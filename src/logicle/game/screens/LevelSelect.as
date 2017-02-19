package logicle.game.screens 
{

	import flash.text.TextFormat;
	import logicle.game.Assets;
	import logicle.game.Constants;
	import logicle.game.GameData;

	import starling.display.DisplayObject;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.events.Event;
	
	import feathers.controls.text.TextFieldTextRenderer;	
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.core.ITextRenderer;

	import logicle.game.utils.scale;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class LevelSelect extends Screen
	{		
		
		public function LevelSelect() 
		{
		}
		
		private var _header:Header;
		private var _footer:Header;
		private var _backBtn:Button;
		
		private var _levels:List;
		private var _tiledRowsLayout:TiledRowsLayout;
		private var _pageIndicator:PageIndicator;
		
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
			_header.title = logicle.game.GameData.currentCategory;
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
			
			_tiledRowsLayout = new TiledRowsLayout();
			_tiledRowsLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			_tiledRowsLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			_tiledRowsLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			_tiledRowsLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			_tiledRowsLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			_tiledRowsLayout.padding = scale(10);
			_tiledRowsLayout.gap = scale(10);
			_tiledRowsLayout.useSquareTiles = false;		
			
			_levels = new List();
			_levels.layout = _tiledRowsLayout;
			_levels.snapToPages = true;
			_levels.hasElasticEdges = true;
			_levels.dataProvider = new ListCollection();			
			var levelPack:String = logicle.game.GameData.currentLevelPack;
			var category:String = logicle.game.GameData.currentCategory;
			var texture:Texture = logicle.game.Assets.getTexture('completeLevelBtn_up');
			var highestLevel:int = logicle.game.GameData.getIndexOfHighestLevelInCategory(levelPack, category);
			for(var n:int = 0, l:int = logicle.game.GameData.levelPacks[levelPack][category].length; n < l; n++) {										
				/*if(n < highestLevel) {
					texture = Assets.getTexture('completeLevelBtn_up');
				} else if(n == highestLevel) {
					texture = GameData.playerData.stats[levelPack][category][n].isComplete ?
						Assets.getTexture('completeLevelBtn_up') : Assets.getTexture('incompleteLevelBtn_up');
				}*/ 
				
				//untested code
				if (n <= highestLevel) {
					if (logicle.game.GameData.playerData.stats[levelPack][category][n].isComplete.overall) {
						texture = logicle.game.GameData.playerData.stats[levelPack][category][n].isPerfect.overall ?
							logicle.game.Assets.getTexture('perfectLevelBtn_up') : logicle.game.Assets.getTexture('completeLevelBtn_up');
					} else {
						texture = logicle.game.Assets.getTexture('incompleteLevelBtn_up');
					}
				} else {
					texture = logicle.game.Assets.getTexture('lockedLevelBtn_up');
				}
				
				_levels.dataProvider.addItem({text: String(n + 1), skin: new Image(texture)});
			}			
			_levels.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.itemHasSkin = true;
				renderer.skinField = 'skin';
				renderer.labelFactory = function():ITextRenderer
				{
					var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(30), 0x34495E);
					textFieldTextRenderer.embedFonts = true;
					
					return textFieldTextRenderer;							
				}
				renderer.labelField = 'text';
				renderer.paddingTop = logicle.game.Constants.PADDING_MEDIUM;
				
				return renderer;
			}
			
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():DisplayObject
			{
				return new Image(logicle.game.Assets.getTexture('unselectedPage'));
			};
			this._pageIndicator.selectedSymbolFactory = function():DisplayObject
			{
				return new Image(logicle.game.Assets.getTexture('selectedPage'));
			};
			this._pageIndicator.gap = logicle.game.Constants.PADDING_SMALL;
			this.addChild(this._pageIndicator);
			
			this.addChild(_levels);
			
			done();
		}
		
		override protected function draw():void
		{						
			_header.x = (stage.stageWidth - _header.backgroundSkin.width) / 2;
			_header.y = logicle.game.Constants.PADDING_MEDIUM;
			
			_footer.x = _header.x;
			_footer.y = stage.stageHeight - _footer.backgroundSkin.height - logicle.game.Constants.PADDING_MEDIUM;
			
			_levels.width = this.stage.stageWidth;
			_levels.height = this.stage.stageHeight - _header.backgroundSkin.height - _footer.backgroundSkin.height - 4 * logicle.game.Constants.PADDING_MEDIUM;
			_levels.x = 0;
			_levels.y = _header.y + _header.backgroundSkin.height + logicle.game.Constants.PADDING_MEDIUM;
			
			this._pageIndicator.x = (this.stage.stageWidth - this._pageIndicator.width) / 2;
			this._pageIndicator.y = this._levels.y + this._levels.height - logicle.game.Constants.PADDING_SMALL;
		}
		
		protected function done():void
		{			
			this.backButtonHandler = backBtn_onTriggered;
			_backBtn.addEventListener(Event.TRIGGERED, backBtn_onTriggered);			
			
			_levels.addEventListener(Event.CHANGE, selectLevel);
			_levels.addEventListener(Event.SCROLL, refreshPageIndicator);
			_levels.addEventListener(FeathersEventType.CREATION_COMPLETE, function(e:Event):void 
			{
				_levels.removeEventListener(e.type, arguments.callee);
				_pageIndicator.pageCount = _levels.horizontalPageCount;
				refreshPageIndicator();
				_pageIndicator.addEventListener(Event.CHANGE, changePage);
			});
		}
		
		private function changePage(e:Event):void
		{
			this._levels.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, 0.75);			
		}
		
		private function refreshPageIndicator(e:Event = null):void
		{
			this._pageIndicator.selectedIndex = this._levels.horizontalPageIndex;
		}
		
		private function selectLevel(event:Event):void 
		{	
			var category:String = logicle.game.GameData.currentCategory;
			var level:int = _levels.selectedIndex;
			
			if(level <= logicle.game.GameData.getIndexOfHighestLevelInCategory(logicle.game.GameData.currentLevelPack, category)) {
				logicle.game.GameData.currentLevel = level;
				
				dispatchEventWith('screenChange', false, logicle.game.Constants.IN_GAME);
			}
		}
		
		private function backBtn_onTriggered(e:Event = null):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.CATEGORY_SELECT);
		}
		
	}

}