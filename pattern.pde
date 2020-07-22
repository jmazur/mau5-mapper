color[] colours = { #f7a85d, #f7f45d, #f75d60, #d8f75d, #8cf75d, #f7c95d, #5df7ef, #5db2f7, #5df7a3, #895df7, #d65df7, #5d7ff7};
boolean isVertical = true;
float totalBars;

void initPattern() {
  totalBars = width / magnification;
}

void drawPattern() {
  for (int i = 0; i < totalBars; i = i + 1) {
    
    int colourIndex = (i % (colours.length * accuracy)) / accuracy;
    color c = colours[colourIndex];
    
    noStroke();
    fill(c);
    
    if (isVertical) {
      rect(magnification * i, 0, magnification, height);
      continue;
    }
    
    rect(0, magnification * i, width, magnification);
    
  }
}

void changeOrientation() {
  if (key == ' ') {
    if (isVertical) {
      isVertical = false;
      return;
    }
    
    isVertical = true;
  }
}
