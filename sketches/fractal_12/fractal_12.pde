boolean paused=false;
ArrayList<Branch> fq;

class Pt{
  float x;
  float y;
  
  Pt(float x,float y){
    this.x=x;
    this.y=y;
  }
}

class Branch{
  float x;
  float y;
  float r;
  float a;
  
  Branch(float x,float y,float r,float a){
    this.x=x;
    this.y=y;
    this.r=r;
    this.a=a;
  }
  
  void shadowline(int n,float d,float x1,float y1){
    float initopa=255;
    for(int i=0;i<n;i++){
      stroke(255,255/(i+1));
      line(x+i*d,y+i*d,x1+i*d,y1+i*d);
    }
  }
  
  Pt[] shape(String s,float x1,float y1){
    if("line".equals(s)){
      line(x,y,x1,y1);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("lline".equals(s)){
      shadowline(5,2,x1,y1);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("ellipse".equals(s)){
      ellipse(x,y,r,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("rect".equals(s)){
      rect(x,y,r,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("circle".equals(s)){
      circle(x,y,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("plus".equals(s)){
      for(int i=0;i<4;i++){
        line(x,y,x+r*cos(i*PI/2),y-r*sin(i*PI/2));
      }
      return new Pt[]{new Pt(x1,y1)};
    }
    if("diamond".equals(s)){
      for(int i=0;i<4;i++){
        float ca=i*PI/2;
        float cb=ca+PI/2;
        line(x+r*cos(ca),y-r*sin(ca),x+r*cos(cb),y-r*sin(cb));
      }
      return new Pt[]{new Pt(x1,y1)};
    }
    if("trizUla".equals(s)){
      line(x,y,x1,y1);
      float rx=0.5*r;
      Pt mpt=new Pt(x1,y1);
      float la=a+PI/2;
      Pt lpt=new Pt(x1+rx*cos(la),y1-rx*sin(la));
      line(x1,y1,lpt.x,lpt.y);
      float ra=a-PI/2;
      Pt rpt=new Pt(x1+rx*cos(ra),y1-rx*sin(ra));
      line(x1,y1,rpt.x,rpt.y);
      return new Pt[]{lpt,mpt,rpt};
    }
    return new Pt[]{};
  }
  
  Pt[] draw(){
    float x1=x+r*cos(a);
    float y1=y-r*sin(a);
    return shape("trizUla",x1,y1);
  }
}

void initfrac00(float rd){
  fq.add(new Branch(width/2,height/2,rd,0));
  fq.add(new Branch(width/2,height/2,rd,PI/2));
  fq.add(new Branch(width/2,height/2,rd,PI));
  fq.add(new Branch(width/2,height/2,rd,3*PI/2));
}

void initfrac01(float rd){
  fq.add(new Branch(width/2,height/2,rd,0));
  fq.add(new Branch(width/2,height/2,rd,PI));
}

void initfrac02(float rd){
  fq.add(new Branch(width/2,height/2,rd,0));
}

void initfrac03(float rd){
  fq.add(new Branch(width/2,height/2,rd,0));
  fq.add(new Branch(width/2,height/2,rd,2*PI/3));
  fq.add(new Branch(width/2,height/2,rd,4*PI/3));
}

void initfrac04(float rd){
  fq.add(new Branch(width/2,height/2,rd,PI/4));
  fq.add(new Branch(width/2,height/2,rd,5*PI/4));
}

void setup(){
  size(3200,3200);
  background(0);
  stroke(255,212);
  strokeWeight(2);
  rectMode(CENTER);
  noFill();
  fq=new ArrayList<Branch>();
  initfrac01(720);
}

void growfrac00(){
  if(fq.isEmpty()){ return; }
  Branch b=fq.remove(0);
  if(b.r<1){ return; }
  Pt[] pts=b.draw();
  float cf=0.4;
  Branch lb=new Branch(pts[0].x,pts[0].y,b.r*0.55,b.a+cf*PI);
  Branch rb=new Branch(pts[0].x,pts[0].y,b.r*0.55,b.a-cf*PI);
  fq.add(lb);
  fq.add(rb);
}

void growfrac01(){
  if(fq.isEmpty()){ return; }
  Branch b=fq.remove(0);
  if(b.r<1){ return; }
  Pt[] pts=b.draw();
  for(int i=0;i<pts.length;i++){
    float ax=b.a+(i-pts.length/2)*PI/16;
    Branch bx=new Branch(pts[i].x,pts[i].y,b.r*0.25,ax);
    fq.add(bx);
  }
}

void growfrac02(){
  if(fq.isEmpty()){ return; }
  Branch b=fq.remove(0);
  if(b.r<1){ return; }
  Pt[] pts=b.draw();
  float cf=1.0/2.0;
  Branch lb=new Branch(pts[0].x,pts[0].y,b.r*0.8,b.a+cf*PI);
  Branch rb=new Branch(pts[0].x,pts[0].y,b.r*0.2,b.a-cf*PI);
  fq.add(lb);
  fq.add(rb);
}

void growfrac03(){
  if(fq.isEmpty()){ return; }
  Branch b=fq.remove(0);
  if(b.r<1){ return; }
  Pt[] pts=b.draw();
  float cf=1.0/2.0;
  Branch lb=new Branch(pts[0].x,pts[0].y,b.r*0.75,b.a+cf*PI);
  Branch rb=new Branch(pts[0].x,pts[0].y,b.r*0.25,b.a-cf*PI);
  fq.add(lb);
  fq.add(rb);
}

void draw(){
  if(!paused){
    growfrac03();
  }
}

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
    String fn=String.format("img/fractal_12_%s.png",rndstr(8));
    println("saving to file: "+fn);
    save(fn);
  }else if(key=='c'){
    fq.clear();
    background(0);
    initfrac01(300);
  }else if(key=='p'){
    paused=!paused;
  }
}

