Turtlebot recipe00() {
  PGraphics tg=createGraphics(1000, 1000);
  x=new Turtlebot(new Turtle(tg), 40f, 120f);
  x.steplfo.updateamountLFO(12, 2.0, 0);
  x.steplfo.updatefrequency(0.15);
  x.steplfo.updatephase(0);
  x.turnlfo.updateamount(0);
  x.turnlfo.updatefrequency(0);
  x.turnlfo.updatephase(0);
  x.tcolor(0, 0, 64, 30);
  return x;
}

Turtlebot recipe01() {
  PGraphics tg=createGraphics(2000, 2000);
  x=new Turtlebot(new Turtle(tg), 60f, 120f);
  x.steplfo.updateamountLFO(12, 2.4, 0);
  x.steplfo.updatefrequency(0.15);
  x.steplfo.updatephase(0.05);
  x.turnlfo.updateamount(0);
  x.turnlfo.updatefrequency(0);
  x.turnlfo.updatephase(0);
  x.tcolor(202, 0, 64, 30);
  return x;
}

Turtlebot recipe02() {
  PGraphics tg=createGraphics(3000, 3000);
  x=new Turtlebot(new Turtle(tg), 1f, 120f);
  x.steplfo.updateamountLFO(12, 2.4, 0);
  x.steplfo.updatefrequency(0.15);
  x.steplfo.updatephase(0);
  x.turnlfo.updateamountLFO(1, 0.8, 0);
  x.turnlfo.updatefrequency(0.5);
  x.turnlfo.updatephase(0);
  x.tcolor(202, 0, 64, 30);
  return x;
}

Turtlebot recipe() {
  PGraphics tg=createGraphics(1570, 1320);
  float[][] fdmat=new float[][]{
    {10.0, 0.0, -0.01}, 
    {1.0, 0.0, 0.0}, 
    {0.0, 1.0, 0.0}
  };
  float[][] ltmat=new float[][]{
    {5.0, 0.0, 0.0}, 
    {1.0, 0.0, 0.0}, 
    {0.0, 1.0, 0.0}
  };
  x=new Turtlebot(new Turtle(tg), fdmat, ltmat);
  x.steplfo.updateamount(0.0);
  x.steplfo.updatefrequency(0.0);
  x.steplfo.updatephase(0.0);
  x.turnlfo.updateamount(0.0);
  x.turnlfo.updatefrequency(0.0);
  x.turnlfo.updatephase(0.0);
  x.tcolor(16, 32, 255, 30);
  return x;
}
