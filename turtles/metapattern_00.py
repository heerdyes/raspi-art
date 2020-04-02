import turtle
import math

t=turtle.Turtle()
t.speed(0)
t.ht()
t.screen.bgcolor(0,0,0)
t.pencolor(1,1,1)

class colorboundary(object):
    def __init__(self,rmin,rmax,gmin,gmax,bmin,bmax):
        self.rmin=rmin
        self.rmax=rmax
        self.gmin=gmin
        self.gmax=gmax
        self.bmin=bmin
        self.bmax=bmax

def reflector(c,cmin,cmax,delta):
    deltanew=delta
    cnew=c
    if c<cmin:
        deltanew=-delta
        cnew=cmin
    elif c>cmax:
        deltanew=-delta
        cnew=cmax
    return cnew,deltanew

def navgen(niter,steplen,dlim,ulim,cb):
    rtdeg=ulim
    turndir=-1
    r=cb.rmax
    g=cb.gmax
    b=cb.bmax
    rdelta=-1/256
    gdelta=-1/256
    bdelta=-1/256
    for j in range(niter):
        print(j)
        for i in range(360):
            r+=rdelta
            g+=gdelta
            b+=bdelta
            r,rdelta=reflector(r,cb.rmin,cb.rmax,rdelta)
            g,gdelta=reflector(g,cb.gmin,cb.gmax,gdelta)
            b,bdelta=reflector(b,cb.bmin,cb.bmax,bdelta)
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
#cb=colorboundary(0.0,0.1,0.0,1.0,0.0,0.1) # predominant greens
#navgen(2,5,-5,30,cb) # 2 petal convergent flower
#navgen(8,7,-7,30,cb) # color harmonics!
cb=colorboundary(0.0,1.0,1.0,1.0,0.0,1.0) # green is stuck at 1
navgen(4,6,-8,30,cb)
