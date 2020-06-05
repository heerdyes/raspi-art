// --- based on code from the book Generative Art by Matt Pearson --- //
FractalRoot frshape;
int _maxlevels=3;
float _strutFactor=0.25;
float _strutNoise;
int _numSides=4;

class PointObj{
  float x,y;
  PointObj(float ex,float why){
    x=ex;
    y=why;
  }
}

class Branch{
  int level,num;
  PointObj[] outerPoints={};
  PointObj[] midPoints={};
  PointObj[] projPoints={};
  Branch[] myBranches={};
  
  Branch(int lev,int n,PointObj[] points){
    level=lev;
    num=n;
    outerPoints=points;
    midPoints=calcMidPoints();
    projPoints=calcStrutPoints();
    
    if((level+1)<_maxlevels){
      Branch childBranch=new Branch(level+1,0,projPoints);
      myBranches=(Branch[])append(myBranches,childBranch);
      
      for(int k=0;k<outerPoints.length;k++){
        int nextk=k-1;
        if(nextk<0){nextk+=outerPoints.length;}
        PointObj[] newPoints={projPoints[k],midPoints[k],
                    outerPoints[k],midPoints[nextk],projPoints[nextk]};
        childBranch=new Branch(level+1,k+1,newPoints);
        myBranches=(Branch[])append(myBranches,childBranch);
      }
    }
  }
  
  void drawMe(){
    strokeWeight(4-level);
    for(int i=0;i<outerPoints.length;i++){
      int nexti=i+1;
      if(nexti==outerPoints.length){nexti=0;}
      line(outerPoints[i].x,outerPoints[i].y,outerPoints[nexti].x,outerPoints[nexti].y);
    }
    
    strokeWeight(0.5);
    fill(255,150);
    for(int j=0;j<midPoints.length;j++){
      //ellipse(midPoints[j].x,midPoints[j].y,15,15);
      line(midPoints[j].x,midPoints[j].y,projPoints[j].x,projPoints[j].y);
      //ellipse(projPoints[j].x,projPoints[j].y,15,15);
    }
    
    for(int k=0;k<myBranches.length;k++){
      myBranches[k].drawMe();
    }
  }
  
  PointObj[] calcMidPoints(){
    PointObj[] mpArray=new PointObj[outerPoints.length];
    for(int i=0;i<outerPoints.length;i++){
      int nexti=i+1;
      if(nexti==outerPoints.length){nexti=0;}
      PointObj thisMP=calcMidPoint(outerPoints[i],outerPoints[nexti]);
      mpArray[i]=thisMP;
    }
    return mpArray;
  }
  
  PointObj calcMidPoint(PointObj end1,PointObj end2){
    float mx,my;
    if(end1.x>end2.x){
      mx=end2.x+((end1.x-end2.x)/2);
    }else{
      mx=end1.x+((end2.x-end1.x)/2);
    }
    if(end1.y>end2.y){
      my=end2.y+((end1.y-end2.y)/2);
    }else{
      my=end1.y+((end2.y-end1.y)/2);
    }
    return new PointObj(mx,my);
  }
  
  PointObj[] calcStrutPoints(){
    PointObj[] strutArray=new PointObj[midPoints.length];
    for(int i=0;i<midPoints.length;i++){
      int nexti=i+3;
      if(nexti>=midPoints.length){nexti-=midPoints.length;}
      PointObj thisSP=calcProjPoint(midPoints[i],outerPoints[nexti]);
      strutArray[i]=thisSP;
    }
    return strutArray;
  }
  
  PointObj calcProjPoint(PointObj mp,PointObj op){
    float px,py;
    float adj,opp;
    if(op.x>mp.x){
      opp=op.x-mp.x;
    }else{
      opp=mp.x-op.x;
    }
    if(op.y>mp.y){
      adj=op.y-mp.y;
    }else{
      adj=mp.y-op.y;
    }
    if(op.x>mp.x){
      px=mp.x+(opp*_strutFactor);
    }else{
      px=mp.x-(opp*_strutFactor);
    }
    if(op.y>mp.y){
      py=mp.y+(adj*_strutFactor);
    }else{
      py=mp.y-(adj*_strutFactor);
    }
    return new PointObj(px,py);
  }
}

class FractalRoot{
  PointObj[] pointArr={};
  Branch rootBranch;
  
  FractalRoot(float startAngle){
    float centX=width/2;
    float centY=height/2;
    float angleStep=360.0f/_numSides;
    for(int i=0;i<360;i+=angleStep){
      float x=centX+(200*cos(radians(startAngle+i)));
      float y=centY+(200*sin(radians(startAngle+i)));
      pointArr=(PointObj[])append(pointArr,new PointObj(x,y));
    }
    rootBranch=new Branch(0,0,pointArr);
  }
  
  void drawShape(){
    rootBranch.drawMe();
  }
}

void setup(){
  size(640,480);
  smooth();
  _strutNoise=0;
}

void draw(){
  background(255);
  _strutNoise+=0.01;
  _strutFactor=(noise(_strutNoise)*3)-1;
  frshape=new FractalRoot(frameCount);
  frshape.drawShape();
  saveFrame("output/fractal_sutcliffe_####.png");
}

void mousePressed(){
  exit();
}
