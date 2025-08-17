// Archivo: lib/pantallas/inicio/iniciopantalla.dart
import 'package:flutter/material.dart';
// CORREGIDO: Se agrega 'as cs' para crear un prefijo y evitar el conflicto de nombres.
import 'package:carousel_slider/carousel_slider.dart' as cs;

class InicioPantalla extends StatelessWidget {
  const InicioPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sliders = [
      {
        "imagen": "assets/imagenes/slider1.jpg",
        "titulo": "Protege nuestros bosques",
        "subtitulo": "Son el pulmon de nuestro planeta."
      },
      {
        "imagen": "assets/imagenes/slider2.jpg",
        "titulo": "Cuida nuestras playas",
        "subtitulo": "Mantengamos limpias nuestras costas."
      },
      {
        "imagen": "assets/imagenes/slider3.jpg",
        "titulo": "Reciclar es vida",
        "subtitulo": "Reduce, reutiliza y recicla."
      }
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CORREGIDO: Se usa el prefijo 'cs.' para llamar al CarouselSlider del paquete.
            cs.CarouselSlider(
              options: cs.CarouselOptions(
                height: 250.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
              ),
              items: sliders.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              item["imagen"]!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, color: Colors.grey, size: 50);
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["titulo"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                                    ),
                                  ),
                                  Text(
                                    item["subtitulo"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      shadows: [Shadow(blurRadius: 8.0, color: Colors.black)],
                                    ),
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
              }).toList(),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola! Bienvenido a la app del ministerio',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Puedes explorar secciones de la aplicacion para aprender mas sobre como contribuir a la proteccion de nuestro medio ambiente en RD. Como ejemplo, se puede reportar daños o participar como voluntario',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
