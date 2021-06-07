class Walker{
  float x,y;
  int si;
  
  Walker(){
    x=0;
    y=height/2;
    si=0;
  }
  
  void display(){
    point(x,y);
    //ellipse(x,y,12,12);
  }
  
  void step(){
    x+=1;
    float toss=noise(x);
    int xi=toss>0.5?1:-1;
    si=si+xi;
    y=height/2+si;
  }
}
