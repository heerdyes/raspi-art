h=0
hinc=1
coeff=0.1

def setup():
    size(800,800)
    stroke(255,25)
    background(0)

def draw():
    global h,hinc
    line(0,h,800,h)
    h+=hinc
    h=h%800
    hinc=1.5+sin(frameCount*coeff)
