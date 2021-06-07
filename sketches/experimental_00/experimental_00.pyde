from reclib import genscripts
from genart import ga00,ga01,ga02

dt=0.01
recordmode=False
pd=True

def setup():
    size(720,720)
    background(64)
    #frameRate(24)

def draw():
    c=color(255,25) if pd else color(64,255)
    stroke(c)
    fill(c)
    t=frameCount*dt
    cx=width/2
    cy=height/2
    ga02(cx,cy,t)
    if recordmode:
        save('img/ps_%04d.png'%frameCount)

def keyPressed():
    global recordmode,pd
    if key=='r':
        recordmode=not recordmode
        print('recordmode: '+recordmode)
    elif key=='g':
        genscripts(width,height)
    elif key=='d':
        pd=not pd
