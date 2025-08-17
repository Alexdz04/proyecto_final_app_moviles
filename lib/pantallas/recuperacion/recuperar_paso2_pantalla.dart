//lib/pantallas/recuperacion/recuperar_paso2_pantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/routes/rutas.dart';

class RecuperarPaso2Pantalla extends StatefulWidget {
  final String correo;
  const RecuperarPaso2Pantalla({super.key, required this.correo});

  @override
  State<RecuperarPaso2Pantalla> createState() => _RecuperarPaso2PantallaState();
}

class _RecuperarPaso2PantallaState extends State<RecuperarPaso2Pantalla> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _apiService = ApiService();
  bool _cargando = false;

  Future<void> _resetearContrasena() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);
      final respuesta = await _apiService.resetearContrasena(
        widget.correo,
        _codigoController.text,
        _nuevaController.text,
      );
      setState(() => _cargando = false);

      if (!mounted) return;

      if (respuesta != null && !respuesta.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada exitosamente!! Ya puedes iniciar sesion!'),
            backgroundColor: Colors.green,
          ),
        );
   
        Navigator.of(context).popUntil((route) => route.settings.name == Rutas.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(respuesta?['error'] ?? 'No se pudo actualizar la contraseña......'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar codigo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Codigo de recuperacion'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nuevaController,
                decoration: const InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _resetearContrasena,
                      child: const Text('Actualizar contraseña'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
