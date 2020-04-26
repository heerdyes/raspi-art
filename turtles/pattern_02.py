from turtle import *
from PIL import Image
import os

t1=Turtle()
t2=Turtle()
t3=Turtle()
t1.speed(0)
t2.speed(0)
t3.speed(0)

t1.screen.bgcolor('white')
r=0
g=0
b=0
t1.pencolor(r,g,b)
t2.pencolor(r,g,b)
t3.pencolor(r,g,b)

# globals
ctr=1

# function definitions
def savescreen(fnm):
    fnmps=fnm+'.ps'
    fnmpng=fnm+'.png'
    cv=getcanvas()
    cv.postscript(file=fnmps,colormode='color')
    img=Image.open(fnmps)
    img.save(fnmpng,'png')
    os.remove(fnmps)

def tri(s,t):
    for i in range(3):
        t.fd(s)
        t.lt(120)

def ufdlt(x,a,t):
    t.up()
    t.fd(x)
    t.lt(a)
    t.down()

def ubk(x,t):
    t.up()
    t.bk(x)
    t.down()

def urtbk(a,x,t):
    t.up()
    t.rt(a)
    t.bk(x)
    t.down()

def L(x,y,t):
    t.up()
    t.bk(x)
    t.rt(90)
    t.fd(y)
    t.lt(90)
    t.down()

def orientxtoy(tx,ty):
    tx.up()
    tx.setpos(ty.pos())
    tx.setheading(ty.heading())
    tx.down()

# tweaked original pattern
def renderptn2(s,x,t):
    orientxtoy(t2,t)
    orientxtoy(t3,t)
    ufdlt(s,120,t2)
    urtbk(120,s,t3)
    
    for i in range(x):
        t1.fd(s/x)
        t2.fd(s/x)
        t3.fd(s/x)
        curpos=t1.pos()
        t1.setpos(t2.pos())
        t1.setpos(t3.pos())
        t1.setpos(curpos)

def compoundptn2(s,d):
    tri(s,t1)
    renderptn2(s,d,t1)

    t1.up()
    t1.bk(s/2)
    t1.rt(90)
    t1.fd(s/3)
    t1.lt(150)
    t1.down()

    tri(s,t1)
    renderptn2(s,d,t1)

# original pattern
def renderptn1(s,x,t):
    global ctr
    orientxtoy(t2,t)
    orientxtoy(t3,t)
    ufdlt(s,120,t2)
    urtbk(120,s,t3)
    
    for i in range(x):
        t2.fd(s/x)
        t3.fd(s/x)
        curpos=t1.pos()
        t1.setpos(t2.pos())
        t1.setpos(t3.pos())
        t1.setpos(curpos)
        t1.fd(s/x)
        savescreen('img/p02-%03d'%ctr)
        ctr+=1

def compoundptn1(s,d):
    tri(s,t1)
    renderptn1(s,d,t1)

    t1.up()
    t1.bk(s/2)
    t1.rt(90)
    t1.fd(s/3)
    t1.lt(150)
    t1.down()

    tri(s,t1)
    renderptn1(s,d,t1)

L(200,100,t1)
compoundptn1(400,60)
