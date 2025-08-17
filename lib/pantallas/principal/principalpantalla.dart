//lib/pantallas/principal/principalpantalla.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ministerio_medioambienteapkrd/services/auth_provider.dart';
import 'package:ministerio_medioambienteapkrd/routes/rutas.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/inicio/iniciopantalla.dart';

class PrincipalPantalla extends StatefulWidget {
  const PrincipalPantalla({super.key});

  @override
  State<PrincipalPantalla> createState() => _PrincipalPantallaState();
}

class _PrincipalPantallaState extends State<PrincipalPantalla> {
  Widget _pantallaactual = const InicioPantalla();
  String _tituloactual = 'Inicio';

  void _seleccionaropcion(Widget pantalla, String titulo) {
    setState(() {
      _pantallaactual = pantalla;
      _tituloactual = titulo;
    });
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);


    final bool sesioniniciada = authprovider.estainiciadasesion;
    final String nombreusuario = sesioniniciada ? (authprovider.datosusuario?['nombre'] ?? 'Usuario') : 'Visitante';
    final String correousuario = sesioniniciada ? (authprovider.datosusuario?['correo'] ?? '') : 'Inicia sesion para mas opciones!';
    final String inicialusuario = sesioniniciada ? (nombreusuario.isNotEmpty ? nombreusuario[0] : 'U') : 'V';

    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloactual),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(nombreusuario),
              accountEmail: Text(correousuario),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  inicialusuario,
                  style: const TextStyle(fontSize: 40.0, color: Colors.green),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => _seleccionaropcion(const InicioPantalla(), 'Inicio'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre nosotros'),
              onTap: () => Navigator.pushNamed(context, Rutas.sobrenosotros),
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Servicios'),
              onTap: () => Navigator.pushNamed(context, Rutas.servicios),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Noticias ambientales'),
              onTap: () => Navigator.pushNamed(context, Rutas.noticias),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Videos educativos'),
              onTap: () => Navigator.pushNamed(context, Rutas.videos),
            ),
            ListTile(
              leading: const Icon(Icons.park),
              title: const Text('Areas protegidas'),
              onTap: () => Navigator.pushNamed(context, Rutas.areasprotegidas),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Mapa de areas protegidas'),
              onTap: () => Navigator.pushNamed(context, Rutas.mapaareas),
            ),
            ListTile(
              leading: const Icon(Icons.eco),
              title: const Text('Medidas ambientales'),
              onTap: () => Navigator.pushNamed(context, Rutas.medidas),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Equipo del ministerio'),
              onTap: () => Navigator.pushNamed(context, Rutas.equipo),
            ),
            
            const Divider(),

            if (sesioniniciada) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Mi cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.gavel),
                title: const Text('Normativas ambientales'),
                onTap: () => Navigator.pushNamed(context, Rutas.normativas),
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Reportar daño ambiental'),
                onTap: () => Navigator.pushNamed(context, Rutas.reportardano),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Mis reportes'),
                onTap: () => Navigator.pushNamed(context, Rutas.misreportes),
              ),
              ListTile(
                leading: const Icon(Icons.map_outlined),
                title: const Text('Mapa de mis reportes'),
                onTap: () => Navigator.pushNamed(context, Rutas.mapareportes),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Cambiar contraseña'),
                onTap: () => Navigator.pushNamed(context, Rutas.cambiarcontrasena),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesion'),
                onTap: () {
                  authprovider.cerrarsesion();
                  Navigator.pushReplacementNamed(context, Rutas.login);
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.volunteer_activism),
                title: const Text('Ser voluntario'),
                onTap: () => Navigator.pushNamed(context, Rutas.voluntariado),
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar sesion'),
                onTap: () => Navigator.pushReplacementNamed(context, Rutas.login),
              ),
            ],
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: const Text('Acerca de'),
              onTap: () => Navigator.pushNamed(context, Rutas.acercade),
            ),
          ],
        ),
      ),
      body: _pantallaactual,
    );
  }
}
