import 'package:flutter/material.dart';
import 'package:vaidraj/constants/sizes.dart';
import 'package:video_player/video_player.dart';

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
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isBuffering = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(widget.loop)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _isInitialized = true;
        });
        if (widget.autoPlay) {
          _play();
        }
      }).catchError((error) {
        setState(() {
          _isInitialized = false;
        });
        print('Error initializing video player: $error');
      });
    ;
  }

  /// play video
  void _play() {
    if (_controller.value.isInitialized) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  /// pause video
  void _pause() {
    if (_controller.value.isInitialized) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  /// toggle mute volume
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  /// on seeking video
  void _onSeek(double value) {
    final position = Duration(
        seconds: (value * _controller.value.duration.inSeconds).toInt());
    _controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.size10),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  _buildControls(),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  /// building controller
  Widget _buildControls() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isPlaying) ...[
            IconButton(
              icon: Icon(Icons.pause, color: Colors.white),
              onPressed: _pause,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.white),
              onPressed: _play,
            ),
          ],
          Slider(
            value: _controller.value.position.inSeconds.toDouble(),
            min: 0,
            max: _controller.value.duration.inSeconds.toDouble(),
            onChanged: _onSeek,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: _toggleMute,
          ),
        ],
      ),
    );
  }

  /// toggle play pause video
  void _togglePlayPause() {
    if (_isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  /// dispose video controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
