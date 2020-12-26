class FSM:
    def __init__(self,states,alphabet,transitionmatrix,currstate):
        self.S=states
        self.A=alphabet
        self.TM=transitionmatrix
        self.currstate=currstate
    
    def accept(self,sym):
        if sym not in self.A:
            return
        symi=self.A.index(sym)
        if self.TM[currstate][symi]:
            self.currstate=self.TM[currstate][symi]
        else:
            raise Exception('undefined transition delta(%s,%s)'%(self.currstate,sym))


class FSMView:
    def __init__(self,x,y,w,h,bg,fg,fsm):
        self.x=x
        self.y=y
        self.w=w
        self.h=h
        self.bg=bg
        self.fg=fg
        self.fsm=fsm
    
    def render():
        fill(self.bg)
        stroke(self.fg)
        rect(self.x,self.y,self.w,self.h)
        
    def transition(evt):
        pass
