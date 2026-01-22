import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;

  Future<void> initialize() async {
    // Get available cameras on device
    _cameras = await availableCameras();
    
    if (_cameras!.isEmpty) {
      throw Exception('No cameras available');
    }
    
    // Use the first camera (usually back camera)
    _controller = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: true, // Enable audio for video recording
    );
    
    await _controller!.initialize();
  }

  CameraController? get controller => _controller;
  bool get isRecording => _isRecording;

  Future<String> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      // Ensure camera is ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Save to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = join(directory.path, 'GPS_Photo_$timestamp.jpg');

      final image = await _controller!.takePicture();
      
      // Save with optimization
      final File imageFile = File(image.path);
      await imageFile.copy(path);
      
      // Clean up temp file
      try {
        await imageFile.delete();
      } catch (_) {}
      
      return path;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  Future<void> startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    if (_isRecording) {
      throw Exception('Already recording');
    }

    try {
      await _controller!.startVideoRecording();
      _isRecording = true;
    } catch (e) {
      throw Exception('Failed to start video recording: $e');
    }
  }

  Future<String> stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    if (!_isRecording) {
      throw Exception('Not recording');
    }

    try {
      final video = await _controller!.stopVideoRecording();
      _isRecording = false;
      
      // Save to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = join(directory.path, 'GPS_Video_$timestamp.mp4');

      // Move video to permanent location
      final File videoFile = File(video.path);
      await videoFile.copy(path);
      
      // Clean up temp file
      try {
        await videoFile.delete();
      } catch (_) {}
      
      return path;
    } catch (e) {
      _isRecording = false;
      throw Exception('Failed to stop video recording: $e');
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
