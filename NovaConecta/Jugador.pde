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