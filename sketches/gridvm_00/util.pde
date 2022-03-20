byte spop() {
  if (stak.size()==0) {
    throw new RuntimeException("attempted to pop empty stak!");
  }
  return stak.remove(stak.size()-1);
}

void spush(byte x) {
  if (stak.size()>=STAKLIM) {
    throw new RuntimeException("STACK OVERFLOW! size of stack exceeded "+STAKLIM);
  }
  stak.add(x);
}
