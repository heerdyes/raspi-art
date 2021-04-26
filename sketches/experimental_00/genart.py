from fnx import w00,w01,h00

def ga00(cx,cy,t):
    fx=w00(cx,30,1.66,0,t)
    gx=w00(cx,-30,1.66,0,t)
    fy=w00(cy,30,2.4,0,t)
    gy=w00(cy,-30,2.4,0,t)
    mf=w00(4,3,0.24,0,t)
    r=w00(300,50,mf,0,t)
    line(w00(fx,r,2,0,t),w00(fy,r,3.55,0,t),fx,fy)
    line(w00(gx,r,2,PI,t),w00(gy,r,3.5,PI,t),gx,gy)

def ga01(cx,cy,t):
    r=200
    lx=h00(1,cx,r,5,0,t)
    ly=h00(3,cy,-r,2.5,0,t)
    line(cx,cy,lx,ly)
