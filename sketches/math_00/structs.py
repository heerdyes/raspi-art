from arch import *

class Mem(Pub):
    def __init__(self):
        Pub.__init__(self)
        self.pd=False
        self.penmode=False
        self.linemode=False
        self.state=0
    
    def togglepenmode(self):
        self.penmode=not self.penmode
        self.publish(Msg('mem','penmode: %s'%self.penmode))
    
    def togglelinemode(self):
        self.linemode=not self.linemode
        self.publish(Msg('mem','linemode: %s'%self.linemode))


class Stationery(Pub):
    def __init__(self,parr):
        Pub.__init__(self)
        self.pens=parr
        self.curr=0
    
    def getpen(self):
        return self.pens[self.curr]
    
    def addpen(self,c):
        self.pens.append(Pen(c))
    
    def next(self):
        tmp=self.curr
        self.curr=(tmp+1)%len(self.pens)


class Pen(Pub):
    def __init__(self,c,nm):
        Pub.__init__(self)
        self.c=c
        self.dx=3
        self.dy=-3
        self.sw=1.0
        self.px=-1
        self.py=-1
        self.m=Mem()
        self.nm=nm
    
    def addsub(self,s):
        Pub.addsub(self,s)
        self.m.addsub(s)
    
    def paint(self):
        strokeWeight(self.sw)
        line(pmouseX,pmouseY,mouseX,mouseY)
        line(mouseX,mouseY,mouseX+self.dx,mouseY+self.dy)
    
    def pdot(self):
        strokeWeight(self.sw)
        line(pmouseX,pmouseY,mouseX,mouseY)
    
    def pline(self):
        if self.px==-1 or self.py==-1:
            return
        strokeWeight(self.sw)
        line(self.px,self.py,mouseX,mouseY)
    
    def savedot(self):
        self.px=mouseX
        self.py=mouseY
        self.publish(Msg('savedot','saved dot: (%d,%d)'%(self.px,self.py)))
        

class Statbar(Sub):
    def __init__(self,x,y,w,h,cf,cs):
        Sub.__init__(self,self.recv)
        self.x=x
        self.y=y
        self.w=w
        self.h=h
        self.cf=cf
        self.cs=cs
        self.sw=1
    
    def recv(self,m):
        self.stat(str(m))
    
    def stat(self,msg):
        strokeWeight(self.sw)
        fill(self.cf)
        stroke(self.cf)
        rect(self.x,self.y,self.w,self.h)
        fill(self.cs)
        stroke(self.cs)
        line(self.x,self.y,self.x+self.w,self.y)
        textAlign(LEFT,TOP)
        text('| %s |'%msg,self.x+6,self.y+3)
