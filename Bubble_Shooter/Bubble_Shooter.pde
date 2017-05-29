  Bubble test;
  boolean _inMotion;
  PVector mouse;
  PVector center;
  static final float SPEED = 7;
  
  void setup(){
     size(450, 600);
     test = new Bubble();
     _inMotion = false;
     noStroke();
  }
  
  void draw(){
    background(255,255,255);
    launch(test);
    drawAll();

  }
  
  void createAngleVector() {
    mouse = new PVector(mouseX, mouseY);
    center = new PVector(test.getXcor(), test.getYcor());
    mouse.sub(center);
  }
  
  void launch(Bubble b){
    if (_inMotion){
      b.move();
    }
  }
  
  //adjusts the dx and dy of the Bubble based on the angle of movement decided by the mouse
  void adjustByAngle(Bubble b){
    float m = mouse.y/mouse.x;
    b.setDx(b.getDx() + 4);
    b.setDy(b.getDx() * m);
    float adjuster = sqrt(SPEED*SPEED/(b.getDx()*b.getDx() + b.getDy() *b.getDy()));
    b.setDx(b.getDx() *adjuster);
    b.setDy(b.getDy() * adjuster);
    if (mouse.x < 0){
      b.setDx(b.getDx() * -1);
      b.setDy(b.getDy() * -1);
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
  

  void drawAll(){
    test.show();
  }
  