// =====================================================
// 6. JUGADOR - VARIABLES
// =====================================================

float jugadorX = 500;
float jugadorY = 300;

float velocidadJugador = 3;

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
  float fasePaso = jugadorCaminando ? sin(frameCount * 0.25) : 0;
  float respirar = sin(frameCount * 0.08) * 0.8;
  float torsoY = jugadorY - 5 + respirar;

  pushStyle();
  stroke(45, 52, 54);
  strokeWeight(2);
  strokeCap(ROUND);
  strokeJoin(ROUND);

  fill(45, 52, 54, 48);
  noStroke();
  ellipse(jugadorX, jugadorY + 27, 35, 9);
  stroke(45, 52, 54);
  strokeWeight(2);

  // Mochila y tirantes
  fill(48, 54, 72);
  rect(jugadorX - 20, jugadorY - 17 + respirar, 12, 27, 5);
  line(jugadorX - 12, jugadorY - 15 + respirar, jugadorX - 8, jugadorY + 7 + respirar);

  // Piernas, tenis y brazos con un balanceo ligero
  pushMatrix();
  translate(jugadorX - 5, jugadorY + 8);
  rotate(fasePaso * 0.14);
  fill(54, 61, 82);
  rect(-4, 0, 8, 15, 3);
  fill(248, 246, 240);
  rect(-7, 12, 13, 7, 3);
  line(-4, 14, 1, 14);
  line(0, 16, 4, 16);
  popMatrix();

  pushMatrix();
  translate(jugadorX + 5, jugadorY + 8);
  rotate(-fasePaso * 0.14);
  fill(54, 61, 82);
  rect(-4, 0, 8, 15, 3);
  fill(248, 246, 240);
  rect(-6, 12, 13, 7, 3);
  line(-3, 14, 2, 14);
  line(1, 16, 5, 16);
  popMatrix();

  pushMatrix();
  translate(jugadorX - 16, torsoY - 7);
  rotate(-fasePaso * 0.09);
  fill(108, 92, 231);
  rect(-3, 0, 7, 22, 4);
  fill(235, 190, 160);
  ellipse(0, 22, 7, 7);
  popMatrix();

  pushMatrix();
  translate(jugadorX + 16, torsoY - 7);
  rotate(fasePaso * 0.09);
  fill(108, 92, 231);
  rect(-4, 0, 7, 22, 4);
  fill(235, 190, 160);
  ellipse(0, 22, 7, 7);
  popMatrix();

  // Chaqueta lavanda con cuello alto y cremallera
  fill(108, 92, 231);
  rect(jugadorX - 14, torsoY - 15, 28, 31, 8);
  fill(133, 119, 239);
  rect(jugadorX - 8, torsoY - 19, 16, 8, 3);
  fill(248, 246, 240);
  triangle(jugadorX - 8, torsoY - 11, jugadorX, torsoY - 4, jugadorX - 2, torsoY - 11);
  triangle(jugadorX + 8, torsoY - 11, jugadorX, torsoY - 4, jugadorX + 2, torsoY - 11);
  line(jugadorX, torsoY - 9, jugadorX, torsoY + 12);
  fill(248, 246, 240);
  ellipse(jugadorX + 2, torsoY + 1, 2.5, 2.5);
  line(jugadorX - 9, torsoY + 7, jugadorX - 5, torsoY + 7);
  line(jugadorX + 6, torsoY + 7, jugadorX + 10, torsoY + 7);

  // Diadema y auriculares pastel
  noFill();
  stroke(196, 180, 255);
  strokeWeight(3);
  arc(jugadorX, jugadorY - 35, 33, 32, PI, TWO_PI);
  stroke(45, 52, 54);
  strokeWeight(2);

  // Rostro, orejas, flequillo y cabello con volumen
  fill(235, 190, 160);
  ellipse(jugadorX - 13, jugadorY - 34, 6, 9);
  ellipse(jugadorX + 13, jugadorY - 34, 6, 9);
  ellipse(jugadorX, jugadorY - 35, 27, 30);
  fill(37, 39, 55);
  ellipse(jugadorX, jugadorY - 43, 31, 21);
  beginShape();
  vertex(jugadorX - 13, jugadorY - 41);
  vertex(jugadorX - 5, jugadorY - 38);
  vertex(jugadorX - 1, jugadorY - 43);
  vertex(jugadorX + 4, jugadorY - 38);
  vertex(jugadorX + 13, jugadorY - 42);
  vertex(jugadorX + 12, jugadorY - 34);
  vertex(jugadorX - 12, jugadorY - 34);
  endShape(CLOSE);

  // Ojos expresivos con brillo
  fill(248, 246, 240);
  ellipse(jugadorX - 5, jugadorY - 34, 6, 8);
  ellipse(jugadorX + 5, jugadorY - 34, 6, 8);
  fill(45, 52, 54);
  ellipse(jugadorX - 4, jugadorY - 33, 3, 5);
  ellipse(jugadorX + 6, jugadorY - 33, 3, 5);
  noStroke();
  fill(255);
  ellipse(jugadorX - 5, jugadorY - 35, 2, 2);
  ellipse(jugadorX + 5, jugadorY - 35, 2, 2);
  stroke(45, 52, 54);
  strokeWeight(1.5);
  noFill();
  arc(jugadorX, jugadorY - 27, 7, 4, 0, PI);

  fill(196, 180, 255);
  strokeWeight(2);
  rect(jugadorX - 17, jugadorY - 38, 5, 10, 2);
  rect(jugadorX + 12, jugadorY - 38, 5, 10, 2);
  popStyle();
}
