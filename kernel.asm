
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 34 c6 10 80       	mov    $0x8010c634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 7c 10 80       	push   $0x80107c20
80100051:	68 00 c6 10 80       	push   $0x8010c600
80100056:	e8 d5 4d 00 00       	call   80104e30 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c 0d 11 80 fc 	movl   $0x80110cfc,0x80110d4c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 0d 11 80 fc 	movl   $0x80110cfc,0x80110d50
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc 0c 11 80       	mov    $0x80110cfc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 7c 10 80       	push   $0x80107c27
80100097:	50                   	push   %eax
80100098:	e8 63 4c 00 00       	call   80104d00 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 0d 11 80       	mov    0x80110d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc 0c 11 80       	cmp    $0x80110cfc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 00 c6 10 80       	push   $0x8010c600
801000e4:	e8 87 4e 00 00       	call   80104f70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 0d 11 80    	mov    0x80110d50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 0d 11 80    	mov    0x80110d4c,%ebx
80100126:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 c6 10 80       	push   $0x8010c600
80100162:	e8 c9 4e 00 00       	call   80105030 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 4b 00 00       	call   80104d40 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 7c 10 80       	push   $0x80107c2e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 2d 4c 00 00       	call   80104de0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 7c 10 80       	push   $0x80107c3f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ec 4b 00 00       	call   80104de0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 4b 00 00       	call   80104da0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010020b:	e8 60 4d 00 00       	call   80104f70 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 50 0d 11 80       	mov    0x80110d50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 0d 11 80       	mov    0x80110d50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 c6 10 80 	movl   $0x8010c600,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 cf 4d 00 00       	jmp    80105030 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 7c 10 80       	push   $0x80107c46
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 df 4c 00 00       	call   80104f70 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 17 11 80    	mov    0x801117e0,%edx
801002a7:	39 15 e4 17 11 80    	cmp    %edx,0x801117e4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 e0 17 11 80       	push   $0x801117e0
801002c5:	e8 36 37 00 00       	call   80103a00 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 17 11 80    	mov    0x801117e0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 17 11 80    	cmp    0x801117e4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 34 00 00       	call   80103750 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 3c 4d 00 00       	call   80105030 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 17 11 80       	mov    %eax,0x801117e0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 17 11 80 	movsbl -0x7feee8a0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 de 4c 00 00       	call   80105030 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 17 11 80    	mov    %edx,0x801117e0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 7c 10 80       	push   $0x80107c4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 1b 82 10 80 	movl   $0x8010821b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 4a 00 00       	call   80104e50 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 7c 10 80       	push   $0x80107c61
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 63 00 00       	call   80106830 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 63 00 00       	call   80106830 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 63 00 00       	call   80106830 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 63 00 00       	call   80106830 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 07 4c 00 00       	call   80105130 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 3a 4b 00 00       	call   80105080 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 7c 10 80       	push   $0x80107c65
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 7c 10 80 	movzbl -0x7fef8370(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 50 49 00 00       	call   80104f70 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 e4 49 00 00       	call   80105030 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 0c 49 00 00       	call   80105030 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 7c 10 80       	mov    $0x80107c78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 7b 47 00 00       	call   80104f70 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 7c 10 80       	push   $0x80107c7f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 48 47 00 00       	call   80104f70 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 17 11 80       	mov    0x801117e8,%eax
80100856:	3b 05 e4 17 11 80    	cmp    0x801117e4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 17 11 80       	mov    %eax,0x801117e8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 a3 47 00 00       	call   80105030 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 17 11 80       	mov    0x801117e8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 17 11 80    	sub    0x801117e0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 17 11 80    	mov    %edx,0x801117e8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 17 11 80    	mov    %cl,-0x7feee8a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 17 11 80       	mov    0x801117e0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 17 11 80    	cmp    %eax,0x801117e8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 17 11 80       	mov    %eax,0x801117e4
          wakeup(&input.r);
80100911:	68 e0 17 11 80       	push   $0x801117e0
80100916:	e8 c5 33 00 00       	call   80103ce0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 17 11 80       	mov    0x801117e8,%eax
8010093d:	39 05 e4 17 11 80    	cmp    %eax,0x801117e4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 17 11 80       	mov    %eax,0x801117e8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 17 11 80       	mov    0x801117e8,%eax
80100964:	3b 05 e4 17 11 80    	cmp    0x801117e4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 17 11 80 0a 	cmpb   $0xa,-0x7feee8a0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 34 00 00       	jmp    80103dc0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 17 11 80 0a 	movb   $0xa,-0x7feee8a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 17 11 80       	mov    0x801117e8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 7c 10 80       	push   $0x80107c88
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 5b 44 00 00       	call   80104e30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 21 11 80 00 	movl   $0x80100600,0x801121ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 21 11 80 70 	movl   $0x80100270,0x801121a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 2f 2d 00 00       	call   80103750 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 e7 6e 00 00       	call   80107980 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 a5 6c 00 00       	call   801077a0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 b3 6b 00 00       	call   801076e0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 89 6d 00 00       	call   80107900 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 f1 6b 00 00       	call   801077a0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 6d 00 00       	call   80107900 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 7c 10 80       	push   $0x80107ca1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 6e 00 00       	call   80107a20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 62 46 00 00       	call   801052a0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 4f 46 00 00       	call   801052a0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 1e 6f 00 00       	call   80107b80 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 b4 6e 00 00       	call   80107b80 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 51 45 00 00       	call   80105260 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 17 68 00 00       	call   80107550 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 bf 6b 00 00       	call   80107900 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ad 7c 10 80       	push   $0x80107cad
80100d6b:	68 00 18 11 80       	push   $0x80111800
80100d70:	e8 bb 40 00 00       	call   80104e30 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 34 18 11 80       	mov    $0x80111834,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 00 18 11 80       	push   $0x80111800
80100d91:	e8 da 41 00 00       	call   80104f70 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 94 21 11 80    	cmp    $0x80112194,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 00 18 11 80       	push   $0x80111800
80100dc1:	e8 6a 42 00 00       	call   80105030 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 00 18 11 80       	push   $0x80111800
80100dda:	e8 51 42 00 00       	call   80105030 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 00 18 11 80       	push   $0x80111800
80100dff:	e8 6c 41 00 00       	call   80104f70 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 00 18 11 80       	push   $0x80111800
80100e1c:	e8 0f 42 00 00       	call   80105030 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 b4 7c 10 80       	push   $0x80107cb4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 00 18 11 80       	push   $0x80111800
80100e51:	e8 1a 41 00 00       	call   80104f70 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 00 18 11 80 	movl   $0x80111800,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 af 41 00 00       	jmp    80105030 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 00 18 11 80       	push   $0x80111800
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 83 41 00 00       	call   80105030 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 ba 24 00 00       	call   80103390 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 bc 7c 10 80       	push   $0x80107cbc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 6e 25 00 00       	jmp    80103540 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 c6 7c 10 80       	push   $0x80107cc6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 3e 23 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 cf 7c 10 80       	push   $0x80107ccf
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 d5 7c 10 80       	push   $0x80107cd5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 18 22 11 80    	add    0x80112218,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 df 7c 10 80       	push   $0x80107cdf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 00 22 11 80    	mov    0x80112200,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 18 22 11 80    	add    0x80112218,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 00 22 11 80       	mov    0x80112200,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 00 22 11 80    	cmp    %eax,0x80112200
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 f2 7c 10 80       	push   $0x80107cf2
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 16 3e 00 00       	call   80105080 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 54 22 11 80       	mov    $0x80112254,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 20 22 11 80       	push   $0x80112220
801012aa:	e8 c1 3c 00 00       	call   80104f70 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 74 3e 11 80    	cmp    $0x80113e74,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 74 3e 11 80    	cmp    $0x80113e74,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 20 22 11 80       	push   $0x80112220
8010130f:	e8 1c 3d 00 00       	call   80105030 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 20 22 11 80       	push   $0x80112220
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 ee 3c 00 00       	call   80105030 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 08 7d 10 80       	push   $0x80107d08
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 18 7d 10 80       	push   $0x80107d18
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 ca 3c 00 00       	call   80105130 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 60 22 11 80       	mov    $0x80112260,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 2b 7d 10 80       	push   $0x80107d2b
80101491:	68 20 22 11 80       	push   $0x80112220
80101496:	e8 95 39 00 00       	call   80104e30 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 32 7d 10 80       	push   $0x80107d32
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 4c 38 00 00       	call   80104d00 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 80 3e 11 80    	cmp    $0x80113e80,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 00 22 11 80       	push   $0x80112200
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 18 22 11 80    	pushl  0x80112218
801014d5:	ff 35 14 22 11 80    	pushl  0x80112214
801014db:	ff 35 10 22 11 80    	pushl  0x80112210
801014e1:	ff 35 0c 22 11 80    	pushl  0x8011220c
801014e7:	ff 35 08 22 11 80    	pushl  0x80112208
801014ed:	ff 35 04 22 11 80    	pushl  0x80112204
801014f3:	ff 35 00 22 11 80    	pushl  0x80112200
801014f9:	68 98 7d 10 80       	push   $0x80107d98
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d 08 22 11 80 01 	cmpl   $0x1,0x80112208
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 08 22 11 80    	cmp    %ebx,0x80112208
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 14 22 11 80    	add    0x80112214,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 ed 3a 00 00       	call   80105080 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 38 7d 10 80       	push   $0x80107d38
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 14 22 11 80    	add    0x80112214,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 fa 3a 00 00       	call   80105130 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 20 22 11 80       	push   $0x80112220
8010165f:	e8 0c 39 00 00       	call   80104f70 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
8010166f:	e8 bc 39 00 00       	call   80105030 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 99 36 00 00       	call   80104d40 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 14 22 11 80    	add    0x80112214,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 13 3a 00 00       	call   80105130 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 50 7d 10 80       	push   $0x80107d50
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 4a 7d 10 80       	push   $0x80107d4a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 68 36 00 00       	call   80104de0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 0c 36 00 00       	jmp    80104da0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 5f 7d 10 80       	push   $0x80107d5f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 7b 35 00 00       	call   80104d40 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 c1 35 00 00       	call   80104da0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801017e6:	e8 85 37 00 00       	call   80104f70 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 20 22 11 80 	movl   $0x80112220,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 2b 38 00 00       	jmp    80105030 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 20 22 11 80       	push   $0x80112220
80101810:	e8 5b 37 00 00       	call   80104f70 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
8010181f:	e8 0c 38 00 00       	call   80105030 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 24 37 00 00       	call   80105130 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 a0 21 11 80 	mov    -0x7feede60(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 28 36 00 00       	call   80105130 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 a4 21 11 80 	mov    -0x7feede5c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 fd 35 00 00       	call   801051a0 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 9e 35 00 00       	call   801051a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 79 7d 10 80       	push   $0x80107d79
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 67 7d 10 80       	push   $0x80107d67
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 d2 1a 00 00       	call   80103750 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 20 22 11 80       	push   $0x80112220
80101c89:	e8 e2 32 00 00       	call   80104f70 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80101c99:	e8 92 33 00 00       	call   80105030 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 36 34 00 00       	call   80105130 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 a3 33 00 00       	call   80105130 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 7e 33 00 00       	call   80105200 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 88 7d 10 80       	push   $0x80107d88
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 0a 84 10 80       	push   $0x8010840a
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 f4 7d 10 80       	push   $0x80107df4
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 eb 7d 10 80       	push   $0x80107deb
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 06 7e 10 80       	push   $0x80107e06
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 1b 2e 00 00       	call   80104e30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 40 45 11 80       	mov    0x80114540,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 dd 2e 00 00       	call   80104f70 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 ea 1b 00 00       	call   80103ce0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 1c 2f 00 00       	call   80105030 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 ad 2c 00 00       	call   80104de0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 03 2e 00 00       	call   80104f70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 42 18 00 00       	call   80103a00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 55 2e 00 00       	jmp    80105030 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 20 7e 10 80       	push   $0x80107e20
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 0a 7e 10 80       	push   $0x80107e0a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 35 7e 10 80       	push   $0x80107e35
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 74 3e 11 80 00 	movl   $0xfec00000,0x80113e74
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 74 3e 11 80       	mov    0x80113e74,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 a0 3f 11 80 	movzbl 0x80113fa0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 54 7e 10 80       	push   $0x80107e54
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 74 3e 11 80    	mov    0x80113e74,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 74 3e 11 80       	mov    0x80113e74,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb e8 79 11 80    	cmp    $0x801179e8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 39 2d 00 00       	call   80105080 <memset>

  if(kmem.use_lock)
80102347:	8b 15 b4 3e 11 80    	mov    0x80113eb4,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 b8 3e 11 80       	mov    0x80113eb8,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 b4 3e 11 80       	mov    0x80113eb4,%eax
  kmem.freelist = r;
80102360:	89 1d b8 3e 11 80    	mov    %ebx,0x80113eb8
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 80 3e 11 80 	movl   $0x80113e80,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 b0 2c 00 00       	jmp    80105030 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 80 3e 11 80       	push   $0x80113e80
80102388:	e8 e3 2b 00 00       	call   80104f70 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 86 7e 10 80       	push   $0x80107e86
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 8c 7e 10 80       	push   $0x80107e8c
80102400:	68 80 3e 11 80       	push   $0x80113e80
80102405:	e8 26 2a 00 00       	call   80104e30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 b4 3e 11 80 00 	movl   $0x0,0x80113eb4
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 b4 3e 11 80 01 	movl   $0x1,0x80113eb4
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 b4 3e 11 80       	mov    0x80113eb4,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 b8 3e 11 80       	mov    0x80113eb8,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 b8 3e 11 80    	mov    %edx,0x80113eb8
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 80 3e 11 80       	push   $0x80113e80
801024f3:	e8 78 2a 00 00       	call   80104f70 <acquire>
  r = kmem.freelist;
801024f8:	a1 b8 3e 11 80       	mov    0x80113eb8,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 b4 3e 11 80    	mov    0x80113eb4,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d b8 3e 11 80    	mov    %ecx,0x80113eb8
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 80 3e 11 80       	push   $0x80113e80
80102521:	e8 0a 2b 00 00       	call   80105030 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 c0 7e 10 80 	movzbl -0x7fef8140(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 a0 7e 10 80 	mov    -0x7fef8160(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 bc 3e 11 80       	mov    0x80113ebc,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 bc 3e 11 80    	mov    0x80113ebc,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 bc 3e 11 80       	mov    0x80113ebc,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 bc 3e 11 80       	mov    0x80113ebc,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 94 27 00 00       	call   801050d0 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d 08 3f 11 80    	mov    0x80113f08,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 f4 3e 11 80       	mov    0x80113ef4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 04 3f 11 80    	pushl  0x80113f04
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 0c 3f 11 80 	pushl  -0x7feec0f4(,%ebx,4)
80102a44:	ff 35 04 3f 11 80    	pushl  0x80113f04
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 c7 26 00 00       	call   80105130 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 08 3f 11 80    	cmp    %ebx,0x80113f08
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 f4 3e 11 80    	pushl  0x80113ef4
80102aae:	ff 35 04 3f 11 80    	pushl  0x80113f04
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 08 3f 11 80    	mov    0x80113f08,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a 0c 3f 11 80    	mov    -0x7feec0f4(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 c0 80 10 80       	push   $0x801080c0
80102b0f:	68 c0 3e 11 80       	push   $0x80113ec0
80102b14:	e8 17 23 00 00       	call   80104e30 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d 04 3f 11 80    	mov    %ebx,0x80113f04
  log.size = sb.nlog;
80102b32:	89 15 f8 3e 11 80    	mov    %edx,0x80113ef8
  log.start = sb.logstart;
80102b38:	a3 f4 3e 11 80       	mov    %eax,0x80113ef4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d 08 3f 11 80    	mov    %ebx,0x80113f08
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 08 3f 11 80    	mov    %ecx,-0x7feec0f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 08 3f 11 80 00 	movl   $0x0,0x80113f08
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 c0 3e 11 80       	push   $0x80113ec0
80102bab:	e8 c0 23 00 00       	call   80104f70 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 c0 3e 11 80       	push   $0x80113ec0
80102bc0:	68 c0 3e 11 80       	push   $0x80113ec0
80102bc5:	e8 36 0e 00 00       	call   80103a00 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 00 3f 11 80       	mov    0x80113f00,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
80102bdb:	8b 15 08 3f 11 80    	mov    0x80113f08,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 fc 3e 11 80       	mov    %eax,0x80113efc
      release(&log.lock);
80102bf7:	68 c0 3e 11 80       	push   $0x80113ec0
80102bfc:	e8 2f 24 00 00       	call   80105030 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 c0 3e 11 80       	push   $0x80113ec0
80102c1e:	e8 4d 23 00 00       	call   80104f70 <acquire>
  log.outstanding -= 1;
80102c23:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
  if(log.committing)
80102c28:	8b 35 00 3f 11 80    	mov    0x80113f00,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d fc 3e 11 80    	mov    %ebx,0x80113efc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 00 3f 11 80 01 	movl   $0x1,0x80113f00
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 c0 3e 11 80       	push   $0x80113ec0
80102c5c:	e8 cf 23 00 00       	call   80105030 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 08 3f 11 80    	mov    0x80113f08,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 f4 3e 11 80       	mov    0x80113ef4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 04 3f 11 80    	pushl  0x80113f04
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 0c 3f 11 80 	pushl  -0x7feec0f4(,%ebx,4)
80102c96:	ff 35 04 3f 11 80    	pushl  0x80113f04
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 75 24 00 00       	call   80105130 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 08 3f 11 80    	cmp    0x80113f08,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 08 3f 11 80 00 	movl   $0x0,0x80113f08
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 c0 3e 11 80       	push   $0x80113ec0
80102cff:	e8 6c 22 00 00       	call   80104f70 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 00 3f 11 80 00 	movl   $0x0,0x80113f00
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 c6 0f 00 00       	call   80103ce0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80102d21:	e8 0a 23 00 00       	call   80105030 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 c0 3e 11 80       	push   $0x80113ec0
80102d40:	e8 9b 0f 00 00       	call   80103ce0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80102d4c:	e8 df 22 00 00       	call   80105030 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 c4 80 10 80       	push   $0x801080c4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 08 3f 11 80    	mov    0x80113f08,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 f8 3e 11 80       	mov    0x80113ef8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 c0 3e 11 80       	push   $0x80113ec0
80102dae:	e8 bd 21 00 00       	call   80104f70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 08 3f 11 80    	mov    0x80113f08,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 0c 3f 11 80    	cmp    0x80113f0c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 0c 3f 11 80 	cmp    %edx,-0x7feec0f4(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 0c 3f 11 80 	mov    %edx,-0x7feec0f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 08 3f 11 80       	mov    %eax,0x80113f08
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 c0 3e 11 80 	movl   $0x80113ec0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 2e 22 00 00       	jmp    80105030 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 0c 3f 11 80 	mov    %edx,-0x7feec0f4(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 0c 3f 11 80       	mov    %eax,0x80113f0c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 d3 80 10 80       	push   $0x801080d3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 e9 80 10 80       	push   $0x801080e9
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 e4 08 00 00       	call   80103730 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 dd 08 00 00       	call   80103730 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 04 81 10 80       	push   $0x80108104
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 99 35 00 00       	call   80106400 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 44 08 00 00       	call   801036b0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 d1 17 00 00       	call   80104650 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 a5 46 00 00       	call   80107530 <switchkvm>
  seginit();
80102e8b:	e8 10 46 00 00       	call   801074a0 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
    front[i] = -1, rear[i] = -1, qSize[i] = 0, qticks[i] = (1<<i);
80102ea7:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102eac:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaf:	55                   	push   %ebp
80102eb0:	89 e5                	mov    %esp,%ebp
80102eb2:	53                   	push   %ebx
80102eb3:	51                   	push   %ecx
  for(int i=0; i<5; i++)
80102eb4:	31 c9                	xor    %ecx,%ecx
    front[i] = -1, rear[i] = -1, qSize[i] = 0, qticks[i] = (1<<i);
80102eb6:	89 d0                	mov    %edx,%eax
80102eb8:	c7 04 8d 6c 0f 11 80 	movl   $0xffffffff,-0x7feef094(,%ecx,4)
80102ebf:	ff ff ff ff 
80102ec3:	c7 04 8d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ecx,4)
80102eca:	ff ff ff ff 
80102ece:	d3 e0                	shl    %cl,%eax
80102ed0:	c7 04 8d d4 c5 10 80 	movl   $0x0,-0x7fef3a2c(,%ecx,4)
80102ed7:	00 00 00 00 
80102edb:	89 04 8d 58 0f 11 80 	mov    %eax,-0x7feef0a8(,%ecx,4)
  for(int i=0; i<5; i++)
80102ee2:	83 c1 01             	add    $0x1,%ecx
80102ee5:	83 f9 05             	cmp    $0x5,%ecx
80102ee8:	75 cc                	jne    80102eb6 <main+0x16>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eea:	83 ec 08             	sub    $0x8,%esp
80102eed:	68 00 00 40 80       	push   $0x80400000
80102ef2:	68 e8 79 11 80       	push   $0x801179e8
80102ef7:	e8 f4 f4 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102efc:	e8 ff 4a 00 00       	call   80107a00 <kvmalloc>
  mpinit();        // detect other processors
80102f01:	e8 7a 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f06:	e8 25 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102f0b:	e8 90 45 00 00       	call   801074a0 <seginit>
  picinit();       // disable pic
80102f10:	e8 4b 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f15:	e8 06 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102f1a:	e8 a1 da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f1f:	e8 4c 38 00 00       	call   80106770 <uartinit>
  pinit();         // process table
80102f24:	e8 67 07 00 00       	call   80103690 <pinit>
  tvinit();        // trap vectors
80102f29:	e8 52 34 00 00       	call   80106380 <tvinit>
  binit();         // buffer cache
80102f2e:	e8 0d d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f33:	e8 28 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f38:	e8 c3 f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f3d:	83 c4 0c             	add    $0xc,%esp
80102f40:	68 8a 00 00 00       	push   $0x8a
80102f45:	68 8c b4 10 80       	push   $0x8010b48c
80102f4a:	68 00 70 00 80       	push   $0x80007000
80102f4f:	e8 dc 21 00 00       	call   80105130 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f54:	69 05 40 45 11 80 b0 	imul   $0xb0,0x80114540,%eax
80102f5b:	00 00 00 
80102f5e:	83 c4 10             	add    $0x10,%esp
80102f61:	05 c0 3f 11 80       	add    $0x80113fc0,%eax
80102f66:	3d c0 3f 11 80       	cmp    $0x80113fc0,%eax
80102f6b:	76 76                	jbe    80102fe3 <main+0x143>
80102f6d:	bb c0 3f 11 80       	mov    $0x80113fc0,%ebx
80102f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(c == mycpu())  // We've started already.
80102f78:	e8 33 07 00 00       	call   801036b0 <mycpu>
80102f7d:	39 d8                	cmp    %ebx,%eax
80102f7f:	74 49                	je     80102fca <main+0x12a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f81:	e8 3a f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f86:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f8b:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f92:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f95:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f9c:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f9f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fa4:	0f b6 03             	movzbl (%ebx),%eax
80102fa7:	83 ec 08             	sub    $0x8,%esp
80102faa:	68 00 70 00 00       	push   $0x7000
80102faf:	50                   	push   %eax
80102fb0:	e8 cb f7 ff ff       	call   80102780 <lapicstartap>
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	90                   	nop
80102fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0x120>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 40 45 11 80 b0 	imul   $0xb0,0x80114540,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 c0 3f 11 80       	add    $0x80113fc0,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 95                	jb     80102f78 <main+0xd8>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 6b f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102ff5:	e8 56 12 00 00       	call   80104250 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 41 fe ff ff       	call   80102e40 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 18 81 10 80       	push   $0x80108118
80103033:	56                   	push   %esi
80103034:	e8 97 20 00 00       	call   801050d0 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 35 81 10 80       	push   $0x80108135
801030f1:	56                   	push   %esi
801030f2:	e8 d9 1f 00 00       	call   801050d0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 bc 3e 11 80       	mov    %eax,0x80113ebc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 5c 81 10 80 	jmp    *-0x7fef7ea4(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 40 45 11 80    	mov    0x80114540,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 40 45 11 80    	mov    %ecx,0x80114540
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 c0 3f 11 80    	mov    %dl,-0x7feec040(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 a0 3f 11 80    	mov    %dl,0x80113fa0
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 1d 81 10 80       	push   $0x8010811d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 3c 81 10 80       	push   $0x8010813c
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 e0 da ff ff       	call   80100d80 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 d5 da ff ff       	call   80100d80 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 0a f2 ff ff       	call   801024c0 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 69 db ff ff       	call   80100e40 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 41 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 70 81 10 80       	push   $0x80108170
80103340:	50                   	push   %eax
80103341:	e8 ea 1a 00 00       	call   80104e30 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 cc 1b 00 00       	call   80104f70 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 1c 09 00 00       	call   80103ce0 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 47 1c 00 00       	jmp    80105030 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 d7 08 00 00       	call   80103ce0 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 17 1c 00 00       	call   80105030 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 e6 ee ff ff       	jmp    80102310 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 2e 1b 00 00       	call   80104f70 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 47 08 00 00       	call   80103ce0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 5e 05 00 00       	call   80103a00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 87 02 00 00       	call   80103750 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 57 1b 00 00       	call   80105030 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 b8 07 00 00       	call   80103ce0 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 00 1b 00 00       	call   80105030 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 1b 1a 00 00       	call   80104f70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 76 04 00 00       	call   80103a00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 a2 01 00 00       	call   80103750 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 6d 1a 00 00       	call   80105030 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 c4 06 00 00       	call   80103ce0 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 0c 1a 00 00       	call   80105030 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103646:	68 60 45 11 80       	push   $0x80114560
8010364b:	e8 e0 19 00 00       	call   80105030 <release>

  if (first) {
80103650:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	85 c0                	test   %eax,%eax
8010365a:	75 04                	jne    80103660 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103660:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103663:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010366a:	00 00 00 
    iinit(ROOTDEV);
8010366d:	6a 01                	push   $0x1
8010366f:	e8 0c de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103674:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010367b:	e8 80 f4 ff ff       	call   80102b00 <initlog>
80103680:	83 c4 10             	add    $0x10,%esp
}
80103683:	c9                   	leave  
80103684:	c3                   	ret    
80103685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103690 <pinit>:
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103696:	68 75 81 10 80       	push   $0x80108175
8010369b:	68 60 45 11 80       	push   $0x80114560
801036a0:	e8 8b 17 00 00       	call   80104e30 <initlock>
}
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036b0 <mycpu>:
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036b5:	9c                   	pushf  
801036b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036b7:	f6 c4 02             	test   $0x2,%ah
801036ba:	75 5e                	jne    8010371a <mycpu+0x6a>
  apicid = lapicid();
801036bc:	e8 6f f0 ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801036c1:	8b 35 40 45 11 80    	mov    0x80114540,%esi
801036c7:	85 f6                	test   %esi,%esi
801036c9:	7e 42                	jle    8010370d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801036cb:	0f b6 15 c0 3f 11 80 	movzbl 0x80113fc0,%edx
801036d2:	39 d0                	cmp    %edx,%eax
801036d4:	74 30                	je     80103706 <mycpu+0x56>
801036d6:	b9 70 40 11 80       	mov    $0x80114070,%ecx
  for (i = 0; i < ncpu; ++i) {
801036db:	31 d2                	xor    %edx,%edx
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
801036e0:	83 c2 01             	add    $0x1,%edx
801036e3:	39 f2                	cmp    %esi,%edx
801036e5:	74 26                	je     8010370d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801036e7:	0f b6 19             	movzbl (%ecx),%ebx
801036ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036f0:	39 c3                	cmp    %eax,%ebx
801036f2:	75 ec                	jne    801036e0 <mycpu+0x30>
801036f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801036fa:	05 c0 3f 11 80       	add    $0x80113fc0,%eax
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
80103705:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103706:	b8 c0 3f 11 80       	mov    $0x80113fc0,%eax
      return &cpus[i];
8010370b:	eb f2                	jmp    801036ff <mycpu+0x4f>
  panic("unknown apicid\n");
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	68 7c 81 10 80       	push   $0x8010817c
80103715:	e8 76 cc ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 a4 82 10 80       	push   $0x801082a4
80103722:	e8 69 cc ff ff       	call   80100390 <panic>
80103727:	89 f6                	mov    %esi,%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <cpuid>:
cpuid() {
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103736:	e8 75 ff ff ff       	call   801036b0 <mycpu>
8010373b:	2d c0 3f 11 80       	sub    $0x80113fc0,%eax
}
80103740:	c9                   	leave  
  return mycpu()-cpus;
80103741:	c1 f8 04             	sar    $0x4,%eax
80103744:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010374a:	c3                   	ret    
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103750 <myproc>:
myproc(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103757:	e8 44 17 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010375c:	e8 4f ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103761:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103767:	e8 74 17 00 00       	call   80104ee0 <popcli>
}
8010376c:	83 c4 04             	add    $0x4,%esp
8010376f:	89 d8                	mov    %ebx,%eax
80103771:	5b                   	pop    %ebx
80103772:	5d                   	pop    %ebp
80103773:	c3                   	ret    
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <growproc>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103788:	e8 13 17 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010378d:	e8 1e ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103792:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103798:	e8 43 17 00 00       	call   80104ee0 <popcli>
  if(n > 0){
8010379d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801037a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801037a2:	7f 1c                	jg     801037c0 <growproc+0x40>
  } else if(n < 0){
801037a4:	75 3a                	jne    801037e0 <growproc+0x60>
  switchuvm(curproc);
801037a6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801037a9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801037ab:	53                   	push   %ebx
801037ac:	e8 9f 3d 00 00       	call   80107550 <switchuvm>
  return 0;
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	31 c0                	xor    %eax,%eax
}
801037b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b9:	5b                   	pop    %ebx
801037ba:	5e                   	pop    %esi
801037bb:	5d                   	pop    %ebp
801037bc:	c3                   	ret    
801037bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037c0:	83 ec 04             	sub    $0x4,%esp
801037c3:	01 c6                	add    %eax,%esi
801037c5:	56                   	push   %esi
801037c6:	50                   	push   %eax
801037c7:	ff 73 04             	pushl  0x4(%ebx)
801037ca:	e8 d1 3f 00 00       	call   801077a0 <allocuvm>
801037cf:	83 c4 10             	add    $0x10,%esp
801037d2:	85 c0                	test   %eax,%eax
801037d4:	75 d0                	jne    801037a6 <growproc+0x26>
      return -1;
801037d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037db:	eb d9                	jmp    801037b6 <growproc+0x36>
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e0:	83 ec 04             	sub    $0x4,%esp
801037e3:	01 c6                	add    %eax,%esi
801037e5:	56                   	push   %esi
801037e6:	50                   	push   %eax
801037e7:	ff 73 04             	pushl  0x4(%ebx)
801037ea:	e8 e1 40 00 00       	call   801078d0 <deallocuvm>
801037ef:	83 c4 10             	add    $0x10,%esp
801037f2:	85 c0                	test   %eax,%eax
801037f4:	75 b0                	jne    801037a6 <growproc+0x26>
801037f6:	eb de                	jmp    801037d6 <growproc+0x56>
801037f8:	90                   	nop
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103800 <sched>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  pushcli();
80103805:	e8 96 16 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010380a:	e8 a1 fe ff ff       	call   801036b0 <mycpu>
  p = c->proc;
8010380f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103815:	e8 c6 16 00 00       	call   80104ee0 <popcli>
  if(!holding(&ptable.lock))
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 60 45 11 80       	push   $0x80114560
80103822:	e8 19 17 00 00       	call   80104f40 <holding>
80103827:	83 c4 10             	add    $0x10,%esp
8010382a:	85 c0                	test   %eax,%eax
8010382c:	74 4f                	je     8010387d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010382e:	e8 7d fe ff ff       	call   801036b0 <mycpu>
80103833:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010383a:	75 68                	jne    801038a4 <sched+0xa4>
  if(p->state == RUNNING)
8010383c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103840:	74 55                	je     80103897 <sched+0x97>
80103842:	9c                   	pushf  
80103843:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103844:	f6 c4 02             	test   $0x2,%ah
80103847:	75 41                	jne    8010388a <sched+0x8a>
  intena = mycpu()->intena;
80103849:	e8 62 fe ff ff       	call   801036b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010384e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103851:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103857:	e8 54 fe ff ff       	call   801036b0 <mycpu>
8010385c:	83 ec 08             	sub    $0x8,%esp
8010385f:	ff 70 04             	pushl  0x4(%eax)
80103862:	53                   	push   %ebx
80103863:	e8 53 1a 00 00       	call   801052bb <swtch>
  mycpu()->intena = intena;
80103868:	e8 43 fe ff ff       	call   801036b0 <mycpu>
}
8010386d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103870:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103876:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103879:	5b                   	pop    %ebx
8010387a:	5e                   	pop    %esi
8010387b:	5d                   	pop    %ebp
8010387c:	c3                   	ret    
    panic("sched ptable.lock");
8010387d:	83 ec 0c             	sub    $0xc,%esp
80103880:	68 8c 81 10 80       	push   $0x8010818c
80103885:	e8 06 cb ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010388a:	83 ec 0c             	sub    $0xc,%esp
8010388d:	68 b8 81 10 80       	push   $0x801081b8
80103892:	e8 f9 ca ff ff       	call   80100390 <panic>
    panic("sched running");
80103897:	83 ec 0c             	sub    $0xc,%esp
8010389a:	68 aa 81 10 80       	push   $0x801081aa
8010389f:	e8 ec ca ff ff       	call   80100390 <panic>
    panic("sched locks");
801038a4:	83 ec 0c             	sub    $0xc,%esp
801038a7:	68 9e 81 10 80       	push   $0x8010819e
801038ac:	e8 df ca ff ff       	call   80100390 <panic>
801038b1:	eb 0d                	jmp    801038c0 <exit>
801038b3:	90                   	nop
801038b4:	90                   	nop
801038b5:	90                   	nop
801038b6:	90                   	nop
801038b7:	90                   	nop
801038b8:	90                   	nop
801038b9:	90                   	nop
801038ba:	90                   	nop
801038bb:	90                   	nop
801038bc:	90                   	nop
801038bd:	90                   	nop
801038be:	90                   	nop
801038bf:	90                   	nop

801038c0 <exit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801038c9:	e8 d2 15 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801038ce:	e8 dd fd ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801038d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801038d9:	e8 02 16 00 00       	call   80104ee0 <popcli>
  if(curproc == initproc)
801038de:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801038e4:	8d 5e 28             	lea    0x28(%esi),%ebx
801038e7:	8d 7e 68             	lea    0x68(%esi),%edi
801038ea:	0f 84 fc 00 00 00    	je     801039ec <exit+0x12c>
    if(curproc->ofile[fd]){
801038f0:	8b 03                	mov    (%ebx),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 12                	je     80103908 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	50                   	push   %eax
801038fa:	e8 41 d5 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801038ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010390b:	39 fb                	cmp    %edi,%ebx
8010390d:	75 e1                	jne    801038f0 <exit+0x30>
  begin_op();
8010390f:	e8 8c f2 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103914:	83 ec 0c             	sub    $0xc,%esp
80103917:	ff 76 68             	pushl  0x68(%esi)
8010391a:	e8 91 de ff ff       	call   801017b0 <iput>
  end_op();
8010391f:	e8 ec f2 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103924:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010392b:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80103932:	e8 39 16 00 00       	call   80104f70 <acquire>
  wakeup1(curproc->parent);
80103937:	8b 56 14             	mov    0x14(%esi),%edx
8010393a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010393d:	b8 94 45 11 80       	mov    $0x80114594,%eax
80103942:	eb 10                	jmp    80103954 <exit+0x94>
80103944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103948:	05 b0 00 00 00       	add    $0xb0,%eax
8010394d:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80103952:	73 1e                	jae    80103972 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103954:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103958:	75 ee                	jne    80103948 <exit+0x88>
8010395a:	3b 50 20             	cmp    0x20(%eax),%edx
8010395d:	75 e9                	jne    80103948 <exit+0x88>
    {  
      p->state = RUNNABLE;
8010395f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103966:	05 b0 00 00 00       	add    $0xb0,%eax
8010396b:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80103970:	72 e2                	jb     80103954 <exit+0x94>
      pq->parent = initproc;
80103972:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(pq = ptable.proc; pq < &ptable.proc[NPROC]; pq++){
80103978:	ba 94 45 11 80       	mov    $0x80114594,%edx
8010397d:	eb 0f                	jmp    8010398e <exit+0xce>
8010397f:	90                   	nop
80103980:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103986:	81 fa 94 71 11 80    	cmp    $0x80117194,%edx
8010398c:	73 3a                	jae    801039c8 <exit+0x108>
    if(pq->parent == curproc){
8010398e:	39 72 14             	cmp    %esi,0x14(%edx)
80103991:	75 ed                	jne    80103980 <exit+0xc0>
      if(pq->state == ZOMBIE)
80103993:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      pq->parent = initproc;
80103997:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(pq->state == ZOMBIE)
8010399a:	75 e4                	jne    80103980 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010399c:	b8 94 45 11 80       	mov    $0x80114594,%eax
801039a1:	eb 11                	jmp    801039b4 <exit+0xf4>
801039a3:	90                   	nop
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a8:	05 b0 00 00 00       	add    $0xb0,%eax
801039ad:	3d 94 71 11 80       	cmp    $0x80117194,%eax
801039b2:	73 cc                	jae    80103980 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801039b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039b8:	75 ee                	jne    801039a8 <exit+0xe8>
801039ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801039bd:	75 e9                	jne    801039a8 <exit+0xe8>
      p->state = RUNNABLE;
801039bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801039c6:	eb e0                	jmp    801039a8 <exit+0xe8>
  curproc->endTime = ticks;
801039c8:	a1 e0 79 11 80       	mov    0x801179e0,%eax
  curproc->state = ZOMBIE;
801039cd:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->endTime = ticks;
801039d4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
  sched();
801039da:	e8 21 fe ff ff       	call   80103800 <sched>
  panic("zombie exit");
801039df:	83 ec 0c             	sub    $0xc,%esp
801039e2:	68 d9 81 10 80       	push   $0x801081d9
801039e7:	e8 a4 c9 ff ff       	call   80100390 <panic>
    panic("init exiting");
801039ec:	83 ec 0c             	sub    $0xc,%esp
801039ef:	68 cc 81 10 80       	push   $0x801081cc
801039f4:	e8 97 c9 ff ff       	call   80100390 <panic>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a00 <sleep>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103a0f:	e8 8c 14 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80103a14:	e8 97 fc ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103a19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a1f:	e8 bc 14 00 00       	call   80104ee0 <popcli>
  if(p == 0)
80103a24:	85 db                	test   %ebx,%ebx
80103a26:	0f 84 87 00 00 00    	je     80103ab3 <sleep+0xb3>
  if(lk == 0)
80103a2c:	85 f6                	test   %esi,%esi
80103a2e:	74 76                	je     80103aa6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103a30:	81 fe 60 45 11 80    	cmp    $0x80114560,%esi
80103a36:	74 50                	je     80103a88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103a38:	83 ec 0c             	sub    $0xc,%esp
80103a3b:	68 60 45 11 80       	push   $0x80114560
80103a40:	e8 2b 15 00 00       	call   80104f70 <acquire>
    release(lk);
80103a45:	89 34 24             	mov    %esi,(%esp)
80103a48:	e8 e3 15 00 00       	call   80105030 <release>
  p->chan = chan;
80103a4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103a50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a57:	e8 a4 fd ff ff       	call   80103800 <sched>
  p->chan = 0;
80103a5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103a63:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80103a6a:	e8 c1 15 00 00       	call   80105030 <release>
    acquire(lk);
80103a6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103a72:	83 c4 10             	add    $0x10,%esp
}
80103a75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a78:	5b                   	pop    %ebx
80103a79:	5e                   	pop    %esi
80103a7a:	5f                   	pop    %edi
80103a7b:	5d                   	pop    %ebp
    acquire(lk);
80103a7c:	e9 ef 14 00 00       	jmp    80104f70 <acquire>
80103a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103a88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103a8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a92:	e8 69 fd ff ff       	call   80103800 <sched>
  p->chan = 0;
80103a97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa1:	5b                   	pop    %ebx
80103aa2:	5e                   	pop    %esi
80103aa3:	5f                   	pop    %edi
80103aa4:	5d                   	pop    %ebp
80103aa5:	c3                   	ret    
    panic("sleep without lk");
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	68 eb 81 10 80       	push   $0x801081eb
80103aae:	e8 dd c8 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ab3:	83 ec 0c             	sub    $0xc,%esp
80103ab6:	68 e5 81 10 80       	push   $0x801081e5
80103abb:	e8 d0 c8 ff ff       	call   80100390 <panic>

80103ac0 <wait>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
  pushcli();
80103ac5:	e8 d6 13 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80103aca:	e8 e1 fb ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103acf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ad5:	e8 06 14 00 00       	call   80104ee0 <popcli>
  acquire(&ptable.lock);
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 60 45 11 80       	push   $0x80114560
80103ae2:	e8 89 14 00 00       	call   80104f70 <acquire>
80103ae7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103aea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aec:	bb 94 45 11 80       	mov    $0x80114594,%ebx
80103af1:	eb 13                	jmp    80103b06 <wait+0x46>
80103af3:	90                   	nop
80103af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103afe:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
80103b04:	73 1e                	jae    80103b24 <wait+0x64>
      if(p->parent != curproc)
80103b06:	39 73 14             	cmp    %esi,0x14(%ebx)
80103b09:	75 ed                	jne    80103af8 <wait+0x38>
      if(p->state == ZOMBIE){
80103b0b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103b0f:	74 37                	je     80103b48 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b11:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80103b17:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1c:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
80103b22:	72 e2                	jb     80103b06 <wait+0x46>
    if(!havekids || curproc->killed){
80103b24:	85 c0                	test   %eax,%eax
80103b26:	74 76                	je     80103b9e <wait+0xde>
80103b28:	8b 46 24             	mov    0x24(%esi),%eax
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	75 6f                	jne    80103b9e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103b2f:	83 ec 08             	sub    $0x8,%esp
80103b32:	68 60 45 11 80       	push   $0x80114560
80103b37:	56                   	push   %esi
80103b38:	e8 c3 fe ff ff       	call   80103a00 <sleep>
    havekids = 0;
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	eb a8                	jmp    80103aea <wait+0x2a>
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103b48:	83 ec 0c             	sub    $0xc,%esp
80103b4b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103b4e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103b51:	e8 ba e7 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103b56:	5a                   	pop    %edx
80103b57:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103b5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103b61:	e8 9a 3d 00 00       	call   80107900 <freevm>
        release(&ptable.lock);
80103b66:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
        p->pid = 0;
80103b6d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103b74:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103b7b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103b7f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103b86:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103b8d:	e8 9e 14 00 00       	call   80105030 <release>
        return pid;
80103b92:	83 c4 10             	add    $0x10,%esp
}
80103b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b98:	89 f0                	mov    %esi,%eax
80103b9a:	5b                   	pop    %ebx
80103b9b:	5e                   	pop    %esi
80103b9c:	5d                   	pop    %ebp
80103b9d:	c3                   	ret    
      release(&ptable.lock);
80103b9e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ba1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ba6:	68 60 45 11 80       	push   $0x80114560
80103bab:	e8 80 14 00 00       	call   80105030 <release>
      return -1;
80103bb0:	83 c4 10             	add    $0x10,%esp
80103bb3:	eb e0                	jmp    80103b95 <wait+0xd5>
80103bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <waitx>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
  pushcli();
80103bc5:	e8 d6 12 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80103bca:	e8 e1 fa ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103bcf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103bd5:	e8 06 13 00 00       	call   80104ee0 <popcli>
  acquire(&ptable.lock);
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 60 45 11 80       	push   $0x80114560
80103be2:	e8 89 13 00 00       	call   80104f70 <acquire>
80103be7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103bea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bec:	bb 94 45 11 80       	mov    $0x80114594,%ebx
80103bf1:	eb 13                	jmp    80103c06 <waitx+0x46>
80103bf3:	90                   	nop
80103bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103bfe:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
80103c04:	73 1e                	jae    80103c24 <waitx+0x64>
      if(p->parent != curproc)
80103c06:	39 73 14             	cmp    %esi,0x14(%ebx)
80103c09:	75 ed                	jne    80103bf8 <waitx+0x38>
      if(p->state == ZOMBIE){
80103c0b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103c0f:	74 3f                	je     80103c50 <waitx+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c11:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
      havekids = 1;
80103c17:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c1c:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
80103c22:	72 e2                	jb     80103c06 <waitx+0x46>
    if(!havekids || curproc->killed){
80103c24:	85 c0                	test   %eax,%eax
80103c26:	0f 84 99 00 00 00    	je     80103cc5 <waitx+0x105>
80103c2c:	8b 46 24             	mov    0x24(%esi),%eax
80103c2f:	85 c0                	test   %eax,%eax
80103c31:	0f 85 8e 00 00 00    	jne    80103cc5 <waitx+0x105>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103c37:	83 ec 08             	sub    $0x8,%esp
80103c3a:	68 60 45 11 80       	push   $0x80114560
80103c3f:	56                   	push   %esi
80103c40:	e8 bb fd ff ff       	call   80103a00 <sleep>
    havekids = 0;
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	eb a0                	jmp    80103bea <waitx+0x2a>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103c56:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103c59:	e8 b2 e6 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103c5e:	5a                   	pop    %edx
80103c5f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103c62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103c69:	e8 92 3c 00 00       	call   80107900 <freevm>
        *rtime = p->runTime;
80103c6e:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80103c74:	8b 45 0c             	mov    0xc(%ebp),%eax
        p->pid = 0;
80103c77:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103c7e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103c85:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103c89:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103c90:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        *rtime = p->runTime;
80103c97:	89 10                	mov    %edx,(%eax)
        *wtime = p->endTime - p->startTime - p->runTime;
80103c99:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103c9f:	2b 53 7c             	sub    0x7c(%ebx),%edx
80103ca2:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
80103ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cab:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80103cad:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80103cb4:	e8 77 13 00 00       	call   80105030 <release>
        return pid;
80103cb9:	83 c4 10             	add    $0x10,%esp
}
80103cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cbf:	89 f0                	mov    %esi,%eax
80103cc1:	5b                   	pop    %ebx
80103cc2:	5e                   	pop    %esi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret    
      release(&ptable.lock);
80103cc5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103cc8:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ccd:	68 60 45 11 80       	push   $0x80114560
80103cd2:	e8 59 13 00 00       	call   80105030 <release>
      return -1;
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	eb e0                	jmp    80103cbc <waitx+0xfc>
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 10             	sub    $0x10,%esp
80103ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103cea:	68 60 45 11 80       	push   $0x80114560
80103cef:	e8 7c 12 00 00       	call   80104f70 <acquire>
80103cf4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf7:	b8 94 45 11 80       	mov    $0x80114594,%eax
80103cfc:	eb 0e                	jmp    80103d0c <wakeup+0x2c>
80103cfe:	66 90                	xchg   %ax,%ax
80103d00:	05 b0 00 00 00       	add    $0xb0,%eax
80103d05:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80103d0a:	73 1e                	jae    80103d2a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103d0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d10:	75 ee                	jne    80103d00 <wakeup+0x20>
80103d12:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d15:	75 e9                	jne    80103d00 <wakeup+0x20>
      p->state = RUNNABLE;
80103d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d1e:	05 b0 00 00 00       	add    $0xb0,%eax
80103d23:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80103d28:	72 e2                	jb     80103d0c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103d2a:	c7 45 08 60 45 11 80 	movl   $0x80114560,0x8(%ebp)
}
80103d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d34:	c9                   	leave  
  release(&ptable.lock);
80103d35:	e9 f6 12 00 00       	jmp    80105030 <release>
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 10             	sub    $0x10,%esp
80103d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103d4a:	68 60 45 11 80       	push   $0x80114560
80103d4f:	e8 1c 12 00 00       	call   80104f70 <acquire>
80103d54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d57:	b8 94 45 11 80       	mov    $0x80114594,%eax
80103d5c:	eb 0e                	jmp    80103d6c <kill+0x2c>
80103d5e:	66 90                	xchg   %ax,%ax
80103d60:	05 b0 00 00 00       	add    $0xb0,%eax
80103d65:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80103d6a:	73 34                	jae    80103da0 <kill+0x60>
    if(p->pid == pid){
80103d6c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103d6f:	75 ef                	jne    80103d60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103d71:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103d75:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103d7c:	75 07                	jne    80103d85 <kill+0x45>
        p->state = RUNNABLE;
80103d7e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103d85:	83 ec 0c             	sub    $0xc,%esp
80103d88:	68 60 45 11 80       	push   $0x80114560
80103d8d:	e8 9e 12 00 00       	call   80105030 <release>
      return 0;
80103d92:	83 c4 10             	add    $0x10,%esp
80103d95:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9a:	c9                   	leave  
80103d9b:	c3                   	ret    
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 60 45 11 80       	push   $0x80114560
80103da8:	e8 83 12 00 00       	call   80105030 <release>
  return -1;
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db8:	c9                   	leave  
80103db9:	c3                   	ret    
80103dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dc0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc9:	bb 94 45 11 80       	mov    $0x80114594,%ebx
{
80103dce:	83 ec 3c             	sub    $0x3c,%esp
80103dd1:	eb 27                	jmp    80103dfa <procdump+0x3a>
80103dd3:	90                   	nop
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 1b 82 10 80       	push   $0x8010821b
80103de0:	e8 7b c8 ff ff       	call   80100660 <cprintf>
80103de5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103dee:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
80103df4:	0f 83 86 00 00 00    	jae    80103e80 <procdump+0xc0>
    if(p->state == UNUSED)
80103dfa:	8b 43 0c             	mov    0xc(%ebx),%eax
80103dfd:	85 c0                	test   %eax,%eax
80103dff:	74 e7                	je     80103de8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e01:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103e04:	ba fc 81 10 80       	mov    $0x801081fc,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e09:	77 11                	ja     80103e1c <procdump+0x5c>
80103e0b:	8b 14 85 08 83 10 80 	mov    -0x7fef7cf8(,%eax,4),%edx
      state = "???";
80103e12:	b8 fc 81 10 80       	mov    $0x801081fc,%eax
80103e17:	85 d2                	test   %edx,%edx
80103e19:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103e1c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e1f:	50                   	push   %eax
80103e20:	52                   	push   %edx
80103e21:	ff 73 10             	pushl  0x10(%ebx)
80103e24:	68 00 82 10 80       	push   $0x80108200
80103e29:	e8 32 c8 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103e35:	75 a1                	jne    80103dd8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103e37:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103e3a:	83 ec 08             	sub    $0x8,%esp
80103e3d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103e40:	50                   	push   %eax
80103e41:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e44:	8b 40 0c             	mov    0xc(%eax),%eax
80103e47:	83 c0 08             	add    $0x8,%eax
80103e4a:	50                   	push   %eax
80103e4b:	e8 00 10 00 00       	call   80104e50 <getcallerpcs>
80103e50:	83 c4 10             	add    $0x10,%esp
80103e53:	90                   	nop
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103e58:	8b 17                	mov    (%edi),%edx
80103e5a:	85 d2                	test   %edx,%edx
80103e5c:	0f 84 76 ff ff ff    	je     80103dd8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103e62:	83 ec 08             	sub    $0x8,%esp
80103e65:	83 c7 04             	add    $0x4,%edi
80103e68:	52                   	push   %edx
80103e69:	68 61 7c 10 80       	push   $0x80107c61
80103e6e:	e8 ed c7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	39 fe                	cmp    %edi,%esi
80103e78:	75 de                	jne    80103e58 <procdump+0x98>
80103e7a:	e9 59 ff ff ff       	jmp    80103dd8 <procdump+0x18>
80103e7f:	90                   	nop
  }
}
80103e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e83:	5b                   	pop    %ebx
80103e84:	5e                   	pop    %esi
80103e85:	5f                   	pop    %edi
80103e86:	5d                   	pop    %ebp
80103e87:	c3                   	ret    
80103e88:	90                   	nop
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e90 <set_priority>:
  release(&ptable.lock);
}

int
set_priority(int new_priority, int pid)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 10             	sub    $0x10,%esp
80103e97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct proc* p;
  int prev_priority = -1;
  acquire(&ptable.lock);
80103e9a:	68 60 45 11 80       	push   $0x80114560
80103e9f:	e8 cc 10 00 00       	call   80104f70 <acquire>
80103ea4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea7:	ba 94 45 11 80       	mov    $0x80114594,%edx
80103eac:	eb 10                	jmp    80103ebe <set_priority+0x2e>
80103eae:	66 90                	xchg   %ax,%ax
80103eb0:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80103eb6:	81 fa 94 71 11 80    	cmp    $0x80117194,%edx
80103ebc:	73 32                	jae    80103ef0 <set_priority+0x60>
    if(p->pid == pid){
80103ebe:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103ec1:	75 ed                	jne    80103eb0 <set_priority+0x20>
      prev_priority = p->priority;
      p->priority = new_priority;
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
      prev_priority = p->priority;
80103ec6:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
      p->priority = new_priority;
80103ecc:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
      break; 
    }
  }
  release(&ptable.lock);
80103ed2:	83 ec 0c             	sub    $0xc,%esp
80103ed5:	68 60 45 11 80       	push   $0x80114560
80103eda:	e8 51 11 00 00       	call   80105030 <release>
  return prev_priority;
}
80103edf:	89 d8                	mov    %ebx,%eax
80103ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int prev_priority = -1;
80103ef0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ef5:	eb db                	jmp    80103ed2 <set_priority+0x42>
80103ef7:	89 f6                	mov    %esi,%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <isFull>:

int
isFull(int num)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
    if( (front[num] == rear[num] + 1) || (front[num] == 0 && rear[num] == 99)) return 1;
80103f07:	8b 0c 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%ecx
80103f0e:	8b 14 85 6c 0f 11 80 	mov    -0x7feef094(,%eax,4),%edx
80103f15:	b8 01 00 00 00       	mov    $0x1,%eax
80103f1a:	8d 59 01             	lea    0x1(%ecx),%ebx
80103f1d:	39 da                	cmp    %ebx,%edx
80103f1f:	74 0f                	je     80103f30 <isFull+0x30>
80103f21:	83 f9 63             	cmp    $0x63,%ecx
80103f24:	0f 94 c1             	sete   %cl
80103f27:	31 c0                	xor    %eax,%eax
80103f29:	85 d2                	test   %edx,%edx
80103f2b:	0f 94 c0             	sete   %al
80103f2e:	21 c8                	and    %ecx,%eax
    return 0;
}
80103f30:	5b                   	pop    %ebx
80103f31:	5d                   	pop    %ebp
80103f32:	c3                   	ret    
80103f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <isEmpty>:

int
isEmpty(int num)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
    if(front[num] == -1) return 1;
80103f43:	8b 45 08             	mov    0x8(%ebp),%eax
    return 0;
}
80103f46:	5d                   	pop    %ebp
    if(front[num] == -1) return 1;
80103f47:	83 3c 85 6c 0f 11 80 	cmpl   $0xffffffff,-0x7feef094(,%eax,4)
80103f4e:	ff 
80103f4f:	0f 94 c0             	sete   %al
80103f52:	0f b6 c0             	movzbl %al,%eax
}
80103f55:	c3                   	ret    
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <enQueue>:

void
enQueue(int num, struct proc* element)
{
80103f60:	55                   	push   %ebp
80103f61:	31 c9                	xor    %ecx,%ecx
80103f63:	89 e5                	mov    %esp,%ebp
80103f65:	57                   	push   %edi
80103f66:	56                   	push   %esi
80103f67:	53                   	push   %ebx

    for(int i = 0; i < 5; i++)
80103f68:	31 ff                	xor    %edi,%edi
{
80103f6a:	83 ec 1c             	sub    $0x1c,%esp
80103f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    {
      if(front[i] <= rear[i])
80103f76:	8b 14 bd 6c 0f 11 80 	mov    -0x7feef094(,%edi,4),%edx
80103f7d:	8b 34 bd c0 c5 10 80 	mov    -0x7fef3a40(,%edi,4),%esi
80103f84:	39 f2                	cmp    %esi,%edx
80103f86:	0f 8f c4 00 00 00    	jg     80104050 <enQueue+0xf0>
      {
        for(int j = front[i]; j>=0 && j <= rear[i]; j++)
80103f8c:	85 d2                	test   %edx,%edx
80103f8e:	78 2c                	js     80103fbc <enQueue+0x5c>
        {
          if(element == q[i][j])
80103f90:	6b c7 64             	imul   $0x64,%edi,%eax
80103f93:	01 d0                	add    %edx,%eax
80103f95:	3b 1c 85 80 0f 11 80 	cmp    -0x7feef080(,%eax,4),%ebx
80103f9c:	75 17                	jne    80103fb5 <enQueue+0x55>
80103f9e:	e9 a3 00 00 00       	jmp    80104046 <enQueue+0xe6>
80103fa3:	90                   	nop
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa8:	39 9c 91 80 0f 11 80 	cmp    %ebx,-0x7feef080(%ecx,%edx,4)
80103faf:	0f 84 91 00 00 00    	je     80104046 <enQueue+0xe6>
        for(int j = front[i]; j>=0 && j <= rear[i]; j++)
80103fb5:	83 c2 01             	add    $0x1,%edx
80103fb8:	39 d6                	cmp    %edx,%esi
80103fba:	7d ec                	jge    80103fa8 <enQueue+0x48>
    for(int i = 0; i < 5; i++)
80103fbc:	83 c7 01             	add    $0x1,%edi
80103fbf:	81 c1 90 01 00 00    	add    $0x190,%ecx
80103fc5:	83 ff 05             	cmp    $0x5,%edi
80103fc8:	75 ac                	jne    80103f76 <enQueue+0x16>
    if( (front[num] == rear[num] + 1) || (front[num] == 0 && rear[num] == 99)) return 1;
80103fca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103fcd:	8b 14 bd c0 c5 10 80 	mov    -0x7fef3a40(,%edi,4),%edx
80103fd4:	8b 04 bd 6c 0f 11 80 	mov    -0x7feef094(,%edi,4),%eax
80103fdb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103fde:	39 c8                	cmp    %ecx,%eax
80103fe0:	0f 84 b9 00 00 00    	je     8010409f <enQueue+0x13f>
80103fe6:	85 c0                	test   %eax,%eax
80103fe8:	0f 84 92 00 00 00    	je     80104080 <enQueue+0x120>
    }

      if(isFull(num)) cprintf("\n Queue is full!! \n");
      else
      {
          qSize[num]++;
80103fee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
          element -> curTime = 0;
80103ff1:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80103ff8:	00 00 00 
          qSize[num]++;
80103ffb:	83 04 bd d4 c5 10 80 	addl   $0x1,-0x7fef3a2c(,%edi,4)
80104002:	01 
          if(front[num] == -1) front[num] = 0;
80104003:	83 f8 ff             	cmp    $0xffffffff,%eax
80104006:	75 0e                	jne    80104016 <enQueue+0xb6>
80104008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010400b:	c7 04 85 6c 0f 11 80 	movl   $0x0,-0x7feef094(,%eax,4)
80104012:	00 00 00 00 
          rear[num] = (rear[num] + 1) % 100;
80104016:	89 c8                	mov    %ecx,%eax
80104018:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010401d:	f7 ea                	imul   %edx
8010401f:	89 c8                	mov    %ecx,%eax
80104021:	c1 f8 1f             	sar    $0x1f,%eax
80104024:	c1 fa 05             	sar    $0x5,%edx
80104027:	29 c2                	sub    %eax,%edx
80104029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010402c:	6b d2 64             	imul   $0x64,%edx,%edx
8010402f:	29 d1                	sub    %edx,%ecx
80104031:	89 0c 85 c0 c5 10 80 	mov    %ecx,-0x7fef3a40(,%eax,4)
80104038:	89 ca                	mov    %ecx,%edx
          q[num][rear[num]] = element;
8010403a:	6b c0 64             	imul   $0x64,%eax,%eax
8010403d:	01 c2                	add    %eax,%edx
8010403f:	89 1c 95 80 0f 11 80 	mov    %ebx,-0x7feef080(,%edx,4)
      }
}
80104046:	83 c4 1c             	add    $0x1c,%esp
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5f                   	pop    %edi
8010404c:	5d                   	pop    %ebp
8010404d:	c3                   	ret    
8010404e:	66 90                	xchg   %ax,%ax
        for(int j = 0; j < 100; j++)
80104050:	31 c0                	xor    %eax,%eax
80104052:	eb 10                	jmp    80104064 <enQueue+0x104>
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	83 c0 01             	add    $0x1,%eax
8010405b:	83 f8 64             	cmp    $0x64,%eax
8010405e:	0f 84 58 ff ff ff    	je     80103fbc <enQueue+0x5c>
          if(j <= rear[i] || j >= front[i])
80104064:	39 c2                	cmp    %eax,%edx
80104066:	7e 04                	jle    8010406c <enQueue+0x10c>
80104068:	39 c6                	cmp    %eax,%esi
8010406a:	7c ec                	jl     80104058 <enQueue+0xf8>
            if(element == q[i][j])
8010406c:	39 9c 81 80 0f 11 80 	cmp    %ebx,-0x7feef080(%ecx,%eax,4)
80104073:	75 e3                	jne    80104058 <enQueue+0xf8>
}
80104075:	83 c4 1c             	add    $0x1c,%esp
80104078:	5b                   	pop    %ebx
80104079:	5e                   	pop    %esi
8010407a:	5f                   	pop    %edi
8010407b:	5d                   	pop    %ebp
8010407c:	c3                   	ret    
8010407d:	8d 76 00             	lea    0x0(%esi),%esi
    if( (front[num] == rear[num] + 1) || (front[num] == 0 && rear[num] == 99)) return 1;
80104080:	83 fa 63             	cmp    $0x63,%edx
80104083:	74 1a                	je     8010409f <enQueue+0x13f>
          qSize[num]++;
80104085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
          element -> curTime = 0;
80104088:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
8010408f:	00 00 00 
          qSize[num]++;
80104092:	83 04 85 d4 c5 10 80 	addl   $0x1,-0x7fef3a2c(,%eax,4)
80104099:	01 
8010409a:	e9 77 ff ff ff       	jmp    80104016 <enQueue+0xb6>
      if(isFull(num)) cprintf("\n Queue is full!! \n");
8010409f:	c7 45 08 09 82 10 80 	movl   $0x80108209,0x8(%ebp)
}
801040a6:	83 c4 1c             	add    $0x1c,%esp
801040a9:	5b                   	pop    %ebx
801040aa:	5e                   	pop    %esi
801040ab:	5f                   	pop    %edi
801040ac:	5d                   	pop    %ebp
      if(isFull(num)) cprintf("\n Queue is full!! \n");
801040ad:	e9 ae c5 ff ff       	jmp    80100660 <cprintf>
801040b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040c0 <allocproc>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c5:	bb 94 45 11 80       	mov    $0x80114594,%ebx
  acquire(&ptable.lock);
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 60 45 11 80       	push   $0x80114560
801040d2:	e8 99 0e 00 00       	call   80104f70 <acquire>
801040d7:	83 c4 10             	add    $0x10,%esp
801040da:	eb 16                	jmp    801040f2 <allocproc+0x32>
801040dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e0:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801040e6:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
801040ec:	0f 83 2e 01 00 00    	jae    80104220 <allocproc+0x160>
    if(p->state == UNUSED)
801040f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801040f5:	85 c0                	test   %eax,%eax
801040f7:	75 e7                	jne    801040e0 <allocproc+0x20>
  p->pid = nextpid++;
801040f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->state = EMBRYO;
801040fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->runTime = 0;                               // default value
80104105:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010410c:	00 00 00 
  p->endTime = 0;                               // default value
8010410f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104116:	00 00 00 
  p->wait_queue_time = 0;                       // default value
80104119:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104120:	00 00 00 
  p->priority = 60;                             // default priority
80104123:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
8010412a:	00 00 00 
  p->pid = nextpid++;
8010412d:	8d 50 01             	lea    0x1(%eax),%edx
80104130:	89 43 10             	mov    %eax,0x10(%ebx)
  p->startTime = ticks;
80104133:	a1 e0 79 11 80       	mov    0x801179e0,%eax
  p->queue = 0;                                 // default queue for MLFQ Scheduling
80104138:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
8010413f:	00 00 00 
  p->curTime = 0;
80104142:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80104149:	00 00 00 
  p->pid = nextpid++;
8010414c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->num_run = 0;
80104152:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104159:	00 00 00 
  p->startTime = ticks;
8010415c:	89 43 7c             	mov    %eax,0x7c(%ebx)
    p->time[i] = 0;
8010415f:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104166:	00 00 00 
    for(int i=0; i<5; i++) {
80104169:	31 c0                	xor    %eax,%eax
    p->time[i] = 0;
8010416b:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104172:	00 00 00 
80104175:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010417c:	00 00 00 
8010417f:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80104186:	00 00 00 
80104189:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80104190:	00 00 00 
    if( (front[num] == rear[num] + 1) || (front[num] == 0 && rear[num] == 99)) return 1;
80104193:	8b 14 85 c0 c5 10 80 	mov    -0x7fef3a40(,%eax,4),%edx
8010419a:	8b 0c 85 6c 0f 11 80 	mov    -0x7feef094(,%eax,4),%ecx
801041a1:	8d 72 01             	lea    0x1(%edx),%esi
801041a4:	39 f1                	cmp    %esi,%ecx
801041a6:	74 09                	je     801041b1 <allocproc+0xf1>
801041a8:	83 fa 63             	cmp    $0x63,%edx
801041ab:	75 63                	jne    80104210 <allocproc+0x150>
801041ad:	85 c9                	test   %ecx,%ecx
801041af:	75 5f                	jne    80104210 <allocproc+0x150>
    for(int i=0; i<5; i++) {
801041b1:	83 c0 01             	add    $0x1,%eax
801041b4:	83 f8 05             	cmp    $0x5,%eax
801041b7:	75 da                	jne    80104193 <allocproc+0xd3>
  release(&ptable.lock);
801041b9:	83 ec 0c             	sub    $0xc,%esp
801041bc:	68 60 45 11 80       	push   $0x80114560
801041c1:	e8 6a 0e 00 00       	call   80105030 <release>
  if((p->kstack = kalloc()) == 0){
801041c6:	e8 f5 e2 ff ff       	call   801024c0 <kalloc>
801041cb:	83 c4 10             	add    $0x10,%esp
801041ce:	85 c0                	test   %eax,%eax
801041d0:	89 43 08             	mov    %eax,0x8(%ebx)
801041d3:	74 66                	je     8010423b <allocproc+0x17b>
  sp -= sizeof *p->tf;
801041d5:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801041db:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801041de:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801041e3:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801041e6:	c7 40 14 67 63 10 80 	movl   $0x80106367,0x14(%eax)
  p->context = (struct context*)sp;
801041ed:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801041f0:	6a 14                	push   $0x14
801041f2:	6a 00                	push   $0x0
801041f4:	50                   	push   %eax
801041f5:	e8 86 0e 00 00       	call   80105080 <memset>
  p->context->eip = (uint)forkret;
801041fa:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801041fd:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104200:	c7 40 10 40 36 10 80 	movl   $0x80103640,0x10(%eax)
}
80104207:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010420a:	89 d8                	mov    %ebx,%eax
8010420c:	5b                   	pop    %ebx
8010420d:	5e                   	pop    %esi
8010420e:	5d                   	pop    %ebp
8010420f:	c3                   	ret    
        enQueue(i, p);
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	53                   	push   %ebx
80104214:	50                   	push   %eax
80104215:	e8 46 fd ff ff       	call   80103f60 <enQueue>
        break;
8010421a:	83 c4 10             	add    $0x10,%esp
8010421d:	eb 9a                	jmp    801041b9 <allocproc+0xf9>
8010421f:	90                   	nop
  release(&ptable.lock);
80104220:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104223:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104225:	68 60 45 11 80       	push   $0x80114560
8010422a:	e8 01 0e 00 00       	call   80105030 <release>
  return 0;
8010422f:	83 c4 10             	add    $0x10,%esp
}
80104232:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104235:	89 d8                	mov    %ebx,%eax
80104237:	5b                   	pop    %ebx
80104238:	5e                   	pop    %esi
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret    
    p->state = UNUSED;
8010423b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104242:	31 db                	xor    %ebx,%ebx
80104244:	eb c1                	jmp    80104207 <allocproc+0x147>
80104246:	8d 76 00             	lea    0x0(%esi),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <userinit>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104257:	e8 64 fe ff ff       	call   801040c0 <allocproc>
8010425c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010425e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104263:	e8 18 37 00 00       	call   80107980 <setupkvm>
80104268:	85 c0                	test   %eax,%eax
8010426a:	89 43 04             	mov    %eax,0x4(%ebx)
8010426d:	0f 84 bd 00 00 00    	je     80104330 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104273:	83 ec 04             	sub    $0x4,%esp
80104276:	68 2c 00 00 00       	push   $0x2c
8010427b:	68 60 b4 10 80       	push   $0x8010b460
80104280:	50                   	push   %eax
80104281:	e8 da 33 00 00       	call   80107660 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104286:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104289:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010428f:	6a 4c                	push   $0x4c
80104291:	6a 00                	push   $0x0
80104293:	ff 73 18             	pushl  0x18(%ebx)
80104296:	e8 e5 0d 00 00       	call   80105080 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010429b:	8b 43 18             	mov    0x18(%ebx),%eax
8010429e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042a3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042a8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042af:	8b 43 18             	mov    0x18(%ebx),%eax
801042b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042b6:	8b 43 18             	mov    0x18(%ebx),%eax
801042b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042bd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042c1:	8b 43 18             	mov    0x18(%ebx),%eax
801042c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042c8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042cc:	8b 43 18             	mov    0x18(%ebx),%eax
801042cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042d6:	8b 43 18             	mov    0x18(%ebx),%eax
801042d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042e0:	8b 43 18             	mov    0x18(%ebx),%eax
801042e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042ea:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042ed:	6a 10                	push   $0x10
801042ef:	68 36 82 10 80       	push   $0x80108236
801042f4:	50                   	push   %eax
801042f5:	e8 66 0f 00 00       	call   80105260 <safestrcpy>
  p->cwd = namei("/");
801042fa:	c7 04 24 3f 82 10 80 	movl   $0x8010823f,(%esp)
80104301:	e8 da db ff ff       	call   80101ee0 <namei>
80104306:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104309:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80104310:	e8 5b 0c 00 00       	call   80104f70 <acquire>
  p->state = RUNNABLE;
80104315:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010431c:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80104323:	e8 08 0d 00 00       	call   80105030 <release>
}
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010432e:	c9                   	leave  
8010432f:	c3                   	ret    
    panic("userinit: out of memory?");
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	68 1d 82 10 80       	push   $0x8010821d
80104338:	e8 53 c0 ff ff       	call   80100390 <panic>
8010433d:	8d 76 00             	lea    0x0(%esi),%esi

80104340 <fork>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104349:	e8 52 0b 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010434e:	e8 5d f3 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104353:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104359:	e8 82 0b 00 00       	call   80104ee0 <popcli>
  if((np = allocproc()) == 0){
8010435e:	e8 5d fd ff ff       	call   801040c0 <allocproc>
80104363:	85 c0                	test   %eax,%eax
80104365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104368:	0f 84 b7 00 00 00    	je     80104425 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010436e:	83 ec 08             	sub    $0x8,%esp
80104371:	ff 33                	pushl  (%ebx)
80104373:	ff 73 04             	pushl  0x4(%ebx)
80104376:	89 c7                	mov    %eax,%edi
80104378:	e8 d3 36 00 00       	call   80107a50 <copyuvm>
8010437d:	83 c4 10             	add    $0x10,%esp
80104380:	85 c0                	test   %eax,%eax
80104382:	89 47 04             	mov    %eax,0x4(%edi)
80104385:	0f 84 a1 00 00 00    	je     8010442c <fork+0xec>
  np->sz = curproc->sz;
8010438b:	8b 03                	mov    (%ebx),%eax
8010438d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104390:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104392:	89 59 14             	mov    %ebx,0x14(%ecx)
80104395:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80104397:	8b 79 18             	mov    0x18(%ecx),%edi
8010439a:	8b 73 18             	mov    0x18(%ebx),%esi
8010439d:	b9 13 00 00 00       	mov    $0x13,%ecx
801043a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801043a4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801043a6:	8b 40 18             	mov    0x18(%eax),%eax
801043a9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801043b0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801043b4:	85 c0                	test   %eax,%eax
801043b6:	74 13                	je     801043cb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	50                   	push   %eax
801043bc:	e8 2f ca ff ff       	call   80100df0 <filedup>
801043c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043c4:	83 c4 10             	add    $0x10,%esp
801043c7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801043cb:	83 c6 01             	add    $0x1,%esi
801043ce:	83 fe 10             	cmp    $0x10,%esi
801043d1:	75 dd                	jne    801043b0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043d9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801043dc:	e8 6f d2 ff ff       	call   80101650 <idup>
801043e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043e4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801043e7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043ea:	8d 47 6c             	lea    0x6c(%edi),%eax
801043ed:	6a 10                	push   $0x10
801043ef:	53                   	push   %ebx
801043f0:	50                   	push   %eax
801043f1:	e8 6a 0e 00 00       	call   80105260 <safestrcpy>
  pid = np->pid;
801043f6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801043f9:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80104400:	e8 6b 0b 00 00       	call   80104f70 <acquire>
  np->state = RUNNABLE;
80104405:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010440c:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80104413:	e8 18 0c 00 00       	call   80105030 <release>
  return pid;
80104418:	83 c4 10             	add    $0x10,%esp
}
8010441b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441e:	89 d8                	mov    %ebx,%eax
80104420:	5b                   	pop    %ebx
80104421:	5e                   	pop    %esi
80104422:	5f                   	pop    %edi
80104423:	5d                   	pop    %ebp
80104424:	c3                   	ret    
    return -1;
80104425:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010442a:	eb ef                	jmp    8010441b <fork+0xdb>
    kfree(np->kstack);
8010442c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010442f:	83 ec 0c             	sub    $0xc,%esp
80104432:	ff 73 08             	pushl  0x8(%ebx)
80104435:	e8 d6 de ff ff       	call   80102310 <kfree>
    np->kstack = 0;
8010443a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104441:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104448:	83 c4 10             	add    $0x10,%esp
8010444b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104450:	eb c9                	jmp    8010441b <fork+0xdb>
80104452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <yield>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	68 60 45 11 80       	push   $0x80114560
8010446d:	e8 fe 0a 00 00       	call   80104f70 <acquire>
  pushcli();
80104472:	e8 29 0a 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104477:	e8 34 f2 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
8010447c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104482:	e8 59 0a 00 00       	call   80104ee0 <popcli>
  myproc()->state = RUNNABLE;
80104487:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  cprintf("Yield called\n");
8010448e:	c7 04 24 41 82 10 80 	movl   $0x80108241,(%esp)
80104495:	e8 c6 c1 ff ff       	call   80100660 <cprintf>
  pushcli();
8010449a:	e8 01 0a 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010449f:	e8 0c f2 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044a4:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044aa:	e8 31 0a 00 00       	call   80104ee0 <popcli>
    cprintf("PREMPTION %d with curTime %d\n", myproc()->pid, myproc()->curTime);
801044af:	8b b3 a8 00 00 00    	mov    0xa8(%ebx),%esi
  pushcli();
801044b5:	e8 e6 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801044ba:	e8 f1 f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044c5:	e8 16 0a 00 00       	call   80104ee0 <popcli>
    cprintf("PREMPTION %d with curTime %d\n", myproc()->pid, myproc()->curTime);
801044ca:	83 c4 0c             	add    $0xc,%esp
801044cd:	56                   	push   %esi
801044ce:	ff 73 10             	pushl  0x10(%ebx)
801044d1:	68 4f 82 10 80       	push   $0x8010824f
801044d6:	e8 85 c1 ff ff       	call   80100660 <cprintf>
  pushcli();
801044db:	e8 c0 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801044e0:	e8 cb f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
801044e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044eb:	e8 f0 09 00 00       	call   80104ee0 <popcli>
    myproc()->queue++;
801044f0:	83 83 90 00 00 00 01 	addl   $0x1,0x90(%ebx)
  pushcli();
801044f7:	e8 a4 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801044fc:	e8 af f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104501:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104507:	e8 d4 09 00 00       	call   80104ee0 <popcli>
    myproc()->curTime = 0;
8010450c:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80104513:	00 00 00 
  pushcli();
80104516:	e8 85 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010451b:	e8 90 f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104520:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104526:	e8 b5 09 00 00       	call   80104ee0 <popcli>
  pushcli();
8010452b:	e8 70 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104530:	e8 7b f1 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80104535:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010453b:	e8 a0 09 00 00       	call   80104ee0 <popcli>
    enQueue(myproc()->queue, myproc());
80104540:	58                   	pop    %eax
80104541:	5a                   	pop    %edx
80104542:	56                   	push   %esi
80104543:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80104549:	e8 12 fa ff ff       	call   80103f60 <enQueue>
  sched();
8010454e:	e8 ad f2 ff ff       	call   80103800 <sched>
  release(&ptable.lock);
80104553:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
8010455a:	e8 d1 0a 00 00       	call   80105030 <release>
}
8010455f:	83 c4 10             	add    $0x10,%esp
80104562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104565:	5b                   	pop    %ebx
80104566:	5e                   	pop    %esi
80104567:	5d                   	pop    %ebp
80104568:	c3                   	ret    
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104570 <update_proc_time>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104574:	bb 94 45 11 80       	mov    $0x80114594,%ebx
{
80104579:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010457c:	68 60 45 11 80       	push   $0x80114560
80104581:	e8 ea 09 00 00       	call   80104f70 <acquire>
80104586:	83 c4 10             	add    $0x10,%esp
80104589:	eb 31                	jmp    801045bc <update_proc_time+0x4c>
8010458b:	90                   	nop
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->wait_queue_time++;
80104590:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80104596:	83 c0 01             	add    $0x1,%eax
      if(p->wait_queue_time > maxage && p->queue != 0) {
80104599:	83 f8 1e             	cmp    $0x1e,%eax
      p->wait_queue_time++;
8010459c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
      if(p->wait_queue_time > maxage && p->queue != 0) {
801045a2:	7e 0a                	jle    801045ae <update_proc_time+0x3e>
801045a4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
801045aa:	85 c0                	test   %eax,%eax
801045ac:	75 5a                	jne    80104608 <update_proc_time+0x98>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ae:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801045b4:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
801045ba:	73 30                	jae    801045ec <update_proc_time+0x7c>
  	if(p->state == RUNNING){	
801045bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801045c0:	75 ce                	jne    80104590 <update_proc_time+0x20>
801045c2:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
      p->runTime++;
801045c8:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
      p->time[p->queue]++;
801045cf:	83 84 83 94 00 00 00 	addl   $0x1,0x94(%ebx,%eax,4)
801045d6:	01 
      p->curTime++;     
801045d7:	83 83 a8 00 00 00 01 	addl   $0x1,0xa8(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045de:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801045e4:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
801045ea:	72 d0                	jb     801045bc <update_proc_time+0x4c>
  release(&ptable.lock);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 60 45 11 80       	push   $0x80114560
801045f4:	e8 37 0a 00 00       	call   80105030 <release>
}
801045f9:	83 c4 10             	add    $0x10,%esp
801045fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045ff:	c9                   	leave  
80104600:	c3                   	ret    
80104601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        enQueue(p->queue, p);
80104608:	83 ec 08             	sub    $0x8,%esp
        p->queue--;
8010460b:	83 e8 01             	sub    $0x1,%eax
        p->curTime = 0;
8010460e:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80104615:	00 00 00 
        enQueue(p->queue, p);
80104618:	53                   	push   %ebx
80104619:	50                   	push   %eax
        p->queue--;
8010461a:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
        p->wait_queue_time = 0;
80104620:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104627:	00 00 00 
        enQueue(p->queue, p);
8010462a:	e8 31 f9 ff ff       	call   80103f60 <enQueue>
        cprintf("AGING %d\n", p->pid);
8010462f:	58                   	pop    %eax
80104630:	5a                   	pop    %edx
80104631:	ff 73 10             	pushl  0x10(%ebx)
80104634:	68 6d 82 10 80       	push   $0x8010826d
80104639:	e8 22 c0 ff ff       	call   80100660 <cprintf>
8010463e:	83 c4 10             	add    $0x10,%esp
80104641:	e9 68 ff ff ff       	jmp    801045ae <update_proc_time+0x3e>
80104646:	8d 76 00             	lea    0x0(%esi),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <scheduler>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
    int flag = 0;
80104656:	31 ff                	xor    %edi,%edi
  struct proc* p = 0;
80104658:	31 db                	xor    %ebx,%ebx
    if (front[num] == rear[num]){
        front[num] = -1;
        rear[num] = -1;
    } /* Q has only one element, so we reset the queue after dequeing it. ? */
    else {
        front[num] = (front[num] + 1) % 100;
8010465a:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
{
8010465f:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104662:	e8 49 f0 ff ff       	call   801036b0 <mycpu>
  c->proc = 0;
80104667:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010466e:	00 00 00 
  struct cpu *c = mycpu();
80104671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104674:	83 c0 04             	add    $0x4,%eax
80104677:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  asm volatile("sti");
80104680:	fb                   	sti    
      acquire(&ptable.lock);
80104681:	83 ec 0c             	sub    $0xc,%esp
80104684:	68 60 45 11 80       	push   $0x80114560
80104689:	e8 e2 08 00 00       	call   80104f70 <acquire>
    if(front[num] == -1) return 1;
8010468e:	8b 0d 6c 0f 11 80    	mov    0x80110f6c,%ecx
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	83 f9 ff             	cmp    $0xffffffff,%ecx
8010469a:	0f 84 60 01 00 00    	je     80104800 <scheduler+0x1b0>
        while(cnt != qSize[0]){
801046a0:	a1 d4 c5 10 80       	mov    0x8010c5d4,%eax
801046a5:	85 c0                	test   %eax,%eax
801046a7:	0f 84 53 01 00 00    	je     80104800 <scheduler+0x1b0>
        int cnt = 0;
801046ad:	31 ff                	xor    %edi,%edi
801046af:	eb 4a                	jmp    801046fb <scheduler+0xab>
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        front[num] = (front[num] + 1) % 100;
801046b8:	83 c1 01             	add    $0x1,%ecx
801046bb:	89 c8                	mov    %ecx,%eax
801046bd:	f7 ee                	imul   %esi
801046bf:	89 c8                	mov    %ecx,%eax
801046c1:	c1 f8 1f             	sar    $0x1f,%eax
801046c4:	c1 fa 05             	sar    $0x5,%edx
801046c7:	29 c2                	sub    %eax,%edx
801046c9:	6b d2 64             	imul   $0x64,%edx,%edx
801046cc:	29 d1                	sub    %edx,%ecx
801046ce:	89 0d 6c 0f 11 80    	mov    %ecx,0x80110f6c
          if(p->state != RUNNABLE){
801046d4:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801046d8:	74 55                	je     8010472f <scheduler+0xdf>
            enQueue(0, p);
801046da:	83 ec 08             	sub    $0x8,%esp
801046dd:	53                   	push   %ebx
801046de:	6a 00                	push   $0x0
801046e0:	e8 7b f8 ff ff       	call   80103f60 <enQueue>
        while(cnt != qSize[0]){
801046e5:	a1 d4 c5 10 80       	mov    0x8010c5d4,%eax
801046ea:	83 c4 10             	add    $0x10,%esp
801046ed:	39 f8                	cmp    %edi,%eax
801046ef:	0f 84 42 01 00 00    	je     80104837 <scheduler+0x1e7>
801046f5:	8b 0d 6c 0f 11 80    	mov    0x80110f6c,%ecx
    qSize[num]--;
801046fb:	83 e8 01             	sub    $0x1,%eax
          cnt++;
801046fe:	83 c7 01             	add    $0x1,%edi
    if (front[num] == rear[num]){
80104701:	39 0d c0 c5 10 80    	cmp    %ecx,0x8010c5c0
    qSize[num]--;
80104707:	a3 d4 c5 10 80       	mov    %eax,0x8010c5d4
    element = q[num][front[num]];
8010470c:	8b 1c 8d 80 0f 11 80 	mov    -0x7feef080(,%ecx,4),%ebx
    if (front[num] == rear[num]){
80104713:	75 a3                	jne    801046b8 <scheduler+0x68>
        front[num] = -1;
80104715:	c7 05 6c 0f 11 80 ff 	movl   $0xffffffff,0x80110f6c
8010471c:	ff ff ff 
        rear[num] = -1;
8010471f:	c7 05 c0 c5 10 80 ff 	movl   $0xffffffff,0x8010c5c0
80104726:	ff ff ff 
          if(p->state != RUNNABLE){
80104729:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010472d:	75 ab                	jne    801046da <scheduler+0x8a>
    if(front[num] == -1) return 1;
8010472f:	83 3d 70 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f70
80104736:	a1 74 0f 11 80       	mov    0x80110f74,%eax
8010473b:	8b 15 78 0f 11 80    	mov    0x80110f78,%edx
80104741:	0f 85 ca 00 00 00    	jne    80104811 <scheduler+0x1c1>
80104747:	83 f8 ff             	cmp    $0xffffffff,%eax
8010474a:	0f 84 8a 03 00 00    	je     80104ada <scheduler+0x48a>
        c->proc = p;
80104750:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        p->num_run++;
80104753:	83 83 ac 00 00 00 01 	addl   $0x1,0xac(%ebx)
        switchuvm(p);
8010475a:	83 ec 0c             	sub    $0xc,%esp
        p->wait_queue_time = 0;
8010475d:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104764:	00 00 00 
        c->proc = p;
80104767:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
        switchuvm(p);
8010476d:	53                   	push   %ebx
8010476e:	e8 dd 2d 00 00       	call   80107550 <switchuvm>
        cprintf("pid = %d, queue = %d, waittime = %d size = %d runtime = %d\n", p->pid, p->queue, p->wait_queue_time, qSize[p->queue], p->runTime);
80104773:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
        p->state = RUNNING;
80104779:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        cprintf("pid = %d, queue = %d, waittime = %d size = %d runtime = %d\n", p->pid, p->queue, p->wait_queue_time, qSize[p->queue], p->runTime);
80104780:	5a                   	pop    %edx
80104781:	59                   	pop    %ecx
80104782:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104788:	ff 34 85 d4 c5 10 80 	pushl  -0x7fef3a2c(,%eax,4)
8010478f:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104795:	50                   	push   %eax
80104796:	ff 73 10             	pushl  0x10(%ebx)
80104799:	68 cc 82 10 80       	push   $0x801082cc
8010479e:	e8 bd be ff ff       	call   80100660 <cprintf>
        swtch(&(c->scheduler), p->context);
801047a3:	83 c4 18             	add    $0x18,%esp
801047a6:	ff 73 1c             	pushl  0x1c(%ebx)
801047a9:	ff 75 e0             	pushl  -0x20(%ebp)
801047ac:	e8 0a 0b 00 00       	call   801052bb <swtch>
        switchkvm();
801047b1:	e8 7a 2d 00 00       	call   80107530 <switchkvm>
        c->proc = 0;
801047b6:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801047bd:	00 00 00 
801047c0:	83 c4 10             	add    $0x10,%esp
801047c3:	90                   	nop
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        int cnt = 0;
801047c8:	bb 94 45 11 80       	mov    $0x80114594,%ebx
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
          if(p->state != RUNNABLE || p -> pid == 0)
801047d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801047d4:	75 15                	jne    801047eb <scheduler+0x19b>
801047d6:	8b 43 10             	mov    0x10(%ebx),%eax
801047d9:	85 c0                	test   %eax,%eax
801047db:	74 0e                	je     801047eb <scheduler+0x19b>
          enQueue(0, p);                        // insert all runnable process without a queue and runnable into queue number 0
801047dd:	83 ec 08             	sub    $0x8,%esp
801047e0:	53                   	push   %ebx
801047e1:	6a 00                	push   $0x0
801047e3:	e8 78 f7 ff ff       	call   80103f60 <enQueue>
801047e8:	83 c4 10             	add    $0x10,%esp
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047eb:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801047f1:	81 fb 94 71 11 80    	cmp    $0x80117194,%ebx
801047f7:	72 d7                	jb     801047d0 <scheduler+0x180>
801047f9:	31 ff                	xor    %edi,%edi
801047fb:	eb 25                	jmp    80104822 <scheduler+0x1d2>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(front[num] == -1) return 1;
80104800:	83 3d 70 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f70
80104807:	0f 84 46 01 00 00    	je     80104953 <scheduler+0x303>
      if(!isEmpty(1) && flag==0){
8010480d:	85 ff                	test   %edi,%edi
8010480f:	74 2f                	je     80104840 <scheduler+0x1f0>
80104811:	8b 43 0c             	mov    0xc(%ebx),%eax
      if(flag == 1 && p->state == RUNNABLE){
80104814:	83 f8 03             	cmp    $0x3,%eax
80104817:	0f 84 33 ff ff ff    	je     80104750 <scheduler+0x100>
8010481d:	bf 01 00 00 00       	mov    $0x1,%edi
      release(&ptable.lock);
80104822:	83 ec 0c             	sub    $0xc,%esp
80104825:	68 60 45 11 80       	push   $0x80114560
8010482a:	e8 01 08 00 00       	call   80105030 <release>
      sti();
8010482f:	83 c4 10             	add    $0x10,%esp
80104832:	e9 49 fe ff ff       	jmp    80104680 <scheduler+0x30>
    if(front[num] == -1) return 1;
80104837:	83 3d 70 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f70
8010483e:	74 7f                	je     801048bf <scheduler+0x26f>
        while(cnt != qSize[1]){
80104840:	a1 d8 c5 10 80       	mov    0x8010c5d8,%eax
80104845:	85 c0                	test   %eax,%eax
80104847:	74 76                	je     801048bf <scheduler+0x26f>
        int cnt = 0;
80104849:	31 ff                	xor    %edi,%edi
8010484b:	eb 3c                	jmp    80104889 <scheduler+0x239>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
        front[num] = (front[num] + 1) % 100;
80104850:	83 c1 01             	add    $0x1,%ecx
80104853:	89 c8                	mov    %ecx,%eax
80104855:	f7 ee                	imul   %esi
80104857:	89 c8                	mov    %ecx,%eax
80104859:	c1 f8 1f             	sar    $0x1f,%eax
8010485c:	c1 fa 05             	sar    $0x5,%edx
8010485f:	29 c2                	sub    %eax,%edx
80104861:	6b c2 64             	imul   $0x64,%edx,%eax
80104864:	29 c1                	sub    %eax,%ecx
80104866:	89 0d 70 0f 11 80    	mov    %ecx,0x80110f70
          if(p->state != RUNNABLE){
8010486c:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104870:	74 9f                	je     80104811 <scheduler+0x1c1>
            enQueue(1, p);
80104872:	83 ec 08             	sub    $0x8,%esp
80104875:	53                   	push   %ebx
80104876:	6a 01                	push   $0x1
80104878:	e8 e3 f6 ff ff       	call   80103f60 <enQueue>
        while(cnt != qSize[1]){
8010487d:	a1 d8 c5 10 80       	mov    0x8010c5d8,%eax
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	39 f8                	cmp    %edi,%eax
80104887:	74 36                	je     801048bf <scheduler+0x26f>
    qSize[num]--;
80104889:	83 e8 01             	sub    $0x1,%eax
    element = q[num][front[num]];
8010488c:	8b 0d 70 0f 11 80    	mov    0x80110f70,%ecx
          cnt++;
80104892:	83 c7 01             	add    $0x1,%edi
    if (front[num] == rear[num]){
80104895:	3b 0d c4 c5 10 80    	cmp    0x8010c5c4,%ecx
    qSize[num]--;
8010489b:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
    element = q[num][front[num]];
801048a0:	8b 1c 8d 10 11 11 80 	mov    -0x7feeeef0(,%ecx,4),%ebx
    if (front[num] == rear[num]){
801048a7:	75 a7                	jne    80104850 <scheduler+0x200>
        front[num] = -1;
801048a9:	c7 05 70 0f 11 80 ff 	movl   $0xffffffff,0x80110f70
801048b0:	ff ff ff 
        rear[num] = -1;
801048b3:	c7 05 c4 c5 10 80 ff 	movl   $0xffffffff,0x8010c5c4
801048ba:	ff ff ff 
801048bd:	eb ad                	jmp    8010486c <scheduler+0x21c>
    if(front[num] == -1) return 1;
801048bf:	83 3d 74 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f74
801048c6:	0f 84 3f 01 00 00    	je     80104a0b <scheduler+0x3bb>
        while(cnt != qSize[2]){
801048cc:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
801048d1:	85 c0                	test   %eax,%eax
801048d3:	0f 84 9c 00 00 00    	je     80104975 <scheduler+0x325>
801048d9:	31 ff                	xor    %edi,%edi
801048db:	eb 40                	jmp    8010491d <scheduler+0x2cd>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
        front[num] = (front[num] + 1) % 100;
801048e0:	83 c1 01             	add    $0x1,%ecx
801048e3:	89 c8                	mov    %ecx,%eax
801048e5:	f7 ee                	imul   %esi
801048e7:	89 c8                	mov    %ecx,%eax
801048e9:	c1 f8 1f             	sar    $0x1f,%eax
801048ec:	c1 fa 05             	sar    $0x5,%edx
801048ef:	29 c2                	sub    %eax,%edx
801048f1:	6b c2 64             	imul   $0x64,%edx,%eax
801048f4:	29 c1                	sub    %eax,%ecx
801048f6:	89 0d 74 0f 11 80    	mov    %ecx,0x80110f74
          if(p->state != RUNNABLE){
801048fc:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104900:	0f 84 4a fe ff ff    	je     80104750 <scheduler+0x100>
            enQueue(2, p);
80104906:	83 ec 08             	sub    $0x8,%esp
80104909:	53                   	push   %ebx
8010490a:	6a 02                	push   $0x2
8010490c:	e8 4f f6 ff ff       	call   80103f60 <enQueue>
        while(cnt != qSize[2]){
80104911:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
80104916:	83 c4 10             	add    $0x10,%esp
80104919:	39 f8                	cmp    %edi,%eax
8010491b:	74 58                	je     80104975 <scheduler+0x325>
    qSize[num]--;
8010491d:	83 e8 01             	sub    $0x1,%eax
    element = q[num][front[num]];
80104920:	8b 0d 74 0f 11 80    	mov    0x80110f74,%ecx
          cnt++;
80104926:	83 c7 01             	add    $0x1,%edi
    if (front[num] == rear[num]){
80104929:	3b 0d c8 c5 10 80    	cmp    0x8010c5c8,%ecx
    qSize[num]--;
8010492f:	a3 dc c5 10 80       	mov    %eax,0x8010c5dc
    element = q[num][front[num]];
80104934:	8b 1c 8d a0 12 11 80 	mov    -0x7feeed60(,%ecx,4),%ebx
    if (front[num] == rear[num]){
8010493b:	75 a3                	jne    801048e0 <scheduler+0x290>
        front[num] = -1;
8010493d:	c7 05 74 0f 11 80 ff 	movl   $0xffffffff,0x80110f74
80104944:	ff ff ff 
        rear[num] = -1;
80104947:	c7 05 c8 c5 10 80 ff 	movl   $0xffffffff,0x8010c5c8
8010494e:	ff ff ff 
80104951:	eb a9                	jmp    801048fc <scheduler+0x2ac>
    if(front[num] == -1) return 1;
80104953:	83 3d 74 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f74
8010495a:	0f 84 4f 01 00 00    	je     80104aaf <scheduler+0x45f>
      if(!isEmpty(2) && flag==0){
80104960:	85 ff                	test   %edi,%edi
80104962:	0f 85 a9 fe ff ff    	jne    80104811 <scheduler+0x1c1>
        while(cnt != qSize[2]){
80104968:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
8010496d:	85 c0                	test   %eax,%eax
8010496f:	0f 85 64 ff ff ff    	jne    801048d9 <scheduler+0x289>
    if(front[num] == -1) return 1;
80104975:	83 3d 78 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f78
8010497c:	0f 84 46 01 00 00    	je     80104ac8 <scheduler+0x478>
        while(cnt != qSize[3]){
80104982:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
80104987:	31 ff                	xor    %edi,%edi
80104989:	85 c0                	test   %eax,%eax
8010498b:	75 48                	jne    801049d5 <scheduler+0x385>
8010498d:	e9 86 00 00 00       	jmp    80104a18 <scheduler+0x3c8>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        front[num] = (front[num] + 1) % 100;
80104998:	83 c1 01             	add    $0x1,%ecx
8010499b:	89 c8                	mov    %ecx,%eax
8010499d:	f7 ee                	imul   %esi
8010499f:	89 c8                	mov    %ecx,%eax
801049a1:	c1 f8 1f             	sar    $0x1f,%eax
801049a4:	c1 fa 05             	sar    $0x5,%edx
801049a7:	29 c2                	sub    %eax,%edx
801049a9:	6b c2 64             	imul   $0x64,%edx,%eax
801049ac:	29 c1                	sub    %eax,%ecx
801049ae:	89 0d 78 0f 11 80    	mov    %ecx,0x80110f78
          if(p->state != RUNNABLE){
801049b4:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801049b8:	0f 84 92 fd ff ff    	je     80104750 <scheduler+0x100>
            enQueue(3, p);
801049be:	83 ec 08             	sub    $0x8,%esp
801049c1:	53                   	push   %ebx
801049c2:	6a 03                	push   $0x3
801049c4:	e8 97 f5 ff ff       	call   80103f60 <enQueue>
        while(cnt != qSize[3]){
801049c9:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
801049ce:	83 c4 10             	add    $0x10,%esp
801049d1:	39 f8                	cmp    %edi,%eax
801049d3:	74 43                	je     80104a18 <scheduler+0x3c8>
    qSize[num]--;
801049d5:	83 e8 01             	sub    $0x1,%eax
    element = q[num][front[num]];
801049d8:	8b 0d 78 0f 11 80    	mov    0x80110f78,%ecx
          cnt++;
801049de:	83 c7 01             	add    $0x1,%edi
    if (front[num] == rear[num]){
801049e1:	3b 0d cc c5 10 80    	cmp    0x8010c5cc,%ecx
    qSize[num]--;
801049e7:	a3 e0 c5 10 80       	mov    %eax,0x8010c5e0
    element = q[num][front[num]];
801049ec:	8b 1c 8d 30 14 11 80 	mov    -0x7feeebd0(,%ecx,4),%ebx
    if (front[num] == rear[num]){
801049f3:	75 a3                	jne    80104998 <scheduler+0x348>
        front[num] = -1;
801049f5:	c7 05 78 0f 11 80 ff 	movl   $0xffffffff,0x80110f78
801049fc:	ff ff ff 
        rear[num] = -1;
801049ff:	c7 05 cc c5 10 80 ff 	movl   $0xffffffff,0x8010c5cc
80104a06:	ff ff ff 
80104a09:	eb a9                	jmp    801049b4 <scheduler+0x364>
    if(front[num] == -1) return 1;
80104a0b:	83 3d 78 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f78
80104a12:	0f 85 6a ff ff ff    	jne    80104982 <scheduler+0x332>
80104a18:	83 3d 7c 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f7c
80104a1f:	0f 84 a3 fd ff ff    	je     801047c8 <scheduler+0x178>
        while(cnt != qSize[4]){
80104a25:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
        int cnt = 0;
80104a2a:	31 ff                	xor    %edi,%edi
        while(cnt != qSize[4]){
80104a2c:	85 c0                	test   %eax,%eax
80104a2e:	75 49                	jne    80104a79 <scheduler+0x429>
80104a30:	e9 93 fd ff ff       	jmp    801047c8 <scheduler+0x178>
80104a35:	8d 76 00             	lea    0x0(%esi),%esi
        front[num] = (front[num] + 1) % 100;
80104a38:	83 c1 01             	add    $0x1,%ecx
80104a3b:	89 c8                	mov    %ecx,%eax
80104a3d:	f7 ee                	imul   %esi
80104a3f:	89 c8                	mov    %ecx,%eax
80104a41:	c1 f8 1f             	sar    $0x1f,%eax
80104a44:	c1 fa 05             	sar    $0x5,%edx
80104a47:	29 c2                	sub    %eax,%edx
80104a49:	6b c2 64             	imul   $0x64,%edx,%eax
80104a4c:	29 c1                	sub    %eax,%ecx
80104a4e:	89 0d 7c 0f 11 80    	mov    %ecx,0x80110f7c
          if(p->state != RUNNABLE){
80104a54:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104a58:	0f 84 f2 fc ff ff    	je     80104750 <scheduler+0x100>
            enQueue(4, p);
80104a5e:	83 ec 08             	sub    $0x8,%esp
80104a61:	53                   	push   %ebx
80104a62:	6a 04                	push   $0x4
80104a64:	e8 f7 f4 ff ff       	call   80103f60 <enQueue>
        while(cnt != qSize[4]){
80104a69:	a1 e4 c5 10 80       	mov    0x8010c5e4,%eax
80104a6e:	83 c4 10             	add    $0x10,%esp
80104a71:	39 f8                	cmp    %edi,%eax
80104a73:	0f 84 4f fd ff ff    	je     801047c8 <scheduler+0x178>
    qSize[num]--;
80104a79:	83 e8 01             	sub    $0x1,%eax
    element = q[num][front[num]];
80104a7c:	8b 0d 7c 0f 11 80    	mov    0x80110f7c,%ecx
          cnt++;
80104a82:	83 c7 01             	add    $0x1,%edi
    if (front[num] == rear[num]){
80104a85:	3b 0d d0 c5 10 80    	cmp    0x8010c5d0,%ecx
    qSize[num]--;
80104a8b:	a3 e4 c5 10 80       	mov    %eax,0x8010c5e4
    element = q[num][front[num]];
80104a90:	8b 1c 8d c0 15 11 80 	mov    -0x7feeea40(,%ecx,4),%ebx
    if (front[num] == rear[num]){
80104a97:	75 9f                	jne    80104a38 <scheduler+0x3e8>
        front[num] = -1;
80104a99:	c7 05 7c 0f 11 80 ff 	movl   $0xffffffff,0x80110f7c
80104aa0:	ff ff ff 
        rear[num] = -1;
80104aa3:	c7 05 d0 c5 10 80 ff 	movl   $0xffffffff,0x8010c5d0
80104aaa:	ff ff ff 
80104aad:	eb a5                	jmp    80104a54 <scheduler+0x404>
    if(front[num] == -1) return 1;
80104aaf:	83 3d 78 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f78
80104ab6:	74 30                	je     80104ae8 <scheduler+0x498>
      if(!isEmpty(3) && flag==0){
80104ab8:	85 ff                	test   %edi,%edi
80104aba:	0f 84 c2 fe ff ff    	je     80104982 <scheduler+0x332>
80104ac0:	e9 4c fd ff ff       	jmp    80104811 <scheduler+0x1c1>
80104ac5:	8d 76 00             	lea    0x0(%esi),%esi
    if(front[num] == -1) return 1;
80104ac8:	83 3d 7c 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f7c
80104acf:	0f 85 50 ff ff ff    	jne    80104a25 <scheduler+0x3d5>
80104ad5:	e9 ee fc ff ff       	jmp    801047c8 <scheduler+0x178>
80104ada:	83 fa ff             	cmp    $0xffffffff,%edx
80104add:	0f 84 2e fd ff ff    	je     80104811 <scheduler+0x1c1>
80104ae3:	e9 68 fc ff ff       	jmp    80104750 <scheduler+0x100>
80104ae8:	83 3d 7c 0f 11 80 ff 	cmpl   $0xffffffff,0x80110f7c
80104aef:	75 0f                	jne    80104b00 <scheduler+0x4b0>
      if(flag == 1 && p->state == RUNNABLE){
80104af1:	83 ff 01             	cmp    $0x1,%edi
80104af4:	0f 85 ce fc ff ff    	jne    801047c8 <scheduler+0x178>
80104afa:	e9 12 fd ff ff       	jmp    80104811 <scheduler+0x1c1>
80104aff:	90                   	nop
      if(!isEmpty(4) && flag==0){
80104b00:	85 ff                	test   %edi,%edi
80104b02:	0f 84 1d ff ff ff    	je     80104a25 <scheduler+0x3d5>
80104b08:	e9 04 fd ff ff       	jmp    80104811 <scheduler+0x1c1>
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <deQueue>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
    element = q[num][front[num]];
80104b18:	8b 0c 9d 6c 0f 11 80 	mov    -0x7feef094(,%ebx,4),%ecx
    qSize[num]--;
80104b1f:	83 2c 9d d4 c5 10 80 	subl   $0x1,-0x7fef3a2c(,%ebx,4)
80104b26:	01 
    element = q[num][front[num]];
80104b27:	6b c3 64             	imul   $0x64,%ebx,%eax
80104b2a:	01 c8                	add    %ecx,%eax
    if (front[num] == rear[num]){
80104b2c:	3b 0c 9d c0 c5 10 80 	cmp    -0x7fef3a40(,%ebx,4),%ecx
    element = q[num][front[num]];
80104b33:	8b 34 85 80 0f 11 80 	mov    -0x7feef080(,%eax,4),%esi
    if (front[num] == rear[num]){
80104b3a:	74 2c                	je     80104b68 <deQueue+0x58>
        front[num] = (front[num] + 1) % 100;
80104b3c:	83 c1 01             	add    $0x1,%ecx
80104b3f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80104b44:	89 c8                	mov    %ecx,%eax
80104b46:	f7 ea                	imul   %edx
80104b48:	89 c8                	mov    %ecx,%eax
80104b4a:	c1 f8 1f             	sar    $0x1f,%eax
80104b4d:	c1 fa 05             	sar    $0x5,%edx
80104b50:	29 c2                	sub    %eax,%edx
    }
    // // cprintf("\n Deleted %d\n", element->pid);
    return element;
}
80104b52:	89 f0                	mov    %esi,%eax
        front[num] = (front[num] + 1) % 100;
80104b54:	6b d2 64             	imul   $0x64,%edx,%edx
80104b57:	29 d1                	sub    %edx,%ecx
80104b59:	89 0c 9d 6c 0f 11 80 	mov    %ecx,-0x7feef094(,%ebx,4)
}
80104b60:	5b                   	pop    %ebx
80104b61:	5e                   	pop    %esi
80104b62:	5d                   	pop    %ebp
80104b63:	c3                   	ret    
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b68:	89 f0                	mov    %esi,%eax
        front[num] = -1;
80104b6a:	c7 04 9d 6c 0f 11 80 	movl   $0xffffffff,-0x7feef094(,%ebx,4)
80104b71:	ff ff ff ff 
        rear[num] = -1;
80104b75:	c7 04 9d c0 c5 10 80 	movl   $0xffffffff,-0x7fef3a40(,%ebx,4)
80104b7c:	ff ff ff ff 
}
80104b80:	5b                   	pop    %ebx
80104b81:	5e                   	pop    %esi
80104b82:	5d                   	pop    %ebp
80104b83:	c3                   	ret    
80104b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b90 <getpinfo>:

int getpinfo(struct proc_stat* pinfo_p, int pid)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	8b 75 08             	mov    0x8(%ebp),%esi
80104b98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct proc* p = 0;
  acquire(&ptable.lock);
80104b9b:	83 ec 0c             	sub    $0xc,%esp
80104b9e:	68 60 45 11 80       	push   $0x80114560
80104ba3:	e8 c8 03 00 00       	call   80104f70 <acquire>
80104ba8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bab:	b8 94 45 11 80       	mov    $0x80114594,%eax
80104bb0:	eb 12                	jmp    80104bc4 <getpinfo+0x34>
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb8:	05 b0 00 00 00       	add    $0xb0,%eax
80104bbd:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80104bc2:	73 6c                	jae    80104c30 <getpinfo+0xa0>
    if(p->pid == pid)
80104bc4:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bc7:	75 ef                	jne    80104bb8 <getpinfo+0x28>
    {
      pinfo_p->pid = p->pid;
80104bc9:	89 1e                	mov    %ebx,(%esi)
      pinfo_p->runtime = p->runTime;
80104bcb:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
      
      for(int i=0; i<5; i++){
        pinfo_p->ticks[i] = p->time[i]; 
      }

      release(&ptable.lock);
80104bd1:	83 ec 0c             	sub    $0xc,%esp
      pinfo_p->runtime = p->runTime;
80104bd4:	89 56 04             	mov    %edx,0x4(%esi)
      pinfo_p->num_run = p->num_run;
80104bd7:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104bdd:	89 56 08             	mov    %edx,0x8(%esi)
      pinfo_p->current_queue = p->queue;
80104be0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80104be6:	89 56 0c             	mov    %edx,0xc(%esi)
        pinfo_p->ticks[i] = p->time[i]; 
80104be9:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80104bef:	89 56 10             	mov    %edx,0x10(%esi)
80104bf2:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104bf8:	89 56 14             	mov    %edx,0x14(%esi)
80104bfb:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80104c01:	89 56 18             	mov    %edx,0x18(%esi)
80104c04:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
80104c0a:	89 56 1c             	mov    %edx,0x1c(%esi)
80104c0d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c13:	89 46 20             	mov    %eax,0x20(%esi)
      release(&ptable.lock);
80104c16:	68 60 45 11 80       	push   $0x80114560
80104c1b:	e8 10 04 00 00       	call   80105030 <release>
      return 1;
80104c20:	83 c4 10             	add    $0x10,%esp
  }
  
  release(&ptable.lock);

  return 0;
}
80104c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 1;
80104c26:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104c2b:	5b                   	pop    %ebx
80104c2c:	5e                   	pop    %esi
80104c2d:	5d                   	pop    %ebp
80104c2e:	c3                   	ret    
80104c2f:	90                   	nop
  release(&ptable.lock);
80104c30:	83 ec 0c             	sub    $0xc,%esp
80104c33:	68 60 45 11 80       	push   $0x80114560
80104c38:	e8 f3 03 00 00       	call   80105030 <release>
  return 0;
80104c3d:	83 c4 10             	add    $0x10,%esp
}
80104c40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c50 <higherPriority>:

int higherPriority(int cur_proc_priority, int flag) { 
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 10             	sub    $0x10,%esp
80104c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* p = 0;
  acquire(&ptable.lock);
80104c5a:	68 60 45 11 80       	push   $0x80114560
80104c5f:	e8 0c 03 00 00       	call   80104f70 <acquire>
80104c64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c67:	b8 94 45 11 80       	mov    $0x80114594,%eax
80104c6c:	eb 0e                	jmp    80104c7c <higherPriority+0x2c>
80104c6e:	66 90                	xchg   %ax,%ax
80104c70:	05 b0 00 00 00       	add    $0xb0,%eax
80104c75:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80104c7a:	73 2c                	jae    80104ca8 <higherPriority+0x58>
    if(p->priority < cur_proc_priority && p->pid !=0 ) {
80104c7c:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104c82:	7d ec                	jge    80104c70 <higherPriority+0x20>
80104c84:	8b 50 10             	mov    0x10(%eax),%edx
80104c87:	85 d2                	test   %edx,%edx
80104c89:	74 e5                	je     80104c70 <higherPriority+0x20>
      // cprintf("%d Higher priority found %d %d\n", p->pid, p->priority, cur_proc_priority);
      release(&ptable.lock);
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	68 60 45 11 80       	push   $0x80114560
80104c93:	e8 98 03 00 00       	call   80105030 <release>
      return 1;
80104c98:	83 c4 10             	add    $0x10,%esp
80104c9b:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  }
  release(&ptable.lock);
  return 0; 
80104ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca3:	c9                   	leave  
80104ca4:	c3                   	ret    
80104ca5:	8d 76 00             	lea    0x0(%esi),%esi
  if(flag) {
80104ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104cab:	85 c9                	test   %ecx,%ecx
80104cad:	74 2e                	je     80104cdd <higherPriority+0x8d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104caf:	b8 94 45 11 80       	mov    $0x80114594,%eax
80104cb4:	eb 16                	jmp    80104ccc <higherPriority+0x7c>
80104cb6:	8d 76 00             	lea    0x0(%esi),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cc0:	05 b0 00 00 00       	add    $0xb0,%eax
80104cc5:	3d 94 71 11 80       	cmp    $0x80117194,%eax
80104cca:	73 11                	jae    80104cdd <higherPriority+0x8d>
    if(p->priority == cur_proc_priority && p->pid !=0 ) {
80104ccc:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104cd2:	75 ec                	jne    80104cc0 <higherPriority+0x70>
80104cd4:	8b 50 10             	mov    0x10(%eax),%edx
80104cd7:	85 d2                	test   %edx,%edx
80104cd9:	74 e5                	je     80104cc0 <higherPriority+0x70>
80104cdb:	eb ae                	jmp    80104c8b <higherPriority+0x3b>
  release(&ptable.lock);
80104cdd:	83 ec 0c             	sub    $0xc,%esp
80104ce0:	68 60 45 11 80       	push   $0x80114560
80104ce5:	e8 46 03 00 00       	call   80105030 <release>
  return 0; 
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	31 c0                	xor    %eax,%eax
80104cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    
80104cf4:	66 90                	xchg   %ax,%ax
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d0a:	68 20 83 10 80       	push   $0x80108320
80104d0f:	8d 43 04             	lea    0x4(%ebx),%eax
80104d12:	50                   	push   %eax
80104d13:	e8 18 01 00 00       	call   80104e30 <initlock>
  lk->name = name;
80104d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d21:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d24:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d2b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d31:	c9                   	leave  
80104d32:	c3                   	ret    
80104d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d4e:	56                   	push   %esi
80104d4f:	e8 1c 02 00 00       	call   80104f70 <acquire>
  while (lk->locked) {
80104d54:	8b 13                	mov    (%ebx),%edx
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 d2                	test   %edx,%edx
80104d5b:	74 16                	je     80104d73 <acquiresleep+0x33>
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104d60:	83 ec 08             	sub    $0x8,%esp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
80104d65:	e8 96 ec ff ff       	call   80103a00 <sleep>
  while (lk->locked) {
80104d6a:	8b 03                	mov    (%ebx),%eax
80104d6c:	83 c4 10             	add    $0x10,%esp
80104d6f:	85 c0                	test   %eax,%eax
80104d71:	75 ed                	jne    80104d60 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104d73:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d79:	e8 d2 e9 ff ff       	call   80103750 <myproc>
80104d7e:	8b 40 10             	mov    0x10(%eax),%eax
80104d81:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d84:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8a:	5b                   	pop    %ebx
80104d8b:	5e                   	pop    %esi
80104d8c:	5d                   	pop    %ebp
  release(&lk->lk);
80104d8d:	e9 9e 02 00 00       	jmp    80105030 <release>
80104d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104da8:	83 ec 0c             	sub    $0xc,%esp
80104dab:	8d 73 04             	lea    0x4(%ebx),%esi
80104dae:	56                   	push   %esi
80104daf:	e8 bc 01 00 00       	call   80104f70 <acquire>
  lk->locked = 0;
80104db4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104dba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104dc1:	89 1c 24             	mov    %ebx,(%esp)
80104dc4:	e8 17 ef ff ff       	call   80103ce0 <wakeup>
  release(&lk->lk);
80104dc9:	89 75 08             	mov    %esi,0x8(%ebp)
80104dcc:	83 c4 10             	add    $0x10,%esp
}
80104dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dd5:	e9 56 02 00 00       	jmp    80105030 <release>
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	53                   	push   %ebx
80104de6:	31 ff                	xor    %edi,%edi
80104de8:	83 ec 18             	sub    $0x18,%esp
80104deb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104dee:	8d 73 04             	lea    0x4(%ebx),%esi
80104df1:	56                   	push   %esi
80104df2:	e8 79 01 00 00       	call   80104f70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104df7:	8b 03                	mov    (%ebx),%eax
80104df9:	83 c4 10             	add    $0x10,%esp
80104dfc:	85 c0                	test   %eax,%eax
80104dfe:	74 13                	je     80104e13 <holdingsleep+0x33>
80104e00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e03:	e8 48 e9 ff ff       	call   80103750 <myproc>
80104e08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e0b:	0f 94 c0             	sete   %al
80104e0e:	0f b6 c0             	movzbl %al,%eax
80104e11:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104e13:	83 ec 0c             	sub    $0xc,%esp
80104e16:	56                   	push   %esi
80104e17:	e8 14 02 00 00       	call   80105030 <release>
  return r;
}
80104e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e1f:	89 f8                	mov    %edi,%eax
80104e21:	5b                   	pop    %ebx
80104e22:	5e                   	pop    %esi
80104e23:	5f                   	pop    %edi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	66 90                	xchg   %ax,%ax
80104e28:	66 90                	xchg   %ax,%ax
80104e2a:	66 90                	xchg   %ax,%ax
80104e2c:	66 90                	xchg   %ax,%ax
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    
80104e4b:	90                   	nop
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e50:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e51:	31 d2                	xor    %edx,%edx
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e56:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e5c:	83 e8 08             	sub    $0x8,%eax
80104e5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e60:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e6c:	77 1a                	ja     80104e88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e6e:	8b 58 04             	mov    0x4(%eax),%ebx
80104e71:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e74:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e77:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e79:	83 fa 0a             	cmp    $0xa,%edx
80104e7c:	75 e2                	jne    80104e60 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e7e:	5b                   	pop    %ebx
80104e7f:	5d                   	pop    %ebp
80104e80:	c3                   	ret    
80104e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e8b:	83 c1 28             	add    $0x28,%ecx
80104e8e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e99:	39 c1                	cmp    %eax,%ecx
80104e9b:	75 f3                	jne    80104e90 <getcallerpcs+0x40>
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5d                   	pop    %ebp
80104e9f:	c3                   	ret    

80104ea0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ea7:	9c                   	pushf  
80104ea8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ea9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104eaa:	e8 01 e8 ff ff       	call   801036b0 <mycpu>
80104eaf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	75 11                	jne    80104eca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104eb9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ebf:	e8 ec e7 ff ff       	call   801036b0 <mycpu>
80104ec4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104eca:	e8 e1 e7 ff ff       	call   801036b0 <mycpu>
80104ecf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ed6:	83 c4 04             	add    $0x4,%esp
80104ed9:	5b                   	pop    %ebx
80104eda:	5d                   	pop    %ebp
80104edb:	c3                   	ret    
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <popcli>:

void
popcli(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ee6:	9c                   	pushf  
80104ee7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ee8:	f6 c4 02             	test   $0x2,%ah
80104eeb:	75 35                	jne    80104f22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104eed:	e8 be e7 ff ff       	call   801036b0 <mycpu>
80104ef2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ef9:	78 34                	js     80104f2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104efb:	e8 b0 e7 ff ff       	call   801036b0 <mycpu>
80104f00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f06:	85 d2                	test   %edx,%edx
80104f08:	74 06                	je     80104f10 <popcli+0x30>
    sti();
}
80104f0a:	c9                   	leave  
80104f0b:	c3                   	ret    
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f10:	e8 9b e7 ff ff       	call   801036b0 <mycpu>
80104f15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f1b:	85 c0                	test   %eax,%eax
80104f1d:	74 eb                	je     80104f0a <popcli+0x2a>
  asm volatile("sti");
80104f1f:	fb                   	sti    
}
80104f20:	c9                   	leave  
80104f21:	c3                   	ret    
    panic("popcli - interruptible");
80104f22:	83 ec 0c             	sub    $0xc,%esp
80104f25:	68 2b 83 10 80       	push   $0x8010832b
80104f2a:	e8 61 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f2f:	83 ec 0c             	sub    $0xc,%esp
80104f32:	68 42 83 10 80       	push   $0x80108342
80104f37:	e8 54 b4 ff ff       	call   80100390 <panic>
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <holding>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	8b 75 08             	mov    0x8(%ebp),%esi
80104f48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f4a:	e8 51 ff ff ff       	call   80104ea0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f4f:	8b 06                	mov    (%esi),%eax
80104f51:	85 c0                	test   %eax,%eax
80104f53:	74 10                	je     80104f65 <holding+0x25>
80104f55:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f58:	e8 53 e7 ff ff       	call   801036b0 <mycpu>
80104f5d:	39 c3                	cmp    %eax,%ebx
80104f5f:	0f 94 c3             	sete   %bl
80104f62:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104f65:	e8 76 ff ff ff       	call   80104ee0 <popcli>
}
80104f6a:	89 d8                	mov    %ebx,%eax
80104f6c:	5b                   	pop    %ebx
80104f6d:	5e                   	pop    %esi
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    

80104f70 <acquire>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f75:	e8 26 ff ff ff       	call   80104ea0 <pushcli>
  if(holding(lk))
80104f7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	53                   	push   %ebx
80104f81:	e8 ba ff ff ff       	call   80104f40 <holding>
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	0f 85 83 00 00 00    	jne    80105014 <acquire+0xa4>
80104f91:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f93:	ba 01 00 00 00       	mov    $0x1,%edx
80104f98:	eb 09                	jmp    80104fa3 <acquire+0x33>
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fa0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fa3:	89 d0                	mov    %edx,%eax
80104fa5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	75 f4                	jne    80104fa0 <acquire+0x30>
  __sync_synchronize();
80104fac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fb4:	e8 f7 e6 ff ff       	call   801036b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104fb9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104fbc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104fbf:	89 e8                	mov    %ebp,%eax
80104fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fc8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104fce:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104fd4:	77 1a                	ja     80104ff0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104fd6:	8b 48 04             	mov    0x4(%eax),%ecx
80104fd9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104fdc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104fdf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fe1:	83 fe 0a             	cmp    $0xa,%esi
80104fe4:	75 e2                	jne    80104fc8 <acquire+0x58>
}
80104fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe9:	5b                   	pop    %ebx
80104fea:	5e                   	pop    %esi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ff3:	83 c2 28             	add    $0x28,%edx
80104ff6:	8d 76 00             	lea    0x0(%esi),%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105006:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105009:	39 d0                	cmp    %edx,%eax
8010500b:	75 f3                	jne    80105000 <acquire+0x90>
}
8010500d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105010:	5b                   	pop    %ebx
80105011:	5e                   	pop    %esi
80105012:	5d                   	pop    %ebp
80105013:	c3                   	ret    
    panic("acquire");
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	68 49 83 10 80       	push   $0x80108349
8010501c:	e8 6f b3 ff ff       	call   80100390 <panic>
80105021:	eb 0d                	jmp    80105030 <release>
80105023:	90                   	nop
80105024:	90                   	nop
80105025:	90                   	nop
80105026:	90                   	nop
80105027:	90                   	nop
80105028:	90                   	nop
80105029:	90                   	nop
8010502a:	90                   	nop
8010502b:	90                   	nop
8010502c:	90                   	nop
8010502d:	90                   	nop
8010502e:	90                   	nop
8010502f:	90                   	nop

80105030 <release>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 10             	sub    $0x10,%esp
80105037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010503a:	53                   	push   %ebx
8010503b:	e8 00 ff ff ff       	call   80104f40 <holding>
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	85 c0                	test   %eax,%eax
80105045:	74 22                	je     80105069 <release+0x39>
  lk->pcs[0] = 0;
80105047:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010504e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105055:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010505a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105063:	c9                   	leave  
  popcli();
80105064:	e9 77 fe ff ff       	jmp    80104ee0 <popcli>
    panic("release");
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	68 51 83 10 80       	push   $0x80108351
80105071:	e8 1a b3 ff ff       	call   80100390 <panic>
80105076:	66 90                	xchg   %ax,%ax
80105078:	66 90                	xchg   %ax,%ax
8010507a:	66 90                	xchg   %ax,%ax
8010507c:	66 90                	xchg   %ax,%ax
8010507e:	66 90                	xchg   %ax,%ax

80105080 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	53                   	push   %ebx
80105085:	8b 55 08             	mov    0x8(%ebp),%edx
80105088:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010508b:	f6 c2 03             	test   $0x3,%dl
8010508e:	75 05                	jne    80105095 <memset+0x15>
80105090:	f6 c1 03             	test   $0x3,%cl
80105093:	74 13                	je     801050a8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105095:	89 d7                	mov    %edx,%edi
80105097:	8b 45 0c             	mov    0xc(%ebp),%eax
8010509a:	fc                   	cld    
8010509b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010509d:	5b                   	pop    %ebx
8010509e:	89 d0                	mov    %edx,%eax
801050a0:	5f                   	pop    %edi
801050a1:	5d                   	pop    %ebp
801050a2:	c3                   	ret    
801050a3:	90                   	nop
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801050a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801050ac:	c1 e9 02             	shr    $0x2,%ecx
801050af:	89 f8                	mov    %edi,%eax
801050b1:	89 fb                	mov    %edi,%ebx
801050b3:	c1 e0 18             	shl    $0x18,%eax
801050b6:	c1 e3 10             	shl    $0x10,%ebx
801050b9:	09 d8                	or     %ebx,%eax
801050bb:	09 f8                	or     %edi,%eax
801050bd:	c1 e7 08             	shl    $0x8,%edi
801050c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801050c2:	89 d7                	mov    %edx,%edi
801050c4:	fc                   	cld    
801050c5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801050c7:	5b                   	pop    %ebx
801050c8:	89 d0                	mov    %edx,%eax
801050ca:	5f                   	pop    %edi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
801050d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801050d9:	8b 75 08             	mov    0x8(%ebp),%esi
801050dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050df:	85 db                	test   %ebx,%ebx
801050e1:	74 29                	je     8010510c <memcmp+0x3c>
    if(*s1 != *s2)
801050e3:	0f b6 16             	movzbl (%esi),%edx
801050e6:	0f b6 0f             	movzbl (%edi),%ecx
801050e9:	38 d1                	cmp    %dl,%cl
801050eb:	75 2b                	jne    80105118 <memcmp+0x48>
801050ed:	b8 01 00 00 00       	mov    $0x1,%eax
801050f2:	eb 14                	jmp    80105108 <memcmp+0x38>
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801050fc:	83 c0 01             	add    $0x1,%eax
801050ff:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105104:	38 ca                	cmp    %cl,%dl
80105106:	75 10                	jne    80105118 <memcmp+0x48>
  while(n-- > 0){
80105108:	39 d8                	cmp    %ebx,%eax
8010510a:	75 ec                	jne    801050f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010510c:	5b                   	pop    %ebx
  return 0;
8010510d:	31 c0                	xor    %eax,%eax
}
8010510f:	5e                   	pop    %esi
80105110:	5f                   	pop    %edi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	90                   	nop
80105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105118:	0f b6 c2             	movzbl %dl,%eax
}
8010511b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010511c:	29 c8                	sub    %ecx,%eax
}
8010511e:	5e                   	pop    %esi
8010511f:	5f                   	pop    %edi
80105120:	5d                   	pop    %ebp
80105121:	c3                   	ret    
80105122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	8b 45 08             	mov    0x8(%ebp),%eax
80105138:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010513b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010513e:	39 c3                	cmp    %eax,%ebx
80105140:	73 26                	jae    80105168 <memmove+0x38>
80105142:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105145:	39 c8                	cmp    %ecx,%eax
80105147:	73 1f                	jae    80105168 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105149:	85 f6                	test   %esi,%esi
8010514b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010514e:	74 0f                	je     8010515f <memmove+0x2f>
      *--d = *--s;
80105150:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105154:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105157:	83 ea 01             	sub    $0x1,%edx
8010515a:	83 fa ff             	cmp    $0xffffffff,%edx
8010515d:	75 f1                	jne    80105150 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010515f:	5b                   	pop    %ebx
80105160:	5e                   	pop    %esi
80105161:	5d                   	pop    %ebp
80105162:	c3                   	ret    
80105163:	90                   	nop
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105168:	31 d2                	xor    %edx,%edx
8010516a:	85 f6                	test   %esi,%esi
8010516c:	74 f1                	je     8010515f <memmove+0x2f>
8010516e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105170:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105174:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105177:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010517a:	39 d6                	cmp    %edx,%esi
8010517c:	75 f2                	jne    80105170 <memmove+0x40>
}
8010517e:	5b                   	pop    %ebx
8010517f:	5e                   	pop    %esi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105193:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105194:	eb 9a                	jmp    80105130 <memmove>
80105196:	8d 76 00             	lea    0x0(%esi),%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801051a8:	53                   	push   %ebx
801051a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801051af:	85 ff                	test   %edi,%edi
801051b1:	74 2f                	je     801051e2 <strncmp+0x42>
801051b3:	0f b6 01             	movzbl (%ecx),%eax
801051b6:	0f b6 1e             	movzbl (%esi),%ebx
801051b9:	84 c0                	test   %al,%al
801051bb:	74 37                	je     801051f4 <strncmp+0x54>
801051bd:	38 c3                	cmp    %al,%bl
801051bf:	75 33                	jne    801051f4 <strncmp+0x54>
801051c1:	01 f7                	add    %esi,%edi
801051c3:	eb 13                	jmp    801051d8 <strncmp+0x38>
801051c5:	8d 76 00             	lea    0x0(%esi),%esi
801051c8:	0f b6 01             	movzbl (%ecx),%eax
801051cb:	84 c0                	test   %al,%al
801051cd:	74 21                	je     801051f0 <strncmp+0x50>
801051cf:	0f b6 1a             	movzbl (%edx),%ebx
801051d2:	89 d6                	mov    %edx,%esi
801051d4:	38 d8                	cmp    %bl,%al
801051d6:	75 1c                	jne    801051f4 <strncmp+0x54>
    n--, p++, q++;
801051d8:	8d 56 01             	lea    0x1(%esi),%edx
801051db:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801051de:	39 fa                	cmp    %edi,%edx
801051e0:	75 e6                	jne    801051c8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801051e2:	5b                   	pop    %ebx
    return 0;
801051e3:	31 c0                	xor    %eax,%eax
}
801051e5:	5e                   	pop    %esi
801051e6:	5f                   	pop    %edi
801051e7:	5d                   	pop    %ebp
801051e8:	c3                   	ret    
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051f0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801051f4:	29 d8                	sub    %ebx,%eax
}
801051f6:	5b                   	pop    %ebx
801051f7:	5e                   	pop    %esi
801051f8:	5f                   	pop    %edi
801051f9:	5d                   	pop    %ebp
801051fa:	c3                   	ret    
801051fb:	90                   	nop
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105200 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
80105205:	8b 45 08             	mov    0x8(%ebp),%eax
80105208:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010520b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010520e:	89 c2                	mov    %eax,%edx
80105210:	eb 19                	jmp    8010522b <strncpy+0x2b>
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105218:	83 c3 01             	add    $0x1,%ebx
8010521b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010521f:	83 c2 01             	add    $0x1,%edx
80105222:	84 c9                	test   %cl,%cl
80105224:	88 4a ff             	mov    %cl,-0x1(%edx)
80105227:	74 09                	je     80105232 <strncpy+0x32>
80105229:	89 f1                	mov    %esi,%ecx
8010522b:	85 c9                	test   %ecx,%ecx
8010522d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105230:	7f e6                	jg     80105218 <strncpy+0x18>
    ;
  while(n-- > 0)
80105232:	31 c9                	xor    %ecx,%ecx
80105234:	85 f6                	test   %esi,%esi
80105236:	7e 17                	jle    8010524f <strncpy+0x4f>
80105238:	90                   	nop
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105240:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105244:	89 f3                	mov    %esi,%ebx
80105246:	83 c1 01             	add    $0x1,%ecx
80105249:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010524b:	85 db                	test   %ebx,%ebx
8010524d:	7f f1                	jg     80105240 <strncpy+0x40>
  return os;
}
8010524f:	5b                   	pop    %ebx
80105250:	5e                   	pop    %esi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret    
80105253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
80105265:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105268:	8b 45 08             	mov    0x8(%ebp),%eax
8010526b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010526e:	85 c9                	test   %ecx,%ecx
80105270:	7e 26                	jle    80105298 <safestrcpy+0x38>
80105272:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105276:	89 c1                	mov    %eax,%ecx
80105278:	eb 17                	jmp    80105291 <safestrcpy+0x31>
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105280:	83 c2 01             	add    $0x1,%edx
80105283:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105287:	83 c1 01             	add    $0x1,%ecx
8010528a:	84 db                	test   %bl,%bl
8010528c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010528f:	74 04                	je     80105295 <safestrcpy+0x35>
80105291:	39 f2                	cmp    %esi,%edx
80105293:	75 eb                	jne    80105280 <safestrcpy+0x20>
    ;
  *s = 0;
80105295:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105298:	5b                   	pop    %ebx
80105299:	5e                   	pop    %esi
8010529a:	5d                   	pop    %ebp
8010529b:	c3                   	ret    
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052a0 <strlen>:

int
strlen(const char *s)
{
801052a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801052a1:	31 c0                	xor    %eax,%eax
{
801052a3:	89 e5                	mov    %esp,%ebp
801052a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801052a8:	80 3a 00             	cmpb   $0x0,(%edx)
801052ab:	74 0c                	je     801052b9 <strlen+0x19>
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
801052b0:	83 c0 01             	add    $0x1,%eax
801052b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801052b7:	75 f7                	jne    801052b0 <strlen+0x10>
    ;
  return n;
}
801052b9:	5d                   	pop    %ebp
801052ba:	c3                   	ret    

801052bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801052c3:	55                   	push   %ebp
  pushl %ebx
801052c4:	53                   	push   %ebx
  pushl %esi
801052c5:	56                   	push   %esi
  pushl %edi
801052c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801052cb:	5f                   	pop    %edi
  popl %esi
801052cc:	5e                   	pop    %esi
  popl %ebx
801052cd:	5b                   	pop    %ebx
  popl %ebp
801052ce:	5d                   	pop    %ebp
  ret
801052cf:	c3                   	ret    

801052d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
801052d4:	83 ec 04             	sub    $0x4,%esp
801052d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052da:	e8 71 e4 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052df:	8b 00                	mov    (%eax),%eax
801052e1:	39 d8                	cmp    %ebx,%eax
801052e3:	76 1b                	jbe    80105300 <fetchint+0x30>
801052e5:	8d 53 04             	lea    0x4(%ebx),%edx
801052e8:	39 d0                	cmp    %edx,%eax
801052ea:	72 14                	jb     80105300 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ef:	8b 13                	mov    (%ebx),%edx
801052f1:	89 10                	mov    %edx,(%eax)
  return 0;
801052f3:	31 c0                	xor    %eax,%eax
}
801052f5:	83 c4 04             	add    $0x4,%esp
801052f8:	5b                   	pop    %ebx
801052f9:	5d                   	pop    %ebp
801052fa:	c3                   	ret    
801052fb:	90                   	nop
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb ee                	jmp    801052f5 <fetchint+0x25>
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 04             	sub    $0x4,%esp
80105317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010531a:	e8 31 e4 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz)
8010531f:	39 18                	cmp    %ebx,(%eax)
80105321:	76 29                	jbe    8010534c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105326:	89 da                	mov    %ebx,%edx
80105328:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010532a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010532c:	39 c3                	cmp    %eax,%ebx
8010532e:	73 1c                	jae    8010534c <fetchstr+0x3c>
    if(*s == 0)
80105330:	80 3b 00             	cmpb   $0x0,(%ebx)
80105333:	75 10                	jne    80105345 <fetchstr+0x35>
80105335:	eb 39                	jmp    80105370 <fetchstr+0x60>
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105340:	80 3a 00             	cmpb   $0x0,(%edx)
80105343:	74 1b                	je     80105360 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105345:	83 c2 01             	add    $0x1,%edx
80105348:	39 d0                	cmp    %edx,%eax
8010534a:	77 f4                	ja     80105340 <fetchstr+0x30>
    return -1;
8010534c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105351:	83 c4 04             	add    $0x4,%esp
80105354:	5b                   	pop    %ebx
80105355:	5d                   	pop    %ebp
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105360:	83 c4 04             	add    $0x4,%esp
80105363:	89 d0                	mov    %edx,%eax
80105365:	29 d8                	sub    %ebx,%eax
80105367:	5b                   	pop    %ebx
80105368:	5d                   	pop    %ebp
80105369:	c3                   	ret    
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105370:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105372:	eb dd                	jmp    80105351 <fetchstr+0x41>
80105374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010537a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105380 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105385:	e8 c6 e3 ff ff       	call   80103750 <myproc>
8010538a:	8b 40 18             	mov    0x18(%eax),%eax
8010538d:	8b 55 08             	mov    0x8(%ebp),%edx
80105390:	8b 40 44             	mov    0x44(%eax),%eax
80105393:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105396:	e8 b5 e3 ff ff       	call   80103750 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010539b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010539d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053a0:	39 c6                	cmp    %eax,%esi
801053a2:	73 1c                	jae    801053c0 <argint+0x40>
801053a4:	8d 53 08             	lea    0x8(%ebx),%edx
801053a7:	39 d0                	cmp    %edx,%eax
801053a9:	72 15                	jb     801053c0 <argint+0x40>
  *ip = *(int*)(addr);
801053ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ae:	8b 53 04             	mov    0x4(%ebx),%edx
801053b1:	89 10                	mov    %edx,(%eax)
  return 0;
801053b3:	31 c0                	xor    %eax,%eax
}
801053b5:	5b                   	pop    %ebx
801053b6:	5e                   	pop    %esi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053c5:	eb ee                	jmp    801053b5 <argint+0x35>
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
801053d5:	83 ec 10             	sub    $0x10,%esp
801053d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801053db:	e8 70 e3 ff ff       	call   80103750 <myproc>
801053e0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801053e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053e5:	83 ec 08             	sub    $0x8,%esp
801053e8:	50                   	push   %eax
801053e9:	ff 75 08             	pushl  0x8(%ebp)
801053ec:	e8 8f ff ff ff       	call   80105380 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053f1:	83 c4 10             	add    $0x10,%esp
801053f4:	85 c0                	test   %eax,%eax
801053f6:	78 28                	js     80105420 <argptr+0x50>
801053f8:	85 db                	test   %ebx,%ebx
801053fa:	78 24                	js     80105420 <argptr+0x50>
801053fc:	8b 16                	mov    (%esi),%edx
801053fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105401:	39 c2                	cmp    %eax,%edx
80105403:	76 1b                	jbe    80105420 <argptr+0x50>
80105405:	01 c3                	add    %eax,%ebx
80105407:	39 da                	cmp    %ebx,%edx
80105409:	72 15                	jb     80105420 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010540b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010540e:	89 02                	mov    %eax,(%edx)
  return 0;
80105410:	31 c0                	xor    %eax,%eax
}
80105412:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105415:	5b                   	pop    %ebx
80105416:	5e                   	pop    %esi
80105417:	5d                   	pop    %ebp
80105418:	c3                   	ret    
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105425:	eb eb                	jmp    80105412 <argptr+0x42>
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105439:	50                   	push   %eax
8010543a:	ff 75 08             	pushl  0x8(%ebp)
8010543d:	e8 3e ff ff ff       	call   80105380 <argint>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 17                	js     80105460 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105449:	83 ec 08             	sub    $0x8,%esp
8010544c:	ff 75 0c             	pushl  0xc(%ebp)
8010544f:	ff 75 f4             	pushl  -0xc(%ebp)
80105452:	e8 b9 fe ff ff       	call   80105310 <fetchstr>
80105457:	83 c4 10             	add    $0x10,%esp
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <syscall>:
[SYS_getpinfo]  sys_getpinfo, 
};

void
syscall(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	53                   	push   %ebx
80105474:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105477:	e8 d4 e2 ff ff       	call   80103750 <myproc>
8010547c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010547e:	8b 40 18             	mov    0x18(%eax),%eax
80105481:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105484:	8d 50 ff             	lea    -0x1(%eax),%edx
80105487:	83 fa 17             	cmp    $0x17,%edx
8010548a:	77 1c                	ja     801054a8 <syscall+0x38>
8010548c:	8b 14 85 80 83 10 80 	mov    -0x7fef7c80(,%eax,4),%edx
80105493:	85 d2                	test   %edx,%edx
80105495:	74 11                	je     801054a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105497:	ff d2                	call   *%edx
80105499:	8b 53 18             	mov    0x18(%ebx),%edx
8010549c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010549f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054a2:	c9                   	leave  
801054a3:	c3                   	ret    
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801054a8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801054a9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801054ac:	50                   	push   %eax
801054ad:	ff 73 10             	pushl  0x10(%ebx)
801054b0:	68 59 83 10 80       	push   $0x80108359
801054b5:	e8 a6 b1 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801054ba:	8b 43 18             	mov    0x18(%ebx),%eax
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801054c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054ca:	c9                   	leave  
801054cb:	c3                   	ret    
801054cc:	66 90                	xchg   %ax,%ax
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801054d6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801054d9:	83 ec 34             	sub    $0x34,%esp
801054dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801054df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801054e2:	56                   	push   %esi
801054e3:	50                   	push   %eax
{
801054e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801054e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801054ea:	e8 11 ca ff ff       	call   80101f00 <nameiparent>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	85 c0                	test   %eax,%eax
801054f4:	0f 84 46 01 00 00    	je     80105640 <create+0x170>
    return 0;
  ilock(dp);
801054fa:	83 ec 0c             	sub    $0xc,%esp
801054fd:	89 c3                	mov    %eax,%ebx
801054ff:	50                   	push   %eax
80105500:	e8 7b c1 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105505:	83 c4 0c             	add    $0xc,%esp
80105508:	6a 00                	push   $0x0
8010550a:	56                   	push   %esi
8010550b:	53                   	push   %ebx
8010550c:	e8 9f c6 ff ff       	call   80101bb0 <dirlookup>
80105511:	83 c4 10             	add    $0x10,%esp
80105514:	85 c0                	test   %eax,%eax
80105516:	89 c7                	mov    %eax,%edi
80105518:	74 36                	je     80105550 <create+0x80>
    iunlockput(dp);
8010551a:	83 ec 0c             	sub    $0xc,%esp
8010551d:	53                   	push   %ebx
8010551e:	e8 ed c3 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105523:	89 3c 24             	mov    %edi,(%esp)
80105526:	e8 55 c1 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010552b:	83 c4 10             	add    $0x10,%esp
8010552e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105533:	0f 85 97 00 00 00    	jne    801055d0 <create+0x100>
80105539:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010553e:	0f 85 8c 00 00 00    	jne    801055d0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105547:	89 f8                	mov    %edi,%eax
80105549:	5b                   	pop    %ebx
8010554a:	5e                   	pop    %esi
8010554b:	5f                   	pop    %edi
8010554c:	5d                   	pop    %ebp
8010554d:	c3                   	ret    
8010554e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105550:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105554:	83 ec 08             	sub    $0x8,%esp
80105557:	50                   	push   %eax
80105558:	ff 33                	pushl  (%ebx)
8010555a:	e8 b1 bf ff ff       	call   80101510 <ialloc>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	89 c7                	mov    %eax,%edi
80105566:	0f 84 e8 00 00 00    	je     80105654 <create+0x184>
  ilock(ip);
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	50                   	push   %eax
80105570:	e8 0b c1 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105575:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105579:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010557d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105581:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105585:	b8 01 00 00 00       	mov    $0x1,%eax
8010558a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010558e:	89 3c 24             	mov    %edi,(%esp)
80105591:	e8 3a c0 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010559e:	74 50                	je     801055f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801055a0:	83 ec 04             	sub    $0x4,%esp
801055a3:	ff 77 04             	pushl  0x4(%edi)
801055a6:	56                   	push   %esi
801055a7:	53                   	push   %ebx
801055a8:	e8 73 c8 ff ff       	call   80101e20 <dirlink>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	0f 88 8f 00 00 00    	js     80105647 <create+0x177>
  iunlockput(dp);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	53                   	push   %ebx
801055bc:	e8 4f c3 ff ff       	call   80101910 <iunlockput>
  return ip;
801055c1:	83 c4 10             	add    $0x10,%esp
}
801055c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c7:	89 f8                	mov    %edi,%eax
801055c9:	5b                   	pop    %ebx
801055ca:	5e                   	pop    %esi
801055cb:	5f                   	pop    %edi
801055cc:	5d                   	pop    %ebp
801055cd:	c3                   	ret    
801055ce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	57                   	push   %edi
    return 0;
801055d4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801055d6:	e8 35 c3 ff ff       	call   80101910 <iunlockput>
    return 0;
801055db:	83 c4 10             	add    $0x10,%esp
}
801055de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e1:	89 f8                	mov    %edi,%eax
801055e3:	5b                   	pop    %ebx
801055e4:	5e                   	pop    %esi
801055e5:	5f                   	pop    %edi
801055e6:	5d                   	pop    %ebp
801055e7:	c3                   	ret    
801055e8:	90                   	nop
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801055f0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	53                   	push   %ebx
801055f9:	e8 d2 bf ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801055fe:	83 c4 0c             	add    $0xc,%esp
80105601:	ff 77 04             	pushl  0x4(%edi)
80105604:	68 00 84 10 80       	push   $0x80108400
80105609:	57                   	push   %edi
8010560a:	e8 11 c8 ff ff       	call   80101e20 <dirlink>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	85 c0                	test   %eax,%eax
80105614:	78 1c                	js     80105632 <create+0x162>
80105616:	83 ec 04             	sub    $0x4,%esp
80105619:	ff 73 04             	pushl  0x4(%ebx)
8010561c:	68 ff 83 10 80       	push   $0x801083ff
80105621:	57                   	push   %edi
80105622:	e8 f9 c7 ff ff       	call   80101e20 <dirlink>
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	85 c0                	test   %eax,%eax
8010562c:	0f 89 6e ff ff ff    	jns    801055a0 <create+0xd0>
      panic("create dots");
80105632:	83 ec 0c             	sub    $0xc,%esp
80105635:	68 f3 83 10 80       	push   $0x801083f3
8010563a:	e8 51 ad ff ff       	call   80100390 <panic>
8010563f:	90                   	nop
    return 0;
80105640:	31 ff                	xor    %edi,%edi
80105642:	e9 fd fe ff ff       	jmp    80105544 <create+0x74>
    panic("create: dirlink");
80105647:	83 ec 0c             	sub    $0xc,%esp
8010564a:	68 02 84 10 80       	push   $0x80108402
8010564f:	e8 3c ad ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105654:	83 ec 0c             	sub    $0xc,%esp
80105657:	68 e4 83 10 80       	push   $0x801083e4
8010565c:	e8 2f ad ff ff       	call   80100390 <panic>
80105661:	eb 0d                	jmp    80105670 <argfd.constprop.0>
80105663:	90                   	nop
80105664:	90                   	nop
80105665:	90                   	nop
80105666:	90                   	nop
80105667:	90                   	nop
80105668:	90                   	nop
80105669:	90                   	nop
8010566a:	90                   	nop
8010566b:	90                   	nop
8010566c:	90                   	nop
8010566d:	90                   	nop
8010566e:	90                   	nop
8010566f:	90                   	nop

80105670 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
80105675:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105677:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010567a:	89 d6                	mov    %edx,%esi
8010567c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010567f:	50                   	push   %eax
80105680:	6a 00                	push   $0x0
80105682:	e8 f9 fc ff ff       	call   80105380 <argint>
80105687:	83 c4 10             	add    $0x10,%esp
8010568a:	85 c0                	test   %eax,%eax
8010568c:	78 2a                	js     801056b8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010568e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105692:	77 24                	ja     801056b8 <argfd.constprop.0+0x48>
80105694:	e8 b7 e0 ff ff       	call   80103750 <myproc>
80105699:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010569c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801056a0:	85 c0                	test   %eax,%eax
801056a2:	74 14                	je     801056b8 <argfd.constprop.0+0x48>
  if(pfd)
801056a4:	85 db                	test   %ebx,%ebx
801056a6:	74 02                	je     801056aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801056a8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801056aa:	89 06                	mov    %eax,(%esi)
  return 0;
801056ac:	31 c0                	xor    %eax,%eax
}
801056ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056b1:	5b                   	pop    %ebx
801056b2:	5e                   	pop    %esi
801056b3:	5d                   	pop    %ebp
801056b4:	c3                   	ret    
801056b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bd:	eb ef                	jmp    801056ae <argfd.constprop.0+0x3e>
801056bf:	90                   	nop

801056c0 <sys_dup>:
{
801056c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	56                   	push   %esi
801056c6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801056c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801056ca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801056cd:	e8 9e ff ff ff       	call   80105670 <argfd.constprop.0>
801056d2:	85 c0                	test   %eax,%eax
801056d4:	78 42                	js     80105718 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801056d6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056d9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056db:	e8 70 e0 ff ff       	call   80103750 <myproc>
801056e0:	eb 0e                	jmp    801056f0 <sys_dup+0x30>
801056e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056e8:	83 c3 01             	add    $0x1,%ebx
801056eb:	83 fb 10             	cmp    $0x10,%ebx
801056ee:	74 28                	je     80105718 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801056f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056f4:	85 d2                	test   %edx,%edx
801056f6:	75 f0                	jne    801056e8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801056f8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105702:	e8 e9 b6 ff ff       	call   80100df0 <filedup>
  return fd;
80105707:	83 c4 10             	add    $0x10,%esp
}
8010570a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010570d:	89 d8                	mov    %ebx,%eax
8010570f:	5b                   	pop    %ebx
80105710:	5e                   	pop    %esi
80105711:	5d                   	pop    %ebp
80105712:	c3                   	ret    
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105718:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010571b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105720:	89 d8                	mov    %ebx,%eax
80105722:	5b                   	pop    %ebx
80105723:	5e                   	pop    %esi
80105724:	5d                   	pop    %ebp
80105725:	c3                   	ret    
80105726:	8d 76 00             	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_read>:
{
80105730:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105731:	31 c0                	xor    %eax,%eax
{
80105733:	89 e5                	mov    %esp,%ebp
80105735:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105738:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010573b:	e8 30 ff ff ff       	call   80105670 <argfd.constprop.0>
80105740:	85 c0                	test   %eax,%eax
80105742:	78 4c                	js     80105790 <sys_read+0x60>
80105744:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105747:	83 ec 08             	sub    $0x8,%esp
8010574a:	50                   	push   %eax
8010574b:	6a 02                	push   $0x2
8010574d:	e8 2e fc ff ff       	call   80105380 <argint>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 37                	js     80105790 <sys_read+0x60>
80105759:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575c:	83 ec 04             	sub    $0x4,%esp
8010575f:	ff 75 f0             	pushl  -0x10(%ebp)
80105762:	50                   	push   %eax
80105763:	6a 01                	push   $0x1
80105765:	e8 66 fc ff ff       	call   801053d0 <argptr>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	78 1f                	js     80105790 <sys_read+0x60>
  return fileread(f, p, n);
80105771:	83 ec 04             	sub    $0x4,%esp
80105774:	ff 75 f0             	pushl  -0x10(%ebp)
80105777:	ff 75 f4             	pushl  -0xc(%ebp)
8010577a:	ff 75 ec             	pushl  -0x14(%ebp)
8010577d:	e8 de b7 ff ff       	call   80100f60 <fileread>
80105782:	83 c4 10             	add    $0x10,%esp
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105795:	c9                   	leave  
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <sys_write>:
{
801057a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057a1:	31 c0                	xor    %eax,%eax
{
801057a3:	89 e5                	mov    %esp,%ebp
801057a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801057ab:	e8 c0 fe ff ff       	call   80105670 <argfd.constprop.0>
801057b0:	85 c0                	test   %eax,%eax
801057b2:	78 4c                	js     80105800 <sys_write+0x60>
801057b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b7:	83 ec 08             	sub    $0x8,%esp
801057ba:	50                   	push   %eax
801057bb:	6a 02                	push   $0x2
801057bd:	e8 be fb ff ff       	call   80105380 <argint>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	78 37                	js     80105800 <sys_write+0x60>
801057c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057cc:	83 ec 04             	sub    $0x4,%esp
801057cf:	ff 75 f0             	pushl  -0x10(%ebp)
801057d2:	50                   	push   %eax
801057d3:	6a 01                	push   $0x1
801057d5:	e8 f6 fb ff ff       	call   801053d0 <argptr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	78 1f                	js     80105800 <sys_write+0x60>
  return filewrite(f, p, n);
801057e1:	83 ec 04             	sub    $0x4,%esp
801057e4:	ff 75 f0             	pushl  -0x10(%ebp)
801057e7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ea:	ff 75 ec             	pushl  -0x14(%ebp)
801057ed:	e8 fe b7 ff ff       	call   80100ff0 <filewrite>
801057f2:	83 c4 10             	add    $0x10,%esp
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105805:	c9                   	leave  
80105806:	c3                   	ret    
80105807:	89 f6                	mov    %esi,%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <sys_close>:
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105816:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105819:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010581c:	e8 4f fe ff ff       	call   80105670 <argfd.constprop.0>
80105821:	85 c0                	test   %eax,%eax
80105823:	78 2b                	js     80105850 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105825:	e8 26 df ff ff       	call   80103750 <myproc>
8010582a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010582d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105830:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105837:	00 
  fileclose(f);
80105838:	ff 75 f4             	pushl  -0xc(%ebp)
8010583b:	e8 00 b6 ff ff       	call   80100e40 <fileclose>
  return 0;
80105840:	83 c4 10             	add    $0x10,%esp
80105843:	31 c0                	xor    %eax,%eax
}
80105845:	c9                   	leave  
80105846:	c3                   	ret    
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_fstat>:
{
80105860:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105861:	31 c0                	xor    %eax,%eax
{
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105868:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010586b:	e8 00 fe ff ff       	call   80105670 <argfd.constprop.0>
80105870:	85 c0                	test   %eax,%eax
80105872:	78 2c                	js     801058a0 <sys_fstat+0x40>
80105874:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105877:	83 ec 04             	sub    $0x4,%esp
8010587a:	6a 14                	push   $0x14
8010587c:	50                   	push   %eax
8010587d:	6a 01                	push   $0x1
8010587f:	e8 4c fb ff ff       	call   801053d0 <argptr>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	78 15                	js     801058a0 <sys_fstat+0x40>
  return filestat(f, st);
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	ff 75 f4             	pushl  -0xc(%ebp)
80105891:	ff 75 f0             	pushl  -0x10(%ebp)
80105894:	e8 77 b6 ff ff       	call   80100f10 <filestat>
80105899:	83 c4 10             	add    $0x10,%esp
}
8010589c:	c9                   	leave  
8010589d:	c3                   	ret    
8010589e:	66 90                	xchg   %ax,%ax
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058b0 <sys_link>:
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
801058b5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801058b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058bc:	50                   	push   %eax
801058bd:	6a 00                	push   $0x0
801058bf:	e8 6c fb ff ff       	call   80105430 <argstr>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	85 c0                	test   %eax,%eax
801058c9:	0f 88 fb 00 00 00    	js     801059ca <sys_link+0x11a>
801058cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801058d2:	83 ec 08             	sub    $0x8,%esp
801058d5:	50                   	push   %eax
801058d6:	6a 01                	push   $0x1
801058d8:	e8 53 fb ff ff       	call   80105430 <argstr>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	0f 88 e2 00 00 00    	js     801059ca <sys_link+0x11a>
  begin_op();
801058e8:	e8 b3 d2 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801058f3:	e8 e8 c5 ff ff       	call   80101ee0 <namei>
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	85 c0                	test   %eax,%eax
801058fd:	89 c3                	mov    %eax,%ebx
801058ff:	0f 84 ea 00 00 00    	je     801059ef <sys_link+0x13f>
  ilock(ip);
80105905:	83 ec 0c             	sub    $0xc,%esp
80105908:	50                   	push   %eax
80105909:	e8 72 bd ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105916:	0f 84 bb 00 00 00    	je     801059d7 <sys_link+0x127>
  ip->nlink++;
8010591c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105921:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105924:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105927:	53                   	push   %ebx
80105928:	e8 a3 bc ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010592d:	89 1c 24             	mov    %ebx,(%esp)
80105930:	e8 2b be ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105935:	58                   	pop    %eax
80105936:	5a                   	pop    %edx
80105937:	57                   	push   %edi
80105938:	ff 75 d0             	pushl  -0x30(%ebp)
8010593b:	e8 c0 c5 ff ff       	call   80101f00 <nameiparent>
80105940:	83 c4 10             	add    $0x10,%esp
80105943:	85 c0                	test   %eax,%eax
80105945:	89 c6                	mov    %eax,%esi
80105947:	74 5b                	je     801059a4 <sys_link+0xf4>
  ilock(dp);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	50                   	push   %eax
8010594d:	e8 2e bd ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	8b 03                	mov    (%ebx),%eax
80105957:	39 06                	cmp    %eax,(%esi)
80105959:	75 3d                	jne    80105998 <sys_link+0xe8>
8010595b:	83 ec 04             	sub    $0x4,%esp
8010595e:	ff 73 04             	pushl  0x4(%ebx)
80105961:	57                   	push   %edi
80105962:	56                   	push   %esi
80105963:	e8 b8 c4 ff ff       	call   80101e20 <dirlink>
80105968:	83 c4 10             	add    $0x10,%esp
8010596b:	85 c0                	test   %eax,%eax
8010596d:	78 29                	js     80105998 <sys_link+0xe8>
  iunlockput(dp);
8010596f:	83 ec 0c             	sub    $0xc,%esp
80105972:	56                   	push   %esi
80105973:	e8 98 bf ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105978:	89 1c 24             	mov    %ebx,(%esp)
8010597b:	e8 30 be ff ff       	call   801017b0 <iput>
  end_op();
80105980:	e8 8b d2 ff ff       	call   80102c10 <end_op>
  return 0;
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	31 c0                	xor    %eax,%eax
}
8010598a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010598d:	5b                   	pop    %ebx
8010598e:	5e                   	pop    %esi
8010598f:	5f                   	pop    %edi
80105990:	5d                   	pop    %ebp
80105991:	c3                   	ret    
80105992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	56                   	push   %esi
8010599c:	e8 6f bf ff ff       	call   80101910 <iunlockput>
    goto bad;
801059a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801059a4:	83 ec 0c             	sub    $0xc,%esp
801059a7:	53                   	push   %ebx
801059a8:	e8 d3 bc ff ff       	call   80101680 <ilock>
  ip->nlink--;
801059ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059b2:	89 1c 24             	mov    %ebx,(%esp)
801059b5:	e8 16 bc ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801059ba:	89 1c 24             	mov    %ebx,(%esp)
801059bd:	e8 4e bf ff ff       	call   80101910 <iunlockput>
  end_op();
801059c2:	e8 49 d2 ff ff       	call   80102c10 <end_op>
  return -1;
801059c7:	83 c4 10             	add    $0x10,%esp
}
801059ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801059cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d2:	5b                   	pop    %ebx
801059d3:	5e                   	pop    %esi
801059d4:	5f                   	pop    %edi
801059d5:	5d                   	pop    %ebp
801059d6:	c3                   	ret    
    iunlockput(ip);
801059d7:	83 ec 0c             	sub    $0xc,%esp
801059da:	53                   	push   %ebx
801059db:	e8 30 bf ff ff       	call   80101910 <iunlockput>
    end_op();
801059e0:	e8 2b d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ed:	eb 9b                	jmp    8010598a <sys_link+0xda>
    end_op();
801059ef:	e8 1c d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f9:	eb 8f                	jmp    8010598a <sys_link+0xda>
801059fb:	90                   	nop
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_unlink>:
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105a06:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a09:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105a0c:	50                   	push   %eax
80105a0d:	6a 00                	push   $0x0
80105a0f:	e8 1c fa ff ff       	call   80105430 <argstr>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	0f 88 77 01 00 00    	js     80105b96 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105a1f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105a22:	e8 79 d1 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a27:	83 ec 08             	sub    $0x8,%esp
80105a2a:	53                   	push   %ebx
80105a2b:	ff 75 c0             	pushl  -0x40(%ebp)
80105a2e:	e8 cd c4 ff ff       	call   80101f00 <nameiparent>
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	89 c6                	mov    %eax,%esi
80105a3a:	0f 84 60 01 00 00    	je     80105ba0 <sys_unlink+0x1a0>
  ilock(dp);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	50                   	push   %eax
80105a44:	e8 37 bc ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a49:	58                   	pop    %eax
80105a4a:	5a                   	pop    %edx
80105a4b:	68 00 84 10 80       	push   $0x80108400
80105a50:	53                   	push   %ebx
80105a51:	e8 3a c1 ff ff       	call   80101b90 <namecmp>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	0f 84 03 01 00 00    	je     80105b64 <sys_unlink+0x164>
80105a61:	83 ec 08             	sub    $0x8,%esp
80105a64:	68 ff 83 10 80       	push   $0x801083ff
80105a69:	53                   	push   %ebx
80105a6a:	e8 21 c1 ff ff       	call   80101b90 <namecmp>
80105a6f:	83 c4 10             	add    $0x10,%esp
80105a72:	85 c0                	test   %eax,%eax
80105a74:	0f 84 ea 00 00 00    	je     80105b64 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105a7a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a7d:	83 ec 04             	sub    $0x4,%esp
80105a80:	50                   	push   %eax
80105a81:	53                   	push   %ebx
80105a82:	56                   	push   %esi
80105a83:	e8 28 c1 ff ff       	call   80101bb0 <dirlookup>
80105a88:	83 c4 10             	add    $0x10,%esp
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	89 c3                	mov    %eax,%ebx
80105a8f:	0f 84 cf 00 00 00    	je     80105b64 <sys_unlink+0x164>
  ilock(ip);
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	50                   	push   %eax
80105a99:	e8 e2 bb ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105aa6:	0f 8e 10 01 00 00    	jle    80105bbc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105aac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ab1:	74 6d                	je     80105b20 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105ab3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ab6:	83 ec 04             	sub    $0x4,%esp
80105ab9:	6a 10                	push   $0x10
80105abb:	6a 00                	push   $0x0
80105abd:	50                   	push   %eax
80105abe:	e8 bd f5 ff ff       	call   80105080 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ac3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ac6:	6a 10                	push   $0x10
80105ac8:	ff 75 c4             	pushl  -0x3c(%ebp)
80105acb:	50                   	push   %eax
80105acc:	56                   	push   %esi
80105acd:	e8 8e bf ff ff       	call   80101a60 <writei>
80105ad2:	83 c4 20             	add    $0x20,%esp
80105ad5:	83 f8 10             	cmp    $0x10,%eax
80105ad8:	0f 85 eb 00 00 00    	jne    80105bc9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105ade:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ae3:	0f 84 97 00 00 00    	je     80105b80 <sys_unlink+0x180>
  iunlockput(dp);
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	56                   	push   %esi
80105aed:	e8 1e be ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105af2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105af7:	89 1c 24             	mov    %ebx,(%esp)
80105afa:	e8 d1 ba ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105aff:	89 1c 24             	mov    %ebx,(%esp)
80105b02:	e8 09 be ff ff       	call   80101910 <iunlockput>
  end_op();
80105b07:	e8 04 d1 ff ff       	call   80102c10 <end_op>
  return 0;
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	31 c0                	xor    %eax,%eax
}
80105b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b14:	5b                   	pop    %ebx
80105b15:	5e                   	pop    %esi
80105b16:	5f                   	pop    %edi
80105b17:	5d                   	pop    %ebp
80105b18:	c3                   	ret    
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b20:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105b24:	76 8d                	jbe    80105ab3 <sys_unlink+0xb3>
80105b26:	bf 20 00 00 00       	mov    $0x20,%edi
80105b2b:	eb 0f                	jmp    80105b3c <sys_unlink+0x13c>
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
80105b30:	83 c7 10             	add    $0x10,%edi
80105b33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105b36:	0f 83 77 ff ff ff    	jae    80105ab3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b3c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b3f:	6a 10                	push   $0x10
80105b41:	57                   	push   %edi
80105b42:	50                   	push   %eax
80105b43:	53                   	push   %ebx
80105b44:	e8 17 be ff ff       	call   80101960 <readi>
80105b49:	83 c4 10             	add    $0x10,%esp
80105b4c:	83 f8 10             	cmp    $0x10,%eax
80105b4f:	75 5e                	jne    80105baf <sys_unlink+0x1af>
    if(de.inum != 0)
80105b51:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b56:	74 d8                	je     80105b30 <sys_unlink+0x130>
    iunlockput(ip);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	53                   	push   %ebx
80105b5c:	e8 af bd ff ff       	call   80101910 <iunlockput>
    goto bad;
80105b61:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	56                   	push   %esi
80105b68:	e8 a3 bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105b6d:	e8 9e d0 ff ff       	call   80102c10 <end_op>
  return -1;
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7a:	eb 95                	jmp    80105b11 <sys_unlink+0x111>
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105b80:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105b85:	83 ec 0c             	sub    $0xc,%esp
80105b88:	56                   	push   %esi
80105b89:	e8 42 ba ff ff       	call   801015d0 <iupdate>
80105b8e:	83 c4 10             	add    $0x10,%esp
80105b91:	e9 53 ff ff ff       	jmp    80105ae9 <sys_unlink+0xe9>
    return -1;
80105b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9b:	e9 71 ff ff ff       	jmp    80105b11 <sys_unlink+0x111>
    end_op();
80105ba0:	e8 6b d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105baa:	e9 62 ff ff ff       	jmp    80105b11 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105baf:	83 ec 0c             	sub    $0xc,%esp
80105bb2:	68 24 84 10 80       	push   $0x80108424
80105bb7:	e8 d4 a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105bbc:	83 ec 0c             	sub    $0xc,%esp
80105bbf:	68 12 84 10 80       	push   $0x80108412
80105bc4:	e8 c7 a7 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105bc9:	83 ec 0c             	sub    $0xc,%esp
80105bcc:	68 36 84 10 80       	push   $0x80108436
80105bd1:	e8 ba a7 ff ff       	call   80100390 <panic>
80105bd6:	8d 76 00             	lea    0x0(%esi),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <sys_open>:

int
sys_open(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105be6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105be9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bec:	50                   	push   %eax
80105bed:	6a 00                	push   $0x0
80105bef:	e8 3c f8 ff ff       	call   80105430 <argstr>
80105bf4:	83 c4 10             	add    $0x10,%esp
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	0f 88 1d 01 00 00    	js     80105d1c <sys_open+0x13c>
80105bff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c02:	83 ec 08             	sub    $0x8,%esp
80105c05:	50                   	push   %eax
80105c06:	6a 01                	push   $0x1
80105c08:	e8 73 f7 ff ff       	call   80105380 <argint>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	0f 88 04 01 00 00    	js     80105d1c <sys_open+0x13c>
    return -1;

  begin_op();
80105c18:	e8 83 cf ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105c1d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c21:	0f 85 a9 00 00 00    	jne    80105cd0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c27:	83 ec 0c             	sub    $0xc,%esp
80105c2a:	ff 75 e0             	pushl  -0x20(%ebp)
80105c2d:	e8 ae c2 ff ff       	call   80101ee0 <namei>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	89 c6                	mov    %eax,%esi
80105c39:	0f 84 b2 00 00 00    	je     80105cf1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105c3f:	83 ec 0c             	sub    $0xc,%esp
80105c42:	50                   	push   %eax
80105c43:	e8 38 ba ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c48:	83 c4 10             	add    $0x10,%esp
80105c4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c50:	0f 84 aa 00 00 00    	je     80105d00 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c56:	e8 25 b1 ff ff       	call   80100d80 <filealloc>
80105c5b:	85 c0                	test   %eax,%eax
80105c5d:	89 c7                	mov    %eax,%edi
80105c5f:	0f 84 a6 00 00 00    	je     80105d0b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105c65:	e8 e6 da ff ff       	call   80103750 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c6a:	31 db                	xor    %ebx,%ebx
80105c6c:	eb 0e                	jmp    80105c7c <sys_open+0x9c>
80105c6e:	66 90                	xchg   %ax,%ax
80105c70:	83 c3 01             	add    $0x1,%ebx
80105c73:	83 fb 10             	cmp    $0x10,%ebx
80105c76:	0f 84 ac 00 00 00    	je     80105d28 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105c7c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c80:	85 d2                	test   %edx,%edx
80105c82:	75 ec                	jne    80105c70 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c84:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c87:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c8b:	56                   	push   %esi
80105c8c:	e8 cf ba ff ff       	call   80101760 <iunlock>
  end_op();
80105c91:	e8 7a cf ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105c96:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c9f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ca2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105ca5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105cac:	89 d0                	mov    %edx,%eax
80105cae:	f7 d0                	not    %eax
80105cb0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cb3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105cb6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cb9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc0:	89 d8                	mov    %ebx,%eax
80105cc2:	5b                   	pop    %ebx
80105cc3:	5e                   	pop    %esi
80105cc4:	5f                   	pop    %edi
80105cc5:	5d                   	pop    %ebp
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cd6:	31 c9                	xor    %ecx,%ecx
80105cd8:	6a 00                	push   $0x0
80105cda:	ba 02 00 00 00       	mov    $0x2,%edx
80105cdf:	e8 ec f7 ff ff       	call   801054d0 <create>
    if(ip == 0){
80105ce4:	83 c4 10             	add    $0x10,%esp
80105ce7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ce9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ceb:	0f 85 65 ff ff ff    	jne    80105c56 <sys_open+0x76>
      end_op();
80105cf1:	e8 1a cf ff ff       	call   80102c10 <end_op>
      return -1;
80105cf6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cfb:	eb c0                	jmp    80105cbd <sys_open+0xdd>
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d03:	85 c9                	test   %ecx,%ecx
80105d05:	0f 84 4b ff ff ff    	je     80105c56 <sys_open+0x76>
    iunlockput(ip);
80105d0b:	83 ec 0c             	sub    $0xc,%esp
80105d0e:	56                   	push   %esi
80105d0f:	e8 fc bb ff ff       	call   80101910 <iunlockput>
    end_op();
80105d14:	e8 f7 ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d19:	83 c4 10             	add    $0x10,%esp
80105d1c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d21:	eb 9a                	jmp    80105cbd <sys_open+0xdd>
80105d23:	90                   	nop
80105d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105d28:	83 ec 0c             	sub    $0xc,%esp
80105d2b:	57                   	push   %edi
80105d2c:	e8 0f b1 ff ff       	call   80100e40 <fileclose>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	eb d5                	jmp    80105d0b <sys_open+0x12b>
80105d36:	8d 76 00             	lea    0x0(%esi),%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d46:	e8 55 ce ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4e:	83 ec 08             	sub    $0x8,%esp
80105d51:	50                   	push   %eax
80105d52:	6a 00                	push   $0x0
80105d54:	e8 d7 f6 ff ff       	call   80105430 <argstr>
80105d59:	83 c4 10             	add    $0x10,%esp
80105d5c:	85 c0                	test   %eax,%eax
80105d5e:	78 30                	js     80105d90 <sys_mkdir+0x50>
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d66:	31 c9                	xor    %ecx,%ecx
80105d68:	6a 00                	push   $0x0
80105d6a:	ba 01 00 00 00       	mov    $0x1,%edx
80105d6f:	e8 5c f7 ff ff       	call   801054d0 <create>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	85 c0                	test   %eax,%eax
80105d79:	74 15                	je     80105d90 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d7b:	83 ec 0c             	sub    $0xc,%esp
80105d7e:	50                   	push   %eax
80105d7f:	e8 8c bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105d84:	e8 87 ce ff ff       	call   80102c10 <end_op>
  return 0;
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	31 c0                	xor    %eax,%eax
}
80105d8e:	c9                   	leave  
80105d8f:	c3                   	ret    
    end_op();
80105d90:	e8 7b ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d9a:	c9                   	leave  
80105d9b:	c3                   	ret    
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_mknod>:

int
sys_mknod(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105da6:	e8 f5 cd ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105dab:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dae:	83 ec 08             	sub    $0x8,%esp
80105db1:	50                   	push   %eax
80105db2:	6a 00                	push   $0x0
80105db4:	e8 77 f6 ff ff       	call   80105430 <argstr>
80105db9:	83 c4 10             	add    $0x10,%esp
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	78 60                	js     80105e20 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105dc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dc3:	83 ec 08             	sub    $0x8,%esp
80105dc6:	50                   	push   %eax
80105dc7:	6a 01                	push   $0x1
80105dc9:	e8 b2 f5 ff ff       	call   80105380 <argint>
  if((argstr(0, &path)) < 0 ||
80105dce:	83 c4 10             	add    $0x10,%esp
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	78 4b                	js     80105e20 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105dd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dd8:	83 ec 08             	sub    $0x8,%esp
80105ddb:	50                   	push   %eax
80105ddc:	6a 02                	push   $0x2
80105dde:	e8 9d f5 ff ff       	call   80105380 <argint>
     argint(1, &major) < 0 ||
80105de3:	83 c4 10             	add    $0x10,%esp
80105de6:	85 c0                	test   %eax,%eax
80105de8:	78 36                	js     80105e20 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105dea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105dee:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105df1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105df5:	ba 03 00 00 00       	mov    $0x3,%edx
80105dfa:	50                   	push   %eax
80105dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dfe:	e8 cd f6 ff ff       	call   801054d0 <create>
80105e03:	83 c4 10             	add    $0x10,%esp
80105e06:	85 c0                	test   %eax,%eax
80105e08:	74 16                	je     80105e20 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e0a:	83 ec 0c             	sub    $0xc,%esp
80105e0d:	50                   	push   %eax
80105e0e:	e8 fd ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105e13:	e8 f8 cd ff ff       	call   80102c10 <end_op>
  return 0;
80105e18:	83 c4 10             	add    $0x10,%esp
80105e1b:	31 c0                	xor    %eax,%eax
}
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop
    end_op();
80105e20:	e8 eb cd ff ff       	call   80102c10 <end_op>
    return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_chdir>:

int
sys_chdir(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	56                   	push   %esi
80105e34:	53                   	push   %ebx
80105e35:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e38:	e8 13 d9 ff ff       	call   80103750 <myproc>
80105e3d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e3f:	e8 5c cd ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e47:	83 ec 08             	sub    $0x8,%esp
80105e4a:	50                   	push   %eax
80105e4b:	6a 00                	push   $0x0
80105e4d:	e8 de f5 ff ff       	call   80105430 <argstr>
80105e52:	83 c4 10             	add    $0x10,%esp
80105e55:	85 c0                	test   %eax,%eax
80105e57:	78 77                	js     80105ed0 <sys_chdir+0xa0>
80105e59:	83 ec 0c             	sub    $0xc,%esp
80105e5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5f:	e8 7c c0 ff ff       	call   80101ee0 <namei>
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	85 c0                	test   %eax,%eax
80105e69:	89 c3                	mov    %eax,%ebx
80105e6b:	74 63                	je     80105ed0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	50                   	push   %eax
80105e71:	e8 0a b8 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e7e:	75 30                	jne    80105eb0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	53                   	push   %ebx
80105e84:	e8 d7 b8 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105e89:	58                   	pop    %eax
80105e8a:	ff 76 68             	pushl  0x68(%esi)
80105e8d:	e8 1e b9 ff ff       	call   801017b0 <iput>
  end_op();
80105e92:	e8 79 cd ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105e97:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	31 c0                	xor    %eax,%eax
}
80105e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ea2:	5b                   	pop    %ebx
80105ea3:	5e                   	pop    %esi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret    
80105ea6:	8d 76 00             	lea    0x0(%esi),%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	53                   	push   %ebx
80105eb4:	e8 57 ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105eb9:	e8 52 cd ff ff       	call   80102c10 <end_op>
    return -1;
80105ebe:	83 c4 10             	add    $0x10,%esp
80105ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec6:	eb d7                	jmp    80105e9f <sys_chdir+0x6f>
80105ec8:	90                   	nop
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ed0:	e8 3b cd ff ff       	call   80102c10 <end_op>
    return -1;
80105ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eda:	eb c3                	jmp    80105e9f <sys_chdir+0x6f>
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exec>:

int
sys_exec(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ee6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105eec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ef2:	50                   	push   %eax
80105ef3:	6a 00                	push   $0x0
80105ef5:	e8 36 f5 ff ff       	call   80105430 <argstr>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	85 c0                	test   %eax,%eax
80105eff:	0f 88 87 00 00 00    	js     80105f8c <sys_exec+0xac>
80105f05:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	50                   	push   %eax
80105f0f:	6a 01                	push   $0x1
80105f11:	e8 6a f4 ff ff       	call   80105380 <argint>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 6f                	js     80105f8c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f1d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f23:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105f26:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f28:	68 80 00 00 00       	push   $0x80
80105f2d:	6a 00                	push   $0x0
80105f2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f35:	50                   	push   %eax
80105f36:	e8 45 f1 ff ff       	call   80105080 <memset>
80105f3b:	83 c4 10             	add    $0x10,%esp
80105f3e:	eb 2c                	jmp    80105f6c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105f40:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f46:	85 c0                	test   %eax,%eax
80105f48:	74 56                	je     80105fa0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f4a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f50:	83 ec 08             	sub    $0x8,%esp
80105f53:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f56:	52                   	push   %edx
80105f57:	50                   	push   %eax
80105f58:	e8 b3 f3 ff ff       	call   80105310 <fetchstr>
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	85 c0                	test   %eax,%eax
80105f62:	78 28                	js     80105f8c <sys_exec+0xac>
  for(i=0;; i++){
80105f64:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f67:	83 fb 20             	cmp    $0x20,%ebx
80105f6a:	74 20                	je     80105f8c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f6c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f72:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f79:	83 ec 08             	sub    $0x8,%esp
80105f7c:	57                   	push   %edi
80105f7d:	01 f0                	add    %esi,%eax
80105f7f:	50                   	push   %eax
80105f80:	e8 4b f3 ff ff       	call   801052d0 <fetchint>
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	79 b4                	jns    80105f40 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f94:	5b                   	pop    %ebx
80105f95:	5e                   	pop    %esi
80105f96:	5f                   	pop    %edi
80105f97:	5d                   	pop    %ebp
80105f98:	c3                   	ret    
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105fa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105fa6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105fa9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105fb0:	00 00 00 00 
  return exec(path, argv);
80105fb4:	50                   	push   %eax
80105fb5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105fbb:	e8 50 aa ff ff       	call   80100a10 <exec>
80105fc0:	83 c4 10             	add    $0x10,%esp
}
80105fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc6:	5b                   	pop    %ebx
80105fc7:	5e                   	pop    %esi
80105fc8:	5f                   	pop    %edi
80105fc9:	5d                   	pop    %ebp
80105fca:	c3                   	ret    
80105fcb:	90                   	nop
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_pipe>:

int
sys_pipe(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	57                   	push   %edi
80105fd4:	56                   	push   %esi
80105fd5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fd6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fd9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fdc:	6a 08                	push   $0x8
80105fde:	50                   	push   %eax
80105fdf:	6a 00                	push   $0x0
80105fe1:	e8 ea f3 ff ff       	call   801053d0 <argptr>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	0f 88 ae 00 00 00    	js     8010609f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ff1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ff4:	83 ec 08             	sub    $0x8,%esp
80105ff7:	50                   	push   %eax
80105ff8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ffb:	50                   	push   %eax
80105ffc:	e8 7f d2 ff ff       	call   80103280 <pipealloc>
80106001:	83 c4 10             	add    $0x10,%esp
80106004:	85 c0                	test   %eax,%eax
80106006:	0f 88 93 00 00 00    	js     8010609f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010600c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010600f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106011:	e8 3a d7 ff ff       	call   80103750 <myproc>
80106016:	eb 10                	jmp    80106028 <sys_pipe+0x58>
80106018:	90                   	nop
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106020:	83 c3 01             	add    $0x1,%ebx
80106023:	83 fb 10             	cmp    $0x10,%ebx
80106026:	74 60                	je     80106088 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106028:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010602c:	85 f6                	test   %esi,%esi
8010602e:	75 f0                	jne    80106020 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106030:	8d 73 08             	lea    0x8(%ebx),%esi
80106033:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106037:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010603a:	e8 11 d7 ff ff       	call   80103750 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010603f:	31 d2                	xor    %edx,%edx
80106041:	eb 0d                	jmp    80106050 <sys_pipe+0x80>
80106043:	90                   	nop
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106048:	83 c2 01             	add    $0x1,%edx
8010604b:	83 fa 10             	cmp    $0x10,%edx
8010604e:	74 28                	je     80106078 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106050:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106054:	85 c9                	test   %ecx,%ecx
80106056:	75 f0                	jne    80106048 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106058:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010605c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010605f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106061:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106064:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106067:	31 c0                	xor    %eax,%eax
}
80106069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010606c:	5b                   	pop    %ebx
8010606d:	5e                   	pop    %esi
8010606e:	5f                   	pop    %edi
8010606f:	5d                   	pop    %ebp
80106070:	c3                   	ret    
80106071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106078:	e8 d3 d6 ff ff       	call   80103750 <myproc>
8010607d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106084:	00 
80106085:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106088:	83 ec 0c             	sub    $0xc,%esp
8010608b:	ff 75 e0             	pushl  -0x20(%ebp)
8010608e:	e8 ad ad ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106093:	58                   	pop    %eax
80106094:	ff 75 e4             	pushl  -0x1c(%ebp)
80106097:	e8 a4 ad ff ff       	call   80100e40 <fileclose>
    return -1;
8010609c:	83 c4 10             	add    $0x10,%esp
8010609f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a4:	eb c3                	jmp    80106069 <sys_pipe+0x99>
801060a6:	66 90                	xchg   %ax,%ax
801060a8:	66 90                	xchg   %ax,%ax
801060aa:	66 90                	xchg   %ax,%ax
801060ac:	66 90                	xchg   %ax,%ax
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_fork>:
#include "proc.h"
#include "pinfoheader.h"

int
sys_fork(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801060b3:	5d                   	pop    %ebp
  return fork();
801060b4:	e9 87 e2 ff ff       	jmp    80104340 <fork>
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_exit>:

int
sys_exit(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801060c6:	e8 f5 d7 ff ff       	call   801038c0 <exit>
  return 0;  // not reached
}
801060cb:	31 c0                	xor    %eax,%eax
801060cd:	c9                   	leave  
801060ce:	c3                   	ret    
801060cf:	90                   	nop

801060d0 <sys_wait>:

int
sys_wait(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801060d3:	5d                   	pop    %ebp
  return wait();
801060d4:	e9 e7 d9 ff ff       	jmp    80103ac0 <wait>
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060e0 <sys_kill>:

int
sys_kill(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060e9:	50                   	push   %eax
801060ea:	6a 00                	push   $0x0
801060ec:	e8 8f f2 ff ff       	call   80105380 <argint>
801060f1:	83 c4 10             	add    $0x10,%esp
801060f4:	85 c0                	test   %eax,%eax
801060f6:	78 18                	js     80106110 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060f8:	83 ec 0c             	sub    $0xc,%esp
801060fb:	ff 75 f4             	pushl  -0xc(%ebp)
801060fe:	e8 3d dc ff ff       	call   80103d40 <kill>
80106103:	83 c4 10             	add    $0x10,%esp
}
80106106:	c9                   	leave  
80106107:	c3                   	ret    
80106108:	90                   	nop
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106115:	c9                   	leave  
80106116:	c3                   	ret    
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106120 <sys_getpid>:

int
sys_getpid(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106126:	e8 25 d6 ff ff       	call   80103750 <myproc>
8010612b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010612e:	c9                   	leave  
8010612f:	c3                   	ret    

80106130 <sys_sbrk>:

int
sys_sbrk(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106134:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106137:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010613a:	50                   	push   %eax
8010613b:	6a 00                	push   $0x0
8010613d:	e8 3e f2 ff ff       	call   80105380 <argint>
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	85 c0                	test   %eax,%eax
80106147:	78 27                	js     80106170 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106149:	e8 02 d6 ff ff       	call   80103750 <myproc>
  if(growproc(n) < 0)
8010614e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106151:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106153:	ff 75 f4             	pushl  -0xc(%ebp)
80106156:	e8 25 d6 ff ff       	call   80103780 <growproc>
8010615b:	83 c4 10             	add    $0x10,%esp
8010615e:	85 c0                	test   %eax,%eax
80106160:	78 0e                	js     80106170 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106162:	89 d8                	mov    %ebx,%eax
80106164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106167:	c9                   	leave  
80106168:	c3                   	ret    
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106170:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106175:	eb eb                	jmp    80106162 <sys_sbrk+0x32>
80106177:	89 f6                	mov    %esi,%esi
80106179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106180 <sys_sleep>:

int
sys_sleep(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106184:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106187:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010618a:	50                   	push   %eax
8010618b:	6a 00                	push   $0x0
8010618d:	e8 ee f1 ff ff       	call   80105380 <argint>
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	85 c0                	test   %eax,%eax
80106197:	0f 88 8a 00 00 00    	js     80106227 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	68 a0 71 11 80       	push   $0x801171a0
801061a5:	e8 c6 ed ff ff       	call   80104f70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061ad:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801061b0:	8b 1d e0 79 11 80    	mov    0x801179e0,%ebx
  while(ticks - ticks0 < n){
801061b6:	85 d2                	test   %edx,%edx
801061b8:	75 27                	jne    801061e1 <sys_sleep+0x61>
801061ba:	eb 54                	jmp    80106210 <sys_sleep+0x90>
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	68 a0 71 11 80       	push   $0x801171a0
801061c8:	68 e0 79 11 80       	push   $0x801179e0
801061cd:	e8 2e d8 ff ff       	call   80103a00 <sleep>
  while(ticks - ticks0 < n){
801061d2:	a1 e0 79 11 80       	mov    0x801179e0,%eax
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	29 d8                	sub    %ebx,%eax
801061dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061df:	73 2f                	jae    80106210 <sys_sleep+0x90>
    if(myproc()->killed){
801061e1:	e8 6a d5 ff ff       	call   80103750 <myproc>
801061e6:	8b 40 24             	mov    0x24(%eax),%eax
801061e9:	85 c0                	test   %eax,%eax
801061eb:	74 d3                	je     801061c0 <sys_sleep+0x40>
      release(&tickslock);
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 a0 71 11 80       	push   $0x801171a0
801061f5:	e8 36 ee ff ff       	call   80105030 <release>
      return -1;
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106205:	c9                   	leave  
80106206:	c3                   	ret    
80106207:	89 f6                	mov    %esi,%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	68 a0 71 11 80       	push   $0x801171a0
80106218:	e8 13 ee ff ff       	call   80105030 <release>
  return 0;
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	31 c0                	xor    %eax,%eax
}
80106222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106225:	c9                   	leave  
80106226:	c3                   	ret    
    return -1;
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb f4                	jmp    80106222 <sys_sleep+0xa2>
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	53                   	push   %ebx
80106234:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106237:	68 a0 71 11 80       	push   $0x801171a0
8010623c:	e8 2f ed ff ff       	call   80104f70 <acquire>
  xticks = ticks;
80106241:	8b 1d e0 79 11 80    	mov    0x801179e0,%ebx
  release(&tickslock);
80106247:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
8010624e:	e8 dd ed ff ff       	call   80105030 <release>
  return xticks;
}
80106253:	89 d8                	mov    %ebx,%eax
80106255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106258:	c9                   	leave  
80106259:	c3                   	ret    
8010625a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106260 <sys_waitx>:

int 
sys_waitx(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime;
  int *rtime;
  
  if(argptr(0, (char**)&wtime, sizeof(int)) < 0)
80106266:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106269:	6a 04                	push   $0x4
8010626b:	50                   	push   %eax
8010626c:	6a 00                	push   $0x0
8010626e:	e8 5d f1 ff ff       	call   801053d0 <argptr>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	78 2e                	js     801062a8 <sys_waitx+0x48>
    return -1;

  if(argptr(1, (char**)&rtime, sizeof(int)) < 0)
8010627a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010627d:	83 ec 04             	sub    $0x4,%esp
80106280:	6a 04                	push   $0x4
80106282:	50                   	push   %eax
80106283:	6a 01                	push   $0x1
80106285:	e8 46 f1 ff ff       	call   801053d0 <argptr>
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	85 c0                	test   %eax,%eax
8010628f:	78 17                	js     801062a8 <sys_waitx+0x48>
    return -1;

  return waitx(wtime, rtime);
80106291:	83 ec 08             	sub    $0x8,%esp
80106294:	ff 75 f4             	pushl  -0xc(%ebp)
80106297:	ff 75 f0             	pushl  -0x10(%ebp)
8010629a:	e8 21 d9 ff ff       	call   80103bc0 <waitx>
8010629f:	83 c4 10             	add    $0x10,%esp
}
801062a2:	c9                   	leave  
801062a3:	c3                   	ret    
801062a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    
801062af:	90                   	nop

801062b0 <sys_set_priority>:

int
sys_set_priority(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 20             	sub    $0x20,%esp
  int new_priority;
  int pid;

  if(argint(0, &new_priority) < 0)
801062b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062b9:	50                   	push   %eax
801062ba:	6a 00                	push   $0x0
801062bc:	e8 bf f0 ff ff       	call   80105380 <argint>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	78 28                	js     801062f0 <sys_set_priority+0x40>
    return -1;
  
  if(argint(1, &pid) < 0)
801062c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062cb:	83 ec 08             	sub    $0x8,%esp
801062ce:	50                   	push   %eax
801062cf:	6a 01                	push   $0x1
801062d1:	e8 aa f0 ff ff       	call   80105380 <argint>
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	85 c0                	test   %eax,%eax
801062db:	78 13                	js     801062f0 <sys_set_priority+0x40>
    return -1;

  return set_priority(new_priority, pid);
801062dd:	83 ec 08             	sub    $0x8,%esp
801062e0:	ff 75 f4             	pushl  -0xc(%ebp)
801062e3:	ff 75 f0             	pushl  -0x10(%ebp)
801062e6:	e8 a5 db ff ff       	call   80103e90 <set_priority>
801062eb:	83 c4 10             	add    $0x10,%esp
}
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    
    return -1;
801062f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f5:	c9                   	leave  
801062f6:	c3                   	ret    
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <sys_getpinfo>:

int
sys_getpinfo(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 1c             	sub    $0x1c,%esp
    int pid;
    struct proc_stat* pinfo_proc;

    if(argptr(0, (char**)&pinfo_proc, sizeof(struct proc_stat)) < 0)
80106306:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106309:	6a 24                	push   $0x24
8010630b:	50                   	push   %eax
8010630c:	6a 00                	push   $0x0
8010630e:	e8 bd f0 ff ff       	call   801053d0 <argptr>
80106313:	83 c4 10             	add    $0x10,%esp
80106316:	85 c0                	test   %eax,%eax
80106318:	78 2e                	js     80106348 <sys_getpinfo+0x48>
        return -1;
    
    if(argint(1, &pid) < 0)
8010631a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010631d:	83 ec 08             	sub    $0x8,%esp
80106320:	50                   	push   %eax
80106321:	6a 01                	push   $0x1
80106323:	e8 58 f0 ff ff       	call   80105380 <argint>
80106328:	83 c4 10             	add    $0x10,%esp
8010632b:	85 c0                	test   %eax,%eax
8010632d:	78 19                	js     80106348 <sys_getpinfo+0x48>
        return -1;
    
    return getpinfo(pinfo_proc, pid);
8010632f:	83 ec 08             	sub    $0x8,%esp
80106332:	ff 75 f0             	pushl  -0x10(%ebp)
80106335:	ff 75 f4             	pushl  -0xc(%ebp)
80106338:	e8 53 e8 ff ff       	call   80104b90 <getpinfo>
8010633d:	83 c4 10             	add    $0x10,%esp
}
80106340:	c9                   	leave  
80106341:	c3                   	ret    
80106342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80106348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010634d:	c9                   	leave  
8010634e:	c3                   	ret    

8010634f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010634f:	1e                   	push   %ds
  pushl %es
80106350:	06                   	push   %es
  pushl %fs
80106351:	0f a0                	push   %fs
  pushl %gs
80106353:	0f a8                	push   %gs
  pushal
80106355:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106356:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010635a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010635c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010635e:	54                   	push   %esp
  call trap
8010635f:	e8 cc 00 00 00       	call   80106430 <trap>
  addl $4, %esp
80106364:	83 c4 04             	add    $0x4,%esp

80106367 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106367:	61                   	popa   
  popl %gs
80106368:	0f a9                	pop    %gs
  popl %fs
8010636a:	0f a1                	pop    %fs
  popl %es
8010636c:	07                   	pop    %es
  popl %ds
8010636d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010636e:	83 c4 08             	add    $0x8,%esp
  iret
80106371:	cf                   	iret   
80106372:	66 90                	xchg   %ax,%ax
80106374:	66 90                	xchg   %ax,%ax
80106376:	66 90                	xchg   %ax,%ax
80106378:	66 90                	xchg   %ax,%ax
8010637a:	66 90                	xchg   %ax,%ax
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106380:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106381:	31 c0                	xor    %eax,%eax
{
80106383:	89 e5                	mov    %esp,%ebp
80106385:	83 ec 08             	sub    $0x8,%esp
80106388:	90                   	nop
80106389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106390:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106397:	c7 04 c5 e2 71 11 80 	movl   $0x8e000008,-0x7fee8e1e(,%eax,8)
8010639e:	08 00 00 8e 
801063a2:	66 89 14 c5 e0 71 11 	mov    %dx,-0x7fee8e20(,%eax,8)
801063a9:	80 
801063aa:	c1 ea 10             	shr    $0x10,%edx
801063ad:	66 89 14 c5 e6 71 11 	mov    %dx,-0x7fee8e1a(,%eax,8)
801063b4:	80 
  for(i = 0; i < 256; i++)
801063b5:	83 c0 01             	add    $0x1,%eax
801063b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801063bd:	75 d1                	jne    80106390 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063bf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801063c4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063c7:	c7 05 e2 73 11 80 08 	movl   $0xef000008,0x801173e2
801063ce:	00 00 ef 
  initlock(&tickslock, "time");
801063d1:	68 45 84 10 80       	push   $0x80108445
801063d6:	68 a0 71 11 80       	push   $0x801171a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063db:	66 a3 e0 73 11 80    	mov    %ax,0x801173e0
801063e1:	c1 e8 10             	shr    $0x10,%eax
801063e4:	66 a3 e6 73 11 80    	mov    %ax,0x801173e6
  initlock(&tickslock, "time");
801063ea:	e8 41 ea ff ff       	call   80104e30 <initlock>
}
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	c9                   	leave  
801063f3:	c3                   	ret    
801063f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106400 <idtinit>:

void
idtinit(void)
{
80106400:	55                   	push   %ebp
  pd[0] = size-1;
80106401:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106406:	89 e5                	mov    %esp,%ebp
80106408:	83 ec 10             	sub    $0x10,%esp
8010640b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010640f:	b8 e0 71 11 80       	mov    $0x801171e0,%eax
80106414:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106418:	c1 e8 10             	shr    $0x10,%eax
8010641b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010641f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106422:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    
80106427:	89 f6                	mov    %esi,%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106430 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	56                   	push   %esi
80106435:	53                   	push   %ebx
80106436:	83 ec 1c             	sub    $0x1c,%esp
80106439:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010643c:	8b 47 30             	mov    0x30(%edi),%eax
8010643f:	83 f8 40             	cmp    $0x40,%eax
80106442:	0f 84 f8 00 00 00    	je     80106540 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106448:	83 e8 20             	sub    $0x20,%eax
8010644b:	83 f8 1f             	cmp    $0x1f,%eax
8010644e:	77 10                	ja     80106460 <trap+0x30>
80106450:	ff 24 85 ec 84 10 80 	jmp    *-0x7fef7b14(,%eax,4)
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106460:	e8 eb d2 ff ff       	call   80103750 <myproc>
80106465:	85 c0                	test   %eax,%eax
80106467:	8b 5f 38             	mov    0x38(%edi),%ebx
8010646a:	0f 84 4a 02 00 00    	je     801066ba <trap+0x28a>
80106470:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106474:	0f 84 40 02 00 00    	je     801066ba <trap+0x28a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010647a:	0f 20 d1             	mov    %cr2,%ecx
8010647d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106480:	e8 ab d2 ff ff       	call   80103730 <cpuid>
80106485:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106488:	8b 47 34             	mov    0x34(%edi),%eax
8010648b:	8b 77 30             	mov    0x30(%edi),%esi
8010648e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106491:	e8 ba d2 ff ff       	call   80103750 <myproc>
80106496:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106499:	e8 b2 d2 ff ff       	call   80103750 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010649e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064a4:	51                   	push   %ecx
801064a5:	53                   	push   %ebx
801064a6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801064a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801064ad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801064ae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064b1:	52                   	push   %edx
801064b2:	ff 70 10             	pushl  0x10(%eax)
801064b5:	68 a8 84 10 80       	push   $0x801084a8
801064ba:	e8 a1 a1 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801064bf:	83 c4 20             	add    $0x20,%esp
801064c2:	e8 89 d2 ff ff       	call   80103750 <myproc>
801064c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064ce:	e8 7d d2 ff ff       	call   80103750 <myproc>
801064d3:	85 c0                	test   %eax,%eax
801064d5:	74 1d                	je     801064f4 <trap+0xc4>
801064d7:	e8 74 d2 ff ff       	call   80103750 <myproc>
801064dc:	8b 50 24             	mov    0x24(%eax),%edx
801064df:	85 d2                	test   %edx,%edx
801064e1:	74 11                	je     801064f4 <trap+0xc4>
801064e3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801064e7:	83 e0 03             	and    $0x3,%eax
801064ea:	66 83 f8 03          	cmp    $0x3,%ax
801064ee:	0f 84 bc 01 00 00    	je     801066b0 <trap+0x280>
      yield();
    }

    #else
    #ifdef MLFQ
      if(myproc() && myproc()->state == RUNNING && myproc()->queue != 4 && myproc()->curTime > qticks[myproc()->queue]){
801064f4:	e8 57 d2 ff ff       	call   80103750 <myproc>
801064f9:	85 c0                	test   %eax,%eax
801064fb:	74 0f                	je     8010650c <trap+0xdc>
801064fd:	e8 4e d2 ff ff       	call   80103750 <myproc>
80106502:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106506:	0f 84 4c 01 00 00    	je     80106658 <trap+0x228>
        }
      }
    #endif
    #endif
    // Check if the process has been killed since we yielded
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010650c:	e8 3f d2 ff ff       	call   80103750 <myproc>
80106511:	85 c0                	test   %eax,%eax
80106513:	74 19                	je     8010652e <trap+0xfe>
80106515:	e8 36 d2 ff ff       	call   80103750 <myproc>
8010651a:	8b 40 24             	mov    0x24(%eax),%eax
8010651d:	85 c0                	test   %eax,%eax
8010651f:	74 0d                	je     8010652e <trap+0xfe>
80106521:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106525:	83 e0 03             	and    $0x3,%eax
80106528:	66 83 f8 03          	cmp    $0x3,%ax
8010652c:	74 3b                	je     80106569 <trap+0x139>
      exit();
  #endif
}
8010652e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106531:	5b                   	pop    %ebx
80106532:	5e                   	pop    %esi
80106533:	5f                   	pop    %edi
80106534:	5d                   	pop    %ebp
80106535:	c3                   	ret    
80106536:	8d 76 00             	lea    0x0(%esi),%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80106540:	e8 0b d2 ff ff       	call   80103750 <myproc>
80106545:	8b 58 24             	mov    0x24(%eax),%ebx
80106548:	85 db                	test   %ebx,%ebx
8010654a:	0f 85 50 01 00 00    	jne    801066a0 <trap+0x270>
    myproc()->tf = tf;
80106550:	e8 fb d1 ff ff       	call   80103750 <myproc>
80106555:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106558:	e8 13 ef ff ff       	call   80105470 <syscall>
    if(myproc()->killed)
8010655d:	e8 ee d1 ff ff       	call   80103750 <myproc>
80106562:	8b 48 24             	mov    0x24(%eax),%ecx
80106565:	85 c9                	test   %ecx,%ecx
80106567:	74 c5                	je     8010652e <trap+0xfe>
}
80106569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010656c:	5b                   	pop    %ebx
8010656d:	5e                   	pop    %esi
8010656e:	5f                   	pop    %edi
8010656f:	5d                   	pop    %ebp
      exit();
80106570:	e9 4b d3 ff ff       	jmp    801038c0 <exit>
80106575:	8d 76 00             	lea    0x0(%esi),%esi
    ideintr();
80106578:	e8 03 bb ff ff       	call   80102080 <ideintr>
    lapiceoi();
8010657d:	e8 ce c1 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106582:	e8 c9 d1 ff ff       	call   80103750 <myproc>
80106587:	85 c0                	test   %eax,%eax
80106589:	0f 85 48 ff ff ff    	jne    801064d7 <trap+0xa7>
8010658f:	e9 60 ff ff ff       	jmp    801064f4 <trap+0xc4>
80106594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106598:	e8 93 d1 ff ff       	call   80103730 <cpuid>
8010659d:	85 c0                	test   %eax,%eax
8010659f:	75 dc                	jne    8010657d <trap+0x14d>
      acquire(&tickslock);
801065a1:	83 ec 0c             	sub    $0xc,%esp
801065a4:	68 a0 71 11 80       	push   $0x801171a0
801065a9:	e8 c2 e9 ff ff       	call   80104f70 <acquire>
      ticks++;
801065ae:	83 05 e0 79 11 80 01 	addl   $0x1,0x801179e0
      update_proc_time();
801065b5:	e8 b6 df ff ff       	call   80104570 <update_proc_time>
      wakeup(&ticks);
801065ba:	c7 04 24 e0 79 11 80 	movl   $0x801179e0,(%esp)
801065c1:	e8 1a d7 ff ff       	call   80103ce0 <wakeup>
      release(&tickslock);
801065c6:	c7 04 24 a0 71 11 80 	movl   $0x801171a0,(%esp)
801065cd:	e8 5e ea ff ff       	call   80105030 <release>
801065d2:	83 c4 10             	add    $0x10,%esp
801065d5:	eb a6                	jmp    8010657d <trap+0x14d>
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
801065e0:	e8 2b c0 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
801065e5:	e8 66 c1 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065ea:	e8 61 d1 ff ff       	call   80103750 <myproc>
801065ef:	85 c0                	test   %eax,%eax
801065f1:	0f 85 e0 fe ff ff    	jne    801064d7 <trap+0xa7>
801065f7:	e9 f8 fe ff ff       	jmp    801064f4 <trap+0xc4>
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106600:	e8 5b 02 00 00       	call   80106860 <uartintr>
    lapiceoi();
80106605:	e8 46 c1 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010660a:	e8 41 d1 ff ff       	call   80103750 <myproc>
8010660f:	85 c0                	test   %eax,%eax
80106611:	0f 85 c0 fe ff ff    	jne    801064d7 <trap+0xa7>
80106617:	e9 d8 fe ff ff       	jmp    801064f4 <trap+0xc4>
8010661c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106620:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106624:	8b 77 38             	mov    0x38(%edi),%esi
80106627:	e8 04 d1 ff ff       	call   80103730 <cpuid>
8010662c:	56                   	push   %esi
8010662d:	53                   	push   %ebx
8010662e:	50                   	push   %eax
8010662f:	68 50 84 10 80       	push   $0x80108450
80106634:	e8 27 a0 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106639:	e8 12 c1 ff ff       	call   80102750 <lapiceoi>
    break;
8010663e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106641:	e8 0a d1 ff ff       	call   80103750 <myproc>
80106646:	85 c0                	test   %eax,%eax
80106648:	0f 85 89 fe ff ff    	jne    801064d7 <trap+0xa7>
8010664e:	e9 a1 fe ff ff       	jmp    801064f4 <trap+0xc4>
80106653:	90                   	nop
80106654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(myproc() && myproc()->state == RUNNING && myproc()->queue != 4 && myproc()->curTime > qticks[myproc()->queue]){
80106658:	e8 f3 d0 ff ff       	call   80103750 <myproc>
8010665d:	83 b8 90 00 00 00 04 	cmpl   $0x4,0x90(%eax)
80106664:	0f 84 a2 fe ff ff    	je     8010650c <trap+0xdc>
8010666a:	e8 e1 d0 ff ff       	call   80103750 <myproc>
8010666f:	8b 98 a8 00 00 00    	mov    0xa8(%eax),%ebx
80106675:	e8 d6 d0 ff ff       	call   80103750 <myproc>
8010667a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106680:	3b 1c 85 58 0f 11 80 	cmp    -0x7feef0a8(,%eax,4),%ebx
80106687:	0f 8e 7f fe ff ff    	jle    8010650c <trap+0xdc>
        yield();
8010668d:	e8 ce dd ff ff       	call   80104460 <yield>
80106692:	e9 75 fe ff ff       	jmp    8010650c <trap+0xdc>
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
801066a0:	e8 1b d2 ff ff       	call   801038c0 <exit>
801066a5:	e9 a6 fe ff ff       	jmp    80106550 <trap+0x120>
801066aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801066b0:	e8 0b d2 ff ff       	call   801038c0 <exit>
801066b5:	e9 3a fe ff ff       	jmp    801064f4 <trap+0xc4>
801066ba:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066bd:	e8 6e d0 ff ff       	call   80103730 <cpuid>
801066c2:	83 ec 0c             	sub    $0xc,%esp
801066c5:	56                   	push   %esi
801066c6:	53                   	push   %ebx
801066c7:	50                   	push   %eax
801066c8:	ff 77 30             	pushl  0x30(%edi)
801066cb:	68 74 84 10 80       	push   $0x80108474
801066d0:	e8 8b 9f ff ff       	call   80100660 <cprintf>
      panic("trap");
801066d5:	83 c4 14             	add    $0x14,%esp
801066d8:	68 4a 84 10 80       	push   $0x8010844a
801066dd:	e8 ae 9c ff ff       	call   80100390 <panic>
801066e2:	66 90                	xchg   %ax,%ax
801066e4:	66 90                	xchg   %ax,%ax
801066e6:	66 90                	xchg   %ax,%ax
801066e8:	66 90                	xchg   %ax,%ax
801066ea:	66 90                	xchg   %ax,%ax
801066ec:	66 90                	xchg   %ax,%ax
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801066f0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801066f5:	55                   	push   %ebp
801066f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801066f8:	85 c0                	test   %eax,%eax
801066fa:	74 1c                	je     80106718 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106701:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106702:	a8 01                	test   $0x1,%al
80106704:	74 12                	je     80106718 <uartgetc+0x28>
80106706:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010670b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010670c:	0f b6 c0             	movzbl %al,%eax
}
8010670f:	5d                   	pop    %ebp
80106710:	c3                   	ret    
80106711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010671d:	5d                   	pop    %ebp
8010671e:	c3                   	ret    
8010671f:	90                   	nop

80106720 <uartputc.part.0>:
uartputc(int c)
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	89 c7                	mov    %eax,%edi
80106728:	bb 80 00 00 00       	mov    $0x80,%ebx
8010672d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106732:	83 ec 0c             	sub    $0xc,%esp
80106735:	eb 1b                	jmp    80106752 <uartputc.part.0+0x32>
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	6a 0a                	push   $0xa
80106745:	e8 26 c0 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010674a:	83 c4 10             	add    $0x10,%esp
8010674d:	83 eb 01             	sub    $0x1,%ebx
80106750:	74 07                	je     80106759 <uartputc.part.0+0x39>
80106752:	89 f2                	mov    %esi,%edx
80106754:	ec                   	in     (%dx),%al
80106755:	a8 20                	test   $0x20,%al
80106757:	74 e7                	je     80106740 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106759:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010675e:	89 f8                	mov    %edi,%eax
80106760:	ee                   	out    %al,(%dx)
}
80106761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106764:	5b                   	pop    %ebx
80106765:	5e                   	pop    %esi
80106766:	5f                   	pop    %edi
80106767:	5d                   	pop    %ebp
80106768:	c3                   	ret    
80106769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106770 <uartinit>:
{
80106770:	55                   	push   %ebp
80106771:	31 c9                	xor    %ecx,%ecx
80106773:	89 c8                	mov    %ecx,%eax
80106775:	89 e5                	mov    %esp,%ebp
80106777:	57                   	push   %edi
80106778:	56                   	push   %esi
80106779:	53                   	push   %ebx
8010677a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010677f:	89 da                	mov    %ebx,%edx
80106781:	83 ec 0c             	sub    $0xc,%esp
80106784:	ee                   	out    %al,(%dx)
80106785:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010678a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010678f:	89 fa                	mov    %edi,%edx
80106791:	ee                   	out    %al,(%dx)
80106792:	b8 0c 00 00 00       	mov    $0xc,%eax
80106797:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010679c:	ee                   	out    %al,(%dx)
8010679d:	be f9 03 00 00       	mov    $0x3f9,%esi
801067a2:	89 c8                	mov    %ecx,%eax
801067a4:	89 f2                	mov    %esi,%edx
801067a6:	ee                   	out    %al,(%dx)
801067a7:	b8 03 00 00 00       	mov    $0x3,%eax
801067ac:	89 fa                	mov    %edi,%edx
801067ae:	ee                   	out    %al,(%dx)
801067af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801067b4:	89 c8                	mov    %ecx,%eax
801067b6:	ee                   	out    %al,(%dx)
801067b7:	b8 01 00 00 00       	mov    $0x1,%eax
801067bc:	89 f2                	mov    %esi,%edx
801067be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801067c5:	3c ff                	cmp    $0xff,%al
801067c7:	74 5a                	je     80106823 <uartinit+0xb3>
  uart = 1;
801067c9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801067d0:	00 00 00 
801067d3:	89 da                	mov    %ebx,%edx
801067d5:	ec                   	in     (%dx),%al
801067d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801067dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801067df:	bb 6c 85 10 80       	mov    $0x8010856c,%ebx
  ioapicenable(IRQ_COM1, 0);
801067e4:	6a 00                	push   $0x0
801067e6:	6a 04                	push   $0x4
801067e8:	e8 e3 ba ff ff       	call   801022d0 <ioapicenable>
801067ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801067f0:	b8 78 00 00 00       	mov    $0x78,%eax
801067f5:	eb 13                	jmp    8010680a <uartinit+0x9a>
801067f7:	89 f6                	mov    %esi,%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106800:	83 c3 01             	add    $0x1,%ebx
80106803:	0f be 03             	movsbl (%ebx),%eax
80106806:	84 c0                	test   %al,%al
80106808:	74 19                	je     80106823 <uartinit+0xb3>
  if(!uart)
8010680a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106810:	85 d2                	test   %edx,%edx
80106812:	74 ec                	je     80106800 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106814:	83 c3 01             	add    $0x1,%ebx
80106817:	e8 04 ff ff ff       	call   80106720 <uartputc.part.0>
8010681c:	0f be 03             	movsbl (%ebx),%eax
8010681f:	84 c0                	test   %al,%al
80106821:	75 e7                	jne    8010680a <uartinit+0x9a>
}
80106823:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106826:	5b                   	pop    %ebx
80106827:	5e                   	pop    %esi
80106828:	5f                   	pop    %edi
80106829:	5d                   	pop    %ebp
8010682a:	c3                   	ret    
8010682b:	90                   	nop
8010682c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106830 <uartputc>:
  if(!uart)
80106830:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106836:	55                   	push   %ebp
80106837:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106839:	85 d2                	test   %edx,%edx
{
8010683b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010683e:	74 10                	je     80106850 <uartputc+0x20>
}
80106840:	5d                   	pop    %ebp
80106841:	e9 da fe ff ff       	jmp    80106720 <uartputc.part.0>
80106846:	8d 76 00             	lea    0x0(%esi),%esi
80106849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106850:	5d                   	pop    %ebp
80106851:	c3                   	ret    
80106852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <uartintr>:

void
uartintr(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106866:	68 f0 66 10 80       	push   $0x801066f0
8010686b:	e8 a0 9f ff ff       	call   80100810 <consoleintr>
}
80106870:	83 c4 10             	add    $0x10,%esp
80106873:	c9                   	leave  
80106874:	c3                   	ret    

80106875 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $0
80106877:	6a 00                	push   $0x0
  jmp alltraps
80106879:	e9 d1 fa ff ff       	jmp    8010634f <alltraps>

8010687e <vector1>:
.globl vector1
vector1:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $1
80106880:	6a 01                	push   $0x1
  jmp alltraps
80106882:	e9 c8 fa ff ff       	jmp    8010634f <alltraps>

80106887 <vector2>:
.globl vector2
vector2:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $2
80106889:	6a 02                	push   $0x2
  jmp alltraps
8010688b:	e9 bf fa ff ff       	jmp    8010634f <alltraps>

80106890 <vector3>:
.globl vector3
vector3:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $3
80106892:	6a 03                	push   $0x3
  jmp alltraps
80106894:	e9 b6 fa ff ff       	jmp    8010634f <alltraps>

80106899 <vector4>:
.globl vector4
vector4:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $4
8010689b:	6a 04                	push   $0x4
  jmp alltraps
8010689d:	e9 ad fa ff ff       	jmp    8010634f <alltraps>

801068a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $5
801068a4:	6a 05                	push   $0x5
  jmp alltraps
801068a6:	e9 a4 fa ff ff       	jmp    8010634f <alltraps>

801068ab <vector6>:
.globl vector6
vector6:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $6
801068ad:	6a 06                	push   $0x6
  jmp alltraps
801068af:	e9 9b fa ff ff       	jmp    8010634f <alltraps>

801068b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $7
801068b6:	6a 07                	push   $0x7
  jmp alltraps
801068b8:	e9 92 fa ff ff       	jmp    8010634f <alltraps>

801068bd <vector8>:
.globl vector8
vector8:
  pushl $8
801068bd:	6a 08                	push   $0x8
  jmp alltraps
801068bf:	e9 8b fa ff ff       	jmp    8010634f <alltraps>

801068c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $9
801068c6:	6a 09                	push   $0x9
  jmp alltraps
801068c8:	e9 82 fa ff ff       	jmp    8010634f <alltraps>

801068cd <vector10>:
.globl vector10
vector10:
  pushl $10
801068cd:	6a 0a                	push   $0xa
  jmp alltraps
801068cf:	e9 7b fa ff ff       	jmp    8010634f <alltraps>

801068d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801068d4:	6a 0b                	push   $0xb
  jmp alltraps
801068d6:	e9 74 fa ff ff       	jmp    8010634f <alltraps>

801068db <vector12>:
.globl vector12
vector12:
  pushl $12
801068db:	6a 0c                	push   $0xc
  jmp alltraps
801068dd:	e9 6d fa ff ff       	jmp    8010634f <alltraps>

801068e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801068e2:	6a 0d                	push   $0xd
  jmp alltraps
801068e4:	e9 66 fa ff ff       	jmp    8010634f <alltraps>

801068e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801068e9:	6a 0e                	push   $0xe
  jmp alltraps
801068eb:	e9 5f fa ff ff       	jmp    8010634f <alltraps>

801068f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $15
801068f2:	6a 0f                	push   $0xf
  jmp alltraps
801068f4:	e9 56 fa ff ff       	jmp    8010634f <alltraps>

801068f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $16
801068fb:	6a 10                	push   $0x10
  jmp alltraps
801068fd:	e9 4d fa ff ff       	jmp    8010634f <alltraps>

80106902 <vector17>:
.globl vector17
vector17:
  pushl $17
80106902:	6a 11                	push   $0x11
  jmp alltraps
80106904:	e9 46 fa ff ff       	jmp    8010634f <alltraps>

80106909 <vector18>:
.globl vector18
vector18:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $18
8010690b:	6a 12                	push   $0x12
  jmp alltraps
8010690d:	e9 3d fa ff ff       	jmp    8010634f <alltraps>

80106912 <vector19>:
.globl vector19
vector19:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $19
80106914:	6a 13                	push   $0x13
  jmp alltraps
80106916:	e9 34 fa ff ff       	jmp    8010634f <alltraps>

8010691b <vector20>:
.globl vector20
vector20:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $20
8010691d:	6a 14                	push   $0x14
  jmp alltraps
8010691f:	e9 2b fa ff ff       	jmp    8010634f <alltraps>

80106924 <vector21>:
.globl vector21
vector21:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $21
80106926:	6a 15                	push   $0x15
  jmp alltraps
80106928:	e9 22 fa ff ff       	jmp    8010634f <alltraps>

8010692d <vector22>:
.globl vector22
vector22:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $22
8010692f:	6a 16                	push   $0x16
  jmp alltraps
80106931:	e9 19 fa ff ff       	jmp    8010634f <alltraps>

80106936 <vector23>:
.globl vector23
vector23:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $23
80106938:	6a 17                	push   $0x17
  jmp alltraps
8010693a:	e9 10 fa ff ff       	jmp    8010634f <alltraps>

8010693f <vector24>:
.globl vector24
vector24:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $24
80106941:	6a 18                	push   $0x18
  jmp alltraps
80106943:	e9 07 fa ff ff       	jmp    8010634f <alltraps>

80106948 <vector25>:
.globl vector25
vector25:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $25
8010694a:	6a 19                	push   $0x19
  jmp alltraps
8010694c:	e9 fe f9 ff ff       	jmp    8010634f <alltraps>

80106951 <vector26>:
.globl vector26
vector26:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $26
80106953:	6a 1a                	push   $0x1a
  jmp alltraps
80106955:	e9 f5 f9 ff ff       	jmp    8010634f <alltraps>

8010695a <vector27>:
.globl vector27
vector27:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $27
8010695c:	6a 1b                	push   $0x1b
  jmp alltraps
8010695e:	e9 ec f9 ff ff       	jmp    8010634f <alltraps>

80106963 <vector28>:
.globl vector28
vector28:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $28
80106965:	6a 1c                	push   $0x1c
  jmp alltraps
80106967:	e9 e3 f9 ff ff       	jmp    8010634f <alltraps>

8010696c <vector29>:
.globl vector29
vector29:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $29
8010696e:	6a 1d                	push   $0x1d
  jmp alltraps
80106970:	e9 da f9 ff ff       	jmp    8010634f <alltraps>

80106975 <vector30>:
.globl vector30
vector30:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $30
80106977:	6a 1e                	push   $0x1e
  jmp alltraps
80106979:	e9 d1 f9 ff ff       	jmp    8010634f <alltraps>

8010697e <vector31>:
.globl vector31
vector31:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $31
80106980:	6a 1f                	push   $0x1f
  jmp alltraps
80106982:	e9 c8 f9 ff ff       	jmp    8010634f <alltraps>

80106987 <vector32>:
.globl vector32
vector32:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $32
80106989:	6a 20                	push   $0x20
  jmp alltraps
8010698b:	e9 bf f9 ff ff       	jmp    8010634f <alltraps>

80106990 <vector33>:
.globl vector33
vector33:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $33
80106992:	6a 21                	push   $0x21
  jmp alltraps
80106994:	e9 b6 f9 ff ff       	jmp    8010634f <alltraps>

80106999 <vector34>:
.globl vector34
vector34:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $34
8010699b:	6a 22                	push   $0x22
  jmp alltraps
8010699d:	e9 ad f9 ff ff       	jmp    8010634f <alltraps>

801069a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $35
801069a4:	6a 23                	push   $0x23
  jmp alltraps
801069a6:	e9 a4 f9 ff ff       	jmp    8010634f <alltraps>

801069ab <vector36>:
.globl vector36
vector36:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $36
801069ad:	6a 24                	push   $0x24
  jmp alltraps
801069af:	e9 9b f9 ff ff       	jmp    8010634f <alltraps>

801069b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $37
801069b6:	6a 25                	push   $0x25
  jmp alltraps
801069b8:	e9 92 f9 ff ff       	jmp    8010634f <alltraps>

801069bd <vector38>:
.globl vector38
vector38:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $38
801069bf:	6a 26                	push   $0x26
  jmp alltraps
801069c1:	e9 89 f9 ff ff       	jmp    8010634f <alltraps>

801069c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $39
801069c8:	6a 27                	push   $0x27
  jmp alltraps
801069ca:	e9 80 f9 ff ff       	jmp    8010634f <alltraps>

801069cf <vector40>:
.globl vector40
vector40:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $40
801069d1:	6a 28                	push   $0x28
  jmp alltraps
801069d3:	e9 77 f9 ff ff       	jmp    8010634f <alltraps>

801069d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $41
801069da:	6a 29                	push   $0x29
  jmp alltraps
801069dc:	e9 6e f9 ff ff       	jmp    8010634f <alltraps>

801069e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $42
801069e3:	6a 2a                	push   $0x2a
  jmp alltraps
801069e5:	e9 65 f9 ff ff       	jmp    8010634f <alltraps>

801069ea <vector43>:
.globl vector43
vector43:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $43
801069ec:	6a 2b                	push   $0x2b
  jmp alltraps
801069ee:	e9 5c f9 ff ff       	jmp    8010634f <alltraps>

801069f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $44
801069f5:	6a 2c                	push   $0x2c
  jmp alltraps
801069f7:	e9 53 f9 ff ff       	jmp    8010634f <alltraps>

801069fc <vector45>:
.globl vector45
vector45:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $45
801069fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106a00:	e9 4a f9 ff ff       	jmp    8010634f <alltraps>

80106a05 <vector46>:
.globl vector46
vector46:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $46
80106a07:	6a 2e                	push   $0x2e
  jmp alltraps
80106a09:	e9 41 f9 ff ff       	jmp    8010634f <alltraps>

80106a0e <vector47>:
.globl vector47
vector47:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $47
80106a10:	6a 2f                	push   $0x2f
  jmp alltraps
80106a12:	e9 38 f9 ff ff       	jmp    8010634f <alltraps>

80106a17 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $48
80106a19:	6a 30                	push   $0x30
  jmp alltraps
80106a1b:	e9 2f f9 ff ff       	jmp    8010634f <alltraps>

80106a20 <vector49>:
.globl vector49
vector49:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $49
80106a22:	6a 31                	push   $0x31
  jmp alltraps
80106a24:	e9 26 f9 ff ff       	jmp    8010634f <alltraps>

80106a29 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $50
80106a2b:	6a 32                	push   $0x32
  jmp alltraps
80106a2d:	e9 1d f9 ff ff       	jmp    8010634f <alltraps>

80106a32 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $51
80106a34:	6a 33                	push   $0x33
  jmp alltraps
80106a36:	e9 14 f9 ff ff       	jmp    8010634f <alltraps>

80106a3b <vector52>:
.globl vector52
vector52:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $52
80106a3d:	6a 34                	push   $0x34
  jmp alltraps
80106a3f:	e9 0b f9 ff ff       	jmp    8010634f <alltraps>

80106a44 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $53
80106a46:	6a 35                	push   $0x35
  jmp alltraps
80106a48:	e9 02 f9 ff ff       	jmp    8010634f <alltraps>

80106a4d <vector54>:
.globl vector54
vector54:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $54
80106a4f:	6a 36                	push   $0x36
  jmp alltraps
80106a51:	e9 f9 f8 ff ff       	jmp    8010634f <alltraps>

80106a56 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $55
80106a58:	6a 37                	push   $0x37
  jmp alltraps
80106a5a:	e9 f0 f8 ff ff       	jmp    8010634f <alltraps>

80106a5f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $56
80106a61:	6a 38                	push   $0x38
  jmp alltraps
80106a63:	e9 e7 f8 ff ff       	jmp    8010634f <alltraps>

80106a68 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $57
80106a6a:	6a 39                	push   $0x39
  jmp alltraps
80106a6c:	e9 de f8 ff ff       	jmp    8010634f <alltraps>

80106a71 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $58
80106a73:	6a 3a                	push   $0x3a
  jmp alltraps
80106a75:	e9 d5 f8 ff ff       	jmp    8010634f <alltraps>

80106a7a <vector59>:
.globl vector59
vector59:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $59
80106a7c:	6a 3b                	push   $0x3b
  jmp alltraps
80106a7e:	e9 cc f8 ff ff       	jmp    8010634f <alltraps>

80106a83 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $60
80106a85:	6a 3c                	push   $0x3c
  jmp alltraps
80106a87:	e9 c3 f8 ff ff       	jmp    8010634f <alltraps>

80106a8c <vector61>:
.globl vector61
vector61:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $61
80106a8e:	6a 3d                	push   $0x3d
  jmp alltraps
80106a90:	e9 ba f8 ff ff       	jmp    8010634f <alltraps>

80106a95 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $62
80106a97:	6a 3e                	push   $0x3e
  jmp alltraps
80106a99:	e9 b1 f8 ff ff       	jmp    8010634f <alltraps>

80106a9e <vector63>:
.globl vector63
vector63:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $63
80106aa0:	6a 3f                	push   $0x3f
  jmp alltraps
80106aa2:	e9 a8 f8 ff ff       	jmp    8010634f <alltraps>

80106aa7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $64
80106aa9:	6a 40                	push   $0x40
  jmp alltraps
80106aab:	e9 9f f8 ff ff       	jmp    8010634f <alltraps>

80106ab0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $65
80106ab2:	6a 41                	push   $0x41
  jmp alltraps
80106ab4:	e9 96 f8 ff ff       	jmp    8010634f <alltraps>

80106ab9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $66
80106abb:	6a 42                	push   $0x42
  jmp alltraps
80106abd:	e9 8d f8 ff ff       	jmp    8010634f <alltraps>

80106ac2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $67
80106ac4:	6a 43                	push   $0x43
  jmp alltraps
80106ac6:	e9 84 f8 ff ff       	jmp    8010634f <alltraps>

80106acb <vector68>:
.globl vector68
vector68:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $68
80106acd:	6a 44                	push   $0x44
  jmp alltraps
80106acf:	e9 7b f8 ff ff       	jmp    8010634f <alltraps>

80106ad4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $69
80106ad6:	6a 45                	push   $0x45
  jmp alltraps
80106ad8:	e9 72 f8 ff ff       	jmp    8010634f <alltraps>

80106add <vector70>:
.globl vector70
vector70:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $70
80106adf:	6a 46                	push   $0x46
  jmp alltraps
80106ae1:	e9 69 f8 ff ff       	jmp    8010634f <alltraps>

80106ae6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $71
80106ae8:	6a 47                	push   $0x47
  jmp alltraps
80106aea:	e9 60 f8 ff ff       	jmp    8010634f <alltraps>

80106aef <vector72>:
.globl vector72
vector72:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $72
80106af1:	6a 48                	push   $0x48
  jmp alltraps
80106af3:	e9 57 f8 ff ff       	jmp    8010634f <alltraps>

80106af8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $73
80106afa:	6a 49                	push   $0x49
  jmp alltraps
80106afc:	e9 4e f8 ff ff       	jmp    8010634f <alltraps>

80106b01 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $74
80106b03:	6a 4a                	push   $0x4a
  jmp alltraps
80106b05:	e9 45 f8 ff ff       	jmp    8010634f <alltraps>

80106b0a <vector75>:
.globl vector75
vector75:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $75
80106b0c:	6a 4b                	push   $0x4b
  jmp alltraps
80106b0e:	e9 3c f8 ff ff       	jmp    8010634f <alltraps>

80106b13 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $76
80106b15:	6a 4c                	push   $0x4c
  jmp alltraps
80106b17:	e9 33 f8 ff ff       	jmp    8010634f <alltraps>

80106b1c <vector77>:
.globl vector77
vector77:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $77
80106b1e:	6a 4d                	push   $0x4d
  jmp alltraps
80106b20:	e9 2a f8 ff ff       	jmp    8010634f <alltraps>

80106b25 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $78
80106b27:	6a 4e                	push   $0x4e
  jmp alltraps
80106b29:	e9 21 f8 ff ff       	jmp    8010634f <alltraps>

80106b2e <vector79>:
.globl vector79
vector79:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $79
80106b30:	6a 4f                	push   $0x4f
  jmp alltraps
80106b32:	e9 18 f8 ff ff       	jmp    8010634f <alltraps>

80106b37 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $80
80106b39:	6a 50                	push   $0x50
  jmp alltraps
80106b3b:	e9 0f f8 ff ff       	jmp    8010634f <alltraps>

80106b40 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $81
80106b42:	6a 51                	push   $0x51
  jmp alltraps
80106b44:	e9 06 f8 ff ff       	jmp    8010634f <alltraps>

80106b49 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $82
80106b4b:	6a 52                	push   $0x52
  jmp alltraps
80106b4d:	e9 fd f7 ff ff       	jmp    8010634f <alltraps>

80106b52 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $83
80106b54:	6a 53                	push   $0x53
  jmp alltraps
80106b56:	e9 f4 f7 ff ff       	jmp    8010634f <alltraps>

80106b5b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $84
80106b5d:	6a 54                	push   $0x54
  jmp alltraps
80106b5f:	e9 eb f7 ff ff       	jmp    8010634f <alltraps>

80106b64 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $85
80106b66:	6a 55                	push   $0x55
  jmp alltraps
80106b68:	e9 e2 f7 ff ff       	jmp    8010634f <alltraps>

80106b6d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $86
80106b6f:	6a 56                	push   $0x56
  jmp alltraps
80106b71:	e9 d9 f7 ff ff       	jmp    8010634f <alltraps>

80106b76 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $87
80106b78:	6a 57                	push   $0x57
  jmp alltraps
80106b7a:	e9 d0 f7 ff ff       	jmp    8010634f <alltraps>

80106b7f <vector88>:
.globl vector88
vector88:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $88
80106b81:	6a 58                	push   $0x58
  jmp alltraps
80106b83:	e9 c7 f7 ff ff       	jmp    8010634f <alltraps>

80106b88 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $89
80106b8a:	6a 59                	push   $0x59
  jmp alltraps
80106b8c:	e9 be f7 ff ff       	jmp    8010634f <alltraps>

80106b91 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $90
80106b93:	6a 5a                	push   $0x5a
  jmp alltraps
80106b95:	e9 b5 f7 ff ff       	jmp    8010634f <alltraps>

80106b9a <vector91>:
.globl vector91
vector91:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $91
80106b9c:	6a 5b                	push   $0x5b
  jmp alltraps
80106b9e:	e9 ac f7 ff ff       	jmp    8010634f <alltraps>

80106ba3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $92
80106ba5:	6a 5c                	push   $0x5c
  jmp alltraps
80106ba7:	e9 a3 f7 ff ff       	jmp    8010634f <alltraps>

80106bac <vector93>:
.globl vector93
vector93:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $93
80106bae:	6a 5d                	push   $0x5d
  jmp alltraps
80106bb0:	e9 9a f7 ff ff       	jmp    8010634f <alltraps>

80106bb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $94
80106bb7:	6a 5e                	push   $0x5e
  jmp alltraps
80106bb9:	e9 91 f7 ff ff       	jmp    8010634f <alltraps>

80106bbe <vector95>:
.globl vector95
vector95:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $95
80106bc0:	6a 5f                	push   $0x5f
  jmp alltraps
80106bc2:	e9 88 f7 ff ff       	jmp    8010634f <alltraps>

80106bc7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $96
80106bc9:	6a 60                	push   $0x60
  jmp alltraps
80106bcb:	e9 7f f7 ff ff       	jmp    8010634f <alltraps>

80106bd0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $97
80106bd2:	6a 61                	push   $0x61
  jmp alltraps
80106bd4:	e9 76 f7 ff ff       	jmp    8010634f <alltraps>

80106bd9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $98
80106bdb:	6a 62                	push   $0x62
  jmp alltraps
80106bdd:	e9 6d f7 ff ff       	jmp    8010634f <alltraps>

80106be2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $99
80106be4:	6a 63                	push   $0x63
  jmp alltraps
80106be6:	e9 64 f7 ff ff       	jmp    8010634f <alltraps>

80106beb <vector100>:
.globl vector100
vector100:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $100
80106bed:	6a 64                	push   $0x64
  jmp alltraps
80106bef:	e9 5b f7 ff ff       	jmp    8010634f <alltraps>

80106bf4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $101
80106bf6:	6a 65                	push   $0x65
  jmp alltraps
80106bf8:	e9 52 f7 ff ff       	jmp    8010634f <alltraps>

80106bfd <vector102>:
.globl vector102
vector102:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $102
80106bff:	6a 66                	push   $0x66
  jmp alltraps
80106c01:	e9 49 f7 ff ff       	jmp    8010634f <alltraps>

80106c06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $103
80106c08:	6a 67                	push   $0x67
  jmp alltraps
80106c0a:	e9 40 f7 ff ff       	jmp    8010634f <alltraps>

80106c0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $104
80106c11:	6a 68                	push   $0x68
  jmp alltraps
80106c13:	e9 37 f7 ff ff       	jmp    8010634f <alltraps>

80106c18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $105
80106c1a:	6a 69                	push   $0x69
  jmp alltraps
80106c1c:	e9 2e f7 ff ff       	jmp    8010634f <alltraps>

80106c21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $106
80106c23:	6a 6a                	push   $0x6a
  jmp alltraps
80106c25:	e9 25 f7 ff ff       	jmp    8010634f <alltraps>

80106c2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $107
80106c2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106c2e:	e9 1c f7 ff ff       	jmp    8010634f <alltraps>

80106c33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $108
80106c35:	6a 6c                	push   $0x6c
  jmp alltraps
80106c37:	e9 13 f7 ff ff       	jmp    8010634f <alltraps>

80106c3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $109
80106c3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106c40:	e9 0a f7 ff ff       	jmp    8010634f <alltraps>

80106c45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $110
80106c47:	6a 6e                	push   $0x6e
  jmp alltraps
80106c49:	e9 01 f7 ff ff       	jmp    8010634f <alltraps>

80106c4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $111
80106c50:	6a 6f                	push   $0x6f
  jmp alltraps
80106c52:	e9 f8 f6 ff ff       	jmp    8010634f <alltraps>

80106c57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $112
80106c59:	6a 70                	push   $0x70
  jmp alltraps
80106c5b:	e9 ef f6 ff ff       	jmp    8010634f <alltraps>

80106c60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $113
80106c62:	6a 71                	push   $0x71
  jmp alltraps
80106c64:	e9 e6 f6 ff ff       	jmp    8010634f <alltraps>

80106c69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $114
80106c6b:	6a 72                	push   $0x72
  jmp alltraps
80106c6d:	e9 dd f6 ff ff       	jmp    8010634f <alltraps>

80106c72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $115
80106c74:	6a 73                	push   $0x73
  jmp alltraps
80106c76:	e9 d4 f6 ff ff       	jmp    8010634f <alltraps>

80106c7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $116
80106c7d:	6a 74                	push   $0x74
  jmp alltraps
80106c7f:	e9 cb f6 ff ff       	jmp    8010634f <alltraps>

80106c84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $117
80106c86:	6a 75                	push   $0x75
  jmp alltraps
80106c88:	e9 c2 f6 ff ff       	jmp    8010634f <alltraps>

80106c8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $118
80106c8f:	6a 76                	push   $0x76
  jmp alltraps
80106c91:	e9 b9 f6 ff ff       	jmp    8010634f <alltraps>

80106c96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $119
80106c98:	6a 77                	push   $0x77
  jmp alltraps
80106c9a:	e9 b0 f6 ff ff       	jmp    8010634f <alltraps>

80106c9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $120
80106ca1:	6a 78                	push   $0x78
  jmp alltraps
80106ca3:	e9 a7 f6 ff ff       	jmp    8010634f <alltraps>

80106ca8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $121
80106caa:	6a 79                	push   $0x79
  jmp alltraps
80106cac:	e9 9e f6 ff ff       	jmp    8010634f <alltraps>

80106cb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $122
80106cb3:	6a 7a                	push   $0x7a
  jmp alltraps
80106cb5:	e9 95 f6 ff ff       	jmp    8010634f <alltraps>

80106cba <vector123>:
.globl vector123
vector123:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $123
80106cbc:	6a 7b                	push   $0x7b
  jmp alltraps
80106cbe:	e9 8c f6 ff ff       	jmp    8010634f <alltraps>

80106cc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $124
80106cc5:	6a 7c                	push   $0x7c
  jmp alltraps
80106cc7:	e9 83 f6 ff ff       	jmp    8010634f <alltraps>

80106ccc <vector125>:
.globl vector125
vector125:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $125
80106cce:	6a 7d                	push   $0x7d
  jmp alltraps
80106cd0:	e9 7a f6 ff ff       	jmp    8010634f <alltraps>

80106cd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $126
80106cd7:	6a 7e                	push   $0x7e
  jmp alltraps
80106cd9:	e9 71 f6 ff ff       	jmp    8010634f <alltraps>

80106cde <vector127>:
.globl vector127
vector127:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $127
80106ce0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ce2:	e9 68 f6 ff ff       	jmp    8010634f <alltraps>

80106ce7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $128
80106ce9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cee:	e9 5c f6 ff ff       	jmp    8010634f <alltraps>

80106cf3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $129
80106cf5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cfa:	e9 50 f6 ff ff       	jmp    8010634f <alltraps>

80106cff <vector130>:
.globl vector130
vector130:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $130
80106d01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d06:	e9 44 f6 ff ff       	jmp    8010634f <alltraps>

80106d0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $131
80106d0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d12:	e9 38 f6 ff ff       	jmp    8010634f <alltraps>

80106d17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $132
80106d19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d1e:	e9 2c f6 ff ff       	jmp    8010634f <alltraps>

80106d23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $133
80106d25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d2a:	e9 20 f6 ff ff       	jmp    8010634f <alltraps>

80106d2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $134
80106d31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d36:	e9 14 f6 ff ff       	jmp    8010634f <alltraps>

80106d3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $135
80106d3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d42:	e9 08 f6 ff ff       	jmp    8010634f <alltraps>

80106d47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $136
80106d49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d4e:	e9 fc f5 ff ff       	jmp    8010634f <alltraps>

80106d53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $137
80106d55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d5a:	e9 f0 f5 ff ff       	jmp    8010634f <alltraps>

80106d5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $138
80106d61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d66:	e9 e4 f5 ff ff       	jmp    8010634f <alltraps>

80106d6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $139
80106d6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d72:	e9 d8 f5 ff ff       	jmp    8010634f <alltraps>

80106d77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $140
80106d79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d7e:	e9 cc f5 ff ff       	jmp    8010634f <alltraps>

80106d83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $141
80106d85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d8a:	e9 c0 f5 ff ff       	jmp    8010634f <alltraps>

80106d8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $142
80106d91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d96:	e9 b4 f5 ff ff       	jmp    8010634f <alltraps>

80106d9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $143
80106d9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106da2:	e9 a8 f5 ff ff       	jmp    8010634f <alltraps>

80106da7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $144
80106da9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106dae:	e9 9c f5 ff ff       	jmp    8010634f <alltraps>

80106db3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $145
80106db5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106dba:	e9 90 f5 ff ff       	jmp    8010634f <alltraps>

80106dbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $146
80106dc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106dc6:	e9 84 f5 ff ff       	jmp    8010634f <alltraps>

80106dcb <vector147>:
.globl vector147
vector147:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $147
80106dcd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106dd2:	e9 78 f5 ff ff       	jmp    8010634f <alltraps>

80106dd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $148
80106dd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106dde:	e9 6c f5 ff ff       	jmp    8010634f <alltraps>

80106de3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $149
80106de5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106dea:	e9 60 f5 ff ff       	jmp    8010634f <alltraps>

80106def <vector150>:
.globl vector150
vector150:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $150
80106df1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106df6:	e9 54 f5 ff ff       	jmp    8010634f <alltraps>

80106dfb <vector151>:
.globl vector151
vector151:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $151
80106dfd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e02:	e9 48 f5 ff ff       	jmp    8010634f <alltraps>

80106e07 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $152
80106e09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e0e:	e9 3c f5 ff ff       	jmp    8010634f <alltraps>

80106e13 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $153
80106e15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e1a:	e9 30 f5 ff ff       	jmp    8010634f <alltraps>

80106e1f <vector154>:
.globl vector154
vector154:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $154
80106e21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e26:	e9 24 f5 ff ff       	jmp    8010634f <alltraps>

80106e2b <vector155>:
.globl vector155
vector155:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $155
80106e2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e32:	e9 18 f5 ff ff       	jmp    8010634f <alltraps>

80106e37 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $156
80106e39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e3e:	e9 0c f5 ff ff       	jmp    8010634f <alltraps>

80106e43 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $157
80106e45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e4a:	e9 00 f5 ff ff       	jmp    8010634f <alltraps>

80106e4f <vector158>:
.globl vector158
vector158:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $158
80106e51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e56:	e9 f4 f4 ff ff       	jmp    8010634f <alltraps>

80106e5b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $159
80106e5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e62:	e9 e8 f4 ff ff       	jmp    8010634f <alltraps>

80106e67 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $160
80106e69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e6e:	e9 dc f4 ff ff       	jmp    8010634f <alltraps>

80106e73 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $161
80106e75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e7a:	e9 d0 f4 ff ff       	jmp    8010634f <alltraps>

80106e7f <vector162>:
.globl vector162
vector162:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $162
80106e81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e86:	e9 c4 f4 ff ff       	jmp    8010634f <alltraps>

80106e8b <vector163>:
.globl vector163
vector163:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $163
80106e8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e92:	e9 b8 f4 ff ff       	jmp    8010634f <alltraps>

80106e97 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $164
80106e99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e9e:	e9 ac f4 ff ff       	jmp    8010634f <alltraps>

80106ea3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $165
80106ea5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106eaa:	e9 a0 f4 ff ff       	jmp    8010634f <alltraps>

80106eaf <vector166>:
.globl vector166
vector166:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $166
80106eb1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106eb6:	e9 94 f4 ff ff       	jmp    8010634f <alltraps>

80106ebb <vector167>:
.globl vector167
vector167:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $167
80106ebd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ec2:	e9 88 f4 ff ff       	jmp    8010634f <alltraps>

80106ec7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $168
80106ec9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ece:	e9 7c f4 ff ff       	jmp    8010634f <alltraps>

80106ed3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $169
80106ed5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106eda:	e9 70 f4 ff ff       	jmp    8010634f <alltraps>

80106edf <vector170>:
.globl vector170
vector170:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $170
80106ee1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ee6:	e9 64 f4 ff ff       	jmp    8010634f <alltraps>

80106eeb <vector171>:
.globl vector171
vector171:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $171
80106eed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ef2:	e9 58 f4 ff ff       	jmp    8010634f <alltraps>

80106ef7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $172
80106ef9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106efe:	e9 4c f4 ff ff       	jmp    8010634f <alltraps>

80106f03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $173
80106f05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f0a:	e9 40 f4 ff ff       	jmp    8010634f <alltraps>

80106f0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $174
80106f11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f16:	e9 34 f4 ff ff       	jmp    8010634f <alltraps>

80106f1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $175
80106f1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f22:	e9 28 f4 ff ff       	jmp    8010634f <alltraps>

80106f27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $176
80106f29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f2e:	e9 1c f4 ff ff       	jmp    8010634f <alltraps>

80106f33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $177
80106f35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f3a:	e9 10 f4 ff ff       	jmp    8010634f <alltraps>

80106f3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $178
80106f41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f46:	e9 04 f4 ff ff       	jmp    8010634f <alltraps>

80106f4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $179
80106f4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f52:	e9 f8 f3 ff ff       	jmp    8010634f <alltraps>

80106f57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $180
80106f59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f5e:	e9 ec f3 ff ff       	jmp    8010634f <alltraps>

80106f63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $181
80106f65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f6a:	e9 e0 f3 ff ff       	jmp    8010634f <alltraps>

80106f6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $182
80106f71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f76:	e9 d4 f3 ff ff       	jmp    8010634f <alltraps>

80106f7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $183
80106f7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f82:	e9 c8 f3 ff ff       	jmp    8010634f <alltraps>

80106f87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $184
80106f89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f8e:	e9 bc f3 ff ff       	jmp    8010634f <alltraps>

80106f93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $185
80106f95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f9a:	e9 b0 f3 ff ff       	jmp    8010634f <alltraps>

80106f9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $186
80106fa1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106fa6:	e9 a4 f3 ff ff       	jmp    8010634f <alltraps>

80106fab <vector187>:
.globl vector187
vector187:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $187
80106fad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106fb2:	e9 98 f3 ff ff       	jmp    8010634f <alltraps>

80106fb7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $188
80106fb9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106fbe:	e9 8c f3 ff ff       	jmp    8010634f <alltraps>

80106fc3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $189
80106fc5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106fca:	e9 80 f3 ff ff       	jmp    8010634f <alltraps>

80106fcf <vector190>:
.globl vector190
vector190:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $190
80106fd1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106fd6:	e9 74 f3 ff ff       	jmp    8010634f <alltraps>

80106fdb <vector191>:
.globl vector191
vector191:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $191
80106fdd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fe2:	e9 68 f3 ff ff       	jmp    8010634f <alltraps>

80106fe7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $192
80106fe9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fee:	e9 5c f3 ff ff       	jmp    8010634f <alltraps>

80106ff3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $193
80106ff5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ffa:	e9 50 f3 ff ff       	jmp    8010634f <alltraps>

80106fff <vector194>:
.globl vector194
vector194:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $194
80107001:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107006:	e9 44 f3 ff ff       	jmp    8010634f <alltraps>

8010700b <vector195>:
.globl vector195
vector195:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $195
8010700d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107012:	e9 38 f3 ff ff       	jmp    8010634f <alltraps>

80107017 <vector196>:
.globl vector196
vector196:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $196
80107019:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010701e:	e9 2c f3 ff ff       	jmp    8010634f <alltraps>

80107023 <vector197>:
.globl vector197
vector197:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $197
80107025:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010702a:	e9 20 f3 ff ff       	jmp    8010634f <alltraps>

8010702f <vector198>:
.globl vector198
vector198:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $198
80107031:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107036:	e9 14 f3 ff ff       	jmp    8010634f <alltraps>

8010703b <vector199>:
.globl vector199
vector199:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $199
8010703d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107042:	e9 08 f3 ff ff       	jmp    8010634f <alltraps>

80107047 <vector200>:
.globl vector200
vector200:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $200
80107049:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010704e:	e9 fc f2 ff ff       	jmp    8010634f <alltraps>

80107053 <vector201>:
.globl vector201
vector201:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $201
80107055:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010705a:	e9 f0 f2 ff ff       	jmp    8010634f <alltraps>

8010705f <vector202>:
.globl vector202
vector202:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $202
80107061:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107066:	e9 e4 f2 ff ff       	jmp    8010634f <alltraps>

8010706b <vector203>:
.globl vector203
vector203:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $203
8010706d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107072:	e9 d8 f2 ff ff       	jmp    8010634f <alltraps>

80107077 <vector204>:
.globl vector204
vector204:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $204
80107079:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010707e:	e9 cc f2 ff ff       	jmp    8010634f <alltraps>

80107083 <vector205>:
.globl vector205
vector205:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $205
80107085:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010708a:	e9 c0 f2 ff ff       	jmp    8010634f <alltraps>

8010708f <vector206>:
.globl vector206
vector206:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $206
80107091:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107096:	e9 b4 f2 ff ff       	jmp    8010634f <alltraps>

8010709b <vector207>:
.globl vector207
vector207:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $207
8010709d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801070a2:	e9 a8 f2 ff ff       	jmp    8010634f <alltraps>

801070a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $208
801070a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801070ae:	e9 9c f2 ff ff       	jmp    8010634f <alltraps>

801070b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $209
801070b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801070ba:	e9 90 f2 ff ff       	jmp    8010634f <alltraps>

801070bf <vector210>:
.globl vector210
vector210:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $210
801070c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801070c6:	e9 84 f2 ff ff       	jmp    8010634f <alltraps>

801070cb <vector211>:
.globl vector211
vector211:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $211
801070cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801070d2:	e9 78 f2 ff ff       	jmp    8010634f <alltraps>

801070d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $212
801070d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070de:	e9 6c f2 ff ff       	jmp    8010634f <alltraps>

801070e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $213
801070e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070ea:	e9 60 f2 ff ff       	jmp    8010634f <alltraps>

801070ef <vector214>:
.globl vector214
vector214:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $214
801070f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070f6:	e9 54 f2 ff ff       	jmp    8010634f <alltraps>

801070fb <vector215>:
.globl vector215
vector215:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $215
801070fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107102:	e9 48 f2 ff ff       	jmp    8010634f <alltraps>

80107107 <vector216>:
.globl vector216
vector216:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $216
80107109:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010710e:	e9 3c f2 ff ff       	jmp    8010634f <alltraps>

80107113 <vector217>:
.globl vector217
vector217:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $217
80107115:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010711a:	e9 30 f2 ff ff       	jmp    8010634f <alltraps>

8010711f <vector218>:
.globl vector218
vector218:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $218
80107121:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107126:	e9 24 f2 ff ff       	jmp    8010634f <alltraps>

8010712b <vector219>:
.globl vector219
vector219:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $219
8010712d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107132:	e9 18 f2 ff ff       	jmp    8010634f <alltraps>

80107137 <vector220>:
.globl vector220
vector220:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $220
80107139:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010713e:	e9 0c f2 ff ff       	jmp    8010634f <alltraps>

80107143 <vector221>:
.globl vector221
vector221:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $221
80107145:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010714a:	e9 00 f2 ff ff       	jmp    8010634f <alltraps>

8010714f <vector222>:
.globl vector222
vector222:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $222
80107151:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107156:	e9 f4 f1 ff ff       	jmp    8010634f <alltraps>

8010715b <vector223>:
.globl vector223
vector223:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $223
8010715d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107162:	e9 e8 f1 ff ff       	jmp    8010634f <alltraps>

80107167 <vector224>:
.globl vector224
vector224:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $224
80107169:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010716e:	e9 dc f1 ff ff       	jmp    8010634f <alltraps>

80107173 <vector225>:
.globl vector225
vector225:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $225
80107175:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010717a:	e9 d0 f1 ff ff       	jmp    8010634f <alltraps>

8010717f <vector226>:
.globl vector226
vector226:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $226
80107181:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107186:	e9 c4 f1 ff ff       	jmp    8010634f <alltraps>

8010718b <vector227>:
.globl vector227
vector227:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $227
8010718d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107192:	e9 b8 f1 ff ff       	jmp    8010634f <alltraps>

80107197 <vector228>:
.globl vector228
vector228:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $228
80107199:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010719e:	e9 ac f1 ff ff       	jmp    8010634f <alltraps>

801071a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $229
801071a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801071aa:	e9 a0 f1 ff ff       	jmp    8010634f <alltraps>

801071af <vector230>:
.globl vector230
vector230:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $230
801071b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801071b6:	e9 94 f1 ff ff       	jmp    8010634f <alltraps>

801071bb <vector231>:
.globl vector231
vector231:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $231
801071bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801071c2:	e9 88 f1 ff ff       	jmp    8010634f <alltraps>

801071c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $232
801071c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071ce:	e9 7c f1 ff ff       	jmp    8010634f <alltraps>

801071d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $233
801071d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801071da:	e9 70 f1 ff ff       	jmp    8010634f <alltraps>

801071df <vector234>:
.globl vector234
vector234:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $234
801071e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071e6:	e9 64 f1 ff ff       	jmp    8010634f <alltraps>

801071eb <vector235>:
.globl vector235
vector235:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $235
801071ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071f2:	e9 58 f1 ff ff       	jmp    8010634f <alltraps>

801071f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $236
801071f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071fe:	e9 4c f1 ff ff       	jmp    8010634f <alltraps>

80107203 <vector237>:
.globl vector237
vector237:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $237
80107205:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010720a:	e9 40 f1 ff ff       	jmp    8010634f <alltraps>

8010720f <vector238>:
.globl vector238
vector238:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $238
80107211:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107216:	e9 34 f1 ff ff       	jmp    8010634f <alltraps>

8010721b <vector239>:
.globl vector239
vector239:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $239
8010721d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107222:	e9 28 f1 ff ff       	jmp    8010634f <alltraps>

80107227 <vector240>:
.globl vector240
vector240:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $240
80107229:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010722e:	e9 1c f1 ff ff       	jmp    8010634f <alltraps>

80107233 <vector241>:
.globl vector241
vector241:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $241
80107235:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010723a:	e9 10 f1 ff ff       	jmp    8010634f <alltraps>

8010723f <vector242>:
.globl vector242
vector242:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $242
80107241:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107246:	e9 04 f1 ff ff       	jmp    8010634f <alltraps>

8010724b <vector243>:
.globl vector243
vector243:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $243
8010724d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107252:	e9 f8 f0 ff ff       	jmp    8010634f <alltraps>

80107257 <vector244>:
.globl vector244
vector244:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $244
80107259:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010725e:	e9 ec f0 ff ff       	jmp    8010634f <alltraps>

80107263 <vector245>:
.globl vector245
vector245:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $245
80107265:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010726a:	e9 e0 f0 ff ff       	jmp    8010634f <alltraps>

8010726f <vector246>:
.globl vector246
vector246:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $246
80107271:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107276:	e9 d4 f0 ff ff       	jmp    8010634f <alltraps>

8010727b <vector247>:
.globl vector247
vector247:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $247
8010727d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107282:	e9 c8 f0 ff ff       	jmp    8010634f <alltraps>

80107287 <vector248>:
.globl vector248
vector248:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $248
80107289:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010728e:	e9 bc f0 ff ff       	jmp    8010634f <alltraps>

80107293 <vector249>:
.globl vector249
vector249:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $249
80107295:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010729a:	e9 b0 f0 ff ff       	jmp    8010634f <alltraps>

8010729f <vector250>:
.globl vector250
vector250:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $250
801072a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801072a6:	e9 a4 f0 ff ff       	jmp    8010634f <alltraps>

801072ab <vector251>:
.globl vector251
vector251:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $251
801072ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801072b2:	e9 98 f0 ff ff       	jmp    8010634f <alltraps>

801072b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $252
801072b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801072be:	e9 8c f0 ff ff       	jmp    8010634f <alltraps>

801072c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $253
801072c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801072ca:	e9 80 f0 ff ff       	jmp    8010634f <alltraps>

801072cf <vector254>:
.globl vector254
vector254:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $254
801072d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801072d6:	e9 74 f0 ff ff       	jmp    8010634f <alltraps>

801072db <vector255>:
.globl vector255
vector255:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $255
801072dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072e2:	e9 68 f0 ff ff       	jmp    8010634f <alltraps>
801072e7:	66 90                	xchg   %ax,%ax
801072e9:	66 90                	xchg   %ax,%ax
801072eb:	66 90                	xchg   %ax,%ax
801072ed:	66 90                	xchg   %ax,%ax
801072ef:	90                   	nop

801072f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801072f6:	89 d3                	mov    %edx,%ebx
{
801072f8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801072fa:	c1 eb 16             	shr    $0x16,%ebx
801072fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107300:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107303:	8b 06                	mov    (%esi),%eax
80107305:	a8 01                	test   $0x1,%al
80107307:	74 27                	je     80107330 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107309:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010730e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107314:	c1 ef 0a             	shr    $0xa,%edi
}
80107317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010731a:	89 fa                	mov    %edi,%edx
8010731c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107322:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107330:	85 c9                	test   %ecx,%ecx
80107332:	74 2c                	je     80107360 <walkpgdir+0x70>
80107334:	e8 87 b1 ff ff       	call   801024c0 <kalloc>
80107339:	85 c0                	test   %eax,%eax
8010733b:	89 c3                	mov    %eax,%ebx
8010733d:	74 21                	je     80107360 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010733f:	83 ec 04             	sub    $0x4,%esp
80107342:	68 00 10 00 00       	push   $0x1000
80107347:	6a 00                	push   $0x0
80107349:	50                   	push   %eax
8010734a:	e8 31 dd ff ff       	call   80105080 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010734f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107355:	83 c4 10             	add    $0x10,%esp
80107358:	83 c8 07             	or     $0x7,%eax
8010735b:	89 06                	mov    %eax,(%esi)
8010735d:	eb b5                	jmp    80107314 <walkpgdir+0x24>
8010735f:	90                   	nop
}
80107360:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107363:	31 c0                	xor    %eax,%eax
}
80107365:	5b                   	pop    %ebx
80107366:	5e                   	pop    %esi
80107367:	5f                   	pop    %edi
80107368:	5d                   	pop    %ebp
80107369:	c3                   	ret    
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107370 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107376:	89 d3                	mov    %edx,%ebx
80107378:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010737e:	83 ec 1c             	sub    $0x1c,%esp
80107381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107384:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107388:	8b 7d 08             	mov    0x8(%ebp),%edi
8010738b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107390:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107393:	8b 45 0c             	mov    0xc(%ebp),%eax
80107396:	29 df                	sub    %ebx,%edi
80107398:	83 c8 01             	or     $0x1,%eax
8010739b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010739e:	eb 15                	jmp    801073b5 <mappages+0x45>
    if(*pte & PTE_P)
801073a0:	f6 00 01             	testb  $0x1,(%eax)
801073a3:	75 45                	jne    801073ea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801073a5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801073a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801073ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801073ad:	74 31                	je     801073e0 <mappages+0x70>
      break;
    a += PGSIZE;
801073af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801073bd:	89 da                	mov    %ebx,%edx
801073bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801073c2:	e8 29 ff ff ff       	call   801072f0 <walkpgdir>
801073c7:	85 c0                	test   %eax,%eax
801073c9:	75 d5                	jne    801073a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801073cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d3:	5b                   	pop    %ebx
801073d4:	5e                   	pop    %esi
801073d5:	5f                   	pop    %edi
801073d6:	5d                   	pop    %ebp
801073d7:	c3                   	ret    
801073d8:	90                   	nop
801073d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073e3:	31 c0                	xor    %eax,%eax
}
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
      panic("remap");
801073ea:	83 ec 0c             	sub    $0xc,%esp
801073ed:	68 74 85 10 80       	push   $0x80108574
801073f2:	e8 99 8f ff ff       	call   80100390 <panic>
801073f7:	89 f6                	mov    %esi,%esi
801073f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107400 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107406:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010740c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010740e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107414:	83 ec 1c             	sub    $0x1c,%esp
80107417:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010741a:	39 d3                	cmp    %edx,%ebx
8010741c:	73 66                	jae    80107484 <deallocuvm.part.0+0x84>
8010741e:	89 d6                	mov    %edx,%esi
80107420:	eb 3d                	jmp    8010745f <deallocuvm.part.0+0x5f>
80107422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107428:	8b 10                	mov    (%eax),%edx
8010742a:	f6 c2 01             	test   $0x1,%dl
8010742d:	74 26                	je     80107455 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010742f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107435:	74 58                	je     8010748f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107437:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010743a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107443:	52                   	push   %edx
80107444:	e8 c7 ae ff ff       	call   80102310 <kfree>
      *pte = 0;
80107449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010744c:	83 c4 10             	add    $0x10,%esp
8010744f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107455:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010745b:	39 f3                	cmp    %esi,%ebx
8010745d:	73 25                	jae    80107484 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010745f:	31 c9                	xor    %ecx,%ecx
80107461:	89 da                	mov    %ebx,%edx
80107463:	89 f8                	mov    %edi,%eax
80107465:	e8 86 fe ff ff       	call   801072f0 <walkpgdir>
    if(!pte)
8010746a:	85 c0                	test   %eax,%eax
8010746c:	75 ba                	jne    80107428 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010746e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107474:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010747a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107480:	39 f3                	cmp    %esi,%ebx
80107482:	72 db                	jb     8010745f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107484:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107487:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748a:	5b                   	pop    %ebx
8010748b:	5e                   	pop    %esi
8010748c:	5f                   	pop    %edi
8010748d:	5d                   	pop    %ebp
8010748e:	c3                   	ret    
        panic("kfree");
8010748f:	83 ec 0c             	sub    $0xc,%esp
80107492:	68 86 7e 10 80       	push   $0x80107e86
80107497:	e8 f4 8e ff ff       	call   80100390 <panic>
8010749c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074a0 <seginit>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801074a6:	e8 85 c2 ff ff       	call   80103730 <cpuid>
801074ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801074b1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801074b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801074ba:	c7 80 38 40 11 80 ff 	movl   $0xffff,-0x7feebfc8(%eax)
801074c1:	ff 00 00 
801074c4:	c7 80 3c 40 11 80 00 	movl   $0xcf9a00,-0x7feebfc4(%eax)
801074cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074ce:	c7 80 40 40 11 80 ff 	movl   $0xffff,-0x7feebfc0(%eax)
801074d5:	ff 00 00 
801074d8:	c7 80 44 40 11 80 00 	movl   $0xcf9200,-0x7feebfbc(%eax)
801074df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801074e2:	c7 80 48 40 11 80 ff 	movl   $0xffff,-0x7feebfb8(%eax)
801074e9:	ff 00 00 
801074ec:	c7 80 4c 40 11 80 00 	movl   $0xcffa00,-0x7feebfb4(%eax)
801074f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074f6:	c7 80 50 40 11 80 ff 	movl   $0xffff,-0x7feebfb0(%eax)
801074fd:	ff 00 00 
80107500:	c7 80 54 40 11 80 00 	movl   $0xcff200,-0x7feebfac(%eax)
80107507:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010750a:	05 30 40 11 80       	add    $0x80114030,%eax
  pd[1] = (uint)p;
8010750f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107513:	c1 e8 10             	shr    $0x10,%eax
80107516:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010751a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010751d:	0f 01 10             	lgdtl  (%eax)
}
80107520:	c9                   	leave  
80107521:	c3                   	ret    
80107522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107530 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107530:	a1 e4 79 11 80       	mov    0x801179e4,%eax
{
80107535:	55                   	push   %ebp
80107536:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107538:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010753d:	0f 22 d8             	mov    %eax,%cr3
}
80107540:	5d                   	pop    %ebp
80107541:	c3                   	ret    
80107542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107550 <switchuvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
80107559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010755c:	85 db                	test   %ebx,%ebx
8010755e:	0f 84 cb 00 00 00    	je     8010762f <switchuvm+0xdf>
  if(p->kstack == 0)
80107564:	8b 43 08             	mov    0x8(%ebx),%eax
80107567:	85 c0                	test   %eax,%eax
80107569:	0f 84 da 00 00 00    	je     80107649 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010756f:	8b 43 04             	mov    0x4(%ebx),%eax
80107572:	85 c0                	test   %eax,%eax
80107574:	0f 84 c2 00 00 00    	je     8010763c <switchuvm+0xec>
  pushcli();
8010757a:	e8 21 d9 ff ff       	call   80104ea0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010757f:	e8 2c c1 ff ff       	call   801036b0 <mycpu>
80107584:	89 c6                	mov    %eax,%esi
80107586:	e8 25 c1 ff ff       	call   801036b0 <mycpu>
8010758b:	89 c7                	mov    %eax,%edi
8010758d:	e8 1e c1 ff ff       	call   801036b0 <mycpu>
80107592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107595:	83 c7 08             	add    $0x8,%edi
80107598:	e8 13 c1 ff ff       	call   801036b0 <mycpu>
8010759d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801075a0:	83 c0 08             	add    $0x8,%eax
801075a3:	ba 67 00 00 00       	mov    $0x67,%edx
801075a8:	c1 e8 18             	shr    $0x18,%eax
801075ab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801075b2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801075b9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801075bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801075c4:	83 c1 08             	add    $0x8,%ecx
801075c7:	c1 e9 10             	shr    $0x10,%ecx
801075ca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801075d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801075d5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801075dc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801075e1:	e8 ca c0 ff ff       	call   801036b0 <mycpu>
801075e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801075ed:	e8 be c0 ff ff       	call   801036b0 <mycpu>
801075f2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801075f6:	8b 73 08             	mov    0x8(%ebx),%esi
801075f9:	e8 b2 c0 ff ff       	call   801036b0 <mycpu>
801075fe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107604:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107607:	e8 a4 c0 ff ff       	call   801036b0 <mycpu>
8010760c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107610:	b8 28 00 00 00       	mov    $0x28,%eax
80107615:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107618:	8b 43 04             	mov    0x4(%ebx),%eax
8010761b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107620:	0f 22 d8             	mov    %eax,%cr3
}
80107623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107626:	5b                   	pop    %ebx
80107627:	5e                   	pop    %esi
80107628:	5f                   	pop    %edi
80107629:	5d                   	pop    %ebp
  popcli();
8010762a:	e9 b1 d8 ff ff       	jmp    80104ee0 <popcli>
    panic("switchuvm: no process");
8010762f:	83 ec 0c             	sub    $0xc,%esp
80107632:	68 7a 85 10 80       	push   $0x8010857a
80107637:	e8 54 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010763c:	83 ec 0c             	sub    $0xc,%esp
8010763f:	68 a5 85 10 80       	push   $0x801085a5
80107644:	e8 47 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107649:	83 ec 0c             	sub    $0xc,%esp
8010764c:	68 90 85 10 80       	push   $0x80108590
80107651:	e8 3a 8d ff ff       	call   80100390 <panic>
80107656:	8d 76 00             	lea    0x0(%esi),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107660 <inituvm>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 1c             	sub    $0x1c,%esp
80107669:	8b 75 10             	mov    0x10(%ebp),%esi
8010766c:	8b 45 08             	mov    0x8(%ebp),%eax
8010766f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107672:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010767b:	77 49                	ja     801076c6 <inituvm+0x66>
  mem = kalloc();
8010767d:	e8 3e ae ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107682:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107685:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107687:	68 00 10 00 00       	push   $0x1000
8010768c:	6a 00                	push   $0x0
8010768e:	50                   	push   %eax
8010768f:	e8 ec d9 ff ff       	call   80105080 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107694:	58                   	pop    %eax
80107695:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010769b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076a0:	5a                   	pop    %edx
801076a1:	6a 06                	push   $0x6
801076a3:	50                   	push   %eax
801076a4:	31 d2                	xor    %edx,%edx
801076a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a9:	e8 c2 fc ff ff       	call   80107370 <mappages>
  memmove(mem, init, sz);
801076ae:	89 75 10             	mov    %esi,0x10(%ebp)
801076b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801076b4:	83 c4 10             	add    $0x10,%esp
801076b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801076ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076bd:	5b                   	pop    %ebx
801076be:	5e                   	pop    %esi
801076bf:	5f                   	pop    %edi
801076c0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801076c1:	e9 6a da ff ff       	jmp    80105130 <memmove>
    panic("inituvm: more than a page");
801076c6:	83 ec 0c             	sub    $0xc,%esp
801076c9:	68 b9 85 10 80       	push   $0x801085b9
801076ce:	e8 bd 8c ff ff       	call   80100390 <panic>
801076d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076e0 <loaduvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801076e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801076f0:	0f 85 91 00 00 00    	jne    80107787 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801076f6:	8b 75 18             	mov    0x18(%ebp),%esi
801076f9:	31 db                	xor    %ebx,%ebx
801076fb:	85 f6                	test   %esi,%esi
801076fd:	75 1a                	jne    80107719 <loaduvm+0x39>
801076ff:	eb 6f                	jmp    80107770 <loaduvm+0x90>
80107701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107708:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010770e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107714:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107717:	76 57                	jbe    80107770 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107719:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771c:	8b 45 08             	mov    0x8(%ebp),%eax
8010771f:	31 c9                	xor    %ecx,%ecx
80107721:	01 da                	add    %ebx,%edx
80107723:	e8 c8 fb ff ff       	call   801072f0 <walkpgdir>
80107728:	85 c0                	test   %eax,%eax
8010772a:	74 4e                	je     8010777a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010772c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010772e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107731:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107736:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010773b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107741:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107744:	01 d9                	add    %ebx,%ecx
80107746:	05 00 00 00 80       	add    $0x80000000,%eax
8010774b:	57                   	push   %edi
8010774c:	51                   	push   %ecx
8010774d:	50                   	push   %eax
8010774e:	ff 75 10             	pushl  0x10(%ebp)
80107751:	e8 0a a2 ff ff       	call   80101960 <readi>
80107756:	83 c4 10             	add    $0x10,%esp
80107759:	39 f8                	cmp    %edi,%eax
8010775b:	74 ab                	je     80107708 <loaduvm+0x28>
}
8010775d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107765:	5b                   	pop    %ebx
80107766:	5e                   	pop    %esi
80107767:	5f                   	pop    %edi
80107768:	5d                   	pop    %ebp
80107769:	c3                   	ret    
8010776a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107773:	31 c0                	xor    %eax,%eax
}
80107775:	5b                   	pop    %ebx
80107776:	5e                   	pop    %esi
80107777:	5f                   	pop    %edi
80107778:	5d                   	pop    %ebp
80107779:	c3                   	ret    
      panic("loaduvm: address should exist");
8010777a:	83 ec 0c             	sub    $0xc,%esp
8010777d:	68 d3 85 10 80       	push   $0x801085d3
80107782:	e8 09 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107787:	83 ec 0c             	sub    $0xc,%esp
8010778a:	68 74 86 10 80       	push   $0x80108674
8010778f:	e8 fc 8b ff ff       	call   80100390 <panic>
80107794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010779a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077a0 <allocuvm>:
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	57                   	push   %edi
801077a4:	56                   	push   %esi
801077a5:	53                   	push   %ebx
801077a6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801077a9:	8b 7d 10             	mov    0x10(%ebp),%edi
801077ac:	85 ff                	test   %edi,%edi
801077ae:	0f 88 8e 00 00 00    	js     80107842 <allocuvm+0xa2>
  if(newsz < oldsz)
801077b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801077b7:	0f 82 93 00 00 00    	jb     80107850 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801077bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801077c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801077c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801077cc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801077cf:	0f 86 7e 00 00 00    	jbe    80107853 <allocuvm+0xb3>
801077d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801077d8:	8b 7d 08             	mov    0x8(%ebp),%edi
801077db:	eb 42                	jmp    8010781f <allocuvm+0x7f>
801077dd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801077e0:	83 ec 04             	sub    $0x4,%esp
801077e3:	68 00 10 00 00       	push   $0x1000
801077e8:	6a 00                	push   $0x0
801077ea:	50                   	push   %eax
801077eb:	e8 90 d8 ff ff       	call   80105080 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801077f0:	58                   	pop    %eax
801077f1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801077f7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077fc:	5a                   	pop    %edx
801077fd:	6a 06                	push   $0x6
801077ff:	50                   	push   %eax
80107800:	89 da                	mov    %ebx,%edx
80107802:	89 f8                	mov    %edi,%eax
80107804:	e8 67 fb ff ff       	call   80107370 <mappages>
80107809:	83 c4 10             	add    $0x10,%esp
8010780c:	85 c0                	test   %eax,%eax
8010780e:	78 50                	js     80107860 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107810:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107816:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107819:	0f 86 81 00 00 00    	jbe    801078a0 <allocuvm+0x100>
    mem = kalloc();
8010781f:	e8 9c ac ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107824:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107826:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107828:	75 b6                	jne    801077e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010782a:	83 ec 0c             	sub    $0xc,%esp
8010782d:	68 f1 85 10 80       	push   $0x801085f1
80107832:	e8 29 8e ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107837:	83 c4 10             	add    $0x10,%esp
8010783a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010783d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107840:	77 6e                	ja     801078b0 <allocuvm+0x110>
}
80107842:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107845:	31 ff                	xor    %edi,%edi
}
80107847:	89 f8                	mov    %edi,%eax
80107849:	5b                   	pop    %ebx
8010784a:	5e                   	pop    %esi
8010784b:	5f                   	pop    %edi
8010784c:	5d                   	pop    %ebp
8010784d:	c3                   	ret    
8010784e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107850:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	89 f8                	mov    %edi,%eax
80107858:	5b                   	pop    %ebx
80107859:	5e                   	pop    %esi
8010785a:	5f                   	pop    %edi
8010785b:	5d                   	pop    %ebp
8010785c:	c3                   	ret    
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	68 09 86 10 80       	push   $0x80108609
80107868:	e8 f3 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010786d:	83 c4 10             	add    $0x10,%esp
80107870:	8b 45 0c             	mov    0xc(%ebp),%eax
80107873:	39 45 10             	cmp    %eax,0x10(%ebp)
80107876:	76 0d                	jbe    80107885 <allocuvm+0xe5>
80107878:	89 c1                	mov    %eax,%ecx
8010787a:	8b 55 10             	mov    0x10(%ebp),%edx
8010787d:	8b 45 08             	mov    0x8(%ebp),%eax
80107880:	e8 7b fb ff ff       	call   80107400 <deallocuvm.part.0>
      kfree(mem);
80107885:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107888:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010788a:	56                   	push   %esi
8010788b:	e8 80 aa ff ff       	call   80102310 <kfree>
      return 0;
80107890:	83 c4 10             	add    $0x10,%esp
}
80107893:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107896:	89 f8                	mov    %edi,%eax
80107898:	5b                   	pop    %ebx
80107899:	5e                   	pop    %esi
8010789a:	5f                   	pop    %edi
8010789b:	5d                   	pop    %ebp
8010789c:	c3                   	ret    
8010789d:	8d 76 00             	lea    0x0(%esi),%esi
801078a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801078a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a6:	5b                   	pop    %ebx
801078a7:	89 f8                	mov    %edi,%eax
801078a9:	5e                   	pop    %esi
801078aa:	5f                   	pop    %edi
801078ab:	5d                   	pop    %ebp
801078ac:	c3                   	ret    
801078ad:	8d 76 00             	lea    0x0(%esi),%esi
801078b0:	89 c1                	mov    %eax,%ecx
801078b2:	8b 55 10             	mov    0x10(%ebp),%edx
801078b5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801078b8:	31 ff                	xor    %edi,%edi
801078ba:	e8 41 fb ff ff       	call   80107400 <deallocuvm.part.0>
801078bf:	eb 92                	jmp    80107853 <allocuvm+0xb3>
801078c1:	eb 0d                	jmp    801078d0 <deallocuvm>
801078c3:	90                   	nop
801078c4:	90                   	nop
801078c5:	90                   	nop
801078c6:	90                   	nop
801078c7:	90                   	nop
801078c8:	90                   	nop
801078c9:	90                   	nop
801078ca:	90                   	nop
801078cb:	90                   	nop
801078cc:	90                   	nop
801078cd:	90                   	nop
801078ce:	90                   	nop
801078cf:	90                   	nop

801078d0 <deallocuvm>:
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801078d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801078d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801078dc:	39 d1                	cmp    %edx,%ecx
801078de:	73 10                	jae    801078f0 <deallocuvm+0x20>
}
801078e0:	5d                   	pop    %ebp
801078e1:	e9 1a fb ff ff       	jmp    80107400 <deallocuvm.part.0>
801078e6:	8d 76 00             	lea    0x0(%esi),%esi
801078e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801078f0:	89 d0                	mov    %edx,%eax
801078f2:	5d                   	pop    %ebp
801078f3:	c3                   	ret    
801078f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107900 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
80107906:	83 ec 0c             	sub    $0xc,%esp
80107909:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010790c:	85 f6                	test   %esi,%esi
8010790e:	74 59                	je     80107969 <freevm+0x69>
80107910:	31 c9                	xor    %ecx,%ecx
80107912:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107917:	89 f0                	mov    %esi,%eax
80107919:	e8 e2 fa ff ff       	call   80107400 <deallocuvm.part.0>
8010791e:	89 f3                	mov    %esi,%ebx
80107920:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107926:	eb 0f                	jmp    80107937 <freevm+0x37>
80107928:	90                   	nop
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107930:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107933:	39 fb                	cmp    %edi,%ebx
80107935:	74 23                	je     8010795a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107937:	8b 03                	mov    (%ebx),%eax
80107939:	a8 01                	test   $0x1,%al
8010793b:	74 f3                	je     80107930 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010793d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107942:	83 ec 0c             	sub    $0xc,%esp
80107945:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107948:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010794d:	50                   	push   %eax
8010794e:	e8 bd a9 ff ff       	call   80102310 <kfree>
80107953:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107956:	39 fb                	cmp    %edi,%ebx
80107958:	75 dd                	jne    80107937 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010795a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010795d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107960:	5b                   	pop    %ebx
80107961:	5e                   	pop    %esi
80107962:	5f                   	pop    %edi
80107963:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107964:	e9 a7 a9 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107969:	83 ec 0c             	sub    $0xc,%esp
8010796c:	68 25 86 10 80       	push   $0x80108625
80107971:	e8 1a 8a ff ff       	call   80100390 <panic>
80107976:	8d 76 00             	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <setupkvm>:
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	56                   	push   %esi
80107984:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107985:	e8 36 ab ff ff       	call   801024c0 <kalloc>
8010798a:	85 c0                	test   %eax,%eax
8010798c:	89 c6                	mov    %eax,%esi
8010798e:	74 42                	je     801079d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107990:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107993:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107998:	68 00 10 00 00       	push   $0x1000
8010799d:	6a 00                	push   $0x0
8010799f:	50                   	push   %eax
801079a0:	e8 db d6 ff ff       	call   80105080 <memset>
801079a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801079a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801079ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801079ae:	83 ec 08             	sub    $0x8,%esp
801079b1:	8b 13                	mov    (%ebx),%edx
801079b3:	ff 73 0c             	pushl  0xc(%ebx)
801079b6:	50                   	push   %eax
801079b7:	29 c1                	sub    %eax,%ecx
801079b9:	89 f0                	mov    %esi,%eax
801079bb:	e8 b0 f9 ff ff       	call   80107370 <mappages>
801079c0:	83 c4 10             	add    $0x10,%esp
801079c3:	85 c0                	test   %eax,%eax
801079c5:	78 19                	js     801079e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079c7:	83 c3 10             	add    $0x10,%ebx
801079ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801079d0:	75 d6                	jne    801079a8 <setupkvm+0x28>
}
801079d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079d5:	89 f0                	mov    %esi,%eax
801079d7:	5b                   	pop    %ebx
801079d8:	5e                   	pop    %esi
801079d9:	5d                   	pop    %ebp
801079da:	c3                   	ret    
801079db:	90                   	nop
801079dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801079e0:	83 ec 0c             	sub    $0xc,%esp
801079e3:	56                   	push   %esi
      return 0;
801079e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801079e6:	e8 15 ff ff ff       	call   80107900 <freevm>
      return 0;
801079eb:	83 c4 10             	add    $0x10,%esp
}
801079ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079f1:	89 f0                	mov    %esi,%eax
801079f3:	5b                   	pop    %ebx
801079f4:	5e                   	pop    %esi
801079f5:	5d                   	pop    %ebp
801079f6:	c3                   	ret    
801079f7:	89 f6                	mov    %esi,%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a00 <kvmalloc>:
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a06:	e8 75 ff ff ff       	call   80107980 <setupkvm>
80107a0b:	a3 e4 79 11 80       	mov    %eax,0x801179e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a10:	05 00 00 00 80       	add    $0x80000000,%eax
80107a15:	0f 22 d8             	mov    %eax,%cr3
}
80107a18:	c9                   	leave  
80107a19:	c3                   	ret    
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a21:	31 c9                	xor    %ecx,%ecx
{
80107a23:	89 e5                	mov    %esp,%ebp
80107a25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a28:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a2e:	e8 bd f8 ff ff       	call   801072f0 <walkpgdir>
  if(pte == 0)
80107a33:	85 c0                	test   %eax,%eax
80107a35:	74 05                	je     80107a3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107a37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a3a:	c9                   	leave  
80107a3b:	c3                   	ret    
    panic("clearpteu");
80107a3c:	83 ec 0c             	sub    $0xc,%esp
80107a3f:	68 36 86 10 80       	push   $0x80108636
80107a44:	e8 47 89 ff ff       	call   80100390 <panic>
80107a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
80107a56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a59:	e8 22 ff ff ff       	call   80107980 <setupkvm>
80107a5e:	85 c0                	test   %eax,%eax
80107a60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a63:	0f 84 9f 00 00 00    	je     80107b08 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a6c:	85 c9                	test   %ecx,%ecx
80107a6e:	0f 84 94 00 00 00    	je     80107b08 <copyuvm+0xb8>
80107a74:	31 ff                	xor    %edi,%edi
80107a76:	eb 4a                	jmp    80107ac2 <copyuvm+0x72>
80107a78:	90                   	nop
80107a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a80:	83 ec 04             	sub    $0x4,%esp
80107a83:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107a89:	68 00 10 00 00       	push   $0x1000
80107a8e:	53                   	push   %ebx
80107a8f:	50                   	push   %eax
80107a90:	e8 9b d6 ff ff       	call   80105130 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a95:	58                   	pop    %eax
80107a96:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107a9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107aa1:	5a                   	pop    %edx
80107aa2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107aa5:	50                   	push   %eax
80107aa6:	89 fa                	mov    %edi,%edx
80107aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107aab:	e8 c0 f8 ff ff       	call   80107370 <mappages>
80107ab0:	83 c4 10             	add    $0x10,%esp
80107ab3:	85 c0                	test   %eax,%eax
80107ab5:	78 61                	js     80107b18 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107ab7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107abd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107ac0:	76 46                	jbe    80107b08 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac5:	31 c9                	xor    %ecx,%ecx
80107ac7:	89 fa                	mov    %edi,%edx
80107ac9:	e8 22 f8 ff ff       	call   801072f0 <walkpgdir>
80107ace:	85 c0                	test   %eax,%eax
80107ad0:	74 61                	je     80107b33 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107ad2:	8b 00                	mov    (%eax),%eax
80107ad4:	a8 01                	test   $0x1,%al
80107ad6:	74 4e                	je     80107b26 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107ad8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107ada:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107adf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107ae8:	e8 d3 a9 ff ff       	call   801024c0 <kalloc>
80107aed:	85 c0                	test   %eax,%eax
80107aef:	89 c6                	mov    %eax,%esi
80107af1:	75 8d                	jne    80107a80 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107af3:	83 ec 0c             	sub    $0xc,%esp
80107af6:	ff 75 e0             	pushl  -0x20(%ebp)
80107af9:	e8 02 fe ff ff       	call   80107900 <freevm>
  return 0;
80107afe:	83 c4 10             	add    $0x10,%esp
80107b01:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b0e:	5b                   	pop    %ebx
80107b0f:	5e                   	pop    %esi
80107b10:	5f                   	pop    %edi
80107b11:	5d                   	pop    %ebp
80107b12:	c3                   	ret    
80107b13:	90                   	nop
80107b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107b18:	83 ec 0c             	sub    $0xc,%esp
80107b1b:	56                   	push   %esi
80107b1c:	e8 ef a7 ff ff       	call   80102310 <kfree>
      goto bad;
80107b21:	83 c4 10             	add    $0x10,%esp
80107b24:	eb cd                	jmp    80107af3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107b26:	83 ec 0c             	sub    $0xc,%esp
80107b29:	68 5a 86 10 80       	push   $0x8010865a
80107b2e:	e8 5d 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107b33:	83 ec 0c             	sub    $0xc,%esp
80107b36:	68 40 86 10 80       	push   $0x80108640
80107b3b:	e8 50 88 ff ff       	call   80100390 <panic>

80107b40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b41:	31 c9                	xor    %ecx,%ecx
{
80107b43:	89 e5                	mov    %esp,%ebp
80107b45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b4e:	e8 9d f7 ff ff       	call   801072f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b53:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b55:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b56:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b5d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b60:	05 00 00 00 80       	add    $0x80000000,%eax
80107b65:	83 fa 05             	cmp    $0x5,%edx
80107b68:	ba 00 00 00 00       	mov    $0x0,%edx
80107b6d:	0f 45 c2             	cmovne %edx,%eax
}
80107b70:	c3                   	ret    
80107b71:	eb 0d                	jmp    80107b80 <copyout>
80107b73:	90                   	nop
80107b74:	90                   	nop
80107b75:	90                   	nop
80107b76:	90                   	nop
80107b77:	90                   	nop
80107b78:	90                   	nop
80107b79:	90                   	nop
80107b7a:	90                   	nop
80107b7b:	90                   	nop
80107b7c:	90                   	nop
80107b7d:	90                   	nop
80107b7e:	90                   	nop
80107b7f:	90                   	nop

80107b80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	57                   	push   %edi
80107b84:	56                   	push   %esi
80107b85:	53                   	push   %ebx
80107b86:	83 ec 1c             	sub    $0x1c,%esp
80107b89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b92:	85 db                	test   %ebx,%ebx
80107b94:	75 40                	jne    80107bd6 <copyout+0x56>
80107b96:	eb 70                	jmp    80107c08 <copyout+0x88>
80107b98:	90                   	nop
80107b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ba3:	89 f1                	mov    %esi,%ecx
80107ba5:	29 d1                	sub    %edx,%ecx
80107ba7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107bad:	39 d9                	cmp    %ebx,%ecx
80107baf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107bb2:	29 f2                	sub    %esi,%edx
80107bb4:	83 ec 04             	sub    $0x4,%esp
80107bb7:	01 d0                	add    %edx,%eax
80107bb9:	51                   	push   %ecx
80107bba:	57                   	push   %edi
80107bbb:	50                   	push   %eax
80107bbc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107bbf:	e8 6c d5 ff ff       	call   80105130 <memmove>
    len -= n;
    buf += n;
80107bc4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107bc7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107bca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107bd0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107bd2:	29 cb                	sub    %ecx,%ebx
80107bd4:	74 32                	je     80107c08 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107bd6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107bd8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107bdb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107bde:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107be4:	56                   	push   %esi
80107be5:	ff 75 08             	pushl  0x8(%ebp)
80107be8:	e8 53 ff ff ff       	call   80107b40 <uva2ka>
    if(pa0 == 0)
80107bed:	83 c4 10             	add    $0x10,%esp
80107bf0:	85 c0                	test   %eax,%eax
80107bf2:	75 ac                	jne    80107ba0 <copyout+0x20>
  }
  return 0;
}
80107bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bfc:	5b                   	pop    %ebx
80107bfd:	5e                   	pop    %esi
80107bfe:	5f                   	pop    %edi
80107bff:	5d                   	pop    %ebp
80107c00:	c3                   	ret    
80107c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c0b:	31 c0                	xor    %eax,%eax
}
80107c0d:	5b                   	pop    %ebx
80107c0e:	5e                   	pop    %esi
80107c0f:	5f                   	pop    %edi
80107c10:	5d                   	pop    %ebp
80107c11:	c3                   	ret    
