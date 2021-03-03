from tilingwm import *

""" a buf is the data model of the text content held by an ed """
class Buf:
    def __init__(self,nm,fp):
        self.nm=nm
        self.crow=0
        self.ccol=0
        self.data=['']
        self.filepath=fp
        
    def persist(self):
        with open(self.filepath,'w') as f:
            for ln in self.data:
                f.write(ln)
    
    def retrieve(self):
        with open(self.filepath) as f:
            self.data=f.readlines()
    
    def modify(self,k):
        currow=self.crow
        curcol=self.ccol
        curln=self.data[currow]
        if curcol==len(curln):
            self.data[currow]=curln+k
        else:
            self.data[currow]=curln[0:curcol]+k+curln[curcol:]
        self.ccol+=1
    
    def insline(self,linum,sdata):
        self.data.insert(linum,sdata)
    
    def newline(self):
        self.crow+=1
        self.insline(self.crow,'')
        self.ccol=0


""" a vu is a win, it must be managed by an scr """
class Vu(Win):
    def __init__(self,x,y,w,h,nm):
        Win.__init__(self,x,y,w,h,nm)
        self.buftop=5
        self.bufleft=26
        self.interlinespace=16
        self.statbarht=20
    
    def statbar(self,buf):
        yy=self.y+self.h-self.statbarht
        line(self.x,yy,self.x+self.w,yy)
        textAlign(LEFT,TOP)
        text('ready',self.x+8,yy)
        text('[%03d:%03d]'%(buf.crow,buf.ccol),self.x+self.w-86,yy)
    
    def render(self,buf):
        bufdata=buf.data
        Win.render(self)
        lnpos=self.y+self.topbarht+self.buftop
        linum=1
        for ln in bufdata:
            stroke(144)
            fill(144)
            text('%02d'%linum,self.x+3,lnpos)
            stroke(0,255,0)
            fill(0,255,0)
            text(ln,self.x+self.bufleft,lnpos)
            lnpos+=self.interlinespace
            linum+=1
        self.statbar(buf)


""" an editor can have multiple bufs but a single vu """
class Ed:
    def __init__(self,x,y,w,h,nm):
        self.bufs=[Buf(nm,'tmp.txt')]
        self.vu=Vu(x,y,w,h,nm)
        self.ibv=0
    
    def render(self):
        i=self.ibv
        self.vu.render(self.bufs[i])

    def sendkey(self,k,kc):
        i=self.ibv
        if kc==10:
            self.bufs[i].newline()
        else:
            self.bufs[i].modify(k)
        self.render()
