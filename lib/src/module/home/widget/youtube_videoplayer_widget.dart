import '../../../../import.dart';

class YoutubeVideoplayerWidget extends StatefulWidget {
  const YoutubeVideoplayerWidget({super.key});

  @override
  State<YoutubeVideoplayerWidget> createState() =>
      _YoutubeVideoplayerWidgetState();
}

class _YoutubeVideoplayerWidgetState extends State<YoutubeVideoplayerWidget>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;
  bool _isInitialized = false;
  bool _isBuffering = false;

  @override
  bool get wantKeepAlive => true; // Keep the widget alive for smooth scrolling

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final homeProvider = context.read<HomeProvider>();
      final videoContent = homeProvider.homeScreenVideoContent;

      // Get video URL from content block or use default
      final videoUrl = videoContent?.videoLink ??
          'https://www.youtube.com/watch?v=md63AQAmqVU';

      // Extract video ID from YouTube URL
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);

      _controller = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          // Playback settings
          autoPlay: false,
          mute: false,

          // Quality and performance optimization
          isLive: false,
          forceHD: false, // Auto quality selection based on network

          // Controls and UI
          enableCaption: true,
          hideControls: false,
          controlsVisibleAtStart: true,
          showLiveFullscreenButton: true,

          // Performance optimization flags
          disableDragSeek: false,
          loop: false,

          // Enhanced buffering and playback
          useHybridComposition: true, // Better performance on Android
        ),
      )..addListener(() {
          if (mounted) {
            // Monitor player state for buffering
            final playerState = _controller.value.playerState;
            setState(() {
              _isBuffering = playerState == PlayerState.buffering;
            });
          }
        });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Title Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cButtonGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.play_circle_outline,
                      color: cButtonGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Watch Our Story',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Discover our journey',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video Player Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RepaintBoundary(
                          child: YoutubePlayerBuilder(
                            player: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: cButtonGreen,
                              progressColors: ProgressBarColors(
                                playedColor: cButtonGreen,
                                handleColor: cButtonGreen,
                                backgroundColor: Colors.grey.shade800,
                                bufferedColor: Colors.grey.shade700,
                              ),
                              onReady: () {
                                // Video is ready to play
                                // Preload video for smoother playback
                                _controller.load(_controller.initialVideoId);
                              },
                              onEnded: (metadata) {
                                // Video ended, can add logic here
                              },
                              bottomActions: [
                                CurrentPosition(),
                                const SizedBox(width: 10),
                                ProgressBar(
                                  isExpanded: true,
                                  colors: ProgressBarColors(
                                    playedColor: cButtonGreen,
                                    handleColor: cButtonGreen,
                                    backgroundColor: Colors.grey.shade800,
                                    bufferedColor: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                RemainingDuration(),
                                FullScreenButton(),
                              ],
                            ),
                            builder: (context, player) {
                              return player;
                            },
                          ),
                        ),
                        // Buffering indicator
                        if (_isBuffering)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        cButtonGreen),
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Loading video...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
