class Msg:
    def __init__(self,hd,bd):
        self.head=hd
        self.body=bd # use body as list: (car cdr)


class Pub:
    serialno=0
    def __init__(self):
        self.subs=[]
        self.pubid='%s_%04d'%(self.__class__.__name__,Pub.serialno)
        Pub.serialno+=1
    
    def publish(self,msg):
        for s in self.subs:
            if not isinstance(s,Sub):
                raise Exception('non-subscriber encountered!')
            m=Msg(self.pubid,msg)
            s.receive(m)
    
    def addsub(self,sub0):
        self.subs.append(sub0)


class Sub:
    def __init__(self,callback):
        self.receive=callback
        

class Binode:
    def __init__(self):
        self.a=None
        self.b=None
        self.up=None
    
    def rm(self):
        pass
