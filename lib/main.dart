import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/camera_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make app fullscreen for better camera experience
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Map Camera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CameraView(),
    );
  }
}
