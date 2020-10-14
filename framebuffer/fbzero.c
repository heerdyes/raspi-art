#include <assert.h>
#include <err.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sysexits.h>
#include <unistd.h>
#include <math.h>

const double PI=3.141592654;

// the rgb color structure
struct rgb{
  unsigned char r;
  unsigned char g;
  unsigned char b;
};

typedef struct rgb RGBCOLOR;

// the color constructor
RGBCOLOR* new_color(unsigned char _r,unsigned char _g,unsigned char _b){
  RGBCOLOR* color=malloc(sizeof(RGBCOLOR));
  color->r=_r;
  color->g=_g;
  color->b=_b;
  return color;
}

// function to compute the rgb integer from separate r,g,b bytes
int compute_rgb(RGBCOLOR color){
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
void dot(struct fb_var_screeninfo sinfo,uint32_t *fb,int x,int y,RGBCOLOR color){
  // compute rgb int
  int rgbnum=compute_rgb(color);
  // place pixel at (x,y)
  fb[y*sinfo.xres+x]=rgbnum;
}

// flow begins
int main(){
  const char *fbPath=getenv("FRAMEBUFFER");
  if(!fbPath) fbPath="/dev/fb0";

  int fb=open(fbPath,O_RDWR);
  if(fb<0) err(EX_OSFILE,"%s",fbPath);

  struct fb_var_screeninfo info;
  int error=ioctl(fb,FBIOGET_VSCREENINFO,&info);
  if(error) err(EX_IOERR,"%s",fbPath);

  size_t size=4*info.xres*info.yres;
  uint32_t *buf=mmap(NULL,size,PROT_READ|PROT_WRITE,MAP_SHARED,fb,0);
  if(buf==MAP_FAILED) err(EX_IOERR,"%s",fbPath);

  // genart code begins
  RGBCOLOR *yellow=new_color(0x44,0xFF,0xFF);
  double t=0.0;
  double r;
  int cx=1000,cy=400;
  for(int j=2;j<=20;j++){
    for(int i=0;i<360;i++){
      t=(PI/180)*i;
      r=j*10;
      double a=r+10*cos(t);
      double b=r+10*sin(t);
      double xx=cx+round(a*cos(t));
      double yy=cy-round(b*sin(t));
      dot(info,buf,xx,yy,*yellow);
    }
    t=0.0;
  }
}
