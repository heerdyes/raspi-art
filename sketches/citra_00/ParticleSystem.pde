import java.util.ArrayList;
import java.awt.Graphics2D;

class ParticleSystem{
  double w,h,f;
  int n,dn;
  ArrayList<Particle> swarm;
  
  ParticleSystem(double w,double h,int n,int dn,double f){
    this.w=w;
    this.h=h;
    this.n=n;
    this.dn=dn;
    this.f=f;
    swarm=new ArrayList<Particle>();
  }
  
  int nlim(double t){
    return (int)Math.round(n+dn*Math.sin(f*t));
  }
  
  void add(Particle p,double t){
    if(swarm.size()>nlim(t)){
      swarm.remove(0);
    }
    swarm.add(p);
  }
  
  void render(double t,Graphics2D g){
    for(Particle p:swarm){
      p.render(g);
      p.blip(t,w,h);
    }
  }
  
  void render(double t,PGraphics g){
    for(Particle p:swarm){
      p.render(g);
      p.blip(t,w,h);
    }
  }
}

