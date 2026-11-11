// =====================================================
// MINIJUEGO 1 - CARRERA DE DATOS DE VERIFICACIÓN
// =====================================================

int carrilJugador = 1;
float progresoCarrera = 0;
float velocidadCarrera = 3.5;
int datosCorrectos = 0;
int datosIncorrectos = 0;
int resultadoCarrera = 0;
boolean minijuego1Activo = false;
boolean minijuego1IniciadoAntes = false;
boolean mostrarAvisoMinijuego1 = false;
boolean botonMinijuego1PresionadoAntes = false;

final float ALTURA_COLISION_CARRERA = 130;
final float VELOCIDAD_BLOQUES_CARRERA = 220;
final int INTERVALO_BLOQUES_CARRERA = 850;

ArrayList<BloqueDato> bloquesDatos = new ArrayList<BloqueDato>();

int ultimoBloqueCarrera = 0;
int ultimoFrameCarrera = 0;
int tipoBloqueCarrera = 0;
boolean joystickIzquierdaCarreraAntes = false;
boolean joystickDerechaCarreraAntes = false;
boolean teclaIzquierdaCarreraAntes = false;
boolean teclaDerechaCarreraAntes = false;

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
      carrilJugador = max(0, carrilJugador - 1);
    }
    teclaIzquierdaCarreraAntes = presionado;
  } else if (key == 'd' || key == 'D') {
    if (presionado && !teclaDerechaCarreraAntes) {
      carrilJugador = min(2, carrilJugador + 1);
    }
    teclaDerechaCarreraAntes = presionado;
  }
}

void actualizarMinijuego1() {
  if (!minijuego1Activo) {
    background(30);
    return;
  }

  int ahora = millis();
  float deltaSegundos = max(0, ahora - ultimoFrameCarrera) / 1000.0;
  ultimoFrameCarrera = ahora;
  progresoCarrera = min(100, progresoCarrera + velocidadCarrera * deltaSegundos);

  actualizarCarrilJoystickMinijuego1();
  generarBloquesCarrera(ahora);
  actualizarBloquesCarrera(deltaSegundos);
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
    carrilJugador = max(0, carrilJugador - 1);
  }
  if (derechaAhora && !joystickDerechaCarreraAntes) {
    carrilJugador = min(2, carrilJugador + 1);
  }

  joystickIzquierdaCarreraAntes = izquierdaAhora;
  joystickDerechaCarreraAntes = derechaAhora;
}

void generarBloquesCarrera(int ahora) {
  if (ahora - ultimoBloqueCarrera < INTERVALO_BLOQUES_CARRERA) {
    return;
  }

  ultimoBloqueCarrera = ahora;
  int tipo = tipoBloqueCarrera % textosBloquesCarrera.length;
  int carril = (int) random(3);
  bloquesDatos.add(
    new BloqueDato(
      carril,
      -50,
      confiableBloqueCarrera[tipo],
      textosBloquesCarrera[tipo]
    )
  );
  tipoBloqueCarrera++;
}

void actualizarBloquesCarrera(float deltaSegundos) {
  float alturaJugador = height - ALTURA_COLISION_CARRERA;

  for (int i = bloquesDatos.size() - 1; i >= 0; i--) {
    BloqueDato bloque = bloquesDatos.get(i);
    float posicionAnterior = bloque.posY;
    bloque.posY += VELOCIDAD_BLOQUES_CARRERA * deltaSegundos;

    boolean cruzaAvatar =
      posicionAnterior <= alturaJugador + 18 &&
      bloque.posY >= alturaJugador - 18;

    if (bloque.carril == carrilJugador && cruzaAvatar) {
      if (bloque.esConfiable) {
        datosCorrectos++;
        cambiarIndicadores(5, 0, 0, 0, 0);
      } else {
        datosIncorrectos++;
        cambiarIndicadores(0, -5, 0, 0, 0);
      }
      bloquesDatos.remove(i);
    } else if (bloque.posY > height + 50) {
      bloquesDatos.remove(i);
    }
  }
}

void dibujarCarreraDatos() {
  background(34, 39, 43);
  dibujarPistaCarrera();
  dibujarBloquesCarrera();
  dibujarAvatarCarrera();
  dibujarHudCarrera();
}

void dibujarPistaCarrera() {
  noStroke();
  fill(45, 52, 54);
  rect(0, 0, width, height);

  float anchoCarril = width / 3.0;
  for (int i = 0; i < 3; i++) {
    fill(i == carrilJugador ? color(108, 92, 231, 35) : color(20, 25, 28, 35));
    rect(i * anchoCarril + 3, 0, anchoCarril - 6, height);
  }

  stroke(190, 186, 168, 90);
  strokeWeight(2);
  for (int i = 1; i < 3; i++) {
    float x = i * anchoCarril;
    for (int y = 0; y < height; y += 38) {
      line(x, y, x, y + 20);
    }
  }
  noStroke();

  fill(255, 255, 255, 22);
  for (int y = (frameCount * 5) % 70; y < height; y += 70) {
    rect(width * 0.12, y, width * 0.76, 2);
  }
}

void dibujarBloquesCarrera() {
  float anchoCarril = width / 3.0;
  for (BloqueDato bloque : bloquesDatos) {
    float bloqueW = anchoCarril - 42;
    float bloqueH = 58;
    float bloqueX = bloque.carril * anchoCarril + 21;

    rectMode(CORNER);
    noStroke();
    fill(0, 0, 0, 55);
    rect(bloqueX + 4, bloque.posY + 5, bloqueW, bloqueH, 12);
    fill(bloque.esConfiable ? color(87, 176, 116) : color(232, 111, 105));
    rect(bloqueX, bloque.posY, bloqueW, bloqueH, 12);

    fill(255);
    textFont(fuenteCuerpo);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(bloque.textoBreve, bloqueX + 8, bloque.posY + 6, bloqueW - 16, bloqueH - 12);
  }
}

void dibujarAvatarCarrera() {
  float centroX = (carrilJugador + 0.5) * width / 3.0;
  float centroY = height - ALTURA_COLISION_CARRERA;

  noStroke();
  fill(248, 246, 240, 40);
  ellipse(centroX, centroY, 88, 88);
  fill(108, 92, 231);
  ellipse(centroX, centroY, 62, 62);

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("V", centroX, centroY);
}

void dibujarHudCarrera() {
  rectMode(CORNER);
  noStroke();
  fill(45, 52, 54, 230);
  rect(24, 20, width - 48, 92, 16);

  fill(248, 246, 240);
  textFont(fuenteTitulo);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("CARRERA DE DATOS DE VERIFICACIÓN", 44, 46);

  textFont(fuenteCuerpo);
  textSize(15);
  text("Verificados: " + datosCorrectos + "    Falsos: " + datosIncorrectos, 44, 82);

  float barraX = width - 330;
  float barraY = 76;
  float barraW = 270;
  float barraH = 12;
  fill(20, 25, 28);
  rect(barraX, barraY, barraW, barraH, 6);
  fill(108, 92, 231);
  rect(barraX, barraY, barraW * progresoCarrera / 100.0, barraH, 6);

  fill(248, 246, 240);
  textAlign(RIGHT, CENTER);
  text(round(progresoCarrera) + "%", width - 42, 48);
  textAlign(CENTER, CENTER);
  text("A / D o joystick para cambiar de carril", width / 2, height - 34);
}

void finalizarMinijuego1() {
  if (datosCorrectos >= 7) {
    resultadoCarrera = 1;
    cambiarIndicadores(15, 0, 0, 0, 15);
  } else if (datosCorrectos >= 4) {
    resultadoCarrera = 2;
    cambiarIndicadores(5, 0, 0, 0, 0);
  } else {
    resultadoCarrera = 3;
    cambiarIndicadores(0, -10, 0, 0, -10);
  }

  minijuego1Activo = false;
  estadoJuego = ESTADO_JUEGO;
  cargarEscenario(2);
  jugadorX = 1000;
  jugadorY = 850;
  actualizarCamara();
}
