import '../../../../import.dart';
import 'package:flutter/services.dart';

class YoutubeVideoplayerWidget extends StatefulWidget {
  const YoutubeVideoplayerWidget({super.key});

  @override
  State<YoutubeVideoplayerWidget> createState() =>
      _YoutubeVideoplayerWidgetState();
}

class _YoutubeVideoplayerWidgetState extends State<YoutubeVideoplayerWidget>
    with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool _isInitialized = false;
  bool _isBuffering = false;
  bool _isDisposed = false;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

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
      _videoId = YoutubePlayer.convertUrlToId(videoUrl);

      _controller = YoutubePlayerController(
        initialVideoId: _videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
          hideControls: false,
          controlsVisibleAtStart: true,
          showLiveFullscreenButton: false, // Disable built-in fullscreen
          disableDragSeek: false,
          loop: false,
          useHybridComposition: true,
        ),
      )..addListener(() {
          if (!mounted || _isDisposed) return;
          final playerState = _controller.value.playerState;
          setState(() {
            _isBuffering = playerState == PlayerState.buffering;
          });
        });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    if (_isInitialized) {
      try {
        _controller.pause();
      } catch (_) {
        // Controller may already be disposed by the platform view
      }
      try {
        _controller.dispose();
      } catch (_) {
        // Ignore if already disposed
      }
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed || !mounted) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isInitialized) {
        try {
          if (_controller.value.isPlaying) {
            _controller.pause();
          }
        } catch (_) {
          // Controller may already be disposed
        }
      }
    }
  }

  bool _isWidgetVisible() {
    if (!_isInitialized || _isDisposed || !mounted) return false;

    try {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) return false;

      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      final screenHeight = MediaQuery.of(context).size.height;

      final visibleHeight = size.height;
      final topVisible = position.dy + visibleHeight > 0;
      final bottomVisible = position.dy < screenHeight;

      return topVisible &&
          bottomVisible &&
          (position.dy > -visibleHeight * 0.5 &&
              position.dy < screenHeight - visibleHeight * 0.5);
    } catch (_) {
      // Element may be inactive/disposed during navigation
      return false;
    }
  }

  // Open fullscreen video in portrait mode
  void _openFullscreenVideo() {
    if (_isDisposed || !mounted || !_isInitialized) return;
    // Pause current video
    try {
      _controller.pause();
    } catch (_) {}

    // Open fullscreen dialog
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenVideoPage(videoId: _videoId ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (_isInitialized && !_isDisposed && mounted) {
            try {
              if (_controller.value.isPlaying) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDisposed && !_isWidgetVisible()) {
                    try {
                      _controller.pause();
                    } catch (_) {}
                  }
                });
              }
            } catch (_) {
              // Controller may be disposed
            }
          }
        }
        return false;
      },
      child: RepaintBoundary(
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
                    // Fullscreen button
                    GestureDetector(
                      onTap: _openFullscreenVideo,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cButtonGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fullscreen,
                          color: cButtonGreen,
                          size: 24,
                        ),
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
                            child: YoutubePlayer(
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
                                // Video is ready - DO NOT auto-play
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
                                // Custom fullscreen button
                                GestureDetector(
                                  onTap: _openFullscreenVideo,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}

// Fullscreen video page - Portrait only
class _FullscreenVideoPage extends StatefulWidget {
  final String videoId;

  const _FullscreenVideoPage({required this.videoId});

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
  late YoutubePlayerController _fullscreenController;

  @override
  void initState() {
    super.initState();

    // Hide status bar for fullscreen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _fullscreenController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
        hideControls: false,
        controlsVisibleAtStart: true,
        showLiveFullscreenButton: false,
        disableDragSeek: false,
        loop: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _fullscreenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video player - centered vertically
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: _fullscreenController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: cButtonGreen,
                  progressColors: ProgressBarColors(
                    playedColor: cButtonGreen,
                    handleColor: cButtonGreen,
                    backgroundColor: Colors.grey.shade800,
                    bufferedColor: Colors.grey.shade700,
                  ),
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
                  ],
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
