class DNA<T> {
  T[] genes;
  float maxforce;
  float fitness;

  DNA(int lifetime) {
    genes=new T[lifetime];
    for (int i=0; i<genes.length; i++) {
      genes[i]=T.random2D();
      genes[i].mult(random(0,maxforce));
    }
  }

  void fitnessfn(T t,T loc) {
    float d=T.dist(loc,t);
    fitness=pow(1/d,2);
  }

  DNA<T> crossover(DNA partner, T t) {
    DNA<T> child=new DNA<T>(t.length());
    int midpoint=int(random(genes.length));
    for (int i=0; i<genes.length; i++) {
      child.genes[i]=(i>midpoint)?genes[i]:partner.genes[i];
    }
    return child;
  }

  void mutate(float mrate) {
    for (int i=0; i<genes.length; i++) {
      if (random(1)<mrate) {
        genes[i]=T.random2D();
      }
    }
  }
}

// T (e.g. Rocket) must have DNA of type U (e.g. PVector)
class Popu<T,U> {
  T[] members;
  ArrayList<T> matingpool;
  float mutationR;
  U target;

  Popu(int n, float mr, U t) {
    members=new T[n];
    mutationR=mr;
    target=t;
    matingpool=new ArrayList<T>();
    initpopu();
  }

  void initpopu() {
    for (int i=0; i<members.length; i++) {
      members[i]=new T();
    }
  }

  void evalfitness() {
    for (int i=0; i<members.length; i++) {
      members[i].dna.fitnessfn(target);
    }
  }

  void buildmatingpool() {
    for (int i=0; i<members.length; i++) {
      int n=int(members[i].dna.fitness*100);
      for (int j=0; j<n; j++) {
        matingpool.add(members[i]);
      }
    }
  }

  void select() {
    evalfitness();
    buildmatingpool();
  }

  void reproduce() {
    for (int i=0; i<members.length; i++) {
      int nm=matingpool.size();
      int a=int(random(nm));
      int b=int(random(nm));
      while (b==a) {
        println("[reproduce][improbability] same parent chosen twice! reselecting...");
        b=int(random(nm));
      }
      DNA<U> parentA=((T)matingpool.get(a)).dna;
      DNA<U> parentB=((T)matingpool.get(b)).dna;
      DNA<U> child=parentA.crossover(parentB, target);
      child.mutate(mutationR);
      members[i]=child;
    }
  }

  void enliven(){
    for(int i=0;i<members.length;i++){
      members[i].run();
    }
  }
}
