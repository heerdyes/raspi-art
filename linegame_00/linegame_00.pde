float _x,_y;
float _vx=0.1,_vy=0.0;
float _ax=0.1,_ay=0.1;
boolean _raytoggle=false;
int _r,_g,_b,_o;
int _ar,_ag,_ab;

void setup(){
  size(500,300);
  background(255);
  _r=150;
  _g=150;
  _b=150;
  _o=100;
  stroke(_r,_g,_b,_o);
  _x=10.0;
  _y=10.0;
  _ar=1;
  _ag=1;
  _ab=-1;
}

void updatecolor(){
  _r+=_ar;
  _g+=_ag;
  _b+=_ab;
  stroke(_r,_g,_b,_o);
}

void draw(){
  //saveFrame("output/linegame_####.png");
  if(_x>width){    _x=10;        }
  if(_y>height){   _y=10;        }
  if(_x<0){        _x=width-10;  }
  if(_y<0){        _y=height-10; }
  if(_r<0){        _r=255;       }
  if(_g<0){        _g=255;       }
  if(_b<0){        _b=255;       }
  if(_r>255){      _r=0;         }
  if(_g>255){      _g=0;         }
  if(_b>255){      _b=0;         }
  updatecolor();
  point(_x,_y);
  if(_raytoggle){
    line(_x,_y,mouseX,mouseY);
  }
  _x+=_vx;
  _y+=_vy;
}

void keyPressed(){
  if(key==CODED){
    if(keyCode==UP){
      _vy-=_ay;
      //println("_vy="+_vy);
    }else if(keyCode==DOWN){
      _vy+=_ay;
      //println("_vy="+_vy);
    }else if(keyCode==LEFT){
      _vx-=_ax;
      //println("_vx="+_vx);
    }else if(keyCode==RIGHT){
      _vx+=_ax;
      //println("_vx="+_vx);
    }
  }else{
    println("keycode="+keyCode);
    if(keyCode==48){
      println("setting color to avg(r,g,b) ...");
      int gray=(_r+_g+_b)/3;
      _r=gray;
      _g=gray;
      _b=gray;
    }else if(keyCode==49){
      println("r++");
      _ar+=1;
    }else if(keyCode==50){
      println("r--");
      _ar-=1;
    }else if(keyCode==51){
      println("g++");
      _ag+=1;
    }else if(keyCode==52){
      println("g--");
      _ag-=1;
    }else if(keyCode==53){
      println("b++");
      _ab+=1;
    }else if(keyCode==54){
      println("b--");
      _ab-=1;
    }
  }
}

void mousePressed(){
  _raytoggle=!_raytoggle;
}
