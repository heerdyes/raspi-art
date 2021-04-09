def frmrect(x,y,w,h,m):
    line(x,y,x+m,y)
    line(x,y,x,y+m)
    line(x,y+h-m,x,y+h)
    line(x,y+h,x+m,y+h)
    line(x+w-m,y,x+w,y)
    line(x+w,y,x+w,y+m)
    line(x+w,y+h-m,x+w,y+h)
    line(x+w,y+h,x+w-m,y+h)

def drawcursor(x,y,w,h,d,c):
    stroke(c)
    line(x,y,x+w/2,y+d)
    line(x+w/2,y+d,x+w,y)
    line(x,y+h,x+w/2,y+h-d)
    line(x+w/2,y+h-d,x+w,y+h)
    
def drawhighlighter(x,y,w,h,c):
    stroke(c)
    line(x+1,y,x+w-2,y)
    line(x+1,y+h,x+w-2,y+h)
    noFill()

def drawlines(x,y,mt,txt,c1,c2):
    lnht=y+mt+10
    linum=0
    rowht=20
    colwt=8
    for ln in txt:
        stroke(c1)
        fill(c1)
        text('%02d'%linum,x+3,lnht)
        stroke(c2)
        fill(c2)
        text(ln,x+26,lnht)
        lnht+=rowht
        linum+=1

def wipetext(x,y,w,h,c,txt):
    fill(0)
    stroke(c)
    rect(x,y,w,h)
    fill(c)
    text(txt,x+10,y+10)
    noFill()

def wiperect(x,y,w,h,c):
    fill(0)
    stroke(c)
    rect(x,y,w,h)
    noFill()
    
