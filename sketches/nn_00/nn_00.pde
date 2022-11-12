class Perceptron {
  float[] weights;
  float c=0.01;

  Perceptron(int n) {
    weights=new float[n];
    for (int i=0; i<n; i++) {
      weights[i]=1-2*random();
    }
  }

  int feedforward(float[] inputs) {
    float sum=0;
    for (int i=0; i<weights.length; i++) {
      sum+=inputs[i]*weights[i];
    }
    return activate(sum);
  }

  int activate(float s) {
    if (s>0) return 1;
    else return -1;
  }

  void train(float[] inputs, int desired) {
    int guess=feedforward(inputs);
    float error=desired-guess;
    for (int i=0; i<weights.length; i++) {
      weights[i]+=c*error*inputs[i];
    }
  }
}

class Trainer {
  float[] inputs;
  int answer;

  Trainer(float x, float y, int a) {
    inputs=new float[3];
    inputs[0]=x;
    inputs[1]=y;
    inputs[2]=1;
    answer=a;
  }
}
