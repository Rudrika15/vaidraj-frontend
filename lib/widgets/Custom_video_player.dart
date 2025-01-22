import 'package:flutter/material.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

/// Stateful widget to fetch and then display video content.
class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl; // The URL of the video to be played
  final bool autoPlay; // Option to autoplay the video when loaded
  final bool loop; // Option to loop the video after it ends
  final double aspectRatio; // Aspect ratio of the video

  CustomVideoPlayer({
    required this.videoUrl,
    this.autoPlay = false,
    this.loop = false,
    this.aspectRatio = 16 / 9,
  });

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;
  bool _isInitialized = false;
  late ValueNotifier<Duration> videoPositionNotifier;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(widget.loop)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _isInitialized = true;
          videoPositionNotifier = ValueNotifier<Duration>(Duration.zero);
        });
        if (widget.autoPlay) {
          _controller.play();
        }
      }).catchError((error) {
        setState(() {
          _isInitialized = false;
        });
        print('Error initializing video player: $error');
      });
    chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: widget.autoPlay,
        looping: widget.loop,
        aspectRatio: widget.aspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.size10),
            child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Chewie(controller: chewieController)),
          )
        : const Center(child: CircularProgressIndicator());
  }

  /// dispose video controller
  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
