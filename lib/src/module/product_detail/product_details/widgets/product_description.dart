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
  VideoPlayerController? _controller;
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
    _controller?.dispose();
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

      // For direct video URLs
      _controller = VideoPlayerController.network(videoUrl);
      await _controller!.initialize();

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

      if (mounted) {
        setState(() {
          _errorMessage = null;
          _isInitialized = true;
        });
      }
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
    _controller?.dispose();
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Widget _buildVideoSection() {
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailsProvider>(context);
    final product = provider.productDetails?.data.product;

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => provider.setSelectedTab(0),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: provider.selectedTab == 0
                          ? cButtonGreen
                          : Colors.white,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(5)),
                      border: Border.all(color: cButtonGreen),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonTextWidget(
                          title: 'About Product',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: provider.selectedTab == 0
                              ? Colors.white
                              : cButtonGreen,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.setSelectedTab(1),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: provider.selectedTab == 1
                          ? cButtonGreen
                          : Colors.white,
                      border: Border.all(color: cButtonGreen),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonTextWidget(
                          title: "What's in box",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: provider.selectedTab == 1
                              ? Colors.white
                              : cButtonGreen,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.setSelectedTab(2),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: provider.selectedTab == 2
                          ? cButtonGreen
                          : Colors.white,
                      border: Border.all(color: cButtonGreen),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonTextWidget(
                          title: "Video",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: provider.selectedTab == 2
                              ? Colors.white
                              : cButtonGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: provider.selectedTab == 2
                ? _buildVideoSection()
                : CommonTextWidget(
                    title: provider.selectedTab == 0
                        ? product?.shortDescription ?? ''
                        : provider.selectedTab == 1
                            ? provider.whatsIncluded ?? ''
                            : "",
                    textAlign: TextAlign.justify,
                  ),
          ),
        ],
      ),
    );
  }
}
