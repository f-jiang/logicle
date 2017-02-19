package logicle.game.screens 
{
	import flash.text.TextFormat;
	import logicle.game.Assets;
	import logicle.game.Constants;
	
	import starling.display.DisplayObject;	
	import starling.display.Image;
	import starling.events.Event;	
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.utils.display.calculateScaleRatioToFit;
	
	import logicle.game.utils.scale;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class About extends Screen 
	{
		
		public function About() 
		{
			super();			
		}
		
		private var _header:Header;
		private var _footer:Header;
		private var _backBtn:Button;
		private var _about:Image;
		
		override protected function initialize():void
		{
			this._header = new Header();
			this._header.backgroundSkin = new Image(logicle.game.Assets.getTexture('headerBg'));
			this._header.titleFactory = function():ITextRenderer
			{
				 var titleRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				 titleRenderer.textFormat = new TextFormat('TimeBurner', scale(35), 0x34495E);
				 titleRenderer.embedFonts = true;
				 return titleRenderer;
			}
			this._header.title = 'About';
			this._header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this._header.paddingLeft = scale(20);			
			this.addChild(this._header);
			
			this._footer = new Header();
			this._footer.backgroundSkin = new Image(logicle.game.Assets.getTexture('footerBg'));
			this._backBtn = new Button();
			this._backBtn.defaultSkin = new Image(logicle.game.Assets.getTexture('backBtn_up'));
			this._backBtn.downSkin = new Image(logicle.game.Assets.getTexture('backBtn_down'));
			this._footer.leftItems = new <DisplayObject>[this._backBtn];	
			this._footer.paddingLeft = logicle.game.Constants.PADDING_MEDIUM;
			this.addChild(this._footer);
			
			this._about = new Image(logicle.game.Assets.getTexture('about'));
			this.addChild(this._about);			
			
			done();
		}
		
		override protected function draw():void
		{
			this._header.x = (this.stage.stageWidth - this._header.backgroundSkin.width) / 2;
			this._header.y = logicle.game.Constants.PADDING_MEDIUM;
			
			this._footer.x = this._header.x;
			this._footer.y = this.stage.stageHeight - this._footer.backgroundSkin.height - logicle.game.Constants.PADDING_MEDIUM;
			
			this._about.scaleX = calculateScaleRatioToFit(this._about.width, this._about.height, 
				this.stage.stageWidth - logicle.game.Constants.PADDING_MEDIUM, this.stage.stageHeight - this._header.backgroundSkin.height 
				- this._footer.backgroundSkin.height - 2 * (logicle.game.Constants.PADDING_LARGE + logicle.game.Constants.PADDING_MEDIUM));
			this._about.scaleY = this._about.scaleX;
			this._about.x = (this.stage.stageWidth - this._about.width) / 2;
			this._about.y = (this.stage.stageHeight - this._about.height) / 2;
		}
		
		protected function done():void
		{
			this.backButtonHandler = backBtn_onTriggered;			
			this._backBtn.addEventListener(Event.TRIGGERED, backBtn_onTriggered);			
		}
		
		private function backBtn_onTriggered(e:Event = null):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.START);
		}
		
	}

}