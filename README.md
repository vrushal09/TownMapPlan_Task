# GPS Map Camera 📸🗺️

A Flutter-based GPS camera application that captures photos with embedded location data and timestamps. Built with MVP architecture for clean, maintainable code.

## Features ✨

- 📷 **Camera Integration** - Capture high-quality photos using device camera
- 🌍 **GPS Tagging** - Automatically embed latitude/longitude with each photo
- ⏰ **Timestamp Recording** - Record date, day, and time for every capture
- 🗺️ **Google Maps Integration** - Open photo locations directly in Google Maps
- 🎨 **Modern UI/UX** - Clean, minimal interface with smooth animations
- 🔍 **Zoom Support** - Interactive image viewer with pinch-to-zoom
- ⚡ **Optimized Performance** - Fast loading with image caching

## Screenshots

[Add your app screenshots here]

## Architecture 🏗️

This app follows **MVP (Model-View-Presenter)** architecture pattern:

```
lib/
├── models/              # Data models
├── views/               # UI screens
├── presenters/          # Business logic
├── services/            # Camera & Location services
└── main.dart           # App entry point
```

## Project Structure 📁

### Core Files

**`lib/main.dart`**
- App entry point and initialization
- Sets up fullscreen mode and portrait orientation
- Configures Material theme

**`lib/models/photo_data.dart`**
- Data model for storing photo information
- Contains: image path, GPS coordinates, timestamp
- Provides formatted location and Google Maps URL

### Services Layer

**`lib/services/camera_service.dart`**
- Manages camera initialization and configuration
- Handles photo capture functionality
- Saves images to device storage with unique filenames
- Cleans up temporary files

**`lib/services/location_service.dart`**
- Requests location permissions
- Retrieves current GPS coordinates
- Handles location service errors
- Uses high-accuracy location settings

### Presenter Layer (Business Logic)

**`lib/presenters/camera_presenter.dart`**
- Implements MVP pattern contract
- Coordinates between services and view
- Handles photo capture workflow:
  1. Takes picture via camera service
  2. Gets location via location service
  3. Creates PhotoData with combined info
  4. Notifies view when complete
- Manages loading states and errors

### View Layer (UI)

**`lib/views/camera_view.dart`**
- Main camera screen interface
- Displays live camera preview
- Shows GPS status indicator
- Capture button with haptic feedback
- Loading overlay during processing
- Error handling with retry option

**`lib/views/photo_detail_view.dart`**
- Photo detail screen with full image display
- Interactive zoom support (pinch to zoom)
- Shows formatted date and time
- Displays GPS coordinates
- "Open in Google Maps" button
- Smooth page transitions

## Dependencies 📦

```yaml
camera: ^0.11.0+2              # Camera functionality
geolocator: ^13.0.4            # GPS location services
permission_handler: ^11.4.0    # Runtime permissions
intl: ^0.19.0                  # Date/time formatting
url_launcher: ^6.3.1           # Open Google Maps
path_provider: ^2.1.5          # File system paths
path: ^1.9.1                   # Path manipulation
```

## Permissions 🔐

### Android (AndroidManifest.xml)
- `CAMERA` - Camera access
- `ACCESS_FINE_LOCATION` - GPS location
- `ACCESS_COARSE_LOCATION` - Network location
- `INTERNET` - Google Maps integration

### iOS (Info.plist)
- `NSCameraUsageDescription` - Camera access
- `NSLocationWhenInUseUsageDescription` - Location while using
- `NSLocationAlwaysUsageDescription` - Background location

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)
gi

## How It Works 🔄

1. **App Launch** → Camera and location services initialize
2. **GPS Active** → Green indicator shows location is ready
3. **Capture Photo** → Tap the white circle button
4. **Processing** → Camera captures + GPS coordinates retrieved
5. **View Details** → Photo opens with location and time info
6. **Open Maps** → Tap location card to view in Google Maps

## Code Flow 📊

```
User taps capture button
         ↓
CameraPresenter.capturePhoto()
         ↓
    CameraService.takePicture()
         ↓
    LocationService.getCurrentLocation()
         ↓
    Create PhotoData model
         ↓
    Navigate to PhotoDetailView
         ↓
    Display image + metadata
```

## Key Features Implementation 💡

### GPS Tagging
Uses `geolocator` package with high-accuracy settings to get precise coordinates when photo is captured.

### Image Optimization
- Cached image loading with `cacheWidth` and `cacheHeight`
- Unique filenames using timestamps
- Automatic cleanup of temporary files

### MVP Pattern Benefits
- **Separation of Concerns** - UI, logic, and data are separate
- **Testability** - Business logic can be unit tested
- **Maintainability** - Easy to modify and extend
- **Reusability** - Services can be reused across screens

## Customization 🎨

### Change App Theme
Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.yourColor),
)
```

### Modify GPS Accuracy
Edit `lib/services/location_service.dart`:
```dart
locationSettings: const LocationSettings(
  accuracy: LocationAccuracy.high, // Change to low, medium, etc.
)
```

### Update Camera Resolution
Edit `lib/services/camera_service.dart`:
```dart
ResolutionPreset.high // Change to medium, low, etc.
```

## Troubleshooting 🔧

**Camera not working?**
- Run `flutter clean` then `flutter pub get`
- Rebuild the app completely (not hot reload)

**Location not found?**
- Enable GPS on device
- Grant location permissions
- Check if location services are enabled

**Build errors?**
- Check Flutter version: `flutter --version`
- Update dependencies: `flutter pub upgrade`
- Clear cache: `flutter clean`

## Future Enhancements 🚀

- [ ] Photo gallery to view all captured images
- [ ] Share photos with location data
- [ ] Photo editing capabilities
- [ ] Offline map caching
- [ ] Location history tracking
- [ ] Export photos with metadata
- [ ] Dark/Light theme toggle
- [ ] Multi-language support

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Author ✍️

Designed and Developed by **Vrushal**

Created with ❤️ using Flutter

---

**Built with Flutter 🐦 | MVP Architecture 🏗️ | Clean Code 💎**
