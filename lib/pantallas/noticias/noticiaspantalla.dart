// ib/pantallas/noticias/noticiaspantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/noticias/noticiadetallepantalla.dart';

class NoticiasPantalla extends StatefulWidget {
  const NoticiasPantalla({super.key});

  @override
  State<NoticiasPantalla> createState() => _NoticiasPantallaState();
}

class _NoticiasPantallaState extends State<NoticiasPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _noticias;

  @override
  void initState() {
    super.initState();
    _noticias = _apiService.obtenerNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias ambientales'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _noticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron noticias....'));
          }

          final noticias = snapshot.data!;
          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];
              
              final imageUrl = noticia['imagen'];
              final hasImage = imageUrl != null && imageUrl.isNotEmpty;

              return Card(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticiaDetallePantalla(noticia: noticia),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      if (hasImage)
                        Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.newspaper,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noticia['titulo'] ?? 'Sin titulo',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia['fecha'] ?? '',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
