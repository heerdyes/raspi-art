from turtle import *
from PIL import Image
import os
import time

t=Turtle()
t.speed(0)
t.ht()

# globals
ctr=1
yname='zenspiral'
snapshot=False

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

# vars
s=100
a=90

for i in range(30):
    t.pencolor('black')
    t.fd(s)
    t.screen.delay(50)
    t.pencolor('white')
    t.bk(s)
    t.lt(90)
    t.fd(1)
    t.rt(90)