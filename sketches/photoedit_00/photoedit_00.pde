PImage img,outimg;
String srcflnm,outflnm;
String[] cfglines;

void setup(){
  size(1000,750);
  background(0);
  stroke(0,200,0);
  line(width/2,0,width/2,height);
  cfglines=loadStrings("resize.cfg");
  String[] parts=cfglines[0].split(" ");
  srcflnm=parts[0];
  outflnm=parts[1];
  img=loadImage(srcflnm);
  println(String.format("src img w:%d, h:%d",img.width,img.height));
  println("src aspect ratio, w:h = "+img.width+":"+img.height+" = "+float(img.width)/float(img.height));
  image(img,0,0);
  for(int i=1;i<cfglines.length;i++){
    String[] twh=cfglines[i].split(" ");
    int tw=int(twh[0]);
    int th=int(twh[1]);
    println("resizing w:"+tw+", h:"+th);
    img.resize(tw,th);
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
