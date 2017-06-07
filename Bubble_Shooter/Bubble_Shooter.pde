  Bubble test; //The bubble that is going to be shot
  boolean _inMotion; //Whether or not the bubble has been released
  PVector mouseClick;
  PVector center; 
  boolean _lose; //Whether player has lost the game
  boolean _win; //Whether player has won the game
  BubbleGrid _bubbleField;  //The game board
  ALQueue<Bubble> _upNext; //Queue of upcoming bubbles
  int _turn; //The turn numner; used to keep track of when to update the game board
  int _gameScreen; //Whether or not the start screen, end screen, or the actual game is currently in use
  PImage _initial; //pictures
  PImage _end; //background images
  PFont _font; //font
  
  static final float SPEED = 12; //speed of bubble
  static final int MAXROW = 12; //Red line that if the bubbles exceed the game will be over
  static final int RADIUS = 20;  //radius of bubble

  //Setting up the initial game board  
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
     populateQueue(); //Creates the three bubbles the queue starts with
     test = _upNext.dequeue();
     _upNext.enqueue(new Bubble());
     center = new PVector(test.getXcor(), test.getYcor());
     noStroke();
  }
  
  void draw(){
    if (_gameScreen == 0){ //Start screen
      initScreen();
    }
    if (_gameScreen == 1 &&!_lose && !_win){ //The actual game
      background(255,255,255);
      launch(test);
      snap();
      shiftDown();
      checkLose();
      checkWin();
      drawAll();
    }
    else if (_lose) { //The end screen
      delay(1000);
      background(255,255,255);
      gameOverScreen();
    }
    else if (_win){
      delay(1000);
      background(255,255,255);
      gameOverScreen();
    }
  }
  
  //Creating the start screen
  void initScreen(){
     background(_initial);
     fill(252, 252, 252);
     textAlign(CENTER);
     textSize(50);
     text("Bubble Shooter", 200, 70);
     textSize(20);
     text("Click Anywhere to Begin", 200, 100);
     fill(175,175,0);
  }
  
  //Creating the end screen
  void gameOverScreen(){
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
     text("Your Score is: " + _bubbleField.getScore(), 200, 300);
     text("Largest Cluster of Bubbles Popped: " + _bubbleField.getLargestCluster(), 200, 340);
  }
  
  //Restarts the game after game is over
   void restarting(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      setup();
      _gameScreen = 1;  
    } 
  }  
  
  //Snaps the bubble that is travelling into place 
  void snap(){
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
  
  //Replacing the bubble that was just launched by another bubble from the queue
  void recharge(){ 
    test = _upNext.dequeue(); 
    _upNext.enqueue(new Bubble());
  }
  
  
  void createAngleVector() {
    mouseClick = new PVector(mouseX, mouseY);
    mouseClick.sub(center);
  }
  
  //Launching the bubb;e
  void launch(Bubble b){
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
    if (_gameScreen == 0){ //When clicked while in the start screen, the game begins
      _gameScreen = 1;
    }
    else if (_gameScreen == -1 || _gameScreen == 2){ //When clicked while in the end game screen, the game restarts
      restarting(125, 425, 150, 80);
    }
    else if (_gameScreen == 1){ //When clicked while in game, the bubble is set in motion.
      if (!_inMotion){
        _inMotion = true;  
        createAngleVector();
        adjustByAngle(test); 
      }
    }
  }
  
  //Creates a dotted line to help the player aim the bubble
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
  
  
  void populateQueue(){ //Creates a new queue of bubbles
    for (int x = 0 ; x < 3 ; x++){
      _upNext.enqueue(new Bubble());
    }
  }
  
  void shiftDown(){ //Depending on how many turns have elapsed, the bubble grid will shift down one.
    if(_turn % 5 == 0 && _bubbleField.getCountNonPop() != 0){
      _turn ++;
      _bubbleField.setCountNonPop(0);
      _bubbleField.moveDown();
    }
    
  }
  
  //If in the bubble grid, bubbles have exceeded one less than the maximum row, then the player has lost.
  void checkLose(){ 
     for (int col = 0 ; col < _bubbleField.getBubbleGrid()[0].length ; col++){
       if (_bubbleField.getBubbleGrid()[MAXROW-1][col] != null && _bubbleField.getBubbleGrid()[MAXROW-1][col].getState() == 1){
         _lose=true;
         _gameScreen = -1;
         return;
       }
     }
     _lose = false;
  }
  
  //If there are no active bubbles in the bubble field, then the player has won.
  void checkWin(){
    for (int col = 0; col < _bubbleField.getBubbleGrid()[0].length; col++){
      if (_bubbleField.getBubbleGrid()[0][col] != null && _bubbleField.getBubbleGrid()[0][col].getState() == 1){
        return;
      }
    }
    _win = true;
    _gameScreen = 2;
  }
  
  void loseLine(){ //Visually displays the red line for losing the game
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
  