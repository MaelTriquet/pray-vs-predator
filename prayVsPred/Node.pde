class Node {
  ArrayList<Connection> connections;
  int layer;
  float value;
  int index;
  float x;
  float y;

  Node(int index_, int layer_) {
    index = index_;
    value = 0;
    layer = layer_;
    connections = new ArrayList<Connection>();
  }

  Node() {
    value = 0;
    connections = new ArrayList<Connection>();
  }

  void feedForward(ArrayList<Node> nodes) {
    for (Connection c : connections) {
      nodes.get(c.to).value += value * c.weight;
    }
  }
  
  void setValue() {
    if (value > 1) {
      value = 1;
    } else if (value < -1) {
      value = -1;
    }
  }

  Node clone() {
    Node clone = new Node();
    clone.layer = layer;
    clone.index = index;
    for (Connection c : connections) {
      clone.connections.add(c.clone());
    }
    return clone;
  }
}
