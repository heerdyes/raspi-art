class Win:
    def __init__(self,x,y,w,h,nm):
        self.x,self.y,self.w,self.h=x,y,w,h
        self.title=nm
        self.topbarht=24
        self.hleft=7
        self.htop=3
        self.font=createFont("assets/ocr-a_regular.ttf",14);
    
    def render(self):
        fill(0)
        rect(self.x,self.y,self.w,self.h)
        line(self.x,self.y+self.topbarht,self.x+self.w,self.y+self.topbarht)
        fill(0,255,0)
        textFont(self.font)
        textAlign(LEFT,TOP)
        textSize(14)
        text(self.title,self.x+self.hleft,self.y+self.htop)
        noFill()
        stroke(0,255,0)


class Scr:
    def __init__(self,x,y,w,h):
        self.x,self.y,self.w,self.h=x,y,w,h
        self.ml,self.mt,self.mr,self.mb=8,8,8,8
        self.wins=[]
        self.activwin=-1
    
    def addwin(self,w):
        nw=len(self.wins)
        self.wins.insert(nw,w)
    
    ''' todo '''
    def getwinbounds(self,splitcfg):
        if len(self.wins)==0 or self.activwin==-1:
            return (self.x+self.ml,self.y+self.mt,self.w-self.ml-self.mr,self.h-self.mt-self.mb)
        cw=self.wins[self.activwin]
        if splitcfg=='lr':
            cw.w=cw.w/2-5
            cw.render()
        elif splitcfg=='td':
            pass
    
    def wipe(self):
        fill(0)
        rect(self.x,self.y,self.w-1,self.h-1)
        noFill()
    
    def render(self):
        self.wipe()
        for w in self.wins:
            w.render()
    
    def keyevent(self,k,kc):
        print(k,kc)
        if k=='e':
            print('instantiating editor...')
