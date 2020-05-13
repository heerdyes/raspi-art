# pattern running instructions:
# python3 metapattern_01.py <m_01_recipes/drunkenspider
# the interactive way is rather time taking
import turtle
import math
from math import pi
from math import degrees

t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(1,1,1)
screen=turtle.Screen()


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

navgen(niter,speedparam,turnparam,cb)
