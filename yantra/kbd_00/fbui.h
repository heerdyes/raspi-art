#include <assert.h>
#include <err.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sysexits.h>
#include <unistd.h>
#include <math.h>

const double PI=3.141592654;

// the rgb color structure
struct rgb
{
  unsigned char r;
  unsigned char g;
  unsigned char b;
};

typedef struct rgb RGBCOLOR;

// the color constructor
RGBCOLOR new_color(unsigned char _r,unsigned char _g,unsigned char _b)
{
  RGBCOLOR* color=malloc(sizeof(RGBCOLOR));
  color->r=_r;
  color->g=_g;
  color->b=_b;
  return *color;
}

// function to compute the rgb integer from separate r,g,b bytes
int compute_rgb(RGBCOLOR color)
{
  // r * 2^16
  // g * 2^8
  // b * 2^0
  int crgb=0,ir,ig,ib;
  ir=(int)color.r;
  crgb+=ir*pow(2,16);
  ig=(int)color.g;
  crgb+=ig*pow(2,8);
  ib=(int)color.b;
  crgb+=ib;
  return crgb;
}

// the basis of all geometry: the point
void dot(struct fb_var_screeninfo sinfo,uint32_t *fb,int x,int y,RGBCOLOR color)
{
  // compute rgb int
  int rgbnum=compute_rgb(color);
  // place pixel at (x,y)
  fb[y*sinfo.xres+x]=rgbnum;
}

void vertline(struct fb_var_screeninfo sinfo,uint32_t *fb,int x,int y1,int y2,RGBCOLOR color)
{
    int lo=y1<y2?y1:y2;
    int hi=y1>y2?y1:y2;
    for(int i=lo;i<=hi;i++)
    {
        dot(sinfo,fb,x,i,color);
    }
}

void horiline(struct fb_var_screeninfo sinfo,uint32_t *fb,int x1,int x2,int y,RGBCOLOR color)
{
    int lo=x1<x2?x1:x2;
    int hi=x1>x2?x1:x2;
    for(int i=lo;i<=hi;i++)
    {
        dot(sinfo,fb,i,y,color);
    }
}

void posline(struct fb_var_screeninfo sinfo,uint32_t *fb,int x1,int y1,int x2,int y2,RGBCOLOR color)
{
    // x1<x2
    float dx=(float)(x2-x1);
    float dy=(float)(y2-y1);
    float m=dy/dx;
    int   fx=y1;
    for(int ix=x1;ix<=x2;ix++)
    {
        fx=fx+(int)m;
        dot(sinfo,fb,ix,fx,color);
    }
}

void negline(struct fb_var_screeninfo sinfo,uint32_t *fb,int x1,int y1,int x2,int y2,RGBCOLOR color)
{
    // x1>x2
    posline(sinfo,fb,x2,y2,x1,y1,color);
}

void line(struct fb_var_screeninfo sinfo,uint32_t *fb,int x1,int y1,int x2,int y2,RGBCOLOR color)
{
    int dx=x2-x1;
    int dy=y2-y1;
    if      (dx==0) { vertline(sinfo,fb,x1,y1,y2,color); }
    else if (dy==0) { horiline(sinfo,fb,x1,x2,y1,color); }
    else
    {
        if(x1<x2) { posline(sinfo,fb,x1,y1,x2,y2,color); }
        else      { negline(sinfo,fb,x1,y1,x2,y2,color); }
    }
}

void strokerect(struct fb_var_screeninfo sinfo,uint32_t *fb,int x,int y,int w,int h,RGBCOLOR color)
{
    horiline(sinfo,fb,x,x+w,y,color);
    horiline(sinfo,fb,x,x+w,y+h,color);
    vertline(sinfo,fb,x,y,y+h,color);
    vertline(sinfo,fb,x+w,y,y+h,color);
}

void fillrect(struct fb_var_screeninfo sinfo,uint32_t *fb,int x,int y,int w,int h,RGBCOLOR color)
{
    for(int j=0;j<h;j++)
    {
        for(int i=0;i<w;i++)
        {
            dot(sinfo,fb,x+i,y+j,color);
        }
    }
}

void art00(struct fb_var_screeninfo info,uint32_t *buf,short kc)
{
  // genart code begins
  RGBCOLOR tronblue=new_color(0x44,0xFF,0xFF);
  double t=0.0;
  double r;
  int cx=1000,cy=400;
  for(int j=2;j<=20;j++)
  {
    for(int i=0;i<360;i++)
    {
      t=(PI/180)*i;
      r=j*10;
      double a=r+kc*cos(t);
      double b=r+kc*sin(t);
      double xx=cx+round(a*cos(t));
      double yy=cy-round(b*sin(t));
      dot(info,buf,xx,yy,tronblue);
    }
    t=0.0;
  }
}
