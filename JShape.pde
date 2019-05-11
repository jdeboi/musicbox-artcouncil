boolean movingPoints = false;

boolean checkClick() {
  for (int k = 0; k < jshapes.size(); k++) {
    dragged = jshapes.get(k).select(mouseX, mouseY);
    if (dragged != null) {
      return true;
    }
  }
  return false;
}

void drawShapes(PImage img) {
  for (JShape js : jshapes) {
    js.uvMap(img);
  }
}

void loadJShapes(int num) {
  jshapes = new ArrayList<JShape>();
  for (int k = 0; k < num; k++) {
    processing.data.JSONObject json;

    json = loadJSONObject("data/polygons/" + k +".json");
    int id = json.getInt("id");
    float x = json.getFloat("x");
    float y = json.getFloat("y");
    int r = json.getInt("radius");

    processing.data.JSONArray pts = json.getJSONArray("points");
    JPoint [] points = new JPoint[pts.size()];
    JShape js = new JShape(id, x, y, r, points);
    for (int i = 0; i < pts.size(); i++) {
      processing.data.JSONObject cp = pts.getJSONObject(i);
      points[i] = new JPoint(cp.getFloat("x"), cp.getFloat("y"), js);
    }



    js.setBoundingBox();
    jshapes.add(js);
  }
}

void saveJShapes() {
  for (int i = 0; i < jshapes.size(); i++) {
    jshapes.get(i).saveShape();
    println("saving");
    println(i, jshapes.get(i).points[0].x, jshapes.get(i).points[0].y);
  }
}



int JID = 0;
PVector mouseDown;
PVector selectedPoint;
JShape selectedShape;



//void draggingJShapes() {
//  for (int k = 0; k < jshapes.size(); k++) {
//    int lockedPoint = jshapes.get(k).lockedPoint;
//    if (lockedPoint > -1) {
//      jshapes.get(k).points[lockedPoint].x = mouseX;
//      jshapes.get(k).points[lockedPoint].y = mouseY;
//    } else if (jshapes.get(k).locked) {
//      jshapes.get(k).x = mouseX;
//      jshapes.get(k).y = mouseY;
//    }
//  }
//}

//void releaseJShapes() {
//  for (int k = 0; k < jshapes.size(); k++) {
//    jshapes.get(k).locked = false;
//    jshapes.get(k).lockedPoint = -1;
//    jshapes.get(k).resetPoints();
//  }
//}


void checkJShapeClick() {
  for (JShape js : jshapes) {
    js.contains();
  }
}

//void checkJShapePointClick() {
//  for (JShape js : jshapes) {
//    js.mouseOverPoints();
//  }
//}

class JShape implements Draggable {

  JPoint[] points;
  int radius;
  float x, y;
  int id;

  int lockedPoint = -1;

  int minX, maxX, minY, maxY;
  boolean locked = false;
  float clickX;
  float clickY;

  JShape(float x, float y, int n, int radius) {
    this.id = JID++;
    this.x = x;
    this.y = y;
    this.radius = radius;
    points = new JPoint[n];
    float anglePoly = 180-(n-2)*180.0/n;

    float angle = 0;
    for (int i = 0; i < n; i++) {
      points[i] = new JPoint(radius*cos(radians(angle)), radius*sin(radians(angle)), this);
      angle += anglePoly;
    }
    setBoundingBox();

  }

  JShape(int id, float x, float y, int r, JPoint[] pts) {
    this.id = id;
    this.x = x; 
    this.y = y;
    this.radius = r;
    points = pts;
  }

  void uvMap(PImage img) {
    pushMatrix();
    translate(x, y);
    noStroke();
    beginShape();
    texture(img);
    textureMode(NORMAL);
    for (PVector point : points) {
      float u = map(point.x, minX, maxX, 0, 1.0);
      float v = map(point.y, minY, maxY, 0, 1.0);
      vertex(point.x, point.y, u, v);
    }
    endShape();
    if (CALIBRATING) {
      displayBoundingBox();
      displayPointGrips();
    }
    popMatrix();
  }

  void setBoundingBox() {
    minX = Integer.MAX_VALUE;
    minY = Integer.MAX_VALUE;
    maxX = Integer.MIN_VALUE;
    maxY = Integer.MIN_VALUE;

    for (PVector point : points) {
      if (point.x < minX) {
        minX = int(point.x);
      }
      if (point.x > maxX) {
        maxX = int(point.x);
      }
      if (point.y < minY) {
        minY = int(point.y);
      }
      if (point.y > maxY) {
        maxY = int(point.y);
      }
    }
  }

  void saveShape() {
    processing.data.JSONObject json;
    json = new processing.data.JSONObject();

    json.setInt("id", id);
    json.setFloat("x", x);
    json.setFloat("y", y);
    json.setInt("radius", radius);

    processing.data.JSONArray pts = new processing.data.JSONArray();

    for (int i = 0; i < points.length; i++) {
      processing.data.JSONObject cp = new processing.data.JSONObject();
      cp.setFloat("x", points[i].x);
      cp.setFloat("y", points[i].y);
      pts.setJSONObject(i, cp);
    }
    json.setJSONArray("points", pts);
    saveJSONObject(json, "data/polygons/" + id + ".json");
  }

  void displayBoundingBox() {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(1);
    rect(minX, minY, maxX-minX, maxY-minY);
  }

  void display() {
    //uvMap();
  }

  void displayPointID() {
    int i = 0;
    for (PVector point : points) {
      strokeWeight(1);
      textSize(20);
      fill(255, 0, 0);
      text(i++, point.x, point.y);
    }
  }


  void displayPointGrips() {
    strokeWeight(1);
    colorMode(RGB);
    noFill();
    stroke(0, 255, 0);
    for (PVector point : points) {
      ellipse(point.x, point.y, 15, 15);
    }
  }



  public boolean contains() {
    //int i;
    //int j;
    //boolean result = false;
    //for (i = 0, j = points.length - 1; i < points.length; j = i++) {
    //  float ptxi = points[i].x;
    //  float ptyi = points[i].y;
    //  float ptxj = points[j].x;
    //  float ptyj = points[j].y;
    //  if ((ptyi > test.y) != (ptyj > test.y) &&
    //    (test.x < (ptxj - ptxi) * (test.y - ptyi) / (ptyj-ptyj) + ptxi)) {
    //    result = !result;
    //  }
    //}
    //println(id, result);
    //return result;

    boolean res =(mouseX > minX+x && mouseX < maxX+x && mouseY > minY+y && mouseY < maxY+y);
    return res;
  }


  public void moveTo(float x, float y) {
    this.x = x - clickX;
    this.y = y - clickY;
  }


  Draggable select(int x, int y) {
    x -= this.x;
    y -= this.y;

    for (int i = 0; i < points.length; i++) {
      if (dist(points[i].x, points[i].y, x, y) < 15)
        return points[i];
    }

    if (contains()) {
      clickX = x;
      clickY = y;
      return this;
    }
    return null;
  }
}
