package logicle.game 
{

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import logicle.game.Assets;
	import logicle.game.Constants;
	
	import starling.core.Starling;
	
	import feathers.system.DeviceCapabilities;
	
	//import net.hires.debug.Stats;

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	
	/// SETUP: Comment out when testing on PC
	import com.mesmotronic.ane.AndroidFullScreen;
	
	import logicle.game.GameData;	
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */

	[SWF(width="360", height="640", frameRate="60", backgroundColor = "0xFFFFFF")]
	public class Logicle extends Sprite 
	{		
		
		public function Logicle()
		{														
			//_stats = new Stats();
			//addChild(_stats);				
			
			//SETUP: Comment out when testing on PC
			Starling.handleLostContext = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		static private var _starling:Starling;
		static private var _stageWidth:int;
		static private var _stageHeight:int;
		static private var _fullScreenWidth:int;
		static private var _fullScreenHeight:int;
		static private var _loader:LoaderMax;
		
		//static private var _stats:Stats;
		
		static private var _textureAtlasDefinitionLevel:String;
		
		static public function get starling():Starling 
		{
			return _starling;
		}
		
		static public function get stageWidth():int 
		{
			return _stageWidth;
		}
		
		static public function get stageHeight():int 
		{
			return _stageHeight;
		}
		
		static public function get fullScreenWidth():int 
		{
			return _fullScreenWidth;
		}
		
		static public function get fullScreenHeight():int 
		{
			return _fullScreenHeight;
		}		
		
		static public function get loader():LoaderMax 
		{
			return _loader;
		}
		
		private function onAddedToStage(event:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			/// SETUP: Comment out when testing on PC
			this.stage.displayState = StageDisplayState.NORMAL;			
			
			/// SETUP: COMMENT OUT BEFORE PACKAGING
			//initStarling();
			
			/// SETUP: Comment out when testing on PC
			this.stage.addEventListener(Event.RESIZE, initStarling);
			
			/// SETUP: Comment out when testing on PC
			if(!AndroidFullScreen.immersiveMode()) 
			{
				this.stage.removeEventListener(Event.RESIZE, initStarling);
				stage.displayState = StageDisplayState.FULL_SCREEN;
				initStarling();
			}
		};
		
		private function initStarling(event:Event = null):void
		{
			/// SETUP: Comment out when testing on PC
			this.stage.removeEventListener(Event.RESIZE, initStarling);
			
			_starling = new Starling(Main, stage);
			
			/// SETUP: Comment out when testing on PC
			_fullScreenWidth = AndroidFullScreen.immersiveWidth;
			_fullScreenHeight = AndroidFullScreen.immersiveHeight;
			
			/// SETUP: COMMENT OUT BEFORE PACKAGING
			//_fullScreenWidth = this.stage.fullScreenWidth;
			//_fullScreenHeight = this.stage.fullScreenHeight;
			
			/// Determines optimal Starling stage dimensions based on device resolution
			switch(String(_fullScreenHeight) + 'x' + String(_fullScreenWidth)) {
				case logicle.game.Constants.QHD:
				case logicle.game.Constants.FHD:
				case logicle.game.Constants.HD:
				case logicle.game.Constants.qHD:
				case logicle.game.Constants.nHD:
					_stageWidth = 180;
					_stageHeight = 320;
					break;
				case logicle.game.Constants.WVGA:
					_stageWidth = 240;
					_stageHeight = 400;
					break;
				case logicle.game.Constants.FWVGA:
					_stageWidth = 240;
					_stageHeight = 427;
					break;					
				case logicle.game.Constants.WXGA:
					_stageWidth = 200;
					_stageHeight = 320;
					break;
				case logicle.game.Constants.WXGA_2:
					_stageWidth = 192;
					_stageHeight = 320;
					break;					
				case logicle.game.Constants.XGA:
					_stageWidth = 192;
					_stageHeight = 256;
					break;										
				case logicle.game.Constants.XGA_PLUS:
					_stageWidth = 216;
					_stageHeight = 288;
					break;										
				case logicle.game.Constants.VGA:
					_stageWidth = 240;
					_stageHeight = 320;
					break;
				default:					
					_stageWidth = 180;
					_stageHeight = 320;	
					break;
			}			
			
			/// Checks device resolution and selects appropriate TextureAtlas to be loaded
			switch(String(_fullScreenHeight) + 'x' + String(_fullScreenWidth)) {
				case logicle.game.Constants.QHD:
				case logicle.game.Constants.FHD:
					_textureAtlasDefinitionLevel = logicle.game.Constants.HD_TEXTURE_ATLAS;
					break;
				case logicle.game.Constants.HD:
				case logicle.game.Constants.qHD:				
				case logicle.game.Constants.XGA:
				case logicle.game.Constants.XGA_PLUS:
				case logicle.game.Constants.WXGA:
				case logicle.game.Constants.WXGA_2:
					_textureAtlasDefinitionLevel = logicle.game.Constants.SD_TEXTURE_ATLAS;
					break;
				case logicle.game.Constants.WVGA:
				case logicle.game.Constants.nHD:
				case logicle.game.Constants.VGA:
				case logicle.game.Constants.FWVGA:	
					_textureAtlasDefinitionLevel = logicle.game.Constants.LD_TEXTURE_ATLAS;
					break;
				default:
					_textureAtlasDefinitionLevel = logicle.game.Constants.LD_TEXTURE_ATLAS;
					break;
			}	
			
			/// Starling viewPort and stage dimensions are set
			_starling.viewPort = new Rectangle(0, 0, _fullScreenWidth, _fullScreenHeight);
			_starling.stage.stageWidth = _stageWidth, _starling.stage.stageHeight = _stageHeight;
			
			/// Commences loading of textures, audio, and levels
			load();
			
			_starling.start();							
		}
		
		private function load():void
		{
			GameData.loadPlayerData();
			
			_loader = new LoaderMax({name: 'loader', onComplete: completeHandler, onError: errorHandler, onFail: failHandler});
			
			/// Initializes individual LoaderMax queues; one is for loading levels, the other is for loading graphics and audio
			logicle.game.Assets.initializeLoadQueue(_textureAtlasDefinitionLevel);
			logicle.game.GameData.initializeLoadQueue();
			
			_loader.append(logicle.game.Assets.queue);
			_loader.append(logicle.game.GameData.queue);
			
			/// Begins loading
			_loader.load();
			
			function completeHandler(event:LoaderEvent):void	/// Executed when loader finishes loading everything
			{
				/// Signals game to run
				logicle.game.GameData.isLoadingComplete = true;
			}
			
			function errorHandler(event:LoaderEvent):void
			{
			}
			
			function failHandler(event:LoaderEvent):void
			{
			}
			
		}
		
	}
	
}