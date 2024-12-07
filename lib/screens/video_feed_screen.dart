import 'package:flutter/material.dart';
import 'package:myfirst_app/widgets/video_item.dart';
import 'dart:math';

class VideoFeedScreen extends StatefulWidget {
  @override
  _VideoFeedScreenState createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  List<String> videoAssets = [
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'assets/videos/video_01.mp4',
    'assets/videos/video_02.mp4',
    'assets/videos/video_03.mp4',
    'assets/videos/video_04.mp4',
    'assets/videos/video_05.mp4',
  ];

  List<Map<String, dynamic>> videoLikes = [];
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

    await Future.delayed(Duration(seconds: 2));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Feed'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              itemCount: videoAssets.length,
              itemBuilder: (context, index) {
                if (isLoading && index == 0) {
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
                    onLikeToggle: (bool isLiked) {
                      if (!isLoading) {
                        _updateLikeStatus(index, isLiked);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
