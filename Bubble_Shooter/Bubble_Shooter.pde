  Bubble test;
  boolean _inMotion;
  PVector mouseClick;
  PVector mouse;
  PVector center;
  static final float SPEED = 7;
  
  void setup(){
     size(450, 600);
     test = new Bubble();
     _inMotion = false;
     center = new PVector(test.getXcor(), test.getYcor());
     noStroke();
  }
  
  void draw(){
    background(255,255,255);
    //createPointer(test);
    launch(test);
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
      float m = mouseClick.y/mouseClick.x;
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
      //System.out.println(mouse.x);
      //System.out.println(width/2);
    }
  }
  
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
      println(angle);
      float newX = center.x + cos(angle) * 80;
      float newY = center.y + sin(angle) * 80;
      stroke(0);
      strokeWeight(2);
      line(center.x, center.y, newX, newY);
      noStroke();
    }
  }
 
  void drawAll(){
    test.show();
    createPointer(test);
  }
  