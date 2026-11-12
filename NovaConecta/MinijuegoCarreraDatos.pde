// =====================================================
// MINIJUEGO 1 - CARRERA DE DATOS DE VERIFICACIÓN
// =====================================================

int carrilJugador = 1;
float progresoCarrera = 0;
int vidasCarrera = 3;
float velocidadCarreraBase = 4.0;
float aceleracionCarrera = 0.008;
float velocidadCarrera = velocidadCarreraBase;
boolean impactoRojo = false;
int tiempoImpacto = 0;
int ralentizacionAvatarHasta = 0;
int ultimoCambioCarril = 0;
int datosCorrectos = 0;
int datosIncorrectos = 0;
int resultadoCarrera = 0;
boolean minijuego1Activo = false;
boolean minijuego1IniciadoAntes = false;
boolean mostrarAvisoMinijuego1 = false;
boolean botonMinijuego1PresionadoAntes = false;

final float ALTURA_COLISION_CARRERA = 120;
final float VELOCIDAD_BLOQUES_CARRERA = 220;
final int INTERVALO_BLOQUES_CARRERA = 600;

ArrayList<BloqueDato> bloquesDatos = new ArrayList<BloqueDato>();

int ultimoBloqueCarrera = 0;
int ultimoFrameCarrera = 0;
int tipoBloqueCarrera = 0;
boolean joystickIzquierdaCarreraAntes = false;
boolean joystickDerechaCarreraAntes = false;
boolean teclaIzquierdaCarreraAntes = false;
boolean teclaDerechaCarreraAntes = false;
boolean flechaIzquierdaCarreraAntes = false;
boolean flechaDerechaCarreraAntes = false;

String[] textosBloquesCarrera = {
  "Comunicado Oficial",
  "Audio Editado",
  "Fuente Anónima",
  "Dato Verificado",
  "Titular sin Fuente",
  "Registro Público"
};

boolean[] confiableBloqueCarrera = {
  true,
  false,
  false,
  true,
  false,
  true
};

class BloqueDato {
  int carril;
  float posY;
  boolean esConfiable;
  String textoBreve;

  BloqueDato(int carril, float posY, boolean esConfiable, String textoBreve) {
    this.carril = carril;
    this.posY = posY;
    this.esConfiable = esConfiable;
    this.textoBreve = textoBreve;
  }
}

void iniciarMinijuego1() {
  if (minijuego1IniciadoAntes) {
    return;
  }

  carrilJugador = 1;
  progresoCarrera = 0;
  vidasCarrera = 3;
  velocidadCarrera = velocidadCarreraBase;
  impactoRojo = false;
  tiempoImpacto = 0;
  ralentizacionAvatarHasta = 0;
  ultimoCambioCarril = 0;
  datosCorrectos = 0;
  datosIncorrectos = 0;
  resultadoCarrera = 0;
  bloquesDatos.clear();
  ultimoBloqueCarrera = millis();
  ultimoFrameCarrera = millis();
  tipoBloqueCarrera = 0;
  joystickIzquierdaCarreraAntes = false;
  joystickDerechaCarreraAntes = false;
  teclaIzquierdaCarreraAntes = false;
  teclaDerechaCarreraAntes = false;
  flechaIzquierdaCarreraAntes = false;
  flechaDerechaCarreraAntes = false;
  mostrarAvisoMinijuego1 = false;
  minijuego1IniciadoAntes = true;
  minijuego1Activo = true;
  estadoJuego = ESTADO_MINIJUEGO1;
}

boolean jugadorEnEntradaColegio() {
  return dist(jugadorX, jugadorY, 1000, 850) <= 120;
}

void actualizarControlMinijuego1() {
  if (
    estadoJuego != ESTADO_JUEGO ||
    escenario != 2 ||
    minijuego1IniciadoAntes ||
    !mandoConectado ||
    botonX == null
  ) {
    botonMinijuego1PresionadoAntes = false;
    return;
  }

  boolean botonAhora = botonX.pressed();
  if (botonAhora && !botonMinijuego1PresionadoAntes) {
    if (mostrarAvisoMinijuego1) {
      iniciarMinijuego1();
    } else if (jugadorEnEntradaColegio()) {
      mostrarAvisoMinijuego1 = true;
    }
  }
  botonMinijuego1PresionadoAntes = botonAhora;
}

boolean manejarClicMinijuego1() {
  if (estadoJuego != ESTADO_JUEGO || escenario != 2 || minijuego1IniciadoAntes) {
    return false;
  }

  if (mostrarAvisoMinijuego1) {
    float botonX = width / 2.0;
    float botonY = height - 90;
    if (
      mouseX >= botonX - 115 && mouseX <= botonX + 115 &&
      mouseY >= botonY - 23 && mouseY <= botonY + 23
    ) {
      iniciarMinijuego1();
      return true;
    }
  }

  if (!redSocialAbierta) {
    return false;
  }

  float telefonoY = height / 2.0 - 280;
  boolean clicNoticia =
    mouseX >= width / 2.0 - 170 &&
    mouseX <= width / 2.0 + 170 &&
    (
      (mouseY >= telefonoY + 120 && mouseY <= telefonoY + 220 && !crisisColegioResuelta[0]) ||
      (mouseY >= telefonoY + 235 && mouseY <= telefonoY + 335 && !crisisColegioResuelta[1]) ||
      (mouseY >= telefonoY + 350 && mouseY <= telefonoY + 450 && !crisisColegioResuelta[2])
    );

  if (clicNoticia) {
    mostrarAvisoMinijuego1 = true;
    return true;
  }

  return false;
}

void dibujarAvisoMinijuego1() {
  if (
    !mostrarAvisoMinijuego1 ||
    estadoJuego != ESTADO_JUEGO ||
    escenario != 2 ||
    minijuego1IniciadoAntes
  ) {
    return;
  }

  pushStyle();
  rectMode(CORNER);
  noStroke();
  fill(0, 0, 0, 165);
  rect(width / 2 - 300, height - 166, 600, 118, 18);

  fill(248, 246, 240);
  stroke(108, 92, 231);
  strokeWeight(2);
  rect(width / 2 - 292, height - 174, 584, 110, 18);

  noFill();
  stroke(108, 92, 231);
  strokeWeight(3);
  ellipse(width / 2 - 245, height - 119, 22, 22);
  line(width / 2 - 237, height - 111, width / 2 - 227, height - 101);

  fill(45, 52, 54);
  noStroke();
  textFont(fuenteTitulo);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("¿Investigar noticia en la Red de Datos?", width / 2 - 210, height - 132);

  fill(108, 92, 231);
  rectMode(CENTER);
  rect(width / 2, height - 90, 230, 46, 23);
  fill(255);
  textFont(fuenteCuerpo);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("[Presiona X / Enter]", width / 2, height - 90);
  popStyle();
}

void controlarTecladoMinijuego1(boolean presionado) {
  if (key == 'a' || key == 'A') {
    if (presionado && !teclaIzquierdaCarreraAntes) {
      cambiarCarrilCarrera(-1);
    }
    teclaIzquierdaCarreraAntes = presionado;
  } else if (key == 'd' || key == 'D') {
    if (presionado && !teclaDerechaCarreraAntes) {
      cambiarCarrilCarrera(1);
    }
    teclaDerechaCarreraAntes = presionado;
  } else if (key == CODED && keyCode == LEFT) {
    if (presionado && !flechaIzquierdaCarreraAntes) {
      cambiarCarrilCarrera(-1);
    }
    flechaIzquierdaCarreraAntes = presionado;
  } else if (key == CODED && keyCode == RIGHT) {
    if (presionado && !flechaDerechaCarreraAntes) {
      cambiarCarrilCarrera(1);
    }
    flechaDerechaCarreraAntes = presionado;
  }
}

void cambiarCarrilCarrera(int cambio) {
  int ahora = millis();
  if (
    ahora < ralentizacionAvatarHasta &&
    ahora - ultimoCambioCarril < 180
  ) {
    return;
  }

  int carrilNuevo = constrain(carrilJugador + cambio, 0, 2);
  if (carrilNuevo != carrilJugador) {
    carrilJugador = carrilNuevo;
    ultimoCambioCarril = ahora;
  }
}

void actualizarMinijuego1() {
  if (!minijuego1Activo) {
    background(30);
    return;
  }

  int ahora = millis();
  if (vidasCarrera <= 0) {
    finalizarMinijuego1ConDerrota();
    return;
  }

  float deltaSegundos = max(0, ahora - ultimoFrameCarrera) / 1000.0;
  ultimoFrameCarrera = ahora;
  velocidadCarrera = velocidadCarreraBase + progresoCarrera * aceleracionCarrera;
  progresoCarrera = min(100, progresoCarrera + velocidadCarrera * deltaSegundos);

  actualizarCarrilJoystickMinijuego1();
  generarBloquesCarrera(ahora);
  actualizarBloquesCarrera(deltaSegundos);
  if (!minijuego1Activo) {
    return;
  }
  dibujarCarreraDatos();

  if (progresoCarrera >= 100) {
    finalizarMinijuego1();
  }
}

void actualizarCarrilJoystickMinijuego1() {
  float ejeX = 0;
  if (mandoConectado && joystickX != null) {
    ejeX = joystickX.getValue();
  }

  boolean izquierdaAhora = ejeX < -0.5;
  boolean derechaAhora = ejeX > 0.5;

  if (izquierdaAhora && !joystickIzquierdaCarreraAntes) {
    cambiarCarrilCarrera(-1);
  }
  if (derechaAhora && !joystickDerechaCarreraAntes) {
    cambiarCarrilCarrera(1);
  }

  joystickIzquierdaCarreraAntes = izquierdaAhora;
  joystickDerechaCarreraAntes = derechaAhora;
}

void generarBloquesCarrera(int ahora) {
  if (ahora - ultimoBloqueCarrera < INTERVALO_BLOQUES_CARRERA) {
    return;
  }

  ultimoBloqueCarrera = ahora;
  int carril = (int) random(3);
  if (random(1) < 0.45) {
    int carrilExtra = (carril + 1 + (int) random(2)) % 3;
    int[] tiposFake = {1, 2, 4};
    for (int i = 0; i < 2; i++) {
      int carrilBloque = i == 0 ? carril : carrilExtra;
      int tipoFake = tiposFake[(int) random(tiposFake.length)];
      bloquesDatos.add(
        new BloqueDato(
          carrilBloque,
          180,
          false,
          textosBloquesCarrera[tipoFake]
        )
      );
    }
    tipoBloqueCarrera++;
  } else {
    int tipo = tipoBloqueCarrera % textosBloquesCarrera.length;
    bloquesDatos.add(
      new BloqueDato(
        carril,
        180,
        confiableBloqueCarrera[tipo],
        textosBloquesCarrera[tipo]
      )
    );
    tipoBloqueCarrera++;
  }
}

void aplicarDanoCarrera() {
  vidasCarrera = max(0, vidasCarrera - 1);
  impactoRojo = true;
  tiempoImpacto = millis();
  ralentizacionAvatarHasta = tiempoImpacto + 400;
  ultimoCambioCarril = tiempoImpacto;
  if (vidasCarrera <= 0) {
    finalizarMinijuego1ConDerrota();
  }
}

void actualizarBloquesCarrera(float deltaSegundos) {
  float alturaJugador = height - ALTURA_COLISION_CARRERA;
  float factorDificultad = velocidadCarrera / velocidadCarreraBase;

  for (int i = bloquesDatos.size() - 1; i >= 0; i--) {
    BloqueDato bloque = bloquesDatos.get(i);
    float posicionAnterior = bloque.posY;
    bloque.posY += VELOCIDAD_BLOQUES_CARRERA * factorDificultad * deltaSegundos;

    boolean cruzaAvatar =
      posicionAnterior <= alturaJugador + 35 &&
      bloque.posY >= alturaJugador - 35;

    if (bloque.carril == carrilJugador && cruzaAvatar) {
      if (bloque.esConfiable) {
        datosCorrectos++;
        progresoCarrera = min(100, progresoCarrera + 2.5);
      } else {
        datosIncorrectos++;
        aplicarDanoCarrera();
      }
      bloquesDatos.remove(i);
      if (!minijuego1Activo) {
        return;
      }
      if (!bloque.esConfiable) {
        break;
      }
    } else if (bloque.posY > height) {
      bloquesDatos.remove(i);
    }
  }
}

void dibujarCarreraDatos() {
  dibujarPistaCarrera();
  dibujarBloquesCarrera();
  dibujarAvatarCarrera();
  dibujarHudCarrera();
  dibujarImpactoRojoCarrera();
}

void dibujarPistaCarrera() {
  pushStyle();
  background(190, 185, 170);

  stroke(108, 92, 231, 120);
  strokeWeight(2);
  fill(245, 235, 210);
  beginShape();
  vertex(width / 2.0 - 70, 180);
  vertex(width / 2.0 + 70, 180);
  vertex(width / 2.0 + 420, height);
  vertex(width / 2.0 - 420, height);
  endShape(CLOSE);

  stroke(178, 178, 158);
  strokeWeight(1);
  for (int i = 1; i <= 8; i++) {
    float y = lerp(180, height, i / 9.0);
    float t = (y - 180) / (height - 180);
    float halfWidth = lerp(70, 420, t);
    line(width / 2.0 - halfWidth, y, width / 2.0 + halfWidth, y);
  }

  stroke(108, 92, 231, 120);
  strokeWeight(2);
  for (int i = 1; i < 3; i++) {
    float xEnHorizonte = lerp(
      pistaIzquierdaEnY(180),
      pistaDerechaEnY(180),
      i / 3.0
    );
    float xEnBase = lerp(
      pistaIzquierdaEnY(height),
      pistaDerechaEnY(height),
      i / 3.0
    );
    line(xEnHorizonte, 180, xEnBase, height);
  }
  popStyle();
}

float pistaIzquierdaEnY(float y) {
  float t = constrain(map(y, 180, height, 0, 1), 0, 1);
  return lerp(width / 2.0 - 70, width / 2.0 - 420, t);
}

float pistaDerechaEnY(float y) {
  float t = constrain(map(y, 180, height, 0, 1), 0, 1);
  return lerp(width / 2.0 + 70, width / 2.0 + 420, t);
}

void dibujarBloquesCarrera() {
  pushStyle();
  for (BloqueDato bloque : bloquesDatos) {
    float t = map(bloque.posY, 180, height - 100, 0.25, 1.0);
    float xIzq = lerp(width / 2.0 - 70, width / 2.0 - 420, t);
    float xDer = lerp(width / 2.0 + 70, width / 2.0 + 420, t);
    float centroX = lerp(xIzq, xDer, (bloque.carril + 0.5) / 3.0);
    float bloqueW = 280 * t;
    float bloqueH = 112 * t;
    float avatarD = 28 * t;
    float margen = 10 * t;
    float encabezadoH = 27 * t;
    float tarjetaX = centroX - bloqueW / 2;
    float tarjetaY = bloque.posY - bloqueH / 2;

    rectMode(CENTER);
    fill(60, 50, 40, 30);
    noStroke();
    rect(centroX, bloque.posY + 4 * t, bloqueW, bloqueH, 10);

    rectMode(CORNER);
    fill(255);
    stroke(228, 225, 220);
    strokeWeight(max(1, t));
    rect(tarjetaX, tarjetaY, bloqueW, bloqueH, 10);

    noStroke();
    fill(bloque.esConfiable ? color(87, 176, 116) : color(232, 111, 105));
    rect(tarjetaX, tarjetaY, bloqueW, encabezadoH, 10, 10, 0, 0);

    fill(196, 180, 225);
    ellipse(tarjetaX + margen + avatarD / 2, tarjetaY + encabezadoH + 20 * t, avatarD, avatarD);
    fill(255);
    textFont(fuenteCuerpo);
    textAlign(CENTER, CENTER);
    textSize(max(7, 11 * t));
    text(bloque.esConfiable ? "V" : "!", tarjetaX + margen + avatarD / 2, tarjetaY + encabezadoH + 20 * t);

    fill(255);
    textFont(fuenteCuerpo);
    textAlign(LEFT, CENTER);
    String etiqueta = bloque.textoBreve;
    float textoX = tarjetaX + margen * 2 + avatarD;
    float textoY = tarjetaY + encabezadoH + 20 * t;
    float anchoTexto = tarjetaX + bloqueW - margen - textoX;
    float tamanoTexto = max(8, 15 * t);
    textSize(tamanoTexto);
    while (textWidth(etiqueta) > anchoTexto && tamanoTexto > 7) {
      tamanoTexto--;
      textSize(tamanoTexto);
    }
    text(etiqueta, textoX, textoY);

    if (t >= 0.6) {
      fill(112, 106, 115);
      textSize(max(7, 10 * t));
      text(
        "PUBLICACIÓN  /  " + (bloque.esConfiable ? "VERIFICADA" : "POR VERIFICAR"),
        tarjetaX + margen,
        tarjetaY + bloqueH - 12 * t
      );
    }
  }
  popStyle();
}

void dibujarAvatarCarrera() {
  float centroX = lerp(
    pistaIzquierdaEnY(height),
    pistaDerechaEnY(height),
    (carrilJugador + 0.5) / 3.0
  );
  float centroY = height - 120;

  pushStyle();
  noStroke();
  fill(70, 70, 70, 120);
  ellipse(centroX, centroY + 15, 36, 10);
  fill(160, 70, 210);
  rect(centroX - 12, centroY - 10, 24, 22, 4);
  fill(230, 180, 140);
  ellipse(centroX, centroY - 22, 22, 22);
  fill(60, 40, 30);
  arc(centroX, centroY - 25, 22, 18, PI, TWO_PI, CHORD);
  popStyle();
}

void dibujarHudCarrera() {
  pushStyle();
  rectMode(CORNER);
  stroke(108, 92, 231);
  strokeWeight(2);
  fill(45, 52, 54, 230);
  rect(24, 20, width - 48, 92, 14);

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("VERIFICACIÓN EN LA RED", 44, 46);

  textFont(fuenteCuerpo);
  textSize(15);
  text("Correctos: " + datosCorrectos + " | Falsos: " + datosIncorrectos, 44, 82);

  noStroke();
  float barraX = width - 370;
  float barraY = 76;
  float barraW = 250;
  float barraH = 12;
  fill(20, 25, 28);
  rect(barraX, barraY, barraW, barraH, 6);
  fill(108, 92, 231);
  rect(barraX, barraY, barraW * progresoCarrera / 100.0, barraH, 6);

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textSize(16);
  textAlign(RIGHT, CENTER);
  if (vidasCarrera == 1) {
    noStroke();
    fill(232, 111, 105, max(0, sin(frameCount * 0.3) * 200));
    rect(width - 180, 30, 136, 32, 8);
    fill(248, 246, 240);
  }
  text("VIDAS: " + vidasCarrera + "/3", width - 44, 46);
  textFont(fuenteCuerpo);
  textSize(13);
  text(round(progresoCarrera) + "%", width - 44, 78);
  textAlign(CENTER, CENTER);
  text("A / D o joystick para cambiar de carril", width / 2, height - 34);
  popStyle();
}

void dibujarImpactoRojoCarrera() {
  if (!impactoRojo) {
    return;
  }

  if (millis() - tiempoImpacto >= 200) {
    impactoRojo = false;
    return;
  }

  pushStyle();
  noStroke();
  fill(232, 111, 105, 70);
  rect(0, 0, width, height);
  popStyle();
}

void finalizarMinijuego1() {
  if (vidasCarrera <= 0 || datosCorrectos < 4) {
    finalizarMinijuego1ConDerrota();
    return;
  }

  if (vidasCarrera >= 2 && datosCorrectos >= 7) {
    resultadoCarrera = 1;
    cambiarIndicadores(15, 10, 5, 10, 15);
  } else {
    resultadoCarrera = 2;
    cambiarIndicadores(5, -5, 0, 0, -5);
  }

  regresarAlColegioDesdeCarrera();
}

void finalizarMinijuego1ConDerrota() {
  if (!minijuego1Activo) {
    return;
  }

  resultadoCarrera = 3;
  cambiarIndicadores(-15, -10, -5, 5, -20);
  regresarAlColegioDesdeCarrera();
}

void regresarAlColegioDesdeCarrera() {
  minijuego1Activo = false;
  estadoJuego = ESTADO_JUEGO;
  cargarEscenario(2);
  jugadorX = 1000;
  jugadorY = 850;
  actualizarCamara();

  minijuegoColegioActivo = true;
  minijuegoColegioTerminado = false;
  publicacionColegioActual = -1;
  puntoAcopioActual = -1;
  publicacionVerificadaColegio = new boolean[] {false, false, false};
  crisisColegioResuelta = new boolean[] {false, false, false};
  crisisColegioCompletadas = 0;
  viralidadColegio = new float[] {70, 55, 45};
  redSocialAbierta = false;

  if (resultadoCarrera == 1) {
    activarTipConecta(2);
    tituloTipConecta = "VERIFICADOR: Fake News frenada";
    mensajeTipConecta = "Frenaste la Fake News. El Colegio Nova puede seguir verificando las crisis electorales.";
  } else if (resultadoCarrera == 2) {
    activarTipConecta(3);
    tituloTipConecta = "La duda sigue en los pasillos";
    mensajeTipConecta = "La información quedó sin resolver. Investiga las tres situaciones electorales en el Colegio.";
  } else if (resultadoCarrera == 3) {
    activarTipConecta(1);
    tituloTipConecta = "ALERTA: desinformación en el Colegio";
    mensajeTipConecta = "Cayeron la Reputación y la Convivencia. Verifica las crisis electorales para frenar el daño.";
  }
}
