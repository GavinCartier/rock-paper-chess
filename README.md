# Rock, Paper, Chess! #

## Summary ##

Rock, Paper, Chess!  is a turn-based chess game that introduces a strategic Rock, Paper, Scissors-type assignment mechanic. Players are prompted to a cutscene explaining the narrative/tutorial of our game, which is a battle between the Aristocrat (player 1) and the Cowboy (player 2). Before the game begins, players enter a “Drafting” phase, during which they take turns assigning Rock, Paper, or Scissors types to each category of their chess pieces. These choices significantly influence gameplay because in our version of chess, pieces are not simply captured; they must battle in a “Challenge”. Every piece on the board has its own health and damage stats. When two pieces engage in a “Challenge”, type advantages (following classic Rock, Paper, Scissors rules) allow the superior types to deal increased damage. Instead of achieving checkmate, a player wins by defeating the opponent’s king in combat. Aside from these additions, all chess pieces retain their traditional movement rules.

![Main Menu](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/main%20menu.png?raw=true)

## Project Resources

[Web-playable version](https://reillydunnucdavis.itch.io/rock-paper-chess)

[Intial Plan](https://docs.google.com/document/d/1R2_ADIK6n0Gfldgpfdc70Q1aaqAm14DkJqM3c9yRP9o/edit?usp=sharing)  

[Rock, Paper, Chess Progress Report Discussion Notes] (https://docs.google.com/document/d/1SKJJgBzz7TyQUmU2RUWdISAFGKn1s6Gl3_dxRyvKgeA/edit?tab=t.0#heading=h.x6bjmdz0ly1d ) 

[Progress Report of Black Rapsohdy Rabbit] (https://docs.google.com/document/d/1sqlWxQEwTkvB5rE3_c796FQBkte6ip863G7BRirKl0s/edit?usp=sharing)

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

`assets/grayscale.gdshader`

Grayscale shader created by following this tutorial (with some minor custom changes applied):

[“How to Make a Simple Greyscale Shader in Godot” by Max O’Didily on YouTube](https://youtu.be/-Ks-Wu8R2KQ)

### Camera Shake

`scripts/chess_cam.gd`

Camera shake logic created by following this tutorial (with some minor custom changes applied):

[“Quality Screen Shake in Godot 4.4 | Game Juice” by Mostly Mad Productions on YouTube](https://youtu.be/pG4KGyxQp40)

### Volume Slider

`scripts/menu/volume.gd`

The code used for the volume slider was taken from here, with minor changes to the code.

["Creating volume sliders in Godot 4" by The Shaggy Dev](https://www.youtube.com/watch?v=aFkRmtGiZCw)

### Tilemap Creation

`scenes/ChessBoard.tscn`

Create the tilemap for chessboard by referring to this tutorial.

["In Depth TILEMAP Tutorial For Godot 4.3+" by DevWorm](https://youtu.be/ZutpG0_CYrQ?si=xNeTdk1QAhrviBW9)

### Screen Coordinates Alined

`scripts/chess_board.gd`

The code used for get the correct position for pieces on chessboard based on the cemera zoom effects.

[Confusion about Screen Coordinates](https://forum.godotengine.org/t/confusion-about-screen-coordinates/97711/2)

Also referred Godot official tutorial/doc for tilemap:

[Godot Engine 4.4 documentation - TileMap](https://docs.godotengine.org/en/4.4/classes/class_tilemap.html)

# Team Member Contributions

## Reilly Dunn ##

Main role: Technical Artist

Subrole: Game Feel

I was our group’s Technical Artist and Game Feel person. This meant I was responsible for implementing the assets into the game in a way that is visually satisfying and makes it clear what’s going on in the game. I found that there was a lot of overlap between the Technical Artist and Game Feel roles, so it makes sense to describe my contributions in a single section.
In my capacity in these roles, my contributions include:
- Implemented logic for hovering over a chess piece
![Hovering Over Pieces](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/tile%20glows.png?raw=true)
  - Highlights the spaces the piece can move to
    - Wrote logic that takes the set of spaces each piece type could move to and returns the subset of those that are legal moves (except for the Castling system)
    - On each legal space, show a highlight to indicate to the player they can move there
    - If an enemy piece is on that square, the color of that highlight changes to reflect the type advantage (red = disadvantage, yellow = neutral, green = advantage)
- Create “rules” button in the chess board scene that shows and hides a pop-up describing the game’s rules
- Add an on-screen warning for when the current player’s king can be attacked by one of the other player’s pieces
  - This involved creating the warning asset, and writing logic to detect when this condition is true
- Animated how the pieces move around the board scene
![Piece Movement](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/challenge%20gif.gif?raw=true)
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
![Cutscene in Editor](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/cutscene%20editor.png?raw=true)
  - Moving the characters around the screen
  - Text boxes that update with the character’s name and line of dialog
  - Animating the mouth of the character speaking so it looks like they’re talking
  - Made the character who isn’t speaking slightly darker so it’s clear who is and isn’t talking
  - Show and hide visualizations of the gameplay concepts being discussed in the cutscene
  - Skip cutscene button
  - Wrote the dialog and named the characters
  	- Their names are puns; We referred to them as the "Aristocrat" and "Cowboy", so I gave them names that sound like the words Aristocrat and Cowboy when said out loud (Aris T. O'Cratt and C. W. Boye)
- Improvements to drafting phase’s UI to help with clarity of what’s going on
![Drafting in Editor](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/drafting%20editor.png?raw=true)
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
- Created a few simple assets using Krita
![Assets made by Reilly](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/reilly%20assets.png?raw=true)

## Lucia Zeng ##

Main role: UI and Input

Subrole: Accessibility and Usability

As a note: the way I fulfilled my subrole, accessibility and usability, was taken into consideration (and integrated) during the creation of the UI and assets, so I will not split them as seperate contributions.

Contributions:
- Implementation of the main menu and basic settings, with functioning buttons to start, open settings, and exiting the game
- Wrote the script and made the entire scene to open and close the settings.
- The addition of the of the stats of each piece on the side of the chessboard (when clicked, and was the player's own piece)
- Victory screen handling, made 2 victory screen scenes
	- This includes: the addition of the stats on the victory screen, a restart button, and its assets (complete list below the role contributions)
- Implementation of the main menu and basic settings, including the volume slider.
- Handled the logic for the statistics displayed text for both victory screens and the pieces when they were hovered on the chessboard

Miscellaneous contributions to the game (outside of my role):
- handled simple transition animations in between each scene using another scene called FadeTransition 
	- created the script, the scene, and the animation for both fading in and out of an offwhite color
- Made the scene and script for FadeTransition
- Updated the font of the drafting UI (for the drop down and the base buttons themselves) to match the rest of the game
- Made the following assets:

![replay_button](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/replay_button.png?raw=true) ![exit](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/exit_button.png?raw=true)
![Settings](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/Settings.png?raw=true) 
![white_winner](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/White_winner.png?raw=true) 
![black_winner](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/Black_winner.png?raw=true)

## Gavin Cartier

### Main role: Game Logic

As the game logic lead, I focused mainly on implementing several of the core game mechanics, as well as the data-based representation of the key game components such as the pieces and piece types. While the role description for game logic includes the implementation of a game manager singleton to manage game state and references, we found that such an approach would lead to bottlenecks in development as feature addition would require me having finished my entire role before others could begin. Instead, we opted for a decentralized approach with interconnected game state, and I adapted my role to focus on development of individual game features central to the game functionality.

**Piece Type Script** - I created and defined the variables within this script to serve as a singleton reference for the data that constitutes a chess piece. This includes enum variables for piece class, type, and owner. It also defines the health and damage stats for each piece class. I tested different stats for different pieces to see what promoted the most interesting gameplay, especially taking into account the damage bonuses for type advantages. This script also defines several static functions used in other scripts. [piece_type.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/models/piece_types.gd)

**Piece Script** - This is the actual class script for in-game pieces. I created this script and the variables that define it, such as class, type, owner, health, max health, damage, board location, as well as helper variables such as if the piece has moved or if it is dead. I also created the combat related functions for the pieces, such as receive_damage() and set_stats(). This script was later expanded upon to include functions for move options indication. [piece.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/models/piece.gd)

**Damage Engine Script** - I created the Damage Engine singleton to use for the piece challenges. This script defines the damage multipliers for Strong, Neutral, and Weak type matchups, and defines which matchups are considered Strong, Neutral and Weak based on the types defined in PieceType.gd. I also implemented the functions challenge() and its helper function, damage\_dealt(), to define challenge logic. [damage_engine.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/damage_engine.gd)

**Health Bar Component + Script** - I created the health bar that displays when pieces are hovered or selected. The health bar indicates the relative health remaining for the piece compared to its max health. When a selected piece is in range of an opponent piece, there is a flashing indicator on the opponent's piece to display how much damage a challenge would deal. This incentivizes more strategic decision-making without overwhelming the player with too much information. [health_bar.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/health_bar.gd)

**Castling Functionality** - I implemented castling as a move option for kings and rooks that have not yet moved and have clear spaces between them. The detection for this was implemented in the \_castling() static function in PieceTypes.gd. [_castling() in piece_types.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/models/piece_types.gd#L156)

**Pawn Promotion** - I implemented the detection, the selection prompt for, and the resetting of piece stats for when a pawn reaches the opposite side of a board. A player will have the option to select between a Knight, Bishop, Rook, or Queen for a pawn that reaches the other side. The pawn will inherit the stats of such piece while maintaining its type. [piece_graduation.gd](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scripts/piece_graduation.gd) [pawn_graduation.tscn](https://github.com/GavinCartier/rock-paper-chess/blob/main/rock-paper-chess/scenes/pawn_graduation.tscn)

### Subrole: Gameplay Testing

As the Gameplay Tester, I had 10 separate reviewers play our near-final version of the game and give feedback based on the Observations and Playtester Comments form. The reviewers I selected were friends and coworkers of mine. I made sure to select a variety of people that were familiar and unfamiliar with chess and video games as a whole in order to get a variety of perspectives. For some of the reviewers, limitations from scheduling or distance made it difficult to conduct reviewing sessions in person, on the same screen. As such, I created the following [google form](https://docs.google.com/forms/d/e/1FAIpQLScDjDRCHewWee6w2hA2qazvpr36ZEn4Q31VbMMfjMSxyo5tgQ/viewform?usp=header) so that such reviewers could evaluate the game using the itch.io link on their own time. 

As I was conducting the reviews, there were some questions on the form that I noticed didn't pertain as well to our game. For example, because some of the reviewers were conducting their reviews remotely, I decided not to include the "In-Game Questions" section to instead focus on comparing between the Postgame Questions. I applied similar logic with the "Graph your emotional investment" question as it was unfeasible to conduct. I also chose to eliminate the question "As you played, did the story evolve with the game?" as our game was not intended to have a developed story aside from the opening cutscene. This left 38 questions to ask per reviewer, which I deemed sufficient for getting a good perspective of the game for each. The full results and answers provided for each review can be found in [this spreadsheet](https://github.com/GavinCartier/rock-paper-chess/blob/main/readme%20images/Gameplay%20Testing%20Survey%20Results.xlsx).

Overall, feedback on the game was very positive, with many highlighting our art style, sound effects, and interfaces as parts of the game that they found attractive. Very few found difficulty understanding the controls, helped by the fact that the game is played entirely with the mouse. Reactions to the combat system were more mixed; most appreciated the twist on the classic game of chess, but some lamented the need for mental calculations of damage to plan ahead. While we do include displays of health and damage stats, such displays were not extremely apparent for some and others found them insufficient. Aside from that, the reviewers found the pace of play acceptable and described satisfaction when successfully using type advantages to capture a piece. One thing that surprised me was a near-unanimous consensus that all reviewers liked that they were playing against another human, as I expected that some would have wanted a single player option against an AI.

The results of the gameplay testing gave the reassurance that we had more or less accomplished what we wanted. While not all of the reviewers stated that they would buy this game, most cited a lack of knowledge/interesting of chess and strategy games as the reasoning, and not for an implementation fault on our part. Most stated that they would gift this game to someone in their life that plays chess, stating that it is a fun twist on the classic game. Given that this was the goal we set out to achieve with *Rock, Paper, Chess!*, this feedback was very comforting to hear.

Due to limitations of time and scope, the large-scale suggestions provided by the reviewers were deemed too ambitious to implement. However, there were several bugs revealed through the testing that we were able to fix before the final project submission. Such bugs include a bug related to [king check detection not working properly](https://github.com/GavinCartier/rock-paper-chess/commit/9b621404409241a1d8c8a71efd05e88dd0a48e3b), a glitch related to the [rook location not updating properly when castling](https://github.com/GavinCartier/rock-paper-chess/commit/4da5cf1bbb702274e2715e4e28a5093256b29733), and a bug where [health bar displays for promoted pawns were not updating properly](https://github.com/GavinCartier/rock-paper-chess/commit/b52ae2de1fc07a2c960ea722d66421b9c3d6277d). 

### Miscellaneous contributions
**Creating and setting up the Github Repository** - I created the Github Repository that this game is based on and [set up the Godot project architecture](https://github.com/GavinCartier/rock-paper-chess/commit/c94534eed8b16cd3e8333ed53e787353edec88ef) at the beginning. This included setting up the [Main and Chessboard scenes](https://github.com/GavinCartier/rock-paper-chess/commit/4a2a4790de9d1af61e1c393c566439c9a047cb3e). 

**Misellaneous bugfixing** - I fixed some of the bugs that showed up during the development process. [Health bar showing when not hovered](https://github.com/GavinCartier/rock-paper-chess/commit/4094a5c7df920c23a2dad8d87a3cb9be4edaf19e), [Turns not swapping](https://github.com/GavinCartier/rock-paper-chess/commit/df412863c1ae8f9e7610ed2a36e426f921340198), [Piece sizing getting messed up](https://github.com/GavinCartier/rock-paper-chess/commit/29b1bafb422c9e39cbed1a714c8a81a23f501224)


## Victoria Zhang ##

**Github: 1mVictoria**

**Main role: Animation and Visuals**

**Subrole: Player Onboarding -> Visual Cohesion and Style Guide**

Note: Since Reilley implemented the cutscene system early on and didn’t realize it overlapped with the my original subrole `Player Onboarding`, I shifted my subrole to `Visual Cohesion and Style Guide` during the later stages of the project. I also took on several game logic tasks, which will be explained below. 

There are a lot of overlaps between the `Animation and Visuals` and `Visual Cohesion and Style Guide`, so I will describe them together in a single section.

**Contributions:**
![prototype]( https://github.com/GavinCartier/rock-paper-chess/blob/fa138271d258f41bc2d7cd3b9100369e6e8c1a82/readme%20images/prototype.jpg) 
- Created most of the visual assets for the whole project, including the chess pieces, chessboard, character portraits, turn indicators, and the hand-drawn background.
- Made the looping main-menu video via Adobe After Effects, which loop for every 25s and connected it to the menu UI.
- Designed the early gamefeel prototype and the refined version later on, covering UI layout ideas, fonts, screen size, and the overall visual guide of the project.
- Set the cohesive visual style, found free-to-use backgrounds and added art effects for the cutscene scenes.
- Implemented the transition from the drafting scene to the chessboard scene.
- Added the turn indicator in the drafting scene and created the wiggle animation to improve gameplay experience.
- Updated the rules page as hovering to make the interface cleaner and to avoid conflicts between piece hover and rule page hover.

**Additional contributions in the Other Contributions section:**
- Initialized the chessboard via creating a tilemap and developed the basic `ChessBoard.tscn` layout.
- Initialized all pieces on the chessboard and set the corresponding textures for them.
- Added the movement logic for each singe piece based on the structure in ` piece_types.gd ` and implemented basic reactions to the player’s mouse inputs.

**Recources**
- [Fonts (free for personal use)]( https://github.com/GavinCartier/rock-paper-chess/tree/70af1b90b33595a47b15528892f10d6c1db8b401/rock-paper-chess/assets/font) 
- Including fonts: `Cochin Regular`, `bodoni-72-oldstyle-book`, `bodoni-72-smallcaps-book`
- [Cutscene Background Info]( https://unsplash.com/photos/a-room-with-a-table-chairs-and-a-bed-AREe9eMdK8Q) 
- [Assets Created by Own]( https://github.com/GavinCartier/rock-paper-chess/tree/ce9e618f099506592477d150447cf4d41200b6a3/rock-paper-chess/assets) 
- Folders includign `new placeholder`, `story`, `chessboard`, `characters`
![Assets Overview]( https://github.com/GavinCartier/rock-paper-chess/blob/fa138271d258f41bc2d7cd3b9100369e6e8c1a82/readme%20images/assets%20overview.jpg)

## Roop Nijjar ##

**Main Role:** Producer
**Sub-Role:** Build & Release Management

- Served as the primary point of contact for the project, communicating essential questions and updates to the professor and TA on behalf of the team.
  
- Prepared and submitted progress reports, including written updates and participation in progress-related discussions.

- Worked on the "summary" of ReadMe.md and the "scheduling" portion of intial plan.

- Conducted gameplay testing with multiple participants, both during scheduled discussion sessions and independently outside of them.

- Created and contributed to the project presentation slides / the actual game demo

- Organized and led team meetings, documented meeting notes, and assigned tasks required for project completion. Constant check-in and monitoring of Discord messages 

- Developed and refined U.I of drafting phase, including asset adjustments, drafting tutorial creation, chess piece rescaling, layout scaling, and drafting interface borders

- Implemented core chess movement algorithms and game logic at the beginning of the project. Later on, it was used to develop the main portion of our game 

- Created the foundation algorithm of the chessboard 

**Resources**

Here was some documentation related to my role, including meeting notes, the progress report i did for my team, gameplay testing findings, and a Gnatt Chart: https://docs.google.com/document/d/1kIB4USr9gDSW2sDW_pepmw7fntMR1_fyC8lqUGGykjk/edit?usp=sharing 

Drafting External Designs: 
![Screenshot 2025-12-10 at 8 25 22 PM](https://github.com/user-attachments/assets/ac7fc515-4a2f-48f7-84c4-04c04cb2c20c)


<img width="2560" height="1440" alt="Drafting" src="https://github.com/user-attachments/assets/dd9ca5bc-4073-4803-87e9-c0a18d5dff11" />

<img width="930" height="647" alt="drafting_tutorial" src="https://github.com/user-attachments/assets/4e1e6702-ad3b-4737-b648-47d07e50ef00" />


## Vivian Sun ##


**Main role: Level and World Design**
As the Level and World Designer for a chess game, there wasn't much to implement as there is only one board. The chessboard and world design was mainly taken care of by Game Logic and Visuals, so I aided in coding part of `damage_engine.gd` and some of the gameplay logic. 

**Subrole: Narrative Design -> Audio**
- Located and uploaded royalty-free audio for some of the game’s sound effects.
- Created an audio system `Sfx.gd` that plays sound effects and the background music globally.
- Created `AudioStreamPlayer` nodes for each audio file.
- Created audio buses that separated "sfx" from "bgm".
- Implemented sound effects within the game logic and UI button scripts.
- Implemented looping background music, with play/pause/resume functionality.
- Fixed up some audio bugs and unintentional sound looping.
- Participated in gameplay testing

**Resources**
Here are some links to the websites I used to find the "victory" and "dialogue" sound effects:

https://www.myinstants.com/en/instant/undertale-select-sound-42576/

https://pixabay.com/sound-effects/search/victory%20trumpets/

 


