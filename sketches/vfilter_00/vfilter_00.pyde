add_library('video')

c=None
w=640.0
h=480.0
darkmode=False

def setup():
    global c,cx,cy
    size(640,480)
    background(0 if darkmode else 255)
    stroke(23,202,230)
    imageMode(CENTER)
    c=Capture(this,640,480)
    c.start();

def genart():
    line(dx,cy-h/2,dx,cy+h/2)

def draw():
    cx=width/2
    cy=height/2
    image(c,cx,cy,w,h)
    #genart()

def captureEvent(cpt):
    cpt.read()

def keyPressed():
    global darkmode
    if key=='d':
        darkmode=not darkmode
        background(0 if darkmode else 255)
