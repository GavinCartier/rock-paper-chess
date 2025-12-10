# Rock, Paper, Chess! #

![Main Menu](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/main%20menu.png?raw=true)

## Summary ##

Chess combined with Rock, Paper, Scissors. Players start by taking turns assigning each piece to a type of Rock, Paper, or Scissors. Instead of directly capturing enemy pieces like in normal Chess, we have a ‘challenge’ system in which each type of piece has its own base stats of Damage and Health. When you challenge an enemy piece, you deal damage to its health value, which is determined by your base damage stat and the type matchup between the two pieces.

## Project Resources

[Web-playable version](https://reillydunnucdavis.itch.io/rock-paper-chess)

[Proposal](https://docs.google.com/document/d/1R2_ADIK6n0Gfldgpfdc70Q1aaqAm14DkJqM3c9yRP9o/edit?usp=sharing)  

## Gameplay Explanation ##

Everything in the game is done with left click.

![Drafting](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/drafting%20in%20game.png?raw=true)

The game begins with the Drafting Phase, in which players take turns assigning types to each class of chess piece. White starts by making only 1 selection, then Black makes two, then White makes 2, and so on until every piece has been assigned a type.
This means that in each round of drafting, you will be making a decision and responding to the other player's decision. You'll have a chance to give one of your pieces the advantage over one of the other player's, but you'll also be opening yourself up to letting your opponent pick an advantageous type against you.
You want to consider which of your pieces you want to have an advantage over which enemy piece. For example, if your opponent selects Rock Pawns, you may want to select Paper Pawns to give yourself an advantage in the early game. 
Another thing to consider is the order in which you assign pieces. If you start by assigning a type to your King or Queen, your enemy can use that information and set more of their pieces to counter your most important pieces. So you probably want to start by assigning types to your weaker pieces like your Pawns or Bishops.

![Board game](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/board%20game.png?raw=true)

After Drafting is complete, you'll move into the main board game. You can try to apply traditional Chess strategies, such as trying to take control of the center of the board. Or you can explore the new strategies that are possible with the type advantage system. If you have a piece with many type advantages, you can be aggressive and send it deep into enemy territory. You can also make use of the way Checks don't force you to resolve them; maybe it's okay to let your King take some damage if you know it will survive? The King has low health, but high damage, so you can risk letting an enemy piece get close in order to defeat it with the King.

# External Code, Ideas, and Structure #

### Grayscale filter

assets/grayscale.gdshader

Grayscale shader created by following this tutorial (with some minor custom changes applied):

[“How to Make a Simple Greyscale Shader in Godot” by Max O’Didily on YouTube](https://youtu.be/-Ks-Wu8R2KQ)

### Camera Shake

scripts/chess_cam.gd

Camera shake logic created by following this tutorial (with some minor custom changes applied):

[“Quality Screen Shake in Godot 4.4 | Game Juice” by Mostly Mad Productions on YouTube](https://youtu.be/pG4KGyxQp40)


# Team Member Contributions

## Reilly Dunn ##

Main role: Technical Artist

Subrole: Game Feel

I was our group’s Technical Artist and Game Feel person. This meant I was responsible for implementing the assets into the game in a way that is visually satisfying and makes it clear what’s going on in the game. I found that there was a lot of overlap between the Technical Artist and Game Feel roles, so it makes sense to describe my contributions in a single section.
In my capacity in these roles, my contributions include:
- Implemented logic for hovering over a chess piece
- ![Hovering Over Pieces](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/tile%20glows.png?raw=true)
  - Highlights the spaces the piece can move to
    - Wrote logic that takes the set of spaces each piece type could move to and returns the subset of those that are legal moves (except for the Castling system)
    - On each legal space, show a highlight to indicate to the player they can move there
    - If an enemy piece is on that square, the color of that highlight changes to reflect the type advantage (red = disadvantage, yellow = neutral, green = advantage)
- Create “rules” button in the chess board scene that shows and hides a pop-up describing the game’s rules
- Add an on-screen warning for when the current player’s king can be attacked by one of the other player’s pieces
  - This involved creating the warning asset, and writing logic to detect when this condition is true
- Animated how the pieces move around the board scene
- ![Piece Movement](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/challenge%20gif.gif?raw=true)
  - When moving to an empty space:
    - The piece glides over to its new position. As it does so it grows larger until halfway through the movement, then shrinks back to the original size. This creates the feeling of the piece being physically lifted up and set down onto the new spot
  - In a challenge:
    - The attacking piece moves on top of the defending piece
    - The camera shakes
    - If the defending piece dies:
      - It gets smaller and moves to the graveyard area
    - Wrote logic to determine where in the graveyard the sprite should land depending on how many pieces are in the graveyard already
  - If the defending piece survives, the attacking piece moves away
- Created everything that drives the cutscene
- ![Cutscene in Editor](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/cutscene%20editor.png?raw=true)
  - Moving the characters around the screen
  - Text boxes that update with the character’s name and line of dialog
  - Animating the mouth of the character speaking so it looks like they’re talking
  - Made the character who isn’t speaking slightly darker so it’s clear who is and isn’t talking
  - Show and hide visualizations of the gameplay concepts being discussed in the cutscene
  - Skip cutscene button
- Improvements to drafting phase’s UI to help with clarity of what’s going on
- ![Drafting in Editor](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/drafting%20editor.png?raw=true)
  - Add piece sprites to UI
    - Pieces that have not yet been assigned a type have a custom shader applied that makes the sprites grayscale and transparent
    - When a piece is assigned a type that shader is removed to make it clear what selections have been made
- Wrote the logic for the indications of whose turn it is
  - I wrote the logic that lets the indicator keep track of whose turn it is, and change state when the current player changes
    - In the drafting scene, the turn indicator moves up and down
    - In the chess board scene, it’s animated to look like it flips over as if it’s a coin
- Create a “legend” sprite that shows which colors correspond to rock, paper, and scissors, and their advantage and disadvantage relationships (present in both drafting and main board game)
- Located royalty-free audio online for the game’s music and most of the sound effects

Contributions outside of my main and sub roles:
- The underlying logic for the drafting phase
- Various bug fixes
- Created a demo build for the 12/8 presentation (to fit in the 5 minute time limit)
  - The build has a much shorter cutscene, no pawns, and a banner sprite indicating that it’s the demo build

