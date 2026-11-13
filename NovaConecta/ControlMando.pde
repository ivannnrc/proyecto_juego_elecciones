// =====================================================
// 2. CONTROL PS4 - VARIABLES
// =====================================================

ControlIO control;
ControlDevice mando;

ControlSlider joystickX;
ControlSlider joystickY;

ControlButton botonTriangulo;
ControlButton botonCuadrado;
ControlButton botonX;
ControlButton botonL1;
ControlButton botonR1;
ControlButton botonL2;
ControlButton botonCirculo;
boolean cuadradoPresionadoAntes = false;
boolean l1PresionadoAntes = false;
boolean r1PresionadoAntes = false;
boolean l2PresionadoAntes = false;
boolean XpresionadoAntes = false;
boolean circuloPresionadoAntes = false;

boolean mandoConectado = false;

// =====================================================
// 11. CONTROL PS4 Y CONECTA
// =====================================================

void actualizarControlRedSocial() {

  if (!mandoConectado) {
    return;
  }

  // TRIANGULO = ABRIR / CERRAR CONECTA
  boolean cuadradoAhora = botonTriangulo.pressed();

  if (cuadradoAhora && !cuadradoPresionadoAntes) {
    redSocialAbierta = !redSocialAbierta;
  }

  cuadradoPresionadoAntes = cuadradoAhora;

  // =====================================================
  // DECISIÓN FINAL DEL MINIJUEGO DEL COLEGIO
  // =====================================================

  if (
    escenario == 2 &&
    minijuegoColegioActivo &&
    publicacionColegioActual != -1 &&
    publicacionVerificadaColegio[publicacionColegioActual]
  ) {

    boolean l1Ahora = botonL1.pressed();
    boolean r1Ahora = botonR1.pressed();
    boolean l2Ahora = botonL2.pressed();

    if (l1Ahora && !l1PresionadoAntes) {
      procesarDecisionColegio(1);
    }

    else if (r1Ahora && !r1PresionadoAntes) {
      procesarDecisionColegio(2);
    }

    else if (l2Ahora && !l2PresionadoAntes) {
      procesarDecisionColegio(3);
    }

    l1PresionadoAntes = l1Ahora;
    r1PresionadoAntes = r1Ahora;
    l2PresionadoAntes = l2Ahora;

    return;
  }
  // L1 / R1 / L2 SOLO CUANDO CONECTA ESTÁ ABIERTA

  if (redSocialAbierta) {
    // =====================================================
    // SELECCIONAR CRISIS DEL COLEGIO
    // =====================================================

    if (
      escenario == 2 &&
      minijuegoColegioActivo &&
      publicacionColegioActual == -1
    ) {

      boolean l1Ahora = botonL1.pressed();
      boolean r1Ahora = botonR1.pressed();
      boolean l2Ahora = botonL2.pressed();

      if (l1Ahora && !l1PresionadoAntes) {

        publicacionColegioActual = 0;

        puntoAcopioActual =
        puntoPublicacionColegio[0];

        redSocialAbierta = false;
      }

      else if (r1Ahora && !r1PresionadoAntes) {

        publicacionColegioActual = 1;

        puntoAcopioActual =
        puntoPublicacionColegio[1];

        redSocialAbierta = false;
      }

      else if (l2Ahora && !l2PresionadoAntes) {

        publicacionColegioActual = 2;

        puntoAcopioActual =
        puntoPublicacionColegio[2];

        redSocialAbierta = false;
      }

      l1PresionadoAntes = l1Ahora;
      r1PresionadoAntes = r1Ahora;
      l2PresionadoAntes = l2Ahora;

      return;
    }

    boolean l1Ahora = botonL1.pressed();
    boolean r1Ahora = botonR1.pressed();
    boolean l2Ahora = botonL2.pressed();

    int idx = obtenerIndicePublicacion(escenario);

    if (idx != -1 && !pubProcesadas[idx]) {

      if (l1Ahora && !l1PresionadoAntes) {
        procesarDecision(idx, 1);
      }

      if (r1Ahora && !r1PresionadoAntes) {
        procesarDecision(idx, 2);
      }

      if (l2Ahora && !l2PresionadoAntes) {
        procesarDecision(idx, 3);
      }
    }

    l1PresionadoAntes = l1Ahora;
    r1PresionadoAntes = r1Ahora;
    l2PresionadoAntes = l2Ahora;

  } else {

    l1PresionadoAntes = false;
    r1PresionadoAntes = false;
    l2PresionadoAntes = false;
  }
}
