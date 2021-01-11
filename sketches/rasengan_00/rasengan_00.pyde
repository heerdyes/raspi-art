t=0.0
dt=0.05
cx=0
cy=0
r=180
rs=[(x+2)*1.1 for x in range(500)]
dr=-1
wiperon=True
sopa=255
wopa=40
sc=[255,255,255]
wc=[0,0,0]
fpd=10

def setup():
    global cx,cy
    size(1280,720)
    background(0)
    stroke(sc[0],sc[1],sc[2],sopa)
    cx=width/2
    cy=height/2
    
def wipe():
    fill(wc[0],wc[1],wc[2],wopa)
    rect(0,0,width,height)
    
def iter(n):
    global t,dt,r,dr
    for i in range(n):
        for idx,ri in enumerate(rs):
            coeff=log(ri)
            sopa=constrain(128+100*sin(0.10*t),10,255)
            stroke(sc[0],sc[1],sc[2],sopa)
            x=cx+ri*cos(coeff*t)
            y=cy-ri*sin(coeff*t)
            point(x,y)
        t+=dt
    if wiperon:
        wipe()
    
def draw():
    iter(fpd)

def keyPressed():
    global wiperon,sopa,sc
    if key=='q':
        print('exiting...')
        exit()
    elif key=='b':
        sc=[0,0,0,sopa]
    elif key=='w':
        sc=[255,255,255,sopa]
    elif key=='.':
        wiperon=not wiperon
    elif key=='o':
        sopa=128 if sopa==16 else 16
    stroke(sc[0],sc[1],sc[2],sopa)

def mouseClicked():
    global fpd
    fpd=constrain(mouseX,1,60)
