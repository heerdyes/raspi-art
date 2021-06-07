add_library('video')

c=None
w=640.0
h=480.0
t=0.0
dt=0.01
darkmode=False

def setup():
    global c,cx,cy
    size(640,480)
    background(0 if darkmode else 255)
    stroke(23,202,230)
    imageMode(CENTER)
    c=Capture(this,640,480)
    c.start();

def imgfltr():
    for i in range(width):
        for j in range(height):
            pxc=get(i,j)
            mxmap=map(mouseX,0,width,0,255)
            mymap=map(mouseY,0,height,0,255)
            pxr,pxg,pxb=red(pxc),green(pxc),blue(pxc)
            if green(pxc)>mxmap:
                pxg=0
            elif red(pxc)>mymap:
                pxr=0
            set(i,j,color(pxr,pxg,pxb))

def draw():
    global t,dt
    cx=width/2
    cy=height/2
    image(c,cx,cy,w,h)
    imgfltr()
    t+=dt

def captureEvent(cpt):
    cpt.read()

def keyPressed():
    global darkmode
    if key=='d':
        darkmode=not darkmode
        background(0 if darkmode else 255)
