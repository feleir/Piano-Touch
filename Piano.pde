import arb.soundcipher.*; //imports the sound cipher external library
PianoKey keys[]; // Array that will hold the different keys

void setup()
{ 
  size(640,640);
  smooth();
  initKeys(10,60,4); 
}

void draw() {
  background(0); 
  for(int i = 0; i < keys.length; i ++)
    keys[i].Draw();
}

// Initialize the keys array
// _quantity: Number of keys
// _width: Width of the keys
// _padding: padding between the keys
void initKeys(int _quantity, int _width, int _padding) 
{
  int currentPosition = _padding/2;
  keys = new PianoKey[_quantity];
  for(int i = 0; i < _quantity; i++)
  {
    keys[i] = new PianoKey(currentPosition,0,_width,height);
    currentPosition += _width + _padding;
  }
}


///PianoKey class, creates the key and handles the equaliser and sound as well.
class PianoKey
{
  int w,h,x,y, loud,tone;
  int rectH, rectY;
  color rectC;
  SoundCipher sc;
  float wait;
 
  public PianoKey(int _x, int _y, int _w, int _h)
  {
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;
    this.rectH = this.h / 25;
    this.rectY = this.h / 2;
    this.rectC = color(106, 45, 97);
    this.wait = 0;
    this.sc = new SoundCipher(); 
  }
 
  private color PlaySound() 
  {
    if (wait == 0) {
      loud = (10+(x/10)); //creates a number position of the key for the loudness of the note
      tone = (30+(rectY/8)); //creates a number based on the position of the note indicator for the tone of the note
      sc.playNote(tone, loud, 2);
      wait = 100;  
    }
    wait -= 1;
    return color(tone*2, loud*2, 255, 150);
  }
  
  // Checks if the mouse is inside the key
  private boolean mouseIsOn()
  {
    if(mouseX >= this.x && mouseX <= this.x + this.w
      && mouseY >= this.y && mouseY <= this.y + this.h)
    {
      return true;
    }
    return false;
  }
  
  // Updates the note indicator
  private void updateRectPosition()
  {
    if(this.mouseIsOn())
    {    
      if(abs(mouseY- this.rectY) > 8)
      {
        if(mouseY > this.rectY)
          this.rectY += 8;
        else
          this.rectY -= 8;
      }
 
    }
    else
    {
      if(abs(this.h / 2  - this.rectY) > 2)
      {
        if(this.h / 2 > this.rectY)
          this.rectY += 1;
        else
          this.rectY -= 1;
      }
      else {
        this.rectY = this.h / 2;
        wait = 0;        
      }
    }
    rectMode(CENTER);
    if (this.rectY != this.h / 2)
      fill(PlaySound());
    else      
      fill(rectC);
    
    rect(x + w/2, rectY, w, rectH);  
  }
 
  public void Draw()
  {
    fill(255);
    rectMode(CORNER);
    rect(x,y,w,h);
    updateRectPosition();

  } 
}
