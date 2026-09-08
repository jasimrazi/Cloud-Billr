import 'package:cloud_billr/models/user_model.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import '../models/error_model.dart';

class UserProvider extends ChangeNotifier{

  Future<ErrorModel> saveProfile(UserModel user) async {
    try {
      await DatabaseHelper.instance.saveUser(user.toMap());
      return ErrorModel(status: true, message: 'Profile updated successfully');
    } catch (e) {
      debugPrint(e.toString());
      return ErrorModel(status: false, message: 'Failed in saving profile.');
    }
  }
}