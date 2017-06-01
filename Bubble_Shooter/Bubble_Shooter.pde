Bubble playBubble;
PVector playBubbleVector;
boolean _inMotion;
PVector mouseClick;
BubbleGrid _bubbleField; 

static final float SPEED = 20;


void setup() {
  size(421, 600);
  playBubble = new Bubble();
  _inMotion = false;
  _bubbleField = new BubbleGrid(); 
  noStroke();
}

void draw() {
  background(255, 255, 255);
  launch(playBubble);
  drawAll();
}

void createAngleVector() {
  mouseClick = new PVector(mouseX, mouseY);
  playBubbleVector = new PVector(playBubble._xcor, playBubble._ycor);
  mouseClick.sub(playBubbleVector);
}

void launch(Bubble b) {
  if (_inMotion) {
    b.move();
  }
}

//adjusts the dx and dy of the Bubble based on the angle of movement decided by the mouse
void adjustByAngle(Bubble b) {
  if (mouseClick.x != 0) {
    float m = mouseClick.y/mouseClick.x;
    b.setDx(b.getDx() + 4);
    b.setDy(b.getDx() * m);
    float adjuster = sqrt(SPEED*SPEED/(b.getDx()*b.getDx() + b.getDy() *b.getDy()));
    b.setDx(b.getDx() *adjuster);
    b.setDy(b.getDy() * adjuster);
    if (mouseClick.x < 0) {
      b.setDx(b.getDx() * -1);
      b.setDy(b.getDy() * -1);
    }
  }
}

void mouseClicked() {
  if (!_inMotion) {
    _inMotion = true;  
    createAngleVector();
    adjustByAngle(playBubble);
  }
}

void createPointer(Bubble b) {
  if (!_inMotion) { 
    float xChange = mouseX - playBubble._xcor;
    float yChange = mouseY - playBubble._ycor;
    float angle;
    if (xChange == 0) {
      angle = (-1 *PI)/2;
    } else {
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
    float startX = playBubble._xcor;
    float startY = playBubble._ycor;
    float endX = startX;
    float endY = startY;
    while ((startX >= 0) && (startX <= width) && (startY >= 0) && (startY <= height)) {
      //println(angle);
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

void drawAll() {
  createPointer(playBubble);
  _bubbleField.show();
  playBubble.show();
}