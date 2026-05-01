import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImageProviderX>();

    return Scaffold(
      appBar: AppBar(title: const Text("Image Picker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SINGLE IMAGE
            if (imageProvider.singleImage != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: FileImage(imageProvider.singleImage!),
                  ),

                  // Loading overlay
                  if (imageProvider.isLoading)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: .center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("Camera"),
                            onTap: () => Navigator.pop(
                              context,
                              imageProvider.pickFromCamera(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: const Text("Gallery"),
                            onTap: () => Navigator.pop(
                              context,
                              imageProvider.pickFromGallery(),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.close),
                            title: const Text("Close"),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
            //
            Divider(),
            SizedBox(height: 20),

            Text("url"),
            ElevatedButton(
              onPressed: imageProvider.uploadSingle,
              child: const Text("Upload Single"),
            ),
            // Text("url"),
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

            // Uploaded URLs
            Expanded(
              child: ListView(
                children: imageProvider.uploadedUrls
                    .map((e) => Text(e))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
