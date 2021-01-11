class LShell:
    def __init__(self,x,y,w,h,c):
        self.x=x
        self.y=y
        self.w=w
        self.h=h
        self.c=c
        self.buf=[]
        self.name="L"
        self.currln=0
        self.lgap=14.0
        self.cgap=10.0
        self.currcol=0
        self.font=createFont("assets/ocr-a_regular.ttf",14)
  
    def render(self):
        # wipe area first
        fill(0)
        noStroke()
        rect(self.x,self.y,self.w,self.h)
        # now paint contents
        stroke(self.c)
        line(self.x,self.y,self.x+self.w,self.y)
        textSize(14)
        textAlign(LEFT,TOP)
        textFont(self.font)
        fill(self.c)
        for i,ln in enumerate(self.buf):
            h=self.y+i*self.lgap
            text("["+self.name+"] ",self.x,h)
            for j,c in enumerate(ln):
                text(c,self.x+self.cgap*j,h)
  
    def sensekey(self):
        if key=='q':
            exit()
        if keyCode==10:
            self.buf.append('')
            self.currln+=1
            self.currcol=0
            self.render()
        else:
            text(key,self.x+self.cgap*self.currcol,self.y+self.currln*self.lgap);
            self.currcol+=1
            print(keyCode)
