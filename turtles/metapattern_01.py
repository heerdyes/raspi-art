import turtle
import math

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


def navgen(niter,steplen,dlim,ulim,cb):
    rtdeg=ulim
    turndir=-1
    for j in range(niter):
        print(j)
        for i in range(360):
            cb.updatecolors()
            t.pencolor(cb.currentrgb())
            t.fd(steplen)
            t.rt(rtdeg)
            if rtdeg>ulim:
                rtdeg=ulim
                turndir=-1
            elif rtdeg<dlim:
                rtdeg=dlim
                turndir=1
            rtdeg+=turndir


rparam=parameter(1.0,0.5,1.0,-1/256)
gparam=parameter(1.0,0.5,1.0,-1/256)
bparam=parameter(0.0,0.0,1.0,1/256)
cb=colorboundary(rparam,gparam,bparam) # green is stuck at 1
navgen(4,6,-8,30,cb)
