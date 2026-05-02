import 'dart:io';

import 'package:adaptive_widgeet/%20graphic_charts/home.dart';
import 'package:adaptive_widgeet/image_picker/helper/helper.dart';
import 'package:adaptive_widgeet/image_picker/ui/btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImageProviderX>();
    bool isIOS = Platform.isIOS;

    return Scaffold(
      appBar: AppBar(title: const Text("Image Picker")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 14,
                children: List.generate(
                  10,
                  (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.category),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Helper.formatText2("All Category"),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              AppTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              AppTextField(
                prefixIcon: const Icon(Icons.abc),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye),
                ),
                label: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // SINGLE IMAGE (same as yours)
              if (imageProvider.singleImage != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: FileImage(imageProvider.singleImage!),
                    ),
                    if (imageProvider.isLoading)
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                )
              else
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 48),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 10,
                      child: Icon(Icons.edit),
                    ),
                  ],
                ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  // keep your existing picker logic
                },
                child: const Text("Pick Image"),
              ),

              const Divider(),

              // MULTIPLE IMAGES
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageProvider.multipleImages.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.file(
                        imageProvider.multipleImages[i],
                        width: 100,
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () => imageProvider.pickMultiple(max: 5),
                child: const Text("Pick Multiple"),
              ),

              const Divider(),
              const SizedBox(height: 20),

              const Text("url"),

              ElevatedButton(
                onPressed: imageProvider.uploadSingle,
                child: const Text("Upload Single"),
              ),

              ElevatedButton(
                onPressed: imageProvider.uploadMultiple,
                child: const Text("Upload Multiple"),
              ),

              if (imageProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),

              const Divider(),

              // ✅ IMPORTANT: remove Expanded, use shrinkWrap ListView
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: imageProvider.uploadedUrls
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
