# simplest fractal root
mainwhorl=None

# the binary root that grows
class Root:
    def __init__(self,x,y,r,br,a,ba):
        self.x=x
        self.y=y
        self.r=r
        self.br=br
        self.lim=1.0
        self.a=a
        self.ba=ba
        self.ltroot=None
        self.rtroot=None
    
    def grow(self):
        if self.r<self.lim:
            return
        x1=self.x+self.r*cos(self.a)
        y1=self.y-self.r*sin(self.a)
        line(self.x,self.y,x1,y1)
        self.ltroot=Root(x1,y1,self.br*self.r,self.br,self.a+self.ba,self.ba)
        self.rtroot=Root(x1,y1,self.br*self.r,self.br,self.a-self.ba,self.ba)
        self.ltroot.grow()
        self.rtroot.grow()


class Whorl:
    def __init__(self,x,y,n,di,fr,fa):
        self.roots=[]
        self.angle=2*PI/n
        for i in range(n):
            self.roots.append(Root(x,y,di,fr,i*self.angle,fa))
    
    def proliferate(self):
        for root in self.roots:
            root.grow()
    

def setup():
    global mainwhorl
    size(900,900)
    background(0)
    stroke(255,255,255,40)
    noFill()
    smooth()
    mainwhorl=Whorl(width/2,height/2,3,130,0.73,PI/3)
    #mainwhorl=Whorl(width/2,height/2,6,130,0.72,PI/3)
    mainwhorl.proliferate()

def draw():
    pass

def keyPressed():
    if key=='q':
        print('bye!')
        exit()
