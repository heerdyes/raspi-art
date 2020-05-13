# this is also implemented as a recipe for metapattern_01
# m_01_recipes/pattern_01
import turtle

t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(0.9,0.9,0.9)
rtdeg=46
turndir=-1

for i in range(360*16):
    t.fd(10)
    t.rt(rtdeg)
    if rtdeg>46:
        rtdeg=46
        turndir=-1
    elif rtdeg<-45:
        rtdeg=-45
        turndir=1
    rtdeg+=turndir
