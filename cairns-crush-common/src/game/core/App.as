package game.core
{
	import game.core.scenes.MainScene;
	import game.utils.Assets;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class App extends Sprite
	{
		private static var _instance:App ;
		public static function get instance():App{
			if(!_instance) _instance = new App();
			return _instance ;
		}
		//==========================================
		
		//[Embed(source="../../../assets/Bg.jpg")]
		//public static const BG:Class;
		
		[Embed(source="../../../assets/scorefont.png")]
		public static const SCOREFONT:Class;
		[Embed(source="../../../assets/scorefont.fnt",mimeType="application/octet-stream")]
		public static const SCOREFONT_FNT:Class;
		
		private var _sceneContainer:Sprite ;
		//private var _overlay:Image;
		
		
		public function App()
		{
			super();
			if(_instance) throw new Error("Only one instance can be instantiated");
			_instance = this ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler);
		}
		
		private function addedHandler( e:Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			var numberFont:BitmapFont=new BitmapFont(Texture.fromBitmap(new SCOREFONT(),false),XML(new SCOREFONT_FNT()));
			TextField.registerBitmapFont( numberFont , "NumberFont");
			
			//simple white background under all screens
			var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight);
			this.addChild(bg);
			
			_sceneContainer = new Sprite();
			addChild(_sceneContainer);
			
			//light texture overlay over entire app
			var _overlay:Image = new Image(Assets.getTexture("CanvasTextureSoftVignette"));//(Texture.fromBitmap(new BG(),false));
			_overlay.touchable=false;
			_overlay.width = stage.stageWidth ;
			_overlay.height = stage.stageHeight ;
			_overlay.blendMode = BlendMode.MULTIPLY;
			addChild(_overlay);
			
			showScene(new MainScene());
			//showScene(new HighScoresScene());
		}
		
		public function showScene( scene:Sprite):void
		{
			_sceneContainer.removeChildren(0,-1,true);
			_sceneContainer.addChild(scene);
		}
	}
}