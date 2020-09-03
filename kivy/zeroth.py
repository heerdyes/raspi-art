from kivy.app import App
from kivy.uix.widget import Widget
from kivy.graphics import *
from math import *


class GenPaintWidget(Widget):
  def on_touch_down(self,touch):
    evtclsnm=touch.__class__.__name__
    if evtclsnm == 'HIDMotionEvent':
      print('ignoring HIDMotionEvent passing through')
      return
    print('[cls:%s] touched at (%d,%d)'%(evtclsnm,touch.x,touch.y))
    with self.canvas:
      Color(0.2,0.8,0.7,0.8)
      d1=30.
      d2=30.
      cx=touch.x
      cy=touch.y
      for i in range(180):
        t=i*pi/180
        Line(points=[cx+i,cy,cx+i,cy-d2*sin(4*t)],width=1)


class GenPaintApp(App):
  def build(self):
    return GenPaintWidget()


if __name__ == '__main__':
  GenPaintApp().run()
