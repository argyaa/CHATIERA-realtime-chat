import 'package:bloc/bloc.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../service/firebase_storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signInWithGoogle() async {
    try {
      emit(AuthLoading());

      UserModel _user = await AuthService().signInWithGoogle();
      late UserModel _currentUser;

      if (await UserService().isUserExist(_user.id.toString())) {
        _currentUser = await UserService().getUserById(_user.id.toString());
        await UserService().updateLastSignInUser(_currentUser);
        emit(AuthSuccess(_currentUser));
      } else {
        await UserService().addUserToFirestore(_user);
        emit(AuthSuccess(_user));
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print("error di cubit");
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> updateProfileUser(String id, String displayName, String status,
      {String imagePath = ""}) async {
    try {
      emit(AuthLoading());
      if (imagePath.isNotEmpty) {
        final String urlImage =
            await FirebaseStorageService().uploadImage(imagePath);

        UserModel user = await UserService()
            .updateProfileUser(id, displayName, status, urlImage);

        emit(AuthSuccess(user));
      } else {
        UserModel user = await UserService()
            .updateProfileUserIfImageIsNull(id, displayName, status);

        emit(AuthSuccess(user));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> getCurrentUser(String id) async {
    try {
      emit(AuthLoading());

      UserModel user = await UserService().getUserById(id);

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await AuthService().logout();
      emit(AuthInitial());
    } catch (e) {
      // ignore: avoid_print
      print(e);
      throw Exception(e);
    }
  }
}
