double _x,_y,_xx,_yy;
double _vx=0.0,_vy=0.0;
double _ax=0.1,_ay=0.1;
int _r,_g,_b,_o;
int _ar,_ag,_ab;
double _lvx=-4.0,_uvx=4.0,_lvy=-4.0,_uvy=4.0;
int _vxdir=1,_vydir=1;
double _vxstep=0.05,_vystep=0.19;

void setup(){
  size(640,480);
  background(0);
  _r=0;
  _g=255;
  _b=0;
  _o=128;
  stroke(_r,_g,_b,_o);
  _x=width/2-50;
  _y=height/2-50;
  _xx=_x;
  _yy=_y;
  _ar=1;
  _ag=1;
  _ab=-1;
  String[] lines=loadStrings("cfg_00.txt");
  String[] vxlims=lines[0].split(" ");
  String[] vylims=lines[1].split(" ");
  String[] vxysteps=lines[2].split(" ");
  _lvx=Double.parseDouble(vxlims[0]);
  _uvx=Double.parseDouble(vxlims[1]);
  _lvy=Double.parseDouble(vylims[0]);
  _uvy=Double.parseDouble(vylims[1]);
  _vxstep=Double.parseDouble(vxysteps[0]);
  _vystep=Double.parseDouble(vxysteps[1]);
  println("vxlims: ",_lvx,_uvx);
  println("vylims: ",_lvy,_uvy);
  println("vsteps: ",_vxstep,_vystep);
}

void updatecolor(){
  _r+=_ar;
  _g+=_ag;
  _b+=_ab;
  stroke(_r,_g,_b,_o);
}

void updatespeed(){
  if(_vx>_uvx){ _vxdir=-1;}
  if(_vx<_lvx){ _vxdir=1; }
  if(_vy>_uvy){ _vydir=-1;}
  if(_vy<_lvy){ _vydir=1; }
  _vx+=_vxdir*_vxstep;
  _vy+=_vydir*_vystep;
  //println("["+_vx+","+_vy+"]");
}

void draw(){
  //saveFrame("output/linegame_####.png");
  if(_x>width){    _x=10;_xx=_x;        }
  if(_y>height){   _y=10;_yy=_y;        }
  if(_x<0){        _x=width-10;_xx=_x;  }
  if(_y<0){        _y=height-10;_yy=_y; }
  if(_r<0){        _r=255;       }
  if(_g<0){        _g=255;       }
  if(_b<0){        _b=255;       }
  if(_r>255){      _r=0;         }
  if(_g>255){      _g=0;         }
  if(_b>255){      _b=0;         }
  //updatecolor();
  updatespeed();
  //point(_x,_y);
  _xx+=_vx;
  _yy+=_vy;
  line((float)_x,(float)_y,(float)_xx,(float)_yy);
  _x=_xx;
  _y=_yy;
}
