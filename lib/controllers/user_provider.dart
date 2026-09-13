import 'dart:io';

import 'package:cloud_billr/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/database_helper.dart';
import '../models/result_status.dart';

class UserProvider extends ChangeNotifier{

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
  
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if(image != null){
      return File(image.path);
    }
    return null;
  }
  

  Future<ResultStatus> saveProfile(UserModel user, String? photoPath) async {
    try {
      await DatabaseHelper.instance.saveUser(user.toMap());
      if(photoPath != null){
        await saveProfilePhoto(userId: user.id, photoPath: photoPath);
      }
      return ResultStatus(status: true, message: 'Profile updated successfully');
    } catch (e) {
      debugPrint(e.toString());
      return ResultStatus(status: false, message: 'Failed in saving profile.');
    }
  }

  Future<UserModel?> loadProfile() async {
    try {
      final result = await DatabaseHelper.instance.loadUser();

      if(result != null){
        final user = UserModel.fromMap(result);
        return user;
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> saveProfilePhoto({
    required String userId,
    required String photoPath,
  }) async {
    try {
      await DatabaseHelper.instance.saveProfilePhoto(
        userId: userId,
        photoPath: photoPath,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> loadProfilePhoto(String userId) async{
    try{
      final result = await DatabaseHelper.instance.loadProfilePhoto(userId: userId);
      return result;
    }catch(e){
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> deleteProfilePhoto(String userId) async{
    try{
      await DatabaseHelper.instance.deleteProfilePhoto(userId: userId);
    }catch(e){
      debugPrint(e.toString());
    }
  }
}