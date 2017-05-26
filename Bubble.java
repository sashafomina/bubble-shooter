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
    private static final int SPEED = 7;

    //------CONSTRUCTOR------
    public Bubble(){

    }

    //------ACCESSORS------

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

    }//O( )

    //sets the State of the bubble
    public void setState(int newState){

    }//O( )

    //sets the radius of the bubble
    public void setRadius(float newRadius){

    }//O( )

    //sets the x velocity of the bubble
    public void setDx(float newVelocity){

    }//O( )

    //sets the y velocity of the bubble
    public void setDy(float newVelocity){

    }//O( )

    //sets the x cor of the bubble
    public void setXcor(float newCor){

    }//O( )

    //sets the y cor of the bubble
    public void setYcor(float newCor){

    }//O( )

    //------OTHER METHODS------

    //determines how a bubble moves given certain states
    public void move(){

    }//O( )

    //determines how a bubble behaves when it reaches a wall
    public void bounce(){
	
    }//O( )

    //returns the number of bubbles directly touching the bubble in question
    public int numNeighbors(){

    }//O( )

    //returns an ArrayList containing all of a bubble's neighbors that share its color.
    public ArrayList<Bubble> getSameNeighbors(){

    }//O( )

    //returns whether a bubble has bubbles on top of it
    public  boolean NeighborsonTop(){

    }//O( )
}
