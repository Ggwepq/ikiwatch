import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/services/vidsrc_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'native_player_screen.dart';

class PlayerScreen extends StatefulWidget {
  final int tmdbId;
  final String title;
  final String mediaType; // 'movie' or 'tv'
  final int? season;
  final int? episode;

  const PlayerScreen({
    super.key,
    required this.tmdbId,
    required this.title,
    required this.mediaType,
    this.season,
    this.episode,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  InAppWebViewController? webViewController;
  int _currentApi = VidsrcService.api1;
  bool _loading = true;
  bool _hasError = false;
  int _errorCount = 0;
  bool _foundStream = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    if (!_foundStream) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  String _buildUrl() {
    if (widget.mediaType == 'movie') {
      return VidsrcService.movieUrl(tmdbId: widget.tmdbId, apiVersion: _currentApi);
    } else {
      return VidsrcService.tvUrl(
        tmdbId: widget.tmdbId,
        season: widget.season ?? 1,
        episode: widget.episode ?? 1,
        apiVersion: _currentApi,
      );
    }
  }

  void _switchApi() {
    setState(() {
      _currentApi = VidsrcService.fallbackApi(_currentApi);
      _loading = true;
      _hasError = false;
    });
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_buildUrl())));
  }

  void _onStreamFound(String url) {
    if (_foundStream) return;
    _foundStream = true;
    
    // Pause the webview player since we are opening the native one
    webViewController?.evaluateJavascript(source: "document.querySelectorAll('video').forEach(v => v.pause());");

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => NativePlayerScreen(
        streamUrl: url,
        title: widget.title,
        mediaType: widget.mediaType,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
            color: const Color(0xFF1E1E1E),
            onSelected: (api) {
              if (api != _currentApi) {
                _errorCount = 0;
                setState(() => _currentApi = api);
                webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_buildUrl())));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: VidsrcService.api1,
                child: Row(
                  children: [
                    if (_currentApi == VidsrcService.api1)
                      const Icon(Icons.check, color: Colors.green, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('API 1 (Multi Server)', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: VidsrcService.api3,
                child: Row(
                  children: [
                    if (_currentApi == VidsrcService.api3)
                      const Icon(Icons.check, color: Colors.green, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('API 3 (Multi Embeds)', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError)
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_buildUrl())),
              initialSettings: InAppWebViewSettings(
                mediaPlaybackRequiresUserGesture: false,
                useShouldInterceptRequest: true,
                useOnLoadResource: true,
                transparentBackground: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (mounted) setState(() => _loading = true);
              },
              onLoadStop: (controller, url) {
                if (mounted) setState(() { _loading = false; _hasError = false; });
              },
              onLoadResource: (controller, resource) {
                if (resource.url != null && resource.url.toString().contains('.m3u8')) {
                  _onStreamFound(resource.url.toString());
                }
              },
              shouldInterceptRequest: (controller, request) async {
                if (request.url.toString().contains('.m3u8')) {
                  // We can't navigate from here because it's not the main thread, but we can call it.
                  // Wait, actually shouldInterceptRequest might run on a background thread on Android.
                  // We use Future.microtask to ensure it runs on UI thread.
                  Future.microtask(() => _onStreamFound(request.url.toString()));
                }
                return null; // Let the request continue so the web player can play it as a fallback
              },
              onReceivedError: (controller, request, error) {
                if (request.isForMainFrame ?? false) {
                  if (mounted) {
                    _errorCount++;
                    if (_errorCount <= 1) {
                      _switchApi();
                    } else {
                      setState(() { _loading = false; _hasError = true; });
                    }
                  }
                }
              },
            ),

          if (_loading)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primaryFixed),
                    const SizedBox(height: 16),
                    Text('Intercepting native stream...', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),

          if (_hasError)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white38, size: 48),
                    const SizedBox(height: 16),
                    const Text('Failed to load stream', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Tried API 1 and API 3', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _errorCount = 0;
                        setState(() {
                          _currentApi = VidsrcService.api1;
                          _hasError = false;
                          _loading = true;
                        });
                        webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_buildUrl())));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
