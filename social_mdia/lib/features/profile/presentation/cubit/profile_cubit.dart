import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mdia/features/profile/domain/repos/profile_repo.dart';
import 'package:social_mdia/features/profile/presentation/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // update both bio and imageUrl
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? newProfileImageUrl,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }
      // profile picture update

      // update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
      );

      // update in repo
      await profileRepo.updateProfile(updatedProfile);

      // re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile:$e"));
    }
  }
}
