import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:muvo/core/config/app_config.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
    required this.videoTitle,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppConfig.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.videoTitle,
          style: AppConfig.bodyStyle.copyWith(
            color: AppConfig.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppConfig.accentColor,
          progressColors: ProgressBarColors(
            playedColor: AppConfig.accentColor,
            handleColor: AppConfig.accentColor,
          ),
        ),
      ),
    );
  }
} 