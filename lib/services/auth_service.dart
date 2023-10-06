import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

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
      Utils.showSnackBar("Successfully registered!", context, color: Colors.green);
      setIsLoading = false;
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
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
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
    await _supabaseClient.auth.signOut();
    notifyListeners();
  }

  User? get CurrentUser => _supabaseClient.auth.currentUser;
}