class T{
  int x,y;
  char d;
  char[][] grid;
  
  char shape(){
    if(d=='n'){return '^';}
    else if(d=='w'){return '<';}
    else if(d=='e'){return '>';}
    else if(d=='s'){return 'v';}
    return '.';
  }
  
  T(char[][] grid){
    this.grid=grid;
    y=grid.length/2;
    x=grid[0].length/2;
    d='n';
  }
  
  void fd(int s){
    if(s>1){
      fd(s-1);
    }
    if(d=='n'){y=y-1;}
    else if(d=='s'){y=y+1;}
    else if(d=='e'){x=x+1;}
    else if(d=='w'){x=x-1;}
    render();
  }
  
  void lt(){
    if(d=='n'){d='w';}
    else if(d=='s'){d='e';}
    else if(d=='e'){d='n';}
    else if(d=='w'){d='s';}
  }
  
  void rt(){
    if(d=='n'){d='e';}
    else if(d=='s'){d='w';}
    else if(d=='e'){d='s';}
    else if(d=='w'){d='n';}
  }
  
  int abs(int a){
    return a>=0?a:-a;
  }
  
  void render(){
    if(x<0){x=abs(x)%grid[0].length;}
    if(y<0){y=abs(y)%grid.length;}
    if(x>=grid[0].length){x=x%grid[0].length;}
    if(y>=grid.length){y=y%grid.length;}
    grid[y][x]=shape();
  }
}
