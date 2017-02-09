package
{
	//import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import game.core.App;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(width="640", height="960", frameRate="60", backgroundColor="#000000")]
	public class CairnsCrushWeb extends Sprite
	{
		private var _starling:Starling;
		
		public function CairnsCrushWeb()
		{
			super();
			// Support for autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color=0;
			stage.frameRate=60;
			
			Starling.handleLostContext = true ; //Deprecated in Starling 2.0!!
			Starling.multitouchEnabled = false ;
			
			//Game design width and height
			var stageW:Number = 640 ;
			var stageH:Number = 960 ;
			
			/*
			var factor:Number = stageW/stageH ;
			if(stage.fullScreenWidth/stage.fullScreenHeight>factor)
			{
				//Landscape, such as iphone5, so need to re-set the width, the high is the same
				stageW = stageH*stage.fullScreenWidth/stage.fullScreenHeight ;
			}
			else
			{
				//Portrait
				stageH = stageW*stage.fullScreenHeight/stage.fullScreenWidth;
			}
			*/
			
			/*
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageW, stageH), 
				new Rectangle(0, 0,stage.fullScreenWidth , stage.fullScreenHeight ),
				ScaleMode.SHOW_ALL,false);
			*/
			
			_starling=  new Starling(App,stage, null, null, "auto", "auto");
			_starling.stage.stageWidth = stageW;
			_starling.stage.stageHeight = stageH ;
			_starling.showStats = true ;
			_starling.showStatsAt("left","bottom");
			_starling.addEventListener("context3DCreate" , onContextCreated);
			
			
		}
		
		private function onContextCreated():void
		{
			_starling.removeEventListener("context3DCreate" , onContextCreated);
			_starling.start();
			
			_starling.stage.addEventListener(ResizeEvent.RESIZE, onResize);  //?? correct?
		}
		
		
		
		private function onResize(e:ResizeEvent):void
		{
			//TODO: make it work!
			trace ("resize");
			// set rectangle dimensions for viewPort:
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = e.width; viewPortRectangle.height = e.height;
			
			// resize the viewport:
			//Starling.current.viewPort = viewPortRectangle;
			Starling.current.viewPort = viewPortRectangle;
			
			// assign the new stage width and height:
			Starling.current.stage.stageWidth = e.width;
			Starling.current.stage.stageHeight = e.height;
		}
	}
}