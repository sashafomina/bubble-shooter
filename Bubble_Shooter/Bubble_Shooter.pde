  Bubble test;
  boolean _inMotion;
  PVector mouseClick;
  PVector center;
  boolean _lose;
  boolean _win;
  BubbleGrid _bubbleField; 
  ALQueue<Bubble> _upNext;
  int _turn;
  int _gameScreen;
  PImage _initial;
  PImage _end;
  PFont _font;
  
  static final float SPEED = 12;
  static final int MAXROW = 12;
  static final int RADIUS = 20; 

  
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
     populateQueue();
     test = _upNext.dequeue();
     _upNext.enqueue(new Bubble());
     center = new PVector(test.getXcor(), test.getYcor());
     noStroke();
  }
  
  void draw(){
    if (_gameScreen == 0){
      initScreen();
    }
    if (_gameScreen == 1 &&!_lose && !_win){
      background(255,255,255);
      launch(test);
      snap();
      shiftDown();
      checkLose();
      checkWin();
      drawAll();
    }
    else if (_lose) {
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
  
  void initScreen(){
     background(_initial);
     fill(252, 252, 252);
     textAlign(CENTER);
     textSize(50);
     text("Bubble Shooter", 200, 70);
     textSize(20);
     text("Click Anywhere to Begin", 200, 100);
     fill(175,175,0);
     /*
     rect(x1, y1, w1, h1);
     rect(x2, y2, w2, h2);
     rect(x3, y3, w3, h3);
     textSize(20);
     fill(175, 100, 220);
     text("Easy Regular", 200, 125);
     text("Hard Regular", 200, 250);
     text("Arcade Mode", 200, 375);
     */
  }
  
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
  
   void restarting(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      setup();
      _gameScreen = 1;  
    } 
  }  
  
  
  void snap(){
    if (_inMotion && _bubbleField.stick(test) != null){
      _turn ++;
      test.setDx(0);
      test.setDy(0);
      Bubble correct = _bubbleField.whichNeighbor(test); 
      _inMotion = false;
      //println(correct.getNeighbors().size());
      _bubbleField.createCluster(correct);
      _bubbleField.pop();
      recharge();
      
    }
  }
  
  void recharge(){
    test = _upNext.dequeue(); 
    _upNext.enqueue(new Bubble());
  }
  
  void createAngleVector() {
    mouseClick = new PVector(mouseX, mouseY);
    mouseClick.sub(center);
  }
  
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
    if (_gameScreen == 0){
      _gameScreen = 1;
    }
    if (_gameScreen == -1 || _gameScreen == 2){
      restarting(125, 425, 150, 80);
    }
    else if (_gameScreen == 1){
      else if (!_inMotion){
        _inMotion = true;  
        createAngleVector();
        adjustByAngle(test); 
      }
    }
  }
  
  /*
  void createPointer(Bubble b){
    if (!_inMotion){ 
      float xChange = mouseX - center.x;
      float yChange = mouseY - center.y;
      float angle;
      if (xChange == 0) {
        angle = (-1 *PI)/2;
      }
      else {
        angle = atan(yChange/xChange);
        //println(mouseX);
        if (mouseX < b.getXcor()){
            angle = PI + angle;
         }
        if (angle < PI && angle > PI/2){
          angle = PI;
        }
        else if (angle > 0 && angle < PI/2 ){
          angle = 0;
        }
      }
      //println(angle);
      float newX = center.x + cos(angle) * 175;
      float newY = center.y + sin(angle) * 175;
      stroke(0);
      strokeWeight(2);
      line(center.x, center.y, newX, newY);
      noStroke();
    }
  }
  */
  
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
  
  
  void populateQueue(){
    for (int x = 0 ; x < 3 ; x++){
      _upNext.enqueue(new Bubble());
    }
  }
  
  void shiftDown(){
    //println(_turn);
    if(_turn % 5 == 0 && _bubbleField.getCountNonPop() != 0){
      println("ITS HERE: " + _turn);
      _turn ++;
      _bubbleField.setCountNonPop(0);
      _bubbleField.moveDown();
    }
    
  }
  
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
  
  void checkWin(){
    for (int col = 0; col < _bubbleField.getBubbleGrid()[0].length; col++){
      if (_bubbleField.getBubbleGrid()[0][col] != null && _bubbleField.getBubbleGrid()[0][col].getState() == 1){
        return;
      }
    }
    _win = true;
    _gameScreen = 2;
  }
  
  //void winPage()
  //void losePage()
  
  void loseLine(){
    stroke(255, 0 ,0 ); 
    line(0 , 2*RADIUS*MAXROW- RADIUS, width, 2*RADIUS*MAXROW - RADIUS);
    noStroke();
  }
    
  void drawAll(){
    loseLine();
    createPointer(test);
    _bubbleField.show();
    test.show();
    //_testq.show();
    _upNext.show();
  }
  