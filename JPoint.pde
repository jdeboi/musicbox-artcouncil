class JPoint extends PVector implements Draggable {

  JShape parent;

  JPoint(float x, float y, JShape parent) {
    super(x, y);
    this.parent = parent;
  }

  void moveTo(float x, float y) {
    this.x = x - parent.x;
    this.y = y - parent.y;
    parent.setBoundingBox();
  }
}
