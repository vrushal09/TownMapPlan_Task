import '../models/photo_data.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';

// Contract for the camera view
abstract class CameraViewContract {
  void showLoading();
  void hideLoading();
  void showError(String message);
  void onPhotoTaken(PhotoData photoData);
}

class CameraPresenter {
  final CameraViewContract view;
  final CameraService cameraService;
  final LocationService locationService;

  CameraPresenter({
    required this.view,
    required this.cameraService,
    required this.locationService,
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
      
      // Create photo data with all info
      final photoData = PhotoData(
        imagePath: imagePath,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      
      view.hideLoading();
      view.onPhotoTaken(photoData);
    } catch (e) {
      view.hideLoading();
      view.showError('Failed to capture photo: ${e.toString()}');
    }
  }

  void dispose() {
    cameraService.dispose();
  }
}
