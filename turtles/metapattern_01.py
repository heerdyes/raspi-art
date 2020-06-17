# pattern running instructions:
# python3 metapattern_01.py <m_01_recipes/drunkenspider
# the interactive way is rather time taking
import turtle
import math
from math import pi
from math import degrees
from PIL import Image
import os

# globals
yname='metapattern_01_'
snapshot=False
imgfname='_tmp_'
snapctr=0
snapfreq=999

def savescreen(fnm):
    global snapshot
    if snapshot:
        print('[snapping screenshot]')
        fnmps=fnm+'.ps'
        fnmpng=fnm+'.png'
        cv=turtle.getcanvas()
        cv.postscript(file=fnmps,colormode='color')
        img=Image.open(fnmps)
        img.save(fnmpng,'png')
        os.remove(fnmps)

def draw_background(a_turtle):
    """ Draw a background rectangle. """
    ts=a_turtle.getscreen()
    canvas=ts.getcanvas()
    height=ts.getcanvas()._canvas.winfo_height()
    width=ts.getcanvas()._canvas.winfo_width()

    turtleheading=a_turtle.heading()
    turtlespeed=a_turtle.speed()
    penposn=a_turtle.position()
    penstate=a_turtle.pen()

    a_turtle.penup()
    a_turtle.speed(0)
    a_turtle.goto(-width/2-2,-height/2+3)
    a_turtle.fillcolor(turtle.Screen().bgcolor())
    a_turtle.begin_fill()
    a_turtle.setheading(0)
    a_turtle.forward(width)
    a_turtle.setheading(90)
    a_turtle.forward(height)
    a_turtle.setheading(180)
    a_turtle.forward(width)
    a_turtle.setheading(270)
    a_turtle.forward(height)
    a_turtle.end_fill()

    a_turtle.penup()
    a_turtle.setposition(*penposn)
    a_turtle.pen(penstate)
    a_turtle.setheading(turtleheading)
    a_turtle.speed(turtlespeed)

def clickhandler(x,y):
    """ take a screenshot """
    global snapctr
    savescreen('img/%s_%03d'%(imgfname,snapctr))
    snapctr+=1

turtle.onscreenclick(clickhandler)
t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(1,1,1)
screen=turtle.Screen()
screen.setup(1600,1000)
draw_background(t)


class Parameter:
    """ abstracts a parameter which can be dynamically controlled
        takes 4 params, current val, min, max, delta"""
    def __init__(self,pcurrval,pmin,pmax,pdelta):
        self.currval=pcurrval
        self.min=pmin
        self.max=pmax
        self.delta=pdelta
        
    def reflect(self):
        if self.currval<self.min:
            self.delta=-self.delta
            self.currval=self.min
        elif self.currval>self.max:
            self.delta=-self.delta
            self.currval=self.max

    def update(self):
        self.currval+=self.delta
        self.reflect()


class Colorboundary:
    """ abstracts the color boundary object.
        takes 3 parameters: red, green, blue """
    def __init__(self,pred,pgreen,pblue):
        self.pr=pred
        self.pg=pgreen
        self.pb=pblue

    def updatecolors(self):
        self.pr.update()
        self.pg.update()
        self.pb.update()

    def currentrgb(self):
        return self.pr.currval,self.pg.currval,self.pb.currval


def navgen(niter,steplenparam,turnparam,cb):
    for j in range(niter):
        print(j)
        for i in range(360):
            cb.updatecolors()
            t.pencolor(cb.currentrgb())
            steplenparam.update()
            t.fd(steplenparam.currval)
            turnparam.update()
            t.rt(turnparam.currval)
        if j%snapfreq==0:
            clickhandler(0,0)

def mkparam(prompt,delim=' '):
    sparr=input(prompt)
    parr=sparr.split(delim)
    print(parr)
    return Parameter(float(parr[0]),float(parr[1]),float(parr[2]),float(parr[3]))

rp=mkparam('red: ')
gp=mkparam('green: ')
bp=mkparam('blue: ')
cb=Colorboundary(rp,gp,bp)
speedparam=mkparam('init_len,min_len,max_len,delta: ')
turnparam=mkparam('init_turn,min_turn,max_turn,delta: ')
niter=int(input('niter: '))
try:
    sep=input()
    if sep=='---':
        print()
        sinitloc=input('init location: ')
        initloc=sinitloc.split(' ')
        ix,iy=int(initloc[0]),int(initloc[1])
        print(ix,iy)
        t.up()
        t.goto(ix,iy)
        t.down()
        simgfreq=input('imagename, frequency: ')
        data=simgfreq.split(' ')
        imgfname,snapfreq=yname+data[0],int(data[1])
        print(imgfname,snapfreq)
        snapshot=True
except EOFError as eofe:
    pass

navgen(niter,speedparam,turnparam,cb)
savescreen('img/%s'%imgfname)
