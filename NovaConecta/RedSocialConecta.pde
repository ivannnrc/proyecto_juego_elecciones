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
// =====================================================
// FEED DINÁMICO DE CONECTA
// =====================================================

// Guarda qué decisión tomó el jugador.
// 0 = todavía no decide
// 1 = compartir
// 2 = verificar/reportar
// 3 = ignorar
int[] decisionPublicacion = {
  0,
  0,
  0
};
String[][] reaccionesIniciales = {

  {
    "@vecina_luisa: ¿Alguien sabe si esto es cierto?",
    "@nova_hoy: Esta publicación se está compartiendo rápidamente."
  },

  {
    "@estudiante_24: Esa foto está circulando por todos los grupos.",
    "@maria_nova: ¿La persona de la foto dio permiso para subirla?"
  },

  {
    "@ciudadano_nova: ¿Existe alguna fuente oficial sobre esto?",
    "@debate_nova: El rumor ya está generando discusión."
  }
};

// Reacciones que aparecen ANTES de tomar una decisión
String[][] reaccionesCompartir = {

  {
    "@vecina_luisa: Ahora todos lo están compartiendo.",
    "@nova_hoy: 🔥 Esta publicación es tendencia en Nova."
  },

  {
    "@estudiante_24: La foto ya llegó a más grupos.",
    "@maria_nova: Esto se está saliendo de control."
  },

  {
    "@ciudadano_nova: El rumor ya se está propagando por toda la plaza.",
    "@debate_nova: 🔥 La publicación está entre las más compartidas."
  }
};


String[][] reaccionesVerificar = {

  {
    "@vecina_luisa: Gracias por aclarar la información.",
    "@nova_hoy: ✓ La publicación fue contrastada con fuentes."
  },

  {
    "@estudiante_24: Ya aclararon que no había consentimiento.",
    "@maria_nova: ✓ La publicación fue reportada correctamente."
  },

  {
    "@ciudadano_nova: Ya apareció una fuente oficial.",
    "@debate_nova: ✓ La información fue corregida."
  }
};


String[][] reaccionesIgnorar = {

  {
    "@vecina_luisa: ¿Todavía nadie ha comprobado esto?",
    "@nova_hoy: La publicación continúa aumentando su alcance."
  },

  {
    "@estudiante_24: La foto sigue circulando.",
    "@maria_nova: Nadie ha hecho nada todavía."
  },

  {
    "@ciudadano_nova: El rumor sigue generando discusión.",
    "@debate_nova: La publicación continúa compartiéndose."
  }
};

PFont fuenteTitulo;
PFont fuenteCuerpo;

boolean redSocialAbierta = false;
boolean mostrarTipConecta = false;
String tituloTipConecta = "";
String mensajeTipConecta = "";
color colorTipConecta = color(108, 92, 231);
int tiempoTipConecta = 0;
int ultimoAumentoViralidad = 0;
int ultimaPublicacionProcesada = -1;
int tiempoUltimaDecision = 0;
// Conversaciones dinámicas del Barrio
int npcRumorActual = 0;
int tiempoUltimoRumor = 0;
boolean burbujaVisible = true;
int tiempoCambioBurbuja = 0;
// =====================================================
// NPC DEL BARRIO AFECTADOS POR EL RUMOR
// =====================================================

float[] vecinosRumorX = {
  950,
  1250,
  1550
};

float[] vecinosRumorY = {
  650,
  700,
  640
};

// Posiciones originales
float[] vecinosCasaX = {
  950,
  1250,
  1550
};

float[] vecinosCasaY = {
  650,
  700,
  640
};

// Punto donde se reúnen cuando el rumor explota
float[] vecinosReunionX = {
  1180,
  1250,
  1320
};

float[] vecinosReunionY = {
  680,
  680,
  680
};
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

  float altoTelefono = 700;
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
  int idx = obtenerPublicacionVisibleConecta(escenario);
  // =====================================================
  // CONECTA ESPECIAL DEL MINIJUEGO DEL COLEGIO
  // =====================================================

  if (escenario == 2 && minijuegoColegioActivo) {

    dibujarConectaColegio();

  } else if (idx != -1) {
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
    // ==========================================
// TODAVÍA NO HA TOMADO UNA DECISIÓN
// ==========================================

if (!pubProcesadas[idx]) {

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 219,
    "L1. Compartir",
    color(170, 70, 60)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 264,
    "R1. Verificar / Reportar",
    color(60, 150, 70)
  );

  dibujarBotonOpcion(
    width/2 - 170,
    telefonoY + 309,
    "L2. Ignorar publicación",
    color(180, 170, 150)
  );
}


// ==========================================
// YA TOMÓ UNA DECISIÓN
// ==========================================

else {

  fill(45, 52, 54);
  textAlign(CENTER, CENTER);
  textSize(13);

  if (decisionPublicacion[idx] == 1) {

    text(
      "COMPARTISTE ESTA PUBLICACIÓN",
      width/2,
      telefonoY + 240
    );
  }

  else if (decisionPublicacion[idx] == 2) {

    text(
      "VERIFICASTE / REPORTASTE LA PUBLICACIÓN",
      width/2,
      telefonoY + 240
    );
  }

  else if (decisionPublicacion[idx] == 3) {

    text(
      "DECIDISTE IGNORAR LA PUBLICACIÓN",
      width/2,
      telefonoY + 240
    );
  }
}


// Siempre mostrar las reacciones
dibujarComentariosConecta(idx, telefonoY);
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
decisionPublicacion[idx] = opcion;
  pubProcesadas[idx] = true;
  // Guardar la publicación que acabamos de responder
ultimaPublicacionProcesada = idx;

// Guardar el momento de la decisión
tiempoUltimaDecision = millis();
}

int obtenerIndicePublicacion(int esc) {
  for (int i = 0; i < pubEscenarios.length; i++) {
    if (pubEscenarios[i] == esc && !pubProcesadas[i]) {
      return i;
    }
  }
  return -1;
}
int obtenerPublicacionVisibleConecta(int esc) {

  // ==========================================
  // PRIMERO BUSCAR UNA PUBLICACIÓN PENDIENTE
  // ==========================================

  int pendiente = obtenerIndicePublicacion(esc);

  if (pendiente != -1) {
    return pendiente;
  }


  // ==========================================
  // SI ACABA DE TOMAR UNA DECISIÓN,
  // MOSTRAR ESA PUBLICACIÓN DURANTE 5 SEGUNDOS
  // ==========================================

  if (
    ultimaPublicacionProcesada != -1 &&
    pubEscenarios[ultimaPublicacionProcesada] == esc &&
    millis() - tiempoUltimaDecision < 5000
  ) {

    return ultimaPublicacionProcesada;
  }


  return -1;
}

boolean hayPublicacionesPendientes(int esc) {
  return obtenerIndicePublicacion(esc) != -1;
}

void dibujarComentariosConecta(int idx, float telefonoY) {

  String comentario1;
  String comentario2;


  // ==========================================
  // TODAVÍA NO HA TOMADO DECISIÓN
  // ==========================================

 if (decisionPublicacion[idx] == 0) {

  // Viralidad baja
  if (pubViralidad[idx] < 50) {

    comentario1 =
      "@vecina_luisa: ¿Alguien sabe si esto es cierto?";

    comentario2 =
      "@nova_hoy: La publicación acaba de empezar a circular.";
  }

  // Viralidad media
  else if (pubViralidad[idx] < 75) {

    comentario1 =
      "@vecina_luisa: Ya lo están enviando por varios grupos.";

    comentario2 =
      "@nova_hoy: La publicación está ganando mucha atención.";
  }

  // Viralidad alta
  else {

    comentario1 =
      "@vecina_luisa: ¡Todo el mundo está hablando de esto!";

    comentario2 =
      "@nova_hoy: TENDENCIA EN NOVA";
  }
}


  // ==========================================
  // COMPARTIÓ
  // ==========================================

  else if (decisionPublicacion[idx] == 1) {

    comentario1 = reaccionesCompartir[idx][0];
    comentario2 = reaccionesCompartir[idx][1];
  }


  // ==========================================
  // VERIFICÓ / REPORTÓ
  // ==========================================

  else if (decisionPublicacion[idx] == 2) {

    comentario1 = reaccionesVerificar[idx][0];
    comentario2 = reaccionesVerificar[idx][1];
  }


  // ==========================================
  // IGNORÓ
  // ==========================================

  else {

    comentario1 = reaccionesIgnorar[idx][0];
    comentario2 = reaccionesIgnorar[idx][1];
  }


  // ==========================================
  // COMENTARIO 1
  // ==========================================

  fill(248, 246, 240);
  stroke(220);
  strokeWeight(1);

  rect(
    width/2 - 170,
    telefonoY + 365,
    340,
    50,
    10
  );

  fill(60);
  noStroke();

  textAlign(LEFT, CENTER);
  textSize(10);

  text(
    comentario1,
    width/2 - 155,
    telefonoY + 390,
    310,
    40
  );


  // ==========================================
  // COMENTARIO 2
  // ==========================================

  fill(248, 246, 240);
  stroke(220);
  strokeWeight(1);

  rect(
    width/2 - 170,
    telefonoY + 425,
    340,
    50,
    10
  );

  fill(60);
  noStroke();

  textAlign(LEFT, CENTER);
  textSize(10);

  text(
    comentario2,
    width/2 - 155,
    telefonoY + 450,
    310,
    40
  );
}
void actualizarViralidadConecta() {

  if (!redSocialAbierta) {
    return;
  }

  // En el colegio usamos otro sistema
  if (escenario == 2 && minijuegoColegioActivo) {
    return;
  }

  int idx = obtenerPublicacionVisibleConecta(escenario);

  if (idx == -1) {
    return;
  }

  // Cada 2 segundos aumenta la viralidad
  if (millis() - ultimoAumentoViralidad >= 2000) {

    pubViralidad[idx] += 3;

    pubViralidad[idx] = constrain(
      pubViralidad[idx],
      0,
      100
    );

    ultimoAumentoViralidad = millis();
  }
}
void actualizarConversacionesBarrio() {

  if (escenario != 1) {
    return;
  }

  if (
    decisionPublicacion[0] == 0 &&
    pubViralidad[0] < 50
  ) {
    return;
  }


  // =====================================================
  // SI LA BURBUJA ESTÁ VISIBLE
  // =====================================================

  if (burbujaVisible) {

    // Mantenerla visible 2 segundos
    if (millis() - tiempoCambioBurbuja >= 2000) {

      burbujaVisible = false;

      tiempoCambioBurbuja = millis();
    }
  }


  // =====================================================
  // SI LA BURBUJA ESTÁ OCULTA
  // =====================================================

  else {

    // Esperar 1 segundo sin ninguna burbuja
    if (millis() - tiempoCambioBurbuja >= 1000) {

      npcRumorActual++;

      if (npcRumorActual > 3) {
        npcRumorActual = 0;
      }

      burbujaVisible = true;

      tiempoCambioBurbuja = millis();
    }
  }
}
void dibujarImpactoRedesMundo() {

  if (escenario != 1) {
    return;
  }
  dibujarVecinosRumor();
  if (!burbujaVisible) {
  return;
}

  int viralidad = pubViralidad[0];


  // =====================================================
  // TODAVÍA NO HA TOMADO DECISIÓN
  // =====================================================

  if (decisionPublicacion[0] == 0) {

    // Todavía no es suficientemente viral
    if (viralidad < 50) {
      return;
    }


    // VIRALIDAD MEDIA
    if (viralidad < 75) {

      if (npcRumorActual % 2 == 0) {

        dibujarBurbujaRumor(
          500,
          570,
          "¿Viste lo que publicaron?"
        );

      } else {

        dibujarBurbujaRumor(
          1250,
          600,
          "Dicen que es verdad..."
        );
      }
    }


    // VIRALIDAD ALTA
    else {

      if (npcRumorActual == 0) {

        dibujarBurbujaRumor(
          500,
          570,
          "¡Todos están hablando de esto!"
        );
      }

      else if (npcRumorActual == 1) {

        dibujarBurbujaRumor(
          1250,
          600,
          "Yo también lo compartí."
        );
      }

      else if (npcRumorActual == 2) {

        dibujarBurbujaRumor(
          1850,
          660,
          "¿Será cierto?"
        );
      }

      else if (npcRumorActual == 3) {

        dibujarBurbujaRumor(
          2150,
          540,
          "Está por todas partes."
        );
      }
    }
  }


  // =====================================================
  // COMPARTIÓ LA PUBLICACIÓN
  // =====================================================

  else if (decisionPublicacion[0] == 1) {

    if (npcRumorActual == 0) {

      dibujarBurbujaRumor(
        500,
        570,
        "¡Ya me llegó esa publicación!"
      );
    }

    else if (npcRumorActual == 1) {

      dibujarBurbujaRumor(
        1250,
        600,
        "Se está compartiendo muchísimo."
      );
    }

    else if (npcRumorActual == 2) {

      dibujarBurbujaRumor(
        1850,
        660,
        "Yo también la reenvié."
      );
    }

    else {

      dibujarBurbujaRumor(
        2150,
        540,
        "Cada vez la comparte más gente."
      );
    }
  }


  // =====================================================
  // VERIFICÓ / REPORTÓ
  // =====================================================

  else if (decisionPublicacion[0] == 2) {

    if (npcRumorActual % 2 == 0) {

      dibujarBurbujaAclaracion(
        500,
        570,
        "Ya publicaron la aclaración."
      );

    } else {

      dibujarBurbujaAclaracion(
        1250,
        600,
        "Hay que verificar antes de compartir."
      );
    }
  }


  // =====================================================
  // IGNORÓ
  // =====================================================

  else if (decisionPublicacion[0] == 3) {

    if (npcRumorActual % 2 == 0) {

      dibujarBurbujaRumor(
        500,
        570,
        "El rumor sigue circulando."
      );

    } else {

      dibujarBurbujaRumor(
        1250,
        600,
        "¿Alguien verificó esto?"
      );
    }
  }
}
void dibujarBurbujaRumor(
  float x,
  float y,
  String mensaje
) {

  pushStyle();

  float ancho = 250;
  float alto = 80;

  fill(255);
  stroke(220, 80, 80);
  strokeWeight(3);

  rect(
    x - ancho/2,
    y - 115,
    ancho,
    alto,
    14
  );

  fill(35);
  noStroke();

  textAlign(LEFT, TOP);
  textSize(14);
  textLeading(18);

  text(
    mensaje,
    x - ancho/2 + 15,
    y - 102,
    ancho - 30,
    alto - 20
  );

  popStyle();
}
void dibujarBurbujaAclaracion(
  float x,
  float y,
  String mensaje
) {

  pushStyle();

  float ancho = 250;
  float alto = 80;

  fill(255);
  stroke(60, 170, 90);
  strokeWeight(3);

  rect(
    x - ancho/2,
    y - 115,
    ancho,
    alto,
    14
  );

  fill(35);
  noStroke();

  textAlign(LEFT, TOP);
  textSize(14);
  textLeading(18);

  text(
    mensaje,
    x - ancho/2 + 15,
    y - 102,
    ancho - 30,
    alto - 20
  );

  popStyle();
}
void actualizarVecinosRumor() {

  if (escenario != 1) {
    return;
  }

  boolean reunirse = false;


  // =====================================================
  // CUÁNDO SE REÚNEN
  // =====================================================

  // Rumor muy viral
  if (
    decisionPublicacion[0] == 0 &&
    pubViralidad[0] >= 75
  ) {

    reunirse = true;
  }


  // Si el jugador compartió,
  // el rumor sigue generando conversación
  if (decisionPublicacion[0] == 1) {

    reunirse = true;
  }


  // Si lo ignoró, también continúa el problema
  if (decisionPublicacion[0] == 3) {

    reunirse = true;
  }



  // =====================================================
  // MOVER LOS NPC
  // =====================================================

  for (int i = 0; i < vecinosRumorX.length; i++) {

    if (reunirse) {

      vecinosRumorX[i] = lerp(
        vecinosRumorX[i],
        vecinosReunionX[i],
        0.025
      );

      vecinosRumorY[i] = lerp(
        vecinosRumorY[i],
        vecinosReunionY[i],
        0.025
      );

    }

    // Si verificó, regresan a donde estaban
    else if (decisionPublicacion[0] == 2) {

      vecinosRumorX[i] = lerp(
        vecinosRumorX[i],
        vecinosCasaX[i],
        0.025
      );

      vecinosRumorY[i] = lerp(
        vecinosRumorY[i],
        vecinosCasaY[i],
        0.025
      );
    }
  }
}
void dibujarVecinosRumor() {

  if (escenario != 1) {
    return;
  }

  // Antes de viralidad 50 todavía no aparecen
  if (
    pubViralidad[0] < 50 &&
    decisionPublicacion[0] == 0
  ) {
    return;
  }


  for (int i = 0; i < vecinosRumorX.length; i++) {

    float x = vecinosRumorX[i];
    float y = vecinosRumorY[i];

    pushStyle();


    // SOMBRA
    noStroke();
    fill(0, 45);

    ellipse(
      x,
      y + 30,
      30,
      9
    );


    // PIERNAS
    fill(55);

    rect(
      x - 8,
      y + 10,
      6,
      20
    );

    rect(
      x + 2,
      y + 10,
      6,
      20
    );


    // CAMISA
    if (i == 0) {
      fill(80, 130, 210);
    }

    else if (i == 1) {
      fill(210, 120, 80);
    }

    else {
      fill(120, 170, 100);
    }

    rect(
      x - 13,
      y - 12,
      26,
      25,
      5
    );


    // CABEZA
    fill(230, 185, 145);

    ellipse(
      x,
      y - 23,
      22,
      22
    );


    popStyle();
  }
}
