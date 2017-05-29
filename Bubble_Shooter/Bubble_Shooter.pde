  Bubble test;
  boolean _inMotion;
  
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

  void launch(Bubble b){
    if (_inMotion){
      b.move();
    }
  }
  
  
  void mouseClicked(){
    if (!_inMotion){
      _inMotion = true;  
    }
  }
  

  void drawAll(){
    test.show();
  }
  