from kivy.app import App
from kivy.uix.widget import Widget
from kivy.graphics import *
from math import *
from random import random


class GenPaintWidget(Widget):
  def on_touch_down(self,touch):
    evtclsnm=touch.__class__.__name__
    if evtclsnm == 'HIDMotionEvent':
      print('ignoring HIDMotionEvent passing through')
      return
    print('[cls:%s] touched at (%d,%d)'%(evtclsnm,touch.x,touch.y))
    color=(random(),1.,1.)
    with self.canvas:
      Color(*color,mode='hsv')
      d=7.
      print(touch.ud)
      cx=touch.x
      cy=touch.y
      Ellipse(pos=(cx-d/2,cy-d/2),size=(d,d))
      touch.ud['line']=Line(points=(cx,cy))

  def on_touch_move(self,touch):
    if 'line' in touch.ud:
      touch.ud['line'].points+=[touch.x,touch.y]
    else:
      touch.ud['line']=Line(points=(touch.x,touch.y))


class GenPaintApp(App):
  def build(self):
    return GenPaintWidget()


if __name__ == '__main__':
  GenPaintApp().run()
