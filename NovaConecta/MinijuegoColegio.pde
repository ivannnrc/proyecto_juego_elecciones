// =====================================================
// MINIJUEGO 2 - COLEGIO / CRISIS ELECTORAL EN CONECTA (VARIABLES)
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
// LÓGICA DEL MINIJUEGO COLEGIO
// =====================================================

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
  float telefonoY = height/2 - 560/2;

  if (
    publicacionColegioActual != -1 &&
    publicacionVerificadaColegio[publicacionColegioActual]
  ) {

    dibujarResultadoInvestigacionColegio();
    return;
  }
  fill(40, 60, 140);
  textAlign(CENTER, CENTER);

  textSize(18);
  text(
    "TENDENCIAS ELECTORALES EN EL COLEGIO",
    width/2,
    telefonoY + 75
  );

  textSize(13);
  fill(112, 106, 115);

  text(
    "Selecciona una situación para investigarla",
    width/2,
    telefonoY + 100
  );

  // =====================================================
  // PUBLICACIÓN 1
  // =====================================================
  if (!crisisColegioResuelta[0]){

    fill(60, 50, 40, 35);
    noStroke();
    rect(width/2 - 167, telefonoY + 124, 340, 100, 12);
    fill(255);
    stroke(228, 225, 220);
    strokeWeight(1);

    rect(
      width/2 - 170,
      telefonoY + 120,
      340,
      100,
      12
    );

    fill(45, 52, 54);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[0],
      width/2 - 150,
      telefonoY + 135,
      300,
      50
    );

    fill(170, 70, 60);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[0]) + "%",
      width/2 - 150,
      telefonoY + 195
    );

  }
  // =====================================================
  // PUBLICACIÓN 2
  // =====================================================
  if (!crisisColegioResuelta[1]) {
    fill(60, 50, 40, 35);
    noStroke();
    rect(width/2 - 167, telefonoY + 239, 340, 100, 12);
    fill(255);
    stroke(228, 225, 220);
    strokeWeight(1);

    rect(
      width/2 - 170,
      telefonoY + 235,
      340,
      100,
      12
    );

    fill(45, 52, 54);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[1],
      width/2 - 150,
      telefonoY + 250,
      300,
      50
    );

    fill(170, 70, 60);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[1]) + "%",
      width/2 - 150,
      telefonoY + 310
    );

  }
  // =====================================================
  // PUBLICACIÓN 3
  // =====================================================
  if (!crisisColegioResuelta[2]) {
    fill(60, 50, 40, 35);
    noStroke();
    rect(width/2 - 167, telefonoY + 354, 340, 100, 12);
    fill(255);
    stroke(228, 225, 220);
    strokeWeight(1);

    rect(
      width/2 - 170,
      telefonoY + 350,
      340,
      100,
      12
    );

    fill(45, 52, 54);
    textAlign(LEFT, TOP);
    textSize(13);

    text(
      publicacionesColegio[2],
      width/2 - 150,
      telefonoY + 365,
      300,
      50
    );

    fill(170, 70, 60);
    textSize(12);

    text(
      "Viralidad: " + round(viralidadColegio[2]) + "%",
      width/2 - 150,
      telefonoY + 425
    );
  }

  // =====================================================
  // CONTROLES
  // =====================================================

  fill(112, 106, 115);
  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "L1 = Primera    R1 = Segunda    L2 = Tercera",
    width/2,
    telefonoY + 480
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
  float telefonoY = height/2 - 560/2;

  if (publicacionColegioActual == -1) {
    return;
  }

  if (!publicacionVerificadaColegio[publicacionColegioActual]) {
    return;
  }

  fill(40, 60, 140);
  textAlign(CENTER, TOP);
  textSize(18);

  text(
    "RESULTADO DE LA VERIFICACIÓN",
    width/2,
    telefonoY + 90
  );

  fill(45, 52, 54);
  textSize(14);

  if (publicacionColegioActual == 0) {

    text(
      "El video estaba recortado y sacado de contexto.\n" +
      "La propuesta completa no decía que se eliminarían\n" +
      "los apoyos estudiantiles.",
      width/2,
      telefonoY + 135
    );

  } else if (publicacionColegioActual == 1) {

    text(
      "La encuesta solo se realizó a un grupo pequeño\n" +
      "de estudiantes y no representa a todo el colegio.\n" +
      "El porcentaje publicado exagera el resultado.",
      width/2,
      telefonoY + 135
    );
  } else if (publicacionColegioActual == 2) {

    text(
      "El foro electoral continúa con normalidad.\n" +
      "No hubo disturbios ni fue suspendido.\n" +
      "La publicación difundió un rumor falso.",
      width/2,
      telefonoY + 135
    );
  }

  // =====================================================
  // OPCIONES
  // =====================================================

  textSize(14);
  fill(45, 52, 54);

  text(
    "¿Qué quieres hacer en Conecta?",
    width/2,
    telefonoY + 205
  );

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 245,
    "L1. Compartir publicación",
    color(170, 70, 60)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 300,
    "R1. Reportar / corregir",
    color(60, 150, 70)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 355,
    "L2. Ignorar",
    color(180, 170, 150)
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
    activarTipConecta(opcion);
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
    activarTipConecta(opcion);
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
    activarTipConecta(opcion);
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