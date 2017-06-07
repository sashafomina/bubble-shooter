  Bubble test; // The bubble to be launched
  boolean _inMotion; //Whether or the bubble is in motion
  PVector mouseClick; 
  PVector center;
  boolean _lose; // Whether or not player has lost
  boolean _win; //Whether or not player has won
  BubbleGrid _bubbleField; //The game board
  ALQueue<Bubble> _upNext; //The queue of upcoming bubbles
  int _turn; //A counter to keep track of how many bubbles have been launched
  int _gameScreen; //A counter to keep track of which game screen to display
  PImage _initial; //background image
  PImage _end; //background image
  PFont _font; //the font
  
  static final float SPEED = 12; //Speed of bubbles
  static final int MAXROW = 12; //Maximum row that bubbles cannot exceed or else player loses
  static final int RADIUS = 20;  //Radius of bubbles

  
  void setup(){
     size(421, 600);
     _font = createFont("Arial Bold", 18);
     _gameScreen = 0;
     _initial = loadImage("bubbles.jpg");
     _end = loadImage("endBubbles.jpg");
     _inMotion = false;
     _turn = 1;
     _lose = false;
     _win = false;
     _bubbleField = new BubbleGrid(); 
     _upNext = new ALQueue<Bubble>();
     populateQueue();    //Creates the queue of upcoming bubbles
     test = _upNext.dequeue();
     _upNext.enqueue(new Bubble());
     center = new PVector(test.getXcor(), test.getYcor());
     noStroke();
  }
  
  void draw(){
    if (_gameScreen == 0){ //This is for the start screen
      initScreen();
    }
    if (_gameScreen == 1 &&!_lose && !_win){ //This is for the actual game
      background(255,255,255);
      launch(test);
      snap();
      shiftDown();
      checkLose();
      checkWin();
      drawAll();
    }
    else if (_lose) { //If the player loses
      delay(1000);
      background(255,255,255);
      gameOverScreen();
    }
    else if (_win){ //If the player wins
      delay(1000);
      background(255,255,255);
      gameOverScreen();
    }
  }
  
  void initScreen(){ //The start screen
     background(_initial);
     fill(252, 252, 252);
     textAlign(CENTER);
     textSize(50);
     text("Bubble Shooter", 200, 70);
     textSize(20);
     text("Click Anywhere to Begin", 200, 100);
     fill(175,175,0);
  }
  
  void gameOverScreen(){ //The end screen
     background(_end);
     fill(0, 0, 0);
     textFont(_font);
     textAlign(CENTER);
     textSize(45);
     if (_lose){
       text("YOU LOSE :(" , 200 , 60);
     }
     else {
       text("YOU WINNN!!" , 200, 60);
     }
     fill(255,255,255);
     rect(125, 425, 150, 80);
     fill(0);
     textSize(20);
     text("Start Again", 200, 475);
     fill(0,0,0);
     text("Your Score is: " + _bubbleField.getScore(), 200, 300); //Display player score
     text("Largest Cluster of Bubbles Popped: " + _bubbleField.getLargestCluster(), 200, 340); //Display largest popped cluster
  }
  
   void restarting(int x, int y, int w, int h){ //After end screen, restarting the game
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      setup();
      _gameScreen = 1;  
    } 
  }  
  
  
  void snap(){ //Adding a bubble into the bubble grid
    if (_inMotion && _bubbleField.stick(test) != null){
      _turn ++;
      test.setDx(0);
      test.setDy(0);
      Bubble correct = _bubbleField.whichNeighbor(test); 
      _inMotion = false;
      _bubbleField.createCluster(correct);
      _bubbleField.pop();
      recharge();
      
    }
  }
  
  void recharge(){ //Getting a bubble from the queue to replace the launched bubble
    test = _upNext.dequeue(); 
    _upNext.enqueue(new Bubble());
  }
  
  void createAngleVector() {
    mouseClick = new PVector(mouseX, mouseY);
    mouseClick.sub(center);
  }
  
  void launch(Bubble b){ //Setting the bubble in motion
    if (_inMotion){
      b.move();
    }
  }
  

  
  //adjusts the dx and dy of the Bubble based on the angle of movement decided by the mouse
  void adjustByAngle(Bubble b){
    if (mouseClick.x != 0){
      float m;
      //println(mouseClick.x);
      if (mouseClick.y > -12 && mouseClick.x < 0){
        m = tan(PI/12);
      }
      else if (mouseClick.y > -12 && mouseClick.x > 0){
        m = -1*tan(PI/12);
      }
      else{
        m = mouseClick.y/mouseClick.x;
      }
      b.setDx(b.getDx() + 4);
      b.setDy(b.getDx() * m);
      float adjuster = sqrt(SPEED*SPEED/(b.getDx()*b.getDx() + b.getDy() *b.getDy()));
      b.setDx(b.getDx() *adjuster);
      b.setDy(b.getDy() * adjuster);
      if (mouseClick.x < 0){
        b.setDx(b.getDx() * -1);
        b.setDy(b.getDy() * -1);     
      }
    }
    else {
      b.setDy(-1*SPEED);
    }
  }
  
  void mouseClicked(){
    if (_gameScreen == 0){ //At start screen
      _gameScreen = 1;
    }
    else if (_gameScreen == -1 || _gameScreen == 2){ //At end screen
      restarting(125, 425, 150, 80);
    }
    else if (_gameScreen == 1){ //To set the bubble in motion
      if (!_inMotion){
        _inMotion = true;  
        createAngleVector();
        adjustByAngle(test); 
      }
    }
  }
  
  void createPointer(Bubble b) {
   if (!_inMotion) { 
     float xChange = mouseX - test._xcor;
     float yChange = mouseY - test._ycor;
     float angle;
     if (xChange == 0) {
       angle = (-1 *PI)/2;
     } 
     else {
       angle = atan(yChange/xChange);
       //println(mouseX);
       if (mouseX < b.getXcor()) {
         angle = PI + angle;
        }
        if (angle < PI + PI/12 && angle > PI/2) {
         angle = PI + PI/12;
         //println(angle);
       } else if (angle > -1 * PI/12 && angle < PI/2 ) {
         angle = -1 * PI/12;
       }
     }
     float startX = test._xcor;
     float startY = test._ycor;
     float endX = startX;
     float endY = startY;
     while ((startX >= 0) && (startX <= width) && (startY >= 0) && (startY <= height)) {
       endX = startX + cos(angle) * 10;
       endY = startY + sin(angle) * 10;
       stroke(175);
       strokeWeight(2);
       line(startX, startY, endX, endY);
       startX = endX + cos(angle) * 10;
       startY = endY + sin(angle) * 10;
      }
     noStroke();
    }
  }
  
  
  void populateQueue(){ //Create queue of upcoming bubbles
    for (int x = 0 ; x < 3 ; x++){
      _upNext.enqueue(new Bubble());
    }
  }
  
  void shiftDown(){ //Creating a new row of bubbles at the top and moving everything down
    if(_turn % 5 == 0 && _bubbleField.getRecentPop() != 0){
      //println("ITS HERE: " + _turn);
      _turn ++;
      _bubbleField.setRecentPop(0);
      _bubbleField.moveDown();
    }
    
  }
  
  void checkLose(){ //Check to see if player has lost -- if bubbles have reached the second to last row of the bubble field
     for (int col = 0 ; col < _bubbleField.getBubbleGrid()[0].length ; col++){
       if (_bubbleField.getBubbleGrid()[MAXROW-1][col] != null && _bubbleField.getBubbleGrid()[MAXROW-1][col].getState() == 1){
         _lose=true;
         _gameScreen = -1;
         return;
       }
     }
     _lose = false;
  }
  
  void checkWin(){ //Check to see if there are bubbles still active in the bubble field
    for (int col = 0; col < _bubbleField.getBubbleGrid()[0].length; col++){
      if (_bubbleField.getBubbleGrid()[0][col] != null && _bubbleField.getBubbleGrid()[0][col].getState() == 1){
        return;
      }
    }
    _win = true;
    _gameScreen = 2;
  }

  void loseLine(){ //Creates the red line that delineates the boundary that bubbles can't exceed
    stroke(255, 0 ,0 ); 
    line(0 , 2*RADIUS*MAXROW- RADIUS, width, 2*RADIUS*MAXROW - RADIUS);
    noStroke();
  }
    
  void drawAll(){
    loseLine();
    createPointer(test);
    _bubbleField.show();
    test.show();
    _upNext.show();
  }
  