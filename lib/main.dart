import 'package:flutter/material.dart';
import 'screens/video_feed_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoFeedScreen(),
    );
  }
}
