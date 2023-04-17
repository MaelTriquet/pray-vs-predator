class Connection {
  int from;
  int to;
  float weight;
  boolean enabled = true;
  
  Connection(int from_, int to_, float weight_) {
    from = from_;
    to = to_;
    weight = weight_;
  }
  
  Connection clone() {
    Connection clone = new Connection(from, to, weight);
    clone.enabled = enabled;
    return clone;
  }
}
