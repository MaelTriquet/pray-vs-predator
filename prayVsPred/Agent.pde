class Agent {
  int type; // 1 = predator, 0 =  pray
  NeuralNetwork brain;
  PVector pos;
  PVector vel;
  float velMax = 2.5;
  float radius = maxRadius;
  float[] sight;
  float[] decision;
  int timeB4Baby = timeBaby;
  boolean test;
  int index;
  boolean dead = false;
  int life = lifespan;
  int cellIndex;
  boolean checked = false;

  Agent(PVector pos_, int type_, boolean test_, int index_) {
    index = index_;
    pos = pos_;
    type = type_;
    velMax += (1-type) * 4;
    sight = new float[4];
    decision = new float[3];
    brain = new NeuralNetwork(sight.length, decision.length);
    test = test_;
  }

  void show() {
    stroke(0);
    strokeWeight(0);
    fill(0, 255, 0);
    if (type == 1) {
      fill(255, 0, 0);
    }
    circle(pos.x, pos.y, radius);
  }

  void update() {
    if (type == 1) {
      life--;
      if (life < 0) {
        die();
      }
    }
    if (timeB4Baby < 0) {
      if (countAlive() < maxPop || majority() != type) {
        makeBaby();
      }
    }

    look();
    think(sight);
    act();
    pos.add(vel);

    if (pos.x < 0) {
      pos.x += width;
    }
    if (pos.y < 0) {
      pos.y += height;
    }
    if (pos.x >= width) {
      pos.x -= width;
    }
    if (pos.y >= height) {
      pos.y -= height;
    }
    if (type == 0 && vel.mag() < .3) {
      timeB4Baby--;
    }
  }

  void look() {
    float nbAgents = 0;
    float nbFriends = 0;
    float nbFoes = 0;
    PVector friendsAvg = new PVector();
    PVector foesAvg = new PVector();
    ArrayList<Cell> neighbours = cells[cellIndex].neighbours();
    for (Cell c : neighbours) {
      for (int i : c.content) {
        if (agents.get(i).type != type) {
          nbFoes++;
          foesAvg.add(agents.get(i).pos);
        } else {
          nbFriends++;
          friendsAvg.add(agents.get(i).pos);
        }
        nbAgents++;
      }
    }
    if (nbFriends > 0) {
      friendsAvg.mult((float)1/nbFriends);
      friendsAvg.sub(pos);
    } else {
      friendsAvg = new PVector();
    }
    if (nbFoes > 0) {
      foesAvg.mult((float)1/nbFoes);
      foesAvg.sub(pos);
    } else {
      foesAvg = new PVector();
    }

    foesAvg.sub(pos);
    if (nbAgents > 0) {
      sight[0] = nbFriends/nbAgents;
      sight[1] = nbFoes/nbAgents;
    } else {
      sight[0] = 0;
      sight[1] = 0;
    }
    sight[2] = foesAvg.x/radius;
    sight[3] = foesAvg.y/radius;
    //sight[4] = friendsAvg.x/radius;
    //sight[5] = friendsAvg.y/radius;
  }

  void think(float[] sight) {
    decision = brain.feedForward(sight);
  }

  void act() {
    if (decision[0] * decision[1] != 0) {
      vel = new PVector(decision[0], decision[1]).setMag(decision[2] * velMax);
      if (vel.mag() > velMax) {
        vel.setMag(velMax);
      }
    } else {
      vel = new PVector();
    }
  }

  void mutate() {
    brain.mutate();
  }

  void makeBaby() {
    Agent baby = clone();
    baby.mutate();
    baby.mutate();
    timeB4Baby = timeBaby;
    if (baby.index < agents.size()) {
      agents.set(baby.index, baby);
    } else {
      agents.add(baby);
    }
  }

  Agent clone() {
    int new_index = agents.size();
    for (int i = 0; i < agents.size(); i++) {
      if (agents.get(i).dead) {
        new_index = i;
        break;
      }
    }
    Agent clone;
    if (type == 0) {
      clone = new Agent(pos.copy().add(new PVector(random(-2*radius, 2*radius), random(-2*radius, 2*radius))), type, test, new_index);
    } else {
      clone = new Agent(pos.copy().add(new PVector(random(-.5*radius, .5*radius), random(-.5*radius, .5*radius))), type, test, new_index);
    }
    clone.brain = brain.clone();
    return clone;
  }

  void die() {
    dead = true;
  }

  void randomStart() {
    for (int i = 0; i < 5; i++) {
      brain.mutate();
    }
  }

  void meet(Agent other) {
    if (other.index != index) {
      if (dist(pos.x, pos.y, other.pos.x, other.pos.y) <= radius/2 + other.radius/2) {
        if (type == 1 && other.type == 0) {
          other.die();
          timeB4Baby -= timeBaby/eat2reproduce;
          life = lifespan;
        } else if (type == 0 && other.type == 1) {
          die();
          other.timeB4Baby -= timeBaby/eat2reproduce;
          other.life = lifespan;
        }
      }
    }
  }
}
