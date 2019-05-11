PShape eyeball;
PShape sphereBall;
PImage iris;
PGraphics sphereScreen;
PGraphics canvas;
import deadpixel.keystone.*; 

color cyan = color(0, 255, 255); 
color blue = color(0, 0, 255); 
color lime = color(70, 255, 0); 
color pink = color(255, 0, 155); 

SpaceRect[] spaceRects;
float zVel = 1.7;
int rectSpacing = 80;

int endPSpaceRects = -1200;
int frontPSpaceRects = 100;
int numRects = (-endPSpaceRects+frontPSpaceRects)/rectSpacing;
int direction2Point = 1;
PShader galaxyShader;

boolean cyclingRects = true;
PGraphics temp;

float galaxyInc = 0.002;
float directionGalaxy = galaxyInc;
float galaxyLocation = 0;

float angleBottom = 0;

void galaxyMove() {
  if (galaxyShader != null) {

    if (mouseX > width/2) directionGalaxy = galaxyInc;
    else if (mouseX < width/2) directionGalaxy = -galaxyInc;
    galaxyLocation += directionGalaxy;

    galaxyShader.set("time", galaxyLocation);
    //if (mouseX < width/2) galaxyShader.set("time", map(mouseX, 0, width/2, 20, 24) - millis()/2000.0);
    //else galaxyShader.set("time", map(mouseX, width/2, width, 24, 28) + millis()/2000.0);
  }
}

void galaxyMoveContinuous() {
  galaxyLocation += galaxyInc;
  galaxyShader.set("time", galaxyLocation);
}

void initSpaceRects() {
  spaceRects = new SpaceRect[numRects];
  for (int r = 0; r < spaceRects.length; r++) {
    spaceRects [r] = new SpaceRect(new PVector(0, 0, endPSpaceRects+rectSpacing*r), new PVector(0, 0, zVel) );
  }
}

class SpaceRect {

  float w, h;
  PVector pos;
  PVector vel;
  PVector acc;
  PVector rot;

  SpaceRect(PVector p, PVector v) {
    pos = p;
    vel = v;
    acc = new PVector(0, 0);
    rot = new PVector(0, 0);
  }

  void update(int mode) {
    pos.add(vel);
    if (cyclingRects) {
      if (pos.z > frontPSpaceRects) pos.z = endPSpaceRects;
      else if (pos.z < endPSpaceRects) pos.z = frontPSpaceRects;
    }
    vel.add(acc);

    int NONE = -1;
    int SUPER_TRIPPY = 0;
    int KINDA_TRIPPY = 1;
    int SORTA_TRIPPY = 2;
    int SEESAW = 3;
    float timePassed = millis()/1000.0;
    if (mode == NONE) rot.z = 0;

    else if (mode == SUPER_TRIPPY) rot.z = map(pos.z, endPSpaceRects, frontPSpaceRects, 0, timePassed);
    else if (mode == KINDA_TRIPPY) rot.z = map(pos.z, endPSpaceRects, frontPSpaceRects, 0, timePassed/5); //map(pos.z, endPSpaceRects, frontPSpaceRects, 0, frameCount/100.0);
    else if (mode == SORTA_TRIPPY) rot.z = map(pos.z, endPSpaceRects, frontPSpaceRects, 0, timePassed/10);
    else if (mode == SEESAW)  vel.z = zVel * 4 * sin(millis()/500.0);
  }


  void display(PGraphics s) {
    s.pushMatrix();

    

    s.translate(s.width/2, s.height/2);
    s.translate(0, 0, pos.z);
    s.rotateX(rot.x);
    s.rotateY(rot.y);
    s.rotateZ(rot.z);
    s.rectMode(CENTER);
    float dw = map(pos.z, frontPSpaceRects, endPSpaceRects, 0, 34*numRects);
    if (pos.z > endPSpaceRects) {
      s.rect(0, 0, s.width-dw, s.height-dw);
      s.translate(0, 0, -5);
      s.rect(0, 0, s.width-dw, s.height-dw);
      s.translate(0, 0, -15);
      s.rect(0, 0, s.width-dw, s.height-dw);
    }
    s.popMatrix();
  }
  void displayTopSides(PGraphics s) {
    s.pushMatrix();
    s.rotateX(rot.x);
    s.rotateY(rot.y);
    s.rotateZ(rot.z);
    s.translate(pos.x, pos.y, pos.z);
    float dw = map(pos.z, frontPSpaceRects, endPSpaceRects, 0, 14*numRects);
    if (pos.z > endPSpaceRects) {
      s.line(0, 0, s.width-dw, 0);
      s.translate(0, s.height-dw, 0);
      s.line(0, 0, s.width-dw, 0);
    }
    s.popMatrix();
  }

  void displayNeon(PGraphics s, int sw, color c) {
    s.pushMatrix();
    s.rotateX(rot.x);
    s.rotateY(rot.y);
    s.rotateZ(rot.z);
    s.translate(pos.x, pos.y, pos.z);
    float dw = map(pos.z, frontPSpaceRects, endPSpaceRects, 0, 14*numRects);
    neonrect(s, 0, 0, int(s.width-dw), int(s.height-dw), sw, c);
    //s.rect(0, 0, s.width-dw, s.height-dw);
    s.popMatrix();
  }

  void changeRectSpacing(int sp) {
  }

  void zGradientStroke(PGraphics s, color c1, color c2, color c3) {
    float zper = map(pos.z, endPSpaceRects, frontPSpaceRects, 0, 1);
    color grad = paradiseStroke(zper, c1, c2, c3);
    //s.colorMode(HSB, 255);
    //float sat = map(pos.z, endPSpaceRects, endPSpaceRects/2, 0, 255);
    //color grad2 = color(hue(grad), sat, 255);
    //colorMode(RGB, 255);
    s.stroke(grad);
  }


  //void displayCenter(PGraphics s, int side) {
  //  //float sz = map(-pos.z*pos.z, frontPSpaceRects, endPSpaceRects, s.width*4, 0); // spazz
  //  //float sz = map(pos.z*2, frontPSpaceRects, endPSpaceRects, s.width*4, 0);   // cool
  //  float sz = map(pos.z, frontPSpaceRects, endPSpaceRects, s.width*4, 0);
  //  if (side == 1) s.rect(s.width, s.height/2, sz, sz);
  //  else s.rect(0, s.height/2, sz, sz);
  //}
}


color paradiseStrokeReturn(float per, color c1, color c2, color c3) {
  per *= 3;
  if (per < 1) return lerpColor(c1, c2, per);
  else if (per < 2) return lerpColor(c2, c3, per-1);
  return lerpColor(c3, c1, per-2);
}

color paradiseStroke(float per, color c1, color c2, color c3) {
  per *= 2;
  if (per < 1) return lerpColor(c1, c2, per);
  return lerpColor(c2, c3, per-1);
}
void drawNeonRect(PGraphics s, int x, int y, int w, int h, int sw, color c) {
  s.beginShape();
  neonrect(s, x, y, w, h, sw, c);
  s.endShape();
}

void neonrect(PGraphics s, int x, int y, int w, int h, int sw, color c) {
  //s.ellipse(x0, y0, w, w);
  //s.ellipse(x0, y0, w, w);
  s.pushMatrix();
  s.noStroke();
  neonline(s, x-w/2, y-h/2, x+w/2, y-h/2, sw, c);
  neonline(s, x+w/2, y-h/2, x+w/2, y+h/2, sw, c);
  neonline(s, x+w/2, y+h/2, x-w/2, y+h/2, sw, c);
  //neonline(s, x-w/2, y+h/2, x-w/2, y-h/2, sw, c);

  s.popMatrix();
}
void neonline(PGraphics s, PVector p0, PVector p1, int sw, color c) {
  neonline(s, int(p0.x), int(p0.y), int(p1.x), int(p1.y), sw, c);
}

void neonline(PGraphics s, int x0, int y0, int x1, int y1, int sw, color c) {
  float len = abs(dist(x0, y0, x1, y1));
  float rot = atan2(1.0*(y1-y0), 1.0*(x1-x0));
  println(rot);

  s.pushMatrix();
  s.noStroke();
  s.rotate(rot);
  s.translate(x0, y0);
  for (int i = 4; i >= 0; i--) {
    int w = sw+i*4;

    s.fill(255, 50 + (4-i) * 50);
    s.beginShape(QUAD);
    s.vertex(-len/2, -w/2);
    s.vertex(len/2, -w/2);
    s.vertex(len/2, w/2);
    s.vertex(-len/2, w/2);
    s.endShape();
  }

  s.popMatrix();
}

void initGalaxyShader(PGraphics s) {
  galaxyShader = loadShader("shaders/galaxy.glsl");
  galaxyShader.set("resolution", float(s.width), float(s.height));
  temp = createGraphics(s.width, s.height, P3D);
}


void glory(PGraphics s) {
  resetSpaceRects();
  cyclingRects = true;
  displaySpaceRects(5, -1, pink, blue, cyan, false, s);
}

void accordian(PGraphics s) {
  resetSpaceRects();
  displayTwoWayTunnels(abs(sin(millis()/5000.0)), s);
}

void resetSpaceRects() {
  for (int r = 0; r < spaceRects.length; r++) {
    //if (zoomIn) spaceRects[r].pos.set(0, 0, -endPSpaceRects+rectSpacing*r-1200); // not going to work with cycling
    //else 
    spaceRects[r].pos.set(0, 0, endPSpaceRects+rectSpacing*r);
  }
}


void displayTunnel(PGraphics s, int len, int num, int gap, int z, color c1, color c2, boolean isGradient) {
  //s.pointLight(255, 255, 255, s.width/2 + 50* sin(millis()/1000.0),s.height/2 + 47* sin(millis()/700.0), -100);
  s.noStroke();

  for (int i = 0; i < num; i++) {
    // top

    s.pushMatrix();
    s.rotateX(radians(-90 + gap));
    s.translate(0, -z, 0);
    float per;
    if (num > 1) per = map(i, 0, num -1, 0, 1);
    else per = 1;
    s.fill(lerpColor(c1, c2, per));
    s.beginShape();
    if (isGradient) s.fill(c1);
    s.vertex(-1, -1);
    s.vertex(s.width+1, -1);
    if (isGradient) s.fill(c2);
    s.vertex(s.width+1, len);
    s.vertex(-1, len);
    s.endShape();
    s.popMatrix();

    // bottom
    s.pushMatrix();
    s.rotateX(radians(-90));
    s.translate(0, 0, s.height);
    s.rotateX(radians(-gap));
    s.translate(0, -z, 0);

    s.beginShape();
    if (isGradient) s.fill(c1);
    s.vertex(-1, -1);
    s.vertex(s.width+1, -1);
    if (isGradient) s.fill(c2);
    s.vertex(s.width+1, len);
    s.vertex(-1, len);
    s.endShape();
    s.popMatrix();

    // left
    s.pushMatrix();
    s.rotateY(radians(90 - gap));
    s.translate(-z, 0, 0);

    s.beginShape(QUADS);
    if (isGradient) s.fill(c1);
    s.vertex(-1, -1);
    if (isGradient) s.fill(c2);
    s.vertex(len, -1);
    s.vertex(len, s.height+1);
    if (isGradient) s.fill(c1); 
    s.vertex(-1, s.height+1);
    s.endShape();
    s.popMatrix();

    // right
    s.pushMatrix();
    s.rotateY(radians(90));
    s.translate (0, 0, s.width);
    s.rotateY(radians(gap));
    s.translate(-z, 0, 0);

    s.beginShape(QUADS);
    if (isGradient) s.fill(c1);
    s.vertex(-1, -1);
    if (isGradient) s.fill(c2);
    s.vertex(len, -1);
    s.vertex(len, s.height+1);
    if (isGradient) s.fill(c1); 
    s.vertex(-1, s.height+1);
    s.endShape();
    s.popMatrix();
    z -= len;
  }
}


void displaySpaceRects(int sw, int mode, color c1, color c2, color c3, boolean isCenter, PGraphics s) {

  temp.beginDraw();
  temp.background(0);
  temp.rectMode(CENTER);

  temp.pushMatrix();
  //temp.translate(temp.width/2, temp.height/2);
  //temp.rectMode(CENTER);
  for (int j = 0; j < numRects; j++) {
    temp.noFill();
    temp.strokeWeight(sw);
    spaceRects[j].zGradientStroke(temp, c1, c2, c3);
    spaceRects[j].display(temp);
    spaceRects[j].update(mode);
  }
  temp.popMatrix();
  temp.rectMode(CORNER);
  temp.endDraw();


  s.beginDraw();
  s.blendMode(ADD);
  s.background(0);
  //s.image(currentImages.get(0), -(i-1)*screenW, 0);
  s.filter(galaxyShader);
  s.image(temp, 0, 0);

  s.endDraw();
}

void galaxyMoveOuter(PGraphics s) {
  s.beginDraw();
  s.blendMode(ADD);
  s.background(0);
  //s.image(currentImages.get(0), -(i-1)*screenW, 0);
  s.filter(galaxyShader);
  s.endDraw();
}

void displayLineBounce(PGraphics s, int spacing, color c1, color c2, int sw) {
  s.beginDraw();
  s.background(0);
  s.blendMode(SCREEN);
  s.strokeWeight(sw);
  int w = s.width;
  int h = s.height ;
  int centerX = w/2;
  //int bottomY = h-50;
  int bottomY = h;
  int centerY = bottomY/2;
  //s.image(currentImages.get(0), 0, 0);
  s.filter(galaxyShader);
  for (int i = 0; i<w; i+=spacing) {
    // 0 -> 1, not 0 -> 2h
    color c = lerpColor(c1, c2, map(i, 0, w, 0, 1));
    s.stroke(c);
    float yMove = bottomY/2-sin(angleBottom)*bottomY/2;
    s.line(centerX, bottomY, i, yMove); // bottom lines
    yMove = bottomY/2+sin(angleBottom)*bottomY/2;
    s.line(centerX, 0, i, yMove);         // top lines
  }
  for (int i = 0; i<=bottomY; i+=spacing) {

    float xMove = centerX/2 + sin(angleBottom)*centerX/2;
    s.line(0, i, xMove, centerY);        // left to right lines

    xMove = w-sin(angleBottom)*w/4 - w/4;
    // between w and w/2
    s.line(xMove, centerY, w, i);
  }
  s.endDraw();
  angleBottom += 0.01;
}

void displayTwoScreenCascade(PGraphics s) {
  temp.beginDraw();
  temp.blendMode(BLEND);
  temp.background(0, 100, 0, 1);
  temp.blendMode(SCREEN);
  temp.noFill();
  temp.strokeWeight(10);
  int num = 10;
  int spacing = 100;
  int bounceD = 200;
  temp.noFill();
  temp.strokeWeight(10);
  for (int i = 0; i < num; i++) {
    spaceRects[i].pos.z = sin(millis()/2000.0 + i * .2) * bounceD - bounceD - i * spacing;
    spaceRects[i].zGradientStroke(temp, cyan, blue, pink);
    spaceRects[i].display(temp);
  }
  temp.endDraw();

  s.beginDraw();
  s.blendMode(ADD);
  s.background(0);
  //s.image(currentImages.get(0), -(j-1)*screenW, 0);
  s.filter(galaxyShader);
  s.image(temp, 0, 0);
  s.endDraw();
}

void displayTwoWayTunnels(float per, PGraphics s) {
  temp.beginDraw();
  temp.blendMode(SCREEN);
  temp.background(0);
  int num = 5;
  int spacing = 20;
  int bounceD = 400;
  temp.noFill();
  temp.strokeWeight(10);
  for (int i = 0; i < num; i++) {
    spaceRects[i].pos.z = sin(per*2*PI + i * .2) * bounceD - bounceD - i * spacing;
    spaceRects[i].zGradientStroke(temp, cyan, blue, pink);
    spaceRects[i].display(temp);
  }
  for (int i = num; i < num*2 && i < spaceRects.length; i++) {
    spaceRects[i].pos.z = cos(per*2*PI + i * .2) * bounceD - bounceD - i * spacing;
    spaceRects[i].zGradientStroke(temp, cyan, blue, pink);
    spaceRects[i].display(temp);
  }
  temp.endDraw();


  s.beginDraw();
  s.blendMode(ADD);
  s.background(0);
  //s.image(currentImages.get(0), 0, 0);
  s.filter(galaxyShader);
  s.image(temp, 0, 0);
  s.endDraw();
}


void fullGlory(int mode, PGraphics s) {
  //resetSpaceRects();
  //cycleShapeFFTTop(getColorOnBeat(pink, blue, cyan));
  displaySpaceRects(5, mode, pink, blue, cyan, false, s); 

  //platformSides();
}


void initEye() {
  iris = loadImage("iris_rain.png");
  noStroke();
  sphereScreen = createGraphics(400, 400, P3D);
  eyeball = createShape(SPHERE, sphereScreen.width*.43); 
  eyeball.setTexture(iris);
}

void drawEye(PGraphics s) {
  s.beginDraw();
  s.background(0);
  s.translate(s.width/2, s.height/2);
  float rx = constrain(map(mouseY, height, height/2, -PI/5, PI/4), -PI/5, radians(10));
  float ry = constrain(map(mouseX, width/2 - 100, width/2 + 100, PI/3.5, PI/1.5), PI/3.5, PI/1.5);
  //println(rx, ry);
  s.rotateX(rx);
  s.rotateY(ry);
  s.shape(eyeball);
  s.endDraw();
}
