let t=0.0;
let scope;
let bgColor='#101010';

// use inheritance later...
class CPSwitch{
  constructor(x,y,w,h){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.d=4;
    this.state=false;
  }
  
  render(){
    fill(0);
    rect(this.x,this.y,this.w,this.h);
    if(this.state){
      fill(0,240,0);
      rect(this.x+this.d,this.y+this.d,this.w-2*this.d,this.h-2*this.d);
    }
  }
}

class CPSwitchBoard{
  constructor(x,y,w,h){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }
}

class SignalBuffer{
  constructor(n,sf,c,lbl){
    this.lbl=lbl;
    this.n=n;
    this.c=c;
    this.tbuf=[];
    this.sf=sf;
  }
  
  feedinput(v){
    if(this.tbuf.length>this.n){
      this.tbuf.shift();
    }
    this.tbuf.push(v);
  }
}

class Oscilloscope{
  constructor(x,y,w,h,cs,sfs,sn){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.cs=cs;
    this.ns=cs.length;
    this.n=floor(0.75*w);
    this.sbuf=[];
    for(let i=0;i<this.ns;i++){
      this.sbuf[i]=new SignalBuffer(this.n,sfs[i],cs[i],sn[i]);
    }
  }
  
  feedsignal(vs){
    if(vs.length!=this.ns){
      console.log("need array of length: "+this.n);
      console.log("doing nothing!");
      return;
    }
    for(let i=0;i<this.ns;i++){
      this.sbuf[i].feedinput(vs[i]);
    }
    this.render();
  }
  
  wipe(){
    fill(bgColor);
    noStroke();
    rect(this.x-this.w/2,this.y-this.h/2,this.w,this.h);
  }
  
  showinfopanel(){
    stroke(0,255,0);
    line(0.28*this.w,-this.h/2,0.28*this.w,this.h/2);
    noStroke();
    for(let i=0;i<this.sbuf.length;i++){
      let sb=this.sbuf[i];
      fill(sb.c);
      rect(0.3*this.w,-0.1*(i+1)*this.h,30,10);
      textAlign(LEFT,TOP);
      text(sb.lbl,0.38*this.w,-0.1*(i+1)*this.h);
    }
  }
  
  render(){
    push();
    translate(width/2,height/2);
    this.wipe();
    noFill();
    stroke(0,255,0);
    rect(this.x-this.w/2,this.y-this.h/2,this.w,this.h);
    this.showinfopanel();
    for(let k=0;k<this.sbuf.length;k++){
      let sb=this.sbuf[k];
      stroke(sb.c);
      for(let i=0;i<sb.tbuf.length;i++){
        let sv=sb.tbuf[i]*sb.sf;
        point(-this.w/2+i,this.y-sv);
      }
    }
    pop();
  }
}

function setup(){
  createCanvas(900,600);
  scope=new Oscilloscope(
      0,0,width/2,height/2,
      ['#00f0b0','#f00000','#f0f000'],
      [1.0,1.0,1.0],
      ['sine','cosine','tangent']);
  background(0);
}

function draw(){
  let fn1=map(mouseX,0,width,0,20)*sin(5*t);
  let fn2=25*cos(map(mouseY,0,height,3,9)*t);
  let fn3=tan(t);
  scope.feedsignal([fn1,fn2,fn3]);
  t+=0.05;
}

function mousePressed(){
  //
}
