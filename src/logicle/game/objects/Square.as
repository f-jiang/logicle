package logicle.game.objects 
{
	
	import flash.geom.Rectangle;
	import logicle.game.Constants;
	import logicle.leveltools.utils.clone;
	
	import logicle.game.Assets;
	import logicle.game.Logicle;

	import starling.animation.Transitions;	
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 * Gameboard 1.1.0
	 */
	
	public class Square extends Sprite 
	{
		
		public function Square(width:Number, squareColor:uint, circleColor:uint, isLabeled:Boolean, squareLabel:String = null, circleLabel:String = null)
		{
			super();
			
			_width = width;
			_squareColor = squareColor;
			_circleColor = circleColor;
			_isLabeled = isLabeled;
			_squareLabel = squareLabel;
			_circleLabel = circleLabel;
			_isShiftInProgress = false;			
			_squareTextPosition = SQUARE_TEXT_POSITION_TOP_LEFT_CORNER;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		public static const SQUARE_TEXT_POSITION_TOP_LEFT_CORNER:String = 'topLeftCorner';
		public static const SQUARE_TEXT_POSITION_TOP_RIGHT_CORNER:String = 'topRightCorner';
		public static const SQUARE_TEXT_POSITION_BOTTOM_LEFT_CORNER:String = 'bottomLeftCorner';
		public static const SQUARE_TEXT_POSITION_BOTTOM_RIGHT_CORNER:String = 'bottomRightCorner';
		
		private var _square:Image;
		private var _circle:Sprite;
		private var _circlePieces:Vector.<Image>;
		private var _circleTween:Tween;
		
		private var _width:Number;
		private var _squareColor:uint;
		private var _circleColor:uint;
		
		private var _isShiftInProgress:Boolean;
		
		private var _isLabeled:Boolean;
		private var _squareLabel:String;
		private var _circleLabel:String;
		private var _squareTextPosition:String;
		private var _squareText:TextField;
		private var _circleTextPieces:Vector.<TextField>;
		private var _circleTexts:Vector.<Sprite>;
		private var _circleTextTweens:Object;
		
		public function get squareColor():uint 
		{
			return _squareColor;
		}
		
		/**
		 * @deprecated
		 */
		public function get isShiftInProgress():Boolean 
		{
			return _isShiftInProgress;
		}
		
		/**
		 * @deprecated
		 */		
		public function set isShiftInProgress(value:Boolean):void 
		{
			_isShiftInProgress = value;
		}
		
		public function get tween():Tween 
		{
			return _circleTween;
		}
		
		public function get squareTextPosition():String 
		{
			return _squareTextPosition;
		}
		
		public function set squareTextPosition(value:String):void 
		{
			_squareTextPosition = value;
			positionLabels();
		}
		
		public function shiftCircle(direction:String, newColor:uint, transition:String, duration:Number, newLabel:String = null):void 
		{
			if(!_isShiftInProgress)
			{
				_isShiftInProgress = true;

				var bottomColor:Image;
				var topColor:Image;
				var beginX:Number, beginY:Number = 0;
				
				switch(direction)
				{
					case Constants.UP:
						beginY = _width;
						beginX = 0;
						
						break;
					case Constants.DOWN:
						beginY = -_width;
						beginX = 0;
						
						break;
					case Constants.LEFT:
						beginX = _width;
						beginY = 0;
						
						break;
					case Constants.RIGHT:
						beginX = -_width;
						beginY = 0;
						
						break;
					default:
						break;
				}								
				_circle.setChildIndex(_circle.getChildAt(0), 1);
				bottomColor = _circle.getChildAt(0) as Image;
				topColor = _circle.getChildAt(1) as Image;				
				topColor.x = beginX;
				topColor.y = beginY;
				
				for(var i:int = 0, l:int = _circlePieces.length; i < l; i++)
				{
					if(_circle.getChildIndex(_circlePieces[i]) == 1)
					{
						_circlePieces[i].color = newColor;
						break;
					}
				}		
				
				_circleTween.reset(topColor, duration, transition);
				_circleTween.onComplete = function():void {_isShiftInProgress = false;};
				_circleTween.moveTo(0, 0);
				Logicle.starling.juggler.add(_circleTween);	//TODO: find alternative so that same code can be used in other projects as well				
				
				if(_isLabeled)
				{	
					_circle.setChildIndex(_circle.getChildAt(2), 3);
					var bottomCircleText:Sprite = _circle.getChildAt(2) as Sprite;
					var topCircleText:Sprite = _circle.getChildAt(3) as Sprite;
					(topCircleText.getChildAt(0) as TextField).text = newLabel;
					_circleTextTweens.bottomLabelTween.reset(bottomCircleText.clipRect, duration, transition);
					_circleTextTweens.topLabelTween.reset(topCircleText.clipRect, duration, transition);					
					switch(direction)
					{
						case Constants.DOWN:
						{
							_circleTextTweens.bottomLabelTween.animate('height', 0);
							_circleTextTweens.bottomLabelTween.animate('y', _width);
							topCircleText.clipRect.x = topCircleText.clipRect.y = 0;
							topCircleText.clipRect.width = _width;
							topCircleText.clipRect.height = 0;
							_circleTextTweens.topLabelTween.animate('height', _width);
						}
						break;
						
						case Constants.UP:
						{
							_circleTextTweens.bottomLabelTween.animate('height', 0);
							topCircleText.clipRect.x = 0;
							topCircleText.clipRect.y = _width;
							topCircleText.clipRect.width = _width;
							topCircleText.clipRect.height = 0;
							_circleTextTweens.topLabelTween.animate('height', _width);
							_circleTextTweens.topLabelTween.animate('y', 0);
						}
						break;
						
						case Constants.RIGHT:
						{
							_circleTextTweens.bottomLabelTween.animate('x', _width);
							_circleTextTweens.bottomLabelTween.animate('width', 0);
							topCircleText.clipRect.x = topCircleText.clipRect.y = 0;
							topCircleText.clipRect.width = 0;
							topCircleText.clipRect.height = _width;
							_circleTextTweens.topLabelTween.animate('width', _width);
						}
						break;
						
						case Constants.LEFT:
						{
							_circleTextTweens.bottomLabelTween.animate('width', 0);
							topCircleText.clipRect.x = _width;
							topCircleText.clipRect.y = 0;
							topCircleText.clipRect.width = 0;
							topCircleText.clipRect.height = _width;
							_circleTextTweens.topLabelTween.animate('width', _width);
							_circleTextTweens.topLabelTween.animate('x', 0);
						}					
						break;
					}
					Logicle.starling.juggler.add(_circleTextTweens.bottomLabelTween);
					Logicle.starling.juggler.add(_circleTextTweens.topLabelTween);
				}			
			}
		}
		
		private function onAddedToStage(event:Event):void 
		{	
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_circle = new Sprite();
			_circle.clipRect = new Rectangle(0, 0, _width, _width);						
			_circlePieces = new <Image>[new Image(logicle.game.Assets.getTexture('circle')), new Image(logicle.game.Assets.getTexture('circle'))];
			for(var x:int = 0, l:int = _circlePieces.length; x < l; x++)
			{
				_circlePieces[x].width = _circlePieces[x].height = _width;
				_circlePieces[x].color = _circleColor;
				_circle.addChild(_circlePieces[x]);
				_circlePieces[x].x = _circlePieces[x].y = 0;				
			}
			this.addChild(_circle);	
			
			_square = new Image(logicle.game.Assets.getTexture('square')); 
			_square.width = _width;
			_square.height = _width;
			_square.color = _squareColor;
			_square.x = 0;
			_square.y = 0;
			this.addChild(_square);			
			
			if(_isLabeled)
			{
				var squareLabelWidth:Number = 0.2 * _width;
				var fontSize:Number = 0.25 * _width;
				_squareText = new TextField(squareLabelWidth, squareLabelWidth, _squareLabel, 'TimeBurner', squareLabelWidth);
				_squareText.autoScale = true;
				this.addChild(_squareText);
				
				_circleTextPieces = new Vector.<TextField>();
				_circleTextPieces[0] = new TextField(_width, _width, null, 'TimeBurner', fontSize);				
				_circleTextPieces[1] = new TextField(_width, _width, _circleLabel, 'TimeBurner', fontSize);
				_circleTextPieces[0].autoScale = true;
				_circleTextPieces[1].autoScale = true;
				_circleTexts = new <Sprite>[new Sprite(), new Sprite()];
				_circleTexts[0].width = _circleTexts[0].height = 0;
				_circleTexts[1].width = _circleTexts[1].height = 0;
				_circleTexts[0].clipRect = new Rectangle(0, 0, 0, _width);
				_circleTexts[1].clipRect = new Rectangle(0, 0, _width, _width);
				_circleTexts[0].addChild(_circleTextPieces[0]);
				_circleTexts[1].addChild(_circleTextPieces[1]);
				_circle.addChild(_circleTexts[0]);
				_circle.addChild(_circleTexts[1]);
				_circleTextTweens = {};
				_circleTextTweens.bottomLabelTween = new Tween(_circleTexts[0].clipRect, 0.5, Transitions.LINEAR);	//TODO: create a const for Transitions.LINEAR?
				_circleTextTweens.topLabelTween = new Tween(_circleTexts[1].clipRect, 0.5, Transitions.LINEAR);
				positionLabels();				
			}
			
			_circleTween = new Tween(_circle.getChildAt(1), 0.5, Transitions.LINEAR);	//TODO: create a const for transition duration?
		}
		
		private function positionLabels():void
		{
			var topOrBottomPadding:Number = (_squareText.width - _squareText.textBounds.width) / 2;
			switch(_squareTextPosition)
			{
				default:
				case SQUARE_TEXT_POSITION_TOP_LEFT_CORNER:
				{
					_squareText.x = 0;
					_squareText.y = topOrBottomPadding;
					break;
				}
				case SQUARE_TEXT_POSITION_TOP_RIGHT_CORNER:
				{
					_squareText.x = _width - _squareText.width;
					_squareText.y = topOrBottomPadding;
					break;
				}
				case SQUARE_TEXT_POSITION_BOTTOM_LEFT_CORNER:
				{
					_squareText.x = 0;
					_squareText.y = _width - _squareText.height - topOrBottomPadding;
					break;
				}
				case SQUARE_TEXT_POSITION_BOTTOM_RIGHT_CORNER:
				{
					_squareText.x = _width - _squareText.width;
					_squareText.y = _width - _squareText.height - topOrBottomPadding;
					break;
				}				
			}
			_circleTexts[0].x = _circleTexts[1].x = 0;
			_circleTexts[0].y = _circleTexts[1].y = 0;
		}
		
	}

}