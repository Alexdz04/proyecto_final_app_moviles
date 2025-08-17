//lib/pantallas/recuperacion/recuperar_paso1_pantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/recuperacion/recuperar_paso2_pantalla.dart';

class RecuperarPaso1Pantalla extends StatefulWidget {
  const RecuperarPaso1Pantalla({super.key});

  @override
  State<RecuperarPaso1Pantalla> createState() => _RecuperarPaso1PantallaState();
}

class _RecuperarPaso1PantallaState extends State<RecuperarPaso1Pantalla> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _apiService = ApiService();
  bool _cargando = false;

  Future<void> _solicitarCodigo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);
      final respuesta = await _apiService.solicitarCodigoRecuperacion(_correoController.text);
      setState(() => _cargando = false);

      if (!mounted) return;

      if (respuesta != null && respuesta.containsKey('codigo')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El codigo se envio a tu correo!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecuperarPaso2Pantalla(correo: _correoController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(respuesta?['error'] ?? 'No se pudo enviar el codigo....'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingresa tu correo electronico para que se te envie un codigo de recuperacion',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo electronico'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _solicitarCodigo,
                      child: const Text('Enviar codigo'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
