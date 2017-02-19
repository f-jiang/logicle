package logicle.game.screens 
{
	
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import logicle.game.Assets;
	import logicle.game.Constants;
	import logicle.game.GameData;
	import logicle.game.Logicle;

	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.events.Event;
	import starling.display.Image;
	
	import feathers.controls.Panel;
	import feathers.controls.Screen;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Check;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import logicle.game.utils.scale;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class Settings extends Screen
	{
		
		public function Settings() 
		{
		}
		
		private var _header:Header;
		private var _footer:Header;
		private var _backBtn:Button;
		
		private var _group:ButtonGroup;
		
		private var _verticalLayout:VerticalLayout;
		private var _container:ScrollContainer;
		
		private var _sfxBtn:Check;
		private var _musicBtn:Check;
		private var _colorBlindModeBtn:Check;
		private var _progressResetBtn:Button;
		
		private var _progressResetPanel:Panel;
		private var _progressResetText:TextField;
		private var _confirmBtn:Button;
		private var _cancelBtn:Button;
		
		private var _tween:Tween;
		
		override protected function initialize():void
		{
			_header = new Header();
			_header.backgroundSkin = new Image(logicle.game.Assets.getTexture('headerBg'));
			_header.titleFactory = function():ITextRenderer
			{
				 var titleRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				 titleRenderer.textFormat = new TextFormat('TimeBurner', logicle.game.utils.scale(35), 0x34495E);
				 titleRenderer.embedFonts = true;
				 return titleRenderer;
			}
			_header.title = 'Settings';
			_header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			_header.paddingLeft = scale(20);			
			this.addChild(_header);
			
			
			_footer = new Header();
			_footer.backgroundSkin = new Image(logicle.game.Assets.getTexture('footerBg'));
			_backBtn = new Button();
			_backBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('backBtn_up'));
			_backBtn.downSkin = new Image(logicle.game.Assets.getTexture('backBtn_down'));
			_footer.leftItems = new <DisplayObject>[_backBtn];	
			_footer.paddingLeft = logicle.game.Constants.PADDING_MEDIUM;
			this.addChild(_footer);
			
			_verticalLayout = new VerticalLayout();
			_verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			
			_container = new ScrollContainer();
			_container.layout = _verticalLayout;
			_container.hasElasticEdges = true;
			//_container.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			//_container.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			
			
			//	TODO use buttongroup for these buttons if possible
			_sfxBtn = new Check();
			_sfxBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_up'));
			_sfxBtn.downSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_down'));
			_sfxBtn.defaultSelectedSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_up'));
			_sfxBtn.selectedDownSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_down'));
			_sfxBtn.labelFactory = function():ITextRenderer
			{
				var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(28), 0x34495E);
				textFieldTextRenderer.embedFonts = true;
				
				return textFieldTextRenderer;
			}
			_sfxBtn.label = 'Sound Effects';
			_sfxBtn.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			_sfxBtn.paddingLeft = scale(10);
			_sfxBtn.isSelected = logicle.game.GameData.playerData.settings.isSfxOn;
			_container.addChild(_sfxBtn);
			
			
			_musicBtn = new Check();
			_musicBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_up'));
			_musicBtn.downSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_down'));
			_musicBtn.defaultSelectedSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_up'));
			_musicBtn.selectedDownSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_down'));
			_musicBtn.labelFactory = function():ITextRenderer
			{
				var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(28), 0x34495E);
				textFieldTextRenderer.embedFonts = true;
				
				return textFieldTextRenderer;
			}
			_musicBtn.label = 'Music';
			_musicBtn.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			_musicBtn.paddingLeft = scale(10);			
			_musicBtn.isSelected = logicle.game.GameData.playerData.settings.isMusicOn;
			_container.addChild(_musicBtn);						
			
			_colorBlindModeBtn = new Check();
			_colorBlindModeBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_up'));
			_colorBlindModeBtn.downSkin = new Image(logicle.game.Assets.getTexture('listToggleOffBtn_down'));
			_colorBlindModeBtn.defaultSelectedSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_up'));
			_colorBlindModeBtn.selectedDownSkin = new Image(logicle.game.Assets.getTexture('listToggleOnBtn_down'));
			_colorBlindModeBtn.labelFactory = function():ITextRenderer
			{
				var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(28), 0x34495E);
				textFieldTextRenderer.embedFonts = true;
				
				return textFieldTextRenderer;
			}
			_colorBlindModeBtn.label = 'Colour Blind Mode';
			_colorBlindModeBtn.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			_colorBlindModeBtn.paddingLeft = scale(10);			
			_colorBlindModeBtn.isSelected = GameData.isColorBlindModeOn;
			_container.addChild(_colorBlindModeBtn);						
			
			_progressResetBtn = new Button();
			_progressResetBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('listBtn_up'));
			_progressResetBtn.downSkin = new Image(logicle.game.Assets.getTexture('listBtn_down'));
			_progressResetBtn.labelFactory = function():ITextRenderer
			{
				var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(28), 0x34495E);
				textFieldTextRenderer.embedFonts = true;
				
				return textFieldTextRenderer;
			}
			_progressResetBtn.label = 'Reset Progress';
			_progressResetBtn.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			_progressResetBtn.paddingLeft = scale(10);
			_container.addChild(_progressResetBtn);
			
			this.addChild(_container);
			
			
			_progressResetPanel = new Panel();
			_progressResetPanel.backgroundSkin = new Image(logicle.game.Assets.getTexture('panel'));			
			_progressResetText = new TextField(_progressResetPanel.backgroundSkin.width / 1.5, _progressResetPanel.backgroundSkin.height / 1.5, 
				'Are you sure you want to do this?', 'TimeBurner', scale(32), 0x34495E);
			_progressResetText.hAlign = HAlign.CENTER;
			_progressResetText.vAlign = VAlign.CENTER;
			_progressResetPanel.addChild(_progressResetText);
			_confirmBtn = new Button();
			_confirmBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('yesBtn_up'));
			_confirmBtn.downSkin = new Image(logicle.game.Assets.getTexture('yesBtn_down'));
			_progressResetPanel.addChild(_confirmBtn);
			_cancelBtn = new Button();
			_cancelBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('noBtn_up'));
			_cancelBtn.downSkin = new Image(logicle.game.Assets.getTexture('noBtn_down'));
			_progressResetPanel.addChild(_cancelBtn);
			this.addChild(_progressResetPanel);
			_progressResetPanel.visible = false;
			
			done();			
		}
		
		override protected function draw():void
		{
			_header.x = (stage.stageWidth - _header.backgroundSkin.width) / 2;
			_header.y = logicle.game.Constants.PADDING_MEDIUM;
			
			_footer.x = _header.x;
			_footer.y = stage.stageHeight - _footer.backgroundSkin.height - logicle.game.Constants.PADDING_MEDIUM;
			
			_container.x = (stage.stageWidth - _container.width) / 2;
			_container.y = _header.y + _header.backgroundSkin.height + logicle.game.Constants.PADDING_LARGE;
			_container.height = stage.stageHeight - _header.backgroundSkin.height - _footer.backgroundSkin.height - 2 * (logicle.game.Constants.PADDING_MEDIUM + logicle.game.Constants.PADDING_LARGE);
			
			_progressResetText.x = (_progressResetPanel.backgroundSkin.width - _progressResetText.width) / 2;
			_progressResetText.y = (_progressResetPanel.backgroundSkin.height - _progressResetText.height) / 3;
			_confirmBtn.x = _progressResetPanel.backgroundSkin.width / 2 - _confirmBtn.defaultSkin.width - logicle.game.Constants.PADDING_MEDIUM;
			_confirmBtn.y = _progressResetPanel.backgroundSkin.height - _confirmBtn.defaultSkin.height - logicle.game.Constants.PADDING_LARGE;
			_cancelBtn.x = _progressResetPanel.backgroundSkin.width / 2 + logicle.game.Constants.PADDING_MEDIUM;
			_cancelBtn.y = _confirmBtn.y;
		}
		
		protected function done():void
		{
			_tween = new Tween(_progressResetPanel, 0.5, 'easeOut');			
			
			this.backButtonHandler = backBtn_onTriggered;
			
			this._backBtn.addEventListener(Event.TRIGGERED, backBtn_onTriggered);
			_musicBtn.addEventListener(Event.TRIGGERED, toggleMusic);
			_sfxBtn.addEventListener(Event.TRIGGERED, toggleSfx);
			_colorBlindModeBtn.addEventListener(Event.TRIGGERED, toggleColorBlindMode);
			_progressResetBtn.addEventListener(Event.TRIGGERED, resetProgress);
			_confirmBtn.addEventListener(Event.TRIGGERED, confirmReset);
			_cancelBtn.addEventListener(Event.TRIGGERED, cancelReset);
		}

		private function resetProgress(event:Event):void 
		{			
			disableBackgroundButtons();
			
			_progressResetPanel.x = stage.stageWidth / 2;
			_progressResetPanel.y = stage.stageHeight / 2;
			_progressResetPanel.scaleX = 0;
			_progressResetPanel.scaleY = 0;			
			
			_progressResetPanel.visible = true;
			
			_tween.reset(_progressResetPanel, 0.5, 'easeOut');			
			_tween.scaleTo(1);
			_tween.moveTo((stage.stageWidth - _progressResetPanel.backgroundSkin.width) / 2, (stage.stageHeight - _progressResetPanel.backgroundSkin.height) / 3);	
			logicle.game.Logicle.starling.juggler.add(_tween);
		}
		
		private function confirmReset(e:Event):void 
		{
			logicle.game.GameData.resetProgress();
			
			_tween.reset(_progressResetPanel, 0.5, 'easeOut');
			_tween.scaleTo(0);
			_tween.moveTo(stage.stageWidth / 2, stage.stageHeight / 2);
			_tween.onComplete = function():void { enableBackgroundButtons(); }
			logicle.game.Logicle.starling.juggler.add(_tween);
		}
		
		private function cancelReset(e:Event):void 
		{		
			_tween.reset(_progressResetPanel, 0.5, 'easeOut');
			_tween.scaleTo(0);
			_tween.moveTo(stage.stageWidth / 2, stage.stageHeight / 2);
			_tween.onComplete = function():void { enableBackgroundButtons(); }
			logicle.game.Logicle.starling.juggler.add(_tween);
		}
		
		private function disableBackgroundButtons():void 
		{
			_backBtn.touchable = false;
			_sfxBtn.touchable = false;
			_musicBtn.touchable = false;
			_colorBlindModeBtn.touchable = false;
			_progressResetBtn.touchable = false;
		}
		
		private function enableBackgroundButtons():void 
		{
			_backBtn.touchable = true;
			_sfxBtn.touchable = true;
			_musicBtn.touchable = true;
			_colorBlindModeBtn.touchable = true;
			_progressResetBtn.touchable = true;
		}
		
		private function backBtn_onTriggered(e:Event = null):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.START);
		}
		
		private function toggleMusic(event:Event):void 
		{
			GameData.isMusicOn = !_musicBtn.isSelected;
		}
		
		private function toggleSfx(event:Event):void 
		{
			GameData.isSfxOn = !_sfxBtn.isSelected;
		}
		
		private function toggleColorBlindMode(event:Event):void
		{
			GameData.isColorBlindModeOn = !_colorBlindModeBtn.isSelected;
		}
		
	}

}