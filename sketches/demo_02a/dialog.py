from arch import *
from wnds import *
from helper import *

class Txtdlg(Wnd,Pub):
    def __init__(self,x,y,w,h,msg):
        Wnd.__init__(self,x,y,w,h,'txtinpdlg')
        Pub.__init__(self)
        self.msg=msg
        self.txt=''
        self.ptr=0
    
    def render(self,c):
        Wnd.render(self,c)
        g=color(0,255,0)
        stroke(g)
        fill(g)
        text(self.msg,self.x+10,self.y+10)
        noFill()
    
    def keyhandler(self,k,kc):
        if k=='\n' or len(self.txt)>=16:
            self.publish(['mvbuf',self.txt])
        elif kc>=65 and kc<=90:
            self.txt+=k
            wipetext(self.x+10,self.y+self.h/2,self.w-20,self.h/2-10,color(0,255,0),self.txt)
