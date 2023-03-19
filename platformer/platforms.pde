class Platform
{
   float w,h, x,y;
   String typeof;
   float halfWidth, halfHeight;
   int columns;
   int [] platforms_x;
   int [] platforms_y;
   
   Platform(float _x, float _y, float _w, float _h, String _typeof)
   {
      x = _x;
      y = _y;
      w = _w;
      h = _h;
      typeof = _typeof;
      columns = 27;
      
      halfWidth = w/2;
      halfHeight = h/2;
      
      //platforms_x = new int[2000000];
      //platforms_y = new int[2000000];
   }
   
   
   void display()
   {
     
   }
}
