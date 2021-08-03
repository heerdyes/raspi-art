byte[] synthpcm(int sr, float f) {
  byte[] pcm_data=new byte[sr*2];
  float L1=((float)sr)/f;

  for (int i=0; i<pcm_data.length; i++) {
    float omega=i/L1;
    pcm_data[i]=(byte)(30*sin(omega*PI*2));
    pcm_data[i]+=(byte)(15*sin(2*omega*PI*2));
  }
  return pcm_data;
}

short[] mkwave(int sr, float f) {
  short[] data=new short[sr*2];
  float L1=((float)sr)/f;

  for (int i=0; i<data.length; i++) {
    float omega=i/L1;
    data[i]=(short)(30*sin(omega*PI*2));
    data[i]+=(short)(15*sin(2*omega*PI*2));
  }
  return data;
}

void savepatch(byte[] pcm_data, String fn) {
  AudioFormat af=new AudioFormat(samplerate, 8, 1, true, true);
  ByteArrayInputStream bais=new ByteArrayInputStream(pcm_data);
  int nbuf=pcm_data.length/af.getFrameSize();
  AudioInputStream ais=new AudioInputStream(bais, af, nbuf);

  try {
    File fwav=new File(sketchpath+"/"+fn);
    AudioSystem.write(ais, AudioFileFormat.Type.WAVE, fwav);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

void displayaudio(byte[] ab) {
  for (int i=0; i<ab.length; i++) {
    point(map(i, 0, ab.length, 0, width), map(ab[i], 127, -128, 0, height));
  }
}

void readwavstream(AudioInputStream ais, int nbytes, int bpf) {
  int totalframesread=0;
  byte[] audiobytes=new byte[nbytes];
  try {
    int nbytesread=0;
    int nframesread=0;
    while ((nbytesread=ais.read(audiobytes))!=-1) {
      nframesread=nbytesread/bpf;
      totalframesread+=nframesread;
      // do something with audiobytes
      displayaudio(audiobytes);
    }
    println(totalframesread);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

void loadpatch(File fin) {
  try {
    AudioInputStream ais=AudioSystem.getAudioInputStream(fin);
    int bytesperframe=ais.getFormat().getFrameSize();
    if (bytesperframe==AudioSystem.NOT_SPECIFIED) {
      bytesperframe=1;
    }

    int nbytes=1024*bytesperframe;
    readwavstream(ais, nbytes, bytesperframe);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}
