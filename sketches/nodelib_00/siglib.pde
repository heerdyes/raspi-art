interface Src {
  void send(float x);
}

interface Dst {
  float recv();
}

class WireChannel implements Src, Dst {
  ArrayList<Float> q;
  int capacity;

  WireChannel(int n) {
    capacity=n;
    q=new ArrayList<Float>();
    for (int i=0; i<n; i++) {
      q.add(i, 0f);
    }
  }

  void send(float x) {
    if (q.size()>capacity) {
      q.remove(q.size()-1);
    }
    q.add(0, x);
  }

  float recv() {
    return q.remove(q.size()-1);
  }
}
