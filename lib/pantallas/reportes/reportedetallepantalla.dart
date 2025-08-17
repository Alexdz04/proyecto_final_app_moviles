//lib/pantallas/reportes/reportedetallepantalla.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class ReporteDetallePantalla extends StatelessWidget {
  final Map<String, dynamic> reporte;

  const ReporteDetallePantalla({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
   
    final fotoBase64 = reporte['foto'] != null ? "data:image/png;base64,${reporte['foto']}" : null;
    final imageBytes = fotoBase64 != null ? base64Decode(fotoBase64.split(',').last) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(reporte['titulo'] ?? 'Detalle del reporte'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reporte['titulo'] ?? 'Sin titulo', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Codigo: ${reporte['codigo'] ?? 'N/A'}', style: const TextStyle(color: Colors.grey)),
                Text('Fecha: ${reporte['fecha'] ?? 'N/A'}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text('Estado: ${reporte['estado'] ?? 'Desconocido'}'),
              backgroundColor: reporte['estado'] == 'Resuelto' ? Colors.green[100] : Colors.yellow[100],
            ),
            const Divider(height: 30),
            const Text('Descripcion:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(reporte['descripcion'] ?? 'Sin descripcion.', style: const TextStyle(fontSize: 16), textAlign: TextAlign.justify),
            const Divider(height: 30),
            const Text('Foto enviada:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(imageBytes, fit: BoxFit.cover, width: double.infinity),
              )
            else
              const Text('No se proporciono fot....'),
            const Divider(height: 30),
            const Text('Comentario del ministerio:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
            
                reporte['comentario_ministerio'] ?? 'Aun no hay comentarios....',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
