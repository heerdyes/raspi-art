int serialno=0;

class Msg {
  String head;
  ArrayList<String> body;

  Msg(String hd, ArrayList<String> bd) {
    this.head=hd;
    this.body=bd; // use body as list: (car cdr)
  }
}

class Msgbus {
  HashMap<Integer, Pubsub> peermap;

  Msgbus() {
    peermap=new HashMap<Integer, Pubsub>();
  }

  void addpeer(int psid, Pubsub ps) {
    if (peermap.containsKey(psid)) {
      println(String.format("peer with id: %d already exists", psid));
    } else {
      peermap.put(psid, ps);
    }
  }

  void sendmsg(int snd, int dst, Msg m) {
    Pubsub receiver=peermap.get(dst);
    Pubsub sender=peermap.get(snd);
    receiver.receive(m, sender);
  }
}

interface Pub {
  void publish(Msg m);
  void addsub(Sub s);
}

interface Sub {
  void receive(Msg m, Pub snd);
}

class Pubsub implements Pub, Sub {
  ArrayList<Sub> subs;
  String pubid;

  Pubsub() {
    this.subs=new ArrayList<Sub>();
    this.pubid=String.format("%s_%04d", Pub.class.getName(), serialno);
    serialno+=1;
  }

  void publish(Msg msg) {
    ArrayList<String> msgbody=msg.body;
    for (Sub s : subs) {
      if (!Sub.class.isInstance(s)) {
        throw new RuntimeException("non-subscriber encountered!");
      }
      Msg m=new Msg(pubid, msgbody);
      s.receive(m, this);
    }
  }

  void addsub(Sub sub0) {
    this.subs.add(sub0);
  }

  void receive(Msg m, Pub p) {
    // override this function
  }
}
