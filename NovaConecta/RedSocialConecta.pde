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

PFont fuenteTitulo;
PFont fuenteCuerpo;

boolean redSocialAbierta = false;
boolean mostrarTipConecta = false;
String tituloTipConecta = "";
String mensajeTipConecta = "";
color colorTipConecta = color(108, 92, 231);
int tiempoTipConecta = 0;

// =====================================================
// 21. RED SOCIAL CONECTA - LÓGICA Y GUI
// =====================================================

void gestionarRedSocialGUI() {
  dibujarIconoRedSocial();
  if (redSocialAbierta) {
    dibujarPantallaConecta();
  }
}

void activarTipConecta(int opcion) {
  if (opcion == 1) {
    tituloTipConecta = "Compartir sin verificar";
    mensajeTipConecta = "¡Cuidado! Compartir sin verificar aumenta la desinformación en Nova.";
    colorTipConecta = color(232, 111, 105);
  } else if (opcion == 2) {
    tituloTipConecta = "Verificación responsable";
    mensajeTipConecta = "¡Excelente Ciudadanía Digital! Verificar fuentes protege a la comunidad.";
    colorTipConecta = color(87, 176, 116);
  } else if (opcion == 3) {
    tituloTipConecta = "Decisión en Conecta";
    mensajeTipConecta = "Actitud Pasiva: Ignorar evita desinformar, pero reportar protege a más vecinos.";
    colorTipConecta = color(108, 92, 231);
  } else {
    return;
  }

  mostrarTipConecta = true;
  tiempoTipConecta = millis();
}

void dibujarTipConecta() {
  if (!mostrarTipConecta) {
    return;
  }

  if (millis() - tiempoTipConecta >= 4000) {
    mostrarTipConecta = false;
    return;
  }

  pushStyle();
  textFont(fuenteCuerpo);
  rectMode(CORNER);

  float tarjetaX = width/2 - 250;
  float tarjetaY = 18;
  float tarjetaAncho = 500;
  float tarjetaAlto = 86;

  noStroke();
  fill(45, 52, 54, 45);
  rect(tarjetaX + 3, tarjetaY + 4, tarjetaAncho, tarjetaAlto, 16);

  fill(248, 246, 240);
  stroke(colorTipConecta);
  strokeWeight(3);
  rect(tarjetaX, tarjetaY, tarjetaAncho, tarjetaAlto, 16);

  fill(colorTipConecta);
  noStroke();
  rect(tarjetaX, tarjetaY, 8, tarjetaAlto, 16, 0, 0, 16);

  fill(45, 52, 54);
  textAlign(LEFT, TOP);
  textSize(14);
  text(tituloTipConecta, tarjetaX + 24, tarjetaY + 14);

  fill(90, 86, 92);
  textSize(12);
  textLeading(16);
  text(mensajeTipConecta, tarjetaX + 24, tarjetaY + 37, tarjetaAncho - 44, 38);

  popStyle();
}

void dibujarIconoRedSocial() {
  pushStyle();
  rectMode(CORNER);
  fill(60, 50, 40, 45);
  noStroke();
  rect(width - 63, 18, 50, 50, 14);

  fill(40, 60, 140);
  rect(width - 65, 15, 50, 50, 14);

  stroke(255, 210);
  strokeWeight(2);
  noFill();
  rect(width - 51, 24, 22, 32, 5);
  noStroke();
  fill(255);
  ellipse(width - 40, 51, 4, 4);
  fill(248, 246, 240);
  ellipse(width - 40, 29, 4, 4);

  // Notificación roja si hay publicación pendiente en este escenario
  if (hayPublicacionesPendientes(escenario)) {
    fill(238, 105, 113);
    noStroke();
    ellipse(width - 15, 15, 14, 14);
  }
  popStyle();
}

void dibujarPantallaConecta() {
  pushStyle();
  textFont(fuenteCuerpo);

  float altoTelefono = 560;
  float telefonoY = height/2 - altoTelefono/2;

  rectMode(CORNER);
  fill(45, 52, 54, 90);
  noStroke();
  rect(0, 0, width, height);

  // Marco del teléfono
  fill(60, 50, 40, 55);
  noStroke();
  rect(width/2 - 194, telefonoY + 5, 400, altoTelefono, 24);

  fill(60, 50, 40);
  stroke(60, 50, 40);
  strokeWeight(3);
  rect(width/2 - 200, telefonoY, 400, altoTelefono, 18);

  fill(245, 235, 210);
  noStroke();
  rect(width/2 - 192, telefonoY + 8, 384, altoTelefono - 16, 14);

  // Encabezado
  fill(40, 60, 140);
  rect(width/2 - 192, telefonoY + 8, 384, 48, 12, 12, 0, 0);

  // Muesca superior y cámara
  fill(60, 50, 40);
  rect(width/2 - 52, telefonoY + 5, 104, 20, 10);
  fill(40, 60, 140);
  ellipse(width/2 + 28, telefonoY + 15, 7, 7);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(15);
  String nombreEscenario = (escenario == 1) ? "BARRIO" : (escenario == 2) ? "COLEGIO" : "ELECCIÓN";
  text("RED CONECTA - " + nombreEscenario, width/2, telefonoY + 38);

  // Buscar publicación para el escenario actual
  int idx = obtenerIndicePublicacion(escenario);
  // =====================================================
  // CONECTA ESPECIAL DEL MINIJUEGO DEL COLEGIO
  // =====================================================

  if (escenario == 2 && minijuegoColegioActivo) {

    dibujarConectaColegio();

  } else if (idx != -1 && !pubProcesadas[idx]) {
    // Tarjeta de publicación con sombra tenue
    fill(45, 52, 54, 35);
    noStroke();
    rect(width/2 - 176, telefonoY + 68, 360, 140, 14);
    fill(255);
    stroke(228, 225, 220);
    strokeWeight(1);
    rect(width/2 - 180, telefonoY + 64, 360, 140, 14);

    // Avatar circular simulado
    fill(196, 180, 225);
    noStroke();
    ellipse(width/2 - 153, telefonoY + 87, 30, 30);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    String inicialAutor = pubAutores[idx].substring(1, 2).toUpperCase();
    text(inicialAutor, width/2 - 153, telefonoY + 87);

    fill(45, 52, 54);
    textAlign(LEFT, TOP);
    textSize(12);
    text(pubAutores[idx], width/2 - 132, telefonoY + 76);
    fill(112, 106, 115);
    textSize(10);
    text("Confiabilidad: " + pubConfiabilidad[idx] + "%  |  Viralidad: " + pubViralidad[idx] + "%", width/2 - 132, telefonoY + 92);

    fill(45, 52, 54);
    textSize(13);
    textLeading(18);
    text(pubTitulos[idx], width/2 - 165, telefonoY + 119, 330, 80);

    // Botones de decisión (1, 2, 3)
    dibujarBotonOpcion(width/2 - 170, telefonoY + 219, "L1. Compartir (Aumenta Viralidad)", color(170, 70, 60));
    dibujarBotonOpcion(width/2 - 170, telefonoY + 264, "R1. Verificar / Reportar", color(60, 150, 70));
    dibujarBotonOpcion(width/2 - 170, telefonoY + 309, "L2. Ignorar Publicación", color(180, 170, 150));
  } else {
    fill(112, 106, 115);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("No hay publicaciones pendientes\nen esta zona de la ciudad.", width/2, telefonoY + altoTelefono/2 - 10);
  }

  // Indicación de cierre
  fill(112, 106, 115);
  textSize(11);
  textAlign(CENTER);
  text("[ Presiona C, Cuadrado o Clic en el icono para Cerrar ]", width/2, telefonoY + altoTelefono - 22);

  popStyle();
}

void dibujarBotonOpcion(float x, float y, String texto, int c) {
  textFont(fuenteCuerpo);
  fill(60, 50, 40, 35);
  noStroke();
  rect(x + 2, y + 3, 340, 36, 12);

  fill(c);
  stroke(255, 150);
  strokeWeight(1);
  rect(x, y, 340, 36, 12);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(13);
  text(texto, x + 18, y + 18);
}

void procesarDecision(int idx, int opcion) {
  if (idx < 0 || idx >= pubTitulos.length) return;

  // 1: Compartir, 2: Verificar/Reportar, 3: Ignorar
  if (opcion == 1) {
    pubViralidad[idx] += 20;
    cambiarIndicadores(-10, -5, -5, +5, -10);
    activarTipConecta(opcion);
  } else if (opcion == 2) {
    pubViralidad[idx] -= 15;
    cambiarIndicadores(+15, +10, +5, +10, +10);
    activarTipConecta(opcion);
  } else if (opcion == 3) {
    cambiarIndicadores(0, 0, +5, 0, 0);
    activarTipConecta(opcion);
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