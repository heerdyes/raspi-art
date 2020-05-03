import turtle
import sys

print(sys.argv)

t=turtle.Turtle()

# function definitions
def savescreen(fnm):
    cv=turtle.getcanvas()
    cv.postscript(file=fnm,colormode='color')

def _chk():
    for i in range(4):
        t.fd(100)
        t.lt(90)
        savescreen("img/ps/sq-%d.ps"%i)
