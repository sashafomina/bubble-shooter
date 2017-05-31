public class BubbleGrid {
  private Bubble[][] _bubbleGrid;
  private int _size;
  public static final int RADIUS = 25;
  
  //Constructor 
  public BubbleGrid(){
    _size = 0; 
    _bubbleGrid = new Bubble[7][16]; //column number must always be even
    populate();
  }
  
  public void populate(){
    for (int row = 0; row < _bubbleGrid.length ; row ++){
      for (int col = 0 ; col < _bubbleGrid[0].length ; col ++){
        if (row % 2 == 1){
          if (col == 1){
            _bubbleGrid[row][col] = new Bubble( 2*RADIUS, 2*RADIUS*row + RADIUS, 1);
          }
          else if (col % 2 == 1){
            _bubbleGrid[row][col] = new Bubble(2*RADIUS*(col/2) + 2*RADIUS, 2*RADIUS*row + RADIUS, 1);
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
           _bubbleGrid[row][col] = new Bubble(2*RADIUS*(col/2) + RADIUS , 2*RADIUS*row +RADIUS , 1);
          
         }
         else {
             _bubbleGrid[row][col] = new Bubble(RADIUS, 2*RADIUS*row +RADIUS, 1);
          }
        }
      }
    }
  }//end populate()
  
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