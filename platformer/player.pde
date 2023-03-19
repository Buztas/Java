//will need to determine proper jumping
class Player {
  
  PImage image;
  
  float w, h, x, y, vx, vy, accelerationX, accelerationY, speedLimit;
  
  float friction, bounce, gravity;
  
  boolean isOnGround, facingRight, facingLeft;
  float jumpForce;
  
  float halfWidth, halfHeight;
  String collisionSide;
  
  int currentFrame;
  int frameSequence;
  int frameOffset;
  int loopFrames;
  int delay;
  
  Player() {
    w = 75 - 40;
    h = 75 - 35;
    x = 450;
    y =  6780;
    vx = 0;
    vy = 0;
    accelerationX = 0;
    accelerationY = 0;
    speedLimit = 6;
    isOnGround = false;
    jumpForce = -10;
    
    //vals for the world
    friction = 0.96;
    bounce = -0.7;
    gravity = .3;
    
    halfWidth = w/2;
    halfHeight = h/2;
    
    collisionSide = "";
    
    currentFrame = 0;
    loopFrames = 4;
    facingRight = false;
    facingLeft = false;
    frameSequence = 7;
    frameOffset = 0;
    delay = 0;
  }
  
  void update()
  {
     if(left && !right)
     {
        accelerationX = -0.2; 
        friction = 1;
        frameOffset = 8;
        facingLeft = true;
        facingRight = false;
     }
     if(right && !left)
     {
        accelerationX = 0.2;
        friction = 1;
        frameOffset = 0;
        facingRight = true;
        facingLeft = false;
     }
     if(!left && !right)
     {
        accelerationX = 0;
     }
     if(up && !down && isOnGround)
     {
       // accelerationY = -0.2;
       // friction = 1;
       // gravity = 0;
       vy = jumpForce;
       isOnGround = false;
       friction = 1;
     }
     if(!up && down)
     {
       // accelerationY = 0.2;
        //friction = 1;
     }
     if(!up && !down)
     {
        //accelerationY = 0; 
     }
     if(up && right && !left && !down)
     {
        frameOffset = 4; 
        facingRight = true;
        facingLeft = false;
     }
     if(up && left && !right && !down)
     {
        frameOffset = 12; 
        facingRight = false;
        facingLeft = true;
     }
     if(up && !left && !right && !down)
     {
        if(facingRight == true)
          frameOffset = 4;
        else if(facingLeft == true)
          frameOffset = 12;
     }
     if(!up && !down && !left && !right)
     {
         friction = 0.96;
         //vx = 0;
         //vy = 0;
        // gravity = 0.65;  
        currentFrame = 0;
     } else 
     {
       if(delay == 0)
       {
          currentFrame = (currentFrame + 1)%loopFrames;   
       }
       
       delay = (delay+1)%10;
     }

     vx += accelerationX;
     vy += accelerationY;
     
     vx *= friction;
     //vy *= friction;
     
     vy += gravity;
     
     
     if(vx > speedLimit)
     {
        vx = speedLimit; 
     }
     
     if(vx < -speedLimit)
     {
        vx = -speedLimit; 
     }
         
     if(vy > speedLimit)
     {
        vy =  speedLimit; 
     }
      
          
     if(abs(vx) < 0.2)
     {
        vx = 0;
     } 
     
     //currentFrame++;
     //if(currentFrame ==  loopFrames)
     //{
     //  currentFrame = 0;       
     //}
     
     //x+=vx;
     //y+=vy;
      
      x = Math.max(0, Math.min(x + vx, gameWorld.h + 200));
      y = Math.max(0, Math.min(y + vy, gameWorld.w - h));
      
     //checkBoundaries(); //method for checking boundaries of the world
     //checkPlatforms();
  }
  
  void checkBoundaries()
  {
    //left
     if(x < 0)
     {
        vx *= bounce;
        x = 0;
     }
     //right
     if(x + w > width)
     {
        vx *= bounce;
        x = width - w;
     }
     //top
     if(y < 0)
     {
        vy *= bounce;
        y = 0;
     }
     //bottom
     if(y + h > height)
      {
        if(vy < 1)
        {
           isOnGround = true;
           vy = 0;
        } else
        {
           vy *= bounce/2; 
        }
        y = height - h;
      }
  }
  
  void checkPlatforms()
  {
     if(collisionSide == "bottom" && vy >= 0)
     {
        if(vy < 1)
        {
           isOnGround = true;
           vy = 0;
        } else 
        {
           vy *= bounce/2; 
        }
     } else if(collisionSide == "top" && vy <= 0)
     {
       vy = 0;
     } else if(collisionSide == "right" && vx >= 0)
     {
       vx = 0;
     } else if(collisionSide == "left" && vx <= 0)
     {
       vx = 0;
     } 
     if(collisionSide != "bottom" && vy > 0)
     {
        isOnGround = false; 
     }
  }
   
  void display()
  {
    //we have a loop of the player
    //0 - 3 walking right
    //4 - 7 jumping right
    //8 - 11 walking left
    //12 - 15 jumping left
    //fill(255,0,255);
    //rect(x - 27,y - 30,w,h + 13);
    image(player[currentFrame+frameOffset], x-45, y-51, w + 40, h + 33);
  }
}
