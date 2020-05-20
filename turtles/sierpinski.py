import turtle
import random

turtle.speed(0)
turtle.bgcolor('black')
turtle.colormode(255)
turtle.pencolor(0,255,0)

def fd(x):
	turtle.fd(x)

def bk(x):
	turtle.bk(x)

def lt(a):
	turtle.lt(a)

def rt(a):
	turtle.rt(a)

def pu():
	turtle.up()

def pd():
	turtle.down()

def color(c):
	r,g,b=c
	turtle.pencolor(r,g,b)

def transition_color(a,b):
	r1=random.randint(a,b)
	g1=random.randint(a,b)
	b1=random.randint(a,b)
	return (r1,g1,b1)

def sierpinski(s,n):
	if n>0:
		c1=transition_color(16,240)
		color(c1)
		for i in range(3):
			fd(s)
			lt(120)
		fd(s/2)
		sierpinski(s/2,n-1)
		lt(120)
		pu()
		fd(s/2)
		pd()
		rt(120)
		sierpinski(s/2,n-1)
		lt(60)
		bk(s/2)
		rt(60)
		sierpinski(s/2,n-1)

def invoker(s,n):
	pu()
	bk(s/2)
	rt(90)
	fd(s/4)
	lt(90)
	pd()
	sierpinski(s,n)

# flow
invoker(512,7)
turtle.done()
