package logicle.game.screens 
{
	
	import logicle.game.Assets;
	import logicle.game.Constants;
	import logicle.game.GameData;
	import starling.events.Event;
	import starling.display.Image;

	import feathers.controls.Button;
	import feathers.controls.Screen;	
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class Start extends Screen
	{
		
		public function Start() 
		{
		}
		
		private var _playBtn:Button;
		private var _settingsBtn:Button;
		private var _logo:Button;
		private var _about:Image;
		
		override protected function initialize():void
		{		
			this._playBtn = new Button();
			this._playBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('playBtn_up'));
			this._playBtn.downSkin = new Image(logicle.game.Assets.getTexture('playBtn_down'));
			this.addChild(this._playBtn);
			
			this._settingsBtn = new Button();
			this._settingsBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('settingsBtn_up'));
			this._settingsBtn.downSkin = new Image(logicle.game.Assets.getTexture('settingsBtn_down'));
			this.addChild(this._settingsBtn);
			
			this._logo = new Button()
			this._logo.defaultSkin = new Image(logicle.game.Assets.getTexture('logo_up'));
			this._logo.downSkin = new Image(logicle.game.Assets.getTexture('logo_down'));
			this.addChild(this._logo);
			
			done();
		}
		
		override protected function draw():void 
		{	
			var gap:Number = (stage.stageHeight-_playBtn.defaultSkin.height-_settingsBtn.defaultSkin.height-_logo.height) / 4;
			
			_logo.x = (stage.stageWidth / 2) - (_logo.width / 2);
			_logo.y = gap;										
			
			_playBtn.x = (stage.stageWidth/2) - (_playBtn.defaultSkin.width/2);
			_playBtn.y = _logo.y + _logo.height + gap;			
			
			_settingsBtn.x = (stage.stageWidth/2) - (_settingsBtn.defaultSkin.width/2);
			_settingsBtn.y = _playBtn.y + _playBtn.defaultSkin.height + gap;			
		}
		
		protected function done():void
		{
			_playBtn.addEventListener(Event.TRIGGERED, playBtn_onTriggered);
			_settingsBtn.addEventListener(Event.TRIGGERED, settingsBtn_onTriggered);
			_logo.addEventListener(Event.TRIGGERED, logo_onTriggered);
		}
		
		private function logo_onTriggered(e:Event):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.ABOUT);
		}
		
		private function settingsBtn_onTriggered(event:Event):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.SETTINGS);
		}
		
		private function playBtn_onTriggered(e:Event):void 
		{
			if(GameData.playerData.isBeginner) 
			{				
				//TODO: create an event or function within the GameData class for updating the current level
				GameData.currentLevelPack = Constants.VANILLA_LEVEL_PACK;
				GameData.currentCategory = Constants.TUTORIAL_CATEGORY;
				GameData.currentLevel = 0;
				dispatchEventWith('screenChange', false, logicle.game.Constants.IN_GAME);
			}
			else
			{
				dispatchEventWith('screenChange', false, logicle.game.Constants.CATEGORY_SELECT);
			}
		}
		
	}

}