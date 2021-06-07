int LOWERCHAR=48;
int UPPERCHAR=57;

class DNA {
  char[] genes;
  float fitness;
  int score;

  DNA(int nch) {
    genes=new char[nch];
    for (int i=0; i<genes.length; i++) {
      genes[i]=(char)random(LOWERCHAR, UPPERCHAR);
    }
    score=1;
  }

  // user assigns score, so the fitness function is human selected for now
  void fitnessfn(int npopu) {
    fitness=float(score)/float(npopu);
  }

  void updatescore(int score) {
    this.score=score;
  }

  DNA crossover(DNA partner) {
    DNA child=new DNA(genes.length);
    int midpoint=int(random(genes.length));
    for (int i=0; i<genes.length; i++) {
      child.genes[i]=(i>midpoint)?genes[i]:partner.genes[i];
    }
    return child;
  }

  void mutate(float mrate) {
    for (int i=0; i<genes.length; i++) {
      if (random(1)<mrate) {
        println("[mutate] dna mutation event");
        genes[i]=(char)random(LOWERCHAR, UPPERCHAR);
      }
    }
  }

  String genome() {
    return new String(genes);
  }
}

class Popu {
  DNA[] members;
  ArrayList<DNA> matingpool;
  float mutationR;
  int genomelen;
  int currentgen;

  Popu(int n, float mr, int gn) {
    members=new DNA[n];
    mutationR=mr;
    genomelen=gn;
    matingpool=new ArrayList<DNA>();
    initpopu();
    currentgen=0;
  }

  void initpopu() {
    for (int i=0; i<members.length; i++) {
      members[i]=new DNA(genomelen);
    }
  }

  void evalfitness() {
    for (int i=0; i<members.length; i++) {
      members[i].fitnessfn(members.length);
    }
  }

  void buildmatingpool() {
    for (int i=0; i<members.length; i++) {
      int n=int(members[i].fitness*members.length); // even fitness for turtles
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
    println("[reproduce] matingpool size: "+matingpool.size());
    for (int i=0; i<members.length; i++) {
      int nm=matingpool.size();
      int a=int(random(nm));
      int b=int(random(nm));
      while (b==a) {
        println("[reproduce][improbability] same parent chosen twice! reselecting...");
        b=int(random(nm));
      }
      DNA parentA=matingpool.get(a);
      DNA parentB=matingpool.get(b);
      DNA child=parentA.crossover(parentB);
      child.mutate(mutationR);
      members[i]=child;
    }
    currentgen+=1;
  }
}
