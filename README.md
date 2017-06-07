# Bubble Shooter
<p> StringCheese </p>
<p> APCS Pd 4: Sasha Fomina, Kevin Li, Daniel Ju </p>

<h2> Launch Instructions from Terminal: </h2>
<ol>
<li> <code> $ git clone git@github.com:sfomina/StringCheese.git </code> </li>
<li> <code> $ cd StringCheese </code> </li>
<li> <code> $ processing Bubble_Shooter/Bubble_Shooter.pde </code> </li>
</ol>

<h2> Description </h2>
<h3> Front </h3>
<p> The user is presented with a hex-grid of bubbles of various colors, connected to one another, "hanging" from the top of the playing screen. They are required to aim a bubble and shoot it from the bottom of the screen. If a bubble creates a connection with 2 or more other bubbles of its color, it will pop, and any bubbles, regardless of color, that are hanging, will be popped as well. Once in a while, the bubbles will shift down a row, to make room for a new row of bubbles. If a bottom-most bubble reaches the red line, the game will be over. The user will be presented with game statistics, namely how many bubbles they popped and the greatest cluster popped. They will be given the option to restart the game.  <p>
<h3> Back </h3>
<p> Using processing, a game-board is set up with instances of bubble. The bubble class is equipped to determine what to do when it is matched with a certain other bubble. A BubbleGrid class sets the playing screen and how clusters are formed and popped. Using Processing's ability to track mouse movement, a moving line helps aim bubbles. A queue is used to shoot new bubbles, and other semester II concepts, such as recursive backtracking, are used to make the game function.

<h2> Credits </h2>
<p> We implemented Mr. Brown's versions of ALQueue, LLNode, LList, and the List and Queue interfaces, from the library. We would also like to thank him for an awesome year of APCS and for teaching us what we needed to create this project!</p>
