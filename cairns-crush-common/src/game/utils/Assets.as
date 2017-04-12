package game.utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private static var _instance:Assets ;
		public static function get instance():Assets{
			if(!_instance) _instance = new Assets();
			return _instance ;
		}
		//==========================================
		
		/*
		Atlases
		*/
		[Embed(source="/../assets/Gems_HD.png")]
		public static const Gems_HD:Class
		[Embed(source="/../assets/Gems_HD.xml",mimeType="application/octet-stream")]
		public static const Gems_HD_XML:Class
		
		[Embed(source="/../assets/UI_SD.png")]
		public static const UI_SD:Class;
		[Embed(source="/../assets/UI_SD.xml",mimeType="application/octet-stream")]
		public static const UI_SD_XML:Class;
		
		/*
		images
		*/
		[Embed(source="/../assets/ui/BtnAbout.png")]
		public static const BtnAbout:Class;
		[Embed(source="/../assets/ui/BtnHighScores.png")]
		public static const BtnHighScores:Class;
		[Embed(source="/../assets/ui/BtnPlay.png")]
		public static const BtnPlay:Class;
		[Embed(source="/../assets/logo_main.png")]
		public static const LogoMain:Class;
		[Embed(source="/../assets/babdImage.png")]
		public static const babdImage:Class;
		
		
		[Embed(source="/../assets/canvas-texture.jpg")]
		public static const CanvasTexture:Class;
		[Embed(source="/../assets/canvas-texture-soft.jpg")]
		public static const CanvasTextureSoft:Class;
		[Embed(source="/../assets/canvas-texture-soft-vignette.jpg")]
		public static const CanvasTextureSoftVignette:Class;
		
		
		
		/*
		Fonts
		*/
		[Embed(fontName="JennaSue", source="/../assets/fonts/JennaSue.ttf", mimeType="application/x-font-truetype", embedAsCFF="false")] 
		public static const JennaSue:Class;
		
		[Embed(fontName="OpenSans-Light", fontWeight="normal", fontFamily="OpenSans", source="/../assets/fonts/OpenSans-Light.ttf", mimeType="application/x-font-truetype", embedAsCFF="false")]
		public static const OpensSansLight:Class;
		
		[Embed(fontName="OpenSans-Semibold", fontWeight="bold", fontFamily="OpenSans", source="/../assets/fonts/OpenSans-Semibold.ttf", mimeType="application/x-font-truetype", embedAsCFF="false")]
		public static const OpensSansSemiBold:Class;
		
		private static var _textures:Dictionary = new Dictionary();
		private static var _gemsAtlas:TextureAtlas ;
		private static var _uiAtlas:TextureAtlas ;
		
		public function Assets()
		{
			_gemsAtlas = new TextureAtlas( Texture.fromBitmap( new Gems_HD(),false,false,2)  , XML( new Gems_HD_XML()) );
			
			_uiAtlas = new TextureAtlas( Texture.fromBitmap( new UI_SD(),false)  , XML( new UI_SD_XML()) );
		}
		
		public function getGemsTexture( name:String ):Texture
		{
			if(!_textures.hasOwnProperty(name)){
				var texture:Texture = _gemsAtlas.getTexture(name);
				_textures[name] = texture ;
			}
			return _textures[name] as Texture ;
		}
		
		
		public function getUITexture( name:String ):Texture 
		{
			if(!_textures.hasOwnProperty(name)){
				var texture:Texture = _uiAtlas.getTexture(name);
				_textures[name] = texture ;
			}
			return _textures[name] as Texture ;
		}
		
		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance
		 */
		public static function getAtlas(atlasId:String):TextureAtlas
		{
			var textureAtlas:TextureAtlas;
			var texture:Texture;
			var xml:XML;
			
			switch (atlasId)
			{
				case "Gems":
					if (_gemsAtlas == null)
					{
						texture = getTexture("Gems_HD");
						xml = XML(new Gems_HD_XML());
						_gemsAtlas=new TextureAtlas(texture, xml);
					}
					textureAtlas =  _gemsAtlas;
					break;
				case "UI":
					if (_uiAtlas == null)
					{
						texture = getTexture("UI_SD");
						xml = XML(new UI_SD_XML());
						_uiAtlas=new TextureAtlas(texture, xml);
					}
					textureAtlas =  _uiAtlas;
					break;
				
				default:
					throw new Error("No atlasID passed to function getAtlas");
					/*
					if (gameTextureAtlas == null)
					{
						texture = getTexture("AtlasTextureGame");
						xml = XML(new AtlasXmlGame());
						gameTextureAtlas=new TextureAtlas(texture, xml);
					}
					textureAtlas =  gameTextureAtlas;
					*/
					
			}
			return textureAtlas;
		}
		
		/**
		 * Returns a texture from this class based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (_textures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				_textures[name]=Texture.fromBitmap(bitmap);
			}
			
			return _textures[name];
		}
		
		
	}
}