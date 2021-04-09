from structs import *

p=None
stnry=None
whitener=None
bluepen=None
sb=None

def setup():
    global p,sb,stnry,whitener,bluepen
    size(1280,720)
    background(255)
    stroke(0,128,128)
    bluepen=Pen(color(0,128,128),'bluepen')
    whitener=Pen(color(255,255,255),'whitener')
    stnry=Stationery([bluepen,whitener])
    sb=Statbar(0,height-30,width-1,20,color(255,255,255),color(0,100,144))
    bluepen.addsub(sb)
    whitener.addsub(sb)
    stnry.addsub(sb)
    p=stnry.getpen()
    sb.stat('ready')

def draw():
    if p.m.pd:
        p.pdot()

def mousePressed():
    p.m.pd=True

def mouseReleased():
    p.m.pd=False
    if p.m.linemode and p.m.state==0:
        p.savedot()
        p.m.state=1
    elif p.m.linemode and p.m.state==1:
        p.pline()
        p.m.state=0

def keyPressed():
    global p
    sb.stat('%d'%keyCode)
    if key=='c':
        background(255)
        sb.stat('screen cleared')
    elif key=='p':
        p.m.togglepenmode()
    elif key in ['1','2','3','4','5','6','7','8','9'] and p.m.penmode:
        p.sw=1.0+0.1*int(key)
        sb.stat('stroke weight: %f'%p.sw)
    elif key=='0' and p.m.penmode:
        p.sw=1
        sb.stat('stroke weight: %f'%p.sw)
    elif key=='l':
        p.m.togglelinemode()
    elif key=='t':
        p=stnry.nxtpen()
    elif key=='o':
        p.m.togglecirclemode()
        
