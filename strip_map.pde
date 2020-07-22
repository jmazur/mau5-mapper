import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.BufferedWriter;

int currentStrip = 0;
int currentLed = 0;
int strokeSize = 8;
color activeColour = #ffffff;
color[] ledColours = { #0090ff, #ff0090, #e902ff, #ff0800, #ffbf00, #00b6ff };

int[][][] map;


void readMap() {
  XML xml = loadXML("map.xml");
  XML[] strips = xml.getChildren("strip");
  map = new int[strips.length][][];
  
  for (int i = 0; i < strips.length; i++) {
    XML strip = strips[i];
    XML[] leds = strip.getChildren("led");
    int[][] stripMap = new int[leds.length][];
    
    for (int ii = 0; ii < leds.length; ii++) {
      XML led = leds[ii];
      int x = led.getInt("x");
      int y = led.getInt("y");
      
      int[] ledMap = { x, y };
      stripMap[ii] = ledMap;
    }
    
    map[i] = stripMap;
  }
}

void bindSaveMap() {
  
  if (key == 's') {
    if (!backupMap()) {
      println("Backup failed, press 'd' to dump XML to console");
      return; 
    }
    
    XML document = generateMapXML();
    saveXML(document, "data/map.xml");
    return; 
  }
  
  if (key == 'd') {
    // genrate XML
    XML document = generateMapXML();
    
    // output to console
    println(document.toString());
    
    return;
  }
}

boolean backupMap() {
  
  String backupName = "map-" + year() + month() + day() + hour() + minute() + second() + ".xml";
  Path currentPath = Paths.get(sketchPath()+"/data/map.xml");
  Path backupPath = Paths.get(sketchPath()+"/data/backup/" + backupName);
  
  try{
    Files.copy(currentPath, backupPath);
    println("Backed up " + backupName);
    return true;
  } catch (IOException e) {
    println(e);
    return false;
  }
}

XML generateMapXML() {
  XML document = parseXML("<?xml version=\"1.0\"?><map></map>");
  document.setString("generated", "" + year() + month() + day() + hour() + minute() + second() + "");
  
  // loop strips
  for (int i = 0; i < map.length; i++) {
    XML strip = document.addChild("strip");
    
    // loop leds on the strip
    for (int ii = 0; ii < map[i].length; ii++) {
      XML led = strip.addChild("led");

      led.setInt("x", map[i][ii][0]);
      led.setInt("y", map[i][ii][1]);
    }
  }
  
  return document;
}

void drawMap() {

  // loop strips
  for (int i = 0; i < map.length; i++) {
    int[][] strip = map[i];
    
    // loop LEDs for that strip
    for (int ii = 0; ii < strip.length; ii++) {
      int[] led = strip[ii];
      color colourIndex = i % ledColours.length;
      
      noFill();
      strokeWeight(strokeSize);
      stroke(ledColours[colourIndex]);
      
      if (i == currentStrip && ii == currentLed) {
        if (key == 'z') {
          fill(activeColour);
        }
        stroke(activeColour);
      }
      
      int x = led[0] * magnification;
      int y = led[1] * magnification;
      
      rect(x, y, magnification - 1, magnification - 1);
      
    }
  }
}

void bindMoveMap() {  
  println(keyCode);
  switch (keyCode) {
    case 9: // tab
      nextMap();
      break;
      
    case 192: // ` ~
      previousMap();
      break;
      
    case 37: // arrow
      mapLeft();
      break;
     
    case 38: // arrow
      mapUp();
      break;
    
    case 39: // arrow
      mapRight();
      break;
        
    case 40: // dn arrow
      mapDown();
      break;
      
    case 65: //a
      addLed();
      nextMap();
      break;
      
    case 81: //q
      //addRowAndLed();
      break;
      
    case 49:
      goRow(0);
      break;
            
    case 50:
      goRow(1);
      break;
            
    case 51:
      goRow(2);
      break;
            
    case 52:
      goRow(3);
      break;
            
    case 53:
      goRow(4);
      break;
            
    case 54:
      goRow(5);
      break;
      
    case 55:
      goRow(6);
      break;
            
    case 56:
      goRow(7);
      break;
  }
}

void addLed() {
   // last strip
   int lastStripId = map[currentStrip].length - 1;
   int[] lastStrip = map[currentStrip][lastStripId];
   int x = lastStrip[0];
   int y = lastStrip[1];
   
   int[] newLed = { (x + 1), y };
   map[currentStrip] = (int[][])expand(map[currentStrip], map[currentStrip].length + 1);
   map[currentStrip][map[currentStrip].length - 1] = newLed;
   
}

void addRowAndLed() {
   // last strip
   int lastStripId = map[currentStrip].length - 1;
   int[] lastStrip = map[currentStrip][lastStripId];
   int x = lastStrip[0];
   int y = lastStrip[1];
   
   int[] newLed = { (x + 1), y };
   map[currentStrip] = (int[][])expand(map[currentStrip], map[currentStrip].length + 1);
   map[currentStrip][map[currentStrip].length - 1] = newLed;
   
}

void nextMap() {
  int totalLeds = map[currentStrip].length;
  
  if ((currentLed + 1) == totalLeds) {
    
    if ((currentStrip + 1) == map.length) {
      return;
    }
    
    currentLed = 0;
    currentStrip++;
    return;
  }
  
  currentLed++;
}

void goRow(int i) {
  currentStrip = i;
  currentLed = map[currentStrip].length - 1;
}

void previousMap() {  
  if (currentLed == 0) {
    
    if (currentStrip == 0) {
      return;
    }
    
    currentStrip--;
    currentLed = map[currentStrip].length - 1;
    return;
  }
  
  currentLed--;
}

void mapLeft() {
  int x = map[currentStrip][currentLed][0];
  x--;
  map[currentStrip][currentLed][0] = x;
}

void mapRight() {
  int x = map[currentStrip][currentLed][0];
  x++;
  map[currentStrip][currentLed][0] = x;
}

void mapUp() {
  int y = map[currentStrip][currentLed][1];
  y--;
  map[currentStrip][currentLed][1] = y;
}

void mapDown() {
  int y = map[currentStrip][currentLed][1];
  y++;
  map[currentStrip][currentLed][1] = y;
}
