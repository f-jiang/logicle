package logicle.game  
{
	
	import flash.media.Sound;
	import starling.display.Image;

	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;

	/**
	 * ...
	 * @author Feilan Jiang
	 */

	public class Assets
	{
		
		[Embed(source = '../../../bin/assets/fonts/timeburner_regular.ttf', fontFamily = 'TimeBurner', embedAsCFF = 'false')]
		static private const TimeBurnerFont:Class;
		
		[Embed(source = '../../../bin/assets/graphics/loadingbar.png')]
		static private const _loadingBarBitmapData:Class;
		
		static private var _textureAtlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>();
		static private var _atlasXMLs:Vector.<XML> = new Vector.<XML>();
		static private var _textures:TextureAtlas;
		
		static private var _shift:Sound;
		static private var _solved:Sound;
		
		static private var _queue:LoaderMax;
		
		static public function get shift():Sound 
		{
			return _shift;
		}
		
		static public function get solved():Sound 
		{
			return _solved;
		}
		
		static public function get queue():LoaderMax 
		{
			return _queue;
		}		
		
		static public function get loadingBarBitmapData():Class 
		{
			return _loadingBarBitmapData;
		}
		
		static public function initializeLoadQueue(textureAtlasDefinitionLevel:String):void
		{
			/// load all assets (use LoaderMax for this)
			_queue = new LoaderMax({name: 'assetsQueue', onComplete: completeHandler, onError: errorHandler, onFail: failHandler});
			
			var numTextureAtlases:int;
			var currentAtlasMaxWidth:int;
			
			_queue.append(new MP3Loader('../assets/audio/1256__anton__kleiner-reverse.mp3', {name: 'shiftSound', autoPlay: false}));
			_queue.append(new MP3Loader('../assets/audio/214666__kibilocomalifasa__ian-s-sound.mp3', {name: 'solvedSound', autoPlay: false}));
			
			/// Loads the TextureAtlas selected in the Logicle class
			switch(textureAtlasDefinitionLevel) {
				case Constants.HD_TEXTURE_ATLAS:
					_queue.append(new ImageLoader('../assets/graphics/HD/textures0.png', {name: 'textureAtlas0'}));
					_queue.append(new ImageLoader('../assets/graphics/HD/textures1.png', {name: 'textureAtlas1'}));
					_queue.append(new ImageLoader('../assets/graphics/HD/textures2.png', {name: 'textureAtlas2'}));
					_queue.append(new XMLLoader('../assets/graphics/HD/textures0.xml', {name: 'atlasXML0'}));		
					_queue.append(new XMLLoader('../assets/graphics/HD/textures1.xml', {name: 'atlasXML1'}));
					_queue.append(new XMLLoader('../assets/graphics/HD/textures2.xml', {name: 'atlasXML2'}));
					
					numTextureAtlases = 3;
					currentAtlasMaxWidth = 1080;
					break;
				case Constants.SD_TEXTURE_ATLAS:
					_queue.append(new ImageLoader('../assets/graphics/SD/textures0.png', {name: 'textureAtlas0'}));
					_queue.append(new XMLLoader('../assets/graphics/SD/textures0.xml', {name: 'atlasXML0'}));
					
					numTextureAtlases = 1;
					currentAtlasMaxWidth = 720;
					break;
				case Constants.LD_TEXTURE_ATLAS:
					_queue.append(new ImageLoader('../assets/graphics/LD/textures0.png', {name: 'textureAtlas0'}));
					_queue.append(new XMLLoader('../assets/graphics/LD/textures0.xml', {name: 'atlasXML0'}));
					
					numTextureAtlases = 1;
					currentAtlasMaxWidth = 480;
					break;
				default:
					break;
			}
			
			function completeHandler(event:LoaderEvent):void
			{
				_shift = _queue.getContent('shiftSound') as Sound;
				_solved = _queue.getContent('solvedSound') as Sound;
				
				/// Calculates a scale ratio for the textures
				var scaleRatio:Number = currentAtlasMaxWidth / Logicle.starling.stage.stageWidth;
				for(var i:int = 0, l:int = numTextureAtlases; i < l; i++) {	/// XMLs and TextureAtlases objects are initialized, and TextureAtlases are scaled
					_atlasXMLs[i] = new XML(_queue.getContent('atlasXML' + String(i)));
						
					_textureAtlases[i] = new TextureAtlas(Texture.fromBitmap(_queue.getContent('textureAtlas' + String(i)).rawContent,	/// extract picture from loadermax
						true, false, scaleRatio), _atlasXMLs[i]);						
				}				
			}
			
			function errorHandler(event:LoaderEvent):void
			{
			}
			
			function failHandler(event:LoaderEvent):void
			{
			}
		}
		
		static public function getTexture(name:String):Texture 
		{
			var texture:Texture = _textureAtlases[0].getTexture(name);
			
			if(texture == null) 
			{
				for(var i:int = 1; i < _textureAtlases.length; i++) 
				{
					if(_textureAtlases[i].getTexture(name) != null) 
					{
						texture = _textureAtlases[i].getTexture(name);
						break;
					}								
				}
			}
			
			return texture;
		}
		
	}

}