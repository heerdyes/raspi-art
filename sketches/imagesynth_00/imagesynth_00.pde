void yrmark(float d,float x,String s){
  float df=lastmark+d;
  line(df,height/2-x,df,height/2+x);
  fill(0,0,120);
  text(s,df-12,height/2+x+10);
  lastmark=df;
}

float lastmark=0.0;
String[] timedata;
String[] eventdata;
float r=250,g=240,b=230;

void setup(){
  size(800,600);
  background(r,g,b);
  stroke(0);
  noLoop();
  timedata=loadStrings("cfg/tmp.timeline");
  eventdata=loadStrings("cfg/tmp.events");
  textSize(11);
}

void rendertimeline(){
  line(0,height/2,width-1,height/2);
  for(String s:timedata){
    String[] x=s.split(" ");
    yrmark(float(x[0]),float(x[1]),x[2]);
  }
}

void lrlabel(float ax,float ry,String txt){
  stroke(100,100,100);
  line(ax,height/2,ax,height/2-ry);
  float dtxt=7*txt.length();
  if(ry<0){
    line(ax,height/2-ry,ax+dtxt,height/2-ry);
    stroke(0,0,200);
    text(txt,ax+5,height/2-ry-1);
  }else{
    line(ax-dtxt,height/2-ry,ax,height/2-ry);
    stroke(0,0,200);
    text(txt,ax-dtxt,height/2-ry-1);
  }
}

void renderevents(){
  for(String e:eventdata){
    String[] ex=e.split(" ");
    float ax=float(ex[0]);
    float ry=float(ex[1]);
    String es=ex[2];
    lrlabel(ax,ry,es);
  }
}

void draw(){
  rendertimeline();
  renderevents();
}

void keyReleased(){
  background(r,g,b);
  redraw();
}

void mouseClicked(){
  saveFrame("rec/imagesynth_####.png");
}
