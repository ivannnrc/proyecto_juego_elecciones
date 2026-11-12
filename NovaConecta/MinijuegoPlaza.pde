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
int vidasPlaza = 3;
boolean impactoRojoPlaza = false;
int tiempoImpactoPlaza = 0;
boolean derrotaPlaza = false;

float reticulaX = 0;
float reticulaY = 0;
int perfilSeleccionadoPlaza = -1;
int perfilesResueltosPlaza = 0;
int botsDesmanteladosPlaza = 0;
boolean tarjetaMetadatosPlaza = false;

float[] perfilesXPlaza = {230, 420, 610, 800, 990, 1150, 520};
float[] perfilesYPlaza = {235, 380, 250, 405, 240, 390, 315};
float[] velXPlaza = {2.8, -3.1, 3.3, -2.9, 3.2, -3.4, 3.0};
float[] velYPlaza = {2.1, -2.3, -2.0, 2.4, 2.2, -2.1, 2.3};

String[] perfilesSospechososPlaza = {
  "@voz_vecinal",
  "@alerta_nova",
  "@registraduria_nova",
  "@bot_nova_500",
  "@foro_abierto",
  "@prensa_verificada",
  "@cambio_real"
};

// 0 = Ciudadano Real | 1 = Bot | 2 = Cuenta Oficial Protegida ("Bomba")
int[] tipoPerfilPlaza = {
  0, 1, 2, 1, 1, 2, 0
};

String[] metadatosPerfilesPlaza = {
  "Antigüedad: 4 años | Patrón: conversaciones variadas",
  "Antigüedad: 1 hora | Patrón: 500 mensajes idénticos",
  "CUENTA OFICIAL | Sello institucional verificado",
  "Antigüedad: 3 minutos | Patrón: publica cada 10 segundos",
  "Antigüedad: 8 minutos | Patrón: repite etiquetas coordinadas",
  "CUENTA OFICIAL | Medio acreditado del debate",
  "Antigüedad: 2 años | Patrón: responde con experiencias propias"
};

boolean[] perfilesRevisadosPlaza = new boolean[7];

// =====================================================
// LÓGICA DEL MINIJUEGO PLAZA
// =====================================================

void iniciarMinijuegoPlaza() {
  aciertosPlaza = 0;
  desaciertosPlaza = 0;
  vidasPlaza = 3;
  impactoRojoPlaza = false;
  tiempoImpactoPlaza = 0;
  derrotaPlaza = false;

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
  reticulaX = width / 2.0;
  reticulaY = height / 2.0;

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
  rect(80, 250, width - 160, 125, 12);

  noFill();
  stroke(255);
  strokeWeight(2);
  rect(80, 250, width - 160, 125, 12);

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
      "El flujo de mensajes en el debate está fuera de control: hay bots, ciudadanos y cuentas oficiales.",
      100,
      300
    );
  } else if (dialogoLaura == 2) {
    text(
      "Escanea rápido con X. ¡Cuidado con censurar cuentas oficiales o ciudadanos reales!",
      100,
      300
    );
  } else if (dialogoLaura == 3) {
    text(
      "Si cometes 3 errores de moderación perderás credibilidad. Usa R1 (Bot) o L1 (Real/Oficial).",
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

  // Mover los nodos rápidamente dentro del área del escáner
  if (!tarjetaMetadatosPlaza) {
    for (int i = 0; i < perfilesSospechososPlaza.length; i++) {
      if (perfilesRevisadosPlaza[i]) continue;
      perfilesXPlaza[i] += velXPlaza[i];
      perfilesYPlaza[i] += velYPlaza[i];

      if (perfilesXPlaza[i] < 185 || perfilesXPlaza[i] > width - 185) {
        velXPlaza[i] *= -1;
      }
      if (perfilesYPlaza[i] < 220 || perfilesYPlaza[i] > 455) {
        velYPlaza[i] *= -1;
      }
    }
  }

  float velocidadReticula = 6;
  if (moverArriba) reticulaY -= velocidadReticula;
  if (moverAbajo) reticulaY += velocidadReticula;
  if (moverIzquierda) reticulaX -= velocidadReticula;
  if (moverDerecha) reticulaX += velocidadReticula;

  if (mandoConectado) {
    float jx = joystickX.getValue();
    float jy = joystickY.getValue();
    if (abs(jx) < 0.15) jx = 0;
    if (abs(jy) < 0.15) jy = 0;

    reticulaX += jx * 8;
    reticulaY += jy * 8;
  }

  if (mouseX != pmouseX || mouseY != pmouseY) {
    reticulaX = mouseX;
    reticulaY = mouseY;
  }

  reticulaX = constrain(reticulaX, 155, width - 155);
  reticulaY = constrain(reticulaY, 205, 485);

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
  float distanciaCercana = 52;

  for (int i = 0; i < perfilesSospechososPlaza.length; i++) {
    if (perfilesRevisadosPlaza[i]) {
      continue;
    }

    float distancia = dist(reticulaX, reticulaY, perfilesXPlaza[i], perfilesYPlaza[i]);

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

  int tipo = tipoPerfilPlaza[perfilSeleccionadoPlaza];
  boolean esBot = (tipo == 1);
  boolean esOficial = (tipo == 2);

  if (desmantelarBot && esOficial) {
    // Error crítico: censuraste una fuente oficial verificada ("bomba")
    desaciertosPlaza++;
    vidasPlaza = max(0, vidasPlaza - 2);
    impactoRojoPlaza = true;
    tiempoImpactoPlaza = millis();
  } else if (desmantelarBot == esBot) {
    aciertosPlaza++;
    if (esBot) {
      botsDesmanteladosPlaza++;
    }
  } else {
    desaciertosPlaza++;
    vidasPlaza = max(0, vidasPlaza - 1);
    impactoRojoPlaza = true;
    tiempoImpactoPlaza = millis();
  }

  perfilesRevisadosPlaza[perfilSeleccionadoPlaza] = true;
  perfilesResueltosPlaza++;
  tarjetaMetadatosPlaza = false;
  perfilSeleccionadoPlaza = -1;

  // Verificar derrota inmediata
  if (vidasPlaza <= 0) {
    derrotaPlaza = true;
    minijuegoPlazaActivo = false;
    minijuegoPlazaTerminado = true;
    aplicarResultadoPlaza();
    return;
  }

  // Verificar victoria al analizar todos
  if (perfilesResueltosPlaza >= perfilesSospechososPlaza.length) {
    derrotaPlaza = false;
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
  fill(45, 52, 54, 235);
  rect(120, 115, width - 240, 440, 16);
  stroke(108, 92, 231);
  strokeWeight(2);
  noFill();
  rect(120, 115, width - 240, 440, 16);
  noStroke();

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textAlign(CENTER, TOP);
  textSize(22);
  text("ESCÁNER DE BOTS - PLAZA NOVA", width / 2, 136);

  fill(196, 180, 225);
  textFont(fuenteCuerpo);
  textSize(13);
  text(
    "Desmantela los bots (R1) y protege ciudadanos o cuentas oficiales (L1)",
    width / 2,
    168
  );

  // Indicador de Credibilidad (Vidas)
  textFont(fuenteTitulo);
  textAlign(RIGHT, TOP);
  textSize(16);
  if (vidasPlaza == 1) {
    fill(232, 111, 105, max(90, sin(frameCount * 0.3) * 255));
  } else {
    fill(87, 176, 116);
  }
  text("CREDIBILIDAD: " + vidasPlaza + "/3", width - 150, 140);

  for (int i = 0; i < perfilesSospechososPlaza.length; i++) {
    if (perfilesRevisadosPlaza[i]) {
      continue;
    }

    float perfilX = perfilesXPlaza[i];
    float perfilY = perfilesYPlaza[i];
    int tipo = tipoPerfilPlaza[i];

    // Las cuentas oficiales tienen halo dorado distintivo
    if (tipo == 2) {
      fill(245, 190, 40, 95);
    } else {
      fill(108, 92, 231, 90);
    }
    ellipse(perfilX, perfilY, 54, 54);

    fill(248, 246, 240);
    ellipse(perfilX, perfilY, 40, 40);

    fill(45, 52, 54);
    textFont(fuenteTitulo);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(perfilesSospechososPlaza[i].substring(1, 2).toUpperCase(), perfilX, perfilY);

    fill(240);
    textFont(fuenteCuerpo);
    textSize(10);
    text(perfilesSospechososPlaza[i], perfilX, perfilY + 36);
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
  text("X / Clic: escanear   |   R1: desmantelar bot   |   L1: confirmar real / oficial", 150, 522);
  text(
    "Bots desmantelados: " + botsDesmanteladosPlaza + "/3   |   Perfiles analizados: " + perfilesResueltosPlaza + "/7",
    150,
    542
  );

  if (tarjetaMetadatosPlaza && perfilSeleccionadoPlaza != -1) {
    dibujarTarjetaMetadatosPlaza();
  }

  // Destello rojo si cometiste un error
  if (impactoRojoPlaza) {
    if (millis() - tiempoImpactoPlaza < 220) {
      fill(232, 111, 105, 85);
      rect(120, 115, width - 240, 440, 16);
    } else {
      impactoRojoPlaza = false;
    }
  }

  popStyle();
}

void dibujarTarjetaMetadatosPlaza() {
  float tarjetaX = width / 2 - 230;
  float tarjetaY = 205;
  int tipo = tipoPerfilPlaza[perfilSeleccionadoPlaza];

  fill(45, 52, 54, 242);
  stroke(tipo == 2 ? color(245, 190, 40) : color(108, 220, 231));
  strokeWeight(2);
  rect(tarjetaX, tarjetaY, 460, 155, 14);

  fill(tipo == 2 ? color(245, 190, 40) : color(108, 220, 231));
  textFont(fuenteTitulo);
  textAlign(LEFT, TOP);
  textSize(18);
  text(tipo == 2 ? "FUENTE INSTITUCIONAL DETECTADA" : "PERFIL ESCANEADO", tarjetaX + 22, tarjetaY + 18);

  fill(248, 246, 240);
  textFont(fuenteCuerpo);
  textSize(15);
  text(perfilesSospechososPlaza[perfilSeleccionadoPlaza], tarjetaX + 22, tarjetaY + 50);

  fill(210);
  textSize(13);
  text(metadatosPerfilesPlaza[perfilSeleccionadoPlaza], tarjetaX + 22, tarjetaY + 78, 416, 40);

  fill(255);
  textSize(12);
  text("R1  Desmantelar Bot        L1  Confirmar Real / Oficial", tarjetaX + 22, tarjetaY + 126);
}

void aplicarResultadoPlaza() {
  if (derrotaPlaza || vidasPlaza <= 0) {
    cambiarIndicadores(-15, -15, -10, -10, -25);
  } else if (botsDesmanteladosPlaza >= 3 && vidasPlaza >= 2) {
    cambiarIndicadores(+15, +15, +10, +15, +20);
  } else {
    cambiarIndicadores(+5, +5, +5, +5, +5);
  }

  slideFinal = 1;
  caracteresVisiblesFinal = 0;
  tiempoInicioFinal = millis();
  ultimoTipeadoFinal = tiempoInicioFinal;
  estadoJuego = ESTADO_FINAL;
}