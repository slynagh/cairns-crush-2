package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import game.core.App;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class CairnsCrushMobile extends Sprite
	{
		private var _starl:Starling ;
		
		public function CairnsCrushMobile()
		{
			super();
			
			// Support for autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color=0;
			stage.frameRate=60;
			
			//Starling.handleLostContext = isAndroid ; //Deprecated in Starling 2.0!!
			Starling.multitouchEnabled = false ;
			
			
			//Game design width and height
			var stageW:Number = 640 ;
			var stageH:Number = 960 ;
			
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
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageW, stageH), 
				new Rectangle(0, 0,stage.fullScreenWidth , stage.fullScreenHeight ), 
				ScaleMode.SHOW_ALL,false);
			
			_starl=  new Starling(App,stage,viewPort);
			_starl.stage.stageWidth = stageW;
			_starl.stage.stageHeight = stageH ;
			_starl.showStats = true ;
			_starl.showStatsAt("left","bottom");
			_starl.addEventListener("context3DCreate" , onContextCreated);
		}
		
		private function onContextCreated():void
		{
			_starl.removeEventListener("context3DCreate" , onContextCreated);
			_starl.start();
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE , activeHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , deactiveHandler);
		}
		
		private function activeHandler(e:Event):void
		{
			_starl.start() ;
		}
		
		private function deactiveHandler(e:Event):void
		{
			_starl.stop() ;
			if(isAndroid)
				NativeApplication.nativeApplication.exit();
		}
		
		//---------------------------------------------------------------
		private function  get isAndroid():Boolean{
			return Capabilities.manufacturer.indexOf('Android') > -1;
		}
		private function  get isIOS():Boolean{
			return Capabilities.manufacturer.indexOf('iOS') > -1;
		}
	}
}