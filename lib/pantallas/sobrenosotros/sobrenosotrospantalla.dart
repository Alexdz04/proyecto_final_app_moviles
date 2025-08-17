//lib/pantallas/sobrenosotros/sobrenosotrospantalla.dart
import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SobreNosotrosPantalla extends StatefulWidget {
  const SobreNosotrosPantalla({super.key});

  @override
  State<SobreNosotrosPantalla> createState() => _SobreNosotrosPantallaState();
}

class _SobreNosotrosPantallaState extends State<SobreNosotrosPantalla> {
  
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    
  
    const videoUrl = 'https://youtu.be/-V5SvkZG23w';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false, 
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre nosotros'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuestra historia',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'El Ministerio de Medio Ambiente y Recursos Naturales de RD fue creado con el proposito de proteger, conservar y restaurar los ecosistemas del pais, promoviendo el desarrollo sostenible y garantizando un ambiente sano para todos. Desde nuestra fundacion, hemos trabajado para enfrentar los desafios ambientales y fomentar una cultura de respeto por la naturaleza.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mision y Vision',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mision: Regular la gestion ambiental y el aprovechamiento sostenible de los recursos naturales, asegurando la participacion ciudadana y promoviendo la educacion para un desarrollo sostenible.\n\nVision: Ser una institucion lider y referente en la gestion ambiental, reconocida por su eficacia, transparencia y compromiso con la proteccion del patrimonio natural de la nacion.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Video institucional',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
