public class BubbleGrid {
  private Bubble[][] _bubbleGrid;
  private int _size; //number of active bubbles
  private LList<Bubble> _cluster;
  private int _cPop;
  private LList<Bubble> _hangingBubbles;
  private int _numMoved;
  private int _score;
  private int _largestCluster;
  private int _poppedPerCluster;
  public static final int RADIUS = 20recent
  
  //Constructor 
  public BubbleGrid(){
    _largestCluster = 0;
    _score = 0;
    _numMoved = 0;
    _cluster = new LList<Bubble>();
    _size = 0; 
    _recentPop = 0;
    _hangingBubbles = new LList<Bubble>();
    _bubbleGrid = new Bubble[12][20]; //column number must always be even
    populate();
    setNeighbors();
  }
  
  
  //Accessor method for a particular bubble in the grid
  public Bubble getBubble(int x, int y){
     return  _bubbleGrid[x][y];
  }
  
  public int getRecentPop(){
    return _recentPop;
  }
  
  //Sets a particular spot of the grid as a particular bubble
  public void setBubble(int x, int y, Bubble b){
     _bubbleGrid[x][y] = b;
  }
   
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
      //println(printArr());
     _bubbleGrid = bubbleGrid2;
     //println(printArr());
     adjustCors();
     setNeighbors();
     resetHanging();
     //println(printArr());
     _numMoved ++;
   }
   
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
  
  public int getLargestCluster(){
    return _largestCluster;
  }

  
  public void markHanging(Bubble start){
    for (Bubble bubs : start.getActiveNeighbors()){
      if (bubs.getHanging() == 0){
        bubs.setHanging(1);
        markHanging(bubs);
      }
    }
  }
  
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
  
  public void searchForHanging(){
    for (int col = 0; col < _bubbleGrid[0].length ; col++){
       if (_bubbleGrid[0][col] != null && _bubbleGrid[0][col].getState() == 1 ){
         markHanging (_bubbleGrid[0][col]);
       }
    }
    println(printArr());
    for (int row = _bubbleGrid.length-1; row >= 0 ; row --){
      for (int c = 0; c< _bubbleGrid[0].length; c ++){
        if(_bubbleGrid[row][c] != null && _bubbleGrid[row][c].getHanging() == 0 && _bubbleGrid[row][c].getState() == 1){
          Bubble actual = _bubbleGrid[row][c]; 
          _poppedPerCluster += 1;
          Bubble copy = new Bubble(actual.getXcor() , actual.getYcor(), actual.getColor(), 1 );
          _hangingBubbles.add(copy);
          copy.show();
          actual.setState(0);
          
        }        
      }
    }
  }
  
  public void resetHanging(){
    for (int row = 1; row < _bubbleGrid.length ; row ++){
      for (int c = 0; c< _bubbleGrid[0].length; c ++){
        if (_bubbleGrid[row][c] != null){
          _bubbleGrid[row][c].setHanging(0);
        }
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
     
     public int getScore(){
       return _score;
     }
  
  
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
  
  public LList<Bubble> getHangingBubbles(){
    return _hangingBubbles;
  }
  
  public void setCountNonPop(int count){
    _recentPop = count;
  }
  
}//end class BubbleGrid 