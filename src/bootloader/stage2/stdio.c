#include "stdio.h"
#include "x86.h"

void putc(char c)
{
  x86_Video_WriteCharTeletype(c,0);
}

void puts(const char* str)
{
  // prints signle chars until it finds the null terminator
  while(*str)
  {
    putc(*str);
    str++;
  }
}
