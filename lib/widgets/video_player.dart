import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReelxVideoPlayer extends StatefulWidget {
  final String path;

  const ReelxVideoPlayer({required this.path, Key? key})
      : assert(path != '', 'Path cannot be empty'),
        super(key: key);

  @override
  State<ReelxVideoPlayer> createState() => ReelxVideoPlayerState();
}

class ReelxVideoPlayerState extends State<ReelxVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          setState(() {}); // Refresh to show the video player
          _videoPlayerController.play();
        });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }
  }

  void share(String path) {
    Share.share(path);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.colorScheme.background;
    final foregroundColor =
        context.theme.textTheme.bodyLarge?.color ?? Colors.white;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            if (_isError)
              const Center(
                child: Text(
                  "Failed to load video.",
                  style: TextStyle(color: Colors.red),
                ),
              )
            else if (_videoPlayerController.value.isInitialized)
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
            Positioned(
              top: 16,
              left: 16,
              child: ClipOval(
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    color: Colors.black54,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () => share(widget.path),
          backgroundColor: backgroundColor,
          child: Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}
