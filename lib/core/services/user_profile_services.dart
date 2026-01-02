import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/models/trader_branch_model.dart';
import 'package:supercycle/core/models/user_profile_model.dart';
import 'package:supercycle/core/routes/end_points.dart';
import 'package:supercycle/core/services/api_endpoints.dart';
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/storage_services.dart';

class UserProfileService {
  // Storage key for user profile
  static const String _profileKey = 'user_profile';
  static const String _branchsKey = 'user_branchs';

  /// Fetch user profile from API and store it in storage
  static Future<UserProfileModel?> fetchAndStoreUserProfile() async {
    try {
      final data = await ApiServices().get(
        endPoint: ApiEndpoints.getProfileInfo,
      );
      final fetchedUser = UserProfileModel.fromJson(data['data']);

      // Store user profile in storage
      await _storeUserProfile(fetchedUser);

      return fetchedUser;
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

  /// Store user profile in secure storage
  static Future<void> _storeUserProfile(UserProfileModel user) async {
    try {
      final userMap = user.toMap();
      await StorageServices.storeData(_profileKey, userMap);
      if (user.branchs.isNotEmpty) {
        await _storeUserBranchs(user.branchs);
      }
    } catch (e) {
      throw Exception('Failed to store user profile: ${e.toString()}');
    }
  }

  static Future<void> _storeUserBranchs(List<TraderBranchModel> branchs) async {
    try {
      final branchsMap = branchs.map((branch) => branch.toMap()).toList();
      await StorageServices.storeData(_branchsKey, branchsMap);
    } catch (e) {
      throw Exception('Failed to store user branchs: ${e.toString()}');
    }
  }

  /// Get user profile from storage
  static Future<UserProfileModel?> getUserProfile() async {
    try {
      final data = await StorageServices.readData<Map<String, dynamic>>(
        _profileKey,
      );

      if (data == null) return null;

      return UserProfileModel.fromMap(data);
    } catch (e) {
      // Return null instead of throwing to avoid breaking the UI
      return null;
    }
  }

  /// Delete user profile from storage
  static Future<void> deleteUserProfile() async {
    await StorageServices.deleteData(_profileKey);
  }

  /// Check if user profile exists in storage
  static Future<bool> hasUserProfile() async {
    return await StorageServices.containsKey(_profileKey);
  }

  /// Navigate to profile with fetching and storing
  static Future<void> navigateToProfile(BuildContext context) async {
    try {
      // Fetch and store user profile
      final fetchedUser = await fetchAndStoreUserProfile();

      if (fetchedUser == null) {
        throw Exception('Failed to fetch user profile');
      }

      final route = switch (fetchedUser.role) {
        'trader_uncontracted' => EndPoints.traderProfileView,
        'representative' => EndPoints.representativeProfileView,
        _ => null,
      };

      if (route != null && context.mounted) {
        GoRouter.of(context).push(route, extra: fetchedUser);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          'Failed to load profile: ${e.toString()}',
        );
      }
    }
  }

  /// Navigate to profile using cached data if available
  static Future<void> navigateToProfileCached(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    try {
      UserProfileModel? fetchedUser;

      // Check if we should use cached data
      if (!forceRefresh && await hasUserProfile()) {
        fetchedUser = await getUserProfile();
      }

      // If no cached data or force refresh, fetch from API
      if (fetchedUser == null || forceRefresh) {
        fetchedUser = await fetchAndStoreUserProfile();
      }

      if (fetchedUser == null) {
        throw Exception('Failed to load user profile');
      }

      final route = switch (fetchedUser.role) {
        'trader_uncontracted' => EndPoints.traderProfileView,
        'trader_contracted' => EndPoints.traderProfileView,
        'representative' => EndPoints.representativeProfileView,
        _ => null,
      };

      if (route != null && context.mounted) {
        GoRouter.of(context).push(route, extra: fetchedUser);
      } else if (context.mounted) {
        CustomSnackBar.showWarning(context, 'Profile type not supported');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          'Failed to load profile: ${e.toString()}',
        );
      }
    }
  }
}
