import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:biotech_maali/import.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _setupAnimations();
    // _listen();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _initializeSpeech() async {
    await Permission.microphone.request();
    await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;

        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
            // _animationController.reset();
            _animationController.stop();
          });

          if (widget.controller.text.isNotEmpty) {
            widget.onSearch(widget.controller.text);
          }
        }
      },
      onError: (error) {
        if (!mounted) return;
        log('Error: $error');
        setState(() {
          _isListening = false;
          _animationController.reset();
          _animationController.stop();
        });
        widget.controller.clear();
        _speech.stop();
      },
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      if (await _speech.initialize()) {
        setState(() {
          _isListening = true;
          Future.delayed(
            const Duration(milliseconds: 5000),
            () {
              _animationController.forward();

              _animationController.reset();
              _animationController.stop();
              setState(() {
                _isListening = false;
              });
            },
          );
        });
        _animationController.repeat(reverse: true);

        await _speech.listen(
          onResult: (result) {
            if (!mounted) return;

            setState(() {
              widget.controller.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
                _animationController.reset();
                _animationController.stop();
                widget.onSearch(widget.controller.text);
              }
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _animationController.reset();
        _animationController.stop();
      });
      await _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening
                    ? Colors.green.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? cButtonGreen : Colors.grey,
                ),
                onPressed: () {
                  widget.controller.clear();
                  _listen();
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: _isListening
                    ? 'Listening...'
                    : 'Search for plants or pots etc...',
                hintStyle: TextStyle(
                  color: _isListening
                      ? cButtonGreen.withOpacity(0.6)
                      : Colors.grey,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  widget.onSearch(value);
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              if (widget.controller.text.isNotEmpty) {
                widget.onSearch(widget.controller.text);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    super.dispose();
  }
}
