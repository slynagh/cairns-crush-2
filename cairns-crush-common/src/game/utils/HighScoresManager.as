package game.utils
{
	public class HighScoresManager
	{
		public static const MODE_LOCAL:String = "local";
		public static const MODE_NETWORK:String = "network";
		
		private static var _highScores:Object = {};
		
		public static function get highScores():Object{
			return _highScores;
		}
	}
}