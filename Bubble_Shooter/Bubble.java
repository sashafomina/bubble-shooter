import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;
import java.lang.Math;

public class Bubble {
    private int _state;
    private int _color;
    private double _angle;
    private ArrayList<Bubble> _neighbors;
    private float _dx;
    private float _dy;
    private float _xcor;
    private float _ycor;

    public static final int RED = 0;
    public static final int BLUE = 1;
    public static final int YELLOW = 2;
    public static final int GREEN = 3;
    public static final int PINK = 4;

    private static final int SPEED = 7;
    
    public Bubble(){
      _color = (int) (Math.random() * 6);
      _xcor = 225;
      _ycor = 600;
    }
}