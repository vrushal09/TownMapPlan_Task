import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/photo_data.dart';

class StorageService {
  
  Future<List<MediaData>> getAllMedia() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync();
      
      List<MediaData> mediaList = [];
      
      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          
          // Check if it's our media file
          if (fileName.startsWith('GPS_Photo_') || fileName.startsWith('GPS_Video_')) {
            try {
              // Extract timestamp from filename
              final timestampStr = fileName
                  .replaceAll('GPS_Photo_', '')
                  .replaceAll('GPS_Video_', '')
                  .replaceAll('.jpg', '')
                  .replaceAll('.mp4', '');
              
              final timestamp = DateTime.fromMillisecondsSinceEpoch(
                int.parse(timestampStr),
              );
              
              // Determine media type
              final mediaType = fileName.startsWith('GPS_Photo_') 
                  ? MediaType.photo 
                  : MediaType.video;
              
              // Create MediaData (location set to 0,0 for existing files without metadata)
              // New captures will have proper GPS data
              final media = MediaData(
                mediaPath: file.path,
                mediaType: mediaType,
                latitude: 0.0,  // Default for backward compatibility
                longitude: 0.0, // Default for backward compatibility
                timestamp: timestamp,
              );
              
              mediaList.add(media);
            } catch (_) {
              // Skip files with invalid format
              continue;
            }
          }
        }
      }
      
      // Sort by timestamp, newest first
      mediaList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return mediaList;
    } catch (e) {
      throw Exception('Failed to load media: $e');
    }
  }
  
  Future<void> deleteMedia(String mediaPath) async {
    try {
      final file = File(mediaPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete media: $e');
    }
  }
  
  Future<int> getMediaCount() async {
    final mediaList = await getAllMedia();
    return mediaList.length;
  }
}
