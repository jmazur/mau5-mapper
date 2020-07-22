int magnification = 12;
int accuracy = 1;
boolean enablePixelPusher = false;

void setup() {
  size(1100, 1000);  
  strokeCap(SQUARE);  
  strokeJoin(MITER);
  frameRate(30);
  
  readMap();
  initPattern();
  
  if (enablePixelPusher) {
    initPusher();
  }
}

void draw() {
  drawPattern();
  drawMap();
  
  if (enablePixelPusher) {
    pushPixels();
  }
}

void keyPressed() {
 changeOrientation();
 bindMoveMap();
 bindSaveMap();
}

void mouseWheel(MouseEvent event) {
  if (event.getCount() > 0) {
    accuracy++;
    return;
  }
  
  if (event.getCount() < 0 && accuracy > 1) {
    accuracy--;
  }
}
