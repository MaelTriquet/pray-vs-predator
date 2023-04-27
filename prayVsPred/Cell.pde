class Cell {
  ArrayList<Integer> content = new ArrayList<Integer>();
  int index;

  Cell(int index_) {
    index = index_;
  }

  ArrayList<Cell> neighbours() {
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    neighbours.add(this);

    //if (index % widthCell != 0) {
    //  neighbours.add(cells[index - 1]);
    //  if (index / widthCell != 0) {
    //    neighbours.add(cells[index - widthCell - 1]);
    //  }
    //  if (index / widthCell != heightCell - 1) {
    //    neighbours.add(cells[index + widthCell - 1]);
    //  }
    //}

    //if (index % widthCell != widthCell - 1) {
    //  neighbours.add(cells[index + 1]);
    //  if (index / widthCell != 0) {
    //    neighbours.add(cells[index - widthCell + 1]);
    //  }
    //  if (index / widthCell != heightCell - 1) {
    //    neighbours.add(cells[index + widthCell + 1]);
    //  }
    //}

    //if (index / widthCell != 0) {
    //  neighbours.add(cells[index - widthCell]);
    //}
    //if (index / widthCell != heightCell - 1) {
    //  neighbours.add(cells[index + widthCell]);
    //}
    
    int i = index % widthCell;
    int j = index / widthCell;
    
    neighbours.add(cells[j * widthCell + (i+1) % widthCell]);//droite
    neighbours.add(cells[j * widthCell + (widthCell + i-1) % widthCell]);//gauche
    neighbours.add(cells[((heightCell + j-1) % heightCell) * widthCell + i]);//haut
    neighbours.add(cells[((j+1) % heightCell) * widthCell + i]);//bas
    neighbours.add(cells[((heightCell + j-1) % heightCell) * widthCell + (widthCell + i-1) % widthCell]);//HG
    neighbours.add(cells[((j+1) % heightCell) * widthCell + (widthCell + i-1) % widthCell]);//BG
    neighbours.add(cells[((heightCell + j-1) % heightCell) * widthCell + (i+1) % widthCell]);//HD
    neighbours.add(cells[((heightCell + j-1) % heightCell) * widthCell + (widthCell + i-1) % widthCell]);//HG

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
