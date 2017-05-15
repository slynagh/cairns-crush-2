package game.ui
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import game.core.App;
	import game.core.scenes.GameScene;
	import game.utils.Assets;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameOverContainer extends Sprite
	{
		/** Background image. */
		private var bg:Quad;
		
		/** Message text field. */
		private var messageText:starling.text.TextField;
		
		/** Name entry text field. (ACRRM) */
		private var nameEntryLabel:starling.text.TextField;
		private var nameEntryText:flash.text.TextField;
		
		/** Name entry text field for extra details--to show for 1st places only. (ACRRM) */
		private var nameEntryFullLabel:starling.text.TextField;
		private var nameEntryFullText:flash.text.TextField;
		
		/** Score container. */
		private var scoreContainer:Sprite;
		
		/** Score display - distance. */
		private var distanceText:starling.text.TextField;
		
		/** Score display - score. */
		private var scoreText:starling.text.TextField;
		
		/** Play again button. */
		//private var playAgainBtn:Button;
		
		/** Main Menu button. */
		private var mainBtn:Button;
		
		/** About button. */
		//private var aboutBtn:Button;
		
		/** Font - score display. */
		//private var fontScore:Font;
		
		/** Font - message display. */
		//private var fontMessage:Font;
		
		/** Score value - distance. */
		//private var _distance:int;
		
		/** Score value - score. */
		private var _score:int;
		private var _highScores:HighScores;
		//private var helpBtn:Button;
		
		public function GameOverContainer()
		{
			super();
			trace("GameOverContainer loaded");
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace ("GameOverContainer added");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this._highScores = App.instance.highScores;
			drawGameOver();
		}
		
		private function drawGameOver():void
		{
			// Get fonts for text display.
			//fontMessage = Fonts.getFont("ScoreValue");
			//fontScore = Fonts.getFont("ScoreLabel");
			
			// Background quad.
			bg = new Quad(stage.stageWidth, stage.stageHeight, 0xffffff);
			bg.alpha = 0.9;
			this.addChild(bg);
			
			// Message text field.
			messageText = new starling.text.TextField(stage.stageWidth, stage.stageHeight * 0.5, "High Score!", "JennaSue", 48,  0x5F680C);
			messageText.vAlign = VAlign.TOP;
			messageText.height = messageText.textBounds.height;
			messageText.y = 130;
			this.addChild(messageText);
			
			/** ACRRM { */
			var inputTextFormat:TextFormat = new TextFormat("Arial", 24, 0x5F680C);
			
			// Name input text field label.
			nameEntryLabel = new starling.text.TextField(stage.stageWidth*0.25, stage.stageHeight * 0.5, "Enter your name", "JennaSue", 36,  0x5F680C);
			nameEntryLabel.vAlign = VAlign.TOP;
			nameEntryLabel.hAlign = HAlign.RIGHT;
			nameEntryLabel.height = nameEntryLabel.textBounds.height;
			nameEntryLabel.x = 0; 
			nameEntryLabel.y = stage.stageHeight * 0.3;
			this.addChild(nameEntryLabel);
			
			// Name input text field.
			nameEntryText = new flash.text.TextField();//stage.stageWidth*0.5, stage.stageHeight * 0.5, "", GameConstants.FONT_NAME_MAIN, 36,  GameConstants.COLOR_SECONDARY);
			inputTextFormat.align = TextFormatAlign.CENTER;
			nameEntryText.defaultTextFormat = inputTextFormat;
			nameEntryText.type = TextFieldType.INPUT;
			nameEntryText.background = true;
			nameEntryText.backgroundColor = 0xf2e3db; 
			
			nameEntryText.text = "";
			nameEntryText.height = 24 *1.5;
			nameEntryText.width = stage.stageWidth*0.4;
			nameEntryText.x = (stage.stageWidth>>1)-(nameEntryText.width>>1);
			nameEntryText.y = stage.stageHeight * 0.3;
			//this.addChild(nameEntryText);
			nameEntryText.visible = false;
			Starling.current.nativeOverlay.addChild(nameEntryText);
			
			// Full name input text field label.
			nameEntryFullLabel = new starling.text.TextField(stage.stageWidth*0.25, stage.stageHeight * 0.5, "Your full name", "JennaSue", 36,  0x5F680C);
			nameEntryFullLabel.vAlign = VAlign.TOP;
			nameEntryFullLabel.hAlign = HAlign.RIGHT;
			nameEntryFullLabel.height = nameEntryFullLabel.textBounds.height;
			nameEntryFullLabel.x = 0; 
			nameEntryFullLabel.y = nameEntryLabel.height + nameEntryLabel.y + 50;
			this.addChild(nameEntryFullLabel);
			
			// Full name input text field.
			nameEntryFullText = new flash.text.TextField();//stage.stageWidth*0.5, stage.stageHeight * 0.5, "", GameConstants.FONT_NAME_MAIN, 36,  GameConstants.COLOR_SECONDARY);
			inputTextFormat.align = TextFormatAlign.CENTER;
			nameEntryFullText.defaultTextFormat = inputTextFormat;
			nameEntryFullText.type = TextFieldType.INPUT;
			nameEntryFullText.background = true;
			nameEntryFullText.backgroundColor = 0xf2e3db;
			nameEntryFullText.text = "";
			nameEntryFullText.height = 24 *1.5;
			nameEntryFullText.width = stage.stageWidth*0.4;
			nameEntryFullText.x = (stage.stageWidth>>1)-(nameEntryFullText.width>>1); 
			nameEntryFullText.y = nameEntryFullLabel.y
			nameEntryFullText.visible = false;
			Starling.current.nativeOverlay.addChild(nameEntryFullText);
			/** } end ACRRM */
			
			// Score			
			scoreText = new starling.text.TextField(stage.stageWidth, 100, "Score: 0000000", "JennaSue", 24, 0x5F680C); 
			scoreText.vAlign = VAlign.TOP;
			scoreText.height = scoreText.textBounds.height;
			scoreText.x = (stage.stageWidth>>1)-(scoreText.width>>1);
			scoreText.y = nameEntryFullText.y + nameEntryFullText.height + 50;//distanceText.bounds.bottom + scoreText.height * 0.5;
			this.addChild(scoreText);
			
			// Navigation buttons.
			
			//var buttonGuide:int = 900;//use this number to align the buttons' x coord
			//var buttonSpacing:int = 140;//use this number for the vertical spacing of buttons
			//var scale:Number = 0.7;
			mainBtn = new Button(Assets.getAtlas("Buttons").getTexture("BtnDone0000"));
			//mainBtn.scaleX = mainBtn.scaleY = scale;
			mainBtn.x = stage.stageWidth/2 - mainBtn.width/2;//buttonGuide - (mainBtn.width>>1);
			mainBtn.y = (stage.stageHeight)-300;;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			
			/*playAgainBtn = new Button(Assets.getAtlas("Doctor").getTexture("playAgainButton0000"));
			playAgainBtn.scaleX = playAgainBtn.scaleY = scale;
			playAgainBtn.x = buttonGuide - (playAgainBtn.width>>1);
			playAgainBtn.y = mainBtn.y + buttonSpacing;
			playAgainBtn.addEventListener(Event.TRIGGERED, onPlayAgainClick);
			this.addChild(playAgainBtn);*/
			
			/*helpBtn = new Button(Assets.getAtlas("Doctor").getTexture("welcome_helpButton0000"));
			helpBtn.scaleX = helpBtn.scaleY = scale;
			helpBtn.x = buttonGuide - (helpBtn.width>>1);
			helpBtn.y = playAgainBtn.y + buttonSpacing;
			helpBtn.addEventListener(Event.TRIGGERED, onHelpClick);
			this.addChild(helpBtn);*/
			
			//draw highscore entry
		}
		
		private function showButtons():void{
			mainBtn.visible = true;
		}
		
		private function onMainClick():void
		{
			_highScores.insertHighScore(this._score, this.nameEntryText.text, null, this.nameEntryFullText.text);
			Starling.current.nativeOverlay.removeChild(nameEntryFullText);
			Starling.current.nativeOverlay.removeChild(nameEntryText);
			nameEntryFullText = null;
			nameEntryText = null;
			
			var parent:GameScene = this.parent as GameScene;
			parent.showMainScene();
		}		
		
		public function initialize(_score:int):void
		{
			//this._distance = _distance;
			trace("Score :"+_score);
			this._score = _score;
			var self:GameOverContainer = this;
			_highScores.updateHighScores(function():void{
				trace ("CallBack...");
				var isHighScore:int = _highScores.checkIfHighScore(self._score);
				nameEntryText.text =  _highScores.currentNickname;
				nameEntryFullText.text = _highScores.currentFullName;
				_highScores.startHsNameTimeout();
				
				trace ("isHighScore :"+isHighScore);
				
				if (isHighScore === 0){
					// top score!
					nameEntryText.visible = true;
					nameEntryLabel.visible = true;
					nameEntryFullText.visible = true;
					nameEntryFullLabel.visible = true;
					
				}else if (isHighScore < 10){
					nameEntryText.visible = true;
					nameEntryLabel.visible = true;
					nameEntryFullText.visible = false;
					nameEntryFullLabel.visible = false;
					nameEntryFullText.text = "";
					
				}else{
					nameEntryText.visible = false;
					nameEntryLabel.visible = false;
					nameEntryFullText.visible = false;
					nameEntryFullLabel.visible = false;
					nameEntryFullText.text = "";
					nameEntryText.text = "";
				}
				
				//self.alpha = 0;
				//self.visible = true;
			});
			
			//self.alpha = 0;
			//self.visible = true;
			//distanceText.text = "DISTANCE TRAVELLED: " + this._distance.toString();
			scoreText.text = "SCORE: " + this._score.toString();
			showButtons();
		}
		
		public function get score():int { return _score; }
	}
}