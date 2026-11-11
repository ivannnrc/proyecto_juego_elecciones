// =====================================================
// 4. INDICADORES DE LA CIUDAD - VARIABLES
// =====================================================

int informacion = 50;
int convivencia = 50;
int bienestar = 50;
int participacion = 50;
int reputacion = 50;

// =====================================================
// 25. INDICADORES DE LA CIUDAD - LÓGICA Y HUD
// =====================================================

void mostrarIndicadores() {
  noStroke();
  fill(0, 170);
  rect(15, 15, 230, 145, 10);

  fill(255);
  textFont(fuenteTitulo);
  textAlign(LEFT);
  textSize(20);
  text("ESTADO DE NOVA", 30, 40);

  textFont(fuenteCuerpo);
  textSize(16);
  text("Informacion: " + informacion, 30, 65);
  text("Convivencia: " + convivencia, 30, 85);
  text("Bienestar digital: " + bienestar, 30, 105);
  text("Participacion: " + participacion, 30, 125);
  text("Reputacion: " + reputacion, 30, 145);
}

void cambiarIndicadores(
  int cambioInformacion,
  int cambioConvivencia,
  int cambioBienestar,
  int cambioParticipacion,
  int cambioReputacion
) {
  informacion += cambioInformacion;
  convivencia += cambioConvivencia;
  bienestar += cambioBienestar;
  participacion += cambioParticipacion;
  reputacion += cambioReputacion;

  informacion = constrain(informacion, 0, 100);
  convivencia = constrain(convivencia, 0, 100);
  bienestar = constrain(bienestar, 0, 100);
  participacion = constrain(participacion, 0, 100);
  reputacion = constrain(reputacion, 0, 100);
}