#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

void* create_shared_memory(size_t size)
{
  int protection=PROT_READ | PROT_WRITE;
  int visibility=MAP_SHARED | MAP_ANONYMOUS;
  return mmap(NULL,size,protection,visibility,-1,0);
}

