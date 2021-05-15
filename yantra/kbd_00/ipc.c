#include <string.h>
#include <unistd.h>
#include "ipc.h"

void idlespin(int n)
{
  int lim=n*1000;
  for(int i=0;i<lim;i++);
}

int main()
{
  char parent_msg[] = "hello";
  char child_msg[]  = "goodbye";
  char bcastmsg[]   = "....";

  printf("[main] creating shared memory...\n");
  void* shmem=create_shared_memory(16);

  printf("[debug] sizeof(parent_msg) = %d\n",sizeof(parent_msg));
  printf("[debug] sizeof(child_msg)  = %d\n",sizeof(child_msg));

  // parent speaks
  memcpy(shmem,parent_msg,sizeof(parent_msg));

  int pid=fork();

  if(pid==0)
  {
    // child scans character sequence
    for(;;)
    {
      printf("[pid:%d] %s\n",pid,shmem);
      if(strcmp(shmem,"stop")==0)
      {
		  printf("[pid:%d] recv stop signal! scan_stop\n",pid);
		  break;
	  }
      idlespin(250);
    }
    printf("[pid:%d] postloop\n",pid);
  }
  else
  {
    // parent generates character sequence with delay
    for(int i=0;i<10;i++)
    {
      for(int j=0;j<4;j++)
      {
        bcastmsg[j]=(char)('a'+((i*j)%26));
      }
      memcpy(shmem,bcastmsg,sizeof(bcastmsg));
      idlespin(1000);
    }
    // broadcast stop signal
    strcpy(bcastmsg,"stop");
    memcpy(shmem,bcastmsg,sizeof(bcastmsg));
  }
}
