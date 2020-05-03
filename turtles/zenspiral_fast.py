from turtle import *
from PIL import Image
import os
import time
import math

t=Turtle()
t.speed(0)
t.ht()

# globals
ctr=1
yname='zenspiral_fast'
snapshot=False
s=200
a=90
dx=5

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

def looktowards(t1,t2):
    x1,y1,x2,y2=t1.xcor(),t1.ycor(),t2.xcor(),t2.ycor()
    if x1==x2 and y1==y2:
        return
    if x1==x2 and y1<y2:
        t1.setheading(90)
        return
    if x1==x2 and y1>y2:
        t1.setheading(-90)
        return
    angle=math.degrees(math.atan(abs(y2-y1)/abs(x2-x1))) # Q1 default
    if x1>x2 and y1<y2: #Q2
        angle=180-angle
    elif x1>x2 and y1>y2: #Q3
        angle=180+angle
    elif x1<x2 and y1>y2: #Q4
        angle=-angle
    print('angle=%f'%angle)
    t1.setheading(angle)
    dist=math.sqrt((x2-x1)**2 + (y2-y1)**2)
    return dist

def spirofiller(tset):
    global dx
    cidx=1
    td=tset[0]
    tset[1].fd(dx)
    dist=looktowards(td,tset[1])
    rfxs=0
    while rfxs<84:
        td.fd(dx)
        tset[(cidx-1)%4]=td.clone()
        td.fd(dist-dx)
        rfxs+=1
        print('r:%d,cidx:%d,dist:%f'%(rfxs,cidx,dist))
        nxtt=tset[(cidx+1)%4]
        nxtt.fd(dx)
        dist=looktowards(td,nxtt)
        cidx+=1

# flow
tset=[]
for i in range(4):
    tset.append(t.clone())
    t.fd(s)
    t.lt(a)

spirofiller(tset)
