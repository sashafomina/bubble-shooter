  Bubble test;
  boolean _inMotion;
  PVector mouseClick;
  PVector center;
  BubbleGrid _bubbleField; 
  ALQueue<Bubble> _upNext;
  int _counter;
  boolean loseYet;
  int gameScreen = 0;
  int x1 = 125;
  int y1 = 75;
  int w1 = 150;
  int h1 = 80;
  int x2 = 125;
  int y2 = 200;
  int w2 = 150;
  int h2 = 80;
  int x3 = 125;
  int y3 = 325;
  int w3 = 150;
  int h3 = 80;
  boolean modeOne;
  boolean modeTwo;
  boolean modeThree;
  boolean restarting;
  PImage Bubs;
  //ALQueue<Bubble> _testq;
  
  static final float SPEED = 12;

  
  void setup(){
     size(421, 600);
     Bubs = loadImage ("bubbles.jpg");
     _inMotion = false;
     _bubbleField = new BubbleGrid(); 
     _upNext = new ALQueue<Bubble>();
     populateQueue();
     test = _upNext.dequeue();
     _upNext.enqueue(new Bubble());
     center = new PVector(test.getXcor(), test.getYcor());
     loseYet = false;
     stroke(0);
     noFill();
     modeOne = false;
     modeTwo = false;
     modeThree = false;
     restarting = false;
  }
  
  void draw(){
   if (gameScreen == 0){
      initScreen();
   }
   else if (gameScreen == 1){
      background(255,255,255);
      launch(test);
      snap();
      drawAll();
   } 
   else if (gameScreen == 2){
     gameOverScreen();
   }
  }
  
  
  void startGame(){
     gameScreen = 1; 
  }
  
  void initScreen(){
     background(Bubs);
     fill(250, 0, 0);
     textAlign(CENTER);
     textSize(30);
     text("Select Game Mode Below", 200, 50);
     fill(175,175,0);
     rect(x1, y1, w1, h1);
     rect(x2, y2, w2, h2);
     rect(x3, y3, w3, h3);
     textSize(20);
     fill(175, 100, 220);
     text("Easy Regular", 200, 125);
     text("Hard Regular", 200, 250);
     text("Arcade Mode", 200, 375);
  }
  
  void gameOverScreen(){
     background(150);
     fill(175, 100, 220);
     textAlign(CENTER);
     textSize(35);
     text("Game Over", 200, 50);
     fill(0,175,0);
     rect(125, 425, 150, 80);
     fill(255);
     textSize(20);
     text("Start Again", 200, 475);
  }
  
  void snap(){
    if (_inMotion && _bubbleField.stick(test) != null){
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
  
  void update(int x, int y) {
    if (gameScreen == 0){
      if ( ModeOne(x1, y1, w1, h1) ) {
          modeOne = true;
      } 
      else if ( ModeTwo(x2, y2, w2, h2) ) {
          modeTwo = true;
      } 
      else if ( ModeThree(x3, y3, w3, h3) ){
          modeThree = true;
      }
    }
    else if(gameScreen == 2){
      if ( ReStarting(125, 425, 150, 80)){
         restarting = true; 
      }
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
  
  boolean ModeOne(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean ModeTwo(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean ModeThree(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean ReStarting(int x, int y, int w, int h){
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      return true;
    } else {
      return false;
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
    if (gameScreen == 0){
      update (mouseX, mouseY);
      if (modeOne){
         _counter = 10;
         startGame();
      }
      else if(modeTwo){
        _counter = 8;
        startGame();
      }
      else if(modeThree){
        _counter = 10;
        startGame();
      }
    }
    else if (gameScreen == 1){
       if (!_inMotion){
        _inMotion = true;  
        createAngleVector();
        adjustByAngle(test);
        _counter -= 1;
      }
    }
    else if (gameScreen == 2){
        update (mouseX, mouseY);
        if (restarting){
          _bubbleField = new BubbleGrid();
          gameScreen = 0;
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
      float newX = center.x + cos(angle) * 80;
      float newY = center.y + sin(angle) * 80;
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
    
  void drawAll(){
    createPointer(test);
    _bubbleField.show();
    test.show();
    //_testq.show();
    _upNext.show();
    if(_counter == 0){
       _bubbleField.Redraw();
       _counter = 10;
    }
    loseYet = _bubbleField.checkGameStatus();
    if(loseYet){
       loseYet = false;
       gameScreen = 2;
    }
  }
  