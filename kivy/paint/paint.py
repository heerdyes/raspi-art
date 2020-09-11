from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.graphics import *
from math import *
from random import random


class GenPaintWidget(Widget):
  def on_touch_down(self,touch):
    evtclsnm=touch.__class__.__name__
    if evtclsnm == 'HIDMotionEvent':
      print('ignoring HIDMotionEvent passing through')
      return
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
    wmain=Widget()
    self.paintarea=GenPaintWidget()
    bclear=Button(text='clear',width=80,height=30,pos=(0,0))
    bclear.bind(on_release=self.clear_canvas)
    wmain.add_widget(self.paintarea)
    wmain.add_widget(bclear)
    return wmain

  def clear_canvas(self,obj):
    self.paintarea.canvas.clear()


if __name__ == '__main__':
  GenPaintApp().run()
