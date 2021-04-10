import java.util.*;

// globals //
int ctr=0;
String[] typolines;
HashMap<Character,PShape> ctab;
int[] cursor=new int[]{0,0};
int[] fontdim=new int[]{30,40};

// lib funxions //
void err(String msg){
  println("-----------------------------");
  println("[ERROR] "+msg);
  println("-----------------------------");
}

void log(String ctx,String msg){
  println("["+ctx+"] "+msg);
}

HashMap<Character,PShape> loadsvgfont(File d){
  log("loadsvgfont","loading svg file shapes...");
  HashMap<Character,PShape> cmap=new HashMap<Character,PShape>();
  for(File f:d.listFiles()){
    String fnm=f.getName();
    if(!fnm.endsWith(".svg")){
      continue;
    }
    String[] fnfx=fnm.split("\\.");
    log("loadsvgfont","mapping character: "+fnfx[0]);
    cmap.put(fnfx[0].charAt(0),loadShape(f.getAbsolutePath()));
  }
  return cmap;
}

// processing funxions //
void setup(){
  size(1280,720);
  smooth();
  background(255,255,255);
  stroke(0);
  File cwd=new File("metafont_01/machinehead");
  log("setup","font dir: "+cwd.getAbsolutePath());
  ctab=loadsvgfont(cwd);
  cursor[0]=30;
  cursor[1]=30;
}

void draw(){}

// sensor handlers //
void mouseClicked(){
  log("mouse","click ("+mouseX+","+mouseY+")");
  //saveFrame(String.format("rec/%s-####.png","videosynth"));
}

void keyPressed(){
  log("keyboard",""+keyCode);
  int ck=(int)key;
  if(ck>=97&ck<=122 || ck>=65&&ck<=91 || ck>=48&&ck<=57){
    if(ctab.get(key)==null){
      err("no svg file for character: "+key);
      return;
    }
    shape(ctab.get(key),cursor[0],cursor[1],fontdim[0],fontdim[1]);
    cursor[0]+=fontdim[0];
  }else if(key==' '){
    cursor[0]+=fontdim[0];
  }else if(key=='\n'){
    cursor[0]=fontdim[0];
    cursor[1]+=fontdim[1];
  }
}

