// http://www.mathpropress.com/stan/bibliography/spigot.pdf

#define DIGITS 2000

void main(void) {
  unsigned int i, j;
  unsigned int q, r;
  unsigned int d[DIGITS+1];

  for(j = 0; j < DIGITS+1; j++) {
    d[j] = 1;
  }
  
  for(i = 0; i < DIGITS-1; i++) {
    for(j = 0; j < DIGITS+1; j++) {
      d[j] *= 10;
    }

    q = 0;
    for(j = DIGITS; j > 0; j--) {
      d[j] += q;
      q = d[j] / (j+1);
      r = d[j] % (j+1);
      d[j] = r;
    }
    
    putchar('0'+q);
  }
  puts("");
}
