import 'package:cloud_billr/models/user_model.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import '../models/result_status.dart';

class UserProvider extends ChangeNotifier{

  Future<ResultStatus> saveProfile(UserModel user) async {
    try {
      await DatabaseHelper.instance.saveUser(user.toMap());
      return ResultStatus(status: true, message: 'Profile updated successfully');
    } catch (e) {
      debugPrint(e.toString());
      return ResultStatus(status: false, message: 'Failed in saving profile.');
    }
  }
}