import 'dart:math';

import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  UserModel? userModel;

  String generateRandomEmployeeId() {
    final random = Random();
    final numbers = List.generate(10, (index) => String.fromCharCode(index+48));
    final alphabet = List.generate(36, (index) => String.fromCharCode(index+65));
    alphabet.addAll(numbers);
    final randomString = List.generate(
      8,
      (index) => alphabet[random.nextInt(alphabet.length)]).join();

    return randomString;
  }
  Future insertNewUser(String email, var id) async {
    await _supabaseClient.from(Constants.employeeTable).insert({
      'id': id,
      'name': '',
      'email': email,
      'employee_id': generateRandomEmployeeId(),
      'department': null,
    });
  }

  Future<UserModel> getUserData() async {
    final userData = await _supabaseClient
        .from(Constants.employeeTable)
        .select()
        .eq("id", _supabaseClient.auth.currentUser!.id).single();
    print("UserData $userData");
    userModel = UserModel.fromJson(userData);
    print("User model $userModel");
    return userModel!;
  }
}