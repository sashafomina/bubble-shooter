  Bubble test;
  boolean _inMotion;
  PVector mouseClick;
  PVector center;
  BubbleGrid _bubbleField; 
  
  static final float SPEED = 12;

  
  void setup(){
     size(421, 600);
     test = new Bubble();
     _inMotion = false;
     center = new PVector(test.getXcor(), test.getYcor());
     _bubbleField = new BubbleGrid(); 
     noStroke();
  }
  
  void draw(){
    background(255,255,255);
    launch(test);
    if (_inMotion && _bubbleField.stick(test) != null){
      test.setDx(0);
      test.setDy(0);
      _bubbleField.whichNeighbor(test); 
      _inMotion = false;
       test = new Bubble();  
    }
    drawAll();

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
      if (mouseClick.y > 0){
        m = 0;
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
    
  void drawAll(){
    createPointer(test);
    _bubbleField.show();
    test.show();
    
  }
  