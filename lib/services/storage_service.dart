import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/photo_data.dart';

class StorageService {
  
  // Save GPS metadata as JSON file
  Future<void> saveMediaMetadata(MediaData mediaData) async {
    try {
      final metadataPath = '${mediaData.mediaPath}.json';
      final file = File(metadataPath);
      await file.writeAsString(jsonEncode(mediaData.toJson()));
    } catch (e) {
      throw Exception('Failed to save metadata: $e');
    }
  }
  
  // Load GPS metadata from JSON file
  Future<MediaData?> loadMediaMetadata(String mediaPath) async {
    try {
      final metadataPath = '$mediaPath.json';
      final file = File(metadataPath);
      
      if (!await file.exists()) {
        return null;
      }
      
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString);
      return MediaData.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }
  
  Future<List<MediaData>> getAllMedia() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync();
      
      List<MediaData> mediaList = [];
      
      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          
          // Check if it's our media file (skip .json metadata files)
          if ((fileName.startsWith('GPS_Photo_') || fileName.startsWith('GPS_Video_')) && !fileName.endsWith('.json')) {
            try {
              // Try to load metadata from JSON file first
              final metadata = await loadMediaMetadata(file.path);
              
              if (metadata != null) {
                mediaList.add(metadata);
              } else {
                // Fallback for old files without metadata
                final timestampStr = fileName
                    .replaceAll('GPS_Photo_', '')
                    .replaceAll('GPS_Video_', '')
                    .replaceAll('.jpg', '')
                    .replaceAll('.mp4', '');
                
                final timestamp = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(timestampStr),
                );
                
                final mediaType = fileName.startsWith('GPS_Photo_') 
                    ? MediaType.photo 
                    : MediaType.video;
                
                final media = MediaData(
                  mediaPath: file.path,
                  mediaType: mediaType,
                  latitude: 0.0,
                  longitude: 0.0,
                  timestamp: timestamp,
                );
                
                mediaList.add(media);
              }
            } catch (_) {
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
      // Delete media file
      final file = File(mediaPath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Delete metadata file
      final metadataFile = File('$mediaPath.json');
      if (await metadataFile.exists()) {
        await metadataFile.delete();
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
