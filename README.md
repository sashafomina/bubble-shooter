# Bubble Shooter
<p> StringCheese </p>
<p> APCS Pd 4: Sasha Fomina, Kevin Li, Daniel Ju </p>

<h2> Launch Instructions </h2>
<ol>
<li> Open file in Processing </li>
<li> Run </li>
</ol>

<h2> Description </h2>
<h3> Front </h3>
<p> The user is presented with a hex-grid of bubbles of various colors, connected to one another, "hanging" from the top of the playing screen. They are required to aim a bubble and shoot it from the bottom of the screen. Based on which bubble it connects to, bubbles will either do nothing, pop, or a special power-up will be activated. Game features include undo, and settings to change difficulty level and visual themes. <p>
<h3> Back </h3>
<p> Using processing, a game-board is set up with instances of bubble. The bubble class is equipped to determine what to do when it is matched with a certain other bubble. Using Processing's ability to track mouse movement, a moving line helps aim bubbles. A queue is used to shoot new bubbles, a stack is used to implement the undo feature, and sorting algorithms allow us to show the user game data and statistics after they lose.
