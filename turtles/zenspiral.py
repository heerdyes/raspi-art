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
yname='zenspiral'
snapshot=False
s=100
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
    return t1

# key listeners
def ainc():
    global a
    a+=1
    print('a:%d'%a)
    
def adec():
    global a
    a-=1
    print('a:%d'%a)

# registration
t.screen.onkey(ainc, 'a')
t.screen.onkey(adec, 'z')
t.screen.listen()

# flow
t2=t.clone()
t2.fd(s)
t2.lt(a)
t3=t2.clone()
t3.fd(s)
t3.lt(a)
t4=t3.clone()
t4.fd(s)
t4.lt(a)
t4.fd(s)
t4.bk(s)
tset=[t,t2,t3,t4]
cidx=1

td=t.clone()
t2.fd(dx)
td=looktowards(td,t2)
tob=td.clone()
tob.up()
scov=0
rfxs=0
div1=4
scovmin=20
while rfxs<40:
    tob.fd(1)
    pixc=getpixelcolor(tob.xcor(),tob.ycor())
    if scov==dx:
        print('freezing current turtle @ scov=%d'%scov)
        tset[(cidx-1)%4]=td.clone()
    if scov<scovmin:
        td.fd(1)
        scov+=1
        continue
    if pixc=='black':
        rfxs+=1
        print('r:%d,cidx:%d'%(rfxs,cidx))
        td.fd(1)
        nxtt=tset[(cidx+1)%4]
        nxtt.fd(dx)
        td=looktowards(td,nxtt)
        tob.setheading(td.heading())
        scov=0
        cidx+=1
    else:
        td.fd(1)
    scov+=1
