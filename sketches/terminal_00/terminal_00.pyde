from widgets import LShell

lsh=None

def setup():
    global lsh
    size(1280,720)
    background(0)
    stroke(255)
    lsh=LShell(5,height-100,width-10,90,color(0,255,0))
    lsh.render()
    
def draw():
    pass

def keyPressed():
    print(keyCode)
    lsh.sensekey()

def mouseClicked():
    pass

