//lib/pantallas/equipo/equipopantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';

class EquipoPantalla extends StatefulWidget {
  const EquipoPantalla({super.key});

  @override
  State<EquipoPantalla> createState() => _EquipoPantallaState();
}

class _EquipoPantallaState extends State<EquipoPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _equipo;

  @override
  void initState() {
    super.initState();
    _equipo = _apiService.obtenerEquipo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo del ministerio'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _equipo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontro el equipo....'));
          }

          final equipo = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: equipo.length,
            itemBuilder: (context, index) {
              final miembro = equipo[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        miembro['foto'],
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            miembro['nombre'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            miembro['cargo'],
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
