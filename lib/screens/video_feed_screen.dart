import 'package:flutter/material.dart';
import 'dart:math';
import 'package:myfirst_app/widgets/video_item.dart';

class VideoFeedScreen extends StatefulWidget {
  @override
  _VideoFeedScreenState createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  List<String> videoAssets = [
   'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://www.w3schools.com/html/movie.mp4',
    "https://www.w3schools.com/html/mov_bbb.mp4",
     "https://media.w3.org/2010/05/sintel/trailer.mp4",
    "https://www.w3schools.com/html/mov_bbb.mp4",
  ];

  List<Map<String, dynamic>> videoLikes = [];
  int currentPlayingIndex = -1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    videoLikes = List.generate(videoAssets.length, (index) {
      return {'liked': false, 'likeCount': 0};
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      videoAssets.shuffle(Random());
      isLoading = false;
    });
  }

  void _updateLikeStatus(int index, bool isLiked) {
    setState(() {
      videoLikes[index]['liked'] = isLiked;
      videoLikes[index]['likeCount'] = isLiked
          ? videoLikes[index]['likeCount'] + 1
          : videoLikes[index]['likeCount'] - 1;
    });
  }

  void _onVideoPlay(int index) {
    setState(() {
      if (currentPlayingIndex == index) {
        currentPlayingIndex = -1;
      } else {
        currentPlayingIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Feeds'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          itemCount: isLoading
              ? 1
              : videoAssets
                  .length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: VideoItem(
                videoAsset: videoAssets[index],
                likeCount: videoLikes[index]['likeCount'],
                isLiked: videoLikes[index]['liked'],
                isPlaying: currentPlayingIndex == index,
                onLikeToggle: (bool isLiked) {
                  if (!isLoading) {
                    _updateLikeStatus(index, isLiked);
                  }
                },
                onPlay: () => _onVideoPlay(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
