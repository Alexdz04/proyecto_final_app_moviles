//lib/pantallas/perfil/cambiarcontrasenapantalla.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';

class CambiarContrasenaPantalla extends StatefulWidget {
  const CambiarContrasenaPantalla({super.key});

  @override
  State<CambiarContrasenaPantalla> createState() => _CambiarContrasenaPantallaState();
}

class _CambiarContrasenaPantallaState extends State<CambiarContrasenaPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _cargando = false;

  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _confirmarController = TextEditingController();

  Future<void> _intentarCambiarContrasena() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final Map<String, dynamic> datos = {
        'nombre': authProvider.datosusuario?['nombre'],
        'apellido': authProvider.datosusuario?['apellido'],
        'telefono': authProvider.datosusuario?['telefono'],
        //esta api no documenta como cambiar el password
      };


      final respuesta = await _apiService.cambiarContrasena(token!, datos);
      setState(() => _cargando = false);
      

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(respuesta['error'] ?? 'No se pudo actualizar. La API no soporta cambio de clave....'),
          backgroundColor: respuesta.containsKey('error') ? Colors.red : Colors.green,
        ),
      );

      if (!respuesta.containsKey('error')) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              TextFormField(
                controller: _actualController,
                decoration: const InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nuevaController,
                decoration: const InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
                validator: (v) {
                  if (v!.isEmpty) return 'Campo requerido';
                  if (v.length < 6) return 'Debe tener al menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmarController,
                decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña'),
                obscureText: true,
                validator: (v) {
                  if (v != _nuevaController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _intentarCambiarContrasena,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Actualizar contraseña'),
                    ),
              const SizedBox(height: 10),
              const Text(
                'Ojo, que la API actual solo permite actualizar los datos del perfil pero no la contraseña. Si se llega a implementar esta funcionalidad en la API, ahi si funcionara y se podra cambiar la contra',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
