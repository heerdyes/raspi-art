class FSM:
    def __init__(self,nstates,alphabet,transitionmatrix,currstate):
        self.nS=nstates
        self.A=alphabet
        self.TM=transitionmatrix
        self.currstate=currstate
    
    def accept(self,sym):
        if sym not in self.A:
            return
        symi=self.A.index(sym)
        print('index of %s -> %d'%(sym,symi))
        if self.TM[self.currstate][symi]!=None:
            self.currstate=self.TM[self.currstate][symi]
        else:
            raise Exception('undefined transition delta(%s,%s)'%(self.currstate,sym))
