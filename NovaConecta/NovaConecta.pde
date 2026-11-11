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
// 9. SETUP
// =====================================================

void setup() {
  size(1500, 900);
  fuenteTitulo = createFont("Trebuchet MS Bold", 18);
  fuenteCuerpo = createFont("Trebuchet MS", 13);

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