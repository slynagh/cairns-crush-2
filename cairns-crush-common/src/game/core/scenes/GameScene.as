package game.core.scenes
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import game.comm.GameData;
	import game.core.App;
	import game.core.item.Card;
	import game.core.item.Hint;
	import game.ui.GameOverContainer;
	import game.utils.Assets;
	import game.utils.CardFactory;
	import game.utils.CardUtil;
	import game.utils.DataUtil;
	import game.utils.SoundManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;
	
	public class GameScene extends Sprite
	{
		private static const STATE_START:String = "stateStart";
		private static const STATE_PLAYING:String = "statePlaying";
		private static const STATE_GAMEOVER:String = "stateGameOver";
		private static const STATE_HIGHSCORE:String = "stateHighScore";
		private static const STATE_PAUSED:String = "statePaused";
		private static const STATE_HIGHSCORE_INIT:String = "stateHighScoreInit";
		
		private var _gameState:String;
		
		private var _bgEffect:Sprite ;
		private var _topBar:Sprite ;
		private var _gemsCon:Sprite ;
		private var _hintCon:Sprite ;
		private var _effectCon:Sprite ;
		private var _effectTxtCon:Sprite ;
		private var _bottomCon:Sprite;
		private var _timerCon:Sprite ;
		private var _timerWidth:Number ;
		private var _txtScore:TextField;
		
		private var _time:int = 60*60; //60*60
		private var _hintTime:int;
		
		private var _clickInterval:int ; //The click interval
		private var _clickTime:int ; //The click interval
		private var _prevPoint:Point=new Point(); //Previous location
		private var _downParam:Number=0.5 ;
		private var _removeCount:int ;
		private var _removeTime:int ;
		private var _items:Array ;
		private var _downCard:Card ;
		private var _gGameOverGems:Array ;
		
		private var _gameIsOver:Boolean ;
		private var _gameIsStart:Boolean;
		
		private var _realScore:int ;
		private var _currScore:int ;
		
		private var _highScoreModal:GameOverContainer;
		private var tween_highScoreModal:Tween;
		
		public function GameScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , added);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added );
			SoundManager.instance.stopLoop();
			
			_highScoreModal = new GameOverContainer();
			_highScoreModal.visible = false;
			this.addChild(_highScoreModal);
			
			createBgEffect();
			
			_gemsCon = new Sprite();
			_gemsCon.x = (stage.stageWidth-640)/2 +40;
			_gemsCon.y = 160 +40;
			addChild(_gemsCon);
			_hintCon = new Sprite();
			_hintCon.x = _gemsCon.x; 
			_hintCon.y = _gemsCon.y; 
			_hintCon.touchable = false; 
			addChild(_hintCon);
			_effectCon = new Sprite();
			_effectCon.x = _gemsCon.x; 
			_effectCon.y = _gemsCon.y; 
			_effectCon.touchable =false;
			addChild(_effectCon);
			_effectTxtCon = new Sprite();
			_effectTxtCon.x = _gemsCon.x; 
			_effectTxtCon.y = _gemsCon.y; 
			_effectTxtCon.touchable =false ;
			addChild(_effectTxtCon);
			
			createBottom();
			createTopBar() ;
			
			
			initCards();
			initShowCards();
			
			_prevPoint = new Point(x,y);
			
			_gameState = STATE_START;
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME , update );
			_gemsCon.addEventListener( TouchEvent.TOUCH , onTouch);
			
			var go:Image = new Image(  Assets.instance.getUITexture("go") );
			go.pivotX = go.width>>1;
			go.pivotY = go.height>>1;
			go.touchable=false ;
			go.scaleX = go.scaleY = 0 ;
			go.x = stage.stageWidth/2;
			go.y = stage.stageHeight/2;
			addChild(go);
			
			var removeTween:Tween = new Tween(go,0.25,Transitions.EASE_IN);
			removeTween.scaleTo(0);
			removeTween.onComplete = function():void
			{
				removeChild(go,true);
				//_gameIsStart = true ;
				_gameState = STATE_PLAYING;
			}
			
			var tween:Tween = new Tween(go,0.5,Transitions.EASE_OUT_ELASTIC);
			tween.delay = 1;
			tween.scaleTo(1);
			tween.nextTween = removeTween ;
			Starling.juggler.add(tween);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			//if(_gameIsStart)
			if (_gameState === STATE_PLAYING)
			{
				var touch:Touch = e.touches[0];
				if(touch.target && touch.target.parent is Card )
				{
					var card:Card = touch.target.parent as Card;
					if(card.type>-1 && card.y == card.ty*80)
					{
						if(touch.phase==TouchPhase.BEGAN)
						{
							_downCard = card ;
							
							if(_hintCon.numChildren>0) _hintCon.removeChildren(0,-1,true);
							_hintTime =0 ;
						}
						else if(touch.phase==TouchPhase.ENDED)
						{
							if(card == _downCard)
							{
								clickHandler();
								_downCard = null ;
							}
						}
					}
				}
			}
		}
		
		private function clickHandler():void
		{
			var flag:Boolean;
			if(_downCard.type>0)
			{
				var roundCards:Vector.<Card> = CardUtil.cardSearchRoundSame(_downCard,_items);
				if(roundCards && roundCards.length>2)
				{
					destroyCards( roundCards );
					flag = true ;
				}
				else
				{
					SoundManager.instance.playMiss();
				}
			}
			else
			{
				//Click on the bomb
				var cards:Vector.<Card> = CardUtil.getRowColCards( _items,_downCard.tx,_downCard.ty,3);
				destroyCards( cards , 1 );
				flag = true ;
			}
			if(flag)
			{
				//Determine if fire should be added
				if(getTimer()-_clickInterval<=800)
				{
					this._clickTime++;
					if(this._clickTime>=4){
						_clickTime=4;
					}
				}
				else
				{
					_clickTime = 0;
				}
				switch(_clickTime)
				{
					case 0:
						SoundManager.instance.playGem0();
						break ;
					case 1:
						SoundManager.instance.playGem1();
						break ;
					case 2:
						SoundManager.instance.playGem2();
						break ;
					case 3:
						SoundManager.instance.playGem3();
						break ;
					case 4:
						SoundManager.instance.playGem4();
						break ;
				}
				_clickInterval = getTimer();
			}
		}
		
		
		/**
		 * Destroyed from the interface and array
		 * @param explosionType 0 means no, 1, 2
		 */
		private function destroyCards(cards:Vector.<Card> ,explosionType:int = 0 ):void
		{
			_realScore += cards.length*(_clickTime+1) ;
			
			_downParam=0.25 ;
			_removeCount++;
			for each (var card:Card in cards)
			{
				if(card.type>0 || card == _downCard){
					card.type = -1 ;
					card.touchable=false ;
					card.destroy();
				}
			}
			
			if(explosionType==0 && cards.length>5)
			{
				card = new Card(0);
				card.tx = _downCard.tx ;
				card.ty = _downCard.ty ;
				card.x = _downCard.x ;
				card.y = _downCard.y ;
				_items[_downCard.ty][_downCard.tx] = card ;
				_gemsCon.addChild(card); 
				
				setTimeout(refreshAll,200);
			}
			else if(explosionType==1)
			{
				SoundManager.instance.playBomb();
				//Ranks of bombs
				var effect1:Image = new Image(Assets.instance.getUITexture("bomb-explo-inner"));
				effect1.blendMode = BlendMode.ADD ;
				effect1.touchable = false ;
				effect1.pivotX = effect1.width>>1;
				effect1.pivotY = effect1.height>>1;
				effect1.x = _downCard.x ;
				effect1.y = _downCard.y ;
				effect1.width=0;
				Starling.juggler.tween( effect1 ,0.25 , {
					transition: Transitions.EASE_OUT,
					width:80*GameData.COLS*2 ,
					onComplete:removeEffect1
				});
				
				function removeEffect1():void
				{
					Starling.juggler.tween(effect1,0.25,{
						alpha:0 ,
						delay:0.1,
						onComplete:function():void{
							effect1.removeFromParent(true);
						}
					});
				}
				
				_effectCon.addChild(effect1);
				
				var effect2:Image = new Image(Assets.instance.getUITexture("bomb-explo-inner"));
				effect2.blendMode = BlendMode.ADD ;
				effect2.touchable = false ;
				effect2.rotation = deg2rad(90);
				effect2.pivotX = effect2.width>>1;
				effect2.pivotY = effect2.height>>1;
				effect2.x = _downCard.x ;
				effect2.y = _downCard.y ;
				effect2.width=0;
				Starling.juggler.tween( effect2 ,0.25 , {
					transition: Transitions.EASE_OUT,
					width:80*GameData.ROWS*2 ,
					onComplete:removeEffect2
				});
				
				function removeEffect2():void
				{
					Starling.juggler.tween(effect2,0.25,{
						alpha:0 ,
						delay:0.1,
						onComplete:function():void{
							effect2.removeFromParent(true);
						}
					});
				}
				_effectCon.addChild(effect2);
				
				setTimeout(refreshAll,500);
			}
			else
			{
				setTimeout(refreshAll,200);
			}
		}
		
		private function refreshAll():void
		{
			if(_gameState === STATE_PLAYING)   //!_gameIsOver
			{
				var card:Card ;
				//Start the shift and create a new one
				for(var i:int = 0 ; i<GameData.ROWS ; i++)
				{
					for( var j:int = 0 ; j<GameData.COLS ; j++)
					{
						card = _items[i][j] as Card ;
						if(card.type==-1)
						{
							handleOneColumn(card);
						}
					}
				}
			}
		}	
		
		/** Processes the data in the item's column */
		private function handleOneColumn(card:Card):void 
		{
			var count:int = 0;//The number of typeId = -1 in this column
			var minEmptyItemTy:int = -1 ;//The minimum is empty
			var tempCard:Card = null ;
			for(var row:int = 0  ; row<GameData.ROWS ; row++ )
			{
				tempCard =_items[row][card.tx];
				if(tempCard.type == -1)
				{
					count++;
					minEmptyItemTy = tempCard.ty; 
				}
			}
			//The above is not empty objects as a whole move
			if(minEmptyItemTy>-1){
				var kongNum:int = 0 ;
				for(var k:int = minEmptyItemTy ; k>=0 ; k-- )
				{
					tempCard = _items[k][card.tx];
					if(tempCard.type>-1)
					{
						tempCard.ty += kongNum ;
						_items[tempCard.ty][card.tx]=tempCard; 
					}
					else
					{
						kongNum++;
					}
				}
			}
			
			//Create a new item
			for( k = 0 ; k<count ; k++)
			{
				tempCard = CardFactory.randomCreateCard();
				tempCard.tx = card.tx ;
				tempCard.ty = k ;
				tempCard.y = -80*(count-k)*2;
				tempCard.x = card.x;
				_gemsCon.addChild(tempCard); 
				_items[k][card.tx] = tempCard ;
			}
			if(getTimer()-_removeTime>1000 && tempCard && _removeCount>0 && _removeCount%10==0 )
			{
//				tempCard.addIcon( Math.round(Math.random()*3)+1 );
				_removeTime = getTimer() ;
			}
		}
		
		
		
		
		public function showMainScene():void
		{
			DataUtil.instance.highScore = _realScore ;
			this.touchable = false ;
			Starling.juggler.purge();
			var scene:MainScene = new MainScene();
			App.instance.showScene(scene);
		}
		
		private function createBgEffect():void
		{
			_bgEffect = new Sprite();
			_bgEffect.touchable = false ;
			addChild(_bgEffect);
			
			var effect1:Image = new Image( Assets.instance.getUITexture("bg-shimmer-0"));
			effect1.blendMode = BlendMode.ADD ;
			effect1.scaleX = effect1.scaleY = 3 ;
			effect1.x = (stage.stageWidth-effect1.width)/2;
			effect1.y = stage.stageHeight ;
			_bgEffect.addChild( effect1 );
			
			var effect2:Image = new Image( Assets.instance.getUITexture("bg-shimmer-1"));
			effect2.blendMode = BlendMode.ADD ;
			effect2.scaleX = effect2.scaleY = 3 ;
			effect2.x = (stage.stageWidth-effect2.width)/2;
			effect2.y = stage.stageHeight*2 ;
			_bgEffect.addChild( effect2 );
		}
		
		private function createTopBar():void
		{
			_topBar = new Sprite();
			addChild(_topBar);
			
			var headerBg:Image = new Image(Assets.instance.getUITexture("headerBg"));
			headerBg.width = stage.stageWidth ;
			headerBg.touchable = false ;
			_topBar.addChild(headerBg);
			var header:Image = new Image(Assets.instance.getUITexture("header"));
			header.x = (stage.stageWidth-header.width)/2 ;
			header.touchable = false ;
			_topBar.addChild(header);
			
			
			_timerCon = new Sprite();
			_timerCon.touchable=false;
			_topBar.addChild(_timerCon);
			var timerBar:Image = new Image( Assets.instance.getUITexture("timer"));   
			_timerCon.x =(stage.stageWidth-timerBar.width)/2  ;
			_timerCon.y = 85 ;
			_timerCon.addChild(timerBar);
			_timerWidth = timerBar.width ;
			_timerCon.clipRect = new Rectangle(0,0,_timerWidth,timerBar.height);
			
			_txtScore = new TextField( stage.stageWidth/2,80,"0","NumberFont",64,0x6B7A10);
			_txtScore.vAlign = VAlign.TOP;
			_txtScore.hAlign = HAlign.RIGHT ;
			_txtScore.touchable = false ;
			_txtScore.x = stage.stageWidth-_txtScore.width-10;
			_txtScore.y = 10;
			_topBar.addChild(_txtScore);
			
			
			var closeButton:Button = new Button(Assets.instance.getUITexture("btn-pause"),"",Assets.instance.getUITexture("btn-pause-down") );
			_topBar.addChild(closeButton);
			closeButton.addEventListener(Event.TRIGGERED , onCloseHandler);
			
			_topBar.y = -headerBg.height ;
			var tween:Tween = new Tween(_topBar,0.5,Transitions.EASE_OUT) ;
			tween.moveTo(0,0);
			tween.delay=0.5;
			Starling.juggler.add( tween );
		}
		
		private function onCloseHandler(e:Event):void
		{
			e.stopPropagation();
			SoundManager.instance.playClick();
			createGameOver();
		}
		
		private function createBottom():void
		{
			/*_bottomCon = new Sprite();
			_bottomCon.touchable = false ;
			addChild(_bottomCon);
			
			var bottom:Image = new Image(Assets.instance.getUITexture("bottom"));
			bottom.width = stage.stageWidth ;
			bottom.y = 960 ;
			bottom.touchable=false;
			_bottomCon.addChild(bottom);
			
			var title:Image = new Image( Assets.instance.getUITexture("title"));
			title.touchable = false ;
			title.pivotX = title.width>>1;
			title.pivotY = title.height>>1;
			title.rotation = deg2rad(-15);
			title.scaleX = title.scaleY = 0.5 ;
			title.y = bottom.y +title.pivotY-40 ;
			title.x = stage.stageWidth/2 ;
			_bottomCon.addChild(title);*/
		}
	
		/**
		 * Initializes an array of items
		 */		
		private function initCards():void
		{
			var card:Card ;
			_items = [];
			for(var i:int = 0 ; i<GameData.ROWS ; i++)
			{
				_items[i] = [];
				for( var j:int = 0 ; j<GameData.COLS ; j++)
				{
					card=CardFactory.randomCreateCard();
					card.ty = i ;
					card.tx = j ;
					_items[i][j] = card;
				}
			}
		}
		/**
		 * Initializes the position of the displayed item
		 */		
		private function initShowCards():void 
		{
			var card:Card ;
			for(var i:int = 0 ; i<GameData.ROWS ; i++)
			{
				for( var j:int = 0 ; j<GameData.COLS ; j++)
				{
					card = _items[i][j] as Card ;
					card.x = 80*j;
					card.y = 80*i - (j+GameData.ROWS-i)*80; 
					_gemsCon.addChild(card) ;
				}
			}
		}
		
		
		private function update( e:EnterFrameEvent ):void 
		{			
			if(_gameState === STATE_PAUSED) return;
			
			if(_gameState === STATE_START || _gameState === STATE_PLAYING)  //!_gameIsOver
			{
				var card:Card ;
				var noDown:Boolean=true; //Whether there is not finished out
				for(var i:int = 0 ; i<GameData.ROWS ; i++)
				{
					for( var j:int = 0 ; j<GameData.COLS ; j++)
					{
						card = _items[i][j] as Card ;
						if(card && card.type>-1){
							var endY:int = 80*card.ty ;
							if(card.y<endY){
								card.y+= 80*_downParam;
								noDown = false;
								if(card.y==endY){
									SoundManager.instance.playTap();
								}
							}else if( card.y>endY){
								card.y = endY ;
							}
						}else{
							noDown = false ;
						}
					}
				}
				
				if(_currScore<_realScore)
				{
					_currScore++;
					_txtScore.text = _currScore+"" ;
				}
				
				for(i=0;i<_bgEffect.numChildren;++i)
				{
					_bgEffect.getChildAt(i).y-=1;
					if(_bgEffect.getChildAt(i).y<-_bgEffect.height){
						_bgEffect.getChildAt(i).y = stage.stageHeight ;
					}
				}
				
				if(_gameState === STATE_PLAYING)   //_gameIsStart
				{
					_time-- ;
					if(_time>=0){
						_timerCon.clipRect.width = _timerWidth*_time/3600 ;
						if(_time==300){
							SoundManager.instance.playTimer();
						}
					}
					if(_time==0){
						createGameOver() ;
					}
				}
				if(noDown){
					++_hintTime;
					if(_hintTime==180){
						//3 seconds
						hint();
					}
				}
			}
			else if (_gameState === STATE_HIGHSCORE_INIT)
			{
				trace ("State: highscore init");
				this.setChildIndex(_highScoreModal, this.numChildren-1);
				//_highScoreModal.alpha = 0;
				//_highScoreModal.visible = true;
				_highScoreModal.initialize(_realScore);
				
				//tween_highScoreModal = new Tween(_highScoreModal, 1);
				//tween_highScoreModal.fadeTo(1);
				//Starling.juggler.add(tween_highScoreModal);
				_gameState = STATE_HIGHSCORE;
			}
			else if (_gameState === STATE_HIGHSCORE)
			{
				_highScoreModal.visible = true;
				//_highScoreModal.alpha = 0;			
				//Nothing to do here
			}
			else
			{
				updateGameOver();
			}
		}
		
		private function hint():void
		{
			var card:Card ;
			var flag:Boolean ;
			for(var i:int = GameData.ROWS-1 ; i>=0 ; --i )
			{
				for( var j:int = 0 ; j<GameData.COLS ; j++)
				{
					card = _items[i][j] as Card ;
					if(card  && card.y == card.ty*80)
					{
						if(card.type>0)
						{
							var cards:Vector.<Card> = CardUtil.cardSearchRoundSame( card,_items );
							if(cards && cards.length>2)
							{
								for each( card in cards){
									var h:Hint = new Hint();
									h.x = card.x ;
									h.y = card.y ;
									_hintCon.addChild(h);
								}
								flag = true ;
								//Jump out of the double loop
								i=-1 ;
								break ;
							}
						}
						else if(card.type==0)
						{
							flag = true ;
							//Jump out of the double loop
							i=-1 ;
							break ;
						}
					}
				}
			}
			if(!flag){
				//There is no elimination
				createGameOver();
			}
		}
		
		private function createGameOver():void
		{
			SoundManager.instance.stopTimer();
			SoundManager.instance.playEndGame();
			_hintCon.removeChildren(0,-1,true);
			
			_gGameOverGems = [];
			
			var card:Card ;
			for(var i:int = 0 ; i<GameData.ROWS ; i++)
			{
				for( var j:int = 0 ; j<GameData.COLS ; j++)
				{
					card = _items[i][j] ;
					
					var ySpeed:Number = (Math.random()*2-1)*0.1;
					var xSpeed:Number = (Math.random()*2-1)*0.1;
					
					var gameOverGem:Object = {sprite: card , xPos: j , yPos: i , ySpeed: ySpeed, xSpeed: xSpeed};
					_gGameOverGems.push(gameOverGem);
				}
			}
			var tween:Tween = new Tween(_topBar,0.5,Transitions.EASE_IN);
			tween.moveTo(0,-150);
			Starling.juggler.add(tween);
			
			tween = new Tween(_bottomCon,0.5);
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			
			_effectTxtCon.visible = false ;
			_effectCon.visible = false ;
			_hintCon.visible = false ;
			
			//_gameIsOver = true ;
			_gameState = STATE_GAMEOVER;
		}
		
		private function updateGameOver():void
		{
			var len:int = _gGameOverGems.length;
			var flag:Boolean = true ;
			var hsRank:int;
			for (var i:int = 0; i <len; i++)
			{
				var gem:Object = _gGameOverGems[i];
				
				gem.xPos = gem.xPos + gem.xSpeed;
				gem.yPos = gem.yPos - gem.ySpeed;
				gem.ySpeed -= 0.005;
				
				gem.sprite.x =gem.xPos*80 ;
				gem.sprite.y =gem.yPos*80 ;
				if(gem.sprite.y+40<stage.stageHeight){
					flag = false ;
				}
			}
			if(flag){
				//check for highscore
				hsRank = App.instance.highScores.checkIfHighScore(_realScore);
				//trace (hsRank);
				if(hsRank === 0)//new highest score!
				{
					_gameState = STATE_HIGHSCORE_INIT;
					trace ("A new High score!");
					//this.addChild(new GameOverContainer());
					
				}
				else if(hsRank < 10)//Made the list
				{
					_gameState = STATE_HIGHSCORE_INIT;
					trace ("A top ten score!");
					//this.addChild(new GameOverContainer());
				}
				else this.showMainScene();
			}
		}		
		
		override public function dispose():void
		{
			super.dispose();
			_prevPoint = null ;
			_items = null ;
		}
	}
}