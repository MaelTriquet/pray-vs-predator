class NeuralNetwork {
  ArrayList<Node> nodes; // by arriving order
  ArrayList<Node> sortedNodes; // sorted by layer nb
  int layerNb;
  int inputNb;
  int outputNb;
  int lastNode;
  int bias;

  NeuralNetwork(int inputNb_, int outputNb_) {
    inputNb = inputNb_;
    outputNb = outputNb_;
    layerNb = 2;
    lastNode = 0;
    nodes = new ArrayList<Node>();
    sortedNodes = new ArrayList<Node>();

    //input
    for (int i = 0; i < inputNb; i++) {
      nodes.add(new Node(lastNode, 0));
      lastNode++;
    }

    //bias
    nodes.add(new Node(lastNode, 0));
    bias = lastNode;
    lastNode++;

    //output
    for (int i = 0; i < outputNb; i++) {
      Node toAdd = new Node(lastNode, 1);
      nodes.add(toAdd);
      nodes.get(bias).connections.add(new Connection(bias, lastNode, random(-.3, .3)));
      lastNode++;
    }
    loserSort(nodes);
  }

  float[] feedForward(float[] input) {
    loserSort(nodes);
    float[] output = new float[outputNb];
    for (int i = 0; i < inputNb; i++) {
      sortedNodes.get(i).value = input[i];
    }
    nodes.get(bias).value = 1;
    for (int i = 0; i < nodes.size() - outputNb; i++) {
      sortedNodes.get(i).feedForward(nodes);
    }
    for (int i = 0; i < outputNb; i++) {
      sortedNodes.get(lastNode - outputNb + i).setValue();
      output[i] = sortedNodes.get(lastNode - outputNb + i).value;
    }

    for (Node n : nodes) {
      n.value = 0;
    }

    return output;
  }

  boolean addConnection(Node from, Node to) {
    boolean done = false;
    if (from.layer < to.layer) {
      if (nodesAreShit(from, to)) {
        return true;
      }
      done = true;
      nodes.get(from.index).connections.add(new Connection(from.index, to.index, random(-1, 1)));
    } else if (from.layer > to.layer) {
      if (nodesAreShit(to, from)) {
        return true;
      }
      done = true;
      nodes.get(to.index).connections.add(new Connection(to.index, from.index, random(-1, 1)));
    }
    return done;
  }

  void addNode(Node from, Node to) {
    Node newbie = new Node(lastNode, from.layer + 1);
    for (Connection c : from.connections) {
      if (c.to == to.index) {
        c.enabled = false;
        from.connections.add(new Connection(from.index, newbie.index, c.weight));
        newbie.connections.add(new Connection(newbie.index, to.index, 1));
      }
      break;
    }
    if (to.layer - from.layer > 1) {
      nodes.add(newbie);
      lastNode++;
      loserSort(nodes);
    } else if (to.layer - from.layer == 1) {
      layerNb++;
      for (Node n : nodes) {
        if (n.layer > from.layer) {
          n.layer++;
        }
      }
      nodes.add(newbie);
      lastNode++;
      loserSort(nodes);
    }
    nodes.get(bias).connections.add(new Connection(bias, newbie.index, 0));
  }

  void loserSort(ArrayList<Node> nodes) {
    sortedNodes.clear();
    for (int l = 0; l < layerNb; l++) {
      for (Node n : nodes) {
        if (n.layer == l) {
          sortedNodes.add(n);
        }
      }
    }
  }

  void mutate() {
    float a = random(1);
    Node randomNode = nodes.get((int) random(nodes.size() - outputNb));
    if (a < probNode) {
      if (randomNode.connections.size() > 0) {
        int randIndex = (int) random(0, randomNode.connections.size());
        addNode(randomNode, nodes.get(randomNode.connections.get(randIndex).to));
      }
    } else if (a < probConn) {
      Node randomNode2;
      do {
        randomNode2 = nodes.get((int) random(nodes.size()));
      } while (!addConnection(randomNode, randomNode2));
    }

    randomNode = nodes.get((int) random(0, nodes.size()));
    float b = random(0, 1);
    if (b < probWeight) {
      int randIndex = (int) random(0, randomNode.connections.size());
      if (randomNode.connections.size() > 0) {
        if (a > .5) {
          randomNode.connections.get(randIndex).weight = random(-1, 1);
        } else {
          randomNode.connections.get(randIndex).weight += random(-.1, .1);
          randomNode.connections.get(randIndex).weight = max(randomNode.connections.get(randIndex).weight, -1);
          randomNode.connections.get(randIndex).weight = min(randomNode.connections.get(randIndex).weight, 1);
        }
      }
    }
  }

  boolean nodesAreShit(Node from, Node to) {
    int nbAfter = 0;
    for (int i = 0; i < nodes.size(); i++) {
      if (nodes.get(i).layer > from.layer) {
        nbAfter++;
      }
    }

    for (Connection c : from.connections) {
      if (c.to == to.index) {
        return true;
      }
    }

    return (from.connections.size() >= nbAfter);
  }

  Node getTrueNode(int index) {
    for (Node n : nodes) {
      if (n.index == index) {
        return n;
      }
    }
    return null;
  }


  NeuralNetwork clone() {
    NeuralNetwork clone = new NeuralNetwork(inputNb, outputNb);
    clone.nodes.clear();
    for (int i = 0; i < nodes.size(); i++) {
      clone.nodes.add(nodes.get(i).clone());
    }
    clone.layerNb = layerNb;
    clone.lastNode = lastNode;
    clone.bias = bias;
    return clone;
  }

  void show() {
    noStroke();
    int size = 20;
    float w = 400;
    float h = 200;
    float x = 10;
    float y = 10;
    int max_layer = 10;
    int last_layer = nodes.get(nodes.size()-1).layer;
    int count = 0;
    int cur_layer = 0;
    for (int i = 0; i < nodes.size(); i++) {
      if (cur_layer < nodes.get(i).layer) {
        count = 0;
        cur_layer++;
      }
      nodes.get(i).x = x + w * (float)(cur_layer) / (float)(last_layer);
      nodes.get(i).y = y + h * (float)(count) / (float)(max_layer);
      fill(0);
      circle(nodes.get(i).x, nodes.get(i).y, size);
      fill(255);
      text(nodes.get(i).index, nodes.get(i).x, nodes.get(i).y);
      count++;
    }
    for (Node n : nodes) {
      for (Connection c : n.connections) {
        if (c.enabled) {
          if (c.weight < 0) {
            stroke(0, 0, 255);
          }
          if (c.weight > 0) {
            stroke(255, 0, 0);
          }
          if (c.weight == 0) {
            stroke(0);
          }
          strokeWeight(map(abs(c.weight), 0, 1, 0, 5));
          Node from = getTrueNode(c.from);
          Node to = getTrueNode(c.to);
          if (from != null && to != null) {
            line(from.x, from.y, to.x, to.y);
          }
        }
      }
    }
  }
}
