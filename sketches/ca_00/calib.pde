class Cell {
  float x, y;
  boolean state;
  boolean nextState;
  boolean lastState;
  float size;

  Cell(float x, float y, float sz) {
    this.x=x*sz;
    this.y=y*sz;
    this.size=sz;
    this.state=false;
  }

  void render() {
    stroke(state?255:0);
    fill(state?255:0);
    rect(x, y, size, size);
  }
}
