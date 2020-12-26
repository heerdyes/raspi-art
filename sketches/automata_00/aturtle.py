class Turtle:
    def __init__(self,x,y,a,c,r):
        self.x=x
        self.y=y
        self.a=a
        self.c=c
        self.r=r
        
    def fd(self,r):
        stroke(self.c)
        x1,y1=self.x,self.y
        x2=self.x+r*cos(self.a)
        y2=self.y-r*sin(self.a)
        if self.r.contains(x2,y2):
            self.x,self.y=x2,y2
            line(x1,y1,x2,y2)
        
    def bk(self,r):
        self.fd(-r)
    
    def lt(self,theta):
        self.a+=radians(theta)
    
    def rt(self,theta):
        self.lt(-theta)
    

class Region:
    def __init__(self,x,y,w,h):
        self.x=x
        self.y=y
        self.w=w
        self.h=h
        
    def wipe(self):
        fill(0)
        stroke(128)
        rect(self.x,self.y,self.w,self.h)
        
    def contains(self,xx,yy):
        return xx>self.x and xx<(self.x+self.w) and yy>self.y and yy<(self.y+self.h)
