RAM65536x8 ram;
BClickManager bcm;
BSwitchBoard baddr,bdata;

void setup(){
  size(900,600);
  stroke(255);
  background(0);
  ram=new RAM65536x8();
  bcm=new BClickManager();
  baddr=new BSwitchBoard(
      16,
      new BLocDim(30,30,522,50),
      new float[]{25,20},
      7.0,
      new float[]{8.0,8.0},
      "A");
  bcm.registerBox(baddr);
  baddr.render();
  bdata=new BSwitchBoard(
      8,
      new BLocDim(30,100,261,50),
      new float[]{25,20},
      7.0,
      new float[]{8.0,8.0},
      "D");
  bcm.registerBox(bdata);
  bdata.render();
}

void draw(){
  //
}

void mouseClicked(){
  bcm.percolateClicks(mouseX,mouseY);
}
