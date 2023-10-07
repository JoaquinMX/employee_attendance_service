import 'package:employee_attendance/screens/login_screen.dart';
import 'package:employee_attendance/screens/splash_screen.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load env
  await dotenv.load();
  // Initialize supabase
  String supabaseUrl = dotenv.env['SUPABASE_URL']?? "";
  String supabaseKey = dotenv.env['SUPABASE_KEY']?? "";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primary = Colors.blueAccent;
    const textColor = Colors.black;
    const secondaryTextColor = Colors.black54;
    const backgroundColor = Color(0xFFF5F5F5);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DbService()),
        ChangeNotifierProvider(create: (context) => AttendanceService()),
      ],
      child: MaterialApp(
        title: 'Employee Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              primaryContainer: primary,
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
            displayColor: secondaryTextColor,
            bodyColor: textColor,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
