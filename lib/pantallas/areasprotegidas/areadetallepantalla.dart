//lib/pantallas/areasprotegidas/areadetallepantalla.dart
import 'package:flutter/material.dart';

class AreaDetallePantalla extends StatelessWidget {
  final Map<String, dynamic> area;

  const AreaDetallePantalla({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(area['nombre'] ?? 'Detalle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'area-imagen-${area['id']}',
              child: Image.network(
                area['imagen'] ?? '',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.park, size: 100, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area['nombre'] ?? 'Sin nombre',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                 
                  Chip(
                    label: Text(area['tipo'] ?? 'Sin tipo'),
                    backgroundColor: Colors.green[100],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    area['descripcion'] ?? 'Sin descripcion.',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  