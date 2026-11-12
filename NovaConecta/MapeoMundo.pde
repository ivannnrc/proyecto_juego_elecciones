// =====================================================
// 3. VARIABLES GENERALES Y NAVEGACIÓN (MUNDO Y CÁMARA)
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
  dibujarPersona(x, y, v, 255);
}

void dibujarPersona(float x, float y, int v, float opacidad) {
  fill(110, 110, 100, opacidad);
  ellipse(x, y + 35, 30, 10);

  fill(50, opacidad);
  rect(x - 8, y + 18, 6, 18);
  rect(x + 3, y + 18, 6, 18);

  if (v == 0) fill(80, 120, 190, opacidad);
  else if (v == 1) fill(200, 90, 90, opacidad);
  else if (v == 2) fill(90, 170, 110, opacidad);
  else fill(220, 170, 70, opacidad);
  rect(x - 12, y - 5, 24, 25);

  fill(230, 180, 140, opacidad);
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
  textFont(fuenteTitulo);
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
  textFont(fuenteTitulo);
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
  textFont(fuenteTitulo);
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