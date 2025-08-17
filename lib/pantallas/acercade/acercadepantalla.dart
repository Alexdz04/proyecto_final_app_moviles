//lib/pantallas/acercade/acercadepantalla.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaDePantalla extends StatelessWidget {
  const AcercaDePantalla({super.key});

  final String fotoUrl = 'assets/desarrollador/mifoto.png'; 
  final String nombre = 'Jayner Alejandro Diaz Peralta';
  final String matricula = '2023-1037';
  final String telefono = '8093534605'; 
  final String telegramUrl = 'https://t.me/alejandrodiaz04';

  Future<void> _lanzarUrl(String url, {bool esTelefono = false}) async {
    final Uri uri = esTelefono ? Uri(scheme: 'tel', path: url) : Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      
      print('No se pudo lanzar $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca del mi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(fotoUrl),
                onBackgroundImageError: (e, s) {
                  
                },
                child: ClipOval(
                  child: Image.asset(
                    fotoUrl,
                    fit: BoxFit.cover,
                    width: 160,
                    height: 160,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 80);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Matricula: $matricula', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Llamame'),
                subtitle: Text(telefono),
                onTap: () => _lanzarUrl(telefono, esTelefono: true),
              ),
              ListTile(
                leading: const Icon(Icons.telegram, color: Colors.blue),
                title: const Text('Contactame al telegram'),
                onTap: () => _lanzarUrl(telegramUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
