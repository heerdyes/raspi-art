import beads.*;
import org.jaudiolibs.beads.*;

AudioContext ac;
Gain g;
Glide fg1,fg2;
WavePlayer wp1,wp2;

void setup(){
  size(400,300);
  ac=new AudioContext();
  
  fg1=new Glide(ac,40.0,50);
  wp1=new WavePlayer(ac,fg1,Buffer.SINE);
  
  fg2=new Glide(ac,40.0,50);
  wp2=new WavePlayer(ac,fg2,Buffer.SINE);
  
  g=new Gain(ac,1,0.5);
  g.addInput(wp1);
  g.addInput(wp2);
  
  ac.out.addInput(g);
  ac.start();
  
  background(0);
  text("mouse x controls gain!",100,100);
  text("mouse y controls freq!",100,120);
}

void draw(){
  fg1.setValue(2*(mouseY+40));
  fg2.setValue(3*(mouseX+40));
}
