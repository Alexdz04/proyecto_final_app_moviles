//lib/pantallas/mapareportes/mapareportespantalla.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/reportes/reportedetallepantalla.dart';

class MapaReportesPantalla extends StatefulWidget {
  const MapaReportesPantalla({super.key});

  @override
  State<MapaReportesPantalla> createState() => _MapaReportesPantallaState();
}

class _MapaReportesPantallaState extends State<MapaReportesPantalla> {
  final ApiService _apiService = ApiService();
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  bool _cargando = true;

  static const CameraPosition _posicionInicial = CameraPosition(
    target: LatLng(18.7357, -70.1627),
    zoom: 8,
  );

  @override
  void initState() {
    super.initState();
    _cargarMarcadoresDeReportes();
  }

  Future<void> _cargarMarcadoresDeReportes() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    final reportes = await _apiService.obtenerMisReportes(token);
    if (mounted) {
      setState(() {
        _markers = reportes.map((reporte) {
          
          final lat = (reporte['latitud'] as num?)?.toDouble() ?? 0.0;
          final lon = (reporte['longitud'] as num?)?.toDouble() ?? 0.0;

          return Marker(
            markerId: MarkerId(reporte['codigo'].toString()),
            position: LatLng(lat, lon),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: reporte['titulo'],
              snippet: 'Toca para ver los detalles del reporte!',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReporteDetallePantalla(reporte: reporte),
                  ),
                );
              },
            ),
          );
        }).toSet();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de mis reportes'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _markers.isEmpty
              ? const Center(
                  child: Text('No tienes reportes con ubicacion para mostrar'),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _posicionInicial,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                ),
    );
  }
}
