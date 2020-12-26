public class BLocDim{
  float[] xy;
  float[] wh;
  
  BLocDim(float[] xy,float[] wh){
    this.xy=xy;
    this.wh=wh;
  }
  
  BLocDim(float x,float y,float w,float h){
    this.xy=new float[]{x,y};
    this.wh=new float[]{w,h};
  }
}

public interface BClickable{
  void handleClick(int mx,int my);
}

public class BBox implements BClickable{
  BLocDim xywh;
  
  BBox(BLocDim xywh){
    this.xywh=xywh;
  }
  
  float getx(){return xywh.xy[0];}
  float gety(){return xywh.xy[1];}
  float getw(){return xywh.wh[0];}
  float geth(){return xywh.wh[1];}
  
  void render(){
    stroke(255);
    noFill();
    rect(getx(),gety(),getw(),geth());
  }
  
  void handleClick(int mx,int my){}
}


public class BSwitch extends BBox{
  boolean state;
  String label;
  
  BSwitch(BLocDim locdim,String label){
    super(locdim);
    state=false;
    this.label=label;
  }
  
  void on(){state=true;}
  void off(){state=false;}
  
  void render(){
    stroke(255);
    if(state){
      fill(255);
    }
    else{
      fill(0);
      rect(getx(),gety(),getw(),geth());
      noFill();
    }
    rect(getx(),gety(),getw(),geth());
    textAlign(LEFT,TOP);
    fill(255);
    text(label,getx(),gety()+geth());
  }
  
  void handleClick(int mx,int my){
    state=!state;
    render();
  }
}

public class BSwitchBoard extends BBox{
  float[] swh;
  float isd;
  float[] mlu;
  BSwitch[] switches;
  
  BSwitchBoard(int n,BLocDim xywh,float[] swh,float isd,float[] mlu,String prefix){
    super(xywh);
    this.swh=swh;
    this.isd=isd;
    this.mlu=mlu;
    switches=new BSwitch[n];
    for(int i=0;i<n;i++){
      float[] xy=new float[]{
        xywh.xy[0]+mlu[0]+(isd+swh[0])*i,
        xywh.xy[1]+mlu[1]
      };
      BLocDim swld=new BLocDim(xy,swh);
      switches[i]=new BSwitch(swld,prefix+(n-i-1));
    }
  }
  
  void render(){
    stroke(255);
    noFill();
    rect(getx(),gety(),getw(),geth());
    for(BSwitch bs:switches){
      bs.render();
    }
  }
  
  String bitstring(){
    StringBuffer sb=new StringBuffer();
    for(BSwitch b:switches){
      sb.append(b.state?"1":"0");
    }
    return sb.toString();
  }
  
  void handleClick(int mx,int my){
    float frac=swh[0]/(isd+swh[0]);
    float d=(mx-getx()-mlu[0])/(isd+swh[0]);
    if((d-floor(d))<frac && my>(gety()+mlu[1]) && my<(gety()+mlu[1]+swh[1])){
      switches[floor(d)].handleClick(mx,my);
      println(bitstring());
    }
  }
}

public class BClickManager{
  ArrayList<BBox> boxes;
  
  BClickManager(){
    boxes=new ArrayList<BBox>();
  }
  
  void registerBox(BBox b){
    boxes.add(b);
  }
  
  void percolateClicks(int mx,int my){
    for(BBox b:boxes){
      float ltx=b.getx();
      float lty=b.gety();
      float rbx=ltx+b.getw();
      float rby=lty+b.geth();
      if(mx>ltx&&mx<rbx&&my>lty&&my<rby){
        b.handleClick(mx,my);
      }
    }
  }
}
