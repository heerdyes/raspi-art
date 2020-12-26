from turtle import *

bgcolor(0,0,0)
pencolor(0,0.75,0)
tracer(n=0,delay=0)

ltp=0.85
turn=20
for i in range(44100):
  fd(1)
  lt(turn)
  if i%360==0:
    turn*=ltp
  if i%450==0:
    if (turn+ltp)!=0:
      ltp*=(turn*turn)/((turn+ltp)**2)

exitonclick()

