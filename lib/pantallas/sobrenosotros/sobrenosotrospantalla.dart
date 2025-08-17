//lib/pantallas/sobrenosotros/sobrenosotrospantalla.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SobreNosotrosPantalla extends StatefulWidget {
  const SobreNosotrosPantalla({super.key});

  @override
  State<SobreNosotrosPantalla> createState() => _SobreNosotrosPantallaState();
}

class _SobreNosotrosPantallaState extends State<SobreNosotrosPantalla> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://youtu.be/-V5SvkZG23w'))
      ..initialize().then((_) {
        setState(() {}); 
      });
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
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          VideoProgressIndicator(_controller, allowScrubbing: true),
                          Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
