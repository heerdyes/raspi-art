#include <string.h>
#include <unistd.h>
#include "ipc.h"
#include "kbd.h"
#include "fbui.h"

void idlespin(int n)
{
  int lim=n*1000;
  for(int i=0;i<lim;i++);
}

void recvloop(void *sm,int pid,struct fb_var_screeninfo info,uint32_t *buf)
{
    int framecount=0;
    float t=0.0;
    printf("[pid:%d]\n",pid);
	for(;;)
    {
        t=framecount*0.025;
        if(strcmp(sm,"STOP")==0)
        {
            printf("[pid:%d] recv stop signal! scan_stop\n",pid);
            break;
        }
        unsigned short kcode;
        sscanf(sm,"%03d",&kcode);
        strokerect(info,buf,150+100*sin(1.5*t),300,400+200*sin(t),200+100*sin(t),new_color(0,kcode%255,kcode%255));
        framecount+=1;
    }
}

void bcastloop(void *sm,char msg[],int msgsz,int pid,FILE *fptr)
{
	unsigned char data[16];
    struct kbevt  *kd;
    
    // init empty kbevt instance
    kd=malloc(sizeof(struct kbevt));
    
	for(;;)
	{
		fread(data,sizeof(data),1,fptr);
		kbdctl(data,kd);
        if(kd->keystate=='D')
        {
            sprintf(msg,"%03d",kd->keycode);
        }
        else if(kd->keystate=='U')
        {
            sprintf(msg,"000");
        }
		memcpy(sm,msg,msgsz);
        if(kd->keycode==1) {break;}
	}
    
    // broadcast stop signal
    strcpy(msg,"STOP");
    memcpy(sm,msg,msgsz);
}

int main()
{
	char bcastmsg[] =       "....";
	FILE                    *fptr;
	unsigned char           data[16];
	unsigned short          tmps=0;
	unsigned int            tmpi=0;
	int                      count=0;
    
    const char              *fbpath;
    int                      fb;
    struct fb_var_screeninfo info;
    int                      error;
    size_t                   size;
    uint32_t                *buf;
    
    // init framebuffer graphics
    fbpath=getenv("FRAMEBUFFER");
    if(!fbpath) {fbpath="/dev/fb0";}
    
    fb=open(fbpath,O_RDWR);
    if(fb<0) {err(EX_OSFILE,"%s",fbpath);}

    error=ioctl(fb,FBIOGET_VSCREENINFO,&info);
    if(error) {err(EX_IOERR,"%s",fbpath);}

    size=4*info.xres*info.yres;
    buf=mmap(NULL,size,PROT_READ|PROT_WRITE,MAP_SHARED,fb,0);
    if(buf==MAP_FAILED) {err(EX_IOERR,"%s",fbpath);}
	
	// init kbd
	fptr=fopen("/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd","r");
	chkdev(fptr);

	void* shmem=create_shared_memory(8);

	int pid=fork();

	if(pid==0)
	{
		// child proc scans broadcast char sequence
		recvloop(shmem,pid,info,buf);
	}
	else
	{
		// parent generates char sequence from kbdev
		bcastloop(shmem,bcastmsg,sizeof(bcastmsg),pid,fptr);
		printf("[pid:%d] closing device files...\n",pid);
		fclose(fptr);
        close(fb);
	}
}
