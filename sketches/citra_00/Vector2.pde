class Vector2{
  double x,y;
  
  Vector2(double x,double y){
    this.x=x;
    this.y=y;
  }
  
  double mag(){
    return Math.sqrt(x*x+y*y);
  }
  
  Vector2 normalized(){
    double vm=mag();
    return new Vector2(x/vm,y/vm);
  }
  
  Vector2 minus(Vector2 v2){
    return new Vector2(x-v2.x,y-v2.y);
  }
  
  Vector2 plus(Vector2 v2){
    return new Vector2(x+v2.x,y+v2.y);
  }
  
  void mul(double f){
    this.x*=f;
    this.y*=f;
  }
  
  void add(double s){
    this.x+=s;
    this.y+=s;
  }
}
