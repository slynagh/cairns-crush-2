package game.core.scenes
{	
	import game.Config;
	import game.core.App;
	import game.utils.Assets;
	import game.utils.DataUtil;
	import game.utils.SoundManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	
	public class MainScene extends Sprite
	{
		private var _gems:Array ;
		private var _gemsAnim:Sprite ;
		private var _kGemSize:int = 50;
		private var title:Image;
		private var btnPlay:Button;
		private var btnAbout:Button ;
		private var btnHighScores:Button;
		private var babdImage:Image;
		private var highScore:TextField ;
		private var txt:TextField ;
		
		public function MainScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			SoundManager.instance.playLoop();
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			_gems = [] ;
			
			babdImage = new Image( Assets.getTexture("babdImage"));
			babdImage.x=(stage.stageWidth>>1) - (babdImage.width>>1);
			babdImage.y=stage.stageHeight - babdImage.height - 20;
			this.addChild(babdImage);
			
			_gemsAnim = new Sprite();
			_gemsAnim.touchable=false;
			addChild(_gemsAnim);
			
			title = new Image( Assets.getTexture("LogoMain") );
			title.touchable = false ;
			title.pivotX = title.width>>1;
			title.pivotY = title.height>>1;
			title.x = stage.stageWidth>>1;
			title.y = -title.height;
			title.rotation = deg2rad(2);
			//title.scaleX = title.scaleY = 0;
			var titleTween:Tween = new Tween(title,1,Transitions.EASE_OUT_BOUNCE);
			titleTween.animate("y", 240);
			var titleSwing:Tween = new Tween(title, 2, Transitions.EASE_IN_OUT);
			titleSwing.rotateTo(deg2rad(-2));
			titleSwing.repeatCount = 0;
			titleSwing.reverse = true;
			Starling.juggler.add( titleTween );
			Starling.juggler.add( titleSwing );
			addChild( title );
			
			btnPlay = new Button( Assets.getTexture("BtnPlay") );
			btnPlay.pivotX = btnPlay.width>>1;
			btnPlay.pivotY = btnPlay.height>>1;
			btnPlay.scaleX = btnPlay.scaleY = 0;
			btnPlay.x = stage.stageWidth>>1;
			btnPlay.y = stage.stageHeight>>1 ;
			var btnPlayTween:Tween = new Tween(btnPlay,0.5,Transitions.EASE_OUT_BOUNCE);
			btnPlayTween.delay = 0.5 ;
			btnPlayTween.scaleTo(1);
			Starling.juggler.add( btnPlayTween);
			addChild(btnPlay);
			
			if (Config.TARGET === "mobile")
			{
				if (DataUtil.instance.highScore > 0){
					var highScoreText:String = "High Score: " + DataUtil.instance.highScore;
					highScore = new TextField( stage.stageWidth,100,highScoreText,"JennaSue",64,0x5F680C);
					highScore.hAlign = HAlign.CENTER;
					
					highScore.y = 550;
					highScore.touchable=false;
					addChild(highScore);
				}
				
				//txt = new TextField( 100,64,"High Score","JennaSue",64,0x5F680C,true);
				//txt.y = highScore.y+72 ;
				//txt.nativeFilters = [ new GlowFilter(0)];
				//txt.touchable = false ;
				//addChild(txt);
			}
			else if (Config.TARGET === "web" )
			{
				btnAbout = new Button( Assets.getTexture("BtnAbout") );
				btnAbout.pivotX = btnAbout.width>>1;
				btnAbout.pivotY = btnAbout.height>>1;
				btnAbout.scaleX = btnAbout.scaleY = 0;
				btnAbout.x = 204;
				btnAbout.y = 532 ;
				var btnAboutTween:Tween = new Tween(btnAbout,0.5,Transitions.EASE_OUT_BOUNCE);
				btnAboutTween.delay = 0.75 ;
				btnAboutTween.scaleTo(1);
				Starling.juggler.add( btnAboutTween);
				addChild(btnAbout);
				
				btnHighScores = new Button( Assets.getTexture("BtnHighScores") );
				btnHighScores.pivotX = btnHighScores.width>>1;
				btnHighScores.pivotY = btnHighScores.height>>1;
				btnHighScores.scaleX = btnHighScores.scaleY = 0;
				btnHighScores.x = 426;
				btnHighScores.y = 532 ;
				var btnHighScoresTween:Tween = new Tween(btnHighScores,0.5,Transitions.EASE_OUT_BOUNCE);
				btnHighScoresTween.delay = 1 ;
				btnHighScoresTween.scaleTo(1);
				Starling.juggler.add( btnHighScoresTween);
				addChild(btnHighScores);
				
				btnHighScores.addEventListener( Event.TRIGGERED, onHighScoresClick );
				btnAbout.addEventListener( Event.TRIGGERED, onAboutClick );
			}
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME , update );
			btnPlay.addEventListener(Event.TRIGGERED , onPlay);
			
		}
		
		private function onPlay(e:Event):void
		{
			e.stopPropagation() ;
			SoundManager.instance.playClick();
			clearScreen("GameScene");
		}
		private function onHighScoresClick(e:Event):void
		{
			e.stopPropagation() ;
			SoundManager.instance.playClick();
			clearScreen("HighScoresScene");
		}
		private function onAboutClick(e:Event):void
		{
			e.stopPropagation() ;
			SoundManager.instance.playClick();
			clearScreen("AboutScene");
		}
		private function showGameScene():void
		{
			Starling.juggler.purge() ;
			var gameScene:GameScene = new GameScene();
			App.instance.showScene( gameScene );
		}
		
		private function showScene(sceneName:String):void
		{
			Starling.juggler.purge() ;
			var scene:Sprite;
			switch (sceneName)
			{
				case "GameScene":
					scene = new GameScene();
					break;
				case "AboutScene":
					scene = new AboutScene();
					break;
				case "HighScoresScene":
					scene = new HighScoresScene();
					break;
				default:
					throw new Error("Scene does not exist: "+sceneName);
					break;
				
			}
			App.instance.showScene( scene );
			/*
			var fullClassName:String = "game.core.scenes." + scene;
			var className:Class = getDefinitionByName(fullClassName) as Class;
			var sceneToShow:Sprite = new className();
			App.instance.showScene( sceneToShow );
			*/
		}
		
		private function clearScreen(newScene:String):void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME , update );
			//this.removeChild( highScore , true );
			//this.removeChild( txt , true );
			
			for (var i:int = 0; i < this._gemsAnim.numChildren; i++)
			{
				var gem:DisplayObject = this._gemsAnim.getChildAt(i);
				var tween:Tween = new Tween(gem,0.25);
				tween.fadeTo(0);
				Starling.juggler.add(tween);
			}
			
			var titleTween:Tween = new Tween(title,0.25);
			titleTween.scaleTo(0);
			titleTween.moveTo(title.x,title.y+100);
			Starling.juggler.add( titleTween);
			
			var btnPlayTween:Tween = new Tween(btnPlay,0.25);
			btnPlayTween.scaleTo(0);
			btnPlayTween.moveTo(btnPlay.x,btnPlay.y+100);
			Starling.juggler.add( btnPlayTween);
			
			if (game.Config.TARGET === "web")
			{
				var btnAboutTween:Tween = new Tween(btnAbout,0.25 );
				btnAboutTween.scaleTo(0);
				btnAboutTween.moveTo(btnAbout.x,btnAbout.y+100);
				Starling.juggler.add( btnAboutTween);
				
				var btnHighScoresTween:Tween = new Tween(btnHighScores,0.25);
				btnHighScoresTween.scaleTo(0);
				btnHighScoresTween.moveTo(btnHighScores.x, btnHighScores.y+100);
				btnHighScoresTween.onComplete = function():void{ showScene(newScene); }
				Starling.juggler.add( btnHighScoresTween );
			}
			else if (game.Config.TARGET === "mobile")
			{
				this.removeChild( highScore , true );
				this.removeChild( txt , true );
				showScene(newScene)
			}
			
			touchable=false;
		}
		
		private function update(e:Event):void
		{
			var gem:Object ;
			
			if (Math.random() < 0.02) 
			{
				var sprt:Image = new Image( Assets.instance.getGemsTexture("Gem"+Math.ceil(Math.random()*6)) );
				sprt.pivotX  = sprt.width>>1;
				sprt.pivotY = sprt.height>>1;
				
				var x:Number = Math.random()*stage.stageWidth;
				var y:Number = - _kGemSize/2;
				var scale:Number = 0.2 + 0.8 * Math.random();
				
				var speed:Number = 4*scale*_kGemSize/40;
				
				sprt.x = x ;
				sprt.y = y ;
				
				sprt.scaleX = sprt.scaleY = scale
				
				gem = {sprt:sprt, speed:speed};

				this._gems.push(gem);
				this._gemsAnim.addChild(sprt);
			}
			
			for (var i:int = this._gems.length-1; i >= 0; i--)
			{
				gem = this._gems[i];
				
				gem.sprt.y += gem.speed;
				
				if (gem.sprt.y > stage.stageHeight + _kGemSize/2)
				{
					this._gemsAnim.removeChild(gem.sprt, true);
					this._gems.splice(i, 1);
				}
			}
		}
	}
}