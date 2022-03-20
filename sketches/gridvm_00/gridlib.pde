enum Mode {
  MUMUKSHU, MUKTA
}

void gridloader() {
  String[] gridlns=loadStrings(gridfile);
  if (gridlns.length!=ROWS) {
    throw new RuntimeException("expected "+ROWS+" rows, got "+gridlns.length+"!");
  }
  for (int i=0; i<ROWS; i++) {
    String ln=gridlns[i];
    String[] parts=ln.split(" +");
    if (parts.length!=COLS) {
      throw new RuntimeException("expected "+COLS+" cols, got "+parts.length+"!");
    }
    for (int j=0; j<COLS; j++) {
      String tok=parts[j];
      if (tok.length()==2) {
        int inst=Integer.parseInt(tok, 16);
        grid[i][j]=(byte)inst;
      } else {
        char ch=tok.charAt(0);
        grid[i][j]=(byte)ch;
      }
    }
  }
}

void rendergrid() {
  for (int i=0; i<ROWS; i++) {
    for (int j=0; j<COLS; j++) {
      if (i==pcr && j==pcc) {
        fill(hg);
      } else {
        fill(fg);
      }
      if (mode==Mode.MUMUKSHU) {
        text((char)grid[i][j], xoff+j*xsp, yoff+i*ysp);
      } else if (mode==Mode.MUKTA) {
        String dat=String.format("%02x", grid[i][j]);
        text(dat, xoff+j*xsp, yoff+i*ysp);
      } else {
        throw new RuntimeException("unknown mode!");
      }
    }
  }
}

void renderstak() {
  int mx=30, my=200;
  noFill();
  stroke(fg);
  rect(width-mx-15, 20, 30, height-my);
  noStroke();
  fill(fg);
  for (int i=0; i<stak.size(); i++) {
    byte sv=stak.get(i);
    if (mode==Mode.MUMUKSHU) {
      text((char)sv, width-mx, height-my-i*20);
    } else if (mode==Mode.MUKTA) {
      String dat=String.format("%02x", sv);
      text(dat, width-mx, height-my-i*20);
    } else {
      throw new RuntimeException("unknown mode!");
    }
  }
}

void txtcfg() {
  mono=createFont(fontfile, 14);
  textFont(mono);
  textSize(14);
  textAlign(CENTER, CENTER);
}

void bootrc() {
  String[] rclns=loadStrings("bootrc");
  fontfile=rclns[0];
  clkdiv=int(rclns[1]);
  gridfile=rclns[2];
}

void renderinfo() {
  fill(fg);
  text("<SPACE> to play/pause grid virtual machine", width/2, height-20);
}
