import 'dart:developer';
import 'package:chewie/chewie.dart';
import '../../../../../import.dart';

class ProductDescription extends StatefulWidget {
  final ProductDetailsProvider provider;
  const ProductDescription({required this.provider, super.key});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  // VideoPlayerController? _controller; // Disabled - video_player package removed
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  bool _isInitialized = false;
  String? _errorMessage;

  bool isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String? validateUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute) return 'Invalid URL format';
      if (!url.startsWith('http')) return 'URL must start with http/https';
      return null;
    } catch (e) {
      return 'Invalid URL';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final provider =
            Provider.of<ProductDetailsProvider>(context, listen: false);
        final videoUrl = provider.productVideo;
        log("Video URL: $videoUrl"); // Debug log
        if (videoUrl != null && videoUrl.isNotEmpty) {
          initializeVideo(videoUrl);
        }
      },
    );
  }

  void initializeVideo(String? videoUrl) async {
    if (videoUrl == null || videoUrl.isEmpty) {
      setState(() => _errorMessage = 'No video URL provided');
      return;
    }

    log("Attempting to initialize video with URL: $videoUrl");

    // Validate URL
    final validationError = validateUrl(videoUrl);
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    // Dispose existing controllers

    _chewieController?.dispose();

    try {
      if (isYouTubeUrl(videoUrl)) {
        // Handle YouTube videos differently
        String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              showLiveFullscreenButton: true,
            ),
          );
          setState(
            () {
              _isInitialized = true;
              _errorMessage = null;
            },
          );
        } else {
          setState(() => _errorMessage = 'Invalid YouTube URL');
        }
        return;
      }

      // For direct video URLs - Temporarily disabled for Google Play compliance

      // Video player functionality temporarily disabled
      setState(() {
        _isInitialized = false;
        _errorMessage = 'Video player temporarily disabled for compliance';
      });
      return;

      /*
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: false,
        looping: false,
        aspectRatio: _controller!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      );
      */
    } catch (error) {
      log("Error initializing video: $error");
      if (mounted) {
        setState(
          () {
            _errorMessage =
                'Sorry, we couldn\'t load the product video at this time.';
            _isInitialized = false;
          },
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant ProductDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider =
        Provider.of<ProductDetailsProvider>(context, listen: false);
    if (provider.selectedTab == 2 && !_isInitialized) {
      final videoUrl = provider.productVideo;
      if (videoUrl != null && videoUrl.isNotEmpty) {
        initializeVideo(videoUrl);
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Widget _buildVideoSection() {
    // Check if video URL is empty or null first
    final provider =
        Provider.of<ProductDetailsProvider>(context, listen: false);
    final videoUrl = provider.productVideo;

    if (videoUrl == null || videoUrl.isEmpty) {
      return _buildNoVideoAvailable();
    }

    if (_errorMessage != null) {
      return Center(
          child:
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    if (!_isInitialized || _youtubeController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _youtubeController!.play();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cButtonGreen,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _youtubeController!.pause();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cButtonGreen,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.pause, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoVideoAvailable() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated video icon with pulse effect
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween<double>(begin: 0.8, end: 1.2),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.videocam_off,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        // Create a continuous pulse animation
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    CommonTextWidget(
                      title: 'No Video Available',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]!,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      title: 'Product video is not available at the moment',
                      fontSize: 14,
                      color: Colors.grey[500]!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailsProvider>(context);
    final product = provider.productDetails?.data.product;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered and responsive tab row
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isTablet ? screenWidth * 0.7 : screenWidth * 0.9,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // About Product Tab
                    GestureDetector(
                      onTap: () => provider.setSelectedTab(0),
                      child: Container(
                        height: 38,
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.28,
                        ),
                        decoration: BoxDecoration(
                          color: provider.selectedTab == 0
                              ? cButtonGreen
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          border: Border.all(color: cButtonGreen),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: CommonTextWidget(
                              title: 'About Product',
                              fontSize: isTablet ? 15 : 13,
                              fontWeight: FontWeight.w500,
                              color: provider.selectedTab == 0
                                  ? Colors.white
                                  : cButtonGreen,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // What's in box Tab
                    GestureDetector(
                      onTap: () => provider.setSelectedTab(1),
                      child: Container(
                        height: 38,
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.28,
                        ),
                        decoration: BoxDecoration(
                          color: provider.selectedTab == 1
                              ? cButtonGreen
                              : Colors.white,
                          border: Border.all(color: cButtonGreen),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: CommonTextWidget(
                              title: "What's in box",
                              fontSize: isTablet ? 15 : 13,
                              fontWeight: FontWeight.w500,
                              color: provider.selectedTab == 1
                                  ? Colors.white
                                  : cButtonGreen,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Video Tab
                    GestureDetector(
                      onTap: () => provider.setSelectedTab(2),
                      child: Container(
                        height: 38,
                        constraints: BoxConstraints(
                          minWidth: screenWidth * 0.28,
                        ),
                        decoration: BoxDecoration(
                          color: provider.selectedTab == 2
                              ? cButtonGreen
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(color: cButtonGreen),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: CommonTextWidget(
                              title: "Video",
                              fontSize: isTablet ? 15 : 13,
                              fontWeight: FontWeight.w500,
                              color: provider.selectedTab == 2
                                  ? Colors.white
                                  : cButtonGreen,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: provider.selectedTab == 2
                ? _buildVideoSection()
                : Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      maxWidth:
                          isTablet ? screenWidth * 0.8 : screenWidth * 0.95,
                    ),
                    child: CommonTextWidget(
                      title: provider.selectedTab == 0
                          ? product?.shortDescription ?? ''
                          : provider.selectedTab == 1
                              ? provider.whatsIncluded ?? ''
                              : "",
                      textAlign: TextAlign.justify,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
