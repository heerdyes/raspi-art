import java.util.Iterator;
import java.util.Map.Entry;

void toprightstats(PGraphics g, int genlim, float st, float tn) {
  float cornerx=g.width-400;
  g.text("TURN = "+nf(tn, 3, 3), cornerx, 10);
  g.text("STEP = "+nf(st, 2, 3), cornerx, 60);
  g.text("DEPTH = "+nf(genlim, 2, 0), cornerx, 110);
}

void bottomleftstats(PGraphics g) {
  float cornery=g.height-ls.rules.size()*100-100;
  g.text("AXIOM : "+ls.axiom, 20, cornery);
  g.text("RULES : ", 20, cornery+50);
  Iterator<Entry<Character, String>> it=ls.rules.entrySet().iterator();
  int ctr=0;
  while (it.hasNext()) {
    Entry<Character, String> e=it.next();
    char k=e.getKey();
    String v=e.getValue();
    String ptxt=String.format("%s -> %s", k, v);
    g.text(ptxt, 20, cornery+(ctr+2)*50);
    ctr+=1;
  }
}

void txtcfg(PGraphics g) {
  g.textFont(ocra);
  g.textAlign(LEFT, TOP);
  g.textSize(fntsz);
}

void txtcfg() {
  textFont(ocra);
  textSize(13.5);
  textAlign(LEFT, TOP);
}

void tbox(String txt, float tbx, float tby, float tbw, float tbh) {
  txtcfg();
  fill(DGRAY);
  noStroke();
  rect(tbx, tby, tbw, tbh);
  fill(WHITE);
  stroke(WHITE);
  text(txt, tbx+5, tby+5);
}
