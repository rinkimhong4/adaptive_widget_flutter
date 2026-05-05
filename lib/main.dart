import 'package:adaptive_widgeet/%20graphic_charts/home.dart';
import 'package:adaptive_widgeet/fetch_api_express/api/config/api_service.dart';
import 'package:adaptive_widgeet/fetch_api_express/providers/product_provider.dart';
import 'package:adaptive_widgeet/fetch_api_express/screens/product_screen.dart';
import 'package:adaptive_widgeet/home_screen.dart';
import 'package:adaptive_widgeet/image_picker/providers/image_provider.dart';
import 'package:adaptive_widgeet/image_picker/services/image_picker_service.dart';
import 'package:adaptive_widgeet/image_picker/services/upload_service.dart';
import 'package:adaptive_widgeet/image_picker/ui/image_picker_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  final apiURL = ApiService(baseUrl: 'http://localhost:3000');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageProviderX(
            picker: ImagePickerService(),
            uploader: UploadService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ProductProvider(apiURL)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProductScreen(),
    );
  }
}
