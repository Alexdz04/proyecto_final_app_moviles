//lib/pantallas/login/loginpantalla.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:ministerio_medioambienteapkrd/routes/rutas.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key});

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  final _formkey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _cargando = false;

  Future<void> _intentariniciarsesion() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });

      final authprovider = Provider.of<AuthProvider>(context, listen: false);
      final exito = await authprovider.iniciarsesion(
        _correoController.text,
        _contrasenaController.text,
      );

      setState(() {
        _cargando = false;
      });
      
      if (!mounted) return;

      if (exito) {
        Navigator.pushReplacementNamed(context, Rutas.principal);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo o contraseña incorrectos!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.asset(
                      'assets/desarrollador/mifoto.png', 
                      fit: BoxFit.cover, 
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Inicia sesion',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electronico',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ingresa tu correo';
                    }
                    if (!value.contains('@')) {
                      return 'Correo no valido!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _intentariniciarsesion,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Entrar'),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: const Text('Olvidaste tu contraseña?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Rutas.voluntariado);
                  },
                  child: const Text('No tienes cuenta? Registrate como voluntario'),
                ),
                 TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Rutas.principal);
                  },
                  child: const Text('Entra como visitante'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

