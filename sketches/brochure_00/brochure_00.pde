import java.util.*;

// lib functions //
void err(String msg){
  println("-----------------------------");
  println("[ERROR] "+msg);
  println("-----------------------------");
}

void log(String ctx,String msg){
  println("["+ctx+"] "+msg);
}

// class definitions //
class Pen{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Pen(float x_,float y_){
    x=x_;
    y=y_;
    println(String.format("initializing turtle at (%f,%f)",x,y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0,1.0,1.0,1.0};
  }
  
  void fd(float r){
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(-angle));
    if(pendown){line(x,y,x2,y2);}
    x=x2;
    y=y2;
  }
  
  void dot(){
    point(x,y);
  }
  
  void write(String txt){
    println("txt:"+txt+" @("+x+","+y+"); color:"+rgba[0]);
    text(txt,x,y);
  }
  
  void bk(float r){fd(-r);}
  void lt(float a){angle+=a;}
  void rt(float a){lt(-a);}
  void pu(){pendown=false;}
  void pd(){pendown=true;}
  void up(){pu();}
  void down(){pd();}
  void seth(float a){angle=a;}
  
  void pencolor(float[] frgba){
    rgba[0]=frgba[0];
    rgba[1]=frgba[1];
    rgba[2]=frgba[2];
    rgba[3]=frgba[3];
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void refreshpen(){
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void movexy(float x_,float y_){
    float oldangle=angle;
    pu();
    seth(0);
    fd(x_);
    lt(90);
    fd(y_);
    pd();
    seth(oldangle);
  }
  
  void linexy(float x_,float y_){
    float px=x;
    float py=y;
    displacexy(x_,y_);
    if(pendown){
      line(px,py,x,y);
    }
  }
  
  void gotoxy(float x_,float y_){
    x=x_;
    y=y_;
  }
  
  void displacexy(float x_,float y_){
    x+=x_;
    y+=y_;
  }
  
  String toString(){
    StringBuffer sb=new StringBuffer();
    sb.append("Pen [\n");
    sb.append("  ("+x+","+y+")\n");
    sb.append("  "+angle+" degrees\n");
    sb.append("  "+(pendown?"PD":"PU")+"\n");
    sb.append("  ");
    sb.append(rgba+"\n");
    sb.append("]\n");
    return sb.toString();
  }
}

class Pair{
  float a;
  float b;
  
  Pair(String a_,String b_){
    a=float(a_);
    b=float(b_);
  }
  
  Pair(float a_,float b_){
    a=a_;
    b=b_;
  }
}

static class Cmd{
  static String PU="PU";
  static String PD="PD";
}

class Inst{
  String command;
  Pair movexy;
  
  Inst(String datum){
    if(datum.equals("u")){
      command=Cmd.PU;
      movexy=null;
    }else if(datum.equals("d")){
      command=Cmd.PD;
      movexy=null;
    }else if(datum.contains(" ")){
      command=null;
      String[] parts=datum.split(" ");
      movexy=new Pair(parts[0],parts[1]);
    }else{
      err("unknown command/data: "+datum);
    }
  }
  
  void evaluate(Pen x,Pair bd){
    if(command==null && movexy==null){
      err("null instruction exception!");
    }
    if(command==null){
      x.linexy((movexy.a/100)*bd.a,(movexy.b/100)*bd.b);
    }else{
      if(command.equals(Cmd.PU)){
        x.pu();
      }else if(command.equals(Cmd.PD)){
        x.pd();
      }else{
        err("unknown command: "+command);
      }
    }
  }
}

class SymbolTracer{
  Pen t;
  HashMap<Character,List<Inst>> tbl;
  Pair bdim;
  float chargap;
  
  float getBlockHeight(){return bdim.b;}
  float getBlockWidth(){return bdim.a;}
  
  HashMap<Character,List<Inst>> genmap(String[] lines){
    HashMap<Character,List<Inst>> hm=new HashMap<Character,List<Inst>>();
    for(String line:lines){
      String[] parts=line.split("=>");
      char sym=parts[0].charAt(0);
      log("genmap","loading symbol <"+sym+">");
      String inststr=parts[1];
      String[] instparts=inststr.split(";");
      List<Inst> instlist=new ArrayList<Inst>();
      for(String i:instparts){
        Inst xi=new Inst(i);
        instlist.add(xi);
      }
      hm.put(sym,instlist);
    }
    return hm;
  }
  
  SymbolTracer(Pen t_,String[] lines,Pair bdim_){
    t=t_;
    tbl=genmap(lines);
    bdim=bdim_;
    chargap=0.0;
  }
  
  void setBlockDimensions(float w,float h){
    bdim=new Pair(w,h);
  }
  
  void setcolor(float r,float g,float b,float a){
    t.pencolor(new float[]{r,g,b,a});
  }
  
  void trace(String txt,float x,float y){
    log("trace",txt);
    t.gotoxy(x,y);
    t.seth(0);
    float currx=t.x;
    float curry=t.y;
    log("trace","currx:"+currx+",curry:"+curry);
    for(int i=0;i<txt.length();i++){
      List<Inst> instseq=tbl.get(txt.charAt(i));
      for(Inst inst:instseq){
        inst.evaluate(t,bdim);
      }
      t.gotoxy(currx,curry);
      t.seth(0);
      t.up();
      t.fd(bdim.a+chargap);
      t.down();
      currx=t.x;
      curry=t.y;
    }
  }
}

class Slide{
  String name;
  String hImage;
  String hText;
  String bImage;
  String fText;
}

// globals //
int ctr=0;
Pen p;
String[] typolines;
SymbolTracer st;
List<Slide> slideseq;
int slideIndex=0;

void mkslideshow(String[] lines){
  slideseq=new ArrayList<Slide>();
  char PARSING_SLIDE='P';
  char NON_SLIDE='N';
  char ERROR='E';
  char state=NON_SLIDE;
  Slide currSlide=null;
  for(String line:lines){
    log("mkslideshow","<state:"+state+">  "+line);
    if(line.trim().equals("")){
      continue;
    }
    if(line.startsWith("#")){
      continue;
    }
    if(line.startsWith("slide ") && state==NON_SLIDE){
      state=PARSING_SLIDE;
      String[] parts=line.split(" ");
      String slideName=parts[1];
      log("mkslideshow","started parsing slide: "+slideName);
      currSlide=new Slide();
      currSlide.name=slideName;
    }
    else if(line.startsWith("slide ") && state==PARSING_SLIDE){
      err("nested slides not yet supported! program will fail!");
      state=ERROR;
      break;
    }
    else if(line.startsWith("end") && state==NON_SLIDE){
      err("nested slides not yet supported! program will fail!");
      state=ERROR;
      break;
    }
    else if(line.startsWith("end") && state==PARSING_SLIDE){
      slideseq.add(currSlide);
      state=NON_SLIDE;
      log("mkslideshow","finished parsing slide: "+currSlide.name);
    }
    else if(state==PARSING_SLIDE){
      String[] parts=line.split("=>");
      String lv=parts[0];
      String rv=parts[1];
      if(lv.equals("h.image")){
        currSlide.hImage=rv;
      }else if(lv.equals("h.text")){
        currSlide.hText=rv;
      }else if(lv.equals("b.image")){
        currSlide.bImage=rv;
      }else if(lv.equals("f.text")){
        currSlide.fText=rv;
      }else{
        err("unknown attribute: "+lv);
        state=ERROR;
        break;
      }
    }
  }
}

void renderslide(int idx){
  background(255,255,255);
  Slide cs=slideseq.get(idx);
  // b.image
  log("renderslide","loading image: "+cs.bImage);
  PImage bimg=loadImage(cs.bImage);
  bimg.resize(992,558);
  image(bimg,4,105);
  // h.image
  log("renderslide","loading image: "+cs.hImage);
  PImage himg=loadImage(cs.hImage);
  himg.resize(50,0);
  image(himg,20,20);
  // h.text
  st.chargap=0.0;
  st.setcolor(0,0,0,255);
  st.setBlockDimensions(18,32);
  st.trace(cs.hText,80,30);
  // f.text
  st.chargap=2.0;
  st.setcolor(180,180,180,255);
  st.setBlockDimensions(10,10);
  st.trace(cs.fText,594,735);
}

// processing funxions //
void setup(){
  size(1000,750);
  smooth();
  background(255,255,255);
  stroke(15);
  p=new Pen(width/2,height/2);
  typolines=loadStrings("machinehead.typo");
  st=new SymbolTracer(p,typolines,new Pair(18,32));
  mkslideshow(loadStrings("piad.slideshow"));
}

void draw(){}

// sensor handlers //
void mouseClicked(){
  log("mouse","click ("+mouseX+","+mouseY+")");
  saveFrame(String.format("rec/%s-####.png","brochure"));
}

void keyReleased(){
  log("keyboard",""+key);
  if(key=='n'){
    log("keyboard","rendering slide "+slideIndex);
    renderslide(slideIndex);
    slideIndex++;
  }else if(key=='p'){
    log("keyboard","rendering slide "+(slideIndex-2));
    renderslide(slideIndex-2);
    slideIndex--;
  }
}
