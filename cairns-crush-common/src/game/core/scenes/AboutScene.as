package game.core.scenes
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AboutScene extends Sprite
	{
		public function AboutScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace("About scene loaded");
		}
	}
}