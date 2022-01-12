import 'package:flutter/material.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/screens/doctor_home/doctor_home_screen.dart';
import 'package:healmob/screens/login/login_screen.dart';
import 'package:healmob/screens/patient_home/patient_home_screen.dart';
import 'package:healmob/screens/register/register_screen.dart';

void main() {
  runApp(const Healmob());
}

class Healmob extends StatelessWidget {
  const Healmob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
      },
      initialRoute: "/login",
      onGenerateRoute: (settings) {
        if (settings.name == "/patientHome") {
          final Hasta args = settings.arguments as Hasta;
          return MaterialPageRoute(
              builder: (context) => PatientHomeScreen(hasta: args));
        } else if (settings.name == "/doctorHome") {
          final Doktor args = settings.arguments as Doktor;
          return MaterialPageRoute(
              builder: (context) => DoctorHomeScreen(doktor: args));
        }
      },
    );
  }
}
