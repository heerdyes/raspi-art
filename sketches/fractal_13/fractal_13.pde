PGraphics large;
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
      large.stroke(255,255/(i+1));
      large.line(x+i*d,y+i*d,x1+i*d,y1+i*d);
    }
  }
  
  Pt[] shape(String s,float x1,float y1){
    if("line".equals(s)){
      large.line(x,y,x1,y1);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("lline".equals(s)){
      shadowline(5,2,x1,y1);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("ellipse".equals(s)){
      large.ellipse(x,y,r,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("rect".equals(s)){
      large.rect(x,y,r,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("circle".equals(s)){
      large.circle(x,y,r);
      return new Pt[]{new Pt(x1,y1)};
    }
    if("plus".equals(s)){
      for(int i=0;i<4;i++){
        large.line(x,y,x+r*cos(i*PI/2),y-r*sin(i*PI/2));
      }
      return new Pt[]{new Pt(x1,y1)};
    }
    if("diamond".equals(s)){
      for(int i=0;i<4;i++){
        float ca=i*PI/2;
        float cb=ca+PI/2;
        large.line(x+r*cos(ca),y-r*sin(ca),x+r*cos(cb),y-r*sin(cb));
      }
      return new Pt[]{new Pt(x1,y1)};
    }
    if("trizUla".equals(s)){
      large.line(x,y,x1,y1);
      float rx=0.5*r;
      Pt mpt=new Pt(x1,y1);
      float la=a+PI/2;
      Pt lpt=new Pt(x1+rx*cos(la),y1-rx*sin(la));
      large.line(x1,y1,lpt.x,lpt.y);
      float ra=a-PI/2;
      Pt rpt=new Pt(x1+rx*cos(ra),y1-rx*sin(ra));
      large.line(x1,y1,rpt.x,rpt.y);
      return new Pt[]{lpt,mpt,rpt};
    }
    return new Pt[]{};
  }
  
  Pt[] draw(String sh){
    float x1=x+r*cos(a);
    float y1=y-r*sin(a);
    return shape(sh,x1,y1);
  }
}

void initfrac00(float rd){
  fq.add(new Branch(large.width/2,large.height/2,rd,0));
  fq.add(new Branch(large.width/2,large.height/2,rd,PI/2));
  fq.add(new Branch(large.width/2,large.height/2,rd,PI));
  fq.add(new Branch(large.width/2,large.height/2,rd,3*PI/2));
}

void initfrac01(float rd){
  fq.add(new Branch(large.width/2,large.height/2,rd,0));
  fq.add(new Branch(large.width/2,large.height/2,rd,PI));
}

void initfrac02(float rd){
  fq.add(new Branch(large.width/2,large.height/2,rd,0));
}

void initfrac03(float rd){
  fq.add(new Branch(large.width/2,large.height/2,rd,0));
  fq.add(new Branch(large.width/2,large.height/2,rd,2*PI/3));
  fq.add(new Branch(large.width/2,large.height/2,rd,4*PI/3));
}

void initfrac04(float rd){
  fq.add(new Branch(large.width/2,large.height/2,rd,PI/4));
  fq.add(new Branch(large.width/2,large.height/2,rd,5*PI/4));
}

void setup(){
  large=createGraphics(3000,3000);
  large.beginDraw();
  large.background(0);
  large.stroke(255,250,240,164);
  large.strokeWeight(4);
  large.rectMode(CENTER);
  large.noFill();
  fq=new ArrayList<Branch>();
  size(900,900);
  initfrac00(900);
  for(int i=0;i<16000;i++){
    growfracn(3,"rect");
  }
  large.endDraw();
  image(large,0,0,width,height);
}

void growfracn(int nx,String s){
  if(fq.isEmpty()){ return; }
  Branch b=fq.remove(0);
  if(b.r<1){ return; }
  Pt[] pts=b.draw(s);
  float cf=1.05/2.0;
  for(int j=0;j<nx;j++){
    Branch bx=new Branch(pts[0].x,pts[0].y,0.414141*b.r,b.a+0.25*PI);
    fq.add(bx);
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
    //String fn=String.format("img/fractal_13_%s.png",rndstr(8));
    String fn=String.format("img/fractal_13_%04d%02d%02d_%02d%02d%02d.jpg",year(),month(),day(),hour(),minute(),second());
    println("saving to file: "+fn);
    large.save(fn);
  }else if(key=='c'){
    fq.clear();
    background(0);
  }
}
