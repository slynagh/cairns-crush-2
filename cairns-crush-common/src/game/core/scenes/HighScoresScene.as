package game.core.scenes
{
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	
	import game.utils.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class HighScoresScene extends Sprite
	{
		public function HighScoresScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace("High Scores scene added");
			
			createHeader();
		
		}
		
		private function createHeader():void
		{
			var titleTexture:Texture = Assets.getAtlas("HighScoresScreen").getTexture("HighScoresTitle0000");
			var title:Image = new Image(titleTexture);
			title.x=20;
			title.y=20;
			this.addChild(title);
		}
		
		private function createList():void
		{
			var list:List = new List();
			list.width = stage.stageWidth;
			list.height = stage.stageHeight;
			this.addChild(list);
			
			var assets:Assets = Assets.instance;
			var groceryList:ListCollection = new ListCollection(
				[
					{ text: "Bomb", thumbnail: assets.getGemsTexture( "Bomb" )},
					{ text: "Gem1", thumbnail: assets.getGemsTexture("Gem1") },
					{ text: "Gem2", thumbnail: assets.getGemsTexture("Gem2") },
					{ text: "Gem3", thumbnail: assets.getGemsTexture("Gem3") },
					{ text: "Gem4", thumbnail: assets.getGemsTexture("Gem4") },
					{ text: "Gem5", thumbnail: assets.getGemsTexture("Gem5") },
					{ text: "Gem6", thumbnail: assets.getGemsTexture("Gem6") },
					{ text: "Light", thumbnail: assets.getGemsTexture("Light") },
					{ text: "Bomb", thumbnail: assets.getGemsTexture( "Bomb" )},
					{ text: "Gem1", thumbnail: assets.getGemsTexture("Gem1") },
					{ text: "Gem2", thumbnail: assets.getGemsTexture("Gem2") },
					{ text: "Gem3", thumbnail: assets.getGemsTexture("Gem3") },
					{ text: "Gem4", thumbnail: assets.getGemsTexture("Gem4") },
					{ text: "Gem5", thumbnail: assets.getGemsTexture("Gem5") },
					{ text: "Gem6", thumbnail: assets.getGemsTexture("Gem6") },
					{ text: "Light", thumbnail: assets.getGemsTexture("Light") },
					{ text: "Bomb", thumbnail: assets.getGemsTexture( "Bomb" )},
					{ text: "Gem1", thumbnail: assets.getGemsTexture("Gem1") },
					{ text: "Gem2", thumbnail: assets.getGemsTexture("Gem2") },
					{ text: "Gem3", thumbnail: assets.getGemsTexture("Gem3") },
					{ text: "Gem4", thumbnail: assets.getGemsTexture("Gem4") },
					{ text: "Gem5", thumbnail: assets.getGemsTexture("Gem5") },
					{ text: "Gem6", thumbnail: assets.getGemsTexture("Gem6") },
					{ text: "Light", thumbnail: assets.getGemsTexture("Light") },
					{ text: "Bomb", thumbnail: assets.getGemsTexture( "Bomb" )},
					{ text: "Gem1", thumbnail: assets.getGemsTexture("Gem1") },
					{ text: "Gem2", thumbnail: assets.getGemsTexture("Gem2") },
					{ text: "Gem3", thumbnail: assets.getGemsTexture("Gem3") },
					{ text: "Gem4", thumbnail: assets.getGemsTexture("Gem4") },
					{ text: "Gem5", thumbnail: assets.getGemsTexture("Gem5") },
					{ text: "Gem6", thumbnail: assets.getGemsTexture("Gem6") },
					{ text: "Light", thumbnail: assets.getGemsTexture("Light") }
				]);
			list.dataProvider = groceryList;
			
			
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.labelFactory = function():ITextRenderer
				{
					var tftr:TextFieldTextRenderer = new TextFieldTextRenderer();
					tftr.embedFonts = true;
					tftr.textFormat = new TextFormat("JennaSue", 48, 0x000000);
					return tftr;
				}
				renderer.iconSourceField = "thumbnail";
				renderer.iconPosition = Button.ICON_POSITION_LEFT;
				renderer.horizontalAlign = "left";
				renderer.gap = 15;
				renderer.padding = 15;
				
				return renderer;
			}	
		}
	}
}