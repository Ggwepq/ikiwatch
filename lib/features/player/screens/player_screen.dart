import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/services/peachify_service.dart';
import '../../../core/theme/app_colors.dart';

class PlayerScreen extends StatefulWidget {
  final int tmdbId;
  final String title;
  final String mediaType; // 'movie' or 'tv'
  final int? season;
  final int? episode;
  final bool isKdrama;

  const PlayerScreen({
    super.key,
    required this.tmdbId,
    required this.title,
    required this.mediaType,
    this.season,
    this.episode,
    this.isKdrama = false,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  InAppWebViewController? webViewController;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _buildUrl() {
    if (widget.mediaType == 'movie') {
      return PeachifyService.instance.buildMovieUrl(widget.tmdbId.toString());
    } else {
      return PeachifyService.instance.buildTvUrl(
        widget.tmdbId.toString(),
        widget.season ?? 1,
        widget.episode ?? 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (!_hasError)
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_buildUrl())),
              initialSettings: InAppWebViewSettings(
                mediaPlaybackRequiresUserGesture: false,
                transparentBackground: true,
                javaScriptEnabled: true,
                allowsInlineMediaPlayback: true,
                supportMultipleWindows: true,
                javaScriptCanOpenWindowsAutomatically: false,
                useShouldOverrideUrlLoading: true,
              ),
              onCreateWindow: (controller, createWindowAction) async {
                // Return true to indicate we handled the window creation
                // Since we don't actually create a window, this blocks the popup!
                return true;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // Block the main frame from being hijacked by ads
                if (navigationAction.isForMainFrame) {
                  final uri = navigationAction.request.url;
                  if (uri != null && !uri.host.contains('peachify.top')) {
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (controller) {
                webViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'peachifyHandler',
                  callback: (args) {
                    if (args.isNotEmpty) {
                      final payload = args[0];
                      if (payload != null && payload['type'] == 'MEDIA_DATA') {
                        final data = payload['data'];
                        if (data != null && data is Map) {
                          final dataMap = Map<String, dynamic>.from(data);
                          
                          // Merge is_kdrama into the specific items
                          for (final key in dataMap.keys) {
                            if (dataMap[key] is Map) {
                              if (key == widget.tmdbId.toString()) {
                                dataMap[key]['is_kdrama'] = widget.isKdrama;
                              } else {
                                final existingProg = PeachifyService.instance.getProgress(key);
                                if (existingProg != null && existingProg['is_kdrama'] != null) {
                                  dataMap[key]['is_kdrama'] = existingProg['is_kdrama'];
                                }
                              }
                            }
                          }
                          
                          // Clean up corrupted keys from previous bug
                          dataMap.removeWhere((key, value) => value is! Map);

                          PeachifyService.instance.saveProgress(dataMap);
                        }
                      }
                    }
                  },
                );
              },
              onLoadStart: (controller, url) {
                if (mounted) setState(() => _loading = true);
              },
              onLoadStop: (controller, url) async {
                // Inject message listener
                await controller.evaluateJavascript(source: """
                  window.addEventListener('message', function(event) {
                    if (event.origin !== 'https://peachify.top') return;
                    window.flutter_inappwebview.callHandler('peachifyHandler', event.data);
                  });
                """);
                if (mounted) setState(() { _loading = false; _hasError = false; });
              },
              onReceivedError: (controller, request, error) {
                if (request.isForMainFrame ?? false) {
                  if (mounted) {
                    setState(() { _loading = false; _hasError = true; });
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
                    Text('Loading player...', style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
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
