package 
{
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class HighScores
	{
		public static const LOCAL_SCORING:int = 1;
		public static const ONLINE_SCORING:int = 2;
		public static const scoreMethod:int = LOCAL_SCORING;//ONLINE_SCORING;//
		public static const RESET_LOCAL_HIGHSCORES:Boolean = false;
		private static const ONLINE_SCORING_SAVE_URL:String = 'http://www.acrrm.org.au/game/gtAmph/'; 
		
		public var highScores:Array = new Array;
		
		private var currentHighScore:Number;
		private var highScoresSO:SharedObject; // * shared object if local method
		private var newArray:Array; //temp array for sorting online scores
		public var currentNickname:String = "";
		public var currentFullName:String = "";
		private var onlineScore:Array;
		private var loadedLength:int;
		private var hsNameTimeout:int = -1;
		
		public function HighScores()
		{
			if (RESET_LOCAL_HIGHSCORES){
				var highScoresSO:SharedObject = SharedObject.getLocal("doctorHighScores");
				highScoresSO.data.scores = new Array; // * no scores saved
			}
			
		}
		
		public function getHighScores(cb = false):void{
			var self:Object = this;
			updateHighScores(function():void{
				cb(self.highScores);
			});
		}
		
		public function updateHighScores(cb = false):void{
			
			if (scoreMethod == LOCAL_SCORING){
				// * For high scores
				highScoresSO = SharedObject.getLocal("doctorHighScores");
				if (highScoresSO.data.scores == undefined)
					highScoresSO.data.scores = new Array; // * no scores saved
				highScores = highScoresSO.data.scores;
				
				for (var i:int = 0; i < highScores.length; i++){
					highScores[i][3] = i;
				}
				
				highScores.sort(sortScores);
				
				if (cb !== false) cb();
				
			}else{// !!! update web method of high scoring
				var myLoader:URLLoader=new URLLoader(new URLRequest(ONLINE_SCORING_SAVE_URL+"highscores.txt?r="+ Math.random()));
				myLoader.addEventListener(Event.COMPLETE, completeHandler);
				
				highScores = new Array;
				
				function completeHandler(e:Event):void {
					
					var loadedText:URLLoader=URLLoader(e.target);
					//trace(loadedText.data);
					var myArray:Array=loadedText.data.split(/\r\n/);
					loadedLength = myArray.length;
					var scoresArray:Array = new Array();
					var newArray:Array = new Array();
					
					//trace (myArray.length);
					for (var i:int = 0; i < myArray.length-1; i++) {
						newArray[i]=myArray[i].split("|");
						newArray[i][3] = i;
					}
					
					highScores = newArray;
					onlineScore = newArray;
					
					highScores.sort(sortScores);
					
					if (cb !== false) cb();
				}
			}
			
		}
		
		// ** takes just the score amount and checks if they placed in the high scores
		public function checkIfHighScore(score):int{
			var scoresAboveMe:int = 0;
			for(var i:int in highScores){
				if (highScores[i][0] >= score)
					scoresAboveMe++;
			}
			return scoresAboveMe;
		}
		// ** takes score amt and name to save in the highscores
		public function insertHighScore(score, nickname, cb, fullName):void{
			if (nickname !== ''){
				if (this.currentNickname !== nickname){
					this.currentFullName = '';
				}
				this.currentNickname = nickname;
				if (this.currentFullName !== ''){
					this.currentFullName = fullName;
				}
			}
			
			if (fullName !== "") this.currentFullName = fullName;
			
			saveHighScores([score, nickname, fullName], function():void{
				highScores.sort(sortScores);
				if (cb !== null){
					cb();
				}
			});
		}
		public function startHsNameTimeout():void{
			if (this.hsNameTimeout != -1){
				this.stopHsNameTimeout();
			}
			var self:HighScores = this;
			this.hsNameTimeout = setTimeout(function():void{
				self.currentNickname = '';
				self.currentFullName = '';
				self.hsNameTimeout = -1;
			}, 10 * 1000);
		}
		public function stopHsNameTimeout():void{
			clearTimeout(this.hsNameTimeout);
		}
		
		private function saveHighScores(scoreInfo, cb):void{
			if (scoreMethod == LOCAL_SCORING){
				var pos:int = checkIfHighScore(scoreInfo[0]);
				for (var i:int = highScores.length; i > pos; i--){
					highScores[i] = highScores[i-1];
					highScores[i][3] = i;
				}
				highScores[pos] = (scoreInfo);
				highScores[pos][3] = pos;
				highScoresSO = SharedObject.getLocal("cryoScores");
				if (highScoresSO.data.scores == undefined)
					highScoresSO.data.scores = new Array; // * no scores saved
				highScoresSO.data.scores = highScores;
				cb();
				
			}else{
				//myData.email = emailAddress.text;
				var myRequest:URLRequest=new URLRequest(ONLINE_SCORING_SAVE_URL + "saveData.php");
				myRequest.method=URLRequestMethod.POST;
				var myData:URLVariables = new URLVariables();
				myData.score = scoreInfo[0];
				myData.nickname= scoreInfo[1];
				
				myRequest.data=myData;
				var loader:URLLoader = new URLLoader();
				//loader.dataFormat= URLLoaderDataFormat.VARIABLES;
				loader.addEventListener(Event.COMPLETE, function():void{ 
					updateHighScores(cb);
				});
				loader.load(myRequest);
				
			}
		}
		
		private function sortScores(a:Array, b:Array):int{
			return 0-sortOnTime(a,b); // ** sort on time also sorts by first ele in array, 0- because we want descending here
		}
		
		private function sortOnTime(a:Array, b:Array):int{
			//trace ("a: " + a + " " + typeof(a[0]));
			//trace ("b: " + b + " " + typeof(b[0]));
			var av:int = parseInt(a[0]);
			var bv:int = parseInt(b[0]);
			
			//trace("av: "+av+":"+typeof(av));
			//trace("bv: "+bv+":"+typeof(bv));
			
			if(av > bv) {
				return 1;
			} else if(av < bv) {
				return -1;
			} else  {
				// sorts on the key (entry 3 is the same as the key)
				return (a[3] < b[3] ? 1 : -1);
				//aPrice == bPrice
				//return 0;
			}
		}
	}
}