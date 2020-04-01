float _x,_y;
float _vx=0.1,_vy=0.1;
float _ax=0.1,_ay=0.1;
boolean _raytoggle=false;
int _r,_g,_b,_o;
int _ar,_ag,_ab;

void setup(){
  size(600,400);
  background(0);
  _r=250;
  _g=250;
  _b=250;
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
  // controlling the various parameters for dynamics
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
    println("key="+key+",keycode="+keyCode);
    if(key=='0'){
      println("setting color to avg(r,g,b) ...");
      int gray=(_r+_g+_b)/3;
      _r=gray;
      _g=gray;
      _b=gray;
    }else if(key=='1'){
      println("ar++");
      _ar+=1;
    }else if(key=='2'){
      println("ar--");
      _ar-=1;
    }else if(key=='3'){
      println("ag++");
      _ag+=1;
    }else if(key=='4'){
      println("ag--");
      _ag-=1;
    }else if(key=='5'){
      println("ab++");
      _ab+=1;
    }else if(key=='6'){
      println("ab--");
      _ab-=1;
    }else if(key=='b'){
      println("black!");
      _r=0;
      _g=0;
      _b=0;
    }else if(key=='w'){
      println("white!");
      _r=255;
      _g=255;
      _b=255;
    }else if(key=='h'){
      println("h -> horizontal alignment...");
      _vx=1.0;
      _vy=0.0;
      _x=0.0;
      _y=random(5,height-5);
    }else if(key=='v'){
      println("v -> vertical alignment...");
      _vx=0.0;
      _vy=1.0;
      _x=random(5,width-5);
      _y=0.0;
    }else if(key=='m'){
      println("m -> monochrome mode...");
      _ar=0;
      _ag=0;
      _ab=0;
    }
  }
}

void mousePressed(){
  _raytoggle=!_raytoggle;
}
