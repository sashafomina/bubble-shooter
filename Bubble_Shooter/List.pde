/*****************************************************
 * Mr. Brown Mykolyk's code from the library
 * interface List -- subset of actual Java List interface
 * Specifies actions a List must be able to perform.
 * If present in local dir, will take precedence over Java's 
 * built-in List interface.
 *****************************************************/

public interface List<T> { 

    public boolean add( T x ); 

    public T get( int i ); 

    public T set( int i, T x ); 

    public int size();
    
    public T remove();
}