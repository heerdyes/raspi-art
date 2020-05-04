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
snapshot=True

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
    else:
        print('[WARN] snapshot set to False. not saving screen')

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
        print('[BOOM] point tried to look towards itself!')
        return 0
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

def weakcopy(ta,tb):
    ta.up()
    ta.setpos(tb.pos())
    ta.setheading(tb.heading())
    ta.down()

def spirofiller(tset,rlim,dx):
    global ctr
    cidx=1
    td=tset[0]
    tset[1].fd(dx)
    dist=looktowards(td,tset[1])
    rfxs=0
    while rfxs<rlim:
        td.fd(dx)
        tset[(cidx-1)%4]=None
        tset[(cidx-1)%4]=td.clone()
        td.fd(dist-dx)
        rfxs+=1
        print('r:%d,cidx:%d,dist:%f'%(rfxs,cidx,dist))
        nxtt=tset[(cidx+1)%4]
        nxtt.fd(dx)
        dist=looktowards(td,nxtt)
        cidx+=1
        savescreen('img/zf-%03d'%ctr)
        ctr+=1

def resetturtles(teset,a):
    for tx in teset:
        tx.up()
        tx.home()
        tx.seth(a)
        tx.down()

def dumptxy(teset):
    print('[')
    for tx in teset:
        print(tx.xcor(),tx.ycor())
    print(']')

def postturtles_sq_l(teset,s):
    for i in range(4):
        for j in range(i+1):
            teset[(i+1)%4].fd(s)
            teset[(i+1)%4].lt(90)

def postturtles_sq_r(teset,s):
    for i in range(4):
        for j in range(i+1):
            teset[(i+1)%4].fd(s)
            teset[(i+1)%4].rt(90)

def mksentries(n):
    teset=[]
    for i in range(n):
        ti=Turtle()
        ti.ht()
        ti.speed(0)
        teset.append(ti)
    return teset

def compound0(s,m,d):
    tset=mksentries(4)
    # top
    postturtles_sq_l(tset,s)
    spirofiller(tset,m,d)
    resetturtles(tset,180)
    postturtles_sq_r(tset,s)
    spirofiller(tset,m,d)
    # bottom
    resetturtles(tset,0)
    postturtles_sq_r(tset,s)
    spirofiller(tset,m,d)
    resetturtles(tset,180)
    postturtles_sq_l(tset,s)
    spirofiller(tset,m,d)

compound0(150,62,5)
print('nimg:%d'%ctr)