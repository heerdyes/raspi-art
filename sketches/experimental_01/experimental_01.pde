Infobar sb;
Worldmonitor[] pages;
int currpage=0;
String prefix="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/experimental_01";

void mkpages(int n) {
  pages=new Worldmonitor[n];
  for (int i=0; i<n; i++) {
    pages[i]=new Worldmonitor(6, 262, 276, 5, 5);
  }
}

void setup() {
  size(800, 600);
  background(255);
  mkpages(5);
  sb=new Infobar();
  textAlign(LEFT, TOP);
  frameRate(20);
}

void draw() {
  pages[currpage].golive();
  pages[currpage].monitor(3);
  sb.render();
}

void selectworlds() {
  ArrayList<TWorld2D> selws=new ArrayList<TWorld2D>();
  for (int i=0; i<pages.length; i++) {
    selws.addAll(pages[i].chosenworlds());
  }
}

void savefavoritespecimens() {
  for (Worldmonitor wm : pages) {
    for (TWorld2D tw : wm.chosenworlds()) {
      tw.snapshot(prefix+"/img");
    }
  }
}

void keyPressed() {
  Worldmonitor currmon=pages[currpage];
  if (key=='n') {
    currpage=(currpage+1)%5;
    currmon=pages[currpage];
  } else if (key=='p') {
    if (currpage<=0) {
      currpage=4;
    } else {
      currpage-=1;
    }
    currmon=pages[currpage];
  } else if (key=='s') {
    selectworlds();
  } else if (key=='0') {
    currmon.toggleregion(0);
  } else if (key=='1') {
    currmon.toggleregion(1);
  } else if (key=='2') {
    currmon.toggleregion(2);
  } else if (key=='3') {
    currmon.toggleregion(3);
  } else if (key=='4') {
    currmon.toggleregion(4);
  } else if (key=='5') {
    currmon.toggleregion(5);
  } else if (key=='e') {
    println("persisting selected world images...");
    savefavoritespecimens();
  }
  sb.updateinfo(currpage, currmon.selectionstr(), "ready");
}
