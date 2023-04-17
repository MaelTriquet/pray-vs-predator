class Cell {
  ArrayList<Integer> content = new ArrayList<Integer>();
  int index;

  Cell(int index_) {
    index = index_;
  }

  ArrayList<Cell> neighbours() {
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    neighbours.add(this);

    if (index % widthCell != 0) {
      neighbours.add(cells[index - 1]);
      if (index / widthCell != 0) {
        neighbours.add(cells[index - widthCell - 1]);
      }
      if (index / widthCell != heightCell - 1) {
        neighbours.add(cells[index + widthCell - 1]);
      }
    }

    if (index % widthCell != widthCell - 1) {
      neighbours.add(cells[index + 1]);
      if (index / widthCell != 0) {
        neighbours.add(cells[index - widthCell + 1]);
      }
      if (index / widthCell != heightCell - 1) {
        neighbours.add(cells[index + widthCell + 1]);
      }
    }

    if (index / widthCell != 0) {
      neighbours.add(cells[index - widthCell]);
    }
    if (index / widthCell != heightCell - 1) {
      neighbours.add(cells[index + widthCell]);
    }

    return neighbours;
  }

  void clean() {
    content.clear();
  }

  void meet(Cell other) {
    for (int i : content) {
      for (int j : other.content) {
        agents.get(i).checked = true;
        agents.get(j).checked = true;
        agents.get(i).meet(agents.get(j));
      }
    }
  }
}

void updateCells() {
  for (Cell c : cells) {
    c.clean();
  }
  for (Agent b : agents) {
    if (!b.dead) {
      b.cellIndex = ((int)b.pos.x) / maxRadius + ((int)b.pos.y) / maxRadius * widthCell;
      if (b.cellIndex >= 0 && b.cellIndex < cells.length) {
        cells[b.cellIndex].content.add(b.index);
      } else {
        b.die();
      }
    }
  }
}
