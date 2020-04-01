import turtle
import math

t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(1,1,1)

def navgen(niter,steplen,dlim,ulim):
    rtdeg=ulim
    turndir=-1
    r=1.0
    g=0.0
    b=0.0
    for j in range(niter):
        print(j)
        for i in range(360):
            r=math.sin(i)
            g=math.cos(i)
            if r<0:
                g=-r
                r=0
            if g<0:
                b=-g
                g=0
            t.pencolor(r,g,b)
            t.fd(steplen)
            t.rt(rtdeg)
            if rtdeg>ulim:
                rtdeg=ulim
                turndir=-1
            elif rtdeg<dlim:
                rtdeg=dlim
                turndir=1
            rtdeg+=turndir

#navgen(4,2,-12,10) # wave particle duality
#navgen(2,5,-15,11) # 10 petalled flower
#navgen(2,5,-15,14) # 12 petal ribbon
#navgen(8,5,-15,16) # orbital middle dense flower
#navgen(4,10,-15,17) # multiple orbital
#navgen(8,10,-15,17) # layered spheres of energy
#navgen(4,10,-15,18) # gift wrap 3d
#navgen(4,10,-15,19) # 18 petalled energy core flower
#navgen(2,10,0,45) # four corner warps
# color dimension entered
#navgen(4,5,-30,10) # edge blooming flower
#navgen(1,10,-30,-10) # tri-gears
navgen(8,10,-30,60)
