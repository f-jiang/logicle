package logicle.game  
{

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import logicle.game.Constants;
	import logicle.game.GameData;
	import logicle.game.screens.*;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;

	import feathers.controls.ProgressBar;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.*;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class Main extends Sprite 
	{
		
		public function Main() 
		{				
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}				
		
		static private var _navigator:ScreenNavigator;
		
		private var _loadingBar:ProgressBar;
		private var _transition:ScreenFadeTransitionManager;		
		
		private function change(event:Event, screen:String):void 
		{
			_navigator.showScreen(screen);
		}
		
		static public function get navigator():ScreenNavigator 
		{
			return _navigator;
		}
		
		private function onAddedToStage(event:Event):void 
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			_loadingBar = new ProgressBar();
			var length:int = Constants.LOADING_BAR_COLORS.length;
			var index:int;
			var barColor:int;
			var fillColor:int;
			var bgSkin:Sprite;
			var frontLayer:Image;
			var backLayer:Quad;
			index = Math.round(Math.random() * (length - 1));
			barColor = Constants.LOADING_BAR_COLORS[index];
			do
			{
				index = Math.round(Math.random() * (length - 1));
				fillColor = Constants.LOADING_BAR_COLORS[index];
			} while(fillColor == barColor);
			frontLayer = new Image(Texture.fromBitmapData((new Assets.loadingBarBitmapData()).bitmapData));
			frontLayer.scaleX = frontLayer.scaleY = (0.4 * stage.stageWidth) / frontLayer.width;
			frontLayer.color = barColor;
			backLayer = new Quad(frontLayer.width, frontLayer.height, fillColor);
			bgSkin = new Sprite();
			bgSkin.addChild(backLayer);
			bgSkin.addChild(frontLayer);
			_loadingBar.backgroundSkin = bgSkin;
			_loadingBar.fillSkin = new Quad(1, bgSkin.height, barColor);
			_loadingBar.x = (stage.stageWidth - bgSkin.width) / 2;
			_loadingBar.y = stage.stageHeight * 0.4;
			this.addChild(_loadingBar);

			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				var tween:Tween = new Tween(_loadingBar, 3, Transitions.EASE_IN_OUT);
				tween.animate('value', 1);
				tween.onComplete = function():void
				{
					if(Logicle.loader.progress == 1) 
					{
						onLoaded();
					}
					else
					{
						this.addEventListener(EnterFrameEvent.ENTER_FRAME, waitForLoadCompletion);
					}
				}
				Logicle.starling.juggler.add(tween);				
			});
			timer.start();
		}
		
		private function waitForLoadCompletion(event:EnterFrameEvent):void
		{
			if(logicle.game.GameData.isLoadingComplete) {	/// Waits for loading to finish before starting game
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, waitForLoadCompletion);
				onLoaded();	/// Starts game
			}
		}
		
		private function onLoaded():void
		{
			this.removeChild(_loadingBar);
			
			_navigator = new ScreenNavigator();
			_navigator.width = stage.stageWidth;
			_navigator.height = stage.stageHeight;
			_navigator.x = 0;
			_navigator.y = 0;
			_navigator.addScreen(logicle.game.Constants.START, new ScreenNavigatorItem(Start, {screenChange:change}));
			_navigator.addScreen(logicle.game.Constants.ABOUT, new ScreenNavigatorItem(About, {screenChange:change}));			
			_navigator.addScreen(logicle.game.Constants.SETTINGS, new ScreenNavigatorItem(Settings, {screenChange:change}));
			_navigator.addScreen(logicle.game.Constants.CATEGORY_SELECT, new ScreenNavigatorItem(CategorySelect, {screenChange:change}));
			_navigator.addScreen(logicle.game.Constants.LEVEL_SELECT, new ScreenNavigatorItem(LevelSelect , {screenChange:change}));
			_navigator.addScreen(logicle.game.Constants.IN_GAME, new ScreenNavigatorItem(InGame, {screenChange:change}));
			_navigator.addScreen(logicle.game.Constants.IN_GAME2, new ScreenNavigatorItem(InGame, {screenChange:change}));
			
			this.addChild(_navigator);
			
			_navigator.showScreen(logicle.game.Constants.START);			
			
			_transition = new ScreenFadeTransitionManager(_navigator);			
		}
		
	}

}