int lastModeCheck = 0;
int currentMode = 0;
int numModes = 6;

color randC1, randC2;

void cycleModes(int delay) {
  if (millis() - lastModeCheck > delay) {
    lastModeCheck = millis();
    currentMode++;
    initMode();
    setRandomColors();
  }
  playMode();
}

void initMode() {
  switch(currentMode%numModes) {
  case 7:
    loadGif("rain2");
    break;
  case 8:
    loadGif("80s");
    break;
  case 9:
    loadGif("stripe");
    break;
  case 10:
    loadGif("hall");
    break;
  case 11:
    loadGif("blue");
    break;
  case 12:
    loadGif("warp");
    break;
  default:
    loadGif("rain2");
    break;
  }
}

void playMode() {
  switch(currentMode%numModes) {
  case 0:
    displayTwoScreenCascade(canvas);
    break;
  case 1:
    accordian(canvas);
    break;
  case 2:
    displaySpaceRects(5, 1, pink, blue, cyan, false, canvas); 
    break;
  case 3:
    displayLineBounce(canvas, 30, cyan, pink, 5);
    break;
  case 4:
    displaySpaceRects(5, 2, pink, blue, cyan, false, canvas); 
    break;
  case 5:
    displaySpaceRects(5, 0, pink, blue, cyan, false, canvas); 
    break;
  case 6:
    displayLineBounce(canvas, 30, cyan, pink, 5);
  default:
    //setSpeed(0.5);
    //drawShapes(animation[index%animation.length]);
    canvas.beginDraw();
    canvas.background(0);
    canvas.image(animation[index%animation.length], 0, 0);
    canvas.endDraw();
    break;
  }
  drawShapes(canvas);
  playLineMode();
}

int numLineModes = 5;

void playLineMode() {
  switch(currentMode%numLineModes) {
  case 0:
    transit(color(pink), 0.5*sin(millis()/1000.0) + 0.5, 0.2);
    break;
  case 1:
    pulsingGrad(pink, cyan, 0.5*sin(millis()/1000.0) + 0.5);
    break;
  case 2:
    transit(color(cyan), 0.5*sin(millis()/1000.0) + 0.5, 0.8);
    break;
  case 3:
    pulsing(color(255), 0.5*sin(millis()/1000.0) + 0.5);
    break;
  case 4: 
    displayLines(color(pink));
    break;
  }
}

void loadGif(String gifName) {
  animation = Gif.getPImages(this, "gifs/" + gifName + ".gif");
}

void gifAll(float speed) {
  //canvas.beginDraw();
  ////canvas.translate(canvas.width/2, canvas.height/2);
  ////canvas.rectMode(CENTER);
  //setSpeed(speed);
  //canvas.image(animation[index%animation.length], 0, 0); // canvas.width/2, canvas.height/2);
  //canvas.endDraw();

  //renderAll();
}

void setSpeed(float per) {
  int n = int(map(per, 0, 1.0, 8, 1));
  if (frameCount % n == 0)
    index++;
}

void setRandomColors() {
  colorMode(HSB, 255);
  randC1 = color(random(255), 255, 255);
  float hue1 = hue(randC1);
  hue1 += 160;
  hue1 %= 255;
  randC2 = color(hue1, 255, 255);
  colorMode(RGB, 255);
}

void evolveRandomColors(float amt1, float amt2) {
  colorMode(HSB, 255);
  float hue1 = hue(randC1);
  hue1+= amt1;
  float hue2 = hue(randC2);
  hue2 += amt2;
  randC1 = color(hue1, 255, 255);
  randC2 = color(hue2, 255, 255);
  colorMode(RGB, 255);
}
