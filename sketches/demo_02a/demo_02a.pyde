from democtrl import *

dc=None

def setup():
    global dc
    size(1280,720)
    background(0)
    stroke(0,255,0)
    noFill()
    dc=DemoCtrl()
    dc.renderall()

def draw():
    dc.blinkcursor()

def keyPressed():
    global dc
    if keyCode==18:
        dc.kmode='cmd'
        dc.stat('- command -')
    elif dc.kmode=='cmd':
        dc.cmdhandler(key,keyCode)
    elif dc.kmode=='edit':
        dc.currenteditor().edithandler(key,keyCode)
    elif dc.kmode=='dlg':
        dc.dlgwnd.keyhandler(key,keyCode)
    else:
        dc.stat('unknown mode!')
