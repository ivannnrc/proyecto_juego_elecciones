// =====================================================
// MINIJUEGO 3 - DEBATE CIUDADANO EN PLAZA NOVA (VARIABLES)
// =====================================================

// Estado general del minijuego
boolean minijuegoPlazaActivo = false;
boolean minijuegoPlazaTerminado = false;

// Periodista Laura
float npcLauraX = 880;
float npcLauraY = 300;
boolean cercaNpcLaura = false;
boolean dialogoLauraActivo = false;
int dialogoLaura = 0;
boolean cuadradoLauraAntes = false;
boolean l1PlazaAntes = false;
boolean r1PlazaAntes = false;
boolean xPlazaAntes = false;
boolean mousePlazaAntes = false;

// Progreso del minijuego
int aciertosPlaza = 0;
int desaciertosPlaza = 0;
float reticulaX = 0;
float reticulaY = 0;
int perfilSeleccionadoPlaza = -1;
int perfilesResueltosPlaza = 0;
int botsDesmanteladosPlaza = 0;
boolean tarjetaMetadatosPlaza = false;
float[] perfilesXPlaza = {210, 430, 680, 900, 1080};
float[] perfilesYPlaza = {245, 390, 235, 410, 290};
String[] perfilesSospechososPlaza = {
  "@voz_vecinal",
  "@alerta_nova",
  "@cambio_real",
  "@bot_nova_500",
  "@foro_abierto"
};
boolean[] perfilesBotPlaza = {
  false,
  true,
  false,
  true,
  true
};
String[] metadatosPerfilesPlaza = {
  "Antigüedad: 4 años | Patrón: conversaciones variadas",
  "Antigüedad: 1 hora | Patrón: 500 mensajes idénticos",
  "Antigüedad: 2 años | Patrón: responde con experiencias propias",
  "Antigüedad: 3 minutos | Patrón: publica cada 10 segundos",
  "Antigüedad: 8 minutos | Patrón: repite etiquetas coordinadas"
};
boolean[] perfilesRevisadosPlaza = {
  false,
  false,
  false,
  false,
  false
};

// =====================================================
// LÓGICA DEL MINIJUEGO PLAZA
// =====================================================

void iniciarMinijuegoPlaza() {
  aciertosPlaza = 0;
  desaciertosPlaza = 0;
  minijuegoPlazaActivo = true;
  minijuegoPlazaTerminado = false;
  l1PlazaAntes = false;
  r1PlazaAntes = false;
  xPlazaAntes = false;
  mousePlazaAntes = false;
  perfilSeleccionadoPlaza = -1;
  perfilesResueltosPlaza = 0;
  botsDesmanteladosPlaza = 0;
  tarjetaMetadatosPlaza = false;
  reticulaX = width / 2;
  reticulaY = height / 2;

  for (int i = 0; i < perfilesRevisadosPlaza.length; i++) {
    perfilesRevisadosPlaza[i] = false;
  }
}

void revisarInteraccionNpcLaura() {
  cercaNpcLaura = false;

  if (escenario != 3) {
    return;
  }

  float distanciaLaura = dist(
    jugadorX,
    jugadorY,
    npcLauraX,
    npcLauraY
  );

  if (distanciaLaura < 80) {
    cercaNpcLaura = true;
  }
}

void controlarDialogoLaura() {
  if (!mandoConectado) {
    return;
  }

  boolean cuadradoAhora = botonCuadrado.pressed();

  if (
    escenario == 3 &&
    cercaNpcLaura &&
    !minijuegoPlazaActivo &&
    cuadradoAhora &&
    !cuadradoLauraAntes
  ) {
    if (!dialogoLauraActivo) {
      dialogoLauraActivo = true;
      dialogoLaura = 1;
    } else if (crisisColegioCompletadas < 3) {
      dialogoLauraActivo = false;
      dialogoLaura = 0;
    } else {
      dialogoLaura++;

      if (dialogoLaura > 3) {
        dialogoLauraActivo = false;
        dialogoLaura = 0;
        iniciarMinijuegoPlaza();
      }
    }
  }

  cuadradoLauraAntes = cuadradoAhora;
}

void dibujarDialogoLaura() {
  if (!dialogoLauraActivo) {
    return;
  }

  pushStyle();

  fill(0, 210);
  noStroke();
  rect(
    80,
    250,
    width - 160,
    125,
    12
  );

  noFill();
  stroke(255);
  strokeWeight(2);
  rect(
    80,
    250,
    width - 160,
    125,
    12
  );

  noStroke();
  fill(255, 210, 60);
  textFont(fuenteTitulo);
  textAlign(LEFT, TOP);
  textSize(28);
  text("Laura", 100, 265);

  fill(255);
  textFont(fuenteCuerpo);
  textSize(20);

  if (crisisColegioCompletadas < 3) {
    text(
      "Primero debes resolver los problemas del Colegio.",
      100,
      300
    );
  } else if (dialogoLaura == 1) {
    text(
      "En este debate circulan comentarios reales y mensajes de bots.",
      100,
      300
    );
  } else if (dialogoLaura == 2) {
    text(
      "Rastrea los perfiles, inspecciona sus metadatos y detecta patrones.",
      100,
      300
    );
  } else if (dialogoLaura == 3) {
    text(
      "Presiona X para escanear; usa R1 para desmantelar bots o L1 para confirmar ciudadanos.",
      100,
      300
    );
  }

  fill(200);
  textFont(fuenteCuerpo);
  textAlign(RIGHT, BOTTOM);
  textSize(12);
  text("□ Continuar", width - 100, 360);

  popStyle();
}

void actualizarMinijuegoPlaza() {
  if (!minijuegoPlazaActivo) {
    l1PlazaAntes = false;
    r1PlazaAntes = false;
    xPlazaAntes = false;
    mousePlazaAntes = false;
    return;
  }

  float velocidadReticula = 4;
  if (moverArriba) reticulaY -= velocidadReticula;
  if (moverAbajo) reticulaY += velocidadReticula;
  if (moverIzquierda) reticulaX -= velocidadReticula;
  if (moverDerecha) reticulaX += velocidadReticula;

  if (mandoConectado) {
    reticulaX += joystickX.getValue() * 6;
    reticulaY += joystickY.getValue() * 6;
  }

  if (mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height) {
    reticulaX = lerp(reticulaX, mouseX, 0.18);
    reticulaY = lerp(reticulaY, mouseY, 0.18);
  }

  reticulaX = constrain(reticulaX, 145, width - 145);
  reticulaY = constrain(reticulaY, 180, height - 90);

  boolean xAhora = mandoConectado && botonX.pressed();
  boolean l1Ahora = mandoConectado && botonL1.pressed();
  boolean r1Ahora = mandoConectado && botonR1.pressed();
  boolean clicAhora = mousePressed;

  if (clicAhora) {
    reticulaX = mouseX;
    reticulaY = mouseY;
  }

  if ((xAhora && !xPlazaAntes) || (clicAhora && !mousePlazaAntes)) {
    if (!tarjetaMetadatosPlaza) {
      perfilSeleccionadoPlaza = obtenerPerfilBajoReticula();
      tarjetaMetadatosPlaza = perfilSeleccionadoPlaza != -1;
    } else {
      tarjetaMetadatosPlaza = false;
    }
  }

  if (tarjetaMetadatosPlaza && perfilSeleccionadoPlaza != -1) {
    if (r1Ahora && !r1PlazaAntes) {
      resolverPerfilPlaza(true);
    } else if (l1Ahora && !l1PlazaAntes) {
      resolverPerfilPlaza(false);
    }
  }

  l1PlazaAntes = l1Ahora;
  r1PlazaAntes = r1Ahora;
  xPlazaAntes = xAhora;
  mousePlazaAntes = clicAhora;
}

int obtenerPerfilBajoReticula() {
  int perfilCercano = -1;
  float distanciaCercana = 55;

  for (int i = 0; i < perfilesSospechososPlaza.length; i++) {
    if (perfilesRevisadosPlaza[i]) {
      continue;
    }

    float perfilX = perfilesXPlaza[i] + sin(frameCount * 0.018 + i) * 18;
    float perfilY = perfilesYPlaza[i] + cos(frameCount * 0.015 + i) * 12;
    float distancia = dist(reticulaX, reticulaY, perfilX, perfilY);

    if (distancia < distanciaCercana) {
      distanciaCercana = distancia;
      perfilCercano = i;
    }
  }

  return perfilCercano;
}

void resolverPerfilPlaza(boolean desmantelarBot) {
  if (perfilSeleccionadoPlaza == -1) {
    return;
  }

  boolean respuestaCorrecta = desmantelarBot == perfilesBotPlaza[perfilSeleccionadoPlaza];
  if (respuestaCorrecta) {
    aciertosPlaza++;
    if (desmantelarBot) {
      botsDesmanteladosPlaza++;
    }
  } else {
    desaciertosPlaza++;
  }

  perfilesRevisadosPlaza[perfilSeleccionadoPlaza] = true;
  perfilesResueltosPlaza++;
  tarjetaMetadatosPlaza = false;
  perfilSeleccionadoPlaza = -1;

  if (perfilesResueltosPlaza >= perfilesSospechososPlaza.length) {
    minijuegoPlazaActivo = false;
    minijuegoPlazaTerminado = true;
    aplicarResultadoPlaza();
  }
}

void dibujarMinijuegoPlaza() {
  if (!minijuegoPlazaActivo) {
    return;
  }

  pushStyle();

  noStroke();
  fill(0, 220);
  rect(
    120,
    120,
    width - 240,
    420,
    14
  );

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textAlign(CENTER, TOP);
  textSize(22);
  text(
    "ESCÁNER DE BOTS - PLAZA NOVA",
    width / 2,
    145
  );

  fill(190);
  textFont(fuenteCuerpo);
  textSize(13);
  text(
    "Rastrea perfiles sospechosos y verifica su identidad digital",
    width / 2,
    180
  );

  for (int i = 0; i < perfilesSospechososPlaza.length; i++) {
    if (perfilesRevisadosPlaza[i]) {
      continue;
    }

    float perfilX = perfilesXPlaza[i] + sin(frameCount * 0.018 + i) * 18;
    float perfilY = perfilesYPlaza[i] + cos(frameCount * 0.015 + i) * 12;

    fill(108, 92, 231, 90);
    ellipse(perfilX, perfilY, 56, 56);
    fill(248, 246, 240);
    ellipse(perfilX, perfilY, 42, 42);
    fill(45, 52, 54);
    textFont(fuenteCuerpo);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(perfilesSospechososPlaza[i].substring(1, 2).toUpperCase(), perfilX, perfilY);
    textSize(10);
    text(perfilesSospechososPlaza[i], perfilX, perfilY + 40);
  }

  stroke(108, 220, 231);
  strokeWeight(2);
  noFill();
  ellipse(reticulaX, reticulaY, 64, 64);
  line(reticulaX - 42, reticulaY, reticulaX - 22, reticulaY);
  line(reticulaX + 22, reticulaY, reticulaX + 42, reticulaY);
  line(reticulaX, reticulaY - 42, reticulaX, reticulaY - 22);
  line(reticulaX, reticulaY + 22, reticulaX, reticulaY + 42);

  noStroke();
  fill(220);
  textFont(fuenteCuerpo);
  textAlign(LEFT, BOTTOM);
  textSize(12);
  text("X / Clic: escanear   |   R1: desmantelar bot   |   L1: confirmar ciudadano", 150, 515);
  text("Bots desmantelados: " + botsDesmanteladosPlaza + "   Perfiles analizados: " + perfilesResueltosPlaza + "/5", 150, 535);

  if (tarjetaMetadatosPlaza && perfilSeleccionadoPlaza != -1) {
    dibujarTarjetaMetadatosPlaza();
  }

  popStyle();
}

void dibujarTarjetaMetadatosPlaza() {
  float tarjetaX = width / 2 - 220;
  float tarjetaY = 205;

  fill(45, 52, 54, 235);
  stroke(108, 220, 231);
  strokeWeight(2);
  rect(tarjetaX, tarjetaY, 440, 150, 14);

  fill(108, 220, 231);
  textFont(fuenteTitulo);
  textAlign(LEFT, TOP);
  textSize(18);
  text("PERFIL ESCANEADO", tarjetaX + 22, tarjetaY + 18);

  fill(248, 246, 240);
  textFont(fuenteCuerpo);
  textSize(15);
  text(perfilesSospechososPlaza[perfilSeleccionadoPlaza], tarjetaX + 22, tarjetaY + 50);
  fill(210);
  textSize(13);
  text(metadatosPerfilesPlaza[perfilSeleccionadoPlaza], tarjetaX + 22, tarjetaY + 78, 396, 40);
  fill(255);
  textSize(12);
  text("R1  Desmantelar Bot        L1  Confirmar Ciudadano Real", tarjetaX + 22, tarjetaY + 124);
}

void aplicarResultadoPlaza() {
  if (botsDesmanteladosPlaza >= 3) {
    cambiarIndicadores(
      +15,
      +10,
      +10,
      +15,
      +15
    );
    println("RESULTADO PLAZA: EXCELENTE");
  } else if (botsDesmanteladosPlaza >= 2) {
    cambiarIndicadores(
      +5,
      +5,
      +5,
      +5,
      +5
    );
    println("RESULTADO PLAZA: REGULAR");
  } else {
    cambiarIndicadores(
      -10,
      -5,
      -5,
      -10,
      -15
    );
    println("RESULTADO PLAZA: MALO - Bots desmantelados: " + botsDesmanteladosPlaza);
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