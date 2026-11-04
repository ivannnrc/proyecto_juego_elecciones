// =====================================================
// NOVA / CONECTA
// JUEGO 2D EN PROCESSING
// CÓDIGO ORGANIZADO POR SECCIONES
// =====================================================

// =====================================================
// 1. IMPORTS Y LIBRERÍAS
// =====================================================

import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

// =====================================================
// 2. CONTROL PS4 - VARIABLES
// =====================================================

ControlIO control;
ControlDevice mando;

ControlSlider joystickX;
ControlSlider joystickY;

ControlButton botonTriangulo;
ControlButton botonCuadrado;
ControlButton botonX;
ControlButton botonL1;
ControlButton botonR1;
ControlButton botonL2;

boolean cuadradoPresionadoAntes = false;
boolean l1PresionadoAntes = false;
boolean r1PresionadoAntes = false;
boolean l2PresionadoAntes = false;
boolean XpresionadoAntes = false;

boolean mandoConectado = false;

// =====================================================
// 3. VARIABLES GENERALES Y NAVEGACIÓN
// =====================================================

int escenario = 1;

final int T_ARBOL = 0;
final int T_CASA = 1;
final int T_BANCA = 2;
final int T_FAROLA = 3;
final int T_FUENTE = 4;
final int T_PERSONA = 5;
final int T_PUESTO = 6;

int mundoW = 2600;
int mundoH = 900;

float camX = 0;
float camY = 0;

ArrayList<float[]> obstaculos = new ArrayList<float[]>();
ArrayList<float[]> objetos = new ArrayList<float[]>();

boolean verColisiones = false;

// =====================================================
// 4. INDICADORES DE LA CIUDAD - VARIABLES
// =====================================================

int informacion = 50;
int convivencia = 50;
int bienestar = 50;
int participacion = 50;
int reputacion = 50;

// =====================================================
// 5. RED SOCIAL CONECTA - VARIABLES
// =====================================================

String[] pubTitulos = {
  "¡Torneo deportivo en el parque del barrio!",
  "¡Fotografía subida sin permiso en el recreo!",
  "URGENTE: Candidato propone cerrar el colegio"
};

int[] pubEscenarios = {1, 2, 3};

String[] pubAutores = {
  "@vecinos_nova",
  "@anonimo_04",
  "@periodico_local"
};

int[] pubConfiabilidad = {85, 30, 45};
int[] pubViralidad = {40, 75, 90};

boolean[] pubProcesadas = {
  false,
  false,
  false
};

boolean redSocialAbierta = false;
// =====================================================
// MINIJUEGO 2 - COLEGIO / CRISIS ELECTORAL EN CONECTA
// =====================================================

// Estado general del minijuego
boolean minijuegoColegioActivo = true;
boolean minijuegoColegioTerminado = false;

// Publicación que el jugador está investigando
// -1 significa que todavía no seleccionó ninguna
int publicacionColegioActual = -1;

// Punto que el jugador debe visitar
int puntoAcopioActual = -1;

// Saber si ya comprobó la situación físicamente
boolean[] publicacionVerificadaColegio = {
  false,
  false,
  false
};

// Saber si cada crisis ya fue resuelta
boolean[] crisisColegioResuelta = {
  false,
  false,
  false
};

// Cantidad de crisis resueltas
int crisisColegioCompletadas = 0;

// =====================================================
// PUNTOS DE ACOPIO DEL COLEGIO
// =====================================================

// 0 = AUDITORIO / BANDERA
// 1 = PATIO / FUENTE
// 2 = CANCHA

float[][] puntosAcopioColegio = {

  {1000, 230},  // Auditorio / bandera

  {450, 420},   // Patio / fuente

  {1500, 380}   // Cancha
};

// Nombres que aparecerán en Conecta
String[] nombresPuntosColegio = {

  "AUDITORIO",

  "PATIO DE LA FUENTE",

  "CANCHA"
};

// =====================================================
// PUBLICACIONES DEL MINIJUEGO
// =====================================================

String[] publicacionesColegio = {

  "VIDEO VIRAL: candidato propone eliminar los apoyos estudiantiles",

  "ENCUESTA: 90% de los estudiantes apoyan una propuesta electoral",

  "URGENTE: suspendieron el foro electoral por disturbios"
};

// Autor de cada publicación
String[] autoresColegio = {

  "@noticias_nova",

  "@encuestas_nova",

  "@alerta_nova"
};

// Viralidad inicial
float[] viralidadColegio = {

  70,

  55,

  45
};

// Relación entre publicación y punto de acopio
// publicación 0 -> auditorio
// publicación 1 -> fuente
// publicación 2 -> cancha

int[] puntoPublicacionColegio = {

  0,

  1,

  2
};

// =====================================================
// MINIJUEGO 3 - DEBATE CIUDADANO EN PLAZA NOVA
// =====================================================

// Estado general del minijuego
boolean minijuegoPlazaActivo = false;
boolean minijuegoPlazaTerminado = false;

// Comentarios sobre el debate ciudadano
String[] comentariosPlaza = {
  "El debate comenzó puntual y todas las candidaturas presentaron sus propuestas.",
  "URGENTE: un candidato abandonó el debate después de ser descubierto mintiendo.",
  "La propuesta de movilidad fue respaldada por organizaciones vecinales.",
  "BOT_NOVA: comparte este mensaje y recibirás un premio por apoyar al candidato.",
  "La periodista Laura confirmó que el foro continuará abierto a preguntas del público.",
  "Miles de personas aseguran que el resultado ya fue decidido, pero nadie presenta pruebas."
};

// Indica si cada comentario fue publicado por un bot
boolean[] respuestaCorrectaPlaza = {
  false,
  true,
  false,
  true,
  false,
  true
};

// Periodista Laura
float npcLauraX = 880;
float npcLauraY = 300;
boolean cercaNpcLaura = false;
boolean dialogoLauraActivo = false;
int dialogoLaura = 0;
boolean cuadradoLauraAntes = false;
boolean l1PlazaAntes = false;
boolean r1PlazaAntes = false;

// Progreso del minijuego
int aciertosPlaza = 0;
int desaciertosPlaza = 0;
int comentarioActualPlaza = -1;

// =====================================================
// 6. JUGADOR - VARIABLES
// =====================================================

float jugadorX = 500;
float jugadorY = 300;

float velocidadJugador = 3;
float animacionCaminar = 0;

boolean moverArriba = false;
boolean moverAbajo = false;
boolean moverIzquierda = false;
boolean moverDerecha = false;

boolean jugadorCaminando = false;

// =====================================================
// 7. MINIJUEGO CARTELES - VARIABLES
// =====================================================

// TIEMPO DEL MINIJUEGO
int tiempoInicioIncendios = 0;
int duracionMinijuego = 30; // segundos

int ultimoSegundoDescontado = 0;

// PUNTUACIÓN DEL MINIJUEGO
int puntosIncendios = 0;
int incendiosApagados = 0;

// Saber cuál incendio está cerca
int incendioCercano = -1;

// Evitar que X se active muchas veces
boolean xIncendioAntes = false;

boolean resultadoCartelesAplicado = false;

// Posición del NPC bombero
float npcBomberoX = 700;
float npcBomberoY = 650;

// Saber si el jugador está cerca
boolean cercaNpcBombero = false;

// Diálogo del bombero
boolean dialogoBomberoActivo = false;
int dialogoBombero = 0;
boolean cuadradoNpcAntes = false;

// Estado del minijuego
boolean minijuegoIncendiosActivo = false;
boolean minijuegoIncendiosTerminado = false;
// INCENDIOS DEL MINIJUEGO
float[][] incendios = {

  {180, 610},
  {340, 780},
  {520, 620},
  {680, 840},

  {760, 660},
  {880, 820},
  {1020, 610},
  {1150, 760},

  {1280, 650},
  {1400, 820},
  {1530, 570},
  {1630, 760},

  {1740, 650},
  {1840, 810},
  {1950, 640},
  {2050, 800},

  {2160, 590},
  {2280, 720},
  {2400, 610},
  {2500, 800},

  {250, 840},
  {1080, 850},
  {1480, 690},
  {2350, 850}
};

boolean[] incendioActivo = {
  true, true, true, true,
  true, true, true, true,
  true, true, true, true,
  true, true, true, true,
  true, true, true, true,
  true, true, true, true
};

// =====================================================
// 8. BUSES - VARIABLES
// =====================================================

float busX = -180;
float busY = 430;

float velocidadBus = 3.0;
float paradaBusX = 1450;

boolean busDetenido = false;
boolean busYaParo = false;

int tiempoBusDetenido = 0;

boolean cercaDelBus = false;

boolean xPresionadoAntes = false;

boolean viajandoEnBus = false;
float oscuridadTransicion = 0;
// =====================================================
// BUS COLEGIO -> PLAZA
// =====================================================

float busPlazaX = -180;
float busPlazaY = 570;

float velocidadBusPlaza = 3;
float paradaBusPlazaX = 1000;

boolean busPlazaDetenido = false;
boolean busPlazaYaParo = false;

int tiempoBusPlazaDetenido = 0;

boolean cercaBusPlaza = false;

boolean viajandoAPlaza = false;
float oscuridadPlaza = 0;

// =====================================================
// 9. SETUP
// =====================================================

void setup() {
  size(1500, 900);

  cargarEscenario(1);

  // ============================
  // CONECTAR MANDO
  // ============================

  control = ControlIO.getInstance(this);

  mando = null;

  for (int i = 0; i < control.getNumberOfDevices(); i++) {

    ControlDevice dispositivo = control.getDevice(i);

    println(i + ": " + dispositivo.getName());

    String nombre = dispositivo.getName().toLowerCase();

    if (
      nombre.contains("wireless controller") ||
      nombre.contains("dualshock") ||
      nombre.contains("ps4") ||
      nombre.contains("xbox") ||
      nombre.contains("xinput")
    ) {

      mando = dispositivo;
      break;
    }
  }

  if (mando != null) {

    println("MANDO ENCONTRADO: " + mando.getName());

    joystickX = mando.getSlider(3);
    joystickY = mando.getSlider(2);

    // BOTONES DEL CONTROL
    botonTriangulo = mando.getButton(4);
    botonCuadrado = mando.getButton(1);
    botonX = mando.getButton(2);

    botonL1 = mando.getButton(5);
    botonR1 = mando.getButton(6);
    botonL2 = mando.getButton(7);

    mandoConectado = true;
  } else {

    println("NO SE ENCONTRO EL MANDO");
    mandoConectado = false;
  }
}

// =====================================================
// 10. DRAW
// =====================================================

void draw() {

  // 1. LEER BOTONES DEL CONTROL PARA CONECTA
  actualizarControlRedSocial();
  revisarInteraccionNpcBombero();
  controlarDialogoBombero();
  revisarInteraccionNpcLaura();
  controlarDialogoLaura();
  revisarIncendioCercano();
  apagarIncendio();
  actualizarMinijuegoIncendios();
  actualizarMinijuegoPlaza();
  actualizarBus();
  actualizarBusPlaza();
  revisarInteraccionBus();
  revisarInteraccionBusPlaza();

  // 2. MOVER JUGADOR
  if (
    !redSocialAbierta &&
    !viajandoEnBus &&
    !viajandoAPlaza
  ) {

    moverJugador();

    revisarCambioEscenario();
  }

  // 3. ACTUALIZAR CÁMARA
  actualizarCamara();

  // 4. DIBUJAR ESCENARIO
  dibujarMundo();

  // 5. HUD E INDICADORES

  mostrarIndicadores();

  // 6. INTERFAZ DE RED SOCIAL
  gestionarRedSocialGUI();
  mostrarMensajeNpcBombero();
  mostrarMensajeIncendio();
  dibujarHUDIncendios();
  dibujarDialogoBombero();
  dibujarDialogoLaura();
  dibujarMinijuegoPlaza();
  actualizarViajeBus();
  actualizarViajePlaza();
  revisarPuntoAcopioColegio();
  comprobarSituacionColegio();

}

// =====================================================
// 11. CONTROL PS4 Y CONECTA
// =====================================================

void actualizarControlRedSocial() {

  if (!mandoConectado) {
    return;
  }

  // TRIANGULO = ABRIR / CERRAR CONECTA
  boolean cuadradoAhora = botonTriangulo.pressed();

  if (cuadradoAhora && !cuadradoPresionadoAntes) {
    redSocialAbierta = !redSocialAbierta;
  }

  cuadradoPresionadoAntes = cuadradoAhora;

  // =====================================================
  // DECISIÓN FINAL DEL MINIJUEGO DEL COLEGIO
  // =====================================================

  if (
    escenario == 2 &&
    minijuegoColegioActivo &&
    publicacionColegioActual != -1 &&
    publicacionVerificadaColegio[publicacionColegioActual]
  ) {

    boolean l1Ahora = botonL1.pressed();
    boolean r1Ahora = botonR1.pressed();
    boolean l2Ahora = botonL2.pressed();

    if (l1Ahora && !l1PresionadoAntes) {
      procesarDecisionColegio(1);
    }

    else if (r1Ahora && !r1PresionadoAntes) {
      procesarDecisionColegio(2);
    }

    else if (l2Ahora && !l2PresionadoAntes) {
      procesarDecisionColegio(3);
    }

    l1PresionadoAntes = l1Ahora;
    r1PresionadoAntes = r1Ahora;
    l2PresionadoAntes = l2Ahora;

    return;
  }
  // L1 / R1 / L2 SOLO CUANDO CONECTA ESTÁ ABIERTA

  if (redSocialAbierta) {
    // =====================================================
    // SELECCIONAR CRISIS DEL COLEGIO
    // =====================================================

    if (
      escenario == 2 &&
      minijuegoColegioActivo &&
      publicacionColegioActual == -1
    ) {

      boolean l1Ahora = botonL1.pressed();
      boolean r1Ahora = botonR1.pressed();
      boolean l2Ahora = botonL2.pressed();

      if (l1Ahora && !l1PresionadoAntes) {

        publicacionColegioActual = 0;

        puntoAcopioActual =
        puntoPublicacionColegio[0];

        redSocialAbierta = false;
      }

      else if (r1Ahora && !r1PresionadoAntes) {

        publicacionColegioActual = 1;

        puntoAcopioActual =
        puntoPublicacionColegio[1];

        redSocialAbierta = false;
      }

      else if (l2Ahora && !l2PresionadoAntes) {

        publicacionColegioActual = 2;

        puntoAcopioActual =
        puntoPublicacionColegio[2];

        redSocialAbierta = false;
      }

      l1PresionadoAntes = l1Ahora;
      r1PresionadoAntes = r1Ahora;
      l2PresionadoAntes = l2Ahora;

      return;
    }

    boolean l1Ahora = botonL1.pressed();
    boolean r1Ahora = botonR1.pressed();
    boolean l2Ahora = botonL2.pressed();

    int idx = obtenerIndicePublicacion(escenario);

    if (idx != -1 && !pubProcesadas[idx]) {

      if (l1Ahora && !l1PresionadoAntes) {
        procesarDecision(idx, 1);
      }

      if (r1Ahora && !r1PresionadoAntes) {
        procesarDecision(idx, 2);
      }

      if (l2Ahora && !l2PresionadoAntes) {
        procesarDecision(idx, 3);
      }
    }

    l1PresionadoAntes = l1Ahora;
    r1PresionadoAntes = r1Ahora;
    l2PresionadoAntes = l2Ahora;

  } else {

    l1PresionadoAntes = false;
    r1PresionadoAntes = false;
    l2PresionadoAntes = false;
  }
}

// =====================================================
// 12. DIBUJAR MUNDO
// =====================================================

void dibujarMundo() {

  noStroke();
  strokeWeight(1);

  pushMatrix();

  translate(-round(camX), -round(camY));

  pushStyle();

  if (escenario == 1) {

    fondoBarrio();
    dibujarBus();
    dibujarNpcBombero();
    dibujarIncendios();

  } else if (escenario == 2) {

    fondoColegio();
    dibujarBusPlaza();
    dibujarPuntosAcopioColegio();

  } else {

    fondoPlaza();
    dibujarNpcLaura();
  }

  popStyle();

  pushStyle();

  dibujarObjetosYJugador();

  if (verColisiones) {
    dibujarColisiones();
  }

  popStyle();

  popMatrix();
}

// =====================================================
// 13. CÁMARA
// =====================================================

void actualizarCamara() {
  camX = constrain(jugadorX - width / 2.0, 0, mundoW - width);
  camY = constrain(jugadorY - height / 2.0, 0, mundoH - height);
}

// =====================================================
// 14. CAMBIO ENTRE ESCENARIOS
// =====================================================

void revisarCambioEscenario() {

  // BARRIO -> COLEGIO
  if (escenario == 1) {

    if (jugadorX > mundoW - 40) {

      cargarEscenario(2);

      jugadorX = 80;
      jugadorY = 500;
    }
  }

  // COLEGIO
  else if (escenario == 2) {

    // COLEGIO -> BARRIO
    if (jugadorX < 40) {

      cargarEscenario(1);

      jugadorX = mundoW - 80;
      jugadorY = 455;
    }

    // COLEGIO -> PLAZA
    else if (jugadorX > mundoW - 40) {

      cargarEscenario(3);

      jugadorX = 80;
      jugadorY = 520;
    }
  }

  // PLAZA -> COLEGIO
  else if (escenario == 3) {

    if (jugadorX < 40) {

      cargarEscenario(2);

      jugadorX = mundoW - 80;
      jugadorY = 500;
    }
  }
}

// =====================================================
// 15. CARGA DE ESCENARIOS Y HELPERS
// =====================================================

void cargarEscenario(int esc) {
  escenario = esc;
  obstaculos.clear();
  objetos.clear();

  if (esc == 1) {
    mundoW = 2600;
    mundoH = 900;
    construirBarrio();
    jugadorX = 1300;
    jugadorY = 455;
  } else if (esc == 2) {
    mundoW = 2000;
    mundoH = 1000;
    construirColegio();
    jugadorX = 1000;
    jugadorY = 330;
  } else {
    mundoW = 2200;
    mundoH = 1000;
    construirPlaza();
    jugadorX = 1100;
    jugadorY = 520;
  }
  ordenarObjetos();
  actualizarCamara();
}

void obs(float x, float y, float w, float h) {
  obstaculos.add(new float[] {x, y, w, h});
}

void addArbol(float x, float yb) {
  objetos.add(new float[] {T_ARBOL, x, yb, 0});
  obs(x - 12, yb - 14, 24, 14);
}

void addCasa(float x, float yb, int v) {
  objetos.add(new float[] {T_CASA, x, yb, v});
  obs(x, yb - 169, 220, 169);
}

void addBanca(float x, float yb) {
  objetos.add(new float[] {T_BANCA, x, yb, 0});
  obs(x - 35, yb - 14, 70, 14);
}

void addFarola(float x, float yb, int v) {
  objetos.add(new float[] {T_FAROLA, x, yb, v});
  obs(x - 6, yb - 8, 12, 8);
}

void addFuente(float x, float yb) {
  objetos.add(new float[] {T_FUENTE, x, yb, 0});
  obs(x - 85, yb - 34, 170, 44);
}

void addPersona(float x, float yCentro) {
  int v = (int)(x * 0.1 + yCentro * 0.3) % 4;
  objetos.add(new float[] {T_PERSONA, x, yCentro + 36, v});
  obs(x - 10, yCentro + 20, 20, 14);
}

void addPuesto(float x, float yb) {
  objetos.add(new float[] {T_PUESTO, x, yb, 0});
  obs(x - 60, yb - 40, 120, 40);
}

void ordenarObjetos() {
  for (int i = 1; i < objetos.size(); i++) {
    float[] k = objetos.get(i);
    int j = i - 1;
    while (j >= 0 && objetos.get(j)[2] > k[2]) {
      objetos.set(j + 1, objetos.get(j));
      j--;
    }
    objetos.set(j + 1, k);
  }
}

// =====================================================
// 16. CONSTRUCCIÓN DE ESCENARIOS
// =====================================================

void construirBarrio() {
  // Fila de casas
  for (int i = 0; i < 8; i++) {
    addCasa(100 + i * 320, 330, i % 3);
  }
  // Árboles entre casas
  for (int i = 0; i < 7; i++) {
    addArbol(370 + i * 320, 345);
  }
  // Árboles detrás de las casas
  for (int x = 60; x < mundoW; x += 210) {
    addArbol(x, 110 + ((x / 210) % 2) * 30);
  }
  // Farolas en las aceras
  for (int x = 250; x < mundoW; x += 400) {
    addFarola(x, 372, 0);
    addFarola(x + 200, 548, 0);
  }
  // Parque
  addFuente(900, 740);
  addBanca(760, 790);
  addBanca(1040, 790);
  addBanca(900, 610);
  float[][] arb = {
    {120, 650}, {260, 830}, {420, 640}, {560, 870}, {700, 880}, {240, 720},
    {1180, 860}, {1300, 640}, {1380, 880}, {1440, 720}, {2420, 700}, {2400, 870}, {2500, 620}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  // Gente (torneo y parque)
  addPersona(1580, 575);
  addPersona(1650, 575);
  addPersona(2150, 575);
  addPersona(2230, 575);
  addPersona(500, 610);
  addPersona(1250, 640);
  addPersona(400, 800);
  addPersona(1900, 700);
  addPersona(1850, 760);
}

void construirColegio() {
  // Edificio principal (fachada superior) y reja inferior
  obs(0, 0, mundoW, 115);
  obs(0, 930, mundoW, 70);

  // Salones anexos
  addCasa(120, 860, 1);
  addCasa(1660, 870, 2);

  // Mástil con bandera
  addFarola(1000, 230, 1);
  // Farolas del camino
  addFarola(915, 300, 0);
  addFarola(1085, 300, 0);
  addFarola(915, 520, 0);
  addFarola(1085, 520, 0);

  // Fuente del patio
  addFuente(450, 420);

  // Bancas
  addBanca(250, 300);
  addBanca(650, 300);
  addBanca(250, 520);
  addBanca(650, 520);
  addBanca(1500, 530);
  addBanca(1620, 530);

  // Árboles
  float[][] arb = {
    {60, 230}, {60, 500}, {1850, 250}, {1930, 420}, {1900, 540},
    {60, 700}, {400, 760}, {600, 700}, {680, 880}, {1240, 760},
    {1400, 900}, {1560, 700}, {1940, 760}, {1930, 640}, {800, 640}, {1200, 640}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  // Estudiantes
  addPersona(700, 420);
  addPersona(1380, 330);
  addPersona(1620, 300);
  addPersona(1480, 500);
  addPersona(600, 590);
  addPersona(1200, 600);
  addPersona(350, 400);
  addPersona(540, 440);
}

void construirPlaza() {
  // Zona superior (edificio / cielo), escenario y carpas
  obs(0, 0, mundoW, 150);
  obs(960, 180, 260, 150);
  obs(670, 220, 160, 100);
  obs(1370, 220, 160, 100);

  // Fuentes
  addFuente(1100, 430);
  addFuente(1100, 830);

  // Bancas
  addBanca(960, 450);
  addBanca(1240, 450);
  addBanca(960, 880);
  addBanca(1240, 880);

  // Puestos de venta
  addPuesto(400, 330);
  addPuesto(1800, 330);
  addPuesto(300, 640);
  addPuesto(500, 640);
  addPuesto(1700, 640);
  addPuesto(1900, 640);

  // Jardineras
  dibujarJardineraObs(300, 780, 160, 70);
  dibujarJardineraObs(1740, 780, 160, 70);

  // Farolas
  for (int x = 400; x < mundoW; x += 300) {
    addFarola(x, 560, 0);
  }

  // Árboles
  float[][] arb = {
    {100, 240}, {260, 230}, {1940, 230}, {2100, 240}, {100, 500}, {2100, 500},
    {100, 760}, {2100, 760}, {100, 960}, {2100, 960}, {620, 960}, {1600, 960}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  // Público del debate (posiciones originales)
  addPersona(880, 300);
  addPersona(930, 330);
  addPersona(1260, 310);
  addPersona(1310, 340);
  addPersona(850, 355);
  addPersona(1350, 355);
  // Más ciudadanos
  addPersona(600, 520);
  addPersona(1700, 520);
  addPersona(900, 700);
  addPersona(1300, 720);
  addPersona(500, 860);
  addPersona(1800, 880);
  addPersona(300, 400);
  addPersona(1900, 400);
}

void dibujarJardineraObs(float x, float y, float w, float h) {
  obs(x, y, w, h);
}

// =====================================================
// 17. DIBUJO DE OBJETOS DEL MUNDO
// =====================================================

void dibujarObjetosYJugador() {
  float baseJugador = jugadorY + 26;
  boolean jugadorDibujado = false;

  for (float[] o : objetos) {
    if (!jugadorDibujado && o[2] > baseJugador) {
      dibujarJugador();
      jugadorDibujado = true;
    }
    // No dibujar lo que está lejos de la pantalla
    if (o[1] < camX - 300 || o[1] > camX + width + 300) continue;
    if (o[2] < camY - 20 || o[2] - 260 > camY + height) continue;
    dibujarObjeto(o);
  }
  if (!jugadorDibujado) dibujarJugador();
}

void dibujarObjeto(float[] o) {
  int t = (int) o[0];
  float x = o[1];
  float yb = o[2];
  noStroke();
  if (t == T_ARBOL) dibujarArbol(x, yb);
  else if (t == T_CASA) dibujarCasa(x, yb - 169, (int) o[3]);
  else if (t == T_BANCA) dibujarBanca(x, yb);
  else if (t == T_FAROLA) dibujarFarola(x, yb, (int) o[3]);
  else if (t == T_FUENTE) dibujarFuente(x, yb);
  else if (t == T_PERSONA) dibujarPersona(x, yb - 36, (int) o[3]);
  else if (t == T_PUESTO) dibujarPuesto(x, yb);
}

void dibujarArbol(float x, float yb) {
  fill(0, 45);
  ellipse(x, yb, 56, 16);
  fill(110, 70, 40);
  rect(x - 8, yb - 55, 16, 55);
  fill(45, 120, 55);
  ellipse(x, yb - 85, 90, 80);
  fill(60, 150, 70);
  ellipse(x - 10, yb - 92, 60, 52);
}

void dibujarCasa(float x, float y, int v) {
  int pared, techo;
  if (v == 0) {
    pared = color(230, 180, 120);
    techo = color(170, 70, 60);
  } else if (v == 1) {
    pared = color(150, 180, 225);
    techo = color(70, 90, 140);
  } else if (v == 2) {
    pared = color(235, 215, 130);
    techo = color(160, 90, 50);
  } else {
    pared = color(200, 230, 190);
    techo = color(90, 130, 80);
  }
  int techoOscuro = lerpColor(techo, color(0), 0.25);

  fill(150, 120, 90);
  rect(x + 7, y + 7, 220, 169);

  fill(pared);
  rect(x, y, 220, 169);

  fill(techoOscuro);
  triangle(x - 12, y + 7, x + 232, y + 7, x + 110, y - 53);

  fill(techo);
  triangle(x - 20, y, x + 240, y, x + 110, y - 60);

  fill(lerpColor(techo, color(0), 0.4));
  rect(x - 20, y - 5, 260, 7);

  fill(100, 60, 40);
  rect(x + 85, y + 100, 50, 69);

  fill(80, 130, 150);
  rect(x + 20, y + 45, 55, 55);
  fill(120, 200, 230);
  rect(x + 25, y + 50, 45, 45);

  fill(80, 130, 150);
  rect(x + 145, y + 45, 55, 55);
  fill(120, 200, 230);
  rect(x + 150, y + 50, 45, 45);
}

void dibujarBanca(float x, float yb) {
  fill(0, 40);
  ellipse(x, yb, 76, 12);
  fill(70, 50, 40);
  rect(x - 30, yb - 14, 6, 14);
  rect(x + 24, yb - 14, 6, 14);
  fill(150, 100, 60);
  rect(x - 35, yb - 22, 70, 10, 2);
  fill(130, 85, 50);
  rect(x - 35, yb - 36, 70, 8, 2);
}

void dibujarFarola(float x, float yb, int v) {
  fill(60);
  rect(x - 6, yb - 6, 12, 6);
  if (v == 1) {
    rect(x - 3, yb - 170, 6, 170);
    fill(255, 220, 0);
    rect(x + 3, yb - 168, 40, 20);
    fill(30, 60, 200);
    rect(x + 3, yb - 148, 40, 10);
    fill(200, 30, 40);
    rect(x + 3, yb - 138, 40, 10);
  } else {
    rect(x - 3, yb - 90, 6, 90);
    fill(250, 230, 120);
    ellipse(x, yb - 95, 18, 18);
  }
}

void dibujarFuente(float x, float yb) {
  noStroke();
  fill(0, 40);
  ellipse(x, yb, 190, 50);
  fill(150, 155, 160);
  ellipse(x, yb - 12, 180, 56);
  fill(120, 125, 130);
  ellipse(x, yb - 16, 160, 44);
  fill(90, 160, 215);
  ellipse(x, yb - 18, 148, 36);
  fill(170, 175, 180);
  rect(x - 8, yb - 60, 16, 42, 4);
  fill(150, 155, 160);
  ellipse(x, yb - 62, 50, 16);
  fill(120, 190, 235);
  ellipse(x, yb - 64, 40, 10);

  float t = frameCount * 0.1;
  stroke(190, 230, 255, 200);
  strokeWeight(2);
  for (int i = -2; i <= 2; i++) {
    float h = 22 + 6 * sin(t + i);
    line(x + i * 3, yb - 66, x + i * 12, yb - 66 - h);
  }
  noStroke();
  strokeWeight(1);
}

void dibujarPersona(float x, float y, int v) {
  fill(110, 110, 100);
  ellipse(x, y + 35, 30, 10);

  fill(50);
  rect(x - 8, y + 18, 6, 18);
  rect(x + 3, y + 18, 6, 18);

  if (v == 0) fill(80, 120, 190);
  else if (v == 1) fill(200, 90, 90);
  else if (v == 2) fill(90, 170, 110);
  else fill(220, 170, 70);
  rect(x - 12, y - 5, 24, 25);

  fill(230, 180, 140);
  ellipse(x, y - 15, 22, 22);
}

void dibujarPuesto(float x, float yb) {
  fill(0, 40);
  ellipse(x, yb, 130, 16);
  fill(120, 90, 60);
  rect(x - 58, yb - 85, 5, 85);
  rect(x + 53, yb - 85, 5, 85);
  fill(200, 160, 110);
  rect(x - 55, yb - 40, 110, 40);
  fill(170, 130, 85);
  rect(x - 55, yb - 40, 110, 8);
  for (int i = 0; i < 6; i++) {
    if (i % 2 == 0) fill(220, 70, 70);
    else fill(245);
    rect(x - 60 + i * 20, yb - 90, 20, 28);
  }
}

void dibujarFlores(float x, float y, float w, float h) {
  noStroke();
  for (int i = 0; i < 14; i++) {
    float fx = x + (i * 37) % int(w);
    float fy = y + (i * 23) % int(h);
    if (i % 3 == 0) fill(255, 90, 120);
    else if (i % 3 == 1) fill(255, 230, 80);
    else fill(255);
    ellipse(fx, fy, 6, 6);
  }
}

void dibujarJardinera(float x, float y, float w, float h) {
  noStroke();
  fill(70, 120, 70);
  rect(x, y + 6, w, h, 12);
  fill(75, 145, 75);
  rect(x, y, w, h, 12);
  dibujarFlores(x + 10, y + 10, w - 20, h - 20);
}

void dibujarVentana(float x, float y) {
  fill(80, 130, 150);
  rect(x, y, 70, 50);
  fill(120, 200, 230);
  rect(x + 5, y + 5, 60, 40);
}

void dibujarColisiones() {
  noStroke();
  fill(255, 0, 0, 90);
  for (float[] o : obstaculos) {
    rect(o[0], o[1], o[2], o[3]);
  }
  fill(0, 0, 255, 120);
  rect(jugadorX - 10, jugadorY + 8, 20, 18);
}

// =====================================================
// 18. ESCENARIO 1 - BARRIO
// =====================================================

void fondoBarrio() {
  background(120, 190, 100);
  noStroke();

  // Césped con parches
  fill(110, 180, 92);
  for (int x = 0; x < mundoW; x += 200) {
    for (int y = 0; y < mundoH; y += 200) {
      if (((x / 200) + (y / 200)) % 2 == 0) rect(x, y, 200, 200);
    }
  }

  // Senderos y flores frente a las casas
  for (int i = 0; i < 8; i++) {
    float hx = 100 + i * 320;
    fill(200, 185, 160);
    rect(hx + 85, 330, 50, 35);
    dibujarFlores(hx + 10, 338, 60, 22);
    dibujarFlores(hx + 150, 338, 60, 22);
  }

  // Calle
  fill(170);
  rect(0, 365, mundoW, 15);
  fill(70);
  rect(0, 380, mundoW, 160);
  fill(250, 220, 80);
  for (int x = 20; x < mundoW; x += 100) {
    rect(x, 455, 50, 8);
  }
  // Paso de cebra
  fill(240);
  for (int y = 385; y < 535; y += 20) {
    rect(1240, y, 70, 10);
  }
  fill(170);
  rect(0, 540, mundoW, 15);

  // Parque: camino y plaza de la fuente
  fill(215, 205, 180);
  rect(870, 555, 60, 120);
  ellipse(900, 715, 460, 230);
  dibujarFlores(1130, 600, 120, 40);
  dibujarFlores(560, 700, 120, 40);

  // Cancha del torneo deportivo
  fill(130);
  rect(1507, 607, 800, 260);
  fill(170, 150, 110);
  rect(1500, 600, 800, 260);
  noFill();
  stroke(255);
  strokeWeight(3);
  rect(1520, 620, 760, 220);
  line(1900, 620, 1900, 840);
  ellipse(1900, 730, 110, 110);
  rect(1520, 690, 90, 80);
  rect(2190, 690, 90, 80);
  noStroke();
  strokeWeight(1);

  // Cartel del torneo
  fill(40, 60, 140);
  rect(1750, 556, 300, 32, 8);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("TORNEO DEPORTIVO", 1900, 571);
  textAlign(LEFT, BASELINE);
}

// =====================================================
// 19. ESCENARIO 2 - COLEGIO
// =====================================================

void fondoColegio() {
  background(190, 190, 170);
  noStroke();

  // Patio con baldosas
  stroke(178, 178, 158);
  strokeWeight(1);
  for (int x = 0; x < mundoW; x += 100) line(x, 120, x, mundoH);
  for (int y = 120; y < mundoH; y += 100) line(0, y, mundoW, y);
  noStroke();

  // Zonas de césped
  fill(120, 175, 100);
  rect(0, 620, 860, 380);
  rect(1140, 620, 860, 380);

  // Caminos
  fill(215, 210, 190);
  rect(930, 120, 140, 880);
  rect(0, 540, mundoW, 70);
  // Plaza de la fuente
  ellipse(450, 400, 420, 200);

  // Flores
  dibujarFlores(120, 200, 200, 30);
  dibujarFlores(720, 200, 200, 30);

  // ----- Edificio principal (fachada superior) -----
  fill(230, 190, 120);
  rect(0, 0, mundoW, 110);
  fill(180, 140, 90);
  rect(0, 100, mundoW, 10);
  fill(120, 120, 110);
  rect(0, 110, mundoW, 10);

  for (int x = 80; x < mundoW - 100; x += 130) {
    if (abs(x + 35 - 1000) < 100) continue;
    dibujarVentana(x, 30);
  }

  // Puerta principal
  noStroke();
  fill(70, 50, 40);
  rect(963, 35, 90, 75);
  fill(110, 70, 45);
  rect(955, 30, 90, 80);
  stroke(70, 50, 40);
  strokeWeight(2);
  line(1000, 30, 1000, 110);
  noStroke();
  strokeWeight(1);
  fill(170);
  rect(940, 110, 120, 12);

  // Letrero
  fill(250, 245, 225);
  rect(925, 2, 150, 24, 4);
  fill(50);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("COLEGIO NOVA", 1000, 14);
  textAlign(LEFT, BASELINE);

  // ----- Cancha -----
  fill(130, 130, 120);
  rect(1257, 197, 500, 280);
  fill(170, 150, 110);
  rect(1250, 190, 500, 280);
  noFill();
  stroke(255);
  strokeWeight(3);
  rect(1265, 205, 470, 250);
  line(1500, 205, 1500, 455);
  ellipse(1500, 330, 90, 90);
  rect(1265, 275, 80, 110);
  rect(1655, 275, 80, 110);
  noStroke();
  strokeWeight(1);

  // ----- Reja del colegio -----
  fill(140, 115, 85);
  rect(0, 940, mundoW, 6);
  rect(0, 965, mundoW, 6);
  fill(110, 90, 70);
  for (int x = 0; x < mundoW; x += 30) {
    rect(x, 925, 8, 75);
  }
}

// =====================================================
// 20. ESCENARIO 3 - PLAZA
// =====================================================

void fondoPlaza() {
  background(175, 220, 245);
  noStroke();

  // Piso de la plaza
  fill(190, 185, 170);
  rect(0, 155, mundoW, mundoH - 155);
  stroke(160);
  strokeWeight(1);
  for (int x = 0; x < mundoW; x += 50) line(x, 155, x, mundoH);
  for (int y = 155; y < mundoH; y += 50) line(0, y, mundoW, y);
  noStroke();

  // Plazoleta alrededor de la fuente grande
  fill(205, 200, 185);
  ellipse(1100, 800, 520, 250);

  // Jardineras
  dibujarJardinera(300, 780, 160, 70);
  dibujarJardinera(1740, 780, 160, 70);

  // ----- Contenido central original (desplazado 600 px) -----
  pushMatrix();
  translate(600, 0);

  // Edificio municipal
  fill(210, 190, 150);
  rect(350, 25, 300, 130);
  fill(130, 90, 70);
  triangle(330, 25, 670, 25, 500, 0);
  fill(100, 70, 50);
  rect(465, 85, 70, 70);
  fill(100, 180, 220);
  rect(385, 65, 50, 40);
  rect(565, 65, 50, 40);
  fill(240);
  ellipse(500, 45, 35, 35);

  // Cartel de elecciones
  fill(100);
  rect(713, 28, 235, 67);
  fill(245, 235, 200);
  rect(705, 20, 235, 67);
  fill(50);
  textAlign(CENTER);
  textSize(18);
  text("ELECCIONES MUNICIPALES", 822, 45);
  textSize(22);
  text("FALTAN 7 DIAS", 822, 72);

  // Tarima del debate
  fill(90);
  rect(370, 275, 260, 65);
  fill(130, 90, 60);
  rect(360, 265, 260, 65);
  fill(225);
  rect(380, 180, 220, 85);
  fill(60);
  textSize(18);
  text("DEBATE CIUDADANO", 490, 215);
  fill(100, 70, 50);
  rect(465, 220, 50, 45);

  // Carpa del candidato A
  fill(230);
  rect(70, 220, 160, 100);
  fill(180, 60, 60);
  rect(70, 220, 160, 25);
  fill(50);
  textSize(16);
  text("CANDIDATO A", 150, 240);
  fill(120, 80, 50);
  rect(90, 275, 120, 25);

  // Carpa del candidato B
  fill(230);
  rect(770, 220, 160, 100);
  fill(70, 100, 190);
  rect(770, 220, 160, 25);
  fill(50);
  text("CANDIDATO B", 850, 240);
  fill(120, 80, 50);
  rect(790, 275, 120, 25);

  // Pancarta que se mueve
  float movimiento = sin(frameCount / 20.0) * 3;
  fill(245, 240, 210);
  rect(255, 210 + movimiento, 90, 45);
  fill(50);
  textSize(13);
  text("TU VOTO\nCUENTA", 300, 227 + movimiento);

  popMatrix();
  textAlign(LEFT, BASELINE);

  // Cuerda de banderines a lo ancho de toda la plaza
  stroke(80);
  strokeWeight(1);
  line(0, 55, mundoW, 55);
  noStroke();
  for (int x = 20; x < mundoW; x += 50) {
    if ((x / 50) % 2 == 0) fill(220, 80, 80);
    else fill(80, 120, 210);
    triangle(x, 55, x + 20, 55, x + 10, 75);
  }
}

// =====================================================
// 21. RED SOCIAL CONECTA
// =====================================================

void gestionarRedSocialGUI() {
  dibujarIconoRedSocial();
  if (redSocialAbierta) {
    dibujarPantallaConecta();
  }
}

void dibujarIconoRedSocial() {
  pushStyle();
  rectMode(CORNER);
  stroke(255);
  strokeWeight(2);
  fill(30, 144, 255); // Azul Conecta
  rect(width - 65, 15, 50, 50, 12);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("📱", width - 40, 38);

  // Notificación roja si hay publicación pendiente en este escenario
  if (hayPublicacionesPendientes(escenario)) {
    fill(255, 50, 50);
    noStroke();
    ellipse(width - 15, 15, 14, 14);
  }
  popStyle();
}

void dibujarPantallaConecta() {
  pushStyle();

  fill(0, 0, 0, 180);
  rect(0, 0, width, height);

  // Marco del teléfono
  fill(20, 25, 35);
  stroke(30, 144, 255);
  strokeWeight(3);
  rect(width/2 - 200, 20, 400, height - 40, 20);

  // Encabezado
  fill(30, 144, 255);
  rect(width/2 - 200, 20, 400, 45, 20, 20, 0, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  String nombreEscenario = (escenario == 1) ? "BARRIO" : (escenario == 2) ? "COLEGIO" : "ELECCIÓN";
  text("RED CONECTA - " + nombreEscenario, width/2, 42);

  // Buscar publicación para el escenario actual
  int idx = obtenerIndicePublicacion(escenario);
  // =====================================================
  // CONECTA ESPECIAL DEL MINIJUEGO DEL COLEGIO
  // =====================================================

  if (escenario == 2 && minijuegoColegioActivo) {

    dibujarConectaColegio();

    popStyle();
    return;
  }

  if (idx != -1 && !pubProcesadas[idx]) {
    // Tarjeta de publicación
    fill(35, 42, 55);
    stroke(60, 70, 90);
    rect(width/2 - 180, 80, 360, 140, 10);

    fill(180, 200, 220);
    textAlign(LEFT, TOP);
    textSize(12);
    text("Autor: " + pubAutores[idx], width/2 - 165, 92);
    text("Confiabilidad: " + pubConfiabilidad[idx] + "%  |  Viralidad: " + pubViralidad[idx] + "%", width/2 - 165, 110);

    fill(255);
    textSize(13);
    textLeading(18);
    text(pubTitulos[idx], width/2 - 165, 135, 330, 80);

    // Botones de decisión (1, 2, 3)
    dibujarBotonOpcion(width/2 - 170, 235, "L1. Compartir (Aumenta Viralidad)", color(220, 80, 80));
    dibujarBotonOpcion(width/2 - 170, 280, "R1. Verificar / Reportar", color(80, 180, 100));
    dibujarBotonOpcion(width/2 - 170, 325, "L2. Ignorar Publicación", color(120, 130, 140));
  } else {
    fill(200);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("No hay publicaciones pendientes\nen esta zona de la ciudad.", width/2, height/2 - 10);
  }

  // Indicación de cierre
  fill(150);
  textSize(11);
  textAlign(CENTER);
  text("[ Presiona C, Cuadrado o Clic en el icono para Cerrar ]", width/2, height - 30);

  popStyle();
}

void dibujarBotonOpcion(float x, float y, String texto, int c) {
  fill(c);
  noStroke();
  rect(x, y, 340, 36, 8);
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(13);
  text(texto, x + 15, y + 18);
}

void procesarDecision(int idx, int opcion) {
  if (idx < 0 || idx >= pubTitulos.length) return;

  // 1: Compartir, 2: Verificar/Reportar, 3: Ignorar
  if (opcion == 1) {
    pubViralidad[idx] += 20;
    cambiarIndicadores(-10, -5, -5, +5, -10);
  } else if (opcion == 2) {
    pubViralidad[idx] -= 15;
    cambiarIndicadores(+15, +10, +5, +10, +10);
  } else if (opcion == 3) {
    cambiarIndicadores(0, 0, +5, 0, 0);
  }

  pubProcesadas[idx] = true;
}

int obtenerIndicePublicacion(int esc) {
  for (int i = 0; i < pubEscenarios.length; i++) {
    if (pubEscenarios[i] == esc && !pubProcesadas[i]) {
      return i;
    }
  }
  return -1;
}

boolean hayPublicacionesPendientes(int esc) {
  return obtenerIndicePublicacion(esc) != -1;
}

// =====================================================
// 22. TECLADO Y MOUSE
// =====================================================

void keyPressed() {

  // Abrir / Cerrar Red Social Conecta
  if (key == 'c' || key == 'C') {
    redSocialAbierta = !redSocialAbierta;
  }

  // Movimiento WASD
  if (key == 'w' || key == 'W') moverArriba = true;
  if (key == 's' || key == 'S') moverAbajo = true;
  if (key == 'a' || key == 'A') moverIzquierda = true;
  if (key == 'd' || key == 'D') moverDerecha = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') moverArriba = false;
  if (key == 's' || key == 'S') moverAbajo = false;
  if (key == 'a' || key == 'A') moverIzquierda = false;
  if (key == 'd' || key == 'D') moverDerecha = false;
}

void mousePressed() {
  // Click en el icono de la red social
  if (mouseX >= width - 65 && mouseX <= width - 15 && mouseY >= 15 && mouseY <= 65) {
    redSocialAbierta = !redSocialAbierta;
    return;
  }

  // Click en los botones de opción cuando la red está abierta
  if (redSocialAbierta) {
    int idx = obtenerIndicePublicacion(escenario);
    if (idx != -1 && !pubProcesadas[idx]) {
      if (mouseX >= width/2 - 170 && mouseX <= width/2 + 170 && mouseY >= 235 && mouseY <= 271) {
        procesarDecision(idx, 1);
      } else if (mouseX >= width/2 - 170 && mouseX <= width/2 + 170 && mouseY >= 280 && mouseY <= 316) {
        procesarDecision(idx, 2);
      } else if (mouseX >= width/2 - 170 && mouseX <= width/2 + 170 && mouseY >= 325 && mouseY <= 361) {
        procesarDecision(idx, 3);
      }
    }
  }
}

// =====================================================
// 23. MOVIMIENTO Y COLISIONES DEL JUGADOR
// =====================================================

void moverJugador() {

  float dx = 0;
  float dy = 0;
  jugadorCaminando = false;

  // ==========================================
  // MOVIMIENTO CON TECLADO WASD
  // ==========================================

  if (moverArriba) dy -= 1;
  if (moverAbajo) dy += 1;
  if (moverIzquierda) dx -= 1;
  if (moverDerecha) dx += 1;

  // ==========================================
  // MOVIMIENTO CON CONTROL PS4
  // ==========================================

  if (mandoConectado) {

    float movimientoX = joystickX.getValue();
    float movimientoY = joystickY.getValue();

    if (abs(movimientoX) < 0.15) {
      movimientoX = 0;
    }

    if (abs(movimientoY) < 0.15) {
      movimientoY = 0;
    }

    // JOYSTICK IZQUIERDO
    dx += movimientoX;
    dy += movimientoY;
  }

  // ==========================================
  // VELOCIDAD EN DIAGONAL
  // ==========================================
  if (dx != 0 || dy != 0) {
    jugadorCaminando = true;
    animacionCaminar += 0.25;
  }
  if (dx != 0 && dy != 0) {

    float magnitud = sqrt(dx * dx + dy * dy);

    if (magnitud > 1) {
      dx /= magnitud;
      dy /= magnitud;
    }
  }

  // ==========================================
  // APLICAR VELOCIDAD
  // ==========================================

  dx *= velocidadJugador;
  dy *= velocidadJugador;

  // ==========================================
  // COLISION HORIZONTAL
  // ==========================================

  float nx = constrain(
    jugadorX + dx,
    18,
    mundoW - 18
  );

  if (!colisiona(nx, jugadorY)) {
    jugadorX = nx;
  }

  // ==========================================
  // COLISION VERTICAL
  // ==========================================

  float ny = constrain(
    jugadorY + dy,
    40,
    mundoH - 35
  );

  if (!colisiona(jugadorX, ny)) {
    jugadorY = ny;
  }
}

boolean colisiona(float x, float y) {
  for (float[] o : obstaculos) {
    if (x + 10 > o[0] && x - 10 < o[0] + o[2] && y + 26 > o[1] && y + 8 < o[1] + o[3]) {
      return true;
    }
  }
  return false;
}

// =====================================================
// 24. DIBUJO DEL JUGADOR
// =====================================================

void dibujarJugador() {
  noStroke();
  // ==========================================
  // ANIMACIÓN DE CAMINAR
  // ==========================================

  float movimientoPiernas = 0;
  float movimientoBrazos = 0;

  if (jugadorCaminando) {

    movimientoPiernas =
    sin(animacionCaminar) * 5;

    movimientoBrazos =
    sin(animacionCaminar) * 4;
  }
  fill(70, 70, 70, 120);
  ellipse(jugadorX, jugadorY + 22, 32, 10);

  fill(40, 50, 80);
  rect(jugadorX - 10, jugadorY + 8 + movimientoPiernas, 8, 18);
  rect(jugadorX + 2, jugadorY + 8 - movimientoPiernas, 8, 18);

  fill(160, 70, 210);
  rect(jugadorX - 14, jugadorY - 15, 28, 25, 5);

  fill(230, 180, 140);
  rect(jugadorX - 18, jugadorY - 10 - movimientoBrazos, 5, 18, 3);
  rect(jugadorX + 13, jugadorY - 10 + movimientoBrazos , 5, 18, 3);

  fill(230, 180, 140);
  ellipse(jugadorX, jugadorY - 27, 25, 25);

  fill(60, 40, 30);
  arc(jugadorX, jugadorY - 30, 25, 20, PI, TWO_PI);

  fill(255);
  ellipse(jugadorX, jugadorY - 48, 9, 9);
}

// =====================================================
// 25. INDICADORES DE LA CIUDAD
// =====================================================

void mostrarIndicadores() {
  noStroke();
  fill(0, 170);
  rect(15, 15, 230, 145, 10);

  fill(255);
  textAlign(LEFT);
  textSize(20);
  text("ESTADO DE NOVA", 30, 40);

  textSize(16);
  text("Informacion: " + informacion, 30, 65);
  text("Convivencia: " + convivencia, 30, 85);
  text("Bienestar digital: " + bienestar, 30, 105);
  text("Participacion: " + participacion, 30, 125);
  text("Reputacion: " + reputacion, 30, 145);
}

void cambiarIndicadores(
  int cambioInformacion,
  int cambioConvivencia,
  int cambioBienestar,
  int cambioParticipacion,
  int cambioReputacion
) {
  informacion += cambioInformacion;
  convivencia += cambioConvivencia;
  bienestar += cambioBienestar;
  participacion += cambioParticipacion;
  reputacion += cambioReputacion;

  informacion = constrain(informacion, 0, 100);
  convivencia = constrain(convivencia, 0, 100);
  bienestar = constrain(bienestar, 0, 100);
  participacion = constrain(participacion, 0, 100);
  reputacion = constrain(reputacion, 0, 100);
}

// =====================================================
// 26. BUS BARRIO -> COLEGIO
// =====================================================

// -------------------------
// 26.1 ACTUALIZAR BUS
// -------------------------

void actualizarBus() {

  // El bus solo existe en el Barrio
  if (escenario != 1 || viajandoEnBus) {
    return;
  }

  // SI ESTÁ DETENIDO
  if (busDetenido) {

    tiempoBusDetenido++;

    // Espera unos segundos
    if (tiempoBusDetenido > 240) {
      busDetenido = false;
    }

  } else {

    // MOVER BUS
    busX += velocidadBus;

    // DETENERSE EN LA PARADA
    if (!busYaParo && busX >= paradaBusX) {

      busX = paradaBusX;

      busDetenido = true;

      busYaParo = true;

      tiempoBusDetenido = 0;
    }

    // SI SALE DEL MAPA, VUELVE A EMPEZAR
    if (busX > mundoW + 180) {

      busX = -180;

      busYaParo = false;

      busDetenido = false;

      tiempoBusDetenido = 0;
    }
  }
}

// -------------------------
// 26.2 DIBUJAR BUS
// -------------------------

void dibujarBus() {

  if (escenario != 1) {
    return;
  }

  pushStyle();

  rectMode(CENTER);

  // SOMBRA
  noStroke();
  fill(0, 50);

  ellipse(
    busX,
    busY + 43,
    220,
    25
  );

  // CUERPO DEL BUS
  fill(245, 190, 40);

  rect(
    busX,
    busY,
    220,
    82,
    14
  );

  // PARTE INFERIOR
  fill(220, 145, 20);

  rect(
    busX,
    busY + 25,
    220,
    30
  );

  // VENTANAS
  fill(120, 190, 220);

  rect(busX - 70, busY - 15, 42, 28, 5);
  rect(busX - 20, busY - 15, 42, 28, 5);
  rect(busX + 30, busY - 15, 42, 28, 5);

  // PUERTA
  fill(75, 125, 150);

  rect(
    busX + 82,
    busY + 3,
    30,
    58,
    4
  );

  // RUEDAS
  fill(35);

  ellipse(
    busX - 70,
    busY + 42,
    36,
    36
  );

  ellipse(
    busX + 70,
    busY + 42,
    36,
    36
  );

  fill(130);

  ellipse(
    busX - 70,
    busY + 42,
    15,
    15
  );

  ellipse(
    busX + 70,
    busY + 42,
    15,
    15
  );

  // TEXTO DEL BUS
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "COLEGIO NOVA",
    busX,
    busY + 15
  );

  rectMode(CORNER);

  popStyle();
}

// -------------------------
// 26.3 INTERACCIÓN CON EL BUS
// -------------------------

void revisarInteraccionBus() {

  cercaDelBus = false;

  if (
    escenario == 1 &&
    busDetenido &&
    minijuegoIncendiosTerminado
  ) {

    float distanciaBus = dist(
      jugadorX,
      jugadorY,
      busX + 75,
      busY + 25
    );

    if (distanciaBus < 105) {
      cercaDelBus = true;
    }
  }

  if (
    mandoConectado &&
    cercaDelBus &&
    minijuegoIncendiosTerminado
  ) {

    boolean xAhora = botonX.pressed();

    if (xAhora && !xPresionadoAntes) {

      viajandoEnBus = true;

      println("SUBIENDO AL BUS");
    }

    xPresionadoAntes = xAhora;

  } else {

    xPresionadoAntes = false;
  }
}

// -------------------------
// 26.4 VIAJE AL COLEGIO
// -------------------------

void actualizarViajeBus() {

  if (!viajandoEnBus) {
    return;
  }

  oscuridadTransicion += 6;

  fill(
    0,
    constrain(oscuridadTransicion, 0, 255)
  );

  noStroke();

  rect(
    0,
    0,
    width,
    height
  );

  if (oscuridadTransicion >= 255) {

    cargarEscenario(2);

    jugadorX = 1000;
    jugadorY = 850;

    viajandoEnBus = false;
    oscuridadTransicion = 0;
  }
}

// =====================================================
// 27. BUS COLEGIO -> PLAZA
// =====================================================

// -------------------------
// 27.1 ACTUALIZAR BUS
// -------------------------

void actualizarBusPlaza() {

  // Este bus solamente existe en el Colegio
  if (escenario != 2 || viajandoAPlaza) {
    return;
  }

  if (busPlazaDetenido) {

    tiempoBusPlazaDetenido++;

    // Espera unos segundos
    if (tiempoBusPlazaDetenido > 240) {

      busPlazaDetenido = false;
    }

  } else {

    // MOVER BUS
    busPlazaX += velocidadBusPlaza;

    // DETENER BUS
    if (!busPlazaYaParo && busPlazaX >= paradaBusPlazaX) {

      busPlazaX = paradaBusPlazaX;

      busPlazaDetenido = true;

      busPlazaYaParo = true;

      tiempoBusPlazaDetenido = 0;
    }

    // VOLVER A COMENZAR
    if (busPlazaX > mundoW + 180) {

      busPlazaX = -180;

      busPlazaYaParo = false;

      busPlazaDetenido = false;

      tiempoBusPlazaDetenido = 0;
    }
  }
}

// -------------------------
// 27.2 DIBUJAR BUS
// -------------------------

void dibujarBusPlaza() {

  if (escenario != 2) {
    return;
  }

  pushStyle();

  rectMode(CENTER);

  // SOMBRA
  noStroke();
  fill(0, 50);

  ellipse(
    busPlazaX,
    busPlazaY + 43,
    220,
    25
  );

  // CUERPO
  fill(70, 120, 210);

  rect(
    busPlazaX,
    busPlazaY,
    220,
    82,
    14
  );

  // PARTE INFERIOR
  fill(40, 80, 170);

  rect(
    busPlazaX,
    busPlazaY + 25,
    220,
    30
  );

  // VENTANAS
  fill(120, 190, 220);

  rect(busPlazaX - 70, busPlazaY - 15, 42, 28, 5);
  rect(busPlazaX - 20, busPlazaY - 15, 42, 28, 5);
  rect(busPlazaX + 30, busPlazaY - 15, 42, 28, 5);

  // PUERTA
  fill(75, 125, 150);

  rect(
    busPlazaX + 82,
    busPlazaY + 3,
    30,
    58,
    4
  );

  // RUEDAS
  fill(35);

  ellipse(
    busPlazaX - 70,
    busPlazaY + 42,
    36,
    36
  );

  ellipse(
    busPlazaX + 70,
    busPlazaY + 42,
    36,
    36
  );

  fill(130);

  ellipse(
    busPlazaX - 70,
    busPlazaY + 42,
    15,
    15
  );

  ellipse(
    busPlazaX + 70,
    busPlazaY + 42,
    15,
    15
  );

  // DESTINO
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "PLAZA NOVA",
    busPlazaX,
    busPlazaY + 15
  );

  rectMode(CORNER);

  popStyle();
}

// -------------------------
// 27.3 INTERACCIÓN CON EL BUS
// -------------------------

void revisarInteraccionBusPlaza() {

  cercaBusPlaza = false;

  // Detectar si el jugador está cerca del bus
  if (
    escenario == 2 &&
    busPlazaDetenido &&
    crisisColegioCompletadas >= 3
  ) {

    float distanciaBusPlaza = dist(
      jugadorX,
      jugadorY,
      busPlazaX + 75,
      busPlazaY + 25
    );

    if (distanciaBusPlaza < 105) {
      cercaBusPlaza = true;
    }
  }

  // PRESIONAR X PARA SUBIR
  if (
    mandoConectado &&
    cercaBusPlaza &&
    !viajandoAPlaza &&
    crisisColegioCompletadas >= 3
  ) {

    boolean xAhora = botonX.pressed();

    if (xAhora && !xPresionadoAntes) {

      viajandoAPlaza = true;

      oscuridadPlaza = 0;

      println("VIAJANDO A LA PLAZA");
    }

    xPresionadoAntes = xAhora;

  } else if (escenario == 2) {

    xPresionadoAntes = false;
  }
}

// -------------------------
// 27.4 VIAJE A LA PLAZA
// -------------------------

void actualizarViajePlaza() {

  if (!viajandoAPlaza) {
    return;
  }

  oscuridadPlaza += 6;

  fill(
    0,
    constrain(oscuridadPlaza, 0, 255)
  );

  noStroke();

  rect(
    0,
    0,
    width,
    height
  );

  if (oscuridadPlaza >= 255) {

    cargarEscenario(3);

    jugadorX = 1100;
    jugadorY = 700;

    viajandoAPlaza = false;

    oscuridadPlaza = 0;

    busPlazaX = -180;

    busPlazaDetenido = false;

    busPlazaYaParo = false;

    tiempoBusPlazaDetenido = 0;

    cercaBusPlaza = false;
  }
}

// =====================================================
// 28. NPC LÍDER SOCIAL
// =====================================================

// -------------------------
// 28.1 DIBUJAR NPC
// -------------------------

void dibujarNpcBombero() {

  if (escenario != 1) {
    return;
  }

  pushStyle();

  // SOMBRA
  noStroke();
  fill(0, 50);
  ellipse(
    npcBomberoX,
    npcBomberoY + 34,
    32,
    10
  );

  // PIERNAS
  fill(40);

  rect(
    npcBomberoX - 8,
    npcBomberoY + 15,
    6,
    20
  );

  rect(
    npcBomberoX + 2,
    npcBomberoY + 15,
    6,
    20
  );

  // UNIFORME
  fill(220, 60, 50);

  rect(
    npcBomberoX - 13,
    npcBomberoY - 8,
    26,
    25,
    4
  );

  // CABEZA
  fill(230, 180, 140);

  ellipse(
    npcBomberoX,
    npcBomberoY - 18,
    22,
    22
  );

  // CASCO
  fill(220, 40, 40);

  arc(
    npcBomberoX,
    npcBomberoY - 21,
    27,
    20,
    PI,
    TWO_PI
  );

  // SIGNO DE INTERACCIÓN
  fill(255, 230, 70);

  textAlign(CENTER);
  textSize(55);

  text(
    "!",
    npcBomberoX,
    npcBomberoY - 42
  );

  popStyle();
}

// -------------------------
// 28.2 DETECTAR CERCANÍA
// -------------------------

void revisarInteraccionNpcBombero() {

  cercaNpcBombero = false;

  if (escenario != 1) {
    return;
  }

  float distanciaBombero = dist(
    jugadorX,
    jugadorY,
    npcBomberoX,
    npcBomberoY
  );

  if (distanciaBombero < 80) {
    cercaNpcBombero = true;
  }
}

// -------------------------
// 28.3 CONTROLAR DIÁLOGO
// -------------------------

void controlarDialogoBombero() {

  if (!mandoConectado) {
    return;
  }

  boolean cuadradoAhora = botonCuadrado.pressed();

  // SI ESTAMOS CERCA DEL BOMBERO
  if (
    escenario == 1 &&
    cercaNpcBombero &&
    !minijuegoIncendiosActivo
  ) {

    // Detectar una sola pulsación
    if (cuadradoAhora && !cuadradoNpcAntes) {

      // Si todavía no había diálogo, abrirlo
      if (!dialogoBomberoActivo) {

        dialogoBomberoActivo = true;
        dialogoBombero = 1;

      } else {

        dialogoBombero++;

        // Si ya pasamos el último diálogo
        if (dialogoBombero > 3) {

          dialogoBomberoActivo = false;

          iniciarMinijuegoIncendios();
        }
      }
    }
  }

  cuadradoNpcAntes = cuadradoAhora;
}

// -------------------------
// 28.4 MOSTRAR MENSAJE PARA HABLAR
// -------------------------

void mostrarMensajeNpcBombero() {

  if (
    escenario == 1 &&
    cercaNpcBombero &&
    !dialogoBomberoActivo &&
    !minijuegoIncendiosActivo
  ) {

    pushStyle();

    noStroke();
    fill(0, 190);

    rect(
      width/2 - 90,
      300,
      180,
      40,
      10
    );

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);

    text(
      "□ Hablar",
      width/2,
      320
    );

    popStyle();
  }
}

// -------------------------
// 28.5 DIBUJAR DIÁLOGO
// -------------------------

void dibujarDialogoBombero() {

  if (!dialogoBomberoActivo) {
    return;
  }

  pushStyle();

  // FONDO OSCURO DEL CUADRO
  fill(0, 210);
  noStroke();

  rect(
    80,
    250,
    width - 160,
    110,
    12
  );

  // BORDE
  noFill();
  stroke(255);
  strokeWeight(2);

  rect(
    80,
    250,
    width - 160,
    110,
    12
  );

  noStroke();

  // NOMBRE DEL NPC
  fill(255, 210, 60);
  textAlign(LEFT, TOP);
  textSize(28);

  text(
    "Líder Social",
    100,
    265
  );

  // TEXTO DEL DIÁLOGO
  fill(255);
  textSize(24);

  if (dialogoBombero == 1) {

    text(
      "¡Necesitamos tu ayuda!\nHay varios carteles con propaganda falsa en el barrio.",
      100,
      292
    );

  } else if (dialogoBombero == 2) {

    text(
      "Debes recogerlos antes de que se termine el tiempo.",
      100,
      292
    );

  } else if (dialogoBombero == 3) {

    text(
      "Entre más rápido seas, mayor será tu puntaje.",
      100,
      292
    );
  }

  // INDICACIÓN
  fill(200);
  textAlign(RIGHT, BOTTOM);
  textSize(12);

  text(
    "□ Continuar",
    width - 100,
    345
  );

  popStyle();
}

// =====================================================
// 29. MINIJUEGO - CARTELES ENGAÑOSOS
// =====================================================

// -------------------------
// 29.1 INICIAR MINIJUEGO
// -------------------------

void iniciarMinijuegoIncendios() {

  minijuegoIncendiosActivo = true;
  minijuegoIncendiosTerminado = false;
  resultadoCartelesAplicado = false;
  puntosIncendios = 100;
  incendiosApagados = 0;

  tiempoInicioIncendios = millis();
  ultimoSegundoDescontado = 0;

  // Reactivar todos los incendios
  for (int i = 0; i < incendioActivo.length; i++) {
    incendioActivo[i] = true;
  }

  println("MINIJUEGO DE Carteles INICIADO");
}

// -------------------------
// 29.2 DIBUJAR CARTELES
// -------------------------

void dibujarIncendios() {

  // Solo aparecen durante el minijuego
  if (!minijuegoIncendiosActivo) {
    return;
  }

  if (escenario != 1) {
    return;
  }

  for (int i = 0; i < incendios.length; i++) {

    if (!incendioActivo[i]) {
      continue;
    }

    float x = incendios[i][0];
    float y = incendios[i][1];

    pushStyle();

    rectMode(CENTER);
    noStroke();

    // SOMBRA
    fill(0, 50);

    ellipse(
      x,
      y + 26,
      50,
      12
    );

    // POSTE DEL CARTEL
    fill(90, 65, 45);

    rect(
      x,
      y + 5,
      7,
      48
    );

    // CARTEL
    fill(245, 235, 210);

    stroke(80);
    strokeWeight(2);

    rect(
      x,
      y - 20,
      58,
      45,
      4
    );

    // FRANJA ROJA
    noStroke();

    fill(210, 55, 55);

    rect(
      x,
      y - 32,
      54,
      14,
      2
    );

    // TEXTO DEL CARTEL
    fill(255);

    textAlign(CENTER, CENTER);
    textSize(9);

    text(
      "¡URGENTE!",
      x,
      y - 32
    );

    fill(40);
    textSize(8);

    text(
      "COMPÁRTELO\nYA!",
      x,
      y - 15
    );

    // SIGNO DE ALERTA
    fill(220, 50, 50);
    textSize(12);

    text(
      "!",
      x + 21,
      y - 5
    );

    rectMode(CORNER);

    popStyle();
  }
}

// -------------------------
// 29.3 DETECTAR CARTEL CERCANO
// -------------------------

void revisarIncendioCercano() {

  incendioCercano = -1;

  // Solo revisar durante el minijuego
  if (!minijuegoIncendiosActivo) {
    return;
  }

  // Solo en el Barrio
  if (escenario != 1) {
    return;
  }

  for (int i = 0; i < incendios.length; i++) {

    // Si ya fue apagado, ignorarlo
    if (!incendioActivo[i]) {
      continue;
    }

    float distanciaIncendio = dist(
      jugadorX,
      jugadorY,
      incendios[i][0],
      incendios[i][1]
    );

    if (distanciaIncendio < 65) {

      incendioCercano = i;
      break;
    }
  }
}

// -------------------------
// 29.4 RETIRAR CARTEL CON X
// -------------------------

void apagarIncendio() {

  if (!minijuegoIncendiosActivo) {
    return;
  }

  if (!mandoConectado) {
    return;
  }

  boolean xAhora = botonX.pressed();

  if (
    incendioCercano != -1 &&
    xAhora &&
    !xIncendioAntes
  ) {

    // APAGAR INCENDIO
    incendioActivo[incendioCercano] = false;

    incendiosApagados++;

    // SUMAR PUNTOS
    puntosIncendios += 20;

    println(
      "INCENDIO APAGADO - PUNTOS: "
      + puntosIncendios
    );
  }

  xIncendioAntes = xAhora;
}

// -------------------------
// 29.5 MOSTRAR MENSAJE X RETIRAR
// -------------------------

void mostrarMensajeIncendio() {

  if (
    minijuegoIncendiosActivo &&
    incendioCercano != -1
  ) {

    pushStyle();

    noStroke();
    fill(0, 190);

    rect(
      width/2 - 90,
      300,
      180,
      40,
      10
    );

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);

    text(
      "X  Retirar cartel",
      width/2,
      320
    );

    popStyle();
  }
}

// -------------------------
// 29.6 TIEMPO Y FINAL DEL MINIJUEGO
// -------------------------

void actualizarMinijuegoIncendios() {

  if (!minijuegoIncendiosActivo) {
    return;
  }

  int segundosPasados =
  (millis() - tiempoInicioIncendios) / 1000;

  int tiempoRestante =
  duracionMinijuego - segundosPasados;

  // RESTAR 1 PUNTO CADA SEGUNDO
  if (segundosPasados > ultimoSegundoDescontado) {

    puntosIncendios--;

    ultimoSegundoDescontado = segundosPasados;

    if (puntosIncendios < 0) {
      puntosIncendios = 0;
    }
  }

  // SE ACABÓ EL TIEMPO
  if (tiempoRestante <= 0) {

    minijuegoIncendiosActivo = false;
    minijuegoIncendiosTerminado = true;

    println("TIEMPO AGOTADO");
  }

  // APAGÓ TODOS
  if (incendiosApagados >= incendios.length) {

    minijuegoIncendiosActivo = false;
    minijuegoIncendiosTerminado = true;
    aplicarResultadoCarteles();

    println("TODOS LOS CARTELES RECOGIDOS");
  }
  if (tiempoRestante <= 0) {

    minijuegoIncendiosActivo = false;
    minijuegoIncendiosTerminado = true;
    aplicarResultadoCarteles();

    println("TIEMPO AGOTADO");
  }
}

// -------------------------
// 29.7 RESULTADO Y REPUTACIÓN
// -------------------------

void aplicarResultadoCarteles() {

  if (resultadoCartelesAplicado) {
    return;
  }

  resultadoCartelesAplicado = true;

  float porcentaje =
  (float) incendiosApagados / incendios.length;

  // =====================================================
  // EXCELENTE - RETIRÓ 80% O MÁS
  // =====================================================

  if (porcentaje >= 0.80) {

    cambiarIndicadores(
      +15,  // Información
      +10,  // Convivencia
      +5,   // Bienestar digital
      +10,  // Participación
      +15   // Reputación
    );

    println("RESULTADO EXCELENTE");
    println("Informacion +15");
    println("Convivencia +10");
    println("Bienestar +5");
    println("Participacion +10");
    println("Reputacion +15");

    // =====================================================
    // REGULAR - RETIRÓ ENTRE 50% Y 79%
    // =====================================================

  } else if (porcentaje >= 0.50) {

    cambiarIndicadores(
      +5,   // Información
      +3,   // Convivencia
      0,    // Bienestar digital
      +5,   // Participación
      +5    // Reputación
    );

    println("RESULTADO REGULAR");
    println("Informacion +5");
    println("Convivencia +3");
    println("Participacion +5");
    println("Reputacion +5");

    // =====================================================
    // MALO - RETIRÓ MENOS DEL 50%
    // =====================================================

  } else {

    cambiarIndicadores(
      -10,  // Información
      -5,   // Convivencia
      0,   // Bienestar digital
      -10,   // Participación
      -20   // Reputación
    );

    println("RESULTADO MALO");
    println("Informacion -10");
    println("Convivencia -5");
    println("Bienestar -0");
    println("Participacion -10");
    println("Reputacion -20");
  }
}

// -------------------------
// 29.8 HUD DEL MINIJUEGO
// -------------------------

void dibujarHUDIncendios() {

  if (!minijuegoIncendiosActivo) {
    return;
  }

  int segundosPasados =
  (millis() - tiempoInicioIncendios) / 1000;

  int tiempoRestante =
  duracionMinijuego - segundosPasados;

  tiempoRestante =
  max(tiempoRestante, 0);

  pushStyle();

  noStroke();

  fill(0, 190);

  rect(
    width - 300,
    15,
    280,
    85,
    12
  );

  fill(255);

  textAlign(LEFT, TOP);

  textSize(15);

  text(
    "CARTELES: " +
    incendiosApagados +
    " / " +
    incendios.length,
    width - 280,
    28
  );

  text(
    "PUNTOS: " +
    puntosIncendios,
    width - 280,
    52
  );

  text(
    "TIEMPO: " +
    tiempoRestante + " s",
    width - 280,
    76
  );

  popStyle();
}
void dibujarPuntosAcopioColegio() {

  if (escenario != 2) {
    return;
  }

  // Si no hay una publicación seleccionada,
  // no mostramos ningún punto
  if (puntoAcopioActual == -1) {
    return;
  }

  float x = puntosAcopioColegio[puntoAcopioActual][0];
  float y = puntosAcopioColegio[puntoAcopioActual][1];

  pushStyle();

  // CÍRCULO DEL OBJETIVO
  noFill();
  stroke(255, 220, 0);
  strokeWeight(4);

  ellipse(
    x,
    y,
    80,
    80
  );

  // PUNTO CENTRAL
  noStroke();
  fill(255, 220, 0);

  ellipse(
    x,
    y,
    18,
    18
  );

  // NOMBRE DEL LUGAR
  fill(0, 190);

  rect(
    x - 100,
    y - 70,
    200,
    35,
    8
  );

  fill(255);

  textAlign(CENTER, CENTER);
  textSize(14);

  text(
    nombresPuntosColegio[puntoAcopioActual],
    x,
    y - 52
  );

  popStyle();
}
void dibujarConectaColegio() {
  if (
    publicacionColegioActual != -1 &&
    publicacionVerificadaColegio[publicacionColegioActual]
  ) {

    dibujarResultadoInvestigacionColegio();
    return;
  }
  fill(255);
  textAlign(CENTER, CENTER);

  textSize(18);
  text(
    "TENDENCIAS ELECTORALES EN EL COLEGIO",
    width/2,
    90
  );

  textSize(13);
  fill(190);

  text(
    "Selecciona una situación para investigarla",
    width/2,
    120
  );

  // =====================================================
  // PUBLICACIÓN 1
  // =====================================================
  if (!crisisColegioResuelta[0]){

    fill(35, 42, 55);
    stroke(80);
    strokeWeight(2);

    rect(
      width/2 - 170,
      155,
      340,
      110,
      10
    );

    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[0],
      width/2 - 150,
      170,
      300,
      50
    );

    fill(255, 100, 100);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[0]) + "%",
      width/2 - 150,
      230
    );

  }
  // =====================================================
  // PUBLICACIÓN 2
  // =====================================================
  if (!crisisColegioResuelta[1]) {
    fill(35, 42, 55);
    stroke(80);

    rect(
      width/2 - 170,
      285,
      340,
      110,
      10
    );

    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[1],
      width/2 - 150,
      300,
      300,
      50
    );

    fill(255, 100, 100);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[1]) + "%",
      width/2 - 150,
      360
    );

  }
  // =====================================================
  // PUBLICACIÓN 3
  // =====================================================
  if (!crisisColegioResuelta[2]) {
    fill(35, 42, 55);
    stroke(80);

    rect(
      width/2 - 170,
      415,
      340,
      110,
      10
    );

    fill(255);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[2],
      width/2 - 150,
      430,
      300,
      50
    );

    fill(255, 100, 100);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[2]) + "%",
      width/2 - 150,
      490
    );
  }

  // =====================================================
  // CONTROLES
  // =====================================================

  fill(200);
  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "L1 = Primera   R1 = Segunda   L2 = Tercera",
    width/2,
    560
  );
}
void revisarPuntoAcopioColegio() {

  if (!minijuegoColegioActivo) {
    return;
  }

  if (escenario != 2) {
    return;
  }

  if (puntoAcopioActual == -1) {
    return;
  }

  float x = puntosAcopioColegio[puntoAcopioActual][0];
  float y = puntosAcopioColegio[puntoAcopioActual][1];

  float distancia = dist(
    jugadorX,
    jugadorY,
    x,
    y
  );

  // Si está cerca del punto
  if (distancia < 80) {

    pushStyle();

    fill(0, 190);
    noStroke();

    rect(
      width/2 - 120,
      300,
      240,
      45,
      10
    );

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);

    text(
      "X  Comprobar situación",
      width/2,
      322
    );

    popStyle();
  }
}
void comprobarSituacionColegio() {

  if (!minijuegoColegioActivo) {
    return;
  }

  if (escenario != 2) {
    return;
  }

  if (puntoAcopioActual == -1) {
    return;
  }

  if (!mandoConectado) {
    return;
  }

  float x = puntosAcopioColegio[puntoAcopioActual][0];
  float y = puntosAcopioColegio[puntoAcopioActual][1];

  float distancia = dist(
    jugadorX,
    jugadorY,
    x,
    y
  );

  boolean xAhora = botonX.pressed();

  if (
    distancia < 80 &&
    xAhora &&
    !XpresionadoAntes
  ) {

    // Marca esta publicación como verificada
    publicacionVerificadaColegio[publicacionColegioActual] = true;

    // Ya no necesitamos mostrar el punto
    puntoAcopioActual = -1;

    println(
      "SITUACION COMPROBADA: "
      + publicacionColegioActual
    );
  }

  XpresionadoAntes = xAhora;
}
void dibujarResultadoInvestigacionColegio() {

  if (publicacionColegioActual == -1) {
    return;
  }

  if (!publicacionVerificadaColegio[publicacionColegioActual]) {
    return;
  }

  fill(255);
  textAlign(CENTER, TOP);
  textSize(18);

  text(
    "RESULTADO DE LA VERIFICACIÓN",
    width/2,
    105
  );

  fill(200);
  textSize(14);

  if (publicacionColegioActual == 0) {

    text(
      "El video estaba recortado y sacado de contexto.\n" +
      "La propuesta completa no decía que se eliminarían\n" +
      "los apoyos estudiantiles.",
      width/2,
      155
    );

  } else if (publicacionColegioActual == 1) {

    text(
      "La encuesta solo se realizó a un grupo pequeño\n" +
      "de estudiantes y no representa a todo el colegio.\n" +
      "El porcentaje publicado exagera el resultado.",
      width/2,
      155
    );
  } else if (publicacionColegioActual == 2) {

    text(
      "El foro electoral continúa con normalidad.\n" +
      "No hubo disturbios ni fue suspendido.\n" +
      "La publicación difundió un rumor falso.",
      width/2,
      155
    );
  }

  // =====================================================
  // OPCIONES
  // =====================================================

  textSize(14);
  fill(255);

  text(
    "¿Qué quieres hacer en Conecta?",
    width/2,
    265
  );

  dibujarBotonOpcion(
    width/2 - 170,
    310,
    "L1. Compartir publicación",
    color(220, 80, 80)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    365,
    "R1. Reportar / corregir",
    color(80, 180, 100)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    420,
    "L2. Ignorar",
    color(120, 130, 140)
  );
}
void procesarDecisionColegio(int opcion) {

  if (publicacionColegioActual == -1) {
    return;
  }

  int i = publicacionColegioActual;

  // =====================================================
  // 1 = COMPARTIR
  // =====================================================
  if (opcion == 1) {

    viralidadColegio[i] += 20;

    cambiarIndicadores(
      -10,  // Información
      -5,   // Convivencia
      -5,   // Bienestar
      +5,   // Participación
      -10   // Reputación
    );
  }

  // =====================================================
  // 2 = REPORTAR / CORREGIR
  // =====================================================
  else if (opcion == 2) {

    viralidadColegio[i] -= 25;

    cambiarIndicadores(
      +10,
      +10,
      +5,
      +10,
      +10
    );
  }

  // =====================================================
  // 3 = IGNORAR
  // =====================================================
  else if (opcion == 3) {

    cambiarIndicadores(
      0,
      -5,
      0,
      0,
      -5
    );
  }

  // =====================================================
  // MARCAR ESTA CRISIS COMO RESUELTA
  // =====================================================

  crisisColegioResuelta[i] = true;

  crisisColegioCompletadas++;

  // Ya no hay una publicación seleccionada
  publicacionColegioActual = -1;

  // Ya no hay punto de acopio activo
  puntoAcopioActual = -1;

  // Cerrar Conecta
  redSocialAbierta = false;

  println(
    "CRISIS DEL COLEGIO RESUELTA: " + i
  );
}

// =====================================================
// 30. MINIJUEGO - DEBATE CIUDADANO EN PLAZA NOVA
// =====================================================

void iniciarMinijuegoPlaza() {
  aciertosPlaza = 0;
  desaciertosPlaza = 0;
  comentarioActualPlaza = 0;
  minijuegoPlazaActivo = true;
  minijuegoPlazaTerminado = false;
  l1PlazaAntes = false;
  r1PlazaAntes = false;
}

void revisarInteraccionNpcLaura() {
  cercaNpcLaura = false;

  if (escenario != 3) {
    return;
  }

  float distanciaLaura = dist(
    jugadorX,
    jugadorY,
    npcLauraX,
    npcLauraY
  );

  if (distanciaLaura < 80) {
    cercaNpcLaura = true;
  }
}

void controlarDialogoLaura() {
  if (!mandoConectado) {
    return;
  }

  boolean cuadradoAhora = botonCuadrado.pressed();

  if (
    escenario == 3 &&
    cercaNpcLaura &&
    !minijuegoPlazaActivo &&
    cuadradoAhora &&
    !cuadradoLauraAntes
  ) {
    if (!dialogoLauraActivo) {
      dialogoLauraActivo = true;
      dialogoLaura = 1;
    } else if (crisisColegioCompletadas < 3) {
      dialogoLauraActivo = false;
      dialogoLaura = 0;
    } else {
      dialogoLaura++;

      if (dialogoLaura > 3) {
        dialogoLauraActivo = false;
        dialogoLaura = 0;
        iniciarMinijuegoPlaza();
      }
    }
  }

  cuadradoLauraAntes = cuadradoAhora;
}

void dibujarDialogoLaura() {
  if (!dialogoLauraActivo) {
    return;
  }

  pushStyle();

  fill(0, 210);
  noStroke();
  rect(
    80,
    250,
    width - 160,
    125,
    12
  );

  noFill();
  stroke(255);
  strokeWeight(2);
  rect(
    80,
    250,
    width - 160,
    125,
    12
  );

  noStroke();
  fill(255, 210, 60);
  textAlign(LEFT, TOP);
  textSize(28);
  text("Laura", 100, 265);

  fill(255);
  textSize(20);

  if (crisisColegioCompletadas < 3) {
    text(
      "Primero debes resolver los problemas del Colegio.",
      100,
      300
    );
  } else if (dialogoLaura == 1) {
    text(
      "En este debate circulan comentarios reales y mensajes de bots.",
      100,
      300
    );
  } else if (dialogoLaura == 2) {
    text(
      "Analiza cada comentario y decide si viene de un ciudadano real.",
      100,
      300
    );
  } else if (dialogoLaura == 3) {
    text(
      "Usa L1 para Ciudadano Real y R1 para Bot / Desinformación.",
      100,
      300
    );
  }

  fill(200);
  textAlign(RIGHT, BOTTOM);
  textSize(12);
  text("□ Continuar", width - 100, 360);

  popStyle();
}

void actualizarMinijuegoPlaza() {
  if (!minijuegoPlazaActivo) {
    l1PlazaAntes = false;
    r1PlazaAntes = false;
    return;
  }

  if (!mandoConectado) {
    return;
  }

  boolean l1Ahora = botonL1.pressed();
  boolean r1Ahora = botonR1.pressed();

  if (l1Ahora && !l1PlazaAntes) {
    evaluarComentarioPlaza(false);
  } else if (r1Ahora && !r1PlazaAntes) {
    evaluarComentarioPlaza(true);
  }

  l1PlazaAntes = l1Ahora;
  r1PlazaAntes = r1Ahora;
}

void evaluarComentarioPlaza(boolean respuestaBot) {
  if (
    comentarioActualPlaza < 0 ||
    comentarioActualPlaza >= comentariosPlaza.length
  ) {
    return;
  }

  if (respuestaBot == respuestaCorrectaPlaza[comentarioActualPlaza]) {
    aciertosPlaza++;
  } else {
    desaciertosPlaza++;
  }

  comentarioActualPlaza++;

  if (comentarioActualPlaza >= comentariosPlaza.length) {
    minijuegoPlazaActivo = false;
    minijuegoPlazaTerminado = true;
    aplicarResultadoPlaza();
  }
}

void dibujarMinijuegoPlaza() {
  if (
    !minijuegoPlazaActivo ||
    comentarioActualPlaza < 0 ||
    comentarioActualPlaza >= comentariosPlaza.length
  ) {
    return;
  }

  pushStyle();

  noStroke();
  fill(0, 220);
  rect(
    120,
    120,
    width - 240,
    420,
    14
  );

  fill(255);
  textAlign(CENTER, TOP);
  textSize(22);
  text(
    "DEBATE CIUDADANO - PLAZA NOVA",
    width / 2,
    145
  );

  fill(220);
  textSize(13);
  text(
    "Comentario " +
    (comentarioActualPlaza + 1) +
    " de " +
    comentariosPlaza.length,
    width / 2,
    180
  );

  fill(255);
  textSize(20);
  text(
    comentariosPlaza[comentarioActualPlaza],
    170,
    225,
    width - 340,
    100
  );

  fill(80, 160, 220);
  rect(
    width / 2 - 260,
    400,
    220,
    55,
    10
  );

  fill(220, 90, 90);
  rect(
    width / 2 + 40,
    400,
    220,
    55,
    10
  );

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("L1  Ciudadano Real", width / 2 - 150, 428);
  text("R1  Bot / Desinformación", width / 2 + 150, 428);

  popStyle();
}

void aplicarResultadoPlaza() {
  if (aciertosPlaza >= 5) {
    cambiarIndicadores(
      +15,
      +10,
      +10,
      +15,
      +15
    );
    println("RESULTADO PLAZA: EXCELENTE");
  } else if (aciertosPlaza >= 3) {
    cambiarIndicadores(
      +5,
      +5,
      +5,
      +5,
      +5
    );
    println("RESULTADO PLAZA: REGULAR");
  } else {
    cambiarIndicadores(
      -10,
      -5,
      -5,
      -10,
      -15
    );
    println("RESULTADO PLAZA: MALO");
  }
}

void dibujarNpcLaura() {
  pushStyle();

  noStroke();
  fill(0, 50);
  ellipse(npcLauraX, npcLauraY + 34, 32, 10);

  fill(40);
  rect(npcLauraX - 8, npcLauraY + 15, 6, 20);
  rect(npcLauraX + 2, npcLauraY + 15, 6, 20);

  fill(80, 130, 200);
  rect(npcLauraX - 13, npcLauraY - 8, 26, 25, 4);

  fill(230, 180, 140);
  ellipse(npcLauraX, npcLauraY - 18, 22, 22);

  fill(255, 230, 70);
  textAlign(CENTER);
  textSize(20);
  text("L", npcLauraX, npcLauraY - 42);

  popStyle();
}
