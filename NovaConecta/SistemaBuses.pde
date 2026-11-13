// =====================================================
// 8. BUSES - VARIABLES
// =====================================================

float busX = -180;
float busY = 430;

float velocidadBus = 3.0;
float paradaBusX = 1450;

boolean busDetenido = false;
boolean busYaParo = false;

int tiempoBusDetenido = 0;

boolean cercaDelBus = false;

boolean xPresionadoAntes = false;

boolean viajandoEnBus = false;
float oscuridadTransicion = 0;

// =====================================================
// BUS COLEGIO -> PLAZA - VARIABLES
// =====================================================

float busPlazaX = -180;
float busPlazaY = 570;

float velocidadBusPlaza = 3;
float paradaBusPlazaX = 1000;

boolean busPlazaDetenido = false;
boolean busPlazaYaParo = false;

int tiempoBusPlazaDetenido = 0;

boolean cercaBusPlaza = false;

boolean viajandoAPlaza = false;
float oscuridadPlaza = 0;

// =====================================================
// 26. BUS BARRIO -> COLEGIO
// =====================================================

// -------------------------
// 26.1 ACTUALIZAR BUS
// -------------------------

void actualizarBus() {

  // El bus solo existe en el Barrio
  if (escenario != 1 || viajandoEnBus) {
    return;
  }

  // SI ESTÁ DETENIDO
  if (busDetenido) {

    tiempoBusDetenido++;

    // Espera unos segundos
    if (tiempoBusDetenido > 240) {
      busDetenido = false;
    }

  } else {

    // MOVER BUS
    busX += velocidadBus;

    // DETENERSE EN LA PARADA
    if (!busYaParo && busX >= paradaBusX) {

      busX = paradaBusX;

      busDetenido = true;

      busYaParo = true;

      tiempoBusDetenido = 0;
    }

    // SI SALE DEL MAPA, VUELVE A EMPEZAR
    if (busX > mundoW + 180) {

      busX = -180;

      busYaParo = false;

      busDetenido = false;

      tiempoBusDetenido = 0;
    }
  }
}

// -------------------------
// 26.2 DIBUJAR BUS
// -------------------------

void dibujarBus() {

  if (escenario != 1) {
    return;
  }

  pushStyle();

  rectMode(CENTER);

  // SOMBRA
  noStroke();
  fill(0, 50);

  ellipse(
    busX,
    busY + 43,
    220,
    25
  );

  // CUERPO DEL BUS
  fill(245, 190, 40);

  rect(
    busX,
    busY,
    220,
    82,
    14
  );

  // PARTE INFERIOR
  fill(220, 145, 20);

  rect(
    busX,
    busY + 25,
    220,
    30
  );

  // VENTANAS
  fill(120, 190, 220);

  rect(busX - 70, busY - 15, 42, 28, 5);
  rect(busX - 20, busY - 15, 42, 28, 5);
  rect(busX + 30, busY - 15, 42, 28, 5);

  // PUERTA
  fill(75, 125, 150);

  rect(
    busX + 82,
    busY + 3,
    30,
    58,
    4
  );

  // RUEDAS
  fill(35);

  ellipse(
    busX - 70,
    busY + 42,
    36,
    36
  );

  ellipse(
    busX + 70,
    busY + 42,
    36,
    36
  );

  fill(130);

  ellipse(
    busX - 70,
    busY + 42,
    15,
    15
  );

  ellipse(
    busX + 70,
    busY + 42,
    15,
    15
  );

  // TEXTO DEL BUS
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "COLEGIO NOVA",
    busX,
    busY + 15
  );

  if (busDetenido && minijuegoIncendiosTerminado) {
    float bob = sin(frameCount * 0.12) * 4;
    String textoGlobo = cercaDelBus
      ? "Presiona [X] para subir"
      : "Bus al Colegio listo";
    float globoY = busY - 68 + bob;

    rectMode(CENTER);
    fill(45, 52, 54, 235);
    stroke(255, 230, 120);
    strokeWeight(2);
    rect(busX, globoY, textWidth(textoGlobo) + 24, 30, 15);
    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    text(textoGlobo, busX, globoY);
  }

  rectMode(CORNER);

  popStyle();
}

// -------------------------
// 26.3 INTERACCIÓN CON EL BUS
// -------------------------

void revisarInteraccionBus() {

  cercaDelBus = false;

  if (
    escenario == 1 &&
    busDetenido &&
    minijuegoIncendiosTerminado
  ) {

    float distanciaBus = dist(
      jugadorX,
      jugadorY,
      busX + 75,
      busY + 25
    );

    if (distanciaBus < 105) {
      cercaDelBus = true;
    }
  }

  if (
    mandoConectado &&
    cercaDelBus &&
    minijuegoIncendiosTerminado
  ) {

    boolean xAhora = botonX.pressed();

    if (xAhora && !xPresionadoAntes) {

      viajandoEnBus = true;

      println("SUBIENDO AL BUS");
    }

    xPresionadoAntes = xAhora;

  } else {

    xPresionadoAntes = false;
  }
}

// -------------------------
// 26.4 VIAJE AL COLEGIO
// -------------------------

void actualizarViajeBus() {

  if (!viajandoEnBus) {
    return;
  }

  oscuridadTransicion += 6;

  fill(
    0,
    constrain(oscuridadTransicion, 0, 255)
  );

  noStroke();

  rect(
    0,
    0,
    width,
    height
  );

  if (oscuridadTransicion >= 255) {

    cargarEscenario(2);

    jugadorX = 1000;
    jugadorY = 850;

    viajandoEnBus = false;
    oscuridadTransicion = 0;
  }
}

// =====================================================
// 27. BUS COLEGIO -> PLAZA
// =====================================================

// -------------------------
// 27.1 ACTUALIZAR BUS
// -------------------------

void actualizarBusPlaza() {

  // Este bus solamente existe en el Colegio
  if (escenario != 2 || viajandoAPlaza) {
    return;
  }

  if (busPlazaDetenido) {

    tiempoBusPlazaDetenido++;

    // Espera unos segundos
    if (tiempoBusPlazaDetenido > 240) {

      busPlazaDetenido = false;
    }

  } else {

    // MOVER BUS
    busPlazaX += velocidadBusPlaza;

    // DETENER BUS
    if (!busPlazaYaParo && busPlazaX >= paradaBusPlazaX) {

      busPlazaX = paradaBusPlazaX;

      busPlazaDetenido = true;

      busPlazaYaParo = true;

      tiempoBusPlazaDetenido = 0;
    }

    // VOLVER A COMENZAR
    if (busPlazaX > mundoW + 180) {

      busPlazaX = -180;

      busPlazaYaParo = false;

      busPlazaDetenido = false;

      tiempoBusPlazaDetenido = 0;
    }
  }
}

// -------------------------
// 27.2 DIBUJAR BUS
// -------------------------

void dibujarBusPlaza() {

  if (escenario != 2) {
    return;
  }

  pushStyle();

  rectMode(CENTER);

  // SOMBRA
  noStroke();
  fill(0, 50);

  ellipse(
    busPlazaX,
    busPlazaY + 43,
    220,
    25
  );

  // CUERPO
  fill(70, 120, 210);

  rect(
    busPlazaX,
    busPlazaY,
    220,
    82,
    14
  );

  // PARTE INFERIOR
  fill(40, 80, 170);

  rect(
    busPlazaX,
    busPlazaY + 25,
    220,
    30
  );

  // VENTANAS
  fill(120, 190, 220);

  rect(busPlazaX - 70, busPlazaY - 15, 42, 28, 5);
  rect(busPlazaX - 20, busPlazaY - 15, 42, 28, 5);
  rect(busPlazaX + 30, busPlazaY - 15, 42, 28, 5);

  // PUERTA
  fill(75, 125, 150);

  rect(
    busPlazaX + 82,
    busPlazaY + 3,
    30,
    58,
    4
  );

  // RUEDAS
  fill(35);

  ellipse(
    busPlazaX - 70,
    busPlazaY + 42,
    36,
    36
  );

  ellipse(
    busPlazaX + 70,
    busPlazaY + 42,
    36,
    36
  );

  fill(130);

  ellipse(
    busPlazaX - 70,
    busPlazaY + 42,
    15,
    15
  );

  ellipse(
    busPlazaX + 70,
    busPlazaY + 42,
    15,
    15
  );

  // DESTINO
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(13);

  text(
    "PLAZA NOVA",
    busPlazaX,
    busPlazaY + 15
  );

  if (busPlazaDetenido && crisisColegioCompletadas >= 3) {
    float bob = sin(frameCount * 0.12) * 4;
    String textoGlobo = cercaBusPlaza
      ? "Presiona [X] para subir"
      : "Bus a Plaza Nova listo";
    float globoY = busPlazaY - 68 + bob;

    rectMode(CENTER);
    fill(45, 52, 54, 235);
    stroke(255, 230, 120);
    strokeWeight(2);
    rect(busPlazaX, globoY, textWidth(textoGlobo) + 24, 30, 15);
    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    text(textoGlobo, busPlazaX, globoY);
  }

  rectMode(CORNER);

  popStyle();
}

// -------------------------
// 27.3 INTERACCIÓN CON EL BUS
// -------------------------

void revisarInteraccionBusPlaza() {

  cercaBusPlaza = false;

  // Detectar si el jugador está cerca del bus
  if (
    escenario == 2 &&
    busPlazaDetenido &&
    crisisColegioCompletadas >= 3
  ) {

    float distanciaBusPlaza = dist(
      jugadorX,
      jugadorY,
      busPlazaX + 75,
      busPlazaY + 25
    );

    if (distanciaBusPlaza < 105) {
      cercaBusPlaza = true;
    }
  }

  // PRESIONAR X PARA SUBIR
  if (
    mandoConectado &&
    cercaBusPlaza &&
    !viajandoAPlaza &&
    crisisColegioCompletadas >= 3
  ) {

    boolean xAhora = botonX.pressed();

    if (xAhora && !xPresionadoAntes) {

      viajandoAPlaza = true;

      oscuridadPlaza = 0;

      println("VIAJANDO A LA PLAZA");
    }

    xPresionadoAntes = xAhora;

  } else if (escenario == 2) {

    xPresionadoAntes = false;
  }
}

// -------------------------
// 27.4 VIAJE A LA PLAZA
// -------------------------

void actualizarViajePlaza() {

  if (!viajandoAPlaza) {
    return;
  }

  oscuridadPlaza += 6;

  fill(
    0,
    constrain(oscuridadPlaza, 0, 255)
  );

  noStroke();

  rect(
    0,
    0,
    width,
    height
  );

  if (oscuridadPlaza >= 255) {
    viajandoAPlaza = false;
    oscuridadPlaza = 0;

    busPlazaX = -180;
    busPlazaDetenido = false;
    busPlazaYaParo = false;
    tiempoBusPlazaDetenido = 0;
    cercaBusPlaza = false;

    slideOutroActo2 = 1;
    caracteresVisiblesActo2 = 0;
    tiempoInicioOutroActo2 = millis();
    ultimoTipeadoActo2 = tiempoInicioOutroActo2;
    estadoJuego = ESTADO_OUTRO_ACTO2;
  }
}