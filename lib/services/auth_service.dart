import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final DbService _dbService = DbService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? get currentUser => _supabaseClient.auth.currentUser;

  set setIsLoading(bool value) {
    _isLoading =  value;
    notifyListeners();
  }

  Future registerEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All fields are required");
      }
      final AuthResponse response = await _supabaseClient.auth.signUp(
          email: email, 
          password: password
      );
      await _dbService.insertNewUser(email, response.user!.id);
      Utils.showSnackBar("Successfully registered!", context, color: Colors.green);
      await loginEmployee(email, password, context);
      Navigator.pop(context);

    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future loginEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All fields are required");
      }
      await _supabaseClient.auth.signInWithPassword(
          email: email,
          password: password
      );

      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future signOut() async {
    _dbService.clearData();
    await _supabaseClient.auth.signOut();
    notifyListeners();
  }

  User? get CurrentUser => _supabaseClient.auth.currentUser;
}