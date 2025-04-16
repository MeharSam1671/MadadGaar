import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _backendAddress = '192.168.100.51:4000';
  // Remove the text controller here because it was only used for the dialog

  Future<void> _loadBackendAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _backendAddress =
          prefs.getString('backend_addr') ?? '192.168.100.51:4000';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBackendAddress();
  }

  @override
  void dispose() {
    // Nothing extra to dispose now.
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
        Uri.parse('$_backendAddress/image-analysis/analyze'),
      );

      String? mimeType = lookupMimeType(_imageFile!.path);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : null, // Set the content type here
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        bool detected = jsonResponse['detected_medical_emergency'] ?? false;

        if (!detected) {
          // Close current dialog and open alternative input dialog
          if (mounted) {
            Navigator.pop(context);
            _showAlternativeInputDialog(context);
          }
        } else {
          // Handle successful detection (e.g. navigate to maps)
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // This version now shows the alternative input dialog by pushing a new widget
  void _showAlternativeInputDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
        builder: (_) => AlternativeInputDialog(
              backendAddress: _backendAddress,
            )
    );
  }

  // Check and navigate to map function – unchanged
  Future<void> _checkAndNavigateToMap(BuildContext context) async {
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
            GestureDetector(
              onTap: () {
                // Show zoomed image in dialog
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.5,
                          maxScale: 4,
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: 150,
                  ),
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.contain,
                  ),
                ),
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

          // Second option: Alternative input
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

// -------------------------------------------------------------
// Alternative Input Dialog Widget
// This dialog now manages its own text controller (and audio state)
// so its lifecycle is independent and you avoid accessing a controller after disposal.
// -------------------------------------------------------------
class AlternativeInputDialog extends StatefulWidget {
  const AlternativeInputDialog({super.key, required this.backendAddress});
  final String backendAddress;

  @override
  State<AlternativeInputDialog> createState() => _AlternativeInputDialogState();
}

class _AlternativeInputDialogState extends State<AlternativeInputDialog> {
  final TextEditingController _textController = TextEditingController();

  // Audio recording state for the dialog
  final _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Start voice recording
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
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
  Future<void> _stopRecording() async {
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
  Future<void> _playRecording() async {
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
  Future<void> _pausePlayback() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error pausing playback: $e');
    }
  }

  // Submit the alternative input (voice or text)
  Future<void> _submitAlternativeInput() async {
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
        Uri.parse('${widget.backendAddress}/submit-emergency'),
      );
      // Use the text from the dialog's controller
      if (_textController.text.isNotEmpty) {
        request.fields['description'] = _textController.text;
      }
      // Add audio file if available
      if (_recordingPath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('audio', _recordingPath!),
        );
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 && mounted) {
        Navigator.pop(context);
        // Optionally, trigger navigation (e.g. maps) here.
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit. Please try again')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error submitting: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Please try again')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _isRecording ? _stopRecording() : _startRecording();
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
                      _isPlaying ? _pausePlayback() : _playRecording();
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            const Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Text input using the dialog's own TextEditingController
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
          onPressed: _isLoading ? null : _submitAlternativeInput,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
