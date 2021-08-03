import javax.sound.sampled.*;
import java.io.*;

String sketchpath="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/wavsyn_00";
int samplerate=44100;
String wavfilename="sine.wav";

void setup() {
  size(1600, 900);
  background(0);
  stroke(128);
  textAlign(CENTER, CENTER);
  textSize(24);
}

void draw() {
}

void stat(String s) {
  background(0);
  text(s, width/2, height/2);
}

void keyPressed() {
  if (key=='r') {
    try {
      stat("playing waveform...");
      String cmd=String.format("aplay %s/%s", sketchpath, wavfilename);
      println("[exec] "+cmd);
      Runtime.getRuntime().exec(cmd);
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  } else if (key=='g') {
    stat("generating waveform...");
    savepatch(synthpcm(samplerate, 240), wavfilename);
    stat("done");
  } else if (key=='l') {
    stat("loading puresine.wav");
    loadpatch(new File(sketchpath+"/sine.wav"));
  }
}
