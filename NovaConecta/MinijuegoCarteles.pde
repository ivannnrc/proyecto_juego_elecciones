// =====================================================
// 7. MINIJUEGO CARTELES - VARIABLES Y ESTADOS
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
// 28. NPC LÍDER SOCIAL / BOMBERO
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
  textFont(fuenteTitulo);
  textAlign(LEFT, TOP);
  textSize(28);

  text(
    "Líder Social",
    100,
    265
  );

  // TEXTO DEL DIÁLOGO
  fill(255);
  textFont(fuenteCuerpo);
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
  textFont(fuenteCuerpo);
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
      0,    // Bienestar digital
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