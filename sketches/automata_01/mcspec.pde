// integer machine //
/*
00 -> exit
 11 -> B=M[PC+1]
 20 -> print A
 21 -> print B
 99 -> PC=M[PC+1]-1 if B==0 (JBZ)
 98 -> PC=M[PC+1]-1 if B!=0 (JBNZ)
 80 -> A--
 81 -> B--
 77 -> D[X][Y]=M[PC+1]; putpixel
 70 -> X=M[PC+1]
 71 -> Y=M[PC+1]
 72 -> X=A
 73 -> Y=A
 74 -> X=B
 75 -> Y=B
 78 -> D[*][*]=0; clear screen
 60 -> line(A,B,X,Y)
 30 -> 
 */
