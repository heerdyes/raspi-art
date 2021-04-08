from arch import *
from wnds import *
from helper import *
import os

class Ed(Wnd,Pub):
    def __init__(self,x,y,w,h,nm):
        Wnd.__init__(self,x,y,w,h,nm)
        Pub.__init__(self)
        self.txt=['']
        self.r=0
        self.c=0
        self.mt=24
    
    def rendercursor(self,c):
        rowht=20
        colwt=8
        y=self.y+self.mt+10+self.r*rowht
        x=self.x+26+self.c*colwt
        drawcursor(x,y,colwt,rowht,4,c)
    
    def renderhighlighter(self):
        rowht=20
        colwt=8
        y=self.y+self.mt+10+self.r*rowht
        drawhighlighter(self.x,y,self.w,rowht,color(0,92,0))
    
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
        drawlines(self.x,self.y,self.mt,self.txt,color(0,144,0),color(0,255,0))
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
            self.handleleft()
        elif kc==38:
            self.handletop()
        elif kc==39:
            self.handleright()
        elif kc==40:
            self.handledown()
        elif kc==35:
            self.handleend()
        elif kc==36:
            self.handlehome()
        else:
            self.txt[currow]=curln[0:curcol]+k+curln[curcol:]
            self.c=curcol+1
        self.wipe()
        self.render(color(0,255,0))
    
    def handleend(self):
        self.c=len(self.txt[self.r])
        
    def handlehome(self):
        self.c=0
        
    def handleleft(self):
        if self.r==0 and self.c==0:
            self.publish(['stat','already at beginning'])
        elif self.c>0:
            self.c-=1
        elif self.c==0 and self.r>0:
            rownum=self.r-1
            self.c=len(self.txt[rownum])
            self.r=rownum
            
    def handletop(self):
        if self.r==0:
            self.publish(['stat','already topmost line'])
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
            self.publish(['stat','already last line'])
        else:
            nxtrow=currow+1
            nxtln=self.txt[nxtrow]
            if curcol>len(nxtln):
                self.c=len(nxtln)
            self.r=nxtrow
    
    def savebuffer(self):
        cwd=os.getcwd()
        afp=os.path.join(cwd,'fs',self.nm)
        self.publish(['stat','saving to file: %s'%afp])
        with open(afp,'w') as f:
            for ln in self.txt:
                f.write('%s\n'%ln)
