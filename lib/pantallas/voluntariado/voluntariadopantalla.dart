//lib/pantallas/voluntariado/voluntariadopantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';

class VoluntariadoPantalla extends StatefulWidget {
  const VoluntariadoPantalla({super.key});

  @override
  State<VoluntariadoPantalla> createState() => _VoluntariadoPantallaState();
}

class _VoluntariadoPantallaState extends State<VoluntariadoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _cargando = false;

  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _telefonoController = TextEditingController();

  Future<void> _enviarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _cargando = true);

      
      final nombreCompleto = _nombreController.text.split(' ');
      final nombre = nombreCompleto.isNotEmpty ? nombreCompleto.first : '';
      final apellido = nombreCompleto.length > 1 ? nombreCompleto.sublist(1).join(' ') : '';

    
      final Map<String, dynamic> datos = {
        'cedula': _cedulaController.text,
        'nombre': nombre,
        'apellido': apellido,
        'correo': _correoController.text,
        'password': _contrasenaController.text,
        'telefono': _telefonoController.text,
      };

      final respuesta = await _apiService.enviarVoluntario(datos);
      setState(() => _cargando = false);

      if (!mounted) return;

    
      final mensaje = respuesta['error'] ?? 'Solicitud enviada exitosamente!! Ahora puedes iniciar sesion';
      final colorFondo = respuesta.containsKey('error') ? Colors.red : Colors.green;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: colorFondo,
        ),
      );

      if (!respuesta.containsKey('error')) {
        _formKey.currentState!.reset();
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unete como voluntario!'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Requisitos para ser voluntario:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('- Ser mayor de 18'),
            const Text('- Tener pasion por el medio ambiente'),
            const Text('- Disponibilidad para participar en actividades'),
            const Text('- Tener compromiso y responsabilidad'),
            const Divider(height: 30),
            const Text('Completa el formulario aqui:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cedulaController,
                    decoration: const InputDecoration(labelText: 'Cedula'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre y apellido'),
                    validator: (v) {
                      if (v!.isEmpty) return 'Campo requerido';
                      if (!v.contains(' ')) return 'Ingresa tu nombre y apellido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: 'Correo electronico'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) return 'Campo requerido';
                      if (!v.contains('@')) return 'Correo no valido!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contrasenaController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: 'Telefono'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 24),
                  _cargando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _enviarSolicitud,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Envia solicitud'),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
