import beads.*;
import org.jaudiolibs.beads.*;

class Bouncer{
  public float x=10.0;
  public float y=10.0;
  float xspeed=1.0;
  float yspeed=1.0;
  
  Bouncer(){}
  
  void move(){
    x+=xspeed;
    if(x<=0){xspeed=1.0;}
    else if(x>=width-10){xspeed=-1.0;}
    
    y+=yspeed;
    if(y<=0){yspeed=1.0;}
    else if(y>=height-10){yspeed=-1.0;}
  }
  
  void draw(){
    noStroke();
    fill(255);
    ellipse(x,y,10,10);
  }
}

AudioContext ac;
float bf=200.0f;
int sc=10;
Gain gains[];
Glide freqs[];
WavePlayer tones[];
Gain mgain;
Bouncer b;

void setup(){
  size(400,300);
  b=new Bouncer();
  ac=new AudioContext();
  
  mgain=new Gain(ac,1,0.5);
  ac.out.addInput(mgain);
  
  freqs=new Glide[sc];
  tones=new WavePlayer[sc];
  gains=new Gain[sc];
  
  float currgain=1.0f;
  for(int i=0;i<sc;i++){
    freqs[i]=new Glide(ac,bf*(i+1),30);
    tones[i]=new WavePlayer(ac,freqs[i],Buffer.SINE);
    gains[i]=new Gain(ac,1,currgain);
    gains[i].addInput(tones[i]);
    mgain.addInput(gains[i]);
    currgain-=(1.0/float(sc));
  }
  
  ac.start();
  
  background(0);
  text("additive synth: bouncing drawbars!",100,100);
}

void draw(){
  background(0);
  b.move();
  b.draw();
  bf=20.0f+b.x;
  for(int i=0;i<sc;i++){
    freqs[i].setValue(bf*float(i+10)*(b.y/height));
  }
}
