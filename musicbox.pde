import gifAnimation.*;
import keystoneMap.*;

boolean CALIBRATING = false;
int numJShapes = 4;

PImage[] animation;
int index = 0;
Gif gif;
PImage img;
PImage bk;
ArrayList<JShape> jshapes;

int screenW = 400;
int screenH = 400;
//Keystone ks;
//CornerPinSurface surface;

void setup() {
  size(800, 800, P3D);
  bk = loadImage("musicbox.jpg");

  //ks = new Keystone(this);
  //surface = ks.createQuadPinSurface(400, 400, 20);
  //initEye();

  lines = new ArrayList<Line>();
  //for (int i = 0; i < 14; i++) {
  //  lines.add(new Line(0, i*20+50, 50, i*20+50));
  //}
  initMode();
  setRandomColors();

  canvas = createGraphics(screenW, screenH, P3D);
  initGalaxyShader(canvas);
  initSpaceRects();
  initEye();

  jshapes = new ArrayList<JShape>();
  //jshapes.add(new JShape(300, 300, 14, 60));
  //jshapes.add(new JShape(300, 300, 4, 60));
  //jshapes.add(new JShape(300, 300, 3, 60));
  //jshapes.add(new JShape(300, 300, 3, 60));
  //jshapes.add(new JShape(300, 300, 4, 60));
  //jshapes.add(new JShape(300, 300, 4, 60));
}

void draw() {
  background(0);
  float factor = 0.2;
  if (CALIBRATING) {
    //image(bk, 0, 0, bk.width*factor, bk.height*factor);
    displayEditingLines();
  } 
  galaxyMoveContinuous();
  cycleModes(10000);
}

void keyPressed() {
  switch(key) {
  case 'c':
    //ks.toggleCalibration();
    //snapOutlinesToTriangles();
    CALIBRATING = !CALIBRATING;
    break;

  case 'l':
    //ks.load("data/keystone/keystone.xml");
    //snapOutlinesToTriangles();
    lines = new ArrayList<Line>();
    loadLines();
    loadJShapes(numJShapes);
    break;

  case 's':
    //ks.save("data/keystone/keystone.xml");
    saveMappedLines();
    saveJShapes();
    break;
  }
}

Draggable dragged;
void mousePressed() {
  if (editingLines) checkLineClick();
  checkClick();
}

void mouseDragged() {
  if (dragged != null) {
    dragged.moveTo(mouseX, mouseY);
  }
}

void mouseReleased() {
  dragged = null;
  linesReleaseMouse();
}
