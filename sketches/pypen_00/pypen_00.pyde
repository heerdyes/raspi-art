class Pen:
    def __init__(self,x=200,y=150):
        self.x=x
        self.y=y
        self.angle=0.0
        self.pendown=True
        self.rgba=[1.0,1.0,1.0,1.0]
    
    def fd(self,r):
        x2=self.x+r*cos(radians(self.angle))
        y2=self.y+r*sin(radians(-self.angle))
        if self.pendown:
            line(self.x,self.y,x2,y2)
        self.x=x2
        self.y=y2
    
    def bk(self,r):
        fd(-r)
    
    def lt(self,a):
        self.angle+=a
    
    def rt(self,a):
        lt(-a)
    
    def pu(self):
        self.pendown=false
    
    def pd(self):
        self.pendown=true
    
    def up(self):
        pu()
    
    def down(self):
        pd()
    
    def seth(self,a):
        self.angle=a
    
    def pencolor(self,frgba):
        self.rgba=frgba
        stroke(self.rgba[0],self.rgba[1],self.rgba[2],self.rgba[3])
    
    def movexy(self,x,y):
        oldangle=self.angle
        self.pu()
        self.seth(0.0)
        self.fd(x)
        self.lt(90.0)
        self.fd(y)
        self.pd()
        self.seth(oldangle)
    

# globals #
jump=1
turn=1
ctr=0
p=Pen()

def setup():
    size(800,600)
    smooth()
    colorMode(RGB,1.0)
    background(0)
    p.x=width/2
    p.y=height/2
    p.pencolor([0.5,1.0,0.2,1.0])

def draw():
    for i in range(4):
        p.fd(50)
        p.lt(90)
    p.lt(3)
