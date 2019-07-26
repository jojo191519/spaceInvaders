/*TO DO LIST:
 - 
 */

/*NOTE TO USER
 you must have the sound library installed for the program to execute
 */

// ------------------GLOBAL VARIABLES------------------


//Importing processing sound
import processing.sound.*;

//Ship position global variables
float shipPositionX = 0.0;
float shipPositionY = 0.0;

float shipWidth;
float shipHeight;

float shotPosX=-100;
float shotPosY=-100;

//bombs positions
int bomb1X=-200;
int bomb2X=-200;
int bomb3X=-200;
int bomb1Y;
int bomb2Y;
int bomb3Y;

//checks if bomb hits
boolean bombHit=false;

//Big spaceship position
int  bigShipX1=-200;
int bigShipX2=-200;
int bigShipX3=-200;
int  bigShipY1;
int  bigShipY2;
int  bigShipY3;

//Variables for number of aliens in the x and y direction
int xAliens=12;
int yAliens=5;

//Array for 'is aliens destroyed?'
boolean[][] isDestroyed = new boolean[yAliens][xAliens];

//X and Y position of Alien
float[][] xPositionAlien = new float[yAliens][xAliens];
float[][] yPositionAlien = new float[yAliens][xAliens];

//Array for the Pillars
int [] pillars = new int[4];
int pillarDiam = 50;
int pillarHeight = 30;

//Bullet position global variables
float bulletPositionX=-10.0;
float bulletPositionY=-10.0;

boolean bulletShot;
float bulletSpeed;
float speed = 20.0;

//Additional global variables
float alienWidthApart;

int shipX;
int shipY;

int alienHeight;
int alienWidth;

float alienSpeed = 1; 

float xAlienIncrament=1.0;  
float yAlienIncrament=10.0;

float shipSize=20;

float turretWidth; 
float turretHeight;

int bulletWidth;
int bulletHeight;

boolean didExecute;
boolean isShooting;
boolean isHit=false;

//Score
int currentScore = 0;
int scoreOpacity = 255;

//Speed of bullets aliens shoot
float alienBulletSpeed;

//Game state and setup of pages
int gameState = 0; 
PFont font1;
PFont font2;
PFont font3; 

//Bomb width and height
int bombWidth=50;
int bombHeight=80;

//Loading in alien image
PImage alien_img;

//Loading in big spaceship
PImage bigship_img;

//Loading in the image of the bomb
PImage bomb_img;

//Loading in sound files
SoundFile shootingSound;
SoundFile leftMove;
SoundFile rightMove;

//Sound files that are having a bit of an issue
SoundFile youDied;
SoundFile Kill;

// ----------------------------------------------------

void setup() {
  //the max allowed screen size is 1440 x 850
  size(800, 600);
  background(0);

  //Initial position for ship
  alienWidthApart=width/15;
  alienHeight = width/25;
  alienWidth = width/25;
  shipPositionX = width/2;
  shipPositionY = height-height/12;

  //Loading in image of aliens and resizing it
  alien_img=loadImage("emoji_alien.png");
  imageMode(CENTER);
  alien_img.resize(alienWidth, alienHeight);

  //loading in big spaceship image and resizing it
  bigship_img=loadImage("big_spaceship.png");
  bigship_img.resize(300, 100);
  bigShipY1=50;
  bigShipY2=120;
  bigShipY3=180;

  //loading in bomb image and resizing it
  bomb_img=loadImage("missile.png");
  bomb_img.resize(bombWidth, bombHeight);

  for (int i=0; i<xPositionAlien.length; i++) {
    for (int j=0; j<xPositionAlien[0].length; j++) {
      xPositionAlien[i][j] = alienWidth + j*alienWidthApart+1;
    }
  }

  for (int k=0; k<yPositionAlien.length; k++) {
    for (int l=0; l<yPositionAlien[0].length; l++) {
      yPositionAlien[k][l] = alienHeight+ k*alienWidthApart;
    }
  }

  //Loading in sound files
  shootingSound = new SoundFile(this, "Pewpew1.wav");
  leftMove = new SoundFile(this, "Move1.wav");
  rightMove = new SoundFile(this, "Move2.wav");

  //####DONT WORK YET####
  youDied = new SoundFile(this, "Youdied.wav");
  Kill = new SoundFile(this, "Kill.wav");
}

//---------------------------------------------------

void draw() {
  //----- Start screen state -----

  if (gameState == 0) {
    size(800, 600);
    background(0);

    //Title
    font1 = loadFont("LatinWide.vlw");
    textFont(font1);
    fill(0, 0, 255);
    text("Space Raiders", (width/2)-3, (height/4)-3);
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    text("Space Raiders", width/2, height/4);

    //Play selector
    fill(255, 0, 0);
    font2 = loadFont("fontidea2.vlw");
    textFont(font2);
    text(">PRESS ENTER TO PLAY<", (width/2)-2, (4*height/10)-2);
    fill(255);
    textAlign(CENTER, CENTER);
    text(">PRESS ENTER TO PLAY<", width/2, 4*height/10);

    //Intructions on start screen
    textFont(font1);
    textSize(24);
    text("Instructions", width/2, 5*height/10);
    textFont(font2);
    textSize(20);
    text("Eliminate all aliens to Win", width/2, 11*height/20);
    text("Go all the way to the one side to appear on the other", width/2, 12*height/20);
    text("Left Arrow: Move Left", width/2, 13*height/20);
    text("Right Arrow: Move Right", width/2, 14*height/20);
    text("Spacebar: Shoot", width/2, 15*height/20);
    text("Select a level and work your way up to being able to do level 3", width/2, 17*height/20);
    text("IT'S HARD!!!!!", width/2, 18*height/20);
  }

  //----- Level select screen -----

  else if (gameState == 4) {
    background(0);

    //Title
    font1 = loadFont("LatinWide.vlw");
    textFont(font1);
    fill(0, 0, 255);
    textAlign(CENTER, CENTER);
    text("Space Raiders", (width/2)-3, (height/4)-3);
    textFont(font1);
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    text("Space Raiders", width/2, height/4);

    //Flashing level selection
    if (second()%2==0) {//This covers the text with a square the colour of the background
      fill(0);
      stroke(0);
      rect(0, 220, width, 50);
    } else {
      textAlign(CENTER, CENTER);
      font3 = loadFont("Courier.vlw");
      fill(255, 0, 0);
      stroke(255, 0, 0);
      textFont(font3);
      text(">SELECT LEVEL<", (width/2)-2, (4*height/10)-2);
      fill(255);
      stroke(255);
      text(">SELECT LEVEL<", width/2, 4*height/10);
    }

    // 3 buttons
    drawLeveloneButtonoriginal();
    drawLeveltwoButtonoriginal();
    drawLevelthreeButtonoriginal();

    //THE MOUSE HOVERING OVER LEVEL 1 BUTTON 
    if ((mouseX<=(3*width)/4) && (mouseX >= (width/4)) && (mouseY <= (height/2)+50) && (mouseY >= (height/2))) {
      drawLeveloneButtonhighlight();
    }

    //THE MOUSE HOVERING OVER LEVEL 2 BUTTON   
    if ((mouseX<=(3*width)/4) && (mouseX >= (width/4)) && (mouseY <= (height/2)+150) && (mouseY >= (height/2)+100)) {
      drawLeveltwoButtonhighlight();
    }

    //THE MOUSE HOVERING OVER LEVEL 3 BUTTON  
    if ((mouseX<=(3*width)/4) && (mouseX >= (width/4)) && (mouseY <= (height/2)+250) && (mouseY >= (height/2)+200)) {
      drawLevelthreeButtonhighlight();
    }
  }


  //----- Playing game -----  
  else if (gameState == 1) {   
    background(0);
    drawBullet();
    drawMainShip();
    drawAliens();
    bombDrop();
    bombHit();
    moveBigSpaceship();
    bombIncrement();
    drawScore();
    alienShotHit();
    drawWingameOverscreen();
    alienFire();
    slowdownShoot();
  }

  //----- Win screen state -----
  else if (gameState == 2) {
    background(0);
    font1 = loadFont("LatinWide.vlw");
    textFont(font1);
    fill(0, 0, 255);
    textAlign(CENTER, CENTER);
    text("Space Raiders", (width/2)-3, (height/4)-3);
    textFont(font1);
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    text("Space Raiders", width/2, height/4);

    textAlign(CENTER, CENTER);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    font3 = loadFont("Courier-40.vlw");
    textFont(font3);
    text(">PRESS ENTER TO RESTART<", (width/2)-1, (4*height/5)-1);
    fill(255);
    stroke(255);
    textFont(font3);
    text(">PRESS ENTER TO RESTART<", (width/2), (4*height/5));

    //Game won flashing signal
    if (second()%2==0) {
      textAlign(CENTER, CENTER);
      font2 = loadFont("Courier-80.vlw");
      fill(0, 255, 0);
      stroke(0, 255, 0);
      textFont(font2);
      text(">YOU WIN<", (width/2)-2, (height/2)-2);
      fill(255);
      stroke(255);
      textFont(font2);
      text(">YOU WIN<", (width/2), (height/2));

      strokeWeight(6);
      fill(0, 255, 0);
      stroke(0, 255, 0);
      line((width/4)-52, (height/2)-52, (3*width/4)+48, (height/2)-52);
      line((width/4)-52, (height/2)+48, (3*width/4)+48, (height/2)+48);

      fill(255);
      stroke(255);
      line((width/4)-50, (height/2)-50, (3*width/4)+50, (height/2)-50);
      line((width/4)-50, (height/2)+50, (3*width/4)+50, (height/2)+50);
    }
  }

  //----- Game over state -----
  else if (gameState==3) {
    //Title
    background(0);
    font1 = loadFont("LatinWide.vlw");
    textFont(font1);
    fill(0, 0, 255);
    textAlign(CENTER, CENTER);
    text("Space Raiders", (width/2)-3, (height/4)-3);
    textFont(font1);
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    text("Space Raiders", width/2, height/4);

    //Option to replay once lost
    textAlign(CENTER, CENTER);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    font3 = loadFont("Courier-40.vlw");
    textFont(font3);
    text(">PRESS ENTER TO RESTART<", (width/2)-1, (4*height/5)-1);
    fill(255);
    stroke(255);
    textFont(font3);
    text(">PRESS ENTER TO RESTART<", (width/2), (4*height/5));

    //Game lost flashing signal
    if (second()%2==0) {
      textAlign(CENTER, CENTER);
      font2 = loadFont("Courier-80.vlw");
      fill(255, 0, 0);
      stroke(255, 0, 0);
      textFont(font2);
      text(">YOU LOSE<", (width/2)-2, (height/2)-2);
      fill(255);
      stroke(255);
      textFont(font2);
      text(">YOU LOSE<", (width/2), (height/2));

      strokeWeight(6);
      fill(255, 0, 0);
      stroke(255, 0, 0);
      line((width/4)-52, (height/2)-52, (3*width/4)+48, (height/2)-52);
      line((width/4)-52, (height/2)+48, (3*width/4)+48, (height/2)+48);

      fill(255);
      stroke(255);
      line((width/4)-50, (height/2)-50, (3*width/4)+50, (height/2)-50);
      line((width/4)-50, (height/2)+50, (3*width/4)+50, (height/2)+50);
    }
    bomb1X=-200;
    bomb2X=-200;
    bomb3X=-200;
    bomb1Y=-100;
    bomb2Y=-100;
    bomb3Y=-100;
  }

  //checking whether the last row of aliens drop below the screen
  if (yPositionAlien[0][0]>height) {
    gameState=3;
  }
}
//DRAW OVER
//-----------------------------------------------------------------------------

/* the mainShip function uses the global variables shipPositionX and shipPositionY for its
 position as the keypressed function cant call these variables from within a seperate 
 function. The starting position for the ship is declared in the setup function.
 */
void drawMainShip() {
  //------------drawing the mainShip--------------
  shipWidth = width/15;
  shipHeight = height/40;
  turretWidth = width/150;
  turretHeight = height/60;
  fill(0, 255, 0);
  noStroke();
  ellipse(shipPositionX, shipPositionY, shipWidth/2, shipHeight*1.5);//cabin
  rect(shipPositionX-(turretWidth/2), shipPositionY-shipHeight*1.2, turretWidth, turretHeight);//turret
  rect(shipPositionX-(shipWidth/2), shipPositionY, shipWidth, shipHeight);//ship
}


//Creating the bullet
void drawBullet() {
  bulletWidth = width/150;
  bulletHeight = height/60;
  fill(255); //White bullet
  noStroke();

  //Shooting the bullet
  if (bulletShot) {
    rect(bulletPositionX, bulletPositionY, bulletWidth, bulletHeight);
    if (bulletPositionY>=0 && didExecute == false) {
      bulletPositionY = bulletPositionY - bulletSpeed;
    } else {
      bulletPositionY = -100;
      didExecute = false;
    }
  }
}


//this moves the aliens in the x-direction
void xIncrement() {
  for (int i=0; i<xPositionAlien.length; i++) {
    for (int j=0; j<xPositionAlien[0].length; j++) {
      if (xPositionAlien[i][j]==width-alienWidth/2 || xPositionAlien[i][j]==alienWidth/2) {
        xAlienIncrament=(-1.0)*xAlienIncrament;
        yIncrement();
      }
      xPositionAlien[i][j]=xPositionAlien[i][j]+xAlienIncrament;
    }
  }
}



//this moves the aliens in the y-direction
void yIncrement() {
  for (int i=0; i<yPositionAlien.length; i++) {
    for (int j=0; j<yPositionAlien[0].length; j++) {
      xPositionAlien[i][j]=xPositionAlien[i][j]+xAlienIncrament;
      yPositionAlien[i][j]=yPositionAlien[i][j]+yAlienIncrament;
    }
  }
}

// The Aliens screen positions (i.e in their block arrangement)
// isDestroyed is a boolean matrix with each entry representing dead or alive for an alien
void drawAliens() {
  xIncrement();
  destroyed();
  for (int i=0; i<xPositionAlien.length; i++) {
    for (int j=0; j<xPositionAlien[0].length; j++) {
      if (isDestroyed[i][j]!=true) {
        image(alien_img, xPositionAlien[i][j], yPositionAlien[i][j]);
      }
      if (isDestroyed[i][j]==true) {
      }
    }
  }
}


//Allowing different alterations in difficulty for each selected level
void mousePressed() {

  if (gameState == 4 && mouseX<=(3*width)/4 && mouseX >= (width/4) && mouseY <= (height/2)+50 && mouseY >= (height/2) ) {
    frameRate(80);
    bulletSpeed = 8; 
    alienBulletSpeed=0.4;
    gameState = 1;
  } else if (gameState == 4 && (mouseX<=(3*width)/4) && (mouseX >= (width/4)) && (mouseY <= (height/2)+150) && (mouseY >= (height/2)+100)) {
    //Increase in frame rate
    frameRate(100);
    bulletSpeed = 8; 
    //Increase in bullet speed
    alienBulletSpeed=0.6;
    gameState = 1;
  } else if (gameState == 4 && (mouseX<=(3*width)/4) && (mouseX >= (width/4)) && (mouseY <= (height/2)+250) && (mouseY >= (height/2)+200)) {
    //Further increase in frame rate
    frameRate(120);
    bulletSpeed = 8;
    //Further increase in bullet speed
    alienBulletSpeed=0.8;
    gameState = 1;
  }
}

void keyPressed() {
  //allowing user to move between start screen and level select
  if (key == ENTER && gameState == 0) {
    gameState = 4;
  }
  //allowing user to go back to start screen after winning or loosing state - resets everything aswell
  if (key == ENTER && (gameState == 3 || gameState == 2)) {

    //reset all variables to starting state, then change game state back
    //Loading in image of aliens and resizing it

    alien_img=loadImage("emoji_alien.png");
    imageMode(CENTER);
    alien_img.resize(alienWidth, alienHeight);

    for (int i=0; i<xPositionAlien.length; i++) {
      for (int j=0; j<xPositionAlien[0].length; j++) {
        xPositionAlien[i][j] = alienWidth + j*alienWidthApart+1;
        isDestroyed[i][j] = false;
      }
    }

    for (int k=0; k<yPositionAlien.length; k++) {
      for (int l=0; l<yPositionAlien[0].length; l++) {
        yPositionAlien[k][l] = alienHeight+ k*alienWidthApart;
      }
    }
    isHit = false; 
    shipPositionX = width/2;
    shotPosX=-100;
    shotPosY=-100;
    currentScore = 0;

    gameState = 0;
  }

  if (key == CODED) {

    //------------Moving the mainShip--------------

    if (keyCode == LEFT) { 
      if (gameState == 1) {
        leftMove.play();
      }
      if (shipPositionX - (1/2)*shipWidth < 0) {
        shipPositionX = width - (1/2)*shipWidth;
      } else {

        //moves at a rate of x pixels to the left
        shipPositionX = shipPositionX-speed;
      }
    } else if (keyCode == RIGHT) {
      if (gameState==1) {
        rightMove.play();
      }
      if (shipPositionX + (1/2)*shipWidth > width) {
        shipPositionX = (1/2)*shipWidth;
      } else {

        //moves at a rate of x pixels to the right
        shipPositionX = shipPositionX+speed;
      }
    }
  }

  // bullet shot by a spacebar

  if (bulletPositionY < -5) {       

    //this allows for the bullet to only be shot when an alien is destroyed or the bullet runs of the canvas (due to the reseting of bulletPositionY) 

    if (key == ' ') {
      bulletShot = true;
      bulletPositionX = shipPositionX;
      bulletPositionY = height-height/12;
      if (gameState==1) {
        shootingSound.play();
      }
    }
  }
}

//this function tells processing when the user can shoot again
boolean resetBullet() {
  return(bulletPositionY <= 0);
}

//this is checking whether aliens have been destroyed and then setting isDestroyed to have correct values
void destroyed() {
  for (int i=0; i<xPositionAlien.length; i++) {
    for (int j=0; j<xPositionAlien[0].length; j++) {
      if (pow((bulletPositionX-xPositionAlien[i][j]), 2) + pow((bulletPositionY-yPositionAlien[i][j]), 2)<pow(32, 2)-400) {
        isDestroyed[i][j] = true; 
        didExecute = true;

        //this stops collisions from happening with bullet and invisible (dead) aliens (i.e we send them far away from game canvas) 
        xPositionAlien[i][j] = -1000;
        yPositionAlien[i][j] = -1000;

        //changing the score opacity when the aliens are hit
        scoreOpacity=0;
      }
    }
  }
}

//As aliens are destroyed, their score is kept count
int drawScore() {
  fill(0, 255, 0);
  textSize(30);
  if (didExecute == true) {
    if (gameState==1) {
      Kill.play();
    }
    currentScore++;
  }
  if (scoreOpacity<255) {
    scoreOpacity+=2;
  }
  fill(0);
  text(currentScore, width-39, 41);
  fill(0, 255, 0, scoreOpacity);
  text(currentScore, width-40, 40);
  return currentScore;
}

//win/gameover screens opacity needs to increase slowly like the score
void drawWingameOverscreen() {
  if (currentScore == xAliens*yAliens) {
    gameState = 2;
  } else {
    for (int i=yPositionAlien.length-1; i>=0; i--) {
      for (int j =0; j<yPositionAlien[i].length; j++) {
        if (isHit || !isDestroyed[i][j] && yPositionAlien[i][j]+alienHeight>=shipPositionY-shipHeight*1.2 && (xPositionAlien[i][j] == shipPositionX || xPositionAlien[i][j] + alienWidth == shipPositionX)) {
          if (gameState==1) {
            youDied.play();
          }
          gameState = 3;
        }
      }
    }
  }
}


//Function which allows the Aliens to shoot
void slowdownShoot() {
  if (!isShooting) {
    int val;
    if (gameState==1) {
      val=50;
    } else if (gameState==2) {
      val=10;
    } else if (gameState==3) {
      val=2;
    } else {
      val=100;
    }
    int dummy=int(random(0, val));
    if (dummy==5) {
      int  shipX=int(random(0, yAliens));
      int  shipY=int(random(0, xAliens));
      if (!isDestroyed[shipX][shipY]) {
        shotPosX=xPositionAlien[shipX][shipY];
        shotPosY=yPositionAlien[shipX][shipY];
      }
    }
  }
}

//The red bullet in which the aliens shoots at the ship
void alienFire() {
  fill(255, 0, 0); //Red bullet
  noStroke();
  rectMode(CENTER);
  if (shotPosY<=height) {
    rect(shotPosX, shotPosY, bulletWidth, bulletHeight);
    shotPosY = shotPosY + (alienBulletSpeed)*bulletSpeed;
    isShooting = true;
  } else {
    isShooting=false;
  }
  rectMode(CORNER);
}

//checks if the aliens bullet has hit the user
void alienShotHit() {
  if (shotPosX<shipPositionX+(shipWidth/2) && shotPosX+bulletWidth>shipPositionX-(shipWidth/2) && shotPosY<shipPositionY+shipHeight && shotPosY>shipPositionY-shipHeight) {
    isHit=true;
  } else {
    isHit=false;
  }
}
/* Button functions - these are used to hover with the mouse 
 and use the up and down keys*/
void drawLeveloneButtonhighlight() {
  fill(#60A55F);
  stroke(#60A55F);
  rect(width/4, height/2, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL I<", width/2, (height/2)+25);
}

void drawLeveltwoButtonhighlight() {
  fill(#60A55F);
  stroke(#60A55F);
  rect(width/4, (height/2)+100, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL II<", width/2, (height/2)+125);
}

void drawLevelthreeButtonhighlight() {
  fill(#60A55F);
  stroke(#60A55F);
  rect(width/4, (height/2)+200, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL III<", width/2, (height/2)+225);
}

void drawLeveloneButtonoriginal() {
  fill(0, 255, 0);
  stroke(0, 255, 0);
  rect(width/4, height/2, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL I<", width/2, (height/2)+25);
}

void drawLeveltwoButtonoriginal() {
  fill(0, 255, 0);
  stroke(0, 255, 0);
  rect(width/4, (height/2)+100, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL II<", width/2, (height/2)+125);
}

void drawLevelthreeButtonoriginal() {
  fill(0, 255, 0);
  stroke(0, 255, 0);
  rect(width/4, (height/2)+200, width/2, 50);

  fill(255);
  stroke(255);
  textAlign(CENTER, CENTER);
  textFont(font2);
  text(">LEVEL III<", width/2, (height/2)+225);
}

//moving the massive spaceships across the top of screen
void moveBigSpaceship() {
  float consideredVal=0;
  for (int j=0; j<xPositionAlien[0].length; j++) {
    for (int i=0; i<xPositionAlien.length; i++) {
      if (isDestroyed[i][j]!=true) {
        consideredVal=yPositionAlien[i][j];
        break;
      }
    }
  }

  if (consideredVal>130) {
    bigSpaceshipIncrement(consideredVal);
  }
  if (consideredVal%22==0) {
    bigShipX1=width+150;
    bigShipX2=width+450;
    bigShipX3=width+750;
  }
}

//moving the big spaceships at the top of the screen 
void bigSpaceshipIncrement(float consideredVal) {
  if (consideredVal>352) {
    bigShipX1--;
    bigShipX2--;
    bigShipX3--;
    image(bigship_img, bigShipX1, bigShipY1);
    image(bigship_img, bigShipX2, bigShipY2);
    image(bigship_img, bigShipX3, bigShipY3);
  } else if (consideredVal>242) {
    bigShipX1--;
    bigShipX2--;
    image(bigship_img, bigShipX1, bigShipY1);
    image(bigship_img, bigShipX2, bigShipY2);
  } else if (consideredVal>132) {
    bigShipX1--;
    image(bigship_img, bigShipX1, bigShipY1);
  }
}

//the bullets shot by the big space ships
void bombDrop() {
  if (bigShipX1%200==0) {
    bomb1X=bigShipX1;
    bomb1Y=bigShipY1;
  }
  if (bigShipX2%150==0) {
    bomb2X=bigShipX2;
    bomb2Y=bigShipY2;
  }
  if (bigShipX3%100==0) {
    bomb3X=bigShipX3;
    bomb3Y=bigShipY3;
  }
}

//movement of the enemy missiles/bombs from big spacship
void bombIncrement() {
  rectMode(CENTER);
  bomb1Y=bomb1Y+3;
  image(bomb_img, bomb1X, bomb1Y);

  bomb2Y=bomb2Y+4;
  image(bomb_img, bomb2X, bomb2Y);

  bomb3Y=bomb3Y+5;
  image(bomb_img, bomb3X, bomb3Y);
  rectMode(CORNER);
}

//checking if the bomb/missile has hit the user
void bombHit() {
  if (bomb1X+(bombWidth/2)>shipPositionX-(shipWidth/2) && bomb1X-(bombWidth/2)<shipPositionX+(shipWidth/2) && bomb1Y+(bombHeight/2)>shipPositionY-(shipHeight/2) && bomb1Y-(bombHeight/2)<shipPositionY+(shipHeight/2)) {
    if (gameState==1) {
      youDied.play();
    }
    gameState=3;
  }
  if (bomb2X+(bombWidth/2)>shipPositionX-(shipWidth/2) && bomb2X-(bombWidth/2)<shipPositionX+(shipWidth/2) && bomb2Y+(bombHeight/2)>shipPositionY-(shipHeight/2) && bomb2Y-(bombHeight/2)<shipPositionY+(shipHeight/2)) {
    if (gameState==1) {
      youDied.play();
    }
    gameState=3;
  }
  if (bomb3X+(bombWidth/2)>shipPositionX-(shipWidth/2) && bomb3X-(bombWidth/2)<shipPositionX+(shipWidth/2) && bomb3Y+(bombHeight/2)>shipPositionY-(shipHeight/2) && bomb3Y-(bombHeight/2)<shipPositionY+(shipHeight/2)) {
    if (gameState==1) {
      youDied.play();
    }
    gameState=3;
  }
}
