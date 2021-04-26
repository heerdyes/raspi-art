def w00(a,b,f,p,t):
    return a+b*sin(f*t+p)

def w01(a,b,f,p,t):
    return a+b*cos(f*t+p)

def h00(n,a,b,f,p,t):
    hs=a
    for i in range(n):
        hs+=w00(0,b*pow(0.5,i),f*pow(2,i),p,t)
    return hs
