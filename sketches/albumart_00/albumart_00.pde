PImage img;

void setup() {
  //size(4608,3456);
  size(1280, 720);
  //img=loadImage("realcloud.jpg");
  imageMode(CENTER);
  stroke(255, 255, 255, 50);
  background(0);
  //image(img,975/2,180/2);
  //image(img,4608/2,3456/2);
}

float t=0f;
//int cx=4608/2,cy=3456/2;
int cx=1280/2, cy=720/2;
//float r=3456/2;
float r=720/2;

void spiral00() {
  for (int i=0; i<180; i++) {
    float erx=r*exp(-0.025*t);
    point(cx+erx*cos(t), cy-erx*sin(t));
    t+=0.01;
  }
}

void spiral01() {
  for (int i=0; i<180; i++) {
    float erx=abs(0.6*r-i);
    point(cx+erx*cos(t), cy-erx*sin(t));
    t+=0.01;
  }
}

void spiral02() {
  for (int i=0; i<180; i++) {
    float w=1*PI;
    float d=exp(-0.0125*t);
    float erx=1.00*d*r*sin(w*t);
    point(cx+erx*cos(t), cy-erx*sin(t));
    t+=0.01;
  }
}

void spiral03() {
  for (int i=0; i<360; i++) {
    float w=10+1*cos(2*t);
    float d=exp(-0.0125*t);
    float erx=0.8*d*r*sin(w*t);
    float x1=cx+erx*cos(t);
    float y1=cy-erx*sin(t);
    point(x1, y1);
    t+=0.001;
  }
}

void spiral04() {
  for (int i=0; i<960; i++) {
    float w=10+1.0*cos(2.0*t);
    float d=exp(-0.015*t);
    float erx=1.0*d*r*sin(w*t);
    float x1=cx+erx*cos((w*3+1.0*d)*t);
    float y1=cy-erx*sin(w*5*t);
    point(x1, y1);
    t+=0.0005;
  }
}

void spiral05() {
  for (int i=0; i<720; i++) {
    float w=10+1*cos(2*t);
    float d=exp(-0.0125*t);
    float erx=d*r*sin(w*t);
    float m=1, n=1;
    float p=1.0, q=5.0;
    if (i%1==0) {
      m*=-1;
      p/=2;
    }
    if (i%2==0) {
      n*=-1;
      n/=2;
    }
    if (i%4==0) {
      erx*=1.02;
    }
    float x1=cx+erx*cos(t-m*p*sin(w));
    float y1=cy-erx*sin(t+n*q*sin(w));
    point(x1, y1);
    t+=0.0005;
  }
}

void spiral06() {
  for (int i=0; i<720; i++) {
    float w=10+1*cos(2*t);
    float d=exp(-0.0125*t);
    float erx=d*r*sin(w*t);
    float m=1, n=1;
    float p=1.0, q=5.0;
    if (i%1==0) {
      m*=-1;
      p/=2;
    }
    if (i%2==0) {
      n*=-1;
      n/=2;
    }
    if (i%4==0) {
      erx*=1.02;
    }
    float x1=cx+erx*cos(t-m*p*sin(w));
    float y1=cy-erx*sin(t+n*q*sin(w));
    point(x1, y1);
    if (i%200==0) {
      fill(0, 0, 0, 5);
      rect(0, 0, 1280, 720);
    }
    t+=0.0005;
  }
}

void draw() {
  spiral06();
}

String rndstr(int n) {
  StringBuffer sb=new StringBuffer();
  for (int i=0; i<n; i++) {
    char rc=(char)int(random(65, 90.1));
    sb.append(rc);
  }
  return sb.toString();
}

void mousePressed() {
  String fn="img/coverart_"+rndstr(8)+".png";
  println("saving to file: "+fn);
  save(fn);
  println("clearing screen...");
  background(0);
  println("resetting time...");
  t=0.0;
}
