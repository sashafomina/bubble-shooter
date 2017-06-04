public class BubbleGrid {
  private Bubble[][] _bubbleGrid;
  private int _size; //number of active bubbles
  private LList<Bubble> _cluster;
  public static final int RADIUS = 20;
  
  //Constructor 
  public BubbleGrid(){
    _cluster = new LList<Bubble>();
    _size = 0; 
    _bubbleGrid = new Bubble[13][20]; //column number must always be even
    populate();
    setNeighbors();
  }
  
  
  //Accessor method for a particular bubble in the grid
  public Bubble getBubble(int x, int y){
     return  _bubbleGrid[x][y];
  }
  
  
  //Sets a particular spot of the grid as a particular bubble
  public void setBubble(int x, int y, Bubble b){
     _bubbleGrid[x][y] = b;
  }
  
  
  //parameter is launched bubble
  public LList<Bubble> createCluster(Bubble b){
    if (!b.getChecked()){
      _cluster.add(b);
      b.setChecked(true); 
    }
    ArrayList<Bubble> same = b.getSameNeighbors();
    //println(same.size());
    if (same.size() != 0){
      for (Bubble bubs : same){
        if (!(bubs.getChecked())){
          _cluster.add(bubs);
          bubs.setChecked(true);
          createCluster(bubs);
        }
      }
    }
    return _cluster;
  }
  
  public void pop(){
   println (_cluster.size());
    if (_cluster.size() < 3){
      while ( _cluster.size() != 0){
        _cluster.get(0).setChecked(false);
        _cluster.remove();
      }
    }
    else {
      while (_cluster.size() != 0){
        Bubble current = _cluster.get(0);
        current.setChecked(false);
        current.setState(-1);
        _cluster.remove();
      }
    }
  }
  
  
  public void populate(){
    int state = 1;
    for (int row = 0; row < _bubbleGrid.length ; row ++){
      if ( row > _bubbleGrid.length/2) {
        state = 0;
      }
      else {
        _size ++;
      }
      for (int col = 0 ; col < _bubbleGrid[0].length ; col ++){
        if (row % 2 == 1){
          if (col == 1){
            _bubbleGrid[row][col] = new Bubble( 2*RADIUS, 2*RADIUS*row + RADIUS, state);
          }
          else if (col % 2 == 1){
            _bubbleGrid[row][col] = new Bubble(2*RADIUS*(col/2) + 2*RADIUS, 2*RADIUS*row + RADIUS, state);
          }
          else {
            _bubbleGrid[row][col] = null;
          }
        }
        else { 
          if (col % 2 == 1){
            _bubbleGrid[row][col] = null;
         }
         else if ( col != 0) {
           _bubbleGrid[row][col] = new Bubble(2*RADIUS*(col/2) + RADIUS , 2*RADIUS*row +RADIUS , state);
          
         }
         else {
             _bubbleGrid[row][col] = new Bubble(RADIUS, 2*RADIUS*row +RADIUS, state);
          }
        }
      }
    }
  }//end populate()
     
  
  
public void setNeighbors(){
    for (int row = 0; row < _bubbleGrid.length ; row++){
      for (int col = 0; col < _bubbleGrid[0].length ; col ++){
        
        if (_bubbleGrid[row][col] != null){
          ArrayList neighbors = _bubbleGrid[row][col].getNeighbors();
          
          if (col < _bubbleGrid[0].length-2 && _bubbleGrid[row][col+2] != null){  
            neighbors.add(_bubbleGrid[row][col + 2]);
          }
          
          if (col < _bubbleGrid[0].length-1 && row < _bubbleGrid.length -1 && _bubbleGrid[row+1][col+1] != null){
            neighbors.add(_bubbleGrid[row+1][col+1]); 
          }
           
          if (col < _bubbleGrid[0].length-1 && row > 0 && _bubbleGrid[row-1][col+1] != null){
              neighbors.add(_bubbleGrid[row-1][col+1]); 
          }
            
          if (col > 1 && _bubbleGrid[row][col -2] != null){
            neighbors.add(_bubbleGrid[row][col-2]);
          }
          
          if (col > 0 && row > 0 && _bubbleGrid[row-1][col-1] != null){
              neighbors.add(_bubbleGrid[row-1][col-1]);
           }
          
          if (col > 0 && row < _bubbleGrid.length - 1 && _bubbleGrid[row+1][col-1] != null){
              neighbors.add(_bubbleGrid[row+1][col-1]);
          }  
         } 
        }
       }
     }
     
  public void show(){
    for (int row = 0; row < _bubbleGrid.length ; row++){
      for (int col = 0; col < _bubbleGrid[0].length ; col++){
        if (_bubbleGrid[row][col] != null){
          _bubbleGrid[row][col].show();
          //println (_bubbleGrid[row][col].getXcor() + " , " + _bubbleGrid[row][col].getYcor());
        }
      }
    }
  }
  
  public Bubble[][] getBubbleGrid(){
    return _bubbleGrid;
  }

  //returns Bubble that the launched Bubble should attach to
  public Bubble stick(Bubble launchedB){
    Bubble attachTo = null;
    boolean found = false;
    for (int row = _bubbleGrid.length-1; row >= 0 ; row --){
      for (int col = 0 ; col < _bubbleGrid[0].length ; col ++){
        if (_bubbleGrid[row][col] != null && _bubbleGrid[row][col].getState() == 1 && launchedB.inContact(_bubbleGrid[row][col])){
          attachTo = _bubbleGrid[row][col];
          found = true;
          break;
        }
        if (found){
          break;
        }
      }
    }
    return attachTo;
  }//end stick()
 
 //takes launched bubbles and returns index of closest neighbor to the launched bubble
 public Bubble whichNeighbor(Bubble b){
   Bubble attachTo = stick(b);
    int indexOpen = 0;
    for (int x = 0; x < attachTo.getNeighbors().size() ; x ++){
      if (attachTo.getNeighbors().get(x).getState() == 0 ||attachTo.getNeighbors().get(x).getState() == -1){
        if (dist(b.getXcor(), b.getYcor(), attachTo.getNeighbors().get(x).getXcor(),attachTo.getNeighbors().get(x).getYcor() ) < dist(b.getXcor(), b.getYcor(), attachTo.getNeighbors().get(indexOpen).getXcor(), attachTo.getNeighbors().get(indexOpen).getYcor())){
          indexOpen = x;
        }
      }
    }
    Bubble correctPos = attachTo.getNeighbors().get(indexOpen);
    correctPos.setColor(b.getColor());
    correctPos.setState(1); //for testing
    return correctPos;
  }//end whichNeighbor()
  
  
  
}//end class BubbleGrid 