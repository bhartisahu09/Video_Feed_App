import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final String videoAsset;
  final int likeCount;
  final bool isLiked;
  final Function(bool) onLikeToggle;

  VideoItem({
    required this.videoAsset,
    required this.likeCount,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool isVideoInitialized = false;
  bool isVideoEnded = false;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {
          isVideoInitialized = true;
        });
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        setState(() {
          progressValue = _controller.value.position.inMilliseconds /
              _controller.value.duration.inMilliseconds;

          if (_controller.value.position == _controller.value.duration) {
            isVideoEnded = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    widget.onLikeToggle(!widget.isLiked);
  }

  void _playPauseVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _restartVideo() {
    setState(() {
      isVideoEnded = false;
    });
    _controller.seekTo(Duration.zero);
    _controller.play();
  }

  void _seekToPosition(double value) {
    final position = Duration(
      milliseconds: (_controller.value.duration.inMilliseconds * value).toInt(),
    );
    _controller.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            children: [
              if (isVideoInitialized)
                VideoPlayer(_controller)
              else
                Center(child: CircularProgressIndicator()),
              Positioned.fill(
                child: GestureDetector(
                  onTap: _playPauseVideo,
                  child: Center(
                    child: Icon(
                      isVideoEnded
                          ? Icons.replay
                          : (_controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                      size: 80,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text(
                _formatDuration(_controller.value.position),
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Expanded(
                child: Slider(
                  value: progressValue.clamp(0.0, 1.0),
                  onChanged: _seekToPosition,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey[300],
                ),
              ),
              Text(
                _formatDuration(_controller.value.duration),
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Icon(
                      Icons.favorite,
                      color: widget.isLiked ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${widget.likeCount} likes',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }
}
