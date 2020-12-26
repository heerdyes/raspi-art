from aturtle import *

r1=Region(50,50,400,400)
t1=Turtle(100,100,0,color(255,192,0),r1)

def setup():
    global t1
    size(1200,800)
    background(0)
    stroke(0,255,128)
    r1.wipe()
    t1.x,t1.y=r1.x+r1.w/2,r1.y+r1.h/2
    
def draw():
    global t1
    t1.fd(2)
    t1.lt(1)
