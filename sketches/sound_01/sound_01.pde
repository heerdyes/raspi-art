import beads.*;
import org.jaudiolibs.beads.*;

AudioContext ac;
Gain g;
Glide gg,fg;
WavePlayer wp;

void setup(){
  size(400,300);
  ac=new AudioContext();
  
  gg=new Glide(ac,0.0,50);
  fg=new Glide(ac,40.0,50);
  
  wp=new WavePlayer(ac,fg,Buffer.SINE);
  
  g=new Gain(ac,1,gg);
  g.addInput(wp);
  
  ac.out.addInput(g);
  ac.start();
  
  background(0);
  text("mouse x controls gain!",100,100);
  text("mouse y controls freq!",100,120);
}

void draw(){
  gg.setValue(mouseX/float(width));
  fg.setValue(2*(mouseY+40));
}
