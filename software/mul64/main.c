#include "omsp_de1soc.h"

#define HW_A      (*(volatile unsigned long *)      0x140)
#define HW_B      (*(volatile unsigned long *)      0x144)
#define HW_RETVAL (*(volatile unsigned long long *) 0x148)
#define HW_CTL    (*(volatile unsigned *)           0x150)

unsigned long long mymul(unsigned long a, unsigned long b) {
   unsigned long long r;
   // compiler appears to generate __mspabi_mpyll for this multiply, which is wrong (signed)
   r = (unsigned long long) a * b;
   return r;
}

unsigned long long mymul_hw(unsigned long a, unsigned long b) {
  HW_A = a;
  HW_B = b;
  HW_CTL = 1;
  HW_CTL = 0;
  return HW_RETVAL;
}

unsigned count = 0;

unsigned TimerLap() {
  unsigned lap;
  TACTL &= ~(MC1 | MC0);
  lap = TAR - count;
  count = TAR;
  TACTL |= MC1;
  return lap;
}

char c16[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

void printfhex(int k) {
  putchar(c16[((k>>12) & 0xF)]);
  putchar(c16[((k>>8 ) & 0xF)]);
  putchar(c16[((k>>4 ) & 0xF)]);
  putchar(c16[((k    ) & 0xF)]);
  long_delay(300);
}

int main(void) {
  unsigned long long sw_tt;
  unsigned           sw_ct;
  unsigned long long hw_tt;
  unsigned           hw_ct;

  volatile unsigned long arga = 0x12345678UL;
  volatile unsigned long argb = 0x0000ABCDUL;
  
  TACTL  |= (TASSEL1 | MC1 | TACLR);
  de1soc_init();
  
  while (1) {

    TimerLap();
    sw_tt = mymul(arga, argb);
    sw_ct = TimerLap();

    TimerLap();
    hw_tt = mymul_hw(arga, argb);
    hw_ct = TimerLap();

    putchar('S');
    putchar('W');
    putchar(' ');
    
    printfhex(sw_tt >> 48);
    printfhex(sw_tt >> 32);
    printfhex(sw_tt >> 16);
    printfhex(sw_tt);
    
    putchar(' ');
    
    printfhex(sw_ct);
    
    putchar(' ');
    putchar('H');
    putchar('W');
    putchar(' ');
    
    printfhex(hw_tt >> 48);
    printfhex(hw_tt >> 32);
    printfhex(hw_tt >> 16);
    printfhex(hw_tt);
    
    putchar(' ');
    
    printfhex(hw_ct);
    
    putchar('\n');    
  }
  
  LPM0;
  
  return 0;
}
 
