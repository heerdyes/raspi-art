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
        self.pendown=False
    
    def pd(self):
        self.pendown=True
    
    def up(self):
        self.pu()
    
    def down(self):
        self.pd()
    
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
    
class SineOsc:
    def __init__(self,a=1,f=1,d=0.01,p=0):
        self.currval=0.0
        self.amplitude=float(a)
        self.frequency=float(f)
        self.timediv=float(d)
        self.phase=float(p)
        self.t=0.0
    
    def populate(self,a,f,d,p):
        self.currval=0.0
        self.amplitude=float(a)
        self.frequency=float(f)
        self.timediv=float(d)
        self.phase=float(p)
        self.t=0.0
        print('[SO] a=%f,f=%f,d=%f,p=%f'%(self.amplitude,self.frequency,self.timediv,self.phase))
    
    def update(self):
        self.currval=self.amplitude*sin(self.frequency*(self.t+self.phase))
        self.t+=self.timediv

# globals #
jump=1
turn=1
ctr=0
p=Pen()
fdo=SineOsc()
lto=SineOsc()
fprefix='__'
cfgpath='cfg/tmp.cfg'

# funxions #
def spin():
    for i in range(45):
        p.fd(fdo.currval)
        p.lt(lto.currval)
        fdo.update()
        lto.update()

# file io
def loadcfg(cfgfile):
    cfglines=loadStrings(cfgfile)
    rgba=cfglines[0].split(' ')
    fdl=cfglines[1].split(' ')
    ltl=cfglines[2].split(' ')
    nmxy=cfglines[3].split(' ')
    fprefix=nmxy[0]
    dx=float(nmxy[1])
    dy=float(nmxy[2])
    fdo.populate(fdl[0],fdl[1],fdl[2],fdl[3])
    lto.populate(ltl[0],ltl[1],ltl[2],ltl[3])
    p.x=(width/2)+dx
    p.y=(height/2)+dy
    p.seth(0.0)
    p.pencolor([float(rgba[0]),float(rgba[1]),float(rgba[2]),float(rgba[3])])

def setup():
    global fprefix
    size(800,600)
    smooth()
    colorMode(RGB,1.0)
    background(0)
    loadcfg(cfgpath);

def draw():
    spin()

def mouseClicked():
    print('snapping a frame')
    saveFrame('rec/%s-####.png'%fprefix)

def keyReleased():
    if key=='c':
        print('clearing screen!')
        background(0)
    if key=='r':
        print('reloading!')
        loadcfg(cfgpath)
    if key=='R':
        print('clearing screen and reloading!')
        background(0)
        loadcfg(cfgpath)
