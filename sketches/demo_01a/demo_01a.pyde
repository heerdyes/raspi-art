from datetime import datetime

ml,mt,mr,mb=10,10,10,10
sbht=27
fontocra=None
kmode='cmd'
t=0.0
flipflop=False

wnds=[]
actwnd=-1

def frmrect(x,y,w,h,m):
    line(x,y,x+m,y)
    line(x,y,x,y+m)
    line(x,y+h-m,x,y+h)
    line(x,y+h,x+m,y+h)
    line(x+w-m,y,x+w,y)
    line(x+w,y,x+w,y+m)
    line(x+w,y+h-m,x+w,y+h)
    line(x+w,y+h,x+w-m,y+h)

def setup():
    global ml,mt,mr,mb,fontocra,wnds,actwnd
    size(1280,720)
    background(0)
    stroke(0,255,0)
    noFill()
    frmrect(ml,mt,width-ml-mr,height-mt-mb-sbht,10)
    fontocra=createFont('assets/ocr-a_regular.ttf',14)
    rootwnd={'x':ml+5,'y':mt+5,'w':width-ml-mr-10,'h':height-mt-mb-sbht-10}
    wnds.insert(0,rootwnd)
    actwnd=0
    render(rootwnd,color(0,255,0))

def draw():
    global t,flipflop
    if kmode=='edit':
        t+=0.05
        if frameCount%50==0:
            if flipflop:
                rendercursor(wnds[actwnd],color(0,255,0))
            else:
                rendercursor(wnds[actwnd],color(0,0,0))
            flipflop=not flipflop

def stat(msg):
    global fontocra
    fill(0)
    stroke(0)
    rect(0,height-sbht,width-1,height-sbht)
    stroke(0,255,0)
    fill(0,255,0)
    textFont(fontocra)
    textSize(14)
    textAlign(LEFT,TOP)
    text('| %s |'%msg,5,height-sbht+3)
    noFill()

def wipe(r):
    fill(0)
    stroke(0)
    rect(r['x'],r['y'],r['w'],r['h'])

def rendercursor(e,c):
    rowht=20
    colwt=8
    y=e['y']+e['mt']+10+e['r']*rowht
    x=e['x']+26+e['c']*colwt
    w=colwt
    h=rowht
    d=4
    stroke(c)
    line(x,y,x+w/2,y+d)
    line(x+w/2,y+d,x+w,y)
    line(x,y+h,x+w/2,y+h-d)
    line(x+w/2,y+h-d,x+w,y+h)

def renderhighlighter(e):
    rowht=20
    colwt=8
    y=e['y']+e['mt']+10+e['r']*rowht
    x=e['x']
    w=e['w']
    h=rowht
    stroke(0,92,0)
    line(x+1,y,x+w-2,y)
    line(x+1,y+h,x+w-2,y+h)
    noFill()

def renderstatus(e):
    sy=e['y']+e['h']-20
    stroke(0,144,0)
    line(e['x'],sy,e['x']+e['w'],sy)
    fill(0,255,0)
    text('| %03d:%03d |'%(e['r'],e['c']),e['x']+5,sy)
    noFill()

def rendereditor(e):
    line(e['x'],e['y']+e['mt'],e['x']+e['w'],e['y']+e['mt'])
    fill(0,255,0)
    text(e['nm'],e['x']+5,e['y']+2)
    lnht=e['y']+e['mt']+10
    linum=0
    rowht=20
    colwt=8
    for ln in e['txt']:
        stroke(0,144,0)
        fill(0,144,0)
        text('%02d'%linum,e['x']+3,lnht)
        stroke(0,255,0)
        fill(0,255,0)
        text(ln,e['x']+26,lnht)
        lnht+=rowht
        linum+=1
    renderhighlighter(e)
    rendercursor(e,color(0,192,0))
    renderstatus(e)

def render(r,c):
    noFill()
    stroke(c)
    rect(r['x'],r['y'],r['w'],r['h'])
    if 'txt' in r:
        rendereditor(r)

def mked(nm):
    global wnds
    if actwnd==-1:
        stat('no active window')
        return
    stat('ed...')
    wnds[actwnd]['nm']=nm
    wnds[actwnd]['txt']=['']
    wnds[actwnd]['r']=0
    wnds[actwnd]['c']=0
    wnds[actwnd]['mt']=24

def renderall():
    for i in range(len(wnds)):
        wipe(wnds[i])
        if i==actwnd:
            render(wnds[i],color(0,255,0))
        else:
            render(wnds[i],color(0,128,0))

def vsplit(frac):
    global wnds,actwnd
    stat('vertical split')
    cw=wnds[actwnd]
    wipe(cw)
    wfrac=frac*cw['w']
    rfrac=cw['w']-wfrac
    mp=cw['x']+wfrac
    cw['w']=wfrac-4
    nw={'x':mp+4,'y':cw['y'],'w':rfrac-4,'h':cw['h']}
    wnds.insert(actwnd+1,nw)

def hsplit(frac):
    global wnds,actwnd
    stat('horizontal split')
    cw=wnds[actwnd]
    wipe(cw)
    hfrac=frac*cw['h']
    rfrac=cw['h']-hfrac
    mp=cw['y']+hfrac
    cw['h']=hfrac-4
    nw={'x':cw['x'],'y':mp+4,'w':cw['w'],'h':rfrac-4}
    wnds.insert(actwnd+1,nw)

def cmdhandler(k,kc):
    global wnds,actwnd,kmode
    if k=='q':
        stat('bye!')
        exit()
    if k=='s':
        stat('screengrab')
        save('img/demo_01a_%s.png'%(datetime.today().strftime('%Y%m%d_%H%M%S')))
    elif k=='v':
        vsplit(0.5)
    elif k=='V':
        vsplit(0.75)
    elif k=='h':
        hsplit(0.5)
    elif k=='H':
        hsplit(0.75)
    elif k=='n':
        actwnd=(actwnd+1)%len(wnds)
        stat('active window index: %d'%actwnd)
    elif k=='p':
        actwnd-=1
        if actwnd<0:
            actwnd=len(wnds)-1
        stat('active window index: %d'%actwnd)
    elif k=='e':
        mked(str(random(1,100)))
    elif k=='i':
        if actwnd==-1:
            stat('no editor active!')
        elif 'txt' not in wnds[actwnd]:
            stat('active window is not an editor!')
        else:
            stat('- insert -')
            kmode='edit'
    renderall()

def edithandler(k,kc):
    global wnds
    currow=wnds[actwnd]['r']
    curcol=wnds[actwnd]['c']
    curln=wnds[actwnd]['txt'][currow]
    if kc==10:
        wnds[actwnd]['txt'].append('')
        wnds[actwnd]['r']=currow+1
        wnds[actwnd]['c']=0
    elif kc==8:
        modstr=curln[0:curcol]+curln[curcol+1:]
        print(modstr)
    elif kc==16:
        print('no special handling for shift')
    elif kc==20:
        print('no special handling for caps lock')
    elif kc==37:
        if wnds[actwnd]['r']==0 and wnds[actwnd]['c']==0:
            stat('already at beginning')
        elif wnds[actwnd]['c']>0:
            wnds[actwnd]['c']-=1
        elif wnds[actwnd]['c']==0 and wnds[actwnd]['r']>0:
            rownum=wnds[actwnd]['r']-1
            wnds[actwnd]['c']=len(wnds[actwnd]['txt'][rownum])
            wnds[actwnd]['r']=rownum
    elif kc==38:
        # left arrow
        if wnds[actwnd]['r']==0:
            stat('already topmost line')
        else:
            prevlinum=wnds[actwnd]['r']-1
            prevln=wnds[actwnd]['txt'][prevlinum]
            if wnds[actwnd]['c']>=len(prevln):
                wnds[actwnd]['c']=len(prevln)-1
            wnds[actwnd]['r']=prevlinum
    elif kc==39:
        # right arrow
        if currow==len(wnds[actwnd]['txt'])-1 and curcol==len(curln):
            stat('already at the end')
        elif curcol==len(curln) and currow<len(wnds[actwnd]['txt'])-1:
            wnds[actwnd]['c']=0
            wnds[actwnd]['r']+=1
        else:
            wnds[actwnd]['c']+=1
    elif kc==40:
        # down arrow
        if currow==len(wnds[actwnd]['txt'])-1:
            stat('already last line')
        else:
            nxtrow=currow+1
            nxtln=wnds[actwnd]['txt'][nxtrow]
            if curcol>len(nxtln):
                wnds[actwnd]['c']=len(nxtln)
            wnds[actwnd]['r']=nxtrow
    elif kc==35:
        print('end')
    elif kc==36:
        print('home')
    else:
        wnds[actwnd]['txt'][currow]=curln[0:curcol]+k+curln[curcol:]
        wnds[actwnd]['c']=curcol+1
    wipe(wnds[actwnd])
    render(wnds[actwnd],color(0,255,0))

def keyPressed():
    global kmode
    print('[%d] %s'%(keyCode,key))
    if keyCode==18:
        kmode='cmd'
        stat('- command -')
    elif kmode=='cmd':
        cmdhandler(key,keyCode)
    elif kmode=='edit':
        edithandler(key,keyCode)
    else:
        stat('unknown mode!')
