import turtle

t=turtle.Turtle()
t.speed(0)
t.up()
t.bk(100)
t.down()

s=turtle.Turtle()
s.speed(0)
s.up()
s.fd(100)
s.down()

for i in range(60):
    r=i/60
    g=1-i/60
    b=0.0
    if r>g:
        b=1.0
    t.pencolor(r,g,b)
    t.circle(60)
    t.rt(6)
    s.pencolor(b,r,g)
    s.circle(60)
    s.lt(6)
    
turtle.done()

