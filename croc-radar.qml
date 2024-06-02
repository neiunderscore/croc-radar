import QtQuick 2.0
import USB2Snes 1.0
import "qrc:/extrajs.js" as Helper // Some extra javascript function
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles 1.4

Rectangle {
  width: 800;
  height: 600;
  id: window;
  color: "#191933";
  transformOrigin: Item.Center;

  Rectangle {
    width: window.width;
    height: window.height;
    id: frame;
    color: "pink";
    opacity: 1;
    transformOrigin: Item.Left;
    scale:800/2048;
    Drag.active: dragArea.drag.active
    property var locked: true;
    MouseArea {
      id: dragArea
      anchors.fill: parent
      drag.target: parent
      scale: 10000;
      onWheel: wheel => {frame.scale+=(wheel.angleDelta.y/1200); if(frame.scale<=0.1) frame.scale=0.2;}
      onClicked: mouse => zonemap.visible=!zonemap.visible;
      onDoubleClicked: mouse => {frame.locked=!frame.locked;zonemap.visible=!zonemap.visible;}
    }
    

  
Rectangle {
    width:    2048;
    height:   4384;
    id: game;
    color: "yellow";
    opacity: 1;
    Image {
      id: map
      source: "map.png"
      width:  game.width;
      height: game.height;
      opacity: 1;
    }
    Image {
      id: zonemap
      source: "zonemap.png"
      width:  game.width;
      height: game.height;
      opacity: 1;
      visible: true;
    }

    Rectangle {
      id:     dk
      width:  32;
      height: 32;
      color:  "yellow";
    }
    Rectangle {
      id:     bird;
      width:  32;
      height: 32;
      color:  "white";
    }
    Rectangle {
      id:     diddy
      width:  32;
      height: 32;
      color:  "red";
    }
    Rectangle {
      id:      x_line;
      width:   8;
      height:  game.height;
      color:   "red";
      opacity: 0.5;
    }
    Rectangle {
      id:      y_line;
      width:   game.width;
      height:  8; 
      color:   "red";
      opacity: 0.5;
    }
    Rectangle {
      id:           camera;
      width:        256 / 2048 * game.width;
      height:       224 / 4384 * game.height;
      color:        "transparent";
      border.color: "white";
      border.width: 8;
    }
    USB2Snes {
      id: usb2snes
      objectName: "usb2snes";							
      timer: 10;					//sets the refresh rate for the radar in ms. (1 frame ~= 16ms)
      onTimerTick: {
        var d_x = memory.readUnsignedWord(0x0B1D); 	//get diddy's x-pos from memory address 0x0B1D
        var d_y = memory.readUnsignedWord(0x0BC5); 	//get diddy's y-pos from memory address 0x0BC5
        var c_x = memory.readUnsignedWord(0x00BE); 	//get camera's x-pos from memory address 0x00BE
        var c_y = memory.readUnsignedWord(0x00C0); 	//get camera's y-pos from memory address 0x00C0
        var b_x = memory.readUnsignedWord(0x0B1F);	//get bird's x-pos from memory address 0x0B1F
        var b_y = memory.readUnsignedWord(0x0BC7);	//get bird's y-pos from memory address 0x0B1F
	var a_x = memory.readUnsignedWord(0x0B1B); 	//get dk's x-pos from memory address 0x0B1B
        var a_y = memory.readUnsignedWord(0x0BC3); 	//get dk's y-pos from memory address 0x0BC3

        camera.x = (c_x);				//move camera box's x-pos
        camera.y = (c_y - 3092);			//move camera box's y-pos, offset by ~3092 (i guessed)

        diddy.x =  (d_x)       - diddy.width  / 2;	//move diddy's x-pos
        diddy.y =  (25550-d_y) - diddy.height / 2;	//move diddy's y-pos, offset by ~25550 (i guessed)

        bird.x =  (b_x)        - bird.width  / 2;	//move bird's x-pos
        bird.y =  (25550-b_y)  - bird.height / 2;	//move bird's y-pos, offset by ~25550 (i guessed)

        dk.x =    (a_x)        - dk.width  / 2;		//move dk's x-pos
        dk.y =    (25550-a_y)  - dk.height / 2;		//move dk's y-pos, offset by ~25550 (i guessed)

        x_line.x = diddy.x + 12;			//move diddy's x-line
        y_line.y = diddy.y + 12;			//move diddy's y-line

	if(frame.locked) {
          frame.scale = window.width/game.width;
          frame.x=0; frame.y=0;
          var y = -(camera.y + camera.height/2 + diddy.y) / 2 + frame.height/2;	  
          if(y<-3300) game.y=-3300;
	  else if(y>-470) game.y=-470;
	  else game.y = y;
        }
      }
    }
  } 
}

}