/***
 * class Latkes
 * (actually: a class to implement a stack of Strings)
 * uses an array as underlying data structure
 ***/
 
public class Latkes 
{

    private String [] _stack;
    private int _stackSize;

    //constructor
    public Latkes(int capacity) 
    { 
	_stack = new String[capacity];
	_stackSize = 0;
    }

    
    //means of insertion
    public void push( String s ) 
    {
	//create more storage space if necessary
	if ( isFull() ) {
	    String [] temp = new String[ _stack.length * 2 ];	
	    for( int i = 0; i < _stack.length; i++ ) {
		temp[i] = _stack[i];
	    }
	    _stack = temp;
	}
	_stack[_stackSize] = s;
	_stackSize++;
    }

    
    //means of removal
    public String pop( ) 
    { 
	String retStr = "";
	retStr = _stack[_stackSize---1];
	return retStr;
    }

    
    //chk for emptiness
    public boolean isEmpty() 
    { 
	return _stackSize == 0;
    }

    //chk for fullness
    public boolean isFull() 
    {
	return _stackSize >= _stack.length; 
    }

    public static void main( String[] args ) {

	Latkes tastyStack = new Latkes(10);

	tastyStack.push("foo");
	tastyStack.push("goo");
	tastyStack.push("hoo");
	tastyStack.push("joo");
	tastyStack.push("moo");
	tastyStack.push("loo");
	tastyStack.push("poo");
	tastyStack.push("qoo");
	tastyStack.push("zoo");
	tastyStack.push("choo");
	tastyStack.push("coocoo");

	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
	System.out.println( tastyStack.pop() );
    }//end main
    
}//end class Latkes

