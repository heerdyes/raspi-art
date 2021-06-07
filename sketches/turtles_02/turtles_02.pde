Turtleswarm ts;
PGraphics large;
int lw=4000,lh=4000;
boolean largemode=false;

void art00(PGraphics p){
  float w=largemode?lw:width;
  float h=largemode?lh:height;
  ts=new Turtleswarm(new ArrayList<Turtlebot>());
  for(int i=0;i<12;i++){
    ts.addt(new Turtlebot(new Turtle(w*0.25+i*7,h*0.52,i*2,p),0.75*i,0,i*2,3+3*sin(i*0.01)));
  }
  if(largemode){ // live through iterations
    for(int j=0;j<3000;j++){
      ts.live();
    }
  }
}

void largesetup(){
  largemode=true;
  large=createGraphics(lw,lh);
  large.beginDraw();
  large.background(255);
  large.stroke(0,128,128,255);
  large.smooth();
  large.strokeWeight(2.0);
  large.noFill();
  art00(large);
  large.endDraw();
  image(large,0,0,width,height);
}

void playsetup(){
  largemode=false;
  background(255);
  smooth();
  //strokeWeight(1.0);
  noFill();
  stroke(0,128,128,128);
  art00(null);
}

void setup(){
  size(900,900);
  playsetup();
}

void draw(){
  if(!largemode){
    ts.live();
  }
}

void keyPressed(){
  if(key=='q'){
    exit();
  }else if(key=='s' && largemode){
    String fn=String.format("img/turtles_02_large_%04d%02d%02d_%02d%02d%02d.jpg",year(),month(),day(),hour(),minute(),second());
    println("saving to file: "+fn);
    large.save(fn);
  }else if(key=='s' && !largemode){
    String fn=String.format("img/turtles_02_play_%04d%02d%02d_%02d%02d%02d.jpg",year(),month(),day(),hour(),minute(),second());
    println("saving to file: "+fn);
    save(fn);
  }else if(key=='c'){
    background(255);
  }
}
