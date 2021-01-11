class LShell{
  int x,y,w,h;
  String name;
  color c;
  ArrayList<StringBuffer> buf;
  int currln,currcol;
  float cgap,lgap;
  PFont font;
  
  LShell(int x,int y,int w,int h,color c){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.c=c;
    buf=new ArrayList<StringBuffer>();
    name="L";
    currln=0;
    lgap=14.0;
    cgap=10.0;
    currcol=0;
    font=createFont("assets/ocr-a_regular.ttf",14);
  }
  
  void render(){
    // wipe area first
    fill(0);
    noStroke();
    rect(this.x,this.y,this.w,this.h);
    // now paint contents
    stroke(c);
    line(this.x,this.y,this.x+this.w,this.y);
    textSize(14);
    textAlign(LEFT,TOP);
    textFont(font);
    fill(c);
    for(int i=0;i<buf.size();i++){
      StringBuffer line=buf.get(i);
      float h=this.y+i*lgap;
      text("["+name+"] ",this.x,h);
      for(int j=0;j<line.length();j++){
        text(line.charAt(j),this.x+cgap*j,h);
      }
    }
  }
  
  void sensekey(){
    if(keyCode==10){
      buf.add(new StringBuffer(""));
      currln+=1;
      currcol=0;
      render();
    }else{
      text(key,this.x+cgap*currcol,this.y+currln*lgap);
      currcol+=1;
    }
    println(keyCode);
  }
}
