//lib/pantallas/medidas/medidaspantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';

class MedidasPantalla extends StatefulWidget {
  const MedidasPantalla({super.key});

  @override
  State<MedidasPantalla> createState() => _MedidasPantallaState();
}

class _MedidasPantallaState extends State<MedidasPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _medidas;

  @override
  void initState() {
    super.initState();
    _medidas = _apiService.obtenerMedidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medidas ambientales'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _medidas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron medidas....'));
          }

          final medidas = snapshot.data!;
          return ListView.builder(
            itemCount: medidas.length,
            itemBuilder: (context, index) {
              final medida = medidas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.eco, color: Colors.green),
                  ),
                  title: Text(medida['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        medida['descripcion'],
                        textAlign: TextAlign.justify,
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
