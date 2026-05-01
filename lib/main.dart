import 'package:adaptive_widgeet/api/controller/controller.dart';
import 'package:adaptive_widgeet/home_screen.dart';
import 'package:adaptive_widgeet/image_picker/providers/image_provider.dart';
import 'package:adaptive_widgeet/image_picker/services/image_picker_service.dart';
import 'package:adaptive_widgeet/image_picker/services/upload_service.dart';
import 'package:adaptive_widgeet/image_picker/ui/image_picker_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageProviderX(
            picker: ImagePickerService(),
            uploader: UploadService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => Controller()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ImagePickerScreen(),
    );
  }
}
