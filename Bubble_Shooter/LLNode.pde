/*****************************************************
 * class LLNode
 * Implements a node, for use in lists and other container classes.
 *****************************************************/

public class LLNode<T> 
{

    private T _cargo;    //cargo may only be of type String
    private LLNode<T> _nextNode; //pointer to next LLNode

    // constructor -- initializes instance vars
    public LLNode( T value, LLNode next ) 
    {
	_cargo = value;
	_nextNode = next;
    }


    //--------------v  ACCESSORS  v--------------
    public T getCargo() { return _cargo; }

    public LLNode getNext() { return _nextNode; }
    //--------------^  ACCESSORS  ^--------------


    //--------------v  MUTATORS  v--------------
    public T setCargo( T newCargo ) 
    {
	T foo = getCargo();
	_cargo = newCargo;
	return foo;
    }

    public LLNode setNext( LLNode newNext ) 
    {
	LLNode foo = getNext();
	_nextNode = newNext;
	return foo;
    }
    //--------------^  MUTATORS  ^--------------


    // override inherited toString
    public String toString() { return _cargo.toString(); }


    
}//end class LLNode