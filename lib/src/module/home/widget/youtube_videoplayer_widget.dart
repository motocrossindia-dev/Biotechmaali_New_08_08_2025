import '../../../../import.dart';

class YoutubeVideoplayerWidget extends StatefulWidget {
  const YoutubeVideoplayerWidget({super.key});

  @override
  State<YoutubeVideoplayerWidget> createState() =>
      _YoutubeVideoplayerWidgetState();
}

class _YoutubeVideoplayerWidgetState extends State<YoutubeVideoplayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Extract video ID from YouTube URL
    final videoId = YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=md63AQAmqVU');

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        showLiveFullscreenButton: true,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: cButtonGreen,
                progressColors: ProgressBarColors(
                  playedColor: cButtonGreen,
                  handleColor: cButtonGreen,
                ),
                onReady: () {
                  setState(() {
                    _isPlaying = true;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Custom controls (optional)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  final currentTime = _controller.value.position.inSeconds;
                  _controller.seekTo(
                    Duration(seconds: currentTime - 10),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  final currentTime = _controller.value.position.inSeconds;
                  _controller.seekTo(
                    Duration(seconds: currentTime + 10),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
