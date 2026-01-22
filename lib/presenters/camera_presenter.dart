import '../models/photo_data.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

// Contract for the camera view
abstract class CameraViewContract {
  void showLoading();
  void hideLoading();
  void showError(String message);
  void onPhotoTaken(MediaData mediaData);
  void onVideoRecordingStarted();
  void onVideoRecordingStopped(MediaData mediaData);
}

class CameraPresenter {
  final CameraViewContract view;
  final CameraService cameraService;
  final LocationService locationService;
  final StorageService storageService;

  CameraPresenter({
    required this.view,
    required this.cameraService,
    required this.locationService,
    required this.storageService,
  });

  Future<void> initialize() async {
    try {
      view.showLoading();
      
      // Initialize camera first
      await cameraService.initialize();
      
      // Then request location permission
      await locationService.requestPermission();
      
      view.hideLoading();
    } catch (e) {
      view.hideLoading();
      view.showError('Failed to initialize: ${e.toString()}');
    }
  }

  Future<void> capturePhoto() async {
    try {
      view.showLoading();
      
      // Take the picture
      final imagePath = await cameraService.takePicture();
      
      // Get current location
      final position = await locationService.getCurrentLocation();
      
      // Create media data with all info
      final mediaData = MediaData(
        mediaPath: imagePath,
        mediaType: MediaType.photo,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      
      // Save GPS metadata to JSON file
      await storageService.saveMediaMetadata(mediaData);
      
      view.hideLoading();
      view.onPhotoTaken(mediaData);
    } catch (e) {
      view.hideLoading();
      view.showError('Failed to capture photo: ${e.toString()}');
    }
  }

  Future<void> startVideoRecording() async {
    try {
      await cameraService.startVideoRecording();
      view.onVideoRecordingStarted();
    } catch (e) {
      view.showError('Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      view.showLoading();
      
      // Stop recording and get video path
      final videoPath = await cameraService.stopVideoRecording();
      
      // Get current location
      final position = await locationService.getCurrentLocation();
      
      // Create media data with all info
      final mediaData = MediaData(
        mediaPath: videoPath,
        mediaType: MediaType.video,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      
      // Save GPS metadata to JSON file
      await storageService.saveMediaMetadata(mediaData);
      
      view.hideLoading();
      view.onVideoRecordingStopped(mediaData);
    } catch (e) {
      view.hideLoading();
      view.showError('Failed to stop recording: ${e.toString()}');
    }
  }

  Future<List<MediaData>> getAllMedia() async {
    try {
      return await storageService.getAllMedia();
    } catch (e) {
      view.showError('Failed to load media: ${e.toString()}');
      return [];
    }
  }

  void dispose() {
    cameraService.dispose();
  }
}
