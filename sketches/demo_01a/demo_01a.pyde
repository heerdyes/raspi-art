from datetime import datetime
from editor import *

democtrl=None

def setup():
    global democtrl
    size(1280,720)
    background(0)
    stroke(0,255,0)
    noFill()
    democtrl=DemoCtrl()
    democtrl.renderall()

def draw():
    democtrl.blinkcursor()

def keyPressed():
    global democtrl
    print('[%d] %s'%(keyCode,key))
    if keyCode==18:
        democtrl.kmode='cmd'
        democtrl.stat('- command -')
    elif democtrl.kmode=='cmd':
        democtrl.cmdhandler(key,keyCode)
    elif democtrl.kmode=='edit':
        democtrl.currenteditor().edithandler(key,keyCode)
    else:
        democtrl.stat('unknown mode!')
