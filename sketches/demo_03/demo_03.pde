PImage m;
String rootdir="/media/heerdyes/home/heerdyes/L/GH/heerdyes/raspi-art/sketches/demo_03/";
ArrayList<String> ring;
int idx=-1;
File imgdir;
int zfw;
String mode="draw";
int cursor[]=new int[2];

void setup(){
  size(1600,900);
  background(255);
  stroke(0,255,0);
  strokeWeight(1.5);
  // populate image buffer ring
  ring=new ArrayList<String>();
  String[] cfg=loadStrings("ppt.seq");
  String dirpath=rootdir+cfg[0];
  for(int i=1;i<cfg.length;i++){
    ring.add(dirpath+"/"+cfg[i]);
  }
  imageMode(CENTER);
  rectMode(CENTER);
  cursor[0]=50;
  cursor[1]=50;
}

void draw(){}

void mouseDragged(){
  if(mode.equals("draw")){
    line(pmouseX,pmouseY,mouseX,mouseY);
  }
}

void mouseClicked(){
  if(mode.equals("draw")){
    circle(mouseX,mouseY,2);
  }else if(mode.equals("type")){
    cursor[0]=mouseX;
    cursor[1]=mouseY;
  }
}

boolean outofslide(){
  if(m==null){
    return false;
  }
  float dw=width/2-m.width/2;
  float dh=height/2-m.height/2;
  return mouseX<dw || mouseX>width-dw || mouseY<dh || mouseY>height-dh;
}

void mouseMoved(){
  if(outofslide()){
    stroke(0,92,0);
  }else{
    stroke(0,255,0);
  }
}

void mouseWheel(MouseEvent event) {
  float e=event.getCount();
  int z=(int)e;
  if(m==null){return;}
  if(z==-1){
    wipecurrimg();
    zfw+=10;
    m.resize(zfw,0);
    image(m,width/2,height/2);
  }else if(z==1){
    println("restoring to original dimensions");
    f5slide();
  }
}

void wipecurrimg(){
  if(m!=null){
    stroke(255);
    fill(255);
    rect(width/2,height/2,m.width,m.height);
    stroke(0,255,0);
  }
}

void nxtslide(){
  if(ring.size()>0){
    wipecurrimg();
    idx=idx+1;
    idx=idx%ring.size();
    m=loadImage(ring.get(idx));
    zfw=m.width;
    image(m,width/2,height/2);
  }else{
    println("ring size less than zero! perhaps no images loaded?");
  }
}

void prvslide(){
  if(ring.size()>0){
    wipecurrimg();
    idx=idx-1;
    if(idx<0){
      idx=ring.size()-1;
    }
    m=loadImage(ring.get(idx));
    zfw=m.width;
    image(m,width/2,height/2);
  }else{
    println("ring size less than zero! perhaps no images loaded?");
  }
}

void f5slide(){
  if(ring.size()>0){
    wipecurrimg();
    m=loadImage(ring.get(idx));
    zfw=m.width;
    image(m,width/2,height/2);
  }
}

void drawKeyHandler(){
  if(key=='n'){
    nxtslide();
  }else if(key=='p'){
    prvslide();
  }else if(key=='c'){
    background(255);
    f5slide();
  }else if(key=='s'){
    String fn=String.format("img/demo_03_%04d%02d%02d_%02d%02d%02d_%03d.png",year(),month(),day(),hour(),minute(),second(),millis());
    println("saving to file: "+fn);
    save(fn);
  }
}

void typeKeyHandler(){
  if(outofslide()){
    stroke(0,64,0);
    fill(0,64,0);
  }else{
    stroke(0,255,0);
    fill(0,255,0);
  }
  text(key,cursor[0],cursor[1]);
  cursor[0]+=10;
}

void keyPressed(){
  println(String.format("[%d] %s",keyCode,key));
  if(keyCode==16){
    mode=mode.equals("type")?"draw":"type";
    println("mode: "+mode);
    return;
  }
  if(mode.equals("draw")){
    drawKeyHandler();
  }else if(mode.equals("type")){
    typeKeyHandler();
  }
}

