class Turtle:
    def __init__(self,x,y,a,c,r):
        self.x=x
        self.y=y
        self.a=a
        self.c=c
        self.r=r
        self.penup=False
        
    def fd(self,r):
        stroke(self.c)
        x1,y1=self.x,self.y
        x2=self.x+r*cos(self.a)
        y2=self.y-r*sin(self.a)
        if self.r.contains(x2,y2):
            self.x,self.y=x2,y2
            if not self.penup:
                line(x1,y1,x2,y2)
        
    def bk(self,r):
        self.fd(-r)
    
    def lt(self,theta):
        self.a+=radians(theta)
    
    def rt(self,theta):
        self.lt(-theta)
        
    def pu(self):
        self.penup=True
    
    def pd(self):
        self.penup=False
    

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


class TWave:
    def __init__(self,pen,amp,freq,dt):
        self.A=amp
        self.F=freq
        self.pen=pen
        self.t=0.0
        self.dt=dt
        self.pendown=True
        
    def grow(self):
        self.pen.pu()
        self.pen.fd(2)
        self.pen.pd()
        if self.pendown:
            self.pen.lt(90)
            amp=self.A*sin(self.F*self.t)+0.5*self.A*sin(2*self.F*self.t)+0.25*self.A*cos(3*self.F*self.t)
            self.pen.fd(amp)
            self.pen.bk(amp)
            self.pen.rt(90)
        self.t+=self.dt
    
    def pu(self):
        self.pendown=False
    
    def pd(self):
        self.pendown=True
    
    def bk(self,x):
        self.pen.bk(2*x)


class DNAWave:
    def __init__(self,tw1,tw2,f,a,t):
        self.tw1=tw1
        self.tw2=tw2
        self.F=f
        self.A=a
        self.t=t
        
    def grow(self):
        self.tw1.grow()
        self.tw2.grow()
        turn=self.A*sin(self.F*self.t)
        self.tw1.pen.lt(turn)
        self.tw2.pen.lt(turn)
        self.t+=0.05


class BiWaveTurtle:
    def __init__(self,tw1,tw2):
        self.tw1=tw1
        self.tw2=tw2
        
    def fd(self,x):
        for i in range(x):
            self.tw1.grow()
            self.tw2.grow()

    def lt(self,a):
        self.tw1.pen.lt(a)
        self.tw2.pen.lt(a)
    
    def rt(self,a):
        self.lt(-a)
        
    def bk(self,x):
        self.tw1.bk(x)
        self.tw2.bk(x)
    
    def pu(self):
        self.tw1.pu()
        self.tw2.pu()
        
    def pd(self):
        self.tw1.pd()
        self.tw2.pd()
