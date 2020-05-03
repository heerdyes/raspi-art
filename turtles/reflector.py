from turtle import *
from PIL import Image
import os
import time

t=Turtle()
t.speed(0)
#t.ht()

# globals
ctr=1
yname='reflector'
snapshot=False
s=50
a=90

# function definitions
def savescreen(fnm):
    global snapshot
    if snapshot:
        fnmps=fnm+'.ps'
        fnmpng=fnm+'.png'
        cv=getcanvas()
        cv.postscript(file=fnmps,colormode='color')
        img=Image.open(fnmps)
        img.save(fnmpng,'png')
        os.remove(fnmps)

def getpixelcolor(x,y):
    y=-y
    cv=getcanvas()
    ids=cv.find_overlapping(x,y,x,y)
    if ids:
        index=ids[-1]
        color=cv.itemcget(index,'fill')
        if color!='':
            return color.lower()
    return 'white'

def flfr(x,y,a,tx):
    tx.fd(x)
    tx.lt(a)
    tx.fd(y)
    tx.rt(a)

def lbrb(x,y,a,tx):
    tx.lt(a)
    tx.bk(x)
    tx.rt(a)
    tx.bk(y)

def rblb(x,y,a,tx):
    tx.rt(a)
    tx.bk(x)
    tx.lt(a)
    tx.bk(y)

def flfr90(x,y,tx):
    flfr(x,y,90,tx)

def lbrb90(x,y,tx):
    lbrb(x,y,90,tx)

def rblb90(x,y,tx):
    rblb(x,y,90,tx)

def frfl(x,y,a,tx):
    tx.fd(x)
    tx.rt(a)
    tx.fd(y)
    tx.lt(a)

def frfl90(x,y,tx):
    frfl(x,y,90,tx)

# class definitions
class Tbot:
    def __init__(self,t,laf,lal,raf,ral,nf):
        t.up()
        t.ht()
        self.la=t.clone()
        self.ra=t.clone()
        self.n=t.clone()
        t.down()
        t.st()
        flfr90(laf,lal,self.la)
        frfl90(raf,ral,self.ra)
        self.n.fd(nf)
        self.tme=t
        self.turn=0
        self.step=5
    
    def resetsensors(self):
        tmeh=self.tme.heading()
        self.la.setheading(tmeh)
        self.ra.setheading(tmeh)
        self.n.setheading(tmeh)
    
    def retract(self):
        lbrb90(1,2,self.la)
        rblb90(1,2,self.ra)
        self.n.bk(1)
    
    def expand(self):
        self.resetsensors()
        flfr90(2,1,self.la)
        frfl90(2,1,self.ra)
        self.n.fd(1)
    
    def fd(self,x):
        self.la.fd(x)
        self.ra.fd(x)
        self.n.fd(x)
        self.tme.fd(x)
        
    def lt(self,a):
        self.retract()
        self.tme.lt(a)
        self.expand()
    
    def rt(self,a):
        self.retract()
        self.tme.rt(a)
        self.expand()
    
    def decide_action(self,lac,rac,nc):
        # update turn and step attributes based on lac,rac,nc
        print(lac,rac,nc)
        if nc=='black':
            self.turn=90
    
    def sense(self):
        # detect colors under sensors
        lac=getpixelcolor(self.la.xcor(),self.la.ycor())
        rac=getpixelcolor(self.ra.xcor(),self.ra.ycor())
        nc=getpixelcolor(self.n.xcor(),self.n.ycor())
        return lac,rac,nc
    
    def react(self):
        # act using turn and step attributes
        self.lt(self.turn)
        self.fd(self.step)
    
    def live(self,motordelay):
        while True:
            lac,rac,nc=self.sense()
            self.decide_action(lac,rac,nc)
            #time.sleep(motordelay)
            self.react()

# key listeners
def ainc():
    global a
    a+=1
    print('a:%d'%a)
    
def adec():
    global a
    a-=1
    print('a:%d'%a)

# registration
t.screen.onkey(ainc, 'a')
t.screen.onkey(adec, 'z')
t.screen.listen()

# flow
for i in range(4):
    t.fd(s)
    t.lt(a)

# agent begin
t.up()
flfr90(10,10,t)
t.down()
xbot=Tbot(t,8,4,8,4,10)
xbot.live(0.1)
