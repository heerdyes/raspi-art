import turtle
import math
from math import pi
from math import degrees

t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(1,1,1)


class parameter(object):
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


class colorboundary(object):
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


rparam=parameter(1.0,0.5,1.0,-1/256)
gparam=parameter(1.0,0.5,1.0,-1/64)
bparam=parameter(0.0,0.0,1.0,1/64)
cb=colorboundary(rparam,gparam,bparam) # green is stuck at 1
speedparam=parameter(10,10,10,0)
pturn=parameter(-15,-15,-7.5,7.5/10)
#navgen(4,speedparam,1,-15,-1,cb) # tri-ellipse
#navgen(4,speedparam,1,-15,-2,cb) # the trellipse starts braiding
#navgen(4,speedparam,1,-15,-5,cb) # optical fibre cable

# exploring dlim:ulim = 2:1
#navgen(4,speedparam,1,-15,-7.5,cb) # ELLIPSE detected! find out if it really is one!
#navgen(4,speedparam,1,-10,-5,cb) # rounded rect or squared circle?
#navgen(4,speedparam,1,-8,-4,cb) # rounded hexagon or hexagonal circle?
#navgen(4,speedparam,1,-6,-3,cb) # dodecagonal circle or circular dodecagon?

# exploring dlim:ulim = 3:1
#navgen(4,speedparam,1,-30,-10,cb) # nested trellipse
slparam=parameter(10,10,10,0)
pturn=parameter(-15,-15,-7.5,1)
navgen(4,slparam,pturn,cb) # again ellipse! added speed as dynamic parameter
