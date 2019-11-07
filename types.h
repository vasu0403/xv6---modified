typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define maxage 30
int qSize[5];
int front[5], rear[5], qticks[5];
struct proc* q[5][100];
int isFull(int);
int isEmpty(int);
void enQueue(int, struct proc*);
struct proc* deQueue(int);