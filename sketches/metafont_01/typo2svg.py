import sys
import os

class Pen:
  def __init__(self):
    self.x=0
    self.y=0
    self.down=True
    
  def moveto(self,dx,dy,fp):
    newx=self.x+dx
    newy=self.y+dy
    if self.down:
      print('  <line x1="%f" y1="%f" x2="%f" y2="%f" stroke="black" style="stroke-width: 2;" />'%(self.x,self.y,newx,newy),file=fp)
    self.x=newx
    self.y=newy
  
  def circle(self,r,fp):
    if self.down:
      print('  <ellipse cx="%f" cy="%f" rx="%f" ry="%f" stroke="black" style="stroke-width: 2;" />'%(self.x,self.y,r,r),file=fp)
    
  def reset(self):
    self.x=0
    self.y=0
    self.down=True


if len(sys.argv)!=2:
  print('usage: python typo2svg.py <filename.typo>')
  exit()
  
ftypo=sys.argv[1]
svgdir=ftypo.split('.')[0]
p=Pen()
print('creating dir: %s'%svgdir)
os.mkdir(svgdir)

with open(ftypo) as ft:
  cmaplns=ft.readlines()

for ln in cmaplns:
  parts=ln.split('=>')
  c=parts[0]
  if c==' ':
    continue
  ilist=parts[1].rstrip().split(';')
  print('[codegen] working on file: %s/%s.svg'%(svgdir,c))
  p.reset()
  with open('%s/%s.svg'%(svgdir,c),'w') as fsvg:
    print('<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">',file=fsvg)
    for inst in ilist:
      if inst=='u':
        p.down=False
      elif inst=='d':
        p.down=True
      elif inst[0]=='c':
        cr=inst.split(' ')
        p.circle(float(cr[1]),fsvg)
      else:
        xy=inst.split(' ')
        p.moveto(float(xy[0]),float(xy[1]),fsvg)
    print('</svg>',file=fsvg)

