import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import com.heroicrobot.dropbit.devices.pixelpusher.PixelPusher;
import com.heroicrobot.dropbit.devices.pixelpusher.PusherCommand;
import java.util.*;

DeviceRegistry registry;
PusherObserver observer;
boolean firstPush = true;

void initPusher() {
  registry = new DeviceRegistry();
  observer = new PusherObserver();
  registry.addObserver(observer);
  registry.setAntiLog(true);
}

void pushPixels() {
  loadPixels();
  
  

  if (observer.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();

    int stripIndex = 0;
     
    for(Strip strip : strips) {
      
      int[][] stripMap = map[stripIndex];
      
      for(int ii = 0; ii < stripMap.length; ii++) {
        int[] led = stripMap[ii];
        int x = round((led[0] * magnification) + (magnification / 2));
        int y = round((led[1] * magnification) + (magnification / 2));
        
        color c = get(x, y);  
        strip.setPixel(c, ii);
      }
      
      stripIndex++;
    }
  }
  
  updatePixels();
      List<PixelPusher> pushers = registry.getPushers();
    
    if (firstPush) {
    for (PixelPusher p: pushers) {
       PusherCommand pc = new PusherCommand(PusherCommand.GLOBALBRIGHTNESS_SET, (short)(3000));
       spamCommand(p,  pc);
    }
    firstPush = false;
    }
}

class PusherObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice != null) {
      println("Device change: " + updatedDevice);
    }
    this.hasStrips = true;
  }
};

void spamCommand(PixelPusher p, PusherCommand pc) {
   for (int i=0; i<3; i++) {
    p.sendCommand(pc);
  }
}

void spamBrightness() {
  List<PixelPusher> pushers = registry.getPushers();
  
  if (millis() < 99) {
    for (PixelPusher p: pushers) {
       PusherCommand pc = new PusherCommand(PusherCommand.GLOBALBRIGHTNESS_SET, (short)(2500));
       spamCommand(p,  pc);
    }
  }
}

void mousePressed() {
  List<PixelPusher> pushers = registry.getPushers();
  println(mouseY);
    for (PixelPusher p: pushers) {
       PusherCommand pc = new PusherCommand(PusherCommand.GLOBALBRIGHTNESS_SET, (short)(8500));
       spamCommand(p,  pc);
    }
 
}
