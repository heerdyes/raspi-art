import beads.*;
AudioContext ac;

WavePlayer modulator;
Glide modulatorFrequency;
WavePlayer carrier;

Gain g;

void setup(){
  size(400,300);
  ac=new AudioContext();
  modulatorFrequency=new Glide(ac,20,30);
  modulator=new WavePlayer(ac,modulatorFrequency,Buffer.SINE);
  // mod fn
  Function frequencyModulation=new Function(modulator){
    public float calculate(){
      return (x[0]*200.0)+mouseY;
    }
  };
  // fm carrier
  carrier=new WavePlayer(ac,frequencyModulation,Buffer.SINE);
  g=new Gain(ac,1,0.5);
  g.addInput(carrier);
  ac.out.addInput(g);
  ac.start();
}

void draw(){
  modulatorFrequency.setValue(mouseX);
}
