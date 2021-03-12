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
