#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "kbd.h"

int main(int argc,char* argv[])
{
    FILE           *fptr;
    unsigned char  data[16];
    unsigned short etype,ecode;
    unsigned int   evalue;
    unsigned short tmps=0;
    unsigned int   tmpi=0;
    int             count=0;
    struct kbevt   *kd;
    
    kd=malloc(sizeof(struct kbevt));

    fptr=fopen("/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd","r");
    chkdev(fptr);

    while(1)
    {
        fread(data,sizeof(data),1,fptr);
        kbdctl(data,kd);
        if(kd->keystate=='D')
        {
            printf("[D] %03d\n",kd->keycode);
        }
        count+=1;
        if(kd->keycode==1) {break;}
    }

    fclose(fptr);
    return 0;
}
