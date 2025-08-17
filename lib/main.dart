//lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:ministerio_medioambienteapkrd/routes/rutas.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/principal/principalpantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/login/loginpantalla.dart';
import 'dart:io'; 


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() {

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Ministerio medio ambiente RD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.green[700],
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authprovider, child) {
            authprovider.cargarsesion();
          
            return authprovider.estainiciadasesion ? const PrincipalPantalla() : const LoginPantalla();
          },
        ),
        routes: obtenerrutas(),
      ),
    );
  }
}
