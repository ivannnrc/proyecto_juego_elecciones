import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ControlIO control;
ControlDevice mando;

ControlSlider joystickX;
ControlSlider joystickY;
ControlButton botonCuadrado;

ControlButton botonL1;
ControlButton botonR1;
ControlButton botonL2;

boolean cuadradoPresionadoAntes = false;
boolean l1PresionadoAntes = false;
boolean r1PresionadoAntes = false;
boolean l2PresionadoAntes = false;
boolean izquierdaAntes = false;
boolean arribaAntes = false;
boolean derechaAntes = false;

boolean mandoConectado = false;

// VARIABLES DE DIÁLOGOS Y MISIONES
boolean dialogoActivo = false;
String hablanteActual = "";
String textoDialogoActual = "";
int misionActual = 1;
boolean teclaEPresionadaAntes = false;

int[] pubDecisiones = {0, 0, 0};

// =====================================================
// NOVA / CONECTA - versión con mundos amplios y cámara
// =====================================================

// VARIABLES GENERALES Y NAVEGACIÓN
int escenario = 1; // 1: BARRIO, 2: COLEGIO, 3: ELECCIÓN/PLAZA

// Tipos de objetos del mundo (se dibujan ordenados por profundidad)
final int T_ARBOL = 0, T_CASA = 1, T_BANCA = 2, T_FAROLA = 3, T_FUENTE = 4, T_PERSONA = 5, T_PUESTO = 6;

// Tamaño del mundo (cambia según el escenario)
int mundoW = 2600;
int mundoH = 900;

// Cámara (esquina superior izquierda de lo que se ve, en coordenadas del mundo)
float camX = 0;
float camY = 0;

// Obstáculos {x, y, ancho, alto} y objetos {tipo, x, yBase, variante}
ArrayList<float[]> obstaculos = new ArrayList<float[]>();
ArrayList<float[]> objetos = new ArrayList<float[]>();
boolean verColisiones = false; // tecla H para depurar

// INDICADORES DE LA CIUDAD DE NOVA
int informacion = 50;
int convivencia = 50;
int bienestar = 50;
int participacion = 50;
int reputacion = 50;

// ARREGLOS DE LA RED SOCIAL CONECTA
String[] pubTitulos = {
  "¡Torneo deportivo en el parque del barrio!",
  "¡Fotografía subida sin permiso en el recreo!",
  "URGENTE: Candidato propone cerrar el colegio"
};
int[] pubEscenarios = {1, 2, 3};
String[] pubAutores = {"@vecinos_nova", "@anonimo_04", "@periodico_local"};
int[] pubConfiabilidad = {85, 30, 45};
int[] pubViralidad = {40, 75, 90};
boolean[] pubProcesadas = {false, false, false};

boolean redSocialAbierta = false;

// VARIABLES DEL JUGADOR
float jugadorX = 500;
float jugadorY = 300;
float velocidadJugador = 3;
float animacionCaminar = 0;

boolean moverArriba = false;
boolean moverAbajo = false;
boolean moverIzquierda = false;
boolean moverDerecha = false;
boolean jugadorCaminando = false;

// SETUP

void setup() {
  size(1000, 400);
  cargarEscenario(1);

  // CONECTAR MANDO
  control = ControlIO.getInstance(this);
  mando = null;

  for (int i = 0; i < control.getNumberOfDevices(); i++) {
    ControlDevice dispositivo = control.getDevice(i);
    println(i + ": " + dispositivo.getName());
    String nombre = dispositivo.getName().toLowerCase();

    if (
      nombre.contains("wireless controller") ||
      nombre.contains("dualshock") ||
      nombre.contains("ps4") 
    ) {
      mando = dispositivo;
      break;
    }
  }

  if (mando != null) {
    println("MANDO ENCONTRADO: " + mando.getName());
    joystickX = mando.getSlider(0);
    joystickY = mando.getSlider(1);

    botonCuadrado = mando.getButton(4);
    botonL1 = mando.getButton(5);
    botonR1 = mando.getButton(6);
    botonL2 = mando.getButton(7);

    mandoConectado = true;
  } else {
    println("NO SE ENCONTRO EL MANDO");
    mandoConectado = false;
  }
}

// DRAW

void draw() {
  // ABRIR / CERRAR CONECTA CON MANDO
  if (mandoConectado) {
    boolean cuadradoAhora = botonCuadrado.pressed();
    if (cuadradoAhora && !cuadradoPresionadoAntes) {
      redSocialAbierta = !redSocialAbierta;
    }
    cuadradoPresionadoAntes = cuadradoAhora;
  }

  if (mandoConectado && redSocialAbierta) {
    boolean l1Ahora = botonL1.pressed();
    boolean r1Ahora = botonR1.pressed();
    boolean l2Ahora = botonL2.pressed();

    int idx = obtenerIndicePublicacion(escenario);

    if (idx != -1 && !pubProcesadas[idx]) {
      if (l1Ahora && !l1PresionadoAntes) procesarDecision(idx, 1);
      if (r1Ahora && !r1PresionadoAntes) procesarDecision(idx, 2);
      if (l2Ahora && !l2PresionadoAntes) procesarDecision(idx, 3);
    }

    l1PresionadoAntes = l1Ahora;
    r1PresionadoAntes = r1Ahora;
    l2PresionadoAntes = l2Ahora;
  }

  // MOVIMIENTO DEL JUGADOR
  if (!redSocialAbierta && !dialogoActivo) {
    moverJugador();
  }

  actualizarCamara();
  revisarCambioEscenario();

  // 1. DIBUJAR EL MUNDO DESPLAZADO POR LA CÁMARA
  noStroke();
  strokeWeight(1);
  pushMatrix();
  translate(-round(camX), -round(camY));
  
  pushStyle();
  if (escenario == 1) {
    fondoBarrio();
  } else if (escenario == 2) {
    fondoColegio();
  } else {
    fondoPlaza();
  }
  popStyle();

  pushStyle();
  dibujarObjetosYJugador();
  if (verColisiones) dibujarColisiones();
  
  // DIBUJAR INDICADOR FLOTANTE SOBRE EL NPC (Dentro de la transformación de la cámara)
  gestionarNPCsPorEscenario();
  popStyle();

  popMatrix();

  // 2. TEXTO DE CONTROLES E INDICADORES (HUD fijo en pantalla)
  noStroke();
  fill(0, 150);
  rect(0, 372, width, 28);
  textSize(14);
  textAlign(LEFT);
  fill(255);
  text("1: Barrio   2: Colegio   3: Plaza     WASD: Moverse     E: Hablar     C: Conecta", 15, 390);

  mostrarIndicadores();

  // 3. INTERFAZ DE RED SOCIAL
  gestionarRedSocialGUI();

  // 4. DIBUJAR CUADRO DE DIÁLOGO (Si está activo)
  if (dialogoActivo) {
    dibujarDialogo();
  }
}

// =====================================================
// CÁMARA (SCROLLING ESTILO POKÉMON)
// =====================================================

void actualizarCamara() {
  camX = constrain(jugadorX - width / 2.0, 0, mundoW - width);
  camY = constrain(jugadorY - height / 2.0, 0, mundoH - height);
}

void revisarCambioEscenario() {
  if (escenario == 1) {
    if (jugadorX > mundoW - 40) {
      cargarEscenario(2);
      jugadorX = 80;
      jugadorY = 500;
    }
  } else if (escenario == 2) {
    if (jugadorX < 40) {
      cargarEscenario(1);
      jugadorX = mundoW - 80;
      jugadorY = 455;
    } else if (jugadorX > mundoW - 40) {
      cargarEscenario(3);
      jugadorX = 80;
      jugadorY = 520;
    }
  } else if (escenario == 3) {
    if (jugadorX < 50) {
      cargarEscenario(2);
      jugadorX = mundoW - 80;
      jugadorY = 500;
    }
  }
}

// =====================================================
// CARGA DE ESCENARIOS
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

// Construcción de mundos

void construirBarrio() {
  for (int i = 0; i < 8; i++) addCasa(100 + i * 320, 330, i % 3);
  for (int i = 0; i < 7; i++) addArbol(370 + i * 320, 345);
  for (int x = 60; x < mundoW; x += 210) addArbol(x, 110 + ((x / 210) % 2) * 30);
  for (int x = 250; x < mundoW; x += 400) {
    addFarola(x, 372, 0);
    addFarola(x + 200, 548, 0);
  }
  addFuente(900, 740);
  addBanca(760, 790);
  addBanca(1040, 790);
  addBanca(900, 610);
  float[][] arb = {
    {120, 650}, {260, 830}, {420, 640}, {560, 870}, {700, 880}, {240, 720},
    {1180, 860}, {1300, 640}, {1380, 880}, {1440, 720}, {2420, 700}, {2400, 870}, {2500, 620}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  addPersona(1580, 575);
  addPersona(1650, 575);
  addPersona(2150, 575);
  addPersona(2230, 575);
  addPersona(500, 610); // DON CARLOS
  addPersona(1250, 640);
  addPersona(400, 800);
  addPersona(1900, 700);
  addPersona(1850, 760);
}

void construirColegio() {
  obs(0, 0, mundoW, 115);
  obs(0, 930, mundoW, 70);
  addCasa(120, 860, 1);
  addCasa(1660, 870, 2);
  addFarola(1000, 230, 1);
  addFarola(915, 300, 0);
  addFarola(1085, 300, 0);
  addFarola(915, 520, 0);
  addFarola(1085, 520, 0);
  addFuente(450, 420);
  addBanca(250, 300);
  addBanca(650, 300);
  addBanca(250, 520);
  addBanca(650, 520);
  addBanca(1500, 530);
  addBanca(1620, 530);

  float[][] arb = {
    {60, 230}, {60, 500}, {1850, 250}, {1930, 420}, {1900, 540},
    {60, 700}, {400, 760}, {600, 700}, {680, 880}, {1240, 760},
    {1400, 900}, {1560, 700}, {1940, 760}, {1930, 640}, {800, 640}, {1200, 640}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  addPersona(700, 420); // SOFÍA
  addPersona(1380, 330);
  addPersona(1620, 300);
  addPersona(1480, 500);
  addPersona(600, 590);
  addPersona(1200, 600);
  addPersona(350, 400);
  addPersona(540, 440);
}

void construirPlaza() {
  obs(0, 0, mundoW, 150);
  obs(960, 180, 260, 150);
  obs(670, 220, 160, 100);
  obs(1370, 220, 160, 100);
  addFuente(1100, 430);
  addFuente(1100, 830);
  addBanca(960, 450);
  addBanca(1240, 450);
  addBanca(960, 880);
  addBanca(1240, 880);
  addPuesto(400, 330);
  addPuesto(1800, 330);
  addPuesto(300, 640);
  addPuesto(500, 640);
  addPuesto(1700, 640);
  addPuesto(1900, 640);
  dibujarJardineraObs(300, 780, 160, 70);
  dibujarJardineraObs(1740, 780, 160, 70);

  for (int x = 400; x < mundoW; x += 300) addFarola(x, 560, 0);

  float[][] arb = {
    {100, 240}, {260, 230}, {1940, 230}, {2100, 240}, {100, 500}, {2100, 500},
    {100, 760}, {2100, 760}, {100, 960}, {2100, 960}, {620, 960}, {1600, 960}
  };
  for (float[] a : arb) addArbol(a[0], a[1]);

  addPersona(880, 300); // LAURA
  addPersona(930, 330);
  addPersona(1260, 310);
  addPersona(1310, 340);
  addPersona(850, 355);
  addPersona(1350, 355);
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
// DIBUJO DE OBJETOS
// =====================================================

void dibujarObjetosYJugador() {
  float baseJugador = jugadorY + 26;
  boolean jugadorDibujado = false;

  for (float[] o : objetos) {
    if (!jugadorDibujado && o[2] > baseJugador) {
      dibujarJugador();
      jugadorDibujado = true;
    }
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

// Escenarios
void fondoBarrio() {
  background(120, 190, 100);
  noStroke();
  fill(110, 180, 92);
  for (int x = 0; x < mundoW; x += 200) {
    for (int y = 0; y < mundoH; y += 200) {
      if (((x / 200) + (y / 200)) % 2 == 0) rect(x, y, 200, 200);
    }
  }
  for (int i = 0; i < 8; i++) {
    float hx = 100 + i * 320;
    fill(200, 185, 160);
    rect(hx + 85, 330, 50, 35);
    dibujarFlores(hx + 10, 338, 60, 22);
    dibujarFlores(hx + 150, 338, 60, 22);
  }
  fill(170);
  rect(0, 365, mundoW, 15);
  fill(70);
  rect(0, 380, mundoW, 160);
  fill(250, 220, 80);
  for (int x = 20; x < mundoW; x += 100) rect(x, 455, 50, 8);
  fill(240);
  for (int y = 385; y < 535; y += 20) rect(1240, y, 70, 10);
  fill(170);
  rect(0, 540, mundoW, 15);
  fill(215, 205, 180);
  rect(870, 555, 60, 120);
  ellipse(900, 715, 460, 230);
  dibujarFlores(1130, 600, 120, 40);
  dibujarFlores(560, 700, 120, 40);
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
  fill(40, 60, 140);
  rect(1750, 556, 300, 32, 8);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("TORNEO DEPORTIVO", 1900, 571);
  textAlign(LEFT, BASELINE);
}

void fondoColegio() {
  background(190, 190, 170);
  noStroke();
  stroke(178, 178, 158);
  strokeWeight(1);
  for (int x = 0; x < mundoW; x += 100) line(x, 120, x, mundoH);
  for (int y = 120; y < mundoH; y += 100) line(0, y, mundoW, y);
  noStroke();
  fill(120, 175, 100);
  rect(0, 620, 860, 380);
  rect(1140, 620, 860, 380);
  fill(215, 210, 190);
  rect(930, 120, 140, 880);
  rect(0, 540, mundoW, 70);
  ellipse(450, 400, 420, 200);
  dibujarFlores(120, 200, 200, 30);
  dibujarFlores(720, 200, 200, 30);
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
  fill(250, 245, 225);
  rect(925, 2, 150, 24, 4);
  fill(50);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("COLEGIO NOVA", 1000, 14);
  textAlign(LEFT, BASELINE);
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
  fill(140, 115, 85);
  rect(0, 940, mundoW, 6);
  rect(0, 965, mundoW, 6);
  fill(110, 90, 70);
  for (int x = 0; x < mundoW; x += 30) rect(x, 925, 8, 75);
}

void fondoPlaza() {
  background(175, 220, 245);
  noStroke();
  fill(190, 185, 170);
  rect(0, 155, mundoW, mundoH - 155);
  stroke(160);
  strokeWeight(1);
  for (int x = 0; x < mundoW; x += 50) line(x, 155, x, mundoH);
  for (int y = 155; y < mundoH; y += 50) line(0, y, mundoW, y);
  noStroke();
  fill(205, 200, 185);
  ellipse(1100, 800, 520, 250);
  dibujarJardinera(300, 780, 160, 70);
  dibujarJardinera(1740, 780, 160, 70);

  pushMatrix();
  translate(600, 0);
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
  fill(230);
  rect(70, 220, 160, 100);
  fill(180, 60, 60);
  rect(70, 220, 160, 25);
  fill(50);
  textSize(16);
  text("CANDIDATO A", 150, 240);
  fill(120, 80, 50);
  rect(90, 275, 120, 25);
  fill(230);
  rect(770, 220, 160, 100);
  fill(70, 100, 190);
  rect(770, 220, 160, 25);
  fill(50);
  text("CANDIDATO B", 850, 240);
  fill(120, 80, 50);
  rect(790, 275, 120, 25);

  float movimiento = sin(frameCount / 20.0) * 3;
  fill(245, 240, 210);
  rect(255, 210 + movimiento, 90, 45);
  fill(50);
  textSize(13);
  text("TU VOTO\nCUENTA", 300, 227 + movimiento);
  popMatrix();

  textAlign(LEFT, BASELINE);
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
// RED SOCIAL
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
  fill(30, 144, 255);
  rect(width - 65, 15, 50, 50, 12);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("📱", width - 40, 38);

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

  fill(20, 25, 35);
  stroke(30, 144, 255);
  strokeWeight(3);
  rect(width/2 - 200, 20, 400, height - 40, 20);

  fill(30, 144, 255);
  rect(width/2 - 200, 20, 400, 45, 20, 20, 0, 0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  String nombreEscenario = (escenario == 1) ? "BARRIO" : (escenario == 2) ? "COLEGIO" : "ELECCIÓN";
  text("RED CONECTA - " + nombreEscenario, width/2, 42);

  int idx = obtenerIndicePublicacion(escenario);

  if (idx != -1 && !pubProcesadas[idx]) {
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

    dibujarBotonOpcion(width/2 - 170, 235, "1 / L1. Compartir", color(220, 80, 80));
    dibujarBotonOpcion(width/2 - 170, 280, "2 / R1. Verificar / Reportar", color(80, 180, 100));
    dibujarBotonOpcion(width/2 - 170, 325, "3 / L2. Ignorar Publicación", color(120, 130, 140));
  } else {
    fill(200);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("No hay publicaciones pendientes\nen esta zona de la ciudad.", width/2, height/2 - 10);
  }

  fill(150);
  textSize(11);
  textAlign(CENTER);
  text("[ Presiona C o Clic en el icono para Cerrar ]", width/2, height - 30);
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

  pubDecisiones[idx] = opcion; // Guardar qué decidió el jugador

  // 1: Compartir (Mala) | 2: Verificar/Reportar (Buena) | 3: Ignorar (Neutral)
  if (opcion == 1) {
    pubViralidad[idx] += 25;
    cambiarIndicadores(-15, -10, -10, +5, -15);
  } else if (opcion == 2) {
    pubViralidad[idx] -= 20;
    cambiarIndicadores(+15, +10, +10, +10, +15);
  } else if (opcion == 3) {
    cambiarIndicadores(0, -5, +5, 0, 0);
  }

  pubProcesadas[idx] = true;

  if (escenario == misionActual) {
    misionActual++;
  }
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
// EVENTOS DE TECLADO Y MOUSE
// =====================================================

void keyPressed() {
  // PROCESAR INTERACCIÓN CON NPCS MEDIANTE TECLA E
  revisarInteraccionTeclado();

  // Abrir / Cerrar Red Social Conecta
  if (key == 'c' || key == 'C') {
    redSocialAbierta = !redSocialAbierta;
  }

  // Responder en Conecta usando números 1, 2, 3
  if (redSocialAbierta) {
    int idx = obtenerIndicePublicacion(escenario);
    if (idx != -1 && !pubProcesadas[idx]) {
      if (key == '1') procesarDecision(idx, 1);
      if (key == '2') procesarDecision(idx, 2);
      if (key == '3') procesarDecision(idx, 3);
    }
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
  if (mouseX >= width - 65 && mouseX <= width - 15 && mouseY >= 15 && mouseY <= 65) {
    redSocialAbierta = !redSocialAbierta;
    return;
  }

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
// MOVIMIENTO Y COLISIONES
// =====================================================

void moverJugador() {
  float dx = 0;
  float dy = 0;
  jugadorCaminando = false;

  if (moverArriba) dy -= 1;
  if (moverAbajo) dy += 1;
  if (moverIzquierda) dx -= 1;
  if (moverDerecha) dx += 1;

  if (mandoConectado) {
    float movimientoX = joystickX.getValue();
    float movimientoY = joystickY.getValue();

    if (abs(movimientoX) < 0.15) movimientoX = 0;
    if (abs(movimientoY) < 0.15) movimientoY = 0;

    dx += movimientoY;
    dy += movimientoX;
  }

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

  dx *= velocidadJugador;
  dy *= velocidadJugador;

  float nx = constrain(jugadorX + dx, 18, mundoW - 18);
  if (!colisiona(nx, jugadorY)) jugadorX = nx;

  float ny = constrain(jugadorY + dy, 40, mundoH - 35);
  if (!colisiona(jugadorX, ny)) jugadorY = ny;
}

boolean colisiona(float x, float y) {
  for (float[] o : obstaculos) {
    if (x + 10 > o[0] && x - 10 < o[0] + o[2] && y + 26 > o[1] && y + 8 < o[1] + o[3]) {
      return true;
    }
  }
  return false;
}

void dibujarJugador() {
  noStroke();
  float movimientoPiernas = 0;
  float movimientoBrazos = 0;

  if (jugadorCaminando) {
    movimientoPiernas = sin(animacionCaminar) * 5;
    movimientoBrazos = sin(animacionCaminar) * 4;
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
  rect(jugadorX + 13, jugadorY - 10 + movimientoBrazos, 5, 18, 3);

  fill(230, 180, 140);
  ellipse(jugadorX, jugadorY - 27, 25, 25);

  fill(60, 40, 30);
  arc(jugadorX, jugadorY - 30, 25, 20, PI, TWO_PI);

  fill(255);
  ellipse(jugadorX, jugadorY - 48, 9, 9);
}

// =====================================================
// INDICADORES
// =====================================================

void mostrarIndicadores() {
  noStroke();
  fill(0, 170);
  rect(15, 15, 230, 145, 10);

  fill(255);
  textAlign(LEFT);
  textSize(16);
  text("ESTADO DE NOVA", 30, 40);

  textSize(13);
  text("Informacion: " + informacion, 30, 65);
  text("Convivencia: " + convivencia, 30, 85);
  text("Bienestar digital: " + bienestar, 30, 105);
  text("Participacion: " + participacion, 30, 125);
  text("Reputacion: " + reputacion, 30, 145);
}

void cambiarIndicadores(int cInf, int cCon, int cBie, int cPar, int cRep) {
  informacion = constrain(informacion + cInf, 0, 100);
  convivencia = constrain(convivencia + cCon, 0, 100);
  bienestar = constrain(bienestar + cBie, 0, 100);
  participacion = constrain(participacion + cPar, 0, 100);
  reputacion = constrain(reputacion + cRep, 0, 100);
}

// =====================================================
// SISTEMA DE DIÁLOGOS Y NPCS
// =====================================================

void dibujarDialogo() {
  if (!dialogoActivo) return;

  pushStyle();
  fill(0, 0, 0, 210);
  stroke(255, 220, 0);
  strokeWeight(2);
  rect(20, 280, 960, 85, 12);

  fill(255, 220, 0);
  textSize(18);
  textAlign(LEFT, TOP);
  text(hablanteActual, 40, 292);

  fill(255);
  textSize(15);
  text(textoDialogoActual, 40, 318, 920, 40);

  fill(180);
  textSize(12);
  textAlign(RIGHT, BOTTOM);
  text("[ Presiona E para cerrar ]", 960, 358);
  popStyle();
}

void revisarInteraccionTeclado() {
  if (key != 'e' && key != 'E') return;

  if (dialogoActivo) {
    dialogoActivo = false;
    return;
  }

  // ==========================================
  // ESCENARIO 1: DON CARLOS (BARRIO)
  // ==========================================
  if (escenario == 1 && dist(jugadorX, jugadorY, 500, 610) < 60) {
    hablanteActual = "Don Carlos";

    if (!pubProcesadas[0]) {
      textoDialogoActual = "¡Hola! En redes dicen que van a cancelar el torneo del parque. Abre Conecta (Tecla C) y ayúdanos a verificar ese rumor.";
    } else if (pubDecisiones[0] == 2) { // Verificar/Reportar
      textoDialogoActual = "¡Excelente trabajo! Al verificar la fuente demostraste que el rumor era falso. El torneo se realiza hoy. En el Colegio necesitan a alguien responsable como tú.";
    } else if (pubDecisiones[0] == 1) { // Compartir
      textoDialogoActual = "¡Oh no! Compartiste la publicación sin revisar y cundió el pánico. El torneo se suspendió temporalmente. Ve al Colegio, el ambiente allá también está tenso.";
    } else { // Ignorar
      textoDialogoActual = "Ignoraste la publicación... El rumor siguió circulando un poco, pero la gente se calmó. Sofía te está buscando en el Colegio.";
    }
    dialogoActivo = true;
  } 

  // ==========================================
  // ESCENARIO 2: SOFÍA (COLEGIO)
  // ==========================================
  else if (escenario == 2 && dist(jugadorX, jugadorY, 700, 420) < 60) {
    hablanteActual = "Sofía";

    if (!pubProcesadas[0]) {
      textoDialogoActual = "Hola... Primero debes atender la situación en el Barrio antes de ver qué ocurre en el Colegio.";
    } else if (!pubProcesadas[1]) {
      textoDialogoActual = "¡Editaron una foto de mi amigo y la subieron a Conecta sin permiso! Abre la red social (Tecla C) y frena este problema de convivencia.";
    } else if (pubDecisiones[1] == 2) { // Verificar/Reportar
      textoDialogoActual = "¡Gracias por reportar la foto! Lograste detener el acoso escolar a tiempo. Esa misma cuenta falsa está saboteando el debate en la Plaza Electoral.";
    } else if (pubDecisiones[1] == 1) { // Compartir
      textoDialogoActual = "¡No puedo creer que la compartieras! El conflicto en el salón empeoró horriblemente. La persona que creó la foto falsa ahora está operando en la Plaza Electoral.";
    } else { // Ignorar
      textoDialogoActual = "Miraste hacia otro lado... La foto siguió circulando en grupos privados. En la Plaza Electoral la periodista Laura necesita ayuda urgida.";
    }
    dialogoActivo = true;
  } 

  // ==========================================
  // ESCENARIO 3: LAURA (PLAZA ELECTORAL)
  // ==========================================
  else if (escenario == 3 && dist(jugadorX, jugadorY, 880, 300) < 60) {
    hablanteActual = "Laura (Periodista)";

    if (!pubProcesadas[1]) {
      textoDialogoActual = "El debate no tardará en empezar, pero debes resolver primero los asuntos pendientes en el Colegio.";
    } else if (!pubProcesadas[2]) {
      textoDialogoActual = "¡Llegas a tiempo! Hay cuentas bots atacando la campaña del alcalde en Conecta. Abre la red social y toma una postura crítica.";
    } else if (pubDecisiones[2] == 2) { // Verificar/Reportar
      textoDialogoActual = "¡Increíble cobertura! Reportaste la campaña de desinformación y la ciudadanía pudo votar informada. ¡Nova es una ciudad conectada!";
    } else { // Compartir o Ignorar
      textoDialogoActual = "La desinformación se propagó por toda la ciudad durante el debate... Las elecciones terminaron en confusión y tensión social.";
    }
    dialogoActivo = true;
  }
}

void gestionarNPCsPorEscenario() {
  float npcX = 0;
  float npcY = 0;
  boolean mostrarIndicador = false;

  if (escenario == 1) {
    npcX = 500; npcY = 610; mostrarIndicador = true;
  } else if (escenario == 2) {
    npcX = 700; npcY = 420; mostrarIndicador = true;
  } else if (escenario == 3) {
    npcX = 880; npcY = 300; mostrarIndicador = true;
  }

  if (mostrarIndicador && !dialogoActivo && dist(jugadorX, jugadorY, npcX, npcY) < 60) {
    pushStyle();
    fill(255, 255, 0);
    textAlign(CENTER, BOTTOM);
    textSize(14);
    text("[ Presiona E para hablar ]", npcX, npcY - 40);
    popStyle();
  }
}

