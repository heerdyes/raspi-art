import supercollider.*;
import oscP5.*;
import netP5.*;

Synth synth;
float f=80.0;

void setup ()
{
    size(800, 200);

    // uses default sc server at 127.0.0.1:57110    
    // does NOT create synth!
    synth = new Synth("sine");
    
    // set initial arguments
    synth.set("amp", 0.5);
    synth.set("freq", 40);
    
    // create synth
    synth.create();
}

void draw ()
{
    background(0);
    stroke(255);
    line(mouseX, 0, mouseX, height);
}

void mouseMoved ()
{
    synth.set("freq",f+map(mouseX,0,width,0,300));
    synth.set("amp",map(mouseY,0,height,0,0.99));
}

void exit ()
{
    synth.free();
    super.exit();
}
