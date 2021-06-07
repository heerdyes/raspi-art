import java.util.concurrent.ThreadLocalRandom;

class ParticleGenerator{
  double cx,cy,mm;
  
  ParticleGenerator(double cx,double cy,double mm){
    this.cx=cx;
    this.cy=cy;
    this.mm=mm;
  }
  
  Particle pgen(double t){
    double vx=ThreadLocalRandom.current().nextDouble(-mm,mm);
    double vy=ThreadLocalRandom.current().nextDouble(-mm,mm);
    double pr=ThreadLocalRandom.current().nextDouble(0.0,100.0);
    double rr=1.0;
    if(pr<10.0){
      rr=ThreadLocalRandom.current().nextDouble(1.0,4.0);
    }
    return new Particle(cx,cy,rr,1.0,new Vector2(vx,vy));
  }
}

