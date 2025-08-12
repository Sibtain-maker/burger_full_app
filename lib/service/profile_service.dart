import 'dart:io';
import 'package:burger_app_full/Core/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  // Get current user profile
  Future<UserProfileModel?> getCurrentUserProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // Create or update user profile
  Future<UserProfileModel?> upsertProfile(UserProfileModel profile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final profileData = profile.copyWith(
        id: user.id,
        email: user.email ?? profile.email,
        updatedAt: DateTime.now(),
      );

      final response = await supabase
          .from('profiles')
          .upsert(profileData.toJson())
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      print('Error updating profile: $e');
      return null;
    }
  }

  // Upload profile avatar
  Future<String?> uploadAvatar(File imageFile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final fileName = '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}';
      final fileExtension = imageFile.path.split('.').last;
      final filePath = '$fileName.$fileExtension';

      await supabase.storage.from('avatars').upload(filePath, imageFile);

      final avatarUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      return avatarUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  // Delete profile avatar
  Future<bool> deleteAvatar(String avatarUrl) async {
    try {
      final fileName = avatarUrl.split('/').last;
      await supabase.storage.from('avatars').remove([fileName]);
      return true;
    } catch (e) {
      print('Error deleting avatar: $e');
      return false;
    }
  }

  // Update specific profile field
  Future<bool> updateProfileField(String field, dynamic value) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await supabase
          .from('profiles')
          .update({
            field: value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      return true;
    } catch (e) {
      print('Error updating profile field: $e');
      return false;
    }
  }

  // Initialize profile for new user
  Future<UserProfileModel?> initializeProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final now = DateTime.now();
      final initialProfile = UserProfileModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: now,
        updatedAt: now,
      );

      final response = await supabase
          .from('profiles')
          .insert(initialProfile.toJson())
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      print('Error initializing profile: $e');
      return null;
    }
  }

  // Get user's favorite products
  Future<List<String>> getUserFavorites() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('Error fetching favorites: No authenticated user');
        return [];
      }

      print('Fetching favorites for user: ${user.id}');
      
      final response = await supabase
          .from('user_favorites')
          .select('product_id')
          .eq('user_id', user.id);

      final favorites = (response as List).map((item) => item['product_id'] as String).toList();
      print('Found ${favorites.length} favorites: $favorites');
      
      return favorites;
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  // Add product to favorites
  Future<bool> addToFavorites(String productId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('Error adding to favorites: No authenticated user');
        return false;
      }

      print('Adding to favorites - User: ${user.id}, Product: $productId');
      
      await supabase.from('user_favorites').insert({
        'user_id': user.id,
        'product_id': productId,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('Successfully added to favorites: $productId');
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove product from favorites
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('Error removing from favorites: No authenticated user');
        return false;
      }

      print('Removing from favorites - User: ${user.id}, Product: $productId');
      
      await supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', productId);

      print('Successfully removed from favorites: $productId');
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  // Delete user profile (for account deletion)
  Future<bool> deleteProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      // Delete from profiles table
      await supabase.from('profiles').delete().eq('id', user.id);
      
      // Delete from favorites
      await supabase.from('user_favorites').delete().eq('user_id', user.id);

      return true;
    } catch (e) {
      print('Error deleting profile: $e');
      return false;
    }
  }
}