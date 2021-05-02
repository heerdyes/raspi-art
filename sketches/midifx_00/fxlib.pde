enum METype {
  NOTE_ON, NOTE_OFF
}

class MEvent {
  long ts;
  int note;
  int velo;
  METype type;

  MEvent(long ts, int note, int velo, METype type) {
    this.ts=ts;
    this.note=note;
    this.velo=velo;
    this.type=type;
  }

  public String toString() {
    return String.format("MEvent[ts: %d, note: %d, velo: %d, type: %s]", ts, note, velo, type);
  }
}

class MEventSeq {
  ArrayList<MEvent> seq;
  long endts;
  boolean recording=false;
  long tmpts;

  MEventSeq() {
    seq=new ArrayList<MEvent>();
    tmpts=0;
  }

  void recbegin() {
    tmpts=millis();
    recording=true;
  }

  void addevent(MEvent me) {
    if (recording) {
      seq.add(me);
    } else {
      println("[warning][addevent] not recording, hence ignoring addevent request");
      println("[warning][addevent] P.S. programmer carelessness is causing you to see this!");
    }
  }

  void addevent(long ms, int p, int v, METype type) {
    addevent(new MEvent(ms-tmpts, p, v, type));
    tmpts=ms;
  }

  void recend() {
    long lastms=millis();
    endts=lastms-tmpts;
    tmpts=lastms;
    recording=false;
  }

  boolean isRecording() { 
    return recording;
  }

  public String toString() {
    StringBuffer sb=new StringBuffer();
    for (MEvent me : seq) {
      sb.append("    "+me.toString()+"\n");
    }
    return String.format("MEventSeq[\n  tmpts: %d,\n  seq: [\n  %s\n  ],\n  endts: %d]", tmpts, sb.toString(), endts);
  }
}

class MLoop implements Runnable {
  MidiBus bus;
  MEventSeq meseq;
  volatile boolean running;
  volatile boolean looppaused;

  void stoploop() {
    running=false;
  }

  MLoop(MidiBus bus, MEventSeq meseq) {
    this.bus=bus;
    this.meseq=meseq;
    running=true;
    looppaused=false;
  }

  void pauseloop() {
    looppaused=true;
  }

  void resumeloop() {
    looppaused=false;
  }

  void playloop() {
    for (MEvent me : meseq.seq) {
      delay((int)me.ts);
      if (METype.NOTE_ON.equals(me.type)) {
        bus.sendNoteOn(0, me.note, me.velo);
      } else if (METype.NOTE_OFF.equals(me.type)) {
        bus.sendNoteOff(0, me.note, me.velo);
      } else {
        println("[playloop][error] unknown event type: "+me.type);
      }
    }
    delay((int)meseq.endts);
  }

  public void run() {
    while (running) {
      // idle spin if paused
      while (looppaused) {
        try {
          Thread.sleep(30);
        }
        catch(InterruptedException ie) {
          println("thread boom! "+ie.getMessage());
        }
      }
      // midi loop player
      playloop();
    }
  }
}
