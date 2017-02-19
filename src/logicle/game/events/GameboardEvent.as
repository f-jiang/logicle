package logicle.game.events 
{
	
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 * Gameboard 1.1.0
	 */
	
	public class GameboardEvent extends Event
	{
		
		static public const SHIFTED:String = 'shifted';		
		static public const RESET:String = 'reset';
		static public const SOLVED:String = 'solved';
		
		public function GameboardEvent(type:String, bubbles:Boolean)
		{
			super(type, bubbles);
		}
		
	}

}