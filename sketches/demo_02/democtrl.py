from datetime import datetime
from helper import *
from editor import *
from dialog import *

class DemoCtrl(Pub,Sub):
    def __init__(self):
        Pub.__init__(self)
        Sub.__init__(self,self.recv)
        self.ml,self.mt,self.mr,self.mb=10,10,10,10
        self.sbht=27
        self.kmode='cmd' # choose from cmd, edit, dlg
        self.t=0.0
        self.flipflop=False
        self.wnds=[]
        frmrect(self.ml,self.mt,width-self.ml-self.mr,height-self.mt-self.mb-self.sbht,10)
        self.fontocra=createFont('assets/ocr-a_regular.ttf',14)
        self.bounds=[self.ml+5,self.mt+5,width-self.ml-self.mr-10,height-self.mt-self.mb-self.sbht-10]
        rootwnd=Voidwnd(self.bounds[0],self.bounds[1],self.bounds[2],self.bounds[3])
        self.wnds.insert(0,rootwnd)
        self.actwnd=0
        self.dlgwnd=None
    
    def recv(self,m):
        hdr=m.head
        car,cdr=m.body[0],m.body[1:]
        if car=='stat':
            self.stat('[%s] %s'%(hdr,cdr[0]))
        elif car=='mvbuf':
            self.stat('renaming current buffer to %s'%cdr[0])
            self.wnds[self.actwnd].nm=cdr[0]
            self.dlgwnd=None
            self.kmode='cmd'
            self.renderall()
        else:
            self.stat('unknown msg cmd: %s'%car)
        
    def stat(self,msg):
        fill(0)
        stroke(0)
        rect(0,height-self.sbht,width-1,height-self.sbht)
        stroke(0,255,0)
        fill(0,255,0)
        textFont(self.fontocra)
        textSize(14)
        textAlign(LEFT,TOP)
        text('| %s |'%msg,5,height-self.sbht+3)
        noFill()
    
    def mkdlg(self,promptmsg):
        if self.dlgwnd:
            self.stat('dialog currently active!')
            return
        self.stat('readying dialog prompt...')
        dw=300
        dh=100
        self.dlgwnd=Txtdlg(width/2-dw/2,height/2-dh/2,dw,dh,promptmsg)
        self.dlgwnd.addsub(self)
        self.kmode='dlg'
    
    def mked(self,nm):
        if self.actwnd==-1:
            self.stat('no active window')
            return
        self.stat('ed...')
        if isinstance(self.wnds[self.actwnd],Ed):
            print('cannot overwrite current editor!')
            return
        vw=self.wnds[self.actwnd]
        self.wnds[self.actwnd]=Ed(vw.x,vw.y,vw.w,vw.h,nm)
        self.wnds[self.actwnd].addsub(self)
    
    def renderall(self):
        wiperect(self.bounds[0],self.bounds[1],self.bounds[2],self.bounds[3],color(0,0,0))
        for i in range(len(self.wnds)):
            if i==self.actwnd:
                self.wnds[i].render(color(0,255,0))
            else:
                self.wnds[i].render(color(0,128,0))
        if self.dlgwnd:
            self.dlgwnd.wipe()
            self.dlgwnd.render(color(0,255,128))
    
    def blinkcursor(self):
        if self.kmode=='edit':
            self.t+=0.05
            if frameCount%50==0:
                if self.flipflop:
                    self.wnds[self.actwnd].rendercursor(color(0,255,0))
                else:
                    self.wnds[self.actwnd].rendercursor(color(0,0,0))
                self.flipflop=not self.flipflop
    
    def vsplit(self,frac):
        self.stat('vertical split')
        cw=self.wnds[self.actwnd]
        cw.wipe()
        wfrac=frac*cw.w
        rfrac=cw.w-wfrac
        mp=cw.x+wfrac
        dmw=3
        cw.w=wfrac-dmw
        nw=Voidwnd(mp+dmw,cw.y,rfrac-dmw,cw.h)
        self.wnds.insert(self.actwnd+1,nw)
    
    def hsplit(self,frac):
        self.stat('horizontal split')
        cw=self.wnds[self.actwnd]
        cw.wipe()
        hfrac=frac*cw.h
        rfrac=cw.h-hfrac
        mp=cw.y+hfrac
        dmh=3
        cw.h=hfrac-dmh
        nw=Voidwnd(cw.x,mp+dmh,cw.w,rfrac-dmh)
        self.wnds.insert(self.actwnd+1,nw)
        
    def bye(self):
        self.stat('bye!')
        exit()
    
    def screenshot(self):
        self.stat('screengrab')
        save('img/demo_01a_%s.png'%(datetime.today().strftime('%Y%m%d_%H%M%S')))
        
    def nextwnd(self):
        self.actwnd=(self.actwnd+1)%len(self.wnds)
        self.stat('active window index: %d'%self.actwnd)
        
    def prevwnd(self):
        self.actwnd-=1
        if self.actwnd<0:
            self.actwnd=len(self.wnds)-1
        self.stat('active window index: %d'%self.actwnd)
    
    def insmode(self):
        if self.actwnd==-1:
            self.stat('no editor active!')
        elif not isinstance(self.wnds[self.actwnd],Ed):
            self.stat('active window is not an editor!')
        else:
            self.stat('- insert -')
            self.kmode='edit'
    
    def writecurbuf(self):
        if self.actwnd==-1:
            self.stat('no editor active!')
        elif not isinstance(self.wnds[self.actwnd],Ed):
            self.stat('active window is not an editor!')
        else:
            self.wnds[self.actwnd].savebuffer()
    
    def loadfile(self):
        pass
    
    def cmdhandler(self,k,kc):
        print('[cmd] (%s,%s)'%(kc,k))
        if k=='q':
            self.bye()
        if k=='s':
            self.screenshot()
        elif k=='v':
            self.vsplit(0.5)
        elif k=='V':
            self.vsplit(0.75)
        elif k=='h':
            self.hsplit(0.5)
        elif k=='H':
            self.hsplit(0.75)
        elif k=='n':
            self.nextwnd()
        elif k=='p':
            self.prevwnd()
        elif k=='e':
            self.mked('%s'%(datetime.today().strftime('%Y%m%d_%H%M%S')))
        elif k=='i':
            self.insmode()
        elif k=='w':
            self.writecurbuf()
        elif k=='o':
            self.loadfile()
        elif k=='r':
            self.mkdlg('new current buffer name:')
        self.renderall()
        
    def currenteditor(self):
        return self.wnds[self.actwnd]
