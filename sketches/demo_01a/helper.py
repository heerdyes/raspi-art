def frmrect(x,y,w,h,m):
    line(x,y,x+m,y)
    line(x,y,x,y+m)
    line(x,y+h-m,x,y+h)
    line(x,y+h,x+m,y+h)
    line(x+w-m,y,x+w,y)
    line(x+w,y,x+w,y+m)
    line(x+w,y+h-m,x+w,y+h)
    line(x+w,y+h,x+w-m,y+h)
