class Box {
  float x, y, w, h;
  color bg, fg;

  Box(float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    bg=color(255);
    fg=color(0);
  }

  void updatepos(float nx, float ny) {
    x=nx;
    y=ny;
  }

  void render() {
    fill(bg);
    stroke(fg);
    rect(x, y, w, h);
  }

  boolean hasmouse() {
    return mouseX>x && mouseX<(x+w) && mouseY>y && mouseY<(y+h);
  }
}

class TextBox extends Box {
  String txt;
  int txtsz;

  TextBox(float x, float y, float w, float h) {
    super(x, y, w, h);
    txt="";
    txtsz=16;
  }

  void render() {
    super.render();
    fill(0);
    textAlign(LEFT, TOP);
    textSize(txtsz);
    text(txt, x+5, y+5);
  }
}

class Port extends Box {
  Port px; // patch connection port
  String parentnodeid;

  Port(String pnid, float x, float y, float w, float h, color c) {
    super(x, y, w, h);
    bg=c;
    px=null;
    parentnodeid=pnid;
  }

  String toString() {
    return String.format("%s->Port", parentnodeid);
  }
}

class InPort extends Port {
  InPort(String pnid, float x, float y, float w, float h) {
    super(pnid, x, y, w, h, color(0, 128, 0));
  }
}

class OutPort extends Port {
  OutPort(String pnid, float x, float y, float w, float h) {
    super(pnid, x, y, w, h, color(0, 0, 128));
  }
}

class Node {
  Box container;
  InPort inport;
  OutPort outport;
  String id;
  float portwidth, portheight;
  color portcolor;

  void updatepos(float nx, float ny) {
    container.updatepos(nx, ny);
    computeportpos();
  }

  void computeinportpos() {
    float cx=container.x;
    float cy=container.y;
    float ch=container.h;
    inport.updatepos(cx-portwidth, cy+ch/2-portheight/2);
  }

  void computeoutportpos() {
    float cx=container.x;
    float cy=container.y;
    float ch=container.h;
    float cw=container.w;
    outport.updatepos(cx+cw, cy+ch/2-portheight/2);
  }

  void computeportpos() {
    computeinportpos();
    computeoutportpos();
  }

  Node(String nid, float x, float y, float w, float h, float pw, float ph) {
    container=new Box(x, y, w, h);
    id=nid;
    portwidth=pw;
    portheight=ph;
    inport=new InPort(id, x-portwidth, y+h/2-portheight/2, portwidth, portheight);
    outport=new OutPort(id, x+w, y+h/2-portheight/2, portwidth, portheight);
  }

  void render() {
    container.render();
    inport.render();
    outport.render();
    if (outport.px!=null) {
      Port src=outport;
      Port dst=outport.px;
      stroke(0);
      line(src.x+src.w/2, src.y+src.h/2, dst.x+dst.w/2, dst.y+dst.h/2);
    }
  }

  String toString() {
    return String.format("Node [%s, %s, %s, %s]", nf(container.x, 3, 2), nf(container.y, 3, 2), nf(container.w, 3, 2), nf(container.h, 3, 2));
  }
}

enum NSState {
  READY, HOLD, PATCH;
}

class NodeMan {
  HashMap<String, Node> ntab;
  Node fn; // focused node
  Node hn; // holding node
  Port psp; // patch src port
  float holddx, holddy;
  NSState ns;
  int nctr=0;
  Port olddst; // old patch destination

  NodeMan() {
    ntab=new HashMap<String, Node>();
    fn=null;
    hn=null;
    psp=null;
    ns=NSState.READY;
  }

  void rendernodegraph() {
    for (Node n : ntab.values()) {
      if (ns==NSState.HOLD && n==hn) {
        n.updatepos(mouseX-holddx, mouseY-holddy);
      }
      n.render();
    }
  }

  void t_readytohold() {
    hn=idnode();
    if (hn!=null) {
      ns=NSState.HOLD;
      sb.txt="holding "+hn.toString();
    } else {
      sb.txt="mouse not inside node";
    }
  }

  void t_holdtoready() {
    ns=NSState.READY;
    sb.txt="releasing "+hn.toString();
    hn=null;
  }

  void updatesrcport(Port src, String nk) {
    olddst=src.px;
    psp=src;
    sb.txt=String.format("[update_src_port] %s src port", nk);
  }

  void t_readytopatch() {
    ns=NSState.PATCH;
    sb.txt="[patching]";
    for (HashMap.Entry<String, Node> te : ntab.entrySet()) {
      String nk=te.getKey();
      Node nv=te.getValue();
      if (nv.inport.hasmouse()) {
        updatesrcport(nv.inport, nk);
        break;
      } else if (nv.outport.hasmouse()) {
        updatesrcport(nv.outport, nk);
        break;
      }
    }
  }

  Port idport() {
    Port dst=null;
    for (HashMap.Entry<String, Node> te : ntab.entrySet()) {
      String nk=te.getKey();
      Node nv=te.getValue();
      if (nv.inport.px!=null || nv.outport.px!=null) {
        continue;
      }
      if (nv.inport.hasmouse()) {
        dst=nv.inport;
        break;
      } else if (nv.outport.hasmouse()) {
        dst=nv.outport;
        break;
      }
    }
    sb.txt=String.format("[idport] %s", (dst==null?"null":dst.toString()));
    return dst;
  }

  void updatedstport(Port dst) {
    if (dst==null) {
      sb.txt="no patch destination!";
    } else {
      sb.txt="patched!";
      psp.px=dst;
      dst.px=psp;
      if (olddst!=null) {
        olddst.px=null;
      }
    }
  }

  void t_patchtoready() {
    if (psp==null) {
      ns=NSState.READY;
      sb.txt="[bug] somehow patch source not set";
      return;
    }
    Port dst=idport();
    updatedstport(dst);
    psp=null;
    ns=NSState.READY;
  }

  void mknode() {
    String nn_name=String.format("n%02d", nctr);
    Node nn=new Node(nn_name, mouseX, mouseY, 200, 150, PORT_W, PORT_H);
    sb.txt=String.format("[mknode] %s - %s", nn_name, nn.toString());
    ntab.put(nn_name, nn);
    nctr+=1;
  }

  void highlightnode() {
    if (fn!=null) {
      sb.txt="selected "+fn.toString();
      for (Node n : ntab.values()) {
        n.container.fg=color(0);
      }
      fn.container.fg=color(255, 128, 0);
    }
  }

  Node idnode() {
    for (Node n : ntab.values()) {
      float nx=n.container.x;
      float ny=n.container.y;
      float nw=n.container.w;
      float nh=n.container.h;
      if (nx<mouseX && ny<mouseY && (nx+nw)>mouseX && (ny+nh)>mouseY) {
        holddx=mouseX-nx;
        holddy=mouseY-ny;
        return n;
      }
    }
    return null;
  }

  void rmpatch() {
    //
  }

  void onmouseclick() {
    fn=idnode();
    highlightnode();
  }

  void onkeydown() {
    if (key=='n') {
      mknode();
    } else if (key=='h' && nm.ns==NSState.READY) {
      t_readytohold();
    } else if (key=='p' && nm.ns==NSState.READY) {
      t_readytopatch();
    } else if (key=='d' && nm.ns==NSState.READY) {
      rmpatch();
    }
  }

  void onkeyup() {
    if (key=='h' && nm.ns==NSState.HOLD) {
      t_holdtoready();
    } else if (key=='p' && nm.ns==NSState.PATCH) {
      t_patchtoready();
    }
  }
}
