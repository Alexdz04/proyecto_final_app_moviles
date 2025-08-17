//lib/routes/rutas.dart
import 'package:flutter/material.dart';

import 'package:ministerio_medioambienteapkrd/pantallas/inicio/iniciopantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/sobrenosotros/sobrenosotrospantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/servicios/serviciospantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/noticias/noticiaspantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/videos/videospantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/areasprotegidas/areasprotegidaspantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/mapaareas/mapaareaspantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/medidas/medidaspantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/equipo/equipopantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/voluntariado/voluntariadopantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/acercade/acercadepantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/login/loginpantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/normativas/normativaspantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/reportes/reportardaniopantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/reportes/misreportespantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/mapareportes/mapareportespantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/perfil/cambiarcontrasenapantalla.dart';
import 'package:ministerio_medioambienteapkrd/pantallas/principal/principalpantalla.dart';

import 'package:ministerio_medioambienteapkrd/pantallas/recuperacion/recuperar_paso1_pantalla.dart';



class Rutas {
  static const String principal = '/principal';
  static const String inicio = '/inicio';
  static const String sobrenosotros = '/sobrenosotros';
  static const String servicios = '/servicios';
  static const String noticias = '/noticias';
  static const String videos = '/videos';
  static const String areasprotegidas = '/areasprotegidas';
  static const String mapaareas = '/mapaareas';
  static const String medidas = '/medidas';
  static const String equipo = '/equipo';
  static const String voluntariado = '/voluntariado';
  static const String acercade = '/acercade';
  static const String login = '/login';
  static const String normativas = '/normativas';
  static const String reportardano = '/reportardano';
  static const String misreportes = '/misreportes';
  static const String mapareportes = '/mapareportes';
  static const String cambiarcontrasena = '/cambiarcontrasena';

  static const String recuperarPaso1 = '/recuperar_paso1';
  static const String recuperarPaso2 = '/recuperar_paso2';
}

Map<String, WidgetBuilder> obtenerrutas() {
  return {
    Rutas.principal: (context) => const PrincipalPantalla(),
    Rutas.inicio: (context) => const InicioPantalla(),
    Rutas.sobrenosotros: (context) => const SobreNosotrosPantalla(),
    Rutas.servicios: (context) => const ServiciosPantalla(),
    Rutas.noticias: (context) => const NoticiasPantalla(),
    Rutas.videos: (context) => const VideosPantalla(),
    Rutas.areasprotegidas: (context) => const AreasProtegidasPantalla(),
    Rutas.mapaareas: (context) => const MapaAreasPantalla(),
    Rutas.medidas: (context) => const MedidasPantalla(),
    Rutas.equipo: (context) => const EquipoPantalla(),
    Rutas.voluntariado: (context) => const VoluntariadoPantalla(),
    Rutas.acercade: (context) => const AcercaDePantalla(),
    Rutas.login: (context) => const LoginPantalla(),
    Rutas.normativas: (context) => const NormativasPantalla(),
    Rutas.reportardano: (context) => const ReportarDanoPantalla(),
    Rutas.misreportes: (context) => const MisReportesPantalla(),
    Rutas.mapareportes: (context) => const MapaReportesPantalla(),
    Rutas.cambiarcontrasena: (context) => const CambiarContrasenaPantalla(),
 
    Rutas.recuperarPaso1: (context) => const RecuperarPaso1Pantalla(),
  };
}
