// this struct is for reference
struct input_event
{
  struct timeval time;
  unsigned short type;
  unsigned short code;
  unsigned int value;
};

struct kbevt
{
    char keystate;
    unsigned short keycode;
};

void chkdev(FILE *fp)
{
	if(!fp)
	{
		printf("[chkdev] could not open device file!");
		exit(1);
	}
}

void dumpdata(unsigned char x[],int n)
{
  int i=0;
  printf("[dumpdata] ");
  for(;i<8;i++) {printf("%02x",x[i]);}
  printf(" ");
  for(;i<10;i++) {printf("%02x",x[i]);}
  printf(" ");
  for(;i<12;i++) {printf("%02x",x[i]);}
  printf(" ");
  for(i=0;i<n;i++)
  {
    printf("%02x",x[i]);
  }
  printf("\n");
}

unsigned int udcba(unsigned char a,unsigned char b,unsigned char c,unsigned char d)
{
  unsigned int t1=0;
  unsigned int t2=0;
  unsigned int t3=0;
  unsigned int res;
  
  // more bit magic
  t1=d;
  t1=t1<<24;
  t2=c;
  t2=t2<<16;
  t3=b;
  t3=t3<<8;
  res=t1|t2|t3|a;
  
  return res;
}

unsigned short uba(unsigned char a,unsigned char b)
{
  unsigned short tmp=0;
  unsigned short res;
  
  // bit magic ensues
  tmp=b;
  tmp=tmp<<8;
  res=tmp|a;
  
  return res;
}

void kbdctl(unsigned char kdata[],struct kbevt *keinfo)
{
    unsigned short etype;
	unsigned short ecode;
	unsigned int   evalue;
    struct kbevt *ke;
    
	etype=uba(kdata[8],kdata[9]);
	ecode=uba(kdata[10],kdata[11]);
	evalue=udcba(kdata[12],kdata[13],kdata[14],kdata[15]);
    
	if(etype==1 && evalue==1)
	{
        keinfo->keystate='D';
        keinfo->keycode=ecode;
	}
	else if(etype==1 && evalue==0)
	{
        keinfo->keystate='U';
        keinfo->keycode=ecode;
	}
}
