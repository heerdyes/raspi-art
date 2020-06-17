int[] dx=new int[]{-2,1,2,1,-2,1,0,1};
int[] dy=new int[]{2,1,0,-2,-1,1,0,2};

// --- function space --- //
void bmtree(int x,int y,int len,int dir){
  int xnew,ynew;
  if(dir<0){dir=dir+8;}
  if(dir>=8){dir=dir-8;}
  xnew=x+len*dx[dir];
  ynew=y+len*dy[dir];
  line(x,y,xnew,ynew);
  if(len>0){
    bmtree(xnew,ynew,len-1,dir-1);
    bmtree(xnew,ynew,len-1,dir+1);
  }
}

int safeinc(int p,int step,int min,int max){
  int tmp=p+step;
  if(tmp>max){tmp=min;}
  if(tmp<min){tmp=max;}
  return tmp;
}

void mutategenes(){
  for(int i=0;i<dx.length;i++){
    dx[i]=safeinc(dx[i],1,-3,3);
    dy[i]=safeinc(dy[i],-1,-3,3);
  }
}

String dumparr(int[] arr){
  StringBuffer x=new StringBuffer();
  x.append("[ ");
  for(int i=0;i<arr.length;i++){
    x.append(arr[i]+" ");
  }
  x.append("]");
  return x.toString();
}

// --- processing specific functions --- //
void setup(){
  size(800,600);
  background(0);
  stroke(0,220,0);
  smooth();
}

void draw(){
  background(0);
  println("dx: "+dumparr(dx));
  println("dy: "+dumparr(dy));
  bmtree(width/2,height/2,12,1);
  mutategenes();
}
