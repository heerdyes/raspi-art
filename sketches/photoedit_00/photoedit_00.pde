PImage img,outimg;
String srcflnm,outflnm;
String[] cfglines;

void setup(){
  size(1000,750);
  background(0);
  stroke(0,200,0);
  line(width/2,0,width/2,height);
  cfglines=loadStrings("resize.cfg");
  String[] l1=cfglines[0].split(" ");
  srcflnm=l1[0];
  outflnm=l1[1];
  img=loadImage(srcflnm);
  println(String.format("src img w:%d, h:%d",img.width,img.height));
  println("src aspect ratio, w:h = "+img.width+":"+img.height+" = "+float(img.width)/float(img.height));
  String[] l2=cfglines[1].split(" ");
  if(!l2[0].equals("scale")){
    throw new RuntimeException("expected scale header at line 2!");
  }
  float sf=float(l2[1]);
  image(img,0,0,img.width*sf,img.height*sf);
  for(int i=2;i<cfglines.length;i++){
    if(cfglines[i].startsWith("#")){
      continue;
    }
    String[] twh=cfglines[i].split(" ");
    String cmd=twh[0];
    if(cmd.equals("resize")){
      int tw=int(twh[0]);
      int th=int(twh[1]);
      println("resizing w:"+tw+", h:"+th);
      img.resize(tw,th);
    }else if(cmd.equals("crop")){
      int x0=int(twh[1]);
      int y0=int(twh[2]);
      int x1=int(twh[3]);
      int y1=int(twh[4]);
      img=get(x0,y0,x1,y1);
    }else if(cmd.equals("rotate")){
      println("TODO rotation");
    }
  }
  image(img,width/2+5,0);
}

void draw(){}

void mouseClicked(){
  outimg=createImage(img.width,img.height,RGB);
  println("saving new image, w:"+img.width+",h:"+img.height);
  outimg=img.get();
  outimg.save(outflnm);
}

void keyPressed(){
  if(key=='q'){
    exit();
  }
}

