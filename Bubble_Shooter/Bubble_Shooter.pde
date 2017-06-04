  Bubble test;
  boolean _inMotion;
  PVector mouseClick;
  PVector center;
  BubbleGrid _bubbleField; 
  ALQueue<Bubble> _upNext;
  //ALQueue<Bubble> _testq;
  
  static final float SPEED = 12;

  
  void setup(){
    //_testq = new ALQueue<Bubble>();
     //_testq.enqueue(new Bubble(0));
     //_testq.enqueue(new Bubble(0));
     //_testq.enqueue(new Bubble(4));
     size(421, 600);
     _inMotion = false;
     _bubbleField = new BubbleGrid(); 
     _upNext = new ALQueue<Bubble>();
     populateQueue();
     //test = new Bubble();
     test = _upNext.dequeue();
     _upNext.enqueue(new Bubble());
     center = new PVector(test.getXcor(), test.getYcor());
     //println(_upNext.peekFront());
     noStroke();
  }
  
  void draw(){
    background(255,255,255);
    launch(test);
    snap();
    drawAll();
  }
  
  
  
  void snap(){
    if (_inMotion && _bubbleField.stick(test) != null){
      test.setDx(0);
      test.setDy(0);
      _bubbleField.whichNeighbor(test); 
      _inMotion = false;
      test = _upNext.dequeue(); 
      //println(test.getColor());
      _upNext.enqueue(new Bubble());
    }
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
      println(mouseClick.x);
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
    if (!_inMotion){
      _inMotion = true;  
      createAngleVector();
      adjustByAngle(test); 
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
  }
  