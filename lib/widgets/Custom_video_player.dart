// import 'package:flutter/material.dart';
// import 'package:vaidraj/constants/sizes.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// /// Stateful widget to fetch and then display video content.
// class CustomVideoPlayer extends StatefulWidget {
//   final String videoUrl; // The URL of the video to be played
//   final bool autoPlay; // Option to autoplay the video when loaded
//   final bool loop; // Option to loop the video after it ends
//   final double aspectRatio; // Aspect ratio of the video

//   CustomVideoPlayer({
//     required this.videoUrl,
//     this.autoPlay = false,
//     this.loop = false,
//     this.aspectRatio = 16 / 9,
//   });

//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<CustomVideoPlayer> {
//   late VideoPlayerController _controller;
//   late ChewieController chewieController;
//   bool _isInitialized = false;
//   late ValueNotifier<Duration> videoPositionNotifier;
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..setLooping(widget.loop)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {
//           _isInitialized = true;
//           videoPositionNotifier = ValueNotifier<Duration>(Duration.zero);
//         });
//         if (widget.autoPlay) {
//           _controller.play();
//         }
//       }).catchError((error) {
//         setState(() {
//           _isInitialized = false;
//         });
//         print('Error initializing video player: $error');
//       });
//     chewieController = ChewieController(
//         videoPlayerController: _controller,
//         autoPlay: widget.autoPlay,
//         looping: widget.loop,
//         aspectRatio: widget.aspectRatio);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? ClipRRect(
//             borderRadius: BorderRadius.circular(AppSizes.size10),
//             child: AspectRatio(
//                 aspectRatio: widget.aspectRatio,
//                 child: Chewie(controller: chewieController)),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }

//   /// dispose video controller
//   @override
//   void dispose() {
//     _controller.dispose();
//     chewieController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:vaidraj/constants/color.dart';
import 'package:vaidraj/constants/text_size.dart';
import 'package:vaidraj/utils/method_helper.dart';
import 'package:vaidraj/utils/navigation_helper/navigation_helper.dart';
import 'package:vaidraj/widgets/green_divider.dart';
import 'package:vaidraj/widgets/loader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Stateful widget to fetch and then display video content.
class CustomVideoPlayer extends StatefulWidget {
  CustomVideoPlayer(
      {super.key,
      required this.videoLink,
      required this.heading,
      required this.description});
  final String videoLink;
  final String heading;
  final String description;
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<CustomVideoPlayer> with NavigateHelper {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    loadController();
  }

  Future<void> loadController() async {
    // print("video player is initing with this video Id => ${widget.videoLink}");
    _controller = YoutubePlayerController(
        initialVideoId: widget.videoLink,
        flags: YoutubePlayerFlags(autoPlay: false, mute: false));
    _controller.addListener(() {
      ///=========================================== do jot remove
      // Check for fullscreen state changes
      if (_controller.value.isFullScreen) {
        // When fullscreen is entered, hide the system UI (status bar, etc.)
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      } else {
        // When exiting fullscreen, restore the system UI
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadController(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Loader(),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: SafeArea(
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  bottomActions: [
                    const CurrentPosition(),
                    MethodHelper.widthBox(width: 2.w),
                    const ProgressBar(
                      isExpanded: true,
                    ),
                    const RemainingDuration(),
                    MethodHelper.widthBox(width: 2.w),
                    const FullScreenButton()
                  ],
                ),
                builder: (context, player) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    player,
                    MethodHelper.heightBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                      ),
                      child: Text(
                        widget.heading,
                        style: TextSizeHelper.smallHeaderStyle
                            .copyWith(color: AppColors.brownColor),
                      ),
                    ),
                    GreenDividerLine(endIndent: 5.w, indent: 5.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        widget.description,
                        style: TextSizeHelper.smallTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // If there's an error, you can handle it here
        return const Center(child: Text('Error initializing video player'));
      },
    );
  }

  /// dispose video controller
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
