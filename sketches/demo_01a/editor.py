from helper import *

class DemoCtrl:
    def __init__(self):
        self.ml,self.mt,self.mr,self.mb=10,10,10,10
        self.sbht=27
        self.kmode='cmd'
        self.t=0.0
        self.flipflop=False
        self.wnds=[]
        frmrect(self.ml,self.mt,width-self.ml-self.mr,height-self.mt-self.mb-self.sbht,10)
        self.fontocra=createFont('assets/ocr-a_regular.ttf',14)
        rootwnd=Voidwnd(self.ml+5,self.mt+5,width-self.ml-self.mr-10,height-self.mt-self.mb-self.sbht-10)
        self.wnds.insert(0,rootwnd)
        self.actwnd=0
        
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
    
    def renderall(self):
        for i in range(len(self.wnds)):
            self.wnds[i].wipe()
            if i==self.actwnd:
                self.wnds[i].render(color(0,255,0))
            else:
                self.wnds[i].render(color(0,128,0))
    
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
        cw.w=wfrac-4
        nw=Voidwnd(mp+4,cw.y,rfrac-4,cw.h)
        self.wnds.insert(self.actwnd+1,nw)
    
    def hsplit(self,frac):
        self.stat('horizontal split')
        cw=self.wnds[self.actwnd]
        cw.wipe()
        hfrac=frac*cw.h
        rfrac=cw.h-hfrac
        mp=cw.y+hfrac
        cw.h=hfrac-4
        nw=Voidwnd(cw.x,mp+4,cw.w,rfrac-4)
        wnds.insert(actwnd+1,nw)
    
    def cmdhandler(self,k,kc):
        if k=='q':
            self.stat('bye!')
            exit()
        if k=='s':
            self.stat('screengrab')
            save('img/demo_01a_%s.png'%(datetime.today().strftime('%Y%m%d_%H%M%S')))
        elif k=='v':
            self.vsplit(0.5)
        elif k=='V':
            self.vsplit(0.75)
        elif k=='h':
            self.hsplit(0.5)
        elif k=='H':
            self.hsplit(0.75)
        elif k=='n':
            self.actwnd=(self.actwnd+1)%len(self.wnds)
            self.stat('active window index: %d'%self.actwnd)
        elif k=='p':
            self.actwnd-=1
            if self.actwnd<0:
                self.actwnd=len(self.wnds)-1
            self.stat('active window index: %d'%self.actwnd)
        elif k=='e':
            self.mked(str(random(1,100)))
        elif k=='i':
            if self.actwnd==-1:
                self.stat('no editor active!')
            elif not isinstance(self.wnds[self.actwnd],Ed):
                self.stat('active window is not an editor!')
            else:
                self.stat('- insert -')
                self.kmode='edit'
        self.renderall()
        
    def currenteditor(self):
        return self.wnds[self.actwnd]


class Wnd:
    def __init__(self,x,y,w,h,nm):
        self.nm=nm
        self.x=x
        self.y=y
        self.w=w
        self.h=h
    
    def wipe(self):
        fill(0)
        stroke(0)
        rect(self.x,self.y,self.w,self.h)
    
    def render(self,c):
        noFill()
        stroke(c)
        rect(self.x,self.y,self.w,self.h)
    

class Voidwnd(Wnd):
    def __init__(self,x,y,w,h):
        Wnd.__init__(self,x,y,w,h,'voidwnd')
    
    def render(self,c):
        Wnd.render(self,c)


class Ed(Wnd):
    def __init__(self,x,y,w,h,nm):
        Wnd.__init__(self,x,y,w,h,nm)
        self.txt=['']
        self.r=0
        self.c=0
        self.mt=24
    
    def rendercursor(self,c):
        rowht=20
        colwt=8
        y=self.y+self.mt+10+self.r*rowht
        x=self.x+26+self.c*colwt
        w=colwt
        h=rowht
        d=4
        stroke(c)
        line(x,y,x+w/2,y+d)
        line(x+w/2,y+d,x+w,y)
        line(x,y+h,x+w/2,y+h-d)
        line(x+w/2,y+h-d,x+w,y+h)
    
    def renderhighlighter(self):
        rowht=20
        colwt=8
        y=self.y+self.mt+10+self.r*rowht
        x=self.x
        w=self.w
        h=rowht
        stroke(0,92,0)
        line(x+1,y,x+w-2,y)
        line(x+1,y+h,x+w-2,y+h)
        noFill()
    
    def renderstatus(self):
        sy=self.y+self.h-20
        stroke(0,144,0)
        line(self.x,sy,self.x+self.w,sy)
        fill(0,255,0)
        text('| %03d:%03d |'%(self.r,self.c),self.x+5,sy)
        noFill()
    
    def render(self,c):
        Wnd.render(self,c)
        line(self.x,self.y+self.mt,self.x+self.w,self.y+self.mt)
        fill(0,255,0)
        text(self.nm,self.x+5,self.y+2)
        lnht=self.y+self.mt+10
        linum=0
        rowht=20
        colwt=8
        for ln in self.txt:
            stroke(0,144,0)
            fill(0,144,0)
            text('%02d'%linum,self.x+3,lnht)
            stroke(0,255,0)
            fill(0,255,0)
            text(ln,self.x+26,lnht)
            lnht+=rowht
            linum+=1
        self.renderhighlighter()
        self.rendercursor(color(0,192,0))
        self.renderstatus()
    
    def edithandler(self,k,kc):
        currow=self.r
        curcol=self.c
        curln=self.txt[currow]
        if kc==10:
            self.txt.append('')
            self.r=currow+1
            self.c=0
        elif kc==8:
            modstr=curln[0:curcol]+curln[curcol+1:]
            print(modstr)
        elif kc==16:
            print('no special handling for shift')
        elif kc==20:
            print('no special handling for caps lock')
        elif kc==37:
            if self.r==0 and self.c==0:
                self.stat('already at beginning')
            elif self.c>0:
                self.c-=1
            elif self.c==0 and self.r>0:
                rownum=self.r-1
                self.c=len(self.txt[rownum])
                self.r=rownum
        elif kc==38:
            # left arrow
            if self.r==0:
                self.stat('already topmost line')
            else:
                prevlinum=self.r-1
                prevln=self.txt[prevlinum]
                if self.c>=len(prevln):
                    self.c=len(prevln)-1
                self.r=prevlinum
        elif kc==39:
            # right arrow
            if currow==len(self.txt)-1 and curcol==len(curln):
                self.stat('already at the end')
            elif curcol==len(curln) and currow<len(self.txt)-1:
                self.c=0
                self.r+=1
            else:
                self.c+=1
        elif kc==40:
            # down arrow
            if currow==len(self.txt)-1:
                self.stat('already last line')
            else:
                nxtrow=currow+1
                nxtln=self.txt[nxtrow]
                if curcol>len(nxtln):
                    self.c=len(nxtln)
                self.r=nxtrow
        elif kc==35:
            print('end')
        elif kc==36:
            print('home')
        else:
            self.txt[currow]=curln[0:curcol]+k+curln[curcol:]
            self.c=curcol+1
        self.wipe()
        self.render(color(0,255,0))
        
    def handleleft(self):
        if self.r==0 and self.c==0:
            self.stat('already at beginning')
        elif self.c>0:
            self.c-=1
        elif self.c==0 and self.r>0:
            rownum=self.r-1
            self.c=len(self.txt[rownum])
            self.r=rownum
            
    def handletop(self):
        if self.r==0:
            self.stat('already topmost line')
        else:
            prevlinum=self.r-1
            prevln=self.txt[prevlinum]
            if self.c>=len(prevln):
                self.c=len(prevln)-1
            self.r=prevlinum
    
    def handleright(self):
        currow=self.r
        curcol=self.c
        curln=self.txt[currow]
        if currow==len(self.txt)-1 and curcol==len(curln):
            self.stat('already at the end')
        elif curcol==len(curln) and currow<len(self.txt)-1:
            self.c=0
            self.r+=1
        else:
            self.c+=1
            
    def handledown(self):
        currow=self.r
        curcol=self.c
        curln=self.txt[currow]
        if currow==len(self.txt)-1:
            self.stat('already last line')
        else:
            nxtrow=currow+1
            nxtln=self.txt[nxtrow]
            if curcol>len(nxtln):
                self.c=len(nxtln)
            self.r=nxtrow
