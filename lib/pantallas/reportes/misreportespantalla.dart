//lib/pantallas/reportes/misreportespantalla.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/reportes/reportedetallepantalla.dart';

class MisReportesPantalla extends StatefulWidget {
  const MisReportesPantalla({super.key});

  @override
  State<MisReportesPantalla> createState() => _MisReportesPantallaState();
}

class _MisReportesPantallaState extends State<MisReportesPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _reportes;

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      _reportes = _apiService.obtenerMisReportes(token);
    } else {
      _reportes = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reportes'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _reportes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No has realizado ningun reporte....'));
          }

          final reportes = snapshot.data!;
          return ListView.builder(
            itemCount: reportes.length,
            itemBuilder: (context, index) {
              final reporte = reportes[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.history_edu, color: Colors.orange),
                  title: Text(reporte['titulo']),
                  subtitle: Text('Fecha: ${reporte['fecha']}'),
                  trailing: Chip(
                    label: Text(reporte['estado']),
                    backgroundColor: reporte['estado'] == 'Resuelto' ? Colors.green[100] : Colors.yellow[100],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReporteDetallePantalla(reporte: reporte),
                      ),
                    );
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
