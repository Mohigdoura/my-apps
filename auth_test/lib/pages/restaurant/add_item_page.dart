import 'dart:io';
import 'package:auth_test/components/my_text_field.dart';
import 'package:auth_test/models/menu_item.dart';
import 'package:auth_test/services/provider/menu_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuItemPage extends ConsumerStatefulWidget {
  final MenuItem? menuItem;
  const AddMenuItemPage({super.key, this.menuItem});

  @override
  ConsumerState<AddMenuItemPage> createState() => _MenuItemFormState();
}

class _MenuItemFormState extends ConsumerState<AddMenuItemPage> {
  late final TextEditingController nameController;
  late final TextEditingController descController;
  late final TextEditingController typeController;
  late final TextEditingController priceController;
  late bool isAvailable;
  String? error;
  File? _imageFile;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
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
      final sizeInMB = await compressedFile.length() / (1024 * 1024);
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();
    typeController = TextEditingController();
    priceController = TextEditingController();
    isAvailable = widget.menuItem?.isavailable ?? true;

    if (widget.menuItem != null) {
      nameController.text = widget.menuItem!.name;
      descController.text = widget.menuItem!.desc;
      typeController.text = widget.menuItem!.type;
      priceController.text = widget.menuItem!.price.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    typeController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (nameController.text.isEmpty ||
        descController.text.isEmpty ||
        typeController.text.isEmpty ||
        priceController.text.isEmpty) {
      setState(() => error = "Please fill all fields");
      return;
    }
    if (_imageFile == null && widget.menuItem == null) {
      setState(() => error = "Please add a photo");
      return;
    }

    double price;
    try {
      price = double.parse(priceController.text.trim());
      if (price <= 0) throw FormatException();
    } catch (e) {
      setState(() => error = "Please enter a valid price");
      return;
    }

    setState(() => _isLoading = true);
    final menuItemsNotifier = ref.read(menuItemsProvider.notifier);

    try {
      String? imageUrl;
      if (_imageFile != null) {
        final compressedFile = await compressImage(_imageFile!);
        if (compressedFile != null) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          imageUrl = await menuItemsNotifier.uploadImage(
            fileName,
            compressedFile,
          );
        }
      }
      // Create/update menu item
      final newMenuItem = MenuItem(
        id: widget.menuItem?.id ?? '',
        name: nameController.text.trim(),
        desc: descController.text.trim(),
        price: price,
        type: typeController.text.trim(),
        imageUrl: imageUrl ?? widget.menuItem?.imageUrl ?? '',
        isavailable: isAvailable,
      );

      widget.menuItem == null
          ? await menuItemsNotifier.addMenuItem(newMenuItem)
          : await menuItemsNotifier.updateMenuItem(newMenuItem);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ ${widget.menuItem == null ? 'Added' : 'Updated'} successfully!",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuItem == null ? "Add Menu Item" : "Edit Menu Item",
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildImageColumn(),
            const SizedBox(height: 20),
            MyTextField(labelText: "Name", controller: nameController),
            const SizedBox(height: 16),
            MyTextField(labelText: "Description", controller: descController),
            const SizedBox(height: 16),
            MyTextField(
              labelText: "Price",
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            MyTextField(
              labelText: "Type",
              controller: typeController,
              obscureText: false,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Available:"),
                Switch(
                  value: isAvailable,
                  onChanged: (value) => setState(() => isAvailable = value),
                ),
              ],
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.upload),
                onPressed:
                    _isLoading ||
                            (_imageFile == null && widget.menuItem == null)
                        ? null
                        : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                label:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                          widget.menuItem == null ? "Add Item" : "Update Item",
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageColumn() {
    return Column(
      children: [
        GestureDetector(
          onTap: pickImage,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child:
                _imageFile != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.menuItem == null
                              ? "Add Photo"
                              : "Change Photo",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
          ),
        ),
        if (_imageFile != null)
          TextButton(
            onPressed: () => setState(() => _imageFile = null),
            child: const Text("Remove Photo"),
          ),
      ],
    );
  }
}
