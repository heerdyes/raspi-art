class Rocket extends Mover{
  DNA<PVector> dna;
  int genectr;

  Rocket(){
    super(1,5);
    dna=new DNA<PVector>(10);
    genectr=0;
  }

  void run(){
    applyforce(dna.genes[genectr]);
    genectr++;
    update();
  }
}
