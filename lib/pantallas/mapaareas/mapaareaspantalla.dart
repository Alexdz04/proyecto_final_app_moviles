//lib/pantallas/mapaareas/mapaareaspantalla.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/areasprotegidas/areadetallepantalla.dart';

class MapaAreasPantalla extends StatefulWidget {
  const MapaAreasPantalla({super.key});

  @override
  State<MapaAreasPantalla> createState() => _MapaAreasPantallaState();
}

class _MapaAreasPantallaState extends State<MapaAreasPantalla> {
  final ApiService _apiService = ApiService();
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  static const CameraPosition _posicionInicial = CameraPosition(
    target: LatLng(18.7357, -70.1627),
    zoom: 8,
  );

  @override
  void initState() {
    super.initState();
    _cargarMarcadores();
  }

  Future<void> _cargarMarcadores() async {
    final areas = await _apiService.obtenerAreasProtegidas();
    if (mounted) {
      setState(() {
        _markers = areas.map((area) {
        
          final lat = (area['latitud'] as num).toDouble();
          final lon = (area['longitud'] as num).toDouble();

          return Marker(
            markerId: MarkerId(area['id'].toString()),
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(
              title: area['nombre'],
              snippet: 'Toca para ver detalles',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaDetallePantalla(area: area),
                  ),
                );
              },
            ),
          );
        }).toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de areas protegidas'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _posicionInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
      ),
    );
  }
}
