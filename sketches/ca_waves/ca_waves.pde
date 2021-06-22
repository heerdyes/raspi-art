// based on code from the book Generative Art by Matt Pearson

// --- data types --- //
class Cell {
  float x, y;
  float state;
  float nextState;
  float lastState=0;
  Cell[] neighbors;

  Cell(float ex, float why) {
    x=ex*_cellSize;
    y=why*_cellSize;
    nextState=((x/500)+(y/300))*14;
    state=nextState;
    neighbors=new Cell[0];
  }

  void addNeighbour(Cell cell) {
    neighbors=(Cell[])append(neighbors, cell);
  }

  void calcNextState() {
    float total=0;
    for (int i=0; i<neighbors.length; i++) {
      total+=neighbors[i].state;
    }
    float average=int(total/8);

    if (average==255) {
      nextState=0;
    } else if (average==0) {
      nextState=255;
    } else {
      nextState=state+average;
      if (lastState>0) {
        nextState-=lastState;
      }
      if (nextState>255) {
        nextState=255;
      } else if (nextState<0) {
        nextState=0;
      }
    }

    lastState=state;
  }

  void drawMe() {
    state=nextState;
    stroke(0);
    fill(state);
    ellipse(x, y, _cellSize, _cellSize);
  }
}

// --- flow --- //
Cell[][] _cellArray;
int _cellSize=5;
int _numX, _numY;

void setup() {
  size(500, 300);
  frameRate(12);
  _numX=floor(width/_cellSize);
  _numY=floor(height/_cellSize);
  restart();
}

void restart() {
  _cellArray=new Cell[_numX][_numY];
  for (int x=0; x<_numX; x++) {
    for (int y=0; y<_numY; y++) {
      Cell newCell=new Cell(x, y);
      _cellArray[x][y]=newCell;
    }
  }

  for (int x=0; x<_numX; x++) {
    for (int y=0; y<_numY; y++) {
      int above=y-1;
      int below=y+1;
      int left=x-1;
      int right=x+1;

      if (above<0) {
        above=_numY-1;
      }
      if (below==_numY) {
        below=0;
      }
      if (left<0) {
        left=_numX-1;
      }
      if (right==_numX) {
        right=0;
      }

      _cellArray[x][y].addNeighbour(_cellArray[left][above]);
      _cellArray[x][y].addNeighbour(_cellArray[left][y]);
      _cellArray[x][y].addNeighbour(_cellArray[left][below]);
      _cellArray[x][y].addNeighbour(_cellArray[x][below]);
      _cellArray[x][y].addNeighbour(_cellArray[right][below]);
      _cellArray[x][y].addNeighbour(_cellArray[right][y]);
      _cellArray[x][y].addNeighbour(_cellArray[right][above]);
      _cellArray[x][y].addNeighbour(_cellArray[x][above]);
    }
  }
}

void draw() {
  background(200);

  for (int x=0; x<_numX; x++) {
    for (int y=0; y<_numY; y++) {
      _cellArray[x][y].calcNextState();
    }
  }

  translate(_cellSize/2, _cellSize/2);

  for (int x=0; x<_numX; x++) {
    for (int y=0; y<_numY; y++) {
      _cellArray[x][y].drawMe();
    }
  }
}

void mousePressed() {
  restart();
}
