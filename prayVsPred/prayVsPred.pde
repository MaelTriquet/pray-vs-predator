ArrayList<Agent> agents = new ArrayList<Agent>();
float probNode = 0.04;
float probConn = probNode + .11;
float probWeight = .8;
int pop = 20;
int widthCell;
int heightCell;
int maxRadius = 15;
ArrayList<Agent> toDie;
Cell[] cells;
int timeBaby = 30;
int eat2reproduce = 8;
int lifespan = 200;
int maxPop = 1000;
int nbInput = 6;
int substep = 5;

void setup() {
  size(800, 800);
  widthCell = ((int)width) / maxRadius + 1;
  heightCell = ((int)height) / maxRadius + 1;
  for (int i = 0; i < pop; i++) {
    agents.add(new Agent(new PVector(random(width), random(height)), 0, i == 0, i));
    agents.get(agents.size() - 1).randomStart();
  }
  toDie = new ArrayList<Agent>();
  cells = new Cell[widthCell * heightCell];
  for (int i = 0; i < cells.length; i++) {
    cells[i] = new Cell(i);
  }
  updateCells();
}

void draw() {
  background(190);
  simplify();
  updateCells();
  for (int i = 0; i < agents.size(); i++) {
    if (!agents.get(i).dead) {
      agents.get(i).show();
      agents.get(i).update();
    }
  }
  cellMeet();
  while (agents.get(agents.size() - 1).dead) {
    agents.remove(agents.size()-1);
  }

  for (int i = agents.size() - 1; i > -1; i--) {
    if (agents.get(i).checked) {
      agents.get(i).checked = false;
    } else {
      agents.get(i).dead = true;
    }
  }
}

void cellMeet() {
  for (int k = 0; k < substep; k++) {
    updateCells();
    toDie.clear();
    for (int i = 0; i < widthCell; i++) {
      for (int j = 0; j < heightCell; j++) {
        ArrayList<Cell> neighbours = cells[i + widthCell * j].neighbours();
        for (Cell c2 : neighbours) {
          cells[i + widthCell * j].meet(c2);
        }
      }
    }

    for (Agent a : toDie) {
      a.die();
    }
  }
}

int countAlive() {
  int res = 0;
  for (Agent a : agents) {
    if (!a.dead) {
      res++;
    }
  }
  return res;
}

void simplify() {
  for (int i = agents.size() - 1; i > -1; i--) {
    if (agents.get(i).dead) {
      agents.remove(i);
    }
  }

  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).index = i;
  }
}

void mouseClicked() {
  Agent predator = new Agent(new PVector(mouseX, mouseY), 1, false, agents.size());
  predator.randomStart();
  agents.add(predator);
}

int majority() {
  int red = 0;
  int green = 0;
  for (Agent a : agents) {
    if (a.type == 0) {
      green++;
    } else {
      red++;
    }
  }
  if (green > red) {
    return 0;
  }
  return 1;
}
