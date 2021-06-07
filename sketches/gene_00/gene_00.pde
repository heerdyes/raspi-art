int psize=150;
float mrate=0.01;
Popu p;
String target="heerdyesmahapatro";

void setup() {
  p=new Popu(psize, mrate, target);
  size(1280, 720);
  background(255);
  stroke(0);
  fill(0);
  textSize(12);
  //frameRate(8);
  
  // evolve gene pool
  // setup turtle swarm with above gene pool
}

void draw() {
  p.select();
  p.reproduce();
  p.display();
}
