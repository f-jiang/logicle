package logicle.game.objects 
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import logicle.game.Constants;
	import logicle.game.utils.scale;
	
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	import logicle.game.events.GameboardEvent;
	import logicle.game.objects.Square;
	import logicle.leveltools.utils.clone;
	import logicle.leveltools.Analyzer;	
	import logicle.leveltools.Modification;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 * Gameboard 1.1.0
	 */	
	
	public class Gameboard extends Sprite 
	{
		
		public function Gameboard(data:Object, width:Number, heightOverride:Number = NaN, isLabeled:Boolean = false, padding:Number = 10, paddingColor:uint =  0xE0C1A3) 
		{
			super();			
			
			if(isNaN(heightOverride))
			{
				_width = width;
				_squareWidth = (width - (2 * padding)) / data.widthSquares;
				_height = (_squareWidth * data.heightSquares) + (2 * padding);
			}
			else
			{
				_height = heightOverride;
				_squareWidth = (height - (2 * padding)) / data.heightSquares;
				_width = (_squareWidth * data.widthSquares) + (2 * padding);
			}
			_gridWidth = data.widthSquares;
			_gridHeight = data.heightSquares;
			_padding = padding;
			_paddingColor = paddingColor;
			_colorList = Modification.getColorList(data);
			_squareColors = Vector.<Object>(clone(data.squares));
			_currentCircleColors = Vector.<Object>(clone(data.circles));
			_originalCircleColors = Vector.<Object>(clone(data.resetCircles == undefined ? data.circles : data.resetCircles));
			_circleColorsBeforeShift = Vector.<Object>(clone(data.circles));						
			_isLabeled = isLabeled;
			_isShiftInProgress = false;
			_timer = new Timer(0);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public const DEFAULT_SHIFT_DURATION:Number = 0.2;
		public const DEFAULT_RESET_DURATION:Number = 0.75;
		
		private var _board:Quad;
		private var _squares:Vector.<Vector.<Square>>;
		
		private var _width:Number;
		private var _height:Number;
		private var _gridWidth:uint;
		private var _gridHeight:uint;
		private var _squareWidth:Number;
		private var _padding:Number;	//TODO: create getter and setter for this instead of having a parameter
		private var _paddingColor:uint;
		
		private var _colorList:Vector.<uint>;
		private var _squareColors:Vector.<Object>;	//TODO: change this to Vector.<Vector.<uint>> if possible
		private var _currentCircleColors:Vector.<Object>;
		private var _originalCircleColors:Vector.<Object>;
		private var _circleColorsBeforeShift:Vector.<Object>;
		
		private var _isLabeled:Boolean;
		private var _isShiftInProgress:Boolean;
		
		private var _timer:Timer;
		
		public override function get width():Number 
		{
			return _width;
		}
		
		public override function get height():Number 
		{
			return _height;
		}		
		
		private function onAddedToStage(event:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_board = new Quad(_width, _height, _paddingColor);
			_board.x = 0;
			_board.y = 0;
			this.addChild(_board);
			
			_squares = new Vector.<Vector.<Square>>();
			
			var circleColor:uint;
			var squareColor:uint;
			var circleLabel:String;
			var squareLabel:String;			
			for(var i:uint = 0; i < _gridWidth; i++) 
			{
				_squares[i] = new Vector.<Square>();
				
				for(var n:uint = 0; n < _gridHeight; n++)
				{
					circleColor = _currentCircleColors[i][n];
					squareColor = _squareColors[i][n];
					circleLabel = String(_colorList.indexOf(circleColor) + 1);
					squareLabel = String(_colorList.indexOf(squareColor) + 1);
					_squares[i][n] = new Square(_squareWidth, squareColor, circleColor, _isLabeled, squareLabel, circleLabel);
					
					_squares[i][n].x = _padding + (_squareWidth * i);
					_squares[i][n].y = _height - _padding - (_squareWidth * (n + 1));
					
					this.addChild(_squares[i][n]);
				}
			}
		}

		public function shiftCircles(direction:String, transition:String = Transitions.LINEAR, duration:Number = DEFAULT_SHIFT_DURATION):void
		{
			if(!_isShiftInProgress) {
				_isShiftInProgress = true;
				_circleColorsBeforeShift = clone(_currentCircleColors);
				
				var column:int;
				var row:int;
				var length:uint;
				
				var changed:Boolean = false;
				var state:String = Analyzer.getCurrentState({circles: _circleColorsBeforeShift, squares: _squareColors, widthSquares: _gridWidth, heightSquares: _gridHeight});								
				var newLabel:String;
				trace('state before shift:', state);
				if(state != Analyzer.STUCK) {
					for(var i:uint = 0; i < _gridWidth; i++) {
						for(var n:uint = 0; n < _gridHeight; n++) {
							if(_squareColors[i][n] != _circleColorsBeforeShift[i][n]) {
								column = i;
								row = n;
								
								if(direction == Constants.UP || direction == Constants.DOWN) {
									length = _gridHeight;
								} else if(direction == Constants.LEFT || direction == Constants.RIGHT) {
									length = _gridWidth;
								}
								
								for(var t:uint = 0; t < length; t++) {
									switch(direction) {
										case Constants.UP:
											row--;
											
											break;
										case Constants.DOWN:
											row++;
											
											break;
										case Constants.LEFT:
											column++;
											
											break;
										case Constants.RIGHT:
											column--;
											
											break;
										default:
											break;
									}
									
									if(column < 0) {
										column += _gridWidth;
									} else if(column >= _gridWidth) {
										column -= _gridWidth;
									}
									
									if(row < 0) {
										row += _gridHeight;
									} else if(row >= _gridHeight) {
										row -= _gridHeight;
									}
									
									if(_squareColors[column][row] != _circleColorsBeforeShift[column][row]) {
										break;
									}
								}
								
								if(i != column || n != row) {
									_currentCircleColors[i][n] = _circleColorsBeforeShift[column][row];
									newLabel = String(_colorList.indexOf(_currentCircleColors[i][n]) + 1);
									_squares[i][n].shiftCircle(direction, _currentCircleColors[i][n], transition, duration, newLabel);
									changed = true;
								}
							}						
						}
					}
				}
				
				onShiftComplete(false, changed);
			}
		}			
		
		public function reset(direction:String = Constants.DOWN, transition:String = 'easeOutBounce', duration:Number = DEFAULT_RESET_DURATION):void 
		{
			if(!_isShiftInProgress) {
				_isShiftInProgress = true;
				
				var changed:Boolean = false;
				
				_circleColorsBeforeShift = clone(_currentCircleColors);
				_currentCircleColors = clone(_originalCircleColors);				
				
				var newLabel:String;
				for(var i:uint = 0; i < _gridWidth; i++) {
					for(var n:uint = 0; n < _gridHeight; n++) {
						if(_circleColorsBeforeShift[i][n] != _originalCircleColors[i][n]) {
							newLabel = String(_colorList.indexOf(_currentCircleColors[i][n]) + 1);
							_squares[i][n].shiftCircle(direction, _currentCircleColors[i][n], transition, duration, newLabel);
							changed = true;
						}
					}
				}
				
				onShiftComplete(true, changed);
			}
		}
		
		private function onShiftComplete(reset:Boolean, changed:Boolean):void {
			if(changed) {
				if(reset) {
					_timer.reset();
					_timer.delay = DEFAULT_RESET_DURATION * 1000;
					_timer.repeatCount = 1;
					_timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {						
						_isShiftInProgress = false;
					});
					_timer.start();
					
					dispatchEvent(new GameboardEvent(GameboardEvent.RESET, true));					
				} else {
					_timer.reset();
					_timer.delay = DEFAULT_SHIFT_DURATION * 1000;
					_timer.repeatCount = 1;
					_timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {						
						_isShiftInProgress = false;
					});
					_timer.start();
					
					dispatchEvent(new GameboardEvent(GameboardEvent.SHIFTED, true));
					
					if (Analyzer.getCurrentState({circles: _currentCircleColors, squares: _squareColors, widthSquares: _gridWidth, heightSquares: _gridHeight}) == Analyzer.SOLVED)
						dispatchEvent(new GameboardEvent(GameboardEvent.SOLVED, true));
				}				
			} else {
				if(reset) {
					dispatchEvent(new GameboardEvent(GameboardEvent.RESET, true));
				}
				_isShiftInProgress = false;
			}
		}
		
		/**
		 * @deprecated
		 */
		public function checkIfChanged():Boolean
		{
			var isChanged:Boolean;
			
			for(var i:uint = 0; i < _gridWidth; i++) {
				for(var n:uint = 0; n < _gridHeight; n++) {
					if(_currentCircleColors[i][n] != _circleColorsBeforeShift[i][n]) {
						isChanged = true;
						
						break;
					} else {
						isChanged = false;
					}						
				}
				
				if(isChanged) {
					break;
				}
			}

			return isChanged;
		}
		
		/**
		 * @deprecated
		 */
		public function checkIfSolved():Boolean
		{
			var isSolved:Boolean;
			
			for(var i:uint = 0; i < _gridWidth; i++) {
				for(var n:uint = 0; n < _gridHeight; n++) {
					if(_squareColors[i][n] != _currentCircleColors[i][n]) {
						isSolved = false;
						
						break;
					} else {
						isSolved = true;
					}
						
				}
				
				if(!isSolved) {
					break;
				}
			}			
			
			return isSolved;
		}
		
	}

}