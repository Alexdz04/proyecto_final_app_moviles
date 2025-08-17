//lib/pantallas/areasprotegidas/areasprotegidaspantalla.dart
import 'package:flutter/material.dart';
import 'package:ministerio_medioambienteapkrd/services/api_service.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/areasprotegidas/areadetallepantalla.dart';

class AreasProtegidasPantalla extends StatefulWidget {
  const AreasProtegidasPantalla({super.key});

  @override
  State<AreasProtegidasPantalla> createState() => _AreasProtegidasPantallaState();
}

class _AreasProtegidasPantallaState extends State<AreasProtegidasPantalla> {
  final ApiService _apiService = ApiService();
  List<dynamic> _areas = [];
  List<dynamic> _areasFiltradas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarAreas();
    _searchController.addListener(_filtrarAreas);
  }

  Future<void> _cargarAreas() async {
    final data = await _apiService.obtenerAreasProtegidas();
    if (mounted) {
      setState(() {
        _areas = data;
        _areasFiltradas = data;
      });
    }
  }

  void _filtrarAreas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _areasFiltradas = _areas.where((area) {
        return (area['nombre'] ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas protegidas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar area protegida',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _areas.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _areasFiltradas.length,
                    itemBuilder: (context, index) {
                      final area = _areasFiltradas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Hero(
                            tag: 'area-imagen-${area['id']}',
                            child: Image.network(
                              area['imagen'] ?? '',
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.park, size: 40),
                            ),
                          ),
                          title: Text(area['nombre'] ?? 'Sin nombre'),
                          
                          subtitle: Text(area['tipo'] ?? 'Sin tipo'),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
