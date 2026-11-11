// =====================================================
// NOVA / CONECTA
// JUEGO 2D EN PROCESSING
// ARCHIVO PRINCIPAL - SETUP, DRAW Y EVENTOS
// =====================================================

// =====================================================
// 1. IMPORTS Y LIBRERÍAS
// =====================================================

import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

// =====================================================
// ESTADOS DE JUEGO E INTRODUCCIÓN
// =====================================================

final int ESTADO_INTRO = 0;
final int ESTADO_JUEGO = 1;
final int ESTADO_MINIJUEGO1 = 2;

int estadoJuego = 0;
int slideActual = 1;
int tiempoInicioSlide = 0;
int caracteresVisibles = 0;
int ultimoTipeado = 0;
PFont fuenteConecta;

String[] textosIntro = {
  "Eres un estudiante de último año en el Colegio Nova.",
  "Prepárate...",
  "Faltan solo unos días para las elecciones de alcalde.",
  "¡ALERTA CIUDADANA! Se filtra información sobre las elecciones. El clima en Nova está tenso y tus acciones en la red dejarán una huella.",
  ""
};

// =====================================================
// 9. SETUP
// =====================================================

void setup() {
  size(1500, 900);
  estadoJuego = ESTADO_INTRO;
  slideActual = 1;
  tiempoInicioSlide = millis();
  caracteresVisibles = 0;
  ultimoTipeado = tiempoInicioSlide;
  fuenteTitulo = createFont("Trebuchet MS Bold", 18);
  fuenteCuerpo = createFont("Trebuchet MS", 13);
  fuenteConecta = createFont("Trebuchet MS", 28);

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

  if (estadoJuego == ESTADO_INTRO) {
    pushStyle();
    actualizarControlIntro();
    dibujarIntroSlides();
    popStyle();
    return;
  }

  if (estadoJuego == ESTADO_MINIJUEGO1) {
    pushStyle();
    actualizarMinijuego1();
    popStyle();
    return;
  }

  if (estadoJuego != ESTADO_JUEGO) {
    return;
  }

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
    !minijuegoPlazaActivo &&
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
  dibujarTipConecta();
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
  actualizarControlMinijuego1();
  dibujarAvisoMinijuego1();

}

void actualizarControlIntro() {
  if (!mandoConectado || botonX == null) {
    XpresionadoAntes = false;
    return;
  }

  boolean xAhora = botonX.pressed();
  if (xAhora && !XpresionadoAntes) {
    avanzarSlideIntro();
  }
  XpresionadoAntes = xAhora;
}

void dibujarIntroSlides() {
  actualizarTextoIntro();
  dibujarFondoNovelaGrafica();

  if (slideActual == 5) {
    dibujarCiudadIntro();
    dibujarCelularIntro(textosIntro[3].length());
    int opacidad = (int) constrain(
      (millis() - tiempoInicioSlide) * 255.0 / 1500,
      0,
      255
    );
    noStroke();
    fill(0, opacidad);
    rect(0, 0, width, height);

    if (millis() - tiempoInicioSlide >= 1500) {
      iniciarJuegoDesdeIntro();
    }
    return;
  }

  if (slideActual == 4) {
    dibujarCiudadIntro();
    dibujarCelularIntro(caracteresVisibles);
  } else {
    dibujarTarjetaIntro(slideActual, caracteresVisibles);
  }
  dibujarIndicadorIntro();
}

void actualizarTextoIntro() {
  if (slideActual < 1 || slideActual > 4) {
    return;
  }

  String texto = textosIntro[slideActual - 1];
  int ahora = millis();
  while (caracteresVisibles < texto.length() && ahora - ultimoTipeado >= 32) {
    caracteresVisibles++;
    ultimoTipeado += 32;
  }
}

void dibujarFondoNovelaGrafica() {
  background(45, 52, 54);
  rectMode(CORNER);
  noStroke();
  for (int y = 0; y < height; y += 4) {
    float mezcla = map(y, 0, height, 0, 1);
    fill(lerpColor(color(45, 52, 54), color(72, 76, 66), mezcla));
    rect(0, y, width, 4);
  }

  for (int i = 0; i < 20; i++) {
    float x = (i * 197 + sin(frameCount * 0.012 + i) * 34 + width) % width;
    float desplazamientoY = (frameCount * 0.32 + i * 53) % (height + 20);
    float y = height - desplazamientoY;
    float diametro = 2 + i % 3;
    fill(248, 246, 240, 40);
    ellipse(x, y, diametro, diametro);
  }
}

void dibujarCiudadIntro() {
  noStroke();
  fill(35, 38, 34, 215);
  rect(0, height - 190, width, 190);

  for (int i = 0; i < 11; i++) {
    float edificioW = 92 + (i * 37) % 70;
    float edificioH = 100 + (i * 53) % 125;
    float x = i * 142 - 20;
    float y = height - edificioH;

    fill(38 + i % 3 * 4, 40 + i % 3 * 3, 34 + i % 3 * 3, 240);
    rect(x, y, edificioW, edificioH);
    fill(250, 245, 225, 65);
    for (int ventanaY = (int)y + 18; ventanaY < height - 18; ventanaY += 28) {
      for (int ventanaX = (int)x + 14; ventanaX < x + edificioW - 10; ventanaX += 25) {
        rect(ventanaX, ventanaY, 8, 12, 2);
      }
    }
  }
}

void dibujarTarjetaIntro(int slide, int cantidadCaracteres) {
  float cajaW = width * 0.68;
  float cajaH = 330;
  float cajaX = (width - cajaW) / 2;
  float cajaY = (height - cajaH) / 2 - 12;

  rectMode(CORNER);
  fill(35, 38, 34, 90);
  noStroke();
  rect(cajaX + 8, cajaY + 12, cajaW, cajaH, 20);
  fill(45, 52, 54, 220);
  stroke(108, 92, 231);
  strokeWeight(2);
  rect(cajaX, cajaY, cajaW, cajaH, 20);
  noStroke();

  fill(196, 180, 225);
  textFont(fuenteTitulo);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("N O V A   /   C O N E C T A", width / 2, cajaY + 57);

  String texto = textosIntro[slide - 1];
  String visible = texto.substring(0, min(cantidadCaracteres, texto.length()));
  fill(248, 246, 240);
  textFont(fuenteConecta);
  textSize(slide == 2 ? 42 : 34);
  textAlign(CENTER, CENTER);
  text(visible, cajaX + 52, cajaY + 92, cajaW - 104, cajaH - 135);

  stroke(255, 255, 255, 35);
  strokeWeight(1);
  line(cajaX + 52, cajaY + cajaH - 48, cajaX + cajaW - 52, cajaY + cajaH - 48);
}

void dibujarIndicadorIntro() {
  float pulso = 1 + 0.045 * sin(frameCount * 0.08);
  pushMatrix();
  translate(width / 2, height - 82);
  scale(pulso);
  rectMode(CENTER);
  noStroke();
  fill(108, 92, 231, 210 + 45 * sin(frameCount * 0.08));
  rect(0, 0, 300, 48, 24);
  fill(255);
  textFont(fuenteCuerpo);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("[ PRESIONA X / ENTER ]", 0, 0);
  popMatrix();
}

void dibujarCelularIntro(int cantidadCaracteres) {
  float telefonoW = 410;
  float telefonoH = 690;
  float vibracionX = slideActual == 4 && millis() - tiempoInicioSlide < 1000 ? random(-2, 2) : 0;
  float vibracionY = slideActual == 4 && millis() - tiempoInicioSlide < 1000 ? random(-2, 2) : 0;
  float telefonoX = (width - telefonoW) / 2 + vibracionX;
  float telefonoY = (height - telefonoH) / 2 + vibracionY;
  float tiempoEncendido = millis() - tiempoInicioSlide;
  float iluminacion = constrain(tiempoEncendido / 650.0, 0, 1);
  iluminacion = 1 - sq(1 - iluminacion);

  rectMode(CORNER);
  noStroke();
  for (int i = 5; i >= 1; i--) {
    fill(108, 92, 231, 9 + i * 3);
    rect(
      telefonoX - i * 8,
      telefonoY - i * 8,
      telefonoW + i * 16,
      telefonoH + i * 16,
      32 + i * 3
    );
  }
  fill(60, 50, 40, 100);
  rect(telefonoX - 12, telefonoY - 12, telefonoW + 24, telefonoH + 24, 36);
  fill(60, 50, 40);
  rect(telefonoX, telefonoY, telefonoW, telefonoH, 32);

  color pantallaApagada = color(75, 68, 61);
  color pantallaEncendida = color(245, 235, 210);
  fill(lerpColor(pantallaApagada, pantallaEncendida, iluminacion));
  rect(telefonoX + 14, telefonoY + 18, telefonoW - 28, telefonoH - 36, 24);

  fill(60, 50, 40);
  rect(width / 2 - 48, telefonoY + 7, 96, 20, 10);
  ellipse(width / 2 + 60, telefonoY + 17, 7, 7);

  fill(45, 52, 54, 180 * iluminacion);
  textFont(fuenteCuerpo);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("NOVA  /  CONECTA", telefonoX + telefonoW / 2, telefonoY + 70);

  float entradaBanner = constrain((tiempoEncendido - 350) / 450.0, 0, 1);
  float bannerW = 340 * entradaBanner;
  float bannerX = telefonoX + (telefonoW - bannerW) / 2;
  float bannerY = telefonoY + 115;
  if (bannerW > 0) {
    fill(248, 246, 240, 245 * iluminacion);
    rect(bannerX, bannerY, bannerW, 190, 18);
    fill(108, 92, 231, 245 * iluminacion);
    rect(bannerX, bannerY, bannerW, 48, 18, 18, 0, 0);

    dibujarIconoTelefono(bannerX + 16, bannerY + 12);

    fill(255, 255, 255);
    textFont(fuenteTitulo);
    textSize(17);
    textAlign(LEFT, CENTER);
    text("NUEVA NOTIFICACIÓN", bannerX + 47, bannerY + 24);

    String visible = textosIntro[3].substring(0, min(cantidadCaracteres, textosIntro[3].length()));
    fill(45, 52, 54);
    textFont(fuenteCuerpo);
    textSize(16);
    textAlign(LEFT, TOP);
    text(visible, bannerX + 18, bannerY + 62, bannerW - 36, 116);
  }
}

void dibujarIconoTelefono(float x, float y) {
  pushStyle();
  rectMode(CORNER);
  noStroke();
  fill(255);
  rect(x, y, 19, 26, 4);
  fill(108, 92, 231);
  rect(x + 2, y + 3, 15, 18, 2);
  fill(255);
  ellipse(x + 9.5, y + 23, 2.5, 2.5);
  popStyle();
}

void avanzarSlideIntro() {
  if (slideActual >= 5) {
    return;
  }

  String texto = textosIntro[slideActual - 1];
  if (caracteresVisibles < texto.length()) {
    caracteresVisibles = texto.length();
    ultimoTipeado = millis();
    return;
  }

  slideActual++;
  tiempoInicioSlide = millis();
  ultimoTipeado = tiempoInicioSlide;
  caracteresVisibles = 0;
}

void iniciarJuegoDesdeIntro() {
  cargarEscenario(2);
  jugadorX = 1000;
  jugadorY = 850;
  actualizarCamara();
  botonMinijuego1PresionadoAntes =
    mandoConectado && botonX != null && botonX.pressed();
  estadoJuego = ESTADO_JUEGO;
}

// =====================================================
// 22. TECLADO Y MOUSE
// =====================================================

void keyPressed() {

  if (estadoJuego == ESTADO_INTRO) {
    if (key == ENTER || key == RETURN || key == ' ') {
      avanzarSlideIntro();
    }
    return;
  }

  if (estadoJuego == ESTADO_MINIJUEGO1) {
    controlarTecladoMinijuego1(true);
    return;
  }

  if (
    estadoJuego == ESTADO_JUEGO &&
    (key == 'e' || key == 'E') &&
    escenario == 2 &&
    !minijuego1IniciadoAntes &&
    jugadorEnEntradaColegio()
  ) {
    mostrarAvisoMinijuego1 = true;
    return;
  }

  if (
    estadoJuego == ESTADO_JUEGO &&
    mostrarAvisoMinijuego1 &&
    (key == ENTER || key == RETURN)
  ) {
    iniciarMinijuego1();
    return;
  }

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
  if (estadoJuego == ESTADO_MINIJUEGO1) {
    controlarTecladoMinijuego1(false);
    return;
  }

  if (key == 'w' || key == 'W') moverArriba = false;
  if (key == 's' || key == 'S') moverAbajo = false;
  if (key == 'a' || key == 'A') moverIzquierda = false;
  if (key == 'd' || key == 'D') moverDerecha = false;
}

void mousePressed() {
  if (estadoJuego == ESTADO_INTRO) {
    avanzarSlideIntro();
    return;
  }

  if (estadoJuego == ESTADO_JUEGO && manejarClicMinijuego1()) {
    return;
  }

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