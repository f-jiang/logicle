package logicle.game.screens 
{
	
	import flash.text.TextFormat;
	import starling.display.Quad;
	
	import logicle.game.Assets;
	import logicle.game.Constants;
	import logicle.game.objects.Gameboard;
	import logicle.game.GameData;
	import logicle.game.utils.scale;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.textures.Texture;		
	import starling.events.Event;
	import starling.display.Image;
	
	import feathers.controls.GroupedList;
	import feathers.controls.IScrollBar;
	import feathers.controls.ScrollBar;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;	
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.Screen;	
	import feathers.data.HierarchicalCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.utils.display.calculateScaleRatioToFit;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */	
	
	public class CategorySelect extends Screen
	{
		
		public function CategorySelect() 
		{
		}
		
		private var _header:Header;
		private var _footer:Header;
		private var _backBtn:Button;
		
		private var _categories:GroupedList;
		private var _verticalLayout:VerticalLayout;
		
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
			_header.title = 'Levels';
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
			_verticalLayout.useVirtualLayout = true;
			_verticalLayout.gap = logicle.game.Constants.PADDING_SMALL;
			
			_categories = new GroupedList();
			_categories.layout = _verticalLayout;
			_categories.dataProvider = new HierarchicalCollection();
			var levelPack:String;
			var category:String;
			var progress:String;
			var texture:Texture = logicle.game.Assets.getTexture('levelCategoryBtn_up');
			var length:int;
			var rendererPadding:Number = scale(15);
			var boardPadding:Number = scale(3);
			var height:Number = texture.height - 2 * rendererPadding;
			var iconData:Object;			
			var icon:Sprite;
			for(var i:int = 0, l:int = logicle.game.GameData.levelPackIndex.length; i < l; i++) {
				levelPack = logicle.game.GameData.levelPackIndex[i];
				_categories.dataProvider.addItemAt(
					{//header: levelPack,
					 children: []},
					i 
				);
				for(var n:int = 0, L:int = logicle.game.GameData.categoryOrder[levelPack].length; n < L; n++) {
					category = logicle.game.GameData.categoryOrder[levelPack][n];
					progress = String(logicle.game.GameData.getNumCompletedLevels(levelPack, category)) + '/' + String(logicle.game.GameData.getIndexOfLastLevelInCategory(levelPack, category) + 1);
					length = GameData.getIndexOfLastLevelInCategory(levelPack, category) + 1;
					iconData = GameData.levelPacks[levelPack][category][uint(Math.random() * length)];
					icon = iconData.widthSquares > iconData.heightSquares ? new Gameboard(iconData, height, NaN, false, boardPadding) : new Gameboard(iconData, NaN, height, false, boardPadding);
					_categories.dataProvider.getItemAt(i).children[n] = {label: category, secondaryLabel: progress, skin: new Image(texture), icon: icon};
				}
			}			
			_categories.itemRendererFactory = function():IGroupedListItemRenderer
			{
				var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				renderer.padding = rendererPadding;
				renderer.itemHasSkin = true;
				renderer.skinField = 'skin';
				renderer.labelField = 'label';
				renderer.iconField = 'icon';
				renderer.accessoryLabelField = 'secondaryLabel';
				renderer.horizontalAlign = DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_LEFT;
				renderer.verticalAlign = DefaultGroupedListItemRenderer.VERTICAL_ALIGN_MIDDLE;
				renderer.layoutOrder = DefaultGroupedListItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;
				renderer.accessoryPosition = DefaultGroupedListItemRenderer.ACCESSORY_POSITION_MANUAL;
				renderer.iconPosition = DefaultGroupedListItemRenderer.ICON_POSITION_RIGHT;
				renderer.labelOffsetY = -(1 / 6) * height;
				renderer.accessoryOffsetY = (2 / 3) * height;
				renderer.gap = Number.POSITIVE_INFINITY;
				renderer.labelFactory = function():ITextRenderer
				{
					var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(28), 0x34495E);
					textFieldTextRenderer.embedFonts = true;
					
					return textFieldTextRenderer;							
				};
				renderer.accessoryLabelFactory = function():ITextRenderer
				{
					var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
					textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(16), 0x34495E);
					textFieldTextRenderer.embedFonts = true;
					
					return textFieldTextRenderer;
				};
				
				return renderer;
			}
			_categories.headerRendererFactory = function():IGroupedListHeaderOrFooterRenderer
			{
				var renderer:DefaultGroupedListHeaderOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
				renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;				
				renderer.contentLabelFactory = function():ITextRenderer
				{
					var textFieldTextRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();					
					textFieldTextRenderer.textFormat = new TextFormat('TimeBurner', scale(30), 0x34495E);
					textFieldTextRenderer.embedFonts = true;
					
					return textFieldTextRenderer;							
				};
				
				return renderer;
			};
			_categories.verticalScrollBarFactory = function():IScrollBar
			{
				var scrollBar:ScrollBar = new ScrollBar();
				scrollBar.thumbFactory = function():Button
				{
					var thumb:Button = new Button();
					thumb.defaultSkin = new Image(Assets.getTexture('thumb'));
					return thumb;
				};
				return scrollBar;
			};
			this.addChild(this._categories);
			
			done();						
		}
		
		override protected function draw():void
		{
			_header.x = (stage.stageWidth - _header.backgroundSkin.width) / 2;
			_header.y = logicle.game.Constants.PADDING_MEDIUM;
			
			_footer.x = _header.x;
			_footer.y = stage.stageHeight - _footer.backgroundSkin.height - logicle.game.Constants.PADDING_MEDIUM;
			
			_categories.x = (stage.stageWidth - _categories.width) / 2;
			_categories.y = _header.y + _header.backgroundSkin.height + logicle.game.Constants.PADDING_SMALL;
			_categories.height = stage.stageHeight - _header.backgroundSkin.height - _footer.backgroundSkin.height - 2 * (logicle.game.Constants.PADDING_MEDIUM + logicle.game.Constants.PADDING_SMALL);
			_categories.width = stage.stageWidth - Constants.PADDING_MEDIUM;
		}
		
		protected function done():void
		{
			this.backButtonHandler = backBtn_onTriggered;
			
			this._backBtn.addEventListener(Event.TRIGGERED, backBtn_onTriggered);
			this._categories.addEventListener(Event.CHANGE, selectCategory);
		}
		
		private function backBtn_onTriggered(e:Event = null):void 
		{
			dispatchEventWith('screenChange', false, logicle.game.Constants.START);
		}
		
		private function selectCategory(event:Event):void 
		{												
			var levelPack:String = logicle.game.GameData.levelPackIndex[_categories.selectedGroupIndex];
			var category:String = logicle.game.GameData.categoryOrder[levelPack][_categories.selectedItemIndex];
			
			logicle.game.GameData.currentLevelPack = levelPack;
			logicle.game.GameData.currentCategory = category;
			dispatchEventWith('screenChange', false, logicle.game.Constants.LEVEL_SELECT);
		}
		
	}

}