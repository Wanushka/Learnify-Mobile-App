import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;

  const CustomVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false;
  double _currentPosition = 0;
  String _position = "00:00";
  String _duration = "00:00";
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(_videoListener);

    _controller.addListener(() {
      if (_controller.value.isReady && !_isInitialized) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }

    final duration = _controller.metadata.duration;
    final position = _controller.value.position;

    setState(() {
      _currentPosition = position.inSeconds / duration.inSeconds;
      _position = _formatDuration(position);
      _duration = _formatDuration(duration);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              'Failed to load video',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    if (_isInitialized) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.addListener(_videoListener);
              },
            ),
          ),
          _VideoProgressBar(
            position: _position,
            duration: _duration,
            progress: _currentPosition,
            onSeek: (double value) {
              final duration = _controller.metadata.duration;
              final newPosition = value * duration.inSeconds;
              _controller.seekTo(Duration(seconds: newPosition.toInt()));
            },
          ),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _VideoProgressBar extends StatelessWidget {
  final String position;
  final String duration;
  final double progress;
  final Function(double) onSeek;

  const _VideoProgressBar({
    Key? key,
    required this.position,
    required this.duration,
    required this.progress,
    required this.onSeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
            ),
            child: Slider(
              value: progress,
              onChanged: onSeek,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(position),
                Text(duration),
              ],
            ),
          ),
        ],
      ),
    );
  }
}