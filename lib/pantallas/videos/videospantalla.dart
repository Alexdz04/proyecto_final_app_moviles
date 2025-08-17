//lib/pantallas/videos/videospantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPantalla extends StatefulWidget {
  const VideosPantalla({super.key});

  @override
  State<VideosPantalla> createState() => _VideosPantallaState();
}

class _VideosPantallaState extends State<VideosPantalla> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = _apiService.obtenerVideos();
  }
  
  Future<void> _abrirVideo(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el video en $url ....')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos educativos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron videos....'));
          }

          final videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              
              final thumbnailUrl = video['thumbnail'];
              final videoUrl = video['url'];

              return Card(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _abrirVideo(videoUrl),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                            Image.network(
                              thumbnailUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
                                );
                              },
                            )
                          else
                            Container(
                              height: 200,
                              color: Colors.grey[800],
                              child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
                            ),
                          const Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
                        ],
                      ),
                      ListTile(
                        title: Text(video['titulo'] ?? 'Sin titulo', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(video['descripcion'] ?? 'Sin descripcion'),
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
