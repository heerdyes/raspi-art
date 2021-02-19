float frac=0.80;

void setup(){
  size(900,600);
  background(0);
  stroke(255);
  noFill();
  //drawcirc(width/2,height/2,300);
  cantor_01(100,height/2,700,10);
  cantor_01(100,height/2-5,700,-10);
}

void cantor_01(float x,float y,float len,float gap){
  if(len<1){ return; }
  line(x,y,x+len,y);
  y+=gap;
  cantor_01(x,y,len/3,gap);
  cantor_01(x+len*2/3,y,len/3,gap);
}

void fracline(float x,float y,float len,float gap){
  if(len<1){ return; }
  line(x,y,x+len,y);
  y+=gap;
  cantor_01(x,y,len/3,gap);
  cantor_01(x+len*2/3,y,len/3,gap);
}

void drawcirc(float x,float y,float radius){
  ellipse(x,y,radius,radius);
  if(radius>1.0){
    int ir=(int)radius;
    float rnext=exp(-frac)*radius;
    drawcirc(x+rnext,y,rnext);
    drawcirc(x-rnext,y,rnext);
  }
}

void draw(){}

String rndstr(int n){
  StringBuffer sb=new StringBuffer();
  for(int i=0;i<n;i++){
    char rc=(char)int(random(65,90.1));
    sb.append(rc);
  }
  return sb.toString();
}

void keyPressed(){
  if(key=='q'){
    exit();
  }else if(key=='s'){
    String fn=String.format("img/fractal_10_%s.png",rndstr(8));
    println("saving to file: "+fn);
    save(fn);
  }
}

