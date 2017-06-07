public class BubbleGrid {
  private Bubble[][] _bubbleGrid;
  private int _size;                //number of active bubbles
  private LList<Bubble> _cluster;   //same color bubbles that are attached to each other and may get popped if > 3 of them
  private int _recentPop;           // 0 if in the last turn bubbles were successfully popped (or if first turn), 1 if last turn resulted in NO pops
  private int _numMoved;            //keeps track of how many rows added to the top throughout the game during the shifts down
  private int _score;               // +5 for every bubble in a cluster that was just popped
  private int _largestCluster;      // largest cluster + hanging bubbles that were popped b/c of it 
  private int _poppedPerCluster;    // cluster + hanging bubbles that were popped b/c of it, compared agst _largestCluster throughout game
  
  public static final int RADIUS = 20;   //Radius of ball
  
  //Constructor 
  public BubbleGrid(){
    _largestCluster = 0;
    _score = 0;
    _numMoved = 0;
    _cluster = new LList<Bubble>();
    _size = 0; 
    _recentPop = 0;
    _bubbleGrid = new Bubble[12][20]; //column number must always be even so that there are the same num bubbles per row
    populate();
    setNeighbors(); 
  }
  
//ACCESSORS----------------------------------------------------------------------------------
  public int getRecentPop(){
    return _recentPop;
  }
  
 public int getLargestCluster(){
    return _largestCluster;
  }
  
 public Bubble[][] getBubbleGrid(){
    return _bubbleGrid;
  }
  
public int getScore(){
  return _score;
  }
  
//MUTATORS------------------------------------------------------------------------------------  
  //Sets a particular spot of the grid as a particular bubble
  public void setBubble(int x, int y, Bubble b){
     _bubbleGrid[x][y] = b;
  }
  
  public void setRecentPop(int count){
    _recentPop = count;
  }
  
//SIGNIFICANT FUNCTIONAL METHODS-------------------------------------------------------------------------------

//populates an empty grid in the constructor
  //This is a hex grid so every other element is null
  //max num neighbors is 6
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
           if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
         }
         else {
             _bubbleGrid[row][col] = new Bubble(RADIUS, 2*RADIUS*row +RADIUS, state);
             if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
          }
        }
      }
    }
  }//end populate()

  //properly adds to the neighbor arrays of each bubble by traversing the 2D array 
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
     } //end setNeighbors()

 
 //Adds a row of new bubbles to the top and shifts everything down, adjusts coordinates, sets neighbors, and resets the hanging property
  public void moveDown(){
     Bubble[][] bubbleGrid2 = new Bubble[_bubbleGrid.length + 1][_bubbleGrid[0].length];
     for (int row=0; row < _bubbleGrid.length ; row ++){
       for (int col=0; col < _bubbleGrid[0].length ; col ++){
         bubbleGrid2[row + 1][col] = _bubbleGrid[row][col];
       }
     }
       for (int c=0; c < _bubbleGrid[0].length ; c++){
         if (c % 2 == (_numMoved % 2)){
           bubbleGrid2[0][c] = null;
         }
         else {
           bubbleGrid2[0][c] = new Bubble();
         }
       }
     _bubbleGrid = bubbleGrid2;
     adjustCors();
     setNeighbors();
     resetHanging();
     _numMoved ++;
   }
   
//adjusts the xcor and ycor of all the bubbles of the changed grid (used after a new row added to top)
public void adjustCors(){
     for (int row=0; row < _bubbleGrid.length ; row ++){
       for (int col=0; col < _bubbleGrid[0].length ; col ++){       
        if (row % 2 == (_numMoved % 2)){
          if (col == 1){
            _bubbleGrid[row][col].setXcor(2*RADIUS);
            _bubbleGrid[row][col].setYcor(2*RADIUS*row + RADIUS);
            if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
          }
          else if (col % 2 == 1){
            _bubbleGrid[row][col].setXcor(2*RADIUS*(col/2) + 2 * RADIUS);
            _bubbleGrid[row][col].setYcor(2*RADIUS*row + RADIUS);
            if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
          }
        }
        else { 
         if ( col%2 == 0 && col != 0) {
           _bubbleGrid[row][col].setXcor(2*RADIUS*(col/2) + RADIUS);
           _bubbleGrid[row][col].setYcor(2*RADIUS*row +RADIUS);
           if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
          
         }
         else if (col == 0) {
             _bubbleGrid[row][col].setXcor(RADIUS);
             _bubbleGrid[row][col].setYcor(2*RADIUS*row +RADIUS);
             if (row == 0){
               _bubbleGrid[row][col].setHanging(1);
             }
             
          }
        }
      }
    }
  }

  
  //parameter is launched bubble, recursively adds all attached same color bubbles to the linked list _cluster 
  public LList<Bubble> createCluster(Bubble b){
    if (!b.getChecked()){    //ensures no bubbles is added to the cluster twice
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
  
  //pops clusters greater than 3 in size , and resets each bubble of cluster's checked property, while setting the states to -1 (popped state)
  //updates poppedPerCluster and largestCluster and score
  public void pop(){
    _poppedPerCluster = 0; 
   //println (_cluster.size());
    if (_cluster.size() < 3){
      while ( _cluster.size() != 0){
        _cluster.get(0).setChecked(false);
        _cluster.remove();
      }
      _recentPop =1;
    }
    else {
      _recentPop = 0;
      _poppedPerCluster += _cluster.size();
      while (_cluster.size() != 0){
        Bubble current = _cluster.get(0);
        current.setChecked(false);
        current.setState(-1);
        _score += 5;
        _cluster.remove();
      }
      searchForHanging();
      resetHanging();
      if (_poppedPerCluster > _largestCluster){
        _largestCluster = _poppedPerCluster;
      }
       //println(_borderCluster.size());
    }
  }
  
   //recursively sets the hanging property of each bubble that is not an "island" and should remain active despite the recently popped cluster disappearing with 1
   //after called, all those still 0 are hanging ie not attached to anything
   //how it works: finds everything attached to start in some manner (indirect neighbor or direct)
  public void markHanging(Bubble start){
    for (Bubble bubs : start.getActiveNeighbors()){
      if (bubs.getHanging() == 0){
        bubs.setHanging(1);
        markHanging(bubs);
      }
    }
  }
  
  //Calls markHanging using every top row bubble as a parameter 
  //sets a state of 0 (inactive) for hanging bubbles 
  public void searchForHanging(){
    for (int col = 0; col < _bubbleGrid[0].length ; col++){
       if (_bubbleGrid[0][col] != null && _bubbleGrid[0][col].getState() == 1 ){
         markHanging (_bubbleGrid[0][col]);
       }
    }
    //println(printArr());
    for (int row = _bubbleGrid.length-1; row >= 0 ; row --){
      for (int c = 0; c< _bubbleGrid[0].length; c ++){
        if(_bubbleGrid[row][c] != null && _bubbleGrid[row][c].getHanging() == 0 && _bubbleGrid[row][c].getState() == 1){
          Bubble actual = _bubbleGrid[row][c]; 
          _poppedPerCluster += 1;
          actual.setState(0);
          
        }        
      }
    }
  }
  
  //resets hanging property of all bubbles to 0 except top row bubbles 
  public void resetHanging(){
    for (int row = 1; row < _bubbleGrid.length ; row ++){
      for (int c = 0; c< _bubbleGrid[0].length; c ++){
        if (_bubbleGrid[row][c] != null){
          _bubbleGrid[row][c].setHanging(0);
        }
      }
    }
  }
  
 
  //returns first active Bubble that the launched Bubble should attach to b/c it collides with it
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
 
 
 //takes launched bubbles and returns the closest neighbor to the launched bubble
 //this is the neighbor that the bubble should transform into when it snapped into place
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
  
  
// DISPLAY/TESTING METHODS -------------------------------------------------------------------------

  public String printArr(){
    //println("GARGGGG");
    String retStr = "";
    for (int row = 0; row < _bubbleGrid.length ; row ++){
      for (int c = 0; c< _bubbleGrid[0].length; c ++){
        if (_bubbleGrid[row][c] != null){
          retStr += _bubbleGrid[row][c].getHanging() + " " ;
        }
      }
      retStr += "\n";
    }
    return retStr;
  }  
  
  //traverses grid and calls Bubble show fxn (only active (state == 1) bubbles are shown  
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
  
  
}//end class BubbleGrid 