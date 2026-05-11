import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/services/vidsrc_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
  late WebViewController _controller;
  int _currentApi = VidsrcService.api1;
  bool _loading = true;
  bool _hasError = false;
  int _errorCount = 0;

  @override
  void initState() {
    super.initState();
    // Lock to landscape for better viewing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initWebView();
  }

  @override
  void dispose() {
    // Restore orientations
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _buildUrl() {
    if (widget.mediaType == 'movie') {
      return VidsrcService.movieUrl(
          tmdbId: widget.tmdbId, apiVersion: _currentApi);
    } else {
      return VidsrcService.tvUrl(
        tmdbId: widget.tmdbId,
        season: widget.season ?? 1,
        episode: widget.episode ?? 1,
        apiVersion: _currentApi,
      );
    }
  }

  void _initWebView() {
    final url = _buildUrl();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() => _loading = true);
        },
        onPageFinished: (_) {
          if (mounted) setState(() { _loading = false; _hasError = false; });
        },
        onWebResourceError: (error) {
          if (mounted && (error.isForMainFrame ?? false)) {
            _errorCount++;
            if (_errorCount <= 1) {
              // Try fallback API
              _switchApi();
            } else {
              setState(() { _loading = false; _hasError = true; });
            }
          }
        },
      ))
      ..loadRequest(Uri.parse(url));
  }

  void _switchApi() {
    setState(() {
      _currentApi = VidsrcService.fallbackApi(_currentApi);
      _loading = true;
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse(_buildUrl()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title,
            style: AppTextStyles.labelMedium
                .copyWith(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // API switcher
          PopupMenuButton<int>(
            icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
            color: const Color(0xFF1E1E1E),
            onSelected: (api) {
              if (api != _currentApi) {
                _errorCount = 0;
                setState(() => _currentApi = api);
                _controller.loadRequest(Uri.parse(_buildUrl()));
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
                    const Text('API 1 (Multi Server)',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
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
                    const Text('API 3 (Multi Embeds)',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: _controller),

          // Loading overlay
          if (_loading)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primaryFixed),
                    const SizedBox(height: 16),
                    Text('Loading API $_currentApi...',
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),

          // Error state
          if (_hasError)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white38, size: 48),
                    const SizedBox(height: 16),
                    const Text('Failed to load stream',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Tried API 1 and API 3',
                        style: TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _errorCount = 0;
                        setState(() {
                          _currentApi = VidsrcService.api1;
                          _hasError = false;
                          _loading = true;
                        });
                        _controller.loadRequest(Uri.parse(_buildUrl()));
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
