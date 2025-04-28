import 'dart:io';
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
  late final TextEditingController priceController;
  late final TextEditingController addonsController;

  // Define your list of categories
  final List<String> categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Beverage',
    'Side Dish',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Soup',
    'Salad',
    'Vegan',
    'Vegetarian',
    'Special',
  ];

  String? selectedCategory;
  late bool isAvailable;
  String? error;
  File? _imageFile;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final options = [
      'Gallery',
      'Camera',
      if (_imageFile != null) 'Remove Photo',
    ];

    final choice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Image Source'),
          children:
              options.map((option) {
                IconData icon;
                if (option == 'Gallery') {
                  icon = Icons.photo_library;
                } else if (option == 'Camera') {
                  icon = Icons.camera_alt;
                } else {
                  icon = Icons.delete;
                }

                return SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, option),
                  child: Row(
                    children: [
                      Icon(icon, color: Theme.of(context).colorScheme.primary),
                      SizedBox(width: 12),
                      Text(option),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );

    if (choice == null) return;

    if (choice == 'Remove Photo') {
      setState(() => _imageFile = null);
      return;
    }

    final source =
        choice == 'Gallery' ? ImageSource.gallery : ImageSource.camera;
    final XFile? image = await picker.pickImage(source: source);

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Image too big (${sizeInMB.toStringAsFixed(2)} MB). Max allowed is 1MB.",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    priceController = TextEditingController();
    addonsController = TextEditingController();
    isAvailable = widget.menuItem?.isavailable ?? true;

    if (widget.menuItem != null) {
      nameController.text = widget.menuItem!.name;
      descController.text = widget.menuItem!.desc;
      selectedCategory = widget.menuItem!.type;
      priceController.text = widget.menuItem!.price.toString();

      // If the existing category is not in our list, add it
      if (selectedCategory != null && !categories.contains(selectedCategory)) {
        categories.add(selectedCategory!);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => error = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null && widget.menuItem?.imageUrl == null) {
      setState(() => error = "Please add a photo");
      return;
    }

    if (selectedCategory == null) {
      setState(() => error = "Please select a category");
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
        } else {
          setState(() {
            _isLoading = false;
            error = "Failed to process image. Please try another one.";
          });
          return;
        }
      }

      // Create/update menu item
      final newMenuItem = MenuItem(
        id: widget.menuItem?.id,
        name: nameController.text.trim(),
        desc: descController.text.trim(),
        price: price,
        type: selectedCategory!, // Use the selected category
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
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.menuItem == null ? "Add Menu Item" : "Edit Menu Item",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSelector(theme),
                const SizedBox(height: 24),
                _buildFormFields(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(theme),
                const SizedBox(height: 16),
                _buildAvailabilitySwitch(theme),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              error!,
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                _buildSubmitButton(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector(ThemeData theme) {
    Widget imageContent;

    if (_imageFile != null) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    } else if (widget.menuItem?.imageUrl != null &&
        widget.menuItem!.imageUrl.isNotEmpty) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.menuItem!.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 40, color: Colors.red),
                    SizedBox(height: 8),
                    Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      imageContent = Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 12),
              Text(
                "Add Item Photo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Tap to select from gallery or camera",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: pickImage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Photo",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          imageContent,
          if (_imageFile != null ||
              (widget.menuItem?.imageUrl != null &&
                  widget.menuItem!.imageUrl.isNotEmpty))
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.edit, size: 16),
                label: Text("Change Photo"),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          label: "Item Name",
          controller: nameController,
          icon: Icons.fastfood,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter item name";
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        _buildTextField(
          label: "Description",
          controller: descController,
          icon: Icons.description,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter item description";
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        _buildTextField(
          label: "Price",
          controller: priceController,
          icon: Icons.attach_money,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter price";
            }
            try {
              final price = double.parse(value);
              if (price <= 0) {
                return "Price must be greater than zero";
              }
            } catch (e) {
              return "Please enter a valid number";
            }
            return null;
          },
        ),
      ],
    );
  }

  // New method for building the category dropdown
  Widget _buildCategoryDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // Remove the default border
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            hint: Text(
              "Select a category",
              style: TextStyle(color: Colors.grey[600]),
            ),
            isExpanded: true,
            items:
                categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select a category";
              }
              return null;
            },
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        SizedBox(height: 8),
        // Option to add a custom category
        GestureDetector(
          onTap: () => _showAddCategoryDialog(theme),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 4),
              Text(
                "Add custom category",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Dialog to add a custom category
  Future<void> _showAddCategoryDialog(ThemeData theme) async {
    final TextEditingController customCategoryController =
        TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Custom Category'),
          content: TextField(
            controller: customCategoryController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newCategory = customCategoryController.text.trim();
                if (newCategory.isNotEmpty &&
                    !categories.contains(newCategory)) {
                  setState(() {
                    categories.add(newCategory);
                    selectedCategory = newCategory;
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildAvailabilitySwitch(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isAvailable ? Icons.check_circle : Icons.cancel,
                color: isAvailable ? Colors.green : Colors.red[300],
              ),
              SizedBox(width: 12),
              Text(
                "Available for Order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Switch(
            value: isAvailable,
            onChanged: (value) => setState(() => isAvailable = value),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleSubmit,
        icon:
            _isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Icon(widget.menuItem == null ? Icons.add : Icons.save),
        label: Text(
          widget.menuItem == null ? "Add to Menu" : "Update Menu Item",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
