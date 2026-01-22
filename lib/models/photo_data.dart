enum MediaType { photo, video }

class MediaData {
  final String mediaPath;
  final MediaType mediaType;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  MediaData({
    required this.mediaPath,
    required this.mediaType,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'mediaPath': mediaPath,
      'mediaType': mediaType == MediaType.photo ? 'photo' : 'video',
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
      mediaPath: json['mediaPath'],
      mediaType: json['mediaType'] == 'photo' ? MediaType.photo : MediaType.video,
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  // Format coordinates to 6 decimal places for display
  String get formattedLocation {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
  
  // Generate Google Maps URL for this location
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }
  
  bool get isPhoto => mediaType == MediaType.photo;
  bool get isVideo => mediaType == MediaType.video;
}

// Keep PhotoData as alias for backward compatibility
typedef PhotoData = MediaData;
