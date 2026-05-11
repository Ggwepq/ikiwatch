import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../core/theme/app_text_styles.dart';

class NativePlayerScreen extends StatefulWidget {
  final String streamUrl;
  final String title;
  final String mediaType;

  const NativePlayerScreen({
    super.key,
    required this.streamUrl,
    required this.title,
    required this.mediaType,
  });

  @override
  State<NativePlayerScreen> createState() => _NativePlayerScreenState();
}

class _NativePlayerScreenState extends State<NativePlayerScreen> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    
    // Initialize player
    player = Player();
    controller = VideoController(player);

    // Enter full screen and hide UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Load video with headers to bypass Vidsrc protections
    player.open(Media(
      widget.streamUrl,
      httpHeaders: {
        'Referer': 'https://vidsrc.wtf/',
        'Origin': 'https://vidsrc.wtf',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      },
    ));
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
      normal: MaterialVideoControlsThemeData(
        displaySeekBar: true,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
        topButtonBar: [
          MaterialCustomButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.title,
              style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      fullscreen: const MaterialVideoControlsThemeData(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Video(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
