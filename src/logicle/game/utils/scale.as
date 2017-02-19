package logicle.game.utils 
{
	import logicle.game.Constants;
	import logicle.game.Logicle;
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	/**
	 * 
	 * @param originalValue
	 * @return InterConnection.starling.stage.stageWidth * ( originalValue / Constants.DEFAULT_WIDTH )
	 * 
	 * - To be used for layout values pertaining to position and size when the stage dimensions are different from the defaults
	 * - Returns a scaled value that maintains the same ratio with the current stage dimensions
	 * - Should not be used with components that have already been scaled
	 */
	public function scale(originalValue:Number):Number
	{
		return Logicle.starling.stage.stageWidth * ( originalValue / Constants.DEFAULT_WIDTH );
	}

}