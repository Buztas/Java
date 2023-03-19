//jump king platformer?
//Justas Buzys 
Player p;
Platform l;
Platform [] platforms;
Platform [] ground;
Platform [] left_side;
Platform [] right_side;
Platform [] filler;
Platform [][] blocks;
boolean left, right, up, down, space;

String pos = "";

PImage [] chars; //our dude
PImage [] inv_chars;
PImage [] player;
PImage [] mapSprites; //array for map sprites
PImage [] backgrounds;
PImage map; //map sheets
PImage img; //characters
PImage inv;
PImage welcome;
PImage finished;

int column, row, amount, m_column, m_amount, inv_amount, inv_column;
int tileWidth, tileHeight;
float tileW, mapW = 34;
int tempo;
int m = 0;
int n = 0;
int scrolling = 0;
int left_side_count = 0;
int right_side_count = 0;
int fill_amount = 0;
String [][] entire_map;
int [][] int_entire_map;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;
final static float right_margin = 400;
final static float left_margin = 60;
final static float vertical_margin = 40;

int [] p_x;
int [] p_y;
int p_w, p_h;
int mapWidth, mapHeight;

int other_id;

int [] ground_x;
int [] ground_y;

int [] left_side_x;
int [] right_side_x;
int [] left_side_y;
int [] right_side_y;

int [] filler_x;
int [] filler_y;

boolean editor = false;
boolean scroll_down = false;
boolean scroll_up = false;
boolean delete = false;
boolean interact = false;
boolean chest = false;
boolean ending = false;
boolean reminder = true;
boolean restart = false;

FrameObject camera, gameWorld;
ImageObject backImage;

int map_row, map_col;
int map_x, map_y;

int tempcol = 0;
int temprow = 0;
int id;
int [] insert_id;
int id_calc = 0;
int scale;
int integer_x;
int integer_y;

int i_amount = 0;

int map_cols, map_rows;

String message;

//ADJUST CAMERA
//POSSIBLY SCORE???
//??? WIN???
//guy is 2 blocks big and 1 block wide

void setup()
{
   size(1035,820); 

   left = false;
   right = false;
   up = false;
   down = false;
   space = false;
   
   tileWidth = 32*3;
   tileW = 14;
   tileHeight = 32;
   mapWidth = 34;
   mapHeight = 34;
   column = 8;
   row = 3;
   map_row = 7;
   map_col = 10;
   amount = 0;
   m_column = 10;
   m_amount = 0;
   inv_chars = new PImage[55];
   chars = new PImage[50];
   mapSprites = new PImage[150];
   player = new PImage[50];
   inv_amount = 0;
   inv_column = 2;
   tempo = 0;
   p_w = 200;
   p_h = 25;
   p_x = new int[20000];
   p_y = new int[20000];
   ground_x = new int[2000];
   ground_y = new int[2000];
   insert_id = new int[71];
   scale = 2;
   
   //existing platforms
   insert_id[0] = 1;
   insert_id[45] = 2;
   insert_id[11] = 3;
   insert_id[12] = 4;
   insert_id[6] = 5;
   
   left_side_x = new int[2000];
   left_side_y = new int[2000];
   right_side_x = new int[2000];
   right_side_y = new int[2000];
   
   filler_x = new int[2000];
   filler_y = new int[2000];
   
   entire_map = new String[2000][2000];
   int_entire_map = new int[2000][2000];

   p = new Player();
   //l = new Platform(300,650,200, 25, "safe");
   
   createPlatforms();
   
   platforms = new Platform[m];
   ground = new Platform[n];
   filler = new Platform[fill_amount];
 
   left_side = new Platform[left_side_count];
   right_side = new Platform[right_side_count];
 
   blocks = new Platform[200][500];
 
   img = loadImage("data/characters.png");
   map = loadImage("data/sheet.png");
   inv = loadImage("data/i_characters.png");
   welcome = loadImage("data/welcome.png");
   finished = loadImage("data/ending.png");
   
   backgrounds = new PImage[20];
   
   for(int i = 0; i < 10; i++)
   {
      backgrounds[i] = loadImage("data/background"+nf(i+1)+".png"); 
   }
   //above we load the backgrounds 1050 820
   //backImage width is actually worlds height, and vice versa for game to work
   backImage = new ImageObject(0,0, width, height, backgrounds[0]);
   backImage.w = height; backImage.h = width;
   gameWorld = new FrameObject(0,0, backImage.h*10, backImage.w);
   camera = new FrameObject(0,0, width, height);
   
   camera.x = (gameWorld.x + gameWorld.w/2) - camera.w/2;
   camera.y = (gameWorld.y + gameWorld.h/2) - camera.h/2;
   
   //player values and various frames 1 - 8 walk and jump
   getSprites();
   //getInvert();
   //println(tileWidth, tileHeight, column, row);
   //println(amount, inv_amount, tempo);
   //println(right_side_count, left_side_count);
   //addPlatform();
   getMap();
   /*
   println("map_rows: " + map_rows, " map_cols: " + map_cols);
   for(int i = 0; i < map_rows; i++)
   {
      print(i + " : ");
      for(int j = 0; j < map_cols; j++)
      {
         print(int_entire_map[i][j]); 
      }
      println();
   }
   */
}

void draw()
{
   //addPlatform();
   //here we change the backgrounds based on coords
   //we have sign interactions
   //if you open the chest or come near it, it opens and teleports you back to the latest sign
   if(p.y < 7000)
     image(backgrounds[9],0,0);
   if(p.y < 5000)
     image(backgrounds[0],0,0);
   if(p.y < 3000)
     image(backgrounds[8], 0, 0);
   if(p.y < 1500)
     image(backgrounds[4], 0, 0);
   if(editor)
   {
       image(map, 0, 0);
       text("ARROW_DOWN = map scroll down", 0, 540);
       text("ARROW_UP = map scroll up", 0, 600);
       text("BACKSPACE = deletion mode, press again to stop", 0, 660);
       text(temprow + " - " + tempcol, 540, 440);
       if(delete)
       {
          text("DELETION MODE ENABLED", 0, 720);
       } else
         text("BUILDING MODE ENABLED", 0, 720);
       addPlatform();
       saveMap();
   } else if(reminder)
   {
       image(welcome, 0, 0);
   } else if(ending)
   {
       image(finished, 0, 0);
       if(restart)
       {
          p.x = 450;
          p.y = 6780;
          ending = false;
          restart = false;
       }
   }
   else
   {
   p.update();
   //moving the camera
   camera.x = floor(p.x + (p.halfWidth) - (camera.w / 2));
   camera.y = floor(p.y + (p.halfHeight) - (camera.h / 2));
   
   //keeping camera inside the gameWorld boundaries
   //currently works as Mario ( eughh ), change width and height for jump king?
   if(camera.x < gameWorld.x)
   {
      camera.x = gameWorld.x; 
   }
   if(camera.y < gameWorld.y)
   {
      camera.y = gameWorld.y;
   }
   if(camera.x + camera.h > gameWorld.x + gameWorld.h)
   {
      camera.x = gameWorld.x + gameWorld.h - camera.h;
   }
   if(camera.y + camera.w > gameWorld.w)
   {
      camera.y = gameWorld.w - camera.w; 
   }
   
   pushMatrix();
   translate(-camera.x, -camera.y);
   
   //image(map,0,0);   
  // p.update();
   createPlatforms();
   p.display();
   collision();
   sign_interactions();
   //p.checkPlatforms();
   interaction();
   //text("x : " + p.x + " y : " + p.y, p.x, p.y - 80);
   if(interaction() == true)
     do_interaction();
   popMatrix();
   }
}

void show()
{

  textSize(28);
  if(mouseX<map.width && mouseY<map.height && mousePressed)
  {
    tempcol = int(mouseX / mapWidth);
    temprow = int(mouseY/ mapWidth);
    id = temprow*map_col+tempcol; 
    if(insert_id[id_calc] != 0)
    {
        insert_id[id_calc] = id;
        id_calc++;
    } 
  }
  if(mouseX<width && mouseY<height && !mousePressed)
  {
     image(mapSprites[id],mouseX,mouseY,60,60);
     map_x = mouseX;
     map_y = mouseY;
     //text(temprow + " - " + tempcol + " - id: " + id + " map_x: " + map_x + " map_y: " + map_y + " id_calc: " + id_calc, 0, 540);  
  }
}

void getMap()
{
   String [] lines = loadStrings("tilemap.csv");
   map_rows = lines.length;
   for(int i = 0; i < lines.length; i++)
   {
      String [] values = split(lines[i], ",");
      //String [] [] mapper;
      //mapper = new String[
      //print(i + " : ");
      map_cols = values.length;
      for(int j = 0; j < values.length; j++)
      {
         
         entire_map[i][j] = values[j];
         //int_entire_map[i][j] = Integer.parseInt(values[j]);
         //print(entire_map[i][j]);
      }
      //println();
   }
   //println(map_rows, map_cols); 214 32
   //entire_map[0][0] = "85";
   for(int i = 0; i < map_rows; i++)
   {
      print(i + " : ");
      for(int j = 0; j < map_cols; j++)
      {
         try
         {
             int_entire_map[i][j] = Integer.parseInt(entire_map[i][j]);
             print(int_entire_map[i][j] + " "); 
         } catch(Exception e)
         {
             map_cols--;
         }
      }
      println();
   }
}

boolean interaction()
{
   float iblockX, iblockY, iblockW, iblockH, iblockHalfHeight, iblockHalfWidth;
   
   iblockH = mapW;
   iblockW = mapW;
   
   iblockHalfHeight = iblockH/2;
   iblockHalfWidth = iblockW/2;
   
   for(int i = 0; i < map_rows; i++)
   for(int j = 0; j < map_cols; j++)
   {
         iblockX = j*mapW + mapW/2;
         iblockY = i*mapW + mapW/2;  
         
         float idx = (p.x + p.w/2) - (iblockX + iblockW/2);
         float idy = (p.y + p.h/2) - (iblockY + iblockH/2);
    
       
         float icombinedHalfWidths = p.halfWidth + iblockHalfWidth;
         float icombinedHalfHeights = p.halfHeight + iblockHalfHeight;
         
     if(int_entire_map[i][j] == 7 || int_entire_map[i][j] == 8 || int_entire_map[i][j] == 9 || 
     int_entire_map[i][j] == 17 || int_entire_map[i][j] == 18 || int_entire_map[i][j] == 19
     )
     {         
         if(abs(idx) < icombinedHalfWidths)
         {
            if(abs(idy) < icombinedHalfHeights)
            {
                interact = true;
                textSize(16);
                text("press F to interact" , p.x - 47, p.y - 30);
                return interact;
            } 
         } 
     }
    if(int_entire_map[i][j] == 47)
    {
       if(abs(idx) < icombinedHalfWidths)
         {
            if(abs(idy) < icombinedHalfHeights)
            {
                chest = true;
                return chest;
            } 
         }
    }
   }
   chest = false;
   interact = chest;
   return chest;
}

void addPlatform()
{ 
  show();
  //change the IDs in excel file
  //do the replacement and done?
  
  if(scroll_up)
  scrolling += 10;
  if(scroll_down)
  scrolling -= 10;
  
   for(int i = 0; i < map_rows; i++)
   {
      for(int j = 0; j < map_cols;j++)
      {
        
         if(int_entire_map[i][j] != 85)
         {
            image(mapSprites[int_entire_map[i][j]], j * tileW + 600, i * tileW + scrolling, tileW, tileW); 
         } else
         {
            rect(j*tileW+600, i *tileW + scrolling, tileW, tileW); 
         }
         /*
         if(values[col].equals(Integer.toString(id)));
         {
             //integer_x[col] = 
         }
         */
      }
   }
   if(mouseY > 0 && mouseY < height && mouseX > (width - 432) && mouseX < width && mousePressed)
   {
      int hoverCol = int((mouseX - 600) / tileW);
      int hoverRow = int((mouseY-scrolling)/ tileW);
      try
      {
         int_entire_map[hoverRow][hoverCol] = id; 
         if(delete)
         {
            int_entire_map[hoverRow][hoverCol] = 85; 
         }
         //text("col: " + hoverCol + ", row: " + hoverRow, 40, 240);
      } catch(Exception e)
      {
          //text("col: " + hoverCol + ", row: " + hoverRow, 40, 240);
      }
   }
   
}

void saveMap()
{
   PrintWriter output = createWriter("tilemap.csv");
   for(int i=0;i<map_rows;i++)
   {
     for(int j=0;j<map_cols;j++)
     {
        output.print(int_entire_map[i][j] + ",");          
     }
     output.println();
   }
        
  output.flush();
  output.close();
}

void createPlatforms()
{
    for(int i = 0; i < map_rows; i++)
    {
       for(int j = 0; j < map_cols; j++)
       {
          if(int_entire_map[i][j] != 85)
          {
            image(mapSprites[int_entire_map[i][j]], j * mapW, i * mapW, mapW, mapW ); 
          }
       }
    }
}

void getSprites()
{
  PImage [] tempChars;
  int m = 0;
  tempChars = new PImage[50];
  //8 - 15 our char
    for(int i =  0; i < 3; i++)
    {
        for(int j = 0; j < 8; j++)
        {
          tempChars[i*column+j] = img.get(j*tileWidth,i * tileWidth, tileWidth, tileWidth);
        }
     }
    for(int i = 8; i <= 15; i++)
    {
        chars[amount] = tempChars[i];
        amount++;
    }

    //7 rows 10 columns
    for(int i = 0; i < 7; i++)
    {
       for(int j = 0; j < 10; j++)
       {
           mapSprites[i*m_column+j] = map.get(j*mapWidth, i * mapWidth, mapWidth, mapWidth);
           m_amount++;
       }
    }
    getInvert();
    
    for(int i = 0; i < amount; i++)
    {
       player[i] = chars[i];
    }
    for(int i = amount; i < amount+inv_amount; i++)
    {
       player[i] = inv_chars[m];
       m++;
    }
    // cols = 7, rows = 10
}

void getInvert()
{
    PImage [] invertChars;
    invertChars = new PImage[150];
     for(int i = 0; i < 2; i++)
    {
       for(int j = 0; j < 25; j++)
       {
           invertChars[i*inv_column+j] = inv.get(j*tileWidth, i * tileWidth, tileWidth, tileWidth);
           tempo++;
       }
    }
    for(int i = 24; i >= 17; i--)
    {
       inv_chars[inv_amount] = invertChars[i];
       inv_amount++;
    }
    /*
    for(int i = 40; i < 48; i++)
    {
        inv_chars[inv_amount] = invertChars[i];
        inv_amount++;
    } 
    */
}

void sign_interactions()
{
  float y,x;
   y = p.y;
   x = p.x;
   if( y < 1000 )
     message = "You are so close!";
   if( y < 7000 && y > 6700 )
   {
     message = "Hi, your main goal is to beat the game\nby jumping up and reaching the top, have fun!"; 
   }
   if(y > 6500 && y < 6560)
   {
      message = "You just experienced a mimic chest,\nthere are no good chests here, only bad ones sadly..\nMimic chests will teleport you back to this sign\nAVOID THEM AT ALL COSTS!"; 
   }
   if( y > 4765 &&  y < 4775)
     message = "This is the forest,\nNot much greenery i suppose...";
   if(y > 2865 && y < 2899 )
     message = "The desert! A rocky place!";
   if(y > 1270 && y < 1320 )
     message = "The tundra...Could it mean the end of a cycle?";
   if(y < 200 && y > 0)
   {
      message = "Victory!";
   }
     
}

void keyPressed()
{
  if(keyCode == 87)
      up = true;
  if(keyCode == 83)
      down = true;
  if(keyCode == 65)
      left = true;
  if(keyCode == 68)
      right = true;
  if(key == 'e')
      editor = !editor;
  if(keyCode == UP)
      scroll_up = true;
  if(keyCode == DOWN)
      scroll_down = true;
  if(keyCode == BACKSPACE)
      delete = !delete;
  if(keyCode == 32)
      reminder = !reminder;
  if(key == 'r' && ending == true)
      restart = true;
   
}
void keyReleased()
{
  if(keyCode == 87)
  {
     up = false;
  }
  if(keyCode == 83)
  {
     down = false;
  }
  if(keyCode == 65)
  {
     left = false;
  }
  if(keyCode == 68)
  {
     right = false;
  }
  if(keyCode == UP)
      scroll_up = false;
  if(keyCode == DOWN)
      scroll_down = false;
   
}

void do_interaction()
{
     if(key == 'f' && interact == true )
      {
          textSize(28);
          text(message, p.x - 17, p.y - 100);
      } 
     
     for(int i = 0; i < map_rows; i++)
     for(int j = 0; j < map_cols; j++)
     {
        if(chest && int_entire_map[i][j] == 47)
        {
             int_entire_map[i][j] = 49;
             p.x = 15; 
             p.y = 6450;
             chest = false;
        }
     }
     if(message == "Victory!" && key == 'f')
     {
         ending = true;
         //text("" + ending, p.x - 17, p.y - 30);
     } else
         ending = false;
     
}

void collision()
{

   //p1 player
   //p2 platform
   //returns the String collisionSide
   
   //if(p1.vy < 0) { return "none"; }
   
   float blockX, blockY, blockW, blockH, blockHalfHeight, blockHalfWidth;
   
   blockH = mapW;
   blockW = mapW;
   
   blockHalfHeight = blockH/2;
   blockHalfWidth = blockW/2;
   
   for(int i = 0; i < map_rows; i++)
      for(int j = 0; j < map_cols; j++)
      {
       if(int_entire_map[i][j] != 85 && (int_entire_map[i][j] != 7 && int_entire_map[i][j] != 8 && int_entire_map[i][j] != 9) &&  
       (int_entire_map[i][j] != 17 && int_entire_map[i][j] != 18 && int_entire_map[i][j] != 19) &&  
       (int_entire_map[i][j] != 27 && int_entire_map[i][j] != 28 && int_entire_map[i][j] != 29) &&  
       (int_entire_map[i][j] != 37 && int_entire_map[i][j] != 38 && int_entire_map[i][j] != 39) &&  
       (int_entire_map[i][j] != 47 && int_entire_map[i][j] != 48 && int_entire_map[i][j] != 49) &&  
       (int_entire_map[i][j] != 57 && int_entire_map[i][j] != 58 && int_entire_map[i][j] != 59) &&  
       (int_entire_map[i][j] != 67 && int_entire_map[i][j] != 68 && int_entire_map[i][j] != 69) &&  
       (int_entire_map[i][j] != 40 && int_entire_map[i][j] != 41 && int_entire_map[i][j] != 50) &&  
       int_entire_map[i][j] != 60 && int_entire_map[i][j] != 34)
       {
       blockX = j*mapW + mapW/2;
       blockY = i*mapW + mapW/2;
       
       float dx = (p.x + p.w/2) - (blockX + blockW/2);
       float dy = (p.y + p.h/2) - (blockY + blockH/2);
    
       
       float combinedHalfWidths = p.halfWidth + blockHalfWidth;
       float combinedHalfHeights = p.halfHeight + blockHalfHeight;
       
       if(abs(dx) < combinedHalfWidths)
       {
          if(abs(dy) < combinedHalfHeights)
          {
             float overlapX = combinedHalfWidths - abs(dx);
             float overlapY = combinedHalfHeights - abs(dy);
             
             if(overlapX >= overlapY)
             {
                if( dy > 0 )
                {
                  //top
                   p.y += overlapY -0.15;
                   p.collisionSide = "top";
                   p.vy = 0;
                } else {
                  //bottom
                   p.y -= overlapY + 0.15;
                   p.collisionSide = "bottom";
                   p.vy = 0; 
                }
             } else {
                 if(dx > 0)
                  {
                    //left
                    p.x += overlapX;
                    p.collisionSide = "left";
                  } else {
                    //right
                     p.x -= overlapX;
                     p.collisionSide = "right";
                  }
             }
          p.checkPlatforms();
          } //else return "none";
       } //else return "none"; 
       }
      }
}
