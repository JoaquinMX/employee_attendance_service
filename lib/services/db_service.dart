import 'dart:math';

import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/department.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  UserModel? userModel;
  List<DepartmentModel> allDepartments = [];
  int? employeeDepartment;

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
    userModel = UserModel.fromJson(userData);
    // Just modify the department value if is null
    employeeDepartment == null
      ? employeeDepartment = userModel?.department
      : null;
    return userModel!;
  }

  Future<void> getAllDepartments() async {
    final List result = await _supabaseClient
        .from(Constants.departmentTable)
        .select();
    allDepartments = result.map((department) => DepartmentModel.fromJson(department)).toList();
    notifyListeners();
  }

  Future updateProfile(String name, BuildContext context) async {
    await _supabaseClient
        .from(Constants.employeeTable)
        .update({
          'name': name,
          'department': employeeDepartment
        })
        .eq('id', _supabaseClient.auth.currentUser!.id);

    Utils.showSnackBar("Profile updated succesfully", context, color: Colors.green);
    notifyListeners();
  }

  clearData() {
    userModel = null;
    employeeDepartment = null;
    notifyListeners();
  }
}