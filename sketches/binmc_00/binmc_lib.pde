import java.util.Timer;
import java.util.TimerTask;
import java.io.*;

public class Adder8b{
  boolean a0,a1,a2,a3,a4,a5,a6,a7;
  boolean b0,b1,b2,b3,b4,b5,b6,b7;
  boolean s0,s1,s2,s3,s4,s5,s6,s7;
  boolean co,ci;
  FullAdder fa0,fa1,fa2,fa3,fa4,fa5,fa6,fa7;
  
  Adder8b(){
    fa0=new FullAdder();
    fa1=new FullAdder();
    fa2=new FullAdder();
    fa3=new FullAdder();
    fa4=new FullAdder();
    fa5=new FullAdder();
    fa6=new FullAdder();
    fa7=new FullAdder();
  }
  
  void feed(byte a0,byte a1,byte a2,byte a3,byte a4,byte a5,byte a6,byte a7,
            byte b0,byte b1,byte b2,byte b3,byte b4,byte b5,byte b6,byte b7,
            byte ci){
    feed(a0==0?false:true,a1==0?false:true,a2==0?false:true,a3==0?false:true,a4==0?false:true,a5==0?false:true,a6==0?false:true,a7==0?false:true,
         b0==0?false:true,b1==0?false:true,b2==0?false:true,b3==0?false:true,b4==0?false:true,b5==0?false:true,b6==0?false:true,b7==0?false:true,
         ci==0?false:true);
  }
  
  void feed(boolean a0,boolean a1,boolean a2,boolean a3,boolean a4,boolean a5,boolean a6,boolean a7,
            boolean b0,boolean b1,boolean b2,boolean b3,boolean b4,boolean b5,boolean b6,boolean b7,
            boolean ci){
    this.a0=a0;
    this.a1=a1;
    this.a2=a2;
    this.a3=a3;
    this.a4=a4;
    this.a5=a5;
    this.a6=a6;
    this.a7=a7;
    this.b0=b0;
    this.b1=b1;
    this.b2=b2;
    this.b3=b3;
    this.b4=b4;
    this.b5=b5;
    this.b6=b6;
    this.b7=b7;
    this.ci=ci;
    add();
  }
  
  void add(){
    fa0.feed(a0,b0,ci);
    s0=fa0.s;
    fa1.feed(a1,b1,fa0.co);
    s1=fa1.s;
    fa2.feed(a2,b2,fa1.co);
    s2=fa2.s;
    fa3.feed(a3,b3,fa2.co);
    s3=fa3.s;
    fa4.feed(a4,b4,fa3.co);
    s4=fa4.s;
    fa5.feed(a5,b5,fa4.co);
    s5=fa5.s;
    fa6.feed(a6,b6,fa5.co);
    s6=fa6.s;
    fa7.feed(a7,b7,fa6.co);
    s7=fa7.s;
    co=fa7.co;
  }
  
  void display(){
    System.out.printf("%d %d %d %d %d %d %d %d\n",s7?1:0,s6?1:0,s5?1:0,s4?1:0,s3?1:0,s2?1:0,s1?1:0,s0?1:0);
  }
}
public interface ControlPanel{
  void feeddata(String addr,String w,String di);
  String collectdata();
}

public class Ctr4b extends TimerTask
{
  long T;
  volatile boolean clk;
  DFlipFlop f1, f2, f3;

  public Ctr4b(long millis)
  {
    T = millis;
    clk = false;
    f1 = new DFlipFlop();
    f2 = new DFlipFlop();
    f3 = new DFlipFlop();
  }

  public void run()
  {
    clk = !clk;
    f1.setClk(clk);
    f2.setClk(!f1.q);
    f3.setClk(!f2.q);
    System.out.println((f3.q?"1":"0") + (f2.q?"1":"0") + (f1.q?"1":"0") + (!clk?"1":"0"));
  }
}

public class Ctr extends TimerTask
{
  long T;
  volatile boolean clk;
  DFlipFlop bit;

  public Ctr(long millis)
  {
    T = millis;
    clk = false;
    bit = new DFlipFlop();
  }

  public void run()
  {
    clk = !clk;
    bit.setClk(clk);
    System.out.println((bit.q?"1":"0") + (!clk?"1":"0"));
  }
}

public class Decoder1to2{
  boolean s0;
  boolean di;
  boolean o1,o0;
  
  public Decoder1to2(){}
  
  void feed(boolean s0,boolean dit){
    this.s0=s0;
    boolean ns0=!s0;
    di=dit;
    o0=di&ns0;
    o1=di& s0;
  }
  
  void feed(String s,String d){
    if(s.length()!=1 || d.length()!=1){
      throw new RuntimeException("illegal length of s or d!");
    }
    feed(s.charAt(0)=='0'?false:true,
        d.charAt(0)=='0'?false:true);
  }
  
  void display(){
    System.out.println("D1x2 -> "+Functions.bitseq(new boolean[]{o1,o0}));
  }
  
}
public class Decoder2to4{
  boolean s1,s0;
  boolean di;
  boolean o3,o2,o1,o0;
  
  public Decoder2to4(){}
  
  void feed(boolean s1,boolean s0,boolean dit){
    this.s1=s1;this.s0=s0;
    boolean ns0=!s0;
    boolean ns1=!s1;
    di=dit;
    o0=di&ns1&ns0;
    o1=di&ns1& s0;
    o2=di& s1&ns0;
    o3=di& s1& s0;
  }
  
  void feed(String s,String d){
    if(s.length()!=2 || d.length()!=1){
      throw new RuntimeException("illegal length of s or d!");
    }
    feed(s.charAt(0)=='0'?false:true,
        s.charAt(1)=='0'?false:true,
        d.charAt(0)=='0'?false:true);
  }
  
  void display(){
    System.out.println("D2x4 -> "+Functions.bitseq(new boolean[]{o3,o2,o1,o0}));
  }
}
public class Decoder3to8{
  boolean s2,s1,s0;
  boolean di;
  boolean o7,o6,o5,o4,o3,o2,o1,o0;
  
  public Decoder3to8(){}
  
  void feed(boolean s2,boolean s1,boolean s0,boolean dit){
    this.s2=s2;this.s1=s1;this.s0=s0;
    boolean ns0=!s0;
    boolean ns1=!s1;
    boolean ns2=!s2;
    di=dit;
    o0=di&ns2&ns1&ns0;
    o1=di&ns2&ns1& s0;
    o2=di&ns2& s1&ns0;
    o3=di&ns2& s1& s0;
    o4=di& s2&ns1&ns0;
    o5=di& s2&ns1& s0;
    o6=di& s2& s1&ns0;
    o7=di& s2& s1& s0;
  }
  
  void feed(String s,String d){
    if(s.length()!=3 || d.length()!=1){
      throw new RuntimeException("illegal length of s or d!");
    }
    feed(s.charAt(0)=='0'?false:true,
        s.charAt(1)=='0'?false:true,
        s.charAt(2)=='0'?false:true,
        d.charAt(0)=='0'?false:true);
  }
  
  void display(){
    System.out.println("D3x8 -> "+Functions.bitseq(new boolean[]{o7,o6,o5,o4,o3,o2,o1,o0}));
  }
  
}
public class DFlipFlop{
  boolean clk,d,q; // d->DI, q->DO, clk->w

  public DFlipFlop() {
    clk=d=q=false;
  }

  public void setClk(boolean v){
    // modeling d-type flip flop requires advanced math modeling
    // and there are atleast a couple of papers on this
    // hacking this from truth table for now
    clk=v;
    if(clk){
      q=d;
    }
  }
  
  // trigger to write
  void w(boolean f){
    d=f;
    setClk(true);setClk(false);
  }
  
  void w(int f){
    w(f==0?false:true);
  }
  
  void display(){
    System.out.printf("[%s\n]",this);
  }
  
  public String toString(){
    return String.format("%s",q?"1":"0");
  }
  
  void truth(){
    System.out.println("D Clk Q Q-bar");
    System.out.println("-------------");
    d=false;setClk(true);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=true;setClk(true);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=false;setClk(false);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=true;setClk(false);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=false;setClk(true);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
  }
  
}
public class DFlipFlopOsc{
  boolean clk,d,q; // d->DI, q->DO

  public DFlipFlopOsc() {
    clk=d=q=false;
  }

  public void setClk(boolean v){
    boolean oldv=clk;
    clk=v;
    if(!oldv && v){
      q=d;
      d=!q;
    }
  }
  
  void truth(){
    System.out.println("D Clk Q Q-bar");
    System.out.println("-------------");
    d=false;setClk(true);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=true;setClk(true);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=false;setClk(false);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
    d=true;setClk(false);
    System.out.printf("%d %d   %d %d\n",d?1:0,clk?1:0,q?1:0,q?0:1);
  }
}
public class FullAdder{
  boolean ci,a,b;
  boolean s,co;
  HalfAdder ha1,ha2;
  
  FullAdder(){
    ha1=new HalfAdder();
    ha2=new HalfAdder();
  }
  
  void add(){
    ha1.feed(a,b);
    ha2.feed(ci,ha1.s);
    s=ha2.s;
    co=ha2.co|ha1.co;
  }
  
  void feed(int a,int b,int cin){
    feed(a==0?false:true,b==0?false:true,cin==0?false:true);
  }
  
  void feed(boolean a,boolean b,boolean cin){
    ci=cin;
    this.a=a;
    this.b=b;
    add();
  }
  
  void display(){
    System.out.printf("%d %d %d %d %d\n",a?1:0,b?1:0,ci?1:0,s?1:0,co?1:0);
  }
  
}
public static class Functions{
  
  static String bitseq(boolean[] x){
    StringBuffer sb=new StringBuffer();
    for(int i=0;i<x.length;i++){
      sb.append(x[i]?"1":"0");
    }
    return sb.toString();
  }
  
}
public class HalfAdder{
  boolean a,b;
  boolean s,co;
  
  boolean xor(boolean x,boolean y){
    return (x|y)&(!(x&y));
  }
  
  void add(){
    s=xor(a,b);// xor
    co=a&b;
  }
  
  void feed(int a,int b){
    feed(a==0?false:true,b==0?false:true);
  }
  
  void feed(boolean a,boolean b){
    this.a=a;
    this.b=b;
    add();
  }
  
  void display(){
    System.out.printf("%d %d %d %d\n",a?1:0,b?1:0,s?1:0,co?1:0);
  }
  
}
public class Latch8b{
  boolean clk;
  DFlipFlop dq0,dq1,dq2,dq3,dq4,dq5,dq6,dq7;
  
  public Latch8b(){
    dq0=new DFlipFlop();
    dq1=new DFlipFlop();
    dq2=new DFlipFlop();
    dq3=new DFlipFlop();
    dq4=new DFlipFlop();
    dq5=new DFlipFlop();
    dq6=new DFlipFlop();
    dq7=new DFlipFlop();
  }
  
  void feed(int clk,
            int d7,int d6,int d5,int d4,int d3,int d2,int d1,int d0){
    feed(clk==0?false:true,
         d7==0?false:true,d6==0?false:true,d5==0?false:true,d4==0?false:true,d3==0?false:true,d2==0?false:true,d1==0?false:true,d0==0?false:true);
  }
  
  void feed(boolean clk,
            boolean d7,boolean d6,boolean d5,boolean d4,boolean d3,boolean d2,boolean d1,boolean d0){
    if(clk){
      dq0.w(d0);
      dq1.w(d1);
      dq2.w(d2);
      dq3.w(d3);
      dq4.w(d4);
      dq5.w(d5);
      dq6.w(d6);
      dq7.w(d7);
    }
  }
  
  void display(){
    System.out.println("L8b -> "+dq7+dq6+dq5+dq4+dq3+dq2+dq1+dq0);
  }
  
}
public class RAM1024x8{
  boolean a9,a8,a7,a6,a5,a4,a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder2to4 wd;
  Decoder2to4 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector4to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM256x8 r0,r1,r2,r3;
  
  RAM1024x8(){
    r0=new RAM256x8();
    r1=new RAM256x8();
    r2=new RAM256x8();
    r3=new RAM256x8();
    wd=new Decoder2to4();
    d7=new Decoder2to4();
    d6=new Decoder2to4();
    d5=new Decoder2to4();
    d4=new Decoder2to4();
    d3=new Decoder2to4();
    d2=new Decoder2to4();
    d1=new Decoder2to4();
    d0=new Decoder2to4();
    s7=new Selector4to1();
    s6=new Selector4to1();
    s5=new Selector4to1();
    s4=new Selector4to1();
    s3=new Selector4to1();
    s2=new Selector4to1();
    s1=new Selector4to1();
    s0=new Selector4to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void feed(boolean a9,boolean a8,boolean a7,boolean a6,boolean a5,boolean a4,boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a9=a9;this.a8=a8;this.a7=a7;this.a6=a6;this.a5=a5;
    this.a4=a4;this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a9,a8,di7);
    d6.feed(a9,a8,di6);
    d5.feed(a9,a8,di5);
    d4.feed(a9,a8,di4);
    d3.feed(a9,a8,di3);
    d2.feed(a9,a8,di2);
    d1.feed(a9,a8,di1);
    d0.feed(a9,a8,di0);
    wd.feed(a9,a8,w);
    // feed 4 256x8 RAMs
    r0.feed(a7,a6,a5,a4,a3,a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a7,a6,a5,a4,a3,a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    r2.feed(a7,a6,a5,a4,a3,a2,a1,a0,wd.o2,d7.o2,d6.o2,d5.o2,d4.o2,d3.o2,d2.o2,d1.o2,d0.o2);
    r3.feed(a7,a6,a5,a4,a3,a2,a1,a0,wd.o3,d7.o3,d6.o3,d5.o3,d4.o3,d3.o3,d2.o3,d1.o3,d0.o3);
    // selection
    s7.feed(a9,a8,r3.do7,r2.do7,r1.do7,r0.do7);
    s6.feed(a9,a8,r3.do6,r2.do6,r1.do6,r0.do6);
    s5.feed(a9,a8,r3.do5,r2.do5,r1.do5,r0.do5);
    s4.feed(a9,a8,r3.do4,r2.do4,r1.do4,r0.do4);
    s3.feed(a9,a8,r3.do3,r2.do3,r1.do3,r0.do3);
    s2.feed(a9,a8,r3.do2,r2.do2,r1.do2,r0.do2);
    s1.feed(a9,a8,r3.do1,r2.do1,r1.do1,r0.do1);
    s0.feed(a9,a8,r3.do0,r2.do0,r1.do0,r0.do0);
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=10 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,addr.charAt(4)=='0'?false:true,
          addr.charAt(5)=='0'?false:true,addr.charAt(6)=='0'?false:true,addr.charAt(7)=='0'?false:true,addr.charAt(8)=='0'?false:true,addr.charAt(9)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    r2.display();
    r3.display();
    //System.out.println("------------");
  }
  
}

public class RAM16BShell implements ControlPanel{
  RAM16x8 ram;
  BufferedReader br;

  RAM16BShell(){
    ram=new RAM16x8();
    InputStreamReader isr=new InputStreamReader(System.in);
    br=new BufferedReader(isr);
  }
  
  public void feeddata(String addr,String w,String di){
    ram.feed(addr,w,di);
  }
  
  public String collectdata(){
    return (ram.do7?"1":"0")+(ram.do6?"1":"0")+(ram.do5?"1":"0")+(ram.do4?"1":"0")
          +(ram.do3?"1":"0")+(ram.do2?"1":"0")+(ram.do1?"1":"0")+(ram.do0?"1":"0");
  }
  
  void repl() {
    try{
      for(;;){
        System.out.print("[RAM_16B]> ");
        String instr=br.readLine();
        String[] parts=instr.split(" ");
        String cmd=parts[0];
        if(cmd.equalsIgnoreCase("exit") || cmd.equalsIgnoreCase("quit") || cmd.equalsIgnoreCase("x") || cmd.equalsIgnoreCase("q")){
          break;
        }
        if(cmd.equalsIgnoreCase("r")){
          String addr=parts[1];
          feeddata(addr,"0","00000000");
          System.out.println(collectdata());
        }else if(cmd.equalsIgnoreCase("w")){
          String addr=parts[1];
          String dat=parts[2];
          feeddata(addr,"1",dat);
          System.out.println(collectdata());
        }else if(cmd.equalsIgnoreCase("d")){
          ram.display();
        }else{
          System.out.println("[ERR] unknown command!");
        }
      }
    }catch(IOException ioe){
      System.err.println("IO exception: "+ioe.getMessage());
    }
  }
  
}

public class RAM16x1{
  boolean a3,a2,a1,a0;
  boolean din,dout;
  boolean w;
  Decoder1to2 dec;
  RAM8x1 r0,r1;
  Selector2to1 sel;
  
  public RAM16x1(){
    dec=new Decoder1to2();
    r0=new RAM8x1();
    r1=new RAM8x1();
    sel=new Selector2to1();
  }
  
  void feed(boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,boolean di){
    this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.din=di;this.w=w;
    dec.feed(a3,di);
    r0.feed(a2,a1,a0,w&!a3,dec.o0);
    r1.feed(a2,a1,a0,w&a3,dec.o1);
    sel.feed(a3,r1.dout,r0.dout);
    dout=sel.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=4 || w.length()!=1 || di.length()!=1){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,
          w.charAt(0)=='0'?false:true,di.charAt(0)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("-----");
    r0.display();
    r1.display();
    //System.out.println("-----");
  }
  
}
public class RAM16x8{
  boolean a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder1to2 wd;
  Decoder1to2 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector2to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM8x8 r1,r0;
  
  RAM16x8(){
    r0=new RAM8x8();
    r1=new RAM8x8();
    wd=new Decoder1to2();
    d7=new Decoder1to2();
    d6=new Decoder1to2();
    d5=new Decoder1to2();
    d4=new Decoder1to2();
    d3=new Decoder1to2();
    d2=new Decoder1to2();
    d1=new Decoder1to2();
    d0=new Decoder1to2();
    s7=new Selector2to1();
    s6=new Selector2to1();
    s5=new Selector2to1();
    s4=new Selector2to1();
    s3=new Selector2to1();
    s2=new Selector2to1();
    s1=new Selector2to1();
    s0=new Selector2to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void displaySelectorStage(){
    s7.display();
    s6.display();
    s5.display();
    s4.display();
    s3.display();
    s2.display();
    s1.display();
    s0.display();
  }
  
  void feed(boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a3,di7);
    d6.feed(a3,di6);
    d5.feed(a3,di5);
    d4.feed(a3,di4);
    d3.feed(a3,di3);
    d2.feed(a3,di2);
    d1.feed(a3,di1);
    d0.feed(a3,di0);
    wd.feed(a3,w);
    //displayDecoderStage();
    r0.feed(a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    s7.feed(a3,r1.do7,r0.do7);
    s6.feed(a3,r1.do6,r0.do6);
    s5.feed(a3,r1.do5,r0.do5);
    s4.feed(a3,r1.do4,r0.do4);
    s3.feed(a3,r1.do3,r0.do3);
    s2.feed(a3,r1.do2,r0.do2);
    s1.feed(a3,r1.do1,r0.do1);
    s0.feed(a3,r1.do0,r0.do0);
    //displaySelectorStage();
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=4 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    //System.out.println("------------");
  }
  
}
public class RAM256x8{
  boolean a7,a6,a5,a4,a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder2to4 wd;
  Decoder2to4 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector4to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM64x8 r0,r1,r2,r3;
  
  RAM256x8(){
    r0=new RAM64x8();
    r1=new RAM64x8();
    r2=new RAM64x8();
    r3=new RAM64x8();
    wd=new Decoder2to4();
    d7=new Decoder2to4();
    d6=new Decoder2to4();
    d5=new Decoder2to4();
    d4=new Decoder2to4();
    d3=new Decoder2to4();
    d2=new Decoder2to4();
    d1=new Decoder2to4();
    d0=new Decoder2to4();
    s7=new Selector4to1();
    s6=new Selector4to1();
    s5=new Selector4to1();
    s4=new Selector4to1();
    s3=new Selector4to1();
    s2=new Selector4to1();
    s1=new Selector4to1();
    s0=new Selector4to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void feed(boolean a7,boolean a6,boolean a5,boolean a4,boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a7=a7;this.a6=a6;this.a5=a5;this.a4=a4;
    this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a7,a6,di7);
    d6.feed(a7,a6,di6);
    d5.feed(a7,a6,di5);
    d4.feed(a7,a6,di4);
    d3.feed(a7,a6,di3);
    d2.feed(a7,a6,di2);
    d1.feed(a7,a6,di1);
    d0.feed(a7,a6,di0);
    wd.feed(a7,a6,w);
    // feed 4 64x8 RAMs
    r0.feed(a5,a4,a3,a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a5,a4,a3,a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    r2.feed(a5,a4,a3,a2,a1,a0,wd.o2,d7.o2,d6.o2,d5.o2,d4.o2,d3.o2,d2.o2,d1.o2,d0.o2);
    r3.feed(a5,a4,a3,a2,a1,a0,wd.o3,d7.o3,d6.o3,d5.o3,d4.o3,d3.o3,d2.o3,d1.o3,d0.o3);
    // selection
    s7.feed(a7,a6,r3.do7,r2.do7,r1.do7,r0.do7);
    s6.feed(a7,a6,r3.do6,r2.do6,r1.do6,r0.do6);
    s5.feed(a7,a6,r3.do5,r2.do5,r1.do5,r0.do5);
    s4.feed(a7,a6,r3.do4,r2.do4,r1.do4,r0.do4);
    s3.feed(a7,a6,r3.do3,r2.do3,r1.do3,r0.do3);
    s2.feed(a7,a6,r3.do2,r2.do2,r1.do2,r0.do2);
    s1.feed(a7,a6,r3.do1,r2.do1,r1.do1,r0.do1);
    s0.feed(a7,a6,r3.do0,r2.do0,r1.do0,r0.do0);
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=8 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,
          addr.charAt(4)=='0'?false:true,addr.charAt(5)=='0'?false:true,addr.charAt(6)=='0'?false:true,addr.charAt(7)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    r2.display();
    r3.display();
    //System.out.println("------------");
  }
  
}

public class RAM64KBShell implements ControlPanel{
  RAM65536x8 ram;
  BufferedReader br;

  RAM64KBShell(){
    ram=new RAM65536x8();
    InputStreamReader isr=new InputStreamReader(System.in);
    br=new BufferedReader(isr);
  }

  public void feeddata(String addr,String w,String di){
    if(addr.length()!=16 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("[ERR] bit length not proper!");
    }
    ram.feed(addr,w,di);
  }
  
  public String collectdata(){
    return (ram.do7?"1":"0")+(ram.do6?"1":"0")+(ram.do5?"1":"0")+(ram.do4?"1":"0")
          +(ram.do3?"1":"0")+(ram.do2?"1":"0")+(ram.do1?"1":"0")+(ram.do0?"1":"0");
  }
  
  void repl() {
    try{
      for(;;){
        System.out.print("[RAM_64KB]> ");
        String instr=br.readLine();
        String[] parts=instr.split(" ");
        String cmd=parts[0];
        if(cmd.equalsIgnoreCase("exit") || cmd.equalsIgnoreCase("quit") || cmd.equalsIgnoreCase("x") || cmd.equalsIgnoreCase("q")){
          break;
        }
        if(cmd.equalsIgnoreCase("r")){
          String addr=parts[1];
          try{
            feeddata(addr,"0","00000000");
            System.out.println(collectdata());
          }catch(Exception e){
            System.err.println(e.getMessage());
          }
        }else if(cmd.equalsIgnoreCase("w")){
          String addr=parts[1];
          String dat=parts[2];
          try{
            feeddata(addr,"1",dat);
            System.out.println(collectdata());
          }catch(Exception e){
            System.err.println(e.getMessage());
          }
        }else{
          System.out.println("[ERR] unknown command!");
        }
      }
    }catch(IOException ioe){
      System.err.println("IO exception: "+ioe.getMessage());
    }
  }
  
}

public class RAM64x8{
  boolean a5,a4,a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder2to4 wd;
  Decoder2to4 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector4to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM16x8 r3,r2,r1,r0;
  
  RAM64x8(){
    r0=new RAM16x8();
    r1=new RAM16x8();
    r2=new RAM16x8();
    r3=new RAM16x8();
    wd=new Decoder2to4();
    d7=new Decoder2to4();
    d6=new Decoder2to4();
    d5=new Decoder2to4();
    d4=new Decoder2to4();
    d3=new Decoder2to4();
    d2=new Decoder2to4();
    d1=new Decoder2to4();
    d0=new Decoder2to4();
    s7=new Selector4to1();
    s6=new Selector4to1();
    s5=new Selector4to1();
    s4=new Selector4to1();
    s3=new Selector4to1();
    s2=new Selector4to1();
    s1=new Selector4to1();
    s0=new Selector4to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void feed(boolean a5,boolean a4,boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a5=a5;this.a4=a4;this.a3=a3;
    this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a5,a4,di7);
    d6.feed(a5,a4,di6);
    d5.feed(a5,a4,di5);
    d4.feed(a5,a4,di4);
    d3.feed(a5,a4,di3);
    d2.feed(a5,a4,di2);
    d1.feed(a5,a4,di1);
    d0.feed(a5,a4,di0);
    // decode write bit
    wd.feed(a5,a4,w);
    // feed 4 16x8 RAMs
    r0.feed(a3,a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a3,a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    r2.feed(a3,a2,a1,a0,wd.o2,d7.o2,d6.o2,d5.o2,d4.o2,d3.o2,d2.o2,d1.o2,d0.o2);
    r3.feed(a3,a2,a1,a0,wd.o3,d7.o3,d6.o3,d5.o3,d4.o3,d3.o3,d2.o3,d1.o3,d0.o3);
    // selections
    s7.feed(a5,a4,r3.do7,r2.do7,r1.do7,r0.do7);
    s6.feed(a5,a4,r3.do6,r2.do6,r1.do6,r0.do6);
    s5.feed(a5,a4,r3.do5,r2.do5,r1.do5,r0.do5);
    s4.feed(a5,a4,r3.do4,r2.do4,r1.do4,r0.do4);
    s3.feed(a5,a4,r3.do3,r2.do3,r1.do3,r0.do3);
    s2.feed(a5,a4,r3.do2,r2.do2,r1.do2,r0.do2);
    s1.feed(a5,a4,r3.do1,r2.do1,r1.do1,r0.do1);
    s0.feed(a5,a4,r3.do0,r2.do0,r1.do0,r0.do0);
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=6 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,
          addr.charAt(3)=='0'?false:true,addr.charAt(4)=='0'?false:true,addr.charAt(5)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    r2.display();
    r3.display();
    //System.out.println("------------");
  }
  
}
public class RAM65536x8{
  boolean a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder3to8 wd;
  Decoder3to8 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector8to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM8192x8 r0,r1,r2,r3,r4,r5,r6,r7;
  
  RAM65536x8(){
    r0=new RAM8192x8();
    r1=new RAM8192x8();
    r2=new RAM8192x8();
    r3=new RAM8192x8();
    r4=new RAM8192x8();
    r5=new RAM8192x8();
    r6=new RAM8192x8();
    r7=new RAM8192x8();
    wd=new Decoder3to8();
    d7=new Decoder3to8();
    d6=new Decoder3to8();
    d5=new Decoder3to8();
    d4=new Decoder3to8();
    d3=new Decoder3to8();
    d2=new Decoder3to8();
    d1=new Decoder3to8();
    d0=new Decoder3to8();
    s7=new Selector8to1();
    s6=new Selector8to1();
    s5=new Selector8to1();
    s4=new Selector8to1();
    s3=new Selector8to1();
    s2=new Selector8to1();
    s1=new Selector8to1();
    s0=new Selector8to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void feed(boolean a15,boolean a14,boolean a13,boolean a12,boolean a11,boolean a10,boolean a9,boolean a8,boolean a7,boolean a6,boolean a5,boolean a4,boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a15=a15;this.a14=a14;this.a13=a13;
    this.a12=a12;this.a11=a11;this.a10=a10;
    this.a9=a9;this.a8=a8;this.a7=a7;this.a6=a6;this.a5=a5;
    this.a4=a4;this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a15,a14,a13,di7);
    d6.feed(a15,a14,a13,di6);
    d5.feed(a15,a14,a13,di5);
    d4.feed(a15,a14,a13,di4);
    d3.feed(a15,a14,a13,di3);
    d2.feed(a15,a14,a13,di2);
    d1.feed(a15,a14,a13,di1);
    d0.feed(a15,a14,a13,di0);
    wd.feed(a15,a14,a13,w);
    // feed 8 8192x8 RAMs
    r0.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    r2.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o2,d7.o2,d6.o2,d5.o2,d4.o2,d3.o2,d2.o2,d1.o2,d0.o2);
    r3.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o3,d7.o3,d6.o3,d5.o3,d4.o3,d3.o3,d2.o3,d1.o3,d0.o3);
    r4.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o4,d7.o4,d6.o4,d5.o4,d4.o4,d3.o4,d2.o4,d1.o4,d0.o4);
    r5.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o5,d7.o5,d6.o5,d5.o5,d4.o5,d3.o5,d2.o5,d1.o5,d0.o5);
    r6.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o6,d7.o6,d6.o6,d5.o6,d4.o6,d3.o6,d2.o6,d1.o6,d0.o6);
    r7.feed(a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o7,d7.o7,d6.o7,d5.o7,d4.o7,d3.o7,d2.o7,d1.o7,d0.o7);
    // selection
    s7.feed(a15,a14,a13,r7.do7,r6.do7,r5.do7,r4.do7,r3.do7,r2.do7,r1.do7,r0.do7);
    s6.feed(a15,a14,a13,r7.do6,r6.do6,r5.do6,r4.do6,r3.do6,r2.do6,r1.do6,r0.do6);
    s5.feed(a15,a14,a13,r7.do5,r6.do5,r5.do5,r4.do5,r3.do5,r2.do5,r1.do5,r0.do5);
    s4.feed(a15,a14,a13,r7.do4,r6.do4,r5.do4,r4.do4,r3.do4,r2.do4,r1.do4,r0.do4);
    s3.feed(a15,a14,a13,r7.do3,r6.do3,r5.do3,r4.do3,r3.do3,r2.do3,r1.do3,r0.do3);
    s2.feed(a15,a14,a13,r7.do2,r6.do2,r5.do2,r4.do2,r3.do2,r2.do2,r1.do2,r0.do2);
    s1.feed(a15,a14,a13,r7.do1,r6.do1,r5.do1,r4.do1,r3.do1,r2.do1,r1.do1,r0.do1);
    s0.feed(a15,a14,a13,r7.do0,r6.do0,r5.do0,r4.do0,r3.do0,r2.do0,r1.do0,r0.do0);
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=16 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,addr.charAt(4)=='0'?false:true,
          addr.charAt(5)=='0'?false:true,addr.charAt(6)=='0'?false:true,addr.charAt(7)=='0'?false:true,addr.charAt(8)=='0'?false:true,addr.charAt(9)=='0'?false:true,
          addr.charAt(10)=='0'?false:true,addr.charAt(11)=='0'?false:true,addr.charAt(12)=='0'?false:true,
          addr.charAt(13)=='0'?false:true,addr.charAt(14)=='0'?false:true,addr.charAt(15)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    r2.display();
    r3.display();
    r4.display();
    r5.display();
    r6.display();
    r7.display();
    //System.out.println("------------");
  }
  
}
public class RAM8192x8{
  boolean a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  Decoder3to8 wd;
  Decoder3to8 d7,d6,d5,d4,d3,d2,d1,d0;
  Selector8to1 s7,s6,s5,s4,s3,s2,s1,s0;
  RAM1024x8 r0,r1,r2,r3,r4,r5,r6,r7;
  
  RAM8192x8(){
    r0=new RAM1024x8();
    r1=new RAM1024x8();
    r2=new RAM1024x8();
    r3=new RAM1024x8();
    r4=new RAM1024x8();
    r5=new RAM1024x8();
    r6=new RAM1024x8();
    r7=new RAM1024x8();
    wd=new Decoder3to8();
    d7=new Decoder3to8();
    d6=new Decoder3to8();
    d5=new Decoder3to8();
    d4=new Decoder3to8();
    d3=new Decoder3to8();
    d2=new Decoder3to8();
    d1=new Decoder3to8();
    d0=new Decoder3to8();
    s7=new Selector8to1();
    s6=new Selector8to1();
    s5=new Selector8to1();
    s4=new Selector8to1();
    s3=new Selector8to1();
    s2=new Selector8to1();
    s1=new Selector8to1();
    s0=new Selector8to1();
  }
  
  void displayDecoderStage(){
    // debugging
    d7.display();
    d6.display();
    d5.display();
    d4.display();
    d3.display();
    d2.display();
    d1.display();
    d0.display();
  }
  
  void feed(boolean a12,boolean a11,boolean a10,boolean a9,boolean a8,boolean a7,boolean a6,boolean a5,boolean a4,boolean a3,boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a12=a12;this.a11=a11;this.a10=a10;
    this.a9=a9;this.a8=a8;this.a7=a7;this.a6=a6;this.a5=a5;
    this.a4=a4;this.a3=a3;this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    d7.feed(a12,a11,a10,di7);
    d6.feed(a12,a11,a10,di6);
    d5.feed(a12,a11,a10,di5);
    d4.feed(a12,a11,a10,di4);
    d3.feed(a12,a11,a10,di3);
    d2.feed(a12,a11,a10,di2);
    d1.feed(a12,a11,a10,di1);
    d0.feed(a12,a11,a10,di0);
    wd.feed(a12,a11,a10,w);
    // feed 8 1024x8 RAMs
    r0.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o0,d7.o0,d6.o0,d5.o0,d4.o0,d3.o0,d2.o0,d1.o0,d0.o0);
    r1.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o1,d7.o1,d6.o1,d5.o1,d4.o1,d3.o1,d2.o1,d1.o1,d0.o1);
    r2.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o2,d7.o2,d6.o2,d5.o2,d4.o2,d3.o2,d2.o2,d1.o2,d0.o2);
    r3.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o3,d7.o3,d6.o3,d5.o3,d4.o3,d3.o3,d2.o3,d1.o3,d0.o3);
    r4.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o4,d7.o4,d6.o4,d5.o4,d4.o4,d3.o4,d2.o4,d1.o4,d0.o4);
    r5.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o5,d7.o5,d6.o5,d5.o5,d4.o5,d3.o5,d2.o5,d1.o5,d0.o5);
    r6.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o6,d7.o6,d6.o6,d5.o6,d4.o6,d3.o6,d2.o6,d1.o6,d0.o6);
    r7.feed(a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,wd.o7,d7.o7,d6.o7,d5.o7,d4.o7,d3.o7,d2.o7,d1.o7,d0.o7);
    // selection
    s7.feed(a12,a11,a10,r7.do7,r6.do7,r5.do7,r4.do7,r3.do7,r2.do7,r1.do7,r0.do7);
    s6.feed(a12,a11,a10,r7.do6,r6.do6,r5.do6,r4.do6,r3.do6,r2.do6,r1.do6,r0.do6);
    s5.feed(a12,a11,a10,r7.do5,r6.do5,r5.do5,r4.do5,r3.do5,r2.do5,r1.do5,r0.do5);
    s4.feed(a12,a11,a10,r7.do4,r6.do4,r5.do4,r4.do4,r3.do4,r2.do4,r1.do4,r0.do4);
    s3.feed(a12,a11,a10,r7.do3,r6.do3,r5.do3,r4.do3,r3.do3,r2.do3,r1.do3,r0.do3);
    s2.feed(a12,a11,a10,r7.do2,r6.do2,r5.do2,r4.do2,r3.do2,r2.do2,r1.do2,r0.do2);
    s1.feed(a12,a11,a10,r7.do1,r6.do1,r5.do1,r4.do1,r3.do1,r2.do1,r1.do1,r0.do1);
    s0.feed(a12,a11,a10,r7.do0,r6.do0,r5.do0,r4.do0,r3.do0,r2.do0,r1.do0,r0.do0);
    do7=s7.q;
    do6=s6.q;
    do5=s5.q;
    do4=s4.q;
    do3=s3.q;
    do2=s2.q;
    do1=s1.q;
    do0=s0.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=13 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,addr.charAt(3)=='0'?false:true,addr.charAt(4)=='0'?false:true,
          addr.charAt(5)=='0'?false:true,addr.charAt(6)=='0'?false:true,addr.charAt(7)=='0'?false:true,addr.charAt(8)=='0'?false:true,addr.charAt(9)=='0'?false:true,
          addr.charAt(10)=='0'?false:true,addr.charAt(11)=='0'?false:true,addr.charAt(12)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("------------");
    r0.display();
    r1.display();
    r2.display();
    r3.display();
    r4.display();
    r5.display();
    r6.display();
    r7.display();
    //System.out.println("------------");
  }
  
}
public class RAM8x1{
  boolean a2,a1,a0;
  boolean din,dout;
  boolean w;
  Decoder3to8 dec;
  Selector8to1 sel;
  DFlipFlop dq0,dq1,dq2,dq3,dq4,dq5,dq6,dq7;
  
  public RAM8x1(){
    dec=new Decoder3to8();
    sel=new Selector8to1();
    dq0=new DFlipFlop();
    dq1=new DFlipFlop();
    dq2=new DFlipFlop();
    dq3=new DFlipFlop();
    dq4=new DFlipFlop();
    dq5=new DFlipFlop();
    dq6=new DFlipFlop();
    dq7=new DFlipFlop();
  }
  
  void feed(boolean a2,boolean a1,boolean a0,
            boolean w,boolean di){
    this.a2=a2;this.a1=a1;this.a0=a0;
    this.din=di;
    this.w=w;
    // decoder circuit
    dec.feed(a2,a1,a0,w);
    // mem circuit
    dq7.d=di; dq7.setClk(dec.o7);
    dq6.d=di; dq6.setClk(dec.o6);
    dq5.d=di; dq5.setClk(dec.o5);
    dq4.d=di; dq4.setClk(dec.o4);
    dq3.d=di; dq3.setClk(dec.o3);
    dq2.d=di; dq2.setClk(dec.o2);
    dq1.d=di; dq1.setClk(dec.o1);
    dq0.d=di; dq0.setClk(dec.o0);
    // selector circuit
    sel.feed(a2,a1,a0,
            dq7.q,dq6.q,dq5.q,dq4.q,
            dq3.q,dq2.q,dq1.q,dq0.q);
    dout=sel.q;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=3 || w.length()!=1 || di.length()!=1){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,
          w.charAt(0)=='0'?false:true,di.charAt(0)=='0'?false:true);
  }
  
  void display(String prefix){
    System.out.println(prefix+"_RAM8x1");
    System.out.println("| "+(dq0.q?"1":"0")+" |");
    System.out.println("| "+(dq1.q?"1":"0")+" |");
    System.out.println("| "+(dq2.q?"1":"0")+" |");
    System.out.println("| "+(dq3.q?"1":"0")+" |");
    System.out.println("| "+(dq4.q?"1":"0")+" |");
    System.out.println("| "+(dq5.q?"1":"0")+" |");
    System.out.println("| "+(dq6.q?"1":"0")+" |");
    System.out.println("| "+(dq7.q?"1":"0")+" |");
  }
  
  void display(){
    System.out.println("| "+(dq0.q?"1":"0")+" |");
    System.out.println("| "+(dq1.q?"1":"0")+" |");
    System.out.println("| "+(dq2.q?"1":"0")+" |");
    System.out.println("| "+(dq3.q?"1":"0")+" |");
    System.out.println("| "+(dq4.q?"1":"0")+" |");
    System.out.println("| "+(dq5.q?"1":"0")+" |");
    System.out.println("| "+(dq6.q?"1":"0")+" |");
    System.out.println("| "+(dq7.q?"1":"0")+" |");
  }
  
}
public class RAM8x2{
  boolean a2,a1,a0;
  boolean di1,di0;
  boolean do1,do0;
  boolean w;
  RAM8x1 r0,r1;
  
  RAM8x2(){
    r0=new RAM8x1();
    r1=new RAM8x1();
  }
  
  void feed(boolean a2,boolean a1,boolean a0,
            boolean w,boolean di1,boolean di0){
    this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;this.di1=di1;this.di0=di0;
    r0.feed(a2,a1,a0,w,di0);
    r1.feed(a2,a1,a0,w,di1);
    do0=r0.dout;
    do1=r1.dout;
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=3 || w.length()!=1 || di.length()!=2){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,
          w.charAt(0)=='0'?false:true,di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("RAM8x2");
    //System.out.println("------");
    System.out.println("| "+(r1.dq0.q?"1":"0")+(r0.dq0.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq1.q?"1":"0")+(r0.dq1.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq2.q?"1":"0")+(r0.dq2.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq3.q?"1":"0")+(r0.dq3.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq4.q?"1":"0")+(r0.dq4.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq5.q?"1":"0")+(r0.dq5.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq6.q?"1":"0")+(r0.dq6.q?"1":"0")+" |");
    System.out.println("| "+(r1.dq7.q?"1":"0")+(r0.dq7.q?"1":"0")+" |");
    //System.out.println("------");
  }
  
}
public class RAM8x8{
  boolean a2,a1,a0;
  boolean di7,di6,di5,di4,di3,di2,di1,di0;
  boolean do7,do6,do5,do4,do3,do2,do1,do0;
  boolean w;
  RAM8x1 r0,r1,r2,r3,r4,r5,r6,r7;
  
  RAM8x8(){
    r0=new RAM8x1();
    r1=new RAM8x1();
    r2=new RAM8x1();
    r3=new RAM8x1();
    r4=new RAM8x1();
    r5=new RAM8x1();
    r6=new RAM8x1();
    r7=new RAM8x1();
  }
  
  void feed(boolean a2,boolean a1,boolean a0,
            boolean w,
            boolean di7,boolean di6,boolean di5,boolean di4,boolean di3,boolean di2,boolean di1,boolean di0){
    this.a2=a2;this.a1=a1;this.a0=a0;
    this.w=w;
    this.di0=di0;
    this.di1=di1;
    this.di2=di2;
    this.di3=di3;
    this.di4=di4;
    this.di5=di5;
    this.di6=di6;
    this.di7=di7;
    r0.feed(a2,a1,a0,w,di0);
    r1.feed(a2,a1,a0,w,di1);
    r2.feed(a2,a1,a0,w,di2);
    r3.feed(a2,a1,a0,w,di3);
    r4.feed(a2,a1,a0,w,di4);
    r5.feed(a2,a1,a0,w,di5);
    r6.feed(a2,a1,a0,w,di6);
    r7.feed(a2,a1,a0,w,di7);
    do0=r0.dout;
    do1=r1.dout;
    do2=r2.dout;
    do3=r3.dout;
    do4=r4.dout;
    do5=r5.dout;
    do6=r6.dout;
    do7=r7.dout;
  }
  
  void printDO(){
    System.out.println("RAM8x8.DO-> "+(do7?"1":"0")+(do6?"1":"0")+(do5?"1":"0")+(do4?"1":"0")+(do3?"1":"0")+(do2?"1":"0")+(do1?"1":"0")+(do0?"1":"0"));
  }
  
  void feed(String addr,String w,String di){
    if(addr.length()!=3 || w.length()!=1 || di.length()!=8){
      throw new RuntimeException("illegal feed in data!");
    }
    feed(addr.charAt(0)=='0'?false:true,addr.charAt(1)=='0'?false:true,addr.charAt(2)=='0'?false:true,
          w.charAt(0)=='0'?false:true,
          di.charAt(0)=='0'?false:true,di.charAt(1)=='0'?false:true,di.charAt(2)=='0'?false:true,di.charAt(3)=='0'?false:true,
          di.charAt(4)=='0'?false:true,di.charAt(5)=='0'?false:true,di.charAt(6)=='0'?false:true,di.charAt(7)=='0'?false:true);
  }
  
  void display(){
    //System.out.println("RAM8x8");
    //System.out.println("------------");
    System.out.println("| "+(r7.dq0.q?"1":"0")+(r6.dq0.q?"1":"0")+(r5.dq0.q?"1":"0")+(r4.dq0.q?"1":"0")+(r3.dq0.q?"1":"0")+(r2.dq0.q?"1":"0")+(r1.dq0.q?"1":"0")+(r0.dq0.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq1.q?"1":"0")+(r6.dq1.q?"1":"0")+(r5.dq1.q?"1":"0")+(r4.dq1.q?"1":"0")+(r3.dq1.q?"1":"0")+(r2.dq1.q?"1":"0")+(r1.dq1.q?"1":"0")+(r0.dq1.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq2.q?"1":"0")+(r6.dq2.q?"1":"0")+(r5.dq2.q?"1":"0")+(r4.dq2.q?"1":"0")+(r3.dq2.q?"1":"0")+(r2.dq2.q?"1":"0")+(r1.dq2.q?"1":"0")+(r0.dq2.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq3.q?"1":"0")+(r6.dq3.q?"1":"0")+(r5.dq3.q?"1":"0")+(r4.dq3.q?"1":"0")+(r3.dq3.q?"1":"0")+(r2.dq3.q?"1":"0")+(r1.dq3.q?"1":"0")+(r0.dq3.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq4.q?"1":"0")+(r6.dq4.q?"1":"0")+(r5.dq4.q?"1":"0")+(r4.dq4.q?"1":"0")+(r3.dq4.q?"1":"0")+(r2.dq4.q?"1":"0")+(r1.dq4.q?"1":"0")+(r0.dq4.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq5.q?"1":"0")+(r6.dq5.q?"1":"0")+(r5.dq5.q?"1":"0")+(r4.dq5.q?"1":"0")+(r3.dq5.q?"1":"0")+(r2.dq5.q?"1":"0")+(r1.dq5.q?"1":"0")+(r0.dq5.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq6.q?"1":"0")+(r6.dq6.q?"1":"0")+(r5.dq6.q?"1":"0")+(r4.dq6.q?"1":"0")+(r3.dq6.q?"1":"0")+(r2.dq6.q?"1":"0")+(r1.dq6.q?"1":"0")+(r0.dq6.q?"1":"0")+" |");
    System.out.println("| "+(r7.dq7.q?"1":"0")+(r6.dq7.q?"1":"0")+(r5.dq7.q?"1":"0")+(r4.dq7.q?"1":"0")+(r3.dq7.q?"1":"0")+(r2.dq7.q?"1":"0")+(r1.dq7.q?"1":"0")+(r0.dq7.q?"1":"0")+" |");
    //System.out.println("------------");
  }
  
}

public class RippleCtr8b extends TimerTask{
  long T;
  volatile boolean clk;
  DFlipFlopOsc f0, f1, f2, f3, f4, f5, f6, f7;

  public RippleCtr8b(long millis){
    T = millis;
    clk = false;
    f0 = new DFlipFlopOsc();
    f1 = new DFlipFlopOsc();
    f2 = new DFlipFlopOsc();
    f3 = new DFlipFlopOsc();
    f4 = new DFlipFlopOsc();
    f5 = new DFlipFlopOsc();
    f6 = new DFlipFlopOsc();
    f7 = new DFlipFlopOsc();
  }

  public void run(){
    clk = !clk;
    f0.setClk(clk);
    f1.setClk(!f0.q);
    f2.setClk(!f1.q);
    f3.setClk(!f2.q);
    f4.setClk(!f3.q);
    f5.setClk(!f4.q);
    f6.setClk(!f5.q);
    f7.setClk(!f6.q);
    if(clk){
      System.out.println((f7.q?"1":"0") + (f6.q?"1":"0") + (f5.q?"1":"0") + (f4.q?"1":"0") + (f3.q?"1":"0") + (f2.q?"1":"0") + (f1.q?"1":"0") + (f0.q?"1":"0"));
    }
  }

}

public class Selector2to1{
  boolean d1,d0;
  boolean s0;
  boolean q;
  
  Selector2to1(){}
  
  boolean selector2to1(boolean s0,
                      boolean d1,boolean d0){
    boolean ns0=!s0;
    boolean a0=d0&ns0;
    boolean a1=d1& s0;
    return a0|a1;
  }
  
  boolean selector2to1(String s,String d){
    if(s.length()!=1 || d.length()!=2){
      throw new RuntimeException("illegal data/select inputs!");
    }
    // selection bits
    boolean s0=s.charAt(0)=='0'?false:true;
    // data bits
    boolean d1=d.charAt(0)=='0'?false:true;
    boolean d0=d.charAt(1)=='0'?false:true;
    return selector2to1(s0,d1,d0);
  }
  
  void feed(boolean s0,
            boolean i1,boolean i0){
    this.s0=s0;
    d1=i1;
    d0=i0;
    q=selector2to1(s0,d1,d0);
  }
  
  void display(){
    System.out.println("S2x1.out -> "+(q?"1":"0"));
  }
  
}
public class Selector4to1{
  boolean d3,d2,d1,d0;
  boolean s0,s1;
  boolean q;
  
  Selector4to1(){}
  
  boolean selector4to1(boolean s1,boolean s0,
                      boolean d3,boolean d2,boolean d1,boolean d0){
    boolean ns0=!s0;
    boolean ns1=!s1;
    boolean a0=d0&ns1&ns0;
    boolean a1=d1&ns1& s0;
    boolean a2=d2& s1&ns0;
    boolean a3=d3& s1& s0;
    return a0|a1|a2|a3;
  }
  
  boolean selector4to1(String s,String d){
    if(s.length()!=2 || d.length()!=4){
      throw new RuntimeException("illegal data/select inputs!");
    }
    // selection bits
    boolean s1=s.charAt(0)=='0'?false:true;
    boolean s0=s.charAt(1)=='0'?false:true;
    // data bits
    boolean d3=d.charAt(0)=='0'?false:true;
    boolean d2=d.charAt(1)=='0'?false:true;
    boolean d1=d.charAt(2)=='0'?false:true;
    boolean d0=d.charAt(3)=='0'?false:true;
    return selector4to1(s1,s0,d3,d2,d1,d0);
  }
  
  void feed(boolean s1,boolean s0,
            boolean i3,boolean i2,boolean i1,boolean i0){
    this.s1=s1;
    this.s0=s0;
    d3=i3;
    d2=i2;
    d1=i1;
    d0=i0;
    q=selector4to1(s1,s0,d3,d2,d1,d0);
  }
  
  void display(){
    System.out.println("S4x1.out -> "+(q?"1":"0"));
  }
  
}
public class Selector8to1{
  boolean d7,d6,d5,d4,d3,d2,d1,d0;
  boolean s0,s1,s2;
  boolean q;
  
  Selector8to1(){}
  
  boolean selector8to1(boolean s2,boolean s1,boolean s0,
                              boolean d7,boolean d6,boolean d5,boolean d4,boolean d3,boolean d2,boolean d1,boolean d0){
    boolean ns0=!s0;
    boolean ns1=!s1;
    boolean ns2=!s2;
    boolean a0=d0&ns2&ns1&ns0;
    boolean a1=d1&ns2&ns1& s0;
    boolean a2=d2&ns2& s1&ns0;
    boolean a3=d3&ns2& s1& s0;
    boolean a4=d4& s2&ns1&ns0;
    boolean a5=d5& s2&ns1& s0;
    boolean a6=d6& s2& s1&ns0;
    boolean a7=d7& s2& s1& s0;
    return a0|a1|a2|a3|a4|a5|a6|a7;
  }
  
  boolean selector8to1(String s,String d){
    if(s.length()!=3 || d.length()!=8){
      throw new RuntimeException("illegal data/select inputs!");
    }
    // selection bits
    boolean s2=s.charAt(0)=='0'?false:true;
    boolean s1=s.charAt(1)=='0'?false:true;
    boolean s0=s.charAt(2)=='0'?false:true;
    // data bits
    boolean d7=d.charAt(0)=='0'?false:true;
    boolean d6=d.charAt(1)=='0'?false:true;
    boolean d5=d.charAt(2)=='0'?false:true;
    boolean d4=d.charAt(3)=='0'?false:true;
    boolean d3=d.charAt(4)=='0'?false:true;
    boolean d2=d.charAt(5)=='0'?false:true;
    boolean d1=d.charAt(6)=='0'?false:true;
    boolean d0=d.charAt(7)=='0'?false:true;
    return selector8to1(s2,s1,s0,d7,d6,d5,d4,d3,d2,d1,d0);
  }
  
  void feed(boolean s2,boolean s1,boolean s0,
            boolean i7,boolean i6,boolean i5,boolean i4,boolean i3,boolean i2,boolean i1,boolean i0){
    this.s2=s2;
    this.s1=s1;
    this.s0=s0;
    d7=i7;
    d6=i6;
    d5=i5;
    d4=i4;
    d3=i3;
    d2=i2;
    d1=i1;
    d0=i0;
    q=selector8to1(s2,s1,s0,d7,d6,d5,d4,d3,d2,d1,d0);
  }
  
  void display(){
    System.out.println("S8x1.out -> "+(q?"1":"0"));
  }
  
}
