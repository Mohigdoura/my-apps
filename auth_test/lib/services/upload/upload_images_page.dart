import 'dart:io';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadImagesPage extends ConsumerStatefulWidget {
  const UploadImagesPage({super.key});

  @override
  ConsumerState<UploadImagesPage> createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends ConsumerState<UploadImagesPage> {
  File? _imageFile;
  bool _isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<File?> compressImage(File file) async {
    final targetPath =
        '${file.parent.path}/compressed_${file.path.split('/').last}';
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    if (compressedFile != null) {
      final sizeInBytes = await compressedFile.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);
      if (sizeInMB > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Image too big (${sizeInMB.toStringAsFixed(2)} MB). Max allowed is 1MB.",
            ),
          ),
        );
        return null;
      }
      return File(compressedFile.path);
    }
    return null;
  }

  Future<void> uploadImages() async {
    final menuItemProvider = ref.read(menuItemsProvider.notifier);

    if (_imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      if (_imageFile != null) {
        final compressedFile1 = await compressImage(_imageFile!);
        if (compressedFile1 != null) {
          final fileName1 = '${DateTime.now().millisecondsSinceEpoch}_1.jpg';
          await menuItemProvider.uploadImage(fileName1, compressedFile1);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Images uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Upload failed: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Images"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageColumn(_imageFile),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed:
                    _imageFile != null && !_isUploading ? uploadImages : null,
                icon:
                    _isUploading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.upload),
                label: Text(_isUploading ? "Uploading..." : "Upload Images"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageColumn(File? imageFile) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              imageFile != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(imageFile, fit: BoxFit.cover),
                  )
                  : Center(child: Text("📷 Image ")),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => pickImage(),
          icon: const Icon(Icons.photo),
          label: Text("Select Image "),
        ),
      ],
    );
  }
}
