// interface for genetic evolution
// the user choice is a probabilistic participant in the fitness function

import java.io.FileNotFoundException;

int psize=42;
float mrate=0.01;
int screensperpage=6;
Popu p;
Worldmonitor[] pages;
Infobar sb;
int currpage=0;
int totalpages=psize/screensperpage;
PrintWriter genewriter;
String prefix="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/gene_02";
String sndirpath;

void initsession() {
  try {
    String ts=String.format("%04d%02d%02d-%02d%02d%02d", year(), month(), day(), hour(), minute(), second());
    sndirpath=String.format("%s/data/%s", prefix, ts);
    String gfnm=String.format("%s/evolution.log", sndirpath);
    File sndir=new File(sndirpath);
    sndir.mkdir();
    File gf=new File(gfnm);
    gf.createNewFile();
    genewriter=new PrintWriter(gf);
    genewriter.println(String.format("### genewriter session [%s] ###", ts));
    genewriter.flush();
  }
  catch (FileNotFoundException fnfe) {
    println("[ERROR] "+fnfe.getMessage());
  }
  catch (IOException ioe) {
    println("[ERROR] "+ioe.getMessage());
  }
}

void mkpages(int n) {
  pages=new Worldmonitor[n];
  for (int i=0; i<n; i++) {
    pages[i]=new Worldmonitor(screensperpage, 262, 276, 5, 5);
  }
}

void introduceDNA() {
  int imember=0;
  for (int i=0; i<pages.length; i++) {
    for (int j=0; j<pages[i].regions.size(); j++) {
      TWorld2D tw=pages[i].regions.get(j);
      tw.getbot(0).updateDNA(p.members[imember]);
      tw.clearplane();
      imember+=1;
    }
  }
}

void influenceturtlebotselection() {
  int ctr=0;
  for (int i=0; i<pages.length; i++) {
    int nr=pages[i].regions.size();
    for (int j=0; j<nr; j++) {
      if (pages[i].selection.get(j)) {
        // retrieve DNA from turtlebot
        TWorld2D currworld=pages[i].regions.get(j);
        Turtlebot currbot=currworld.getbot(0);
        DNA cdna=currbot.getDNA();
        // update score and insert into the population
        cdna.updatescore(nr);
        p.members[ctr]=cdna;
      }
      ctr+=1;
    }
  }
}

void remark(String msg) {
  sb.updateinfo(p.currentgen, currpage, pages[currpage].selectionstr(), msg);
}

void resetselection() {
  for (int i=0; i<pages.length; i++) {
    int ns=pages[i].selection.size();
    for (int j=0; j<ns; j++) {
      pages[i].selection.set(j, false);
    }
  }
}

void savefavoritespecimens() {
  genewriter.print(String.format("generation %03d:", p.currentgen));
  for (Worldmonitor wm : pages) {
    for (TWorld2D tw : wm.chosenworlds()) {
      genewriter.print(" "+tw.getbot(0).getDNA().genome());
      tw.snapshot(sndirpath);
    }
  }
  genewriter.println();
  genewriter.flush();
}

void evolvebots() {
  remark("[evolution] influencing turtlebot selection...");
  influenceturtlebotselection();
  remark("[disk] persisting favorite genome sequences...");
  savefavoritespecimens();
  remark("[evolution] population selection...");
  p.select();
  remark("[evolution] commencing reproduction...");
  p.reproduce();
  remark("[evolution] reintroducing DNA...");
  introduceDNA();
  remark("[audition_ui] resetting selections");
  resetselection();
  remark("e: evolve, n: next, p: prev, 0-5: sel");
}

void setup() {
  initsession();
  p=new Popu(psize, mrate, 8);

  size(800, 600);
  background(255);
  stroke(0);
  textAlign(LEFT, TOP);
  textSize(12);
  frameRate(15);

  mkpages(totalpages);
  sb=new Infobar();
  introduceDNA();
}

void updatevisibleworlds() {
  pages[currpage].golive();
}

void updateallworlds() {
  for (Worldmonitor wm : pages) {
    wm.golive();
  }
}

void draw() {
  updateallworlds();
  pages[currpage].monitor(screensperpage/2);
  sb.render();
}

void keyPressed() {
  Worldmonitor currmon=pages[currpage];
  if (key=='n') {
    currpage=(currpage+1)%totalpages;
    currmon=pages[currpage];
  } else if (key=='p') {
    if (currpage<=0) {
      currpage=totalpages-1;
    } else {
      currpage-=1;
    }
    currmon=pages[currpage];
  } else if (key=='e') {
    evolvebots();
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
  } else if (key=='6') {
    currmon.toggleregion(6);
  } else if (key=='7') {
    currmon.toggleregion(7);
  } else if (key=='8') {
    currmon.toggleregion(8);
  } else if (key=='9') {
    currmon.toggleregion(9);
  }
  sb.updateinfo(p.currentgen, currpage, currmon.selectionstr(), "n: next, p: prev, 0-5: sel");
}

void exit() {
  if (genewriter!=null) {
    try {
      genewriter.close();
      genewriter=null;
    }
    catch(Exception e) {
      println("[ERROR] boom! error while closing genewriter file!");
      println(e.getMessage());
    }
  }
  System.exit(0);
}
