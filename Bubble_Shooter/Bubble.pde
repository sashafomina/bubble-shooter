import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;


public class Bubble {
    private int _state;
    private int _color;
    private float _radius;
    private float _dx;
    private float _dy;
    private float _xcor;
    private float _ycor;
    private ArrayList<Bubble> _neighbors;

    public static final int  RED = 0;
    public static final int BLUE = 1;
    public static final int YELLOW = 2;
    public static final int GREEN = 3;
    public static final int PINK = 4;
    
    public static final int RADIUS = 20;

    //------CONSTRUCTORS------
    public Bubble(float x , float y ,float dx, float dy, int ncolor, int state){
      _radius = RADIUS;
      _neighbors = new ArrayList(6);
      _xcor = x; 
      _ycor = y;
      _dx = dx;
      _dy = dy;
      _color = ncolor;
      _state = state;
    }
    
    public Bubble(float x , float y, int state){
      this (x , y , 0 , 0 , (int) random(0,5) , state);
    }
    
    public Bubble(){
      this(width/2, height - 45, 0 , 0, (int) random(0,5), 1);
    }

    //------ACCESSORS------
    //returns radius of the bubble 
    public float getRadius(){
      return _radius;
    }
    
    //returns the Color of the bubble
    public int getColor(){
	    return _color;
    }//O( )

    //returns the state of the bubble
    public int getState(){
	    return _state;
    }//O( )

    //returns the x velocity of the bubble
    public float getDx(){
	    return _dx;
    }//O( )

    //returns the y velocity of the bubble
    public float getDy(){
	    return _dy;
    }//O( )

    //returns the x cor of the bubble
    public float getXcor(){
	    return _xcor;
    }//O( )

    //returns the y cor of the bubble
    public float getYcor(){
	    return _ycor;
    }//O( )

    //returns the neighbors of the bubble
    public ArrayList<Bubble> getNeighbors(){
	     return _neighbors;
    }//O( )
   
    //------MUTATORS------

    //sets the Color of the bubble
    public void setColor(int newColor){
      _color = newColor;
    }//O( )

    //sets the State of the bubble
    public void setState(int newState){
      _state = newState;

    }//O( )

    //sets the radius of the bubble
    public void setRadius(float newRadius){
      _radius = newRadius;
    }//O( )

    //sets the x velocity of the bubble
    public void setDx(float newVelocity){
      _dx = newVelocity;
    }//O( )

    //sets the y velocity of the bubble
    public void setDy(float newVelocity){
      _dy = newVelocity;
    }//O( )

    //sets the x cor of the bubble
    public void setXcor(float newCor){
      _xcor = newCor;
    }//O( )

    //sets the y cor of the bubble
    public void setYcor(float newCor){
      _ycor = newCor;
    }//O( )

    //------OTHER METHODS------

    //determines how a bubble moves given certain states
    public void move(){
      _xcor += _dx;
      _ycor += _dy;
      bounce();
      
    }//O( )

    //determines how a bubble behaves when it reaches a wall
    public void bounce(){
	      if( _xcor <= 0 || _xcor >= width){
           _dx *= -1;
         }
         if (_ycor <= 0 || _ycor >= height){
           _dy *= -1;
         }
    }//O( )
    
    public boolean inContact(Bubble other){
      float x2 = other.getXcor();
      float y2 = other.getYcor();
      float r2 = other.getRadius();
      return dist(_xcor, _ycor, x2, y2) <= r2 + _radius; 
    }
  
   
    //returns the number of bubbles directly touching the bubble in question 
    public int numActiveNeighbors(){
        int count = 0;
        for (Bubble b : _neighbors){
          if (b.getState() == 1){
            count ++;
          }
        }
        return count;
    }//O( )

    //returns an ArrayList containing all of a bubble's neighbors that share its color.
    public ArrayList<Bubble> getSameNeighbors(){
        ArrayList sameNeighbors = new ArrayList();
        for (Bubble b : _neighbors){
          if (b.getColor() == _color){
            sameNeighbors.add(b);
          }
        }
        return sameNeighbors;
    }//O( )


    public void show(){
      if (_state == 1){
        if (_color == BLUE){
          fill(10,27,216);
        
        }
        else if (_color == RED){
          fill (216, 10,10);
        }
        else if (_color == YELLOW){
          fill(229,255,2);
        }
        else if (_color == GREEN){
          fill(25, 244, 9);
        }
        else if (_color == PINK){
          fill(255, 0 ,250);
        }
        ellipse(_xcor, _ycor, 2*_radius, 2*_radius);
      }
   }
}