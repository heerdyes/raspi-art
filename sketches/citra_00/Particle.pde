import java.awt.Graphics2D;
import java.util.concurrent.ThreadLocalRandom;
import java.awt.Color;

class Particle{
  double x,y,r,m;
  Vector2 v;
  
  Particle(double x,double y,double r,double m,Vector2 v){
    this.x=x;
    this.y=y;
    this.r=r;
    this.m=m;
    this.v=v;
  }
  
  void blip(double t,double w,double h){
    double rndcent=ThreadLocalRandom.current().nextDouble(0.0,1000.0);
    if(rndcent>111.0 && rndcent<111.1){
      this.x=Math.random()*w;
      this.y=Math.random()*h;
    }else if(rndcent>500.0){
      this.x+=this.v.x;
      this.y+=this.v.y;
      v.plus((new Vector2(-v.y,v.x)).normalized());
    }else{
      v.mul(0.985);
    }
  }
  
  void render(Graphics2D g){
    int ix=(int)Math.round(x);
    int iy=(int)Math.round(y);
    int ir=(int)Math.round(r);
    //int a=ir==0?255:(int)Math.round(128.0/ir);
    g.setColor(new Color(24,202,230,128));
    g.fillOval(ix,iy,ir,ir);
  }
  
  void render(PGraphics g){
    int ix=(int)Math.round(x);
    int iy=(int)Math.round(y);
    int ir=(int)Math.round(r);
    //int a=ir==0?255:(int)Math.round(128.0/ir);
    float fa=ir==0?255.0:(float)(128.0/r);
    //g.stroke(24,202,230,128);
    g.noStroke();
    g.fill(24,202,230,fa);
    //g.circle(ix,iy,ir);
    g.circle((float)x,(float)y,(float)r);
  }
}

