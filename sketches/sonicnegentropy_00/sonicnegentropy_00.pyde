from bturtle import *
from fsm import *

r=None
tw1,tw2=None,None
tw3,tw4=None,None
fsm1=None
bwt,peri=None,None

def setup():
    global r,tw1,tw2,tw3,tw4,dw,fsm1,bwt,peri
    size(2000,2000)
    background(0)
    stroke(0,240,0)
    r=Region(30,30,width-60,height-60)
    r.wipe()
    xx=width/2-580
    yy=height/2+340
    tw1=TWave(Turtle(xx,yy,0,color(0,255,128,192),r),25,2,0.05)
    tw2=TWave(Turtle(xx+5,yy,0,color(255,128,0,192),r),25,3,0.05)
    tw3=TWave(Turtle(xx,height/4-100,0,color(0,255,128,128),r),10,1,0.05)
    tw4=TWave(Turtle(xx+5,height/4-100,0,color(255,128,0,128),r),10,4,0.05)
    bwt=BiWaveTurtle(tw1,tw2)
    peri=BiWaveTurtle(tw3,tw4)
    # flow
    alpha_S(200)
    space_bw()
    alpha_N(400)
    perimeter()

def perimeter():
    peri.fd(600)
    peri.pu()
    peri.bk(600)
    peri.rt(90)
    peri.fd(550)
    peri.lt(90)
    peri.pd()
    peri.fd(600)

def space_bw():
    bwt.pu()
    bwt.fd(100)
    bwt.rt(90)
    bwt.fd(400)
    bwt.lt(180)
    bwt.pd()

def alpha_S(m):
    bwt.fd(m+20)
    bwt.lt(90)
    bwt.fd(m)
    bwt.lt(90)
    bwt.fd(m+20)
    bwt.rt(90)
    bwt.fd(m)
    bwt.rt(90)
    bwt.fd(m+20)

def alpha_N(m):
    bwt.fd(m)
    bwt.rt(90)
    bwt.fd(20)
    bwt.rt(60)
    bwt.fd(m+50)
    bwt.lt(60)
    bwt.fd(20)
    bwt.lt(90)
    bwt.fd(m)

def rpt(n):
    for i in range(n):
        alpha_S(100)
        bwt.rt(180)

def draw():
    global tw1,tw2,r,bwt
    #rpt(1)

def keyPressed():
    print(keyCode)
    if keyCode==32:
        saveFrame("sn-######.png")
