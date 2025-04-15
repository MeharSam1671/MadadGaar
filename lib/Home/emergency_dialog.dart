import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class EmergencyDialogContent extends StatefulWidget {
  const EmergencyDialogContent({super.key});

  @override
  State<EmergencyDialogContent> createState() => _EmergencyDialogContentState();
}

class _EmergencyDialogContentState extends State<EmergencyDialogContent> {
  File? _imageFile;
  bool _isLoading = false;
  final _textController = TextEditingController();

  // For recording
  final _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Take a photo using the camera
  Future<void> _takePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image')),
        );
      }
    }
  }

  // Submit the image to the API
  Future<void> _submitImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'YOUR_API_ENDPOINT_HERE/upload'), // Replace with your actual API endpoint
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        bool detected = jsonResponse['detected'] ?? false;

        if (!detected) {
          if (mounted) {
            Navigator.pop(context); // Close current dialog
            _showAlternativeInputDialog(context);
          }
        } else {
          // Handle successful detection - perhaps navigate to maps
          if (mounted) {
            Navigator.pop(context);
            _checkAndNavigateToMap(context);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Failed to process image. Please try again or use alternative input')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error submitting image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Please try again')),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show dialog for alternative input methods
  void _showAlternativeInputDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                "Describe Emergency",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Our system was unable to detect any medical emergency in the image. We're very sorry if this is due to system limitations. To continue, please describe the issue via voice or text.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Voice recording controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: _isRecording ? Colors.red : Colors.blue,
                            size: 36,
                          ),
                          onPressed: () {
                            _isRecording
                                ? _stopRecording(setState)
                                : _startRecording(setState);
                          },
                        ),
                        if (_recordingPath != null) ...[
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.blue,
                              size: 36,
                            ),
                            onPressed: () {
                              _isPlaying
                                  ? _pausePlayback(setState)
                                  : _playRecording(setState);
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("OR",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    // Text input
                    TextField(
                      controller: _textController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Describe the emergency here...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitAlternativeInput(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Start voice recording
  Future<void> _startRecording(StateSetter setState) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder
            .start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);

        setState(() {
          _isRecording = true;
          _recordingPath = path;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  // Stop voice recording
  Future<void> _stopRecording(StateSetter setState) async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  // Play recorded audio
  Future<void> _playRecording(StateSetter setState) async {
    if (_recordingPath == null) return;

    try {
      await _audioPlayer.play(DeviceFileSource(_recordingPath!));
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      debugPrint('Error playing recording: $e');
    }
  }

  // Pause audio playback
  Future<void> _pausePlayback(StateSetter setState) async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error pausing playback: $e');
    }
  }

  // Submit either voice or text input
  Future<void> _submitAlternativeInput(BuildContext context) async {
    bool hasInput = _textController.text.isNotEmpty || _recordingPath != null;

    if (!hasInput) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide either voice or text input')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'YOUR_API_ENDPOINT_HERE/submit-emergency'), // Replace with your actual API endpoint
      );

      // Add text if available
      if (_textController.text.isNotEmpty) {
        request.fields['description'] = _textController.text;
      }

      // Add audio file if available
      if (_recordingPath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'audio',
            _recordingPath!,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle successful submission
        if (context.mounted) {
          Navigator.pop(context);
          _checkAndNavigateToMap(context);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit. Please try again')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error submitting: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Please try again')),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Check and navigate to map function - use your existing implementation
  Future<void> _checkAndNavigateToMap(BuildContext context) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    } else {
      if (context.mounted) {
        Navigator.pushNamed(context, "/maps");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First option: Capture image
          _buildOptionCard(
            context,
            title: "Capture Image of Emergency",
            description:
                "Take a photo of the situation to help us understand the emergency",
            icon: Icons.camera_alt,
            onTap: _takePicture,
          ),

          // Show image preview if available
          if (_imageFile != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _imageFile!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retake"),
                  onPressed: _takePicture,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Submit"),
                  onPressed: _isLoading ? null : _submitImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          const Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Second option: Skip to alternative inputs
          _buildOptionCard(
            context,
            title: "Describe Emergency",
            description:
                "Use voice or text to describe the emergency situation",
            icon: Icons.mic,
            onTap: () {
              Navigator.pop(context);
              _showAlternativeInputDialog(context);
            },
          ),

          // Loading indicator
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
