class PhotoData {
  final String imagePath;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  PhotoData({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  // Format coordinates to 6 decimal places for display
  String get formattedLocation {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
  
  // Generate Google Maps URL for this location
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }
}
