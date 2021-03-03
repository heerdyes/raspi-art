from editor import *
from datetime import datetime

e=None
altdown=False
edfocus=None
s=None

def setup():
    global e,edfocus,s
    size(1280,720)
    background(0)
    stroke(0,255,0);
    s=Scr(20,20,width-40,height-40)
    s.render()
    
def draw():
    pass

def keyPressed():
    global altdown
    if altdown and key=='q':
        exit()
    if altdown and key=='s':
        print('grabbing screen with timestamp...')
        save('img/demo_01_%s.png'%(datetime.today().strftime('%Y%m%d_%H%M%S')))
    if keyCode==18:
        altdown=True
    s.keyevent(key,keyCode)

def keyReleased():
    global altdown
    if keyCode==18:
        altdown=False
