//lib/pantallas/servicios/serviciospantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';

class ServiciosPantalla extends StatefulWidget {
  const ServiciosPantalla({super.key});

  @override
  State<ServiciosPantalla> createState() => _ServiciosPantallaState();
}

class _ServiciosPantallaState extends State<ServiciosPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _servicios;

  @override
  void initState() {
    super.initState();
    _servicios = _apiService.obtenerServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _servicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron servicios.....'));
          }

          final servicios = snapshot.data!;
          return ListView.builder(
            itemCount: servicios.length,
            itemBuilder: (context, index) {
              final servicio = servicios[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.miscellaneous_services, color: Colors.green),
                  ),
                  title: Text(servicio['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(servicio['descripcion']),
                  onTap: () {
                    // se podria navegar a una pantalla de detalle si la api lo permitiera, pero no es asi
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
