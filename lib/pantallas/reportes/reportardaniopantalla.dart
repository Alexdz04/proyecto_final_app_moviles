//lib/pantallas/reportes/reportardaniopantalla.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';

class ReportarDanoPantalla extends StatefulWidget {
  const ReportarDanoPantalla({super.key});

  @override
  State<ReportarDanoPantalla> createState() => _ReportarDanoPantallaState();
}

class _ReportarDanoPantallaState extends State<ReportarDanoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _cargando = false;

  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _imagen;
  String? _imagenBase64;
  Position? _posicion;

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
      final bytes = await pickedFile.readAsBytes();
      _imagenBase64 = base64Encode(bytes);
    }
  }

  Future<void> _obtenerUbicacion() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
     
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Los servicios de ubicacion estan desactivados....')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Los permisos de ubicacion fueron denegados....')));
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Los permisos de ubicacion estan permanentemente denegados....')));
      return;
    } 

    setState(() => _cargando = true);
    _posicion = await Geolocator.getCurrentPosition();
    setState(() => _cargando = false);
  }

  Future<void> _enviarReporte() async {
    if (_formKey.currentState!.validate()) {
      if (_imagenBase64 == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes seleccionar una foto!')));
        return;
      }
      if (_posicion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes obtener tu ubicacion!')));
        return;
      }

      setState(() => _cargando = true);
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      
      
      final Map<String, dynamic> datos = {
        'titulo': _tituloController.text,
        'descripcion': _descripcionController.text,
        'foto': _imagenBase64!,
        'latitud': _posicion!.latitude,
        'longitud': _posicion!.longitude,
      };

      final respuesta = await _apiService.enviarReporte(token!, datos);
      setState(() => _cargando = false);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(respuesta['error'] ?? 'Reporte enviado exitosamente!!'),
          backgroundColor: respuesta.containsKey('error') ? Colors.red : Colors.green,
        ),
      );

      if (!respuesta.containsKey('error')) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar daño ambiental'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Titulo del reporte'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripcion detallada'),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              _imagen == null
                  ? const Text('no hay ninguna imagen seleccionada')
                  : Image.file(_imagen!, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _seleccionarImagen,
                icon: const Icon(Icons.photo_camera),
                label: const Text('Seleccionar foto'),
              ),
              const SizedBox(height: 20),
              if (_posicion != null)
                Text('Ubicacion: ${_posicion!.latitude.toStringAsFixed(4)}, ${_posicion!.longitude.toStringAsFixed(4)}'),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _obtenerUbicacion,
                icon: const Icon(Icons.location_on),
                label: const Text('Obtener mi ubicacion actual'),
              ),
              const SizedBox(height: 30),
              _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _enviarReporte,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Enviar reporte!'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
