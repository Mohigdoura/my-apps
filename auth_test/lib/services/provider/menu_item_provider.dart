import 'dart:io';

import 'package:auth_test/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Menu items provider with Supabase integration
class MenuItemsNotifier extends StateNotifier<AsyncValue<List<MenuItem>>> {
  final SupabaseClient _supabaseClient;
  RealtimeChannel? _menuSubscription;

  MenuItemsNotifier(this._supabaseClient) : super(const AsyncValue.loading()) {
    fetchMenuItems();
    _setupMenuStream();
  }

  void _setupMenuStream() {
    _menuSubscription =
        _supabaseClient
            .channel('public:menu')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'menu',
              callback: (payload) {
                // Refresh the list when any change happens
                fetchMenuItems();
              },
            )
            .subscribe();
  }

  @override
  void dispose() {
    // Clean up the subscription when the provider is disposed
    _menuSubscription?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchMenuItems() async {
    try {
      state = const AsyncValue.loading();

      final response = await _supabaseClient
          .from('menu')
          .select()
          .order('created_at', ascending: false);
      print('Supabase response: $response');
      print(
        'First item details: ${response.isNotEmpty ? response[0] : "No items"}',
      );

      final List<MenuItem> menuItems =
          response.map<MenuItem>((item) {
            try {
              return MenuItem.fromJson(item);
            } catch (e, stackTrace) {
              // Log invalid items but continue loading others
              debugPrint('Error parsing menu item: $e\n$stackTrace');
              return MenuItem(
                id: 'invalid-${DateTime.now().millisecondsSinceEpoch}',
                name: 'Invalid Item',
                desc: '',
                price: 0.0,
                type: 'Other',
                imageUrl: '',
                isavailable: false,
              );
            }
          }).toList();
      state = AsyncValue.data(menuItems);
    } catch (error, stackTrace) {
      debugPrint('Fetch error: $error\n$stackTrace');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addMenuItem(MenuItem menuItem) async {
    try {
      await _supabaseClient.from('menu').insert({
        'name': menuItem.name,
        'desc': menuItem.desc,
        'price': menuItem.price,
        'type': menuItem.type,
        'image_url': menuItem.imageUrl,
        'is_available': menuItem.isavailable,
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> updateMenuItem(MenuItem menuItem) async {
    try {
      await _supabaseClient
          .from('menu')
          .update({
            'name': menuItem.name,
            'desc': menuItem.desc,
            'price': menuItem.price,
            'type': menuItem.type,
            'image_url': menuItem.imageUrl,
            'is_available': menuItem.isavailable,
          })
          .eq('id', menuItem.id!);
    } catch (error) {
      throw Exception(error);
    }
  }

  // Remove the publicUrl variable from the class as it's no longer used

  Future<void> deleteMenuItem(MenuItem menuItem) async {
    try {
      // Delete image only if URL exists
      if (menuItem.imageUrl.isNotEmpty) {
        const basePath =
            "https://gdiygxyqegubbghgtyft.supabase.co/storage/v1/object/public/images/"; // Ensure trailing slash

        if (menuItem.imageUrl.startsWith(basePath)) {
          final imagePath = menuItem.imageUrl.substring(basePath.length);
          print("Attempting to delete image at path: $imagePath");

          // Pass the full path as a single string in the list
          final response = await _supabaseClient.storage.from('images').remove([
            imagePath,
          ]);

          print("Storage deletion response: $response");
        } else {
          print("Invalid image URL format: ${menuItem.imageUrl}");
        }
      }

      // Delete from menu table
      await _supabaseClient.from('menu').delete().eq('id', menuItem.id!);
    } catch (error, stackTrace) {
      print("Delete error: $error\n$stackTrace");
      throw Exception("Failed to delete: ${error.toString()}");
    }
  }

  Future<String> uploadImage(String fileName, File compressedFile) async {
    try {
      await _supabaseClient.storage
          .from("images")
          .upload('uploads/$fileName', compressedFile);

      return _supabaseClient.storage
          .from("images")
          .getPublicUrl('uploads/$fileName');
    } catch (e) {
      throw Exception(e);
    }
  }
}

// Provider declarations
final menuItemsProvider =
    StateNotifierProvider<MenuItemsNotifier, AsyncValue<List<MenuItem>>>((ref) {
      final supabaseClient = ref.watch(supabaseClientProvider);
      return MenuItemsNotifier(supabaseClient);
    });

// Provider to filter menu items by type
final filteredMenuItemsProvider =
    Provider.family<AsyncValue<List<MenuItem>>, String>((ref, type) {
      final menuItemsAsyncValue = ref.watch(menuItemsProvider);

      return menuItemsAsyncValue.when(
        data: (menuItems) {
          if (type.isEmpty) return AsyncValue.data(menuItems);
          return AsyncValue.data(
            menuItems.where((item) => item.type == type).toList(),
          );
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      );
    });

final menuItemProvider = Provider.family<AsyncValue<MenuItem?>, String>((
  ref,
  id,
) {
  final menuItemsAsyncValue = ref.watch(menuItemsProvider);

  return menuItemsAsyncValue.when(
    data: (menuItems) {
      final menuItem = menuItems.firstWhere(
        (item) => item.id == id,
        orElse:
            () => MenuItem(
              id: '',
              name: '',
              desc: '',
              price: 0.0,
              type: '',
              imageUrl: '',
              isavailable: false,
            ),
      );
      return AsyncValue.data(menuItem);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});
