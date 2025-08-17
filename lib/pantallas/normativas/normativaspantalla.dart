//lib/pantallas/normativas/normativaspantalla.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NormativasPantalla extends StatefulWidget {
  const NormativasPantalla({super.key});

  @override
  State<NormativasPantalla> createState() => _NormativasPantallaState();
}

class _NormativasPantallaState extends State<NormativasPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _normativas;

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      _normativas = _apiService.obtenerNormativas(token);
    } else {
      _normativas = Future.value([]);
    }
  }

  Future<void> _abrirEnlace(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el documento en $url !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normativas ambientales'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _normativas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron normativas....'));
          }

          final normativas = snapshot.data!;
          return ListView.builder(
            itemCount: normativas.length,
            itemBuilder: (context, index) {
              final normativa = normativas[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.gavel, color: Colors.brown),
                  title: Text(normativa['titulo'] ?? 'Sin titulo', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(normativa['descripcion'] ?? 'Sin descripcion'),
                  trailing: const Icon(Icons.download_for_offline),
                  
                  onTap: () => _abrirEnlace(normativa['url_documento']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
