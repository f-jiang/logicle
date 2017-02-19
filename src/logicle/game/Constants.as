package logicle.game  
{
	
	import logicle.game.utils.scale;

	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class Constants 
	{
		static private const _PADDING_SMALL:Number = 5;
		static private const _PADDING_MEDIUM:Number = 10
		static private const _PADDING_LARGE:Number = 20;
		
		static public const LOADING_BAR_COLORS:Vector.<uint> = new <uint>[0x4D86E4, 0xB54535, 0x369A33, 0xF4D526, 0x867367, 0x8D37C1];
		
		static public const DEFAULT_WIDTH:Number = 360;
		static public const DEFAULT_HEIGHT:Number = 640;
		
		static public const HD_TEXTURE_ATLAS:String = 'hdTextureAtlas';
		static public const SD_TEXTURE_ATLAS:String = 'sdTextureAtlas';
		static public const LD_TEXTURE_ATLAS:String = 'ldTextureAtlas';
		
		static public const WVGA:String = '800x480';
		static public const FWVGA:String = '854x480';
		static public const WXGA:String = '1280x800';
		static public const WXGA_2:String = '1280x768';
		static public const XGA:String = '1024x768';
		static public const XGA_PLUS:String = '1152x864';
		static public const VGA:String = '640x480';		
		static public const nHD:String = '640x360';		
		static public const qHD:String = '960x540';
		static public const HD:String = '1280x720';
		static public const FHD:String = '1920x1080';
		static public const QHD:String = '2560x1440';
		
		static public const START:String = 'start';
		static public const ABOUT:String = 'about';
		static public const SETTINGS:String = 'settings';
		static public const CATEGORY_SELECT:String = 'packSelect';
		static public const LEVEL_SELECT:String = 'levelSelect';
		static public const IN_GAME:String = 'inGame';
		static public const IN_GAME2:String = 'inGame1';
		
		static public const UP:String = 'up';
		static public const DOWN:String = 'down';
		static public const LEFT:String = 'left';
		static public const RIGHT:String = 'right';
		
		static public const TUTORIAL_CATEGORY:String = 'Easy Boards';
		static public const NUM_TUTORIAL_LEVELS:uint = 6;
		static public const VANILLA_LEVEL_PACK:String = 'Levels';
		static public const VANILLA_CATEGORIES:Vector.<String> = new <String>[TUTORIAL_CATEGORY, '2x3 Boards', '3x3 Boards', '3x4 Boards'];		
		
		static public function get PADDING_SMALL():Number 
		{
			return scale(_PADDING_SMALL);
		}
		
		static public function get PADDING_MEDIUM():Number 
		{
			return scale(_PADDING_MEDIUM);
		}
		
		static public function get PADDING_LARGE():Number 
		{
			return scale(_PADDING_LARGE);
		}
		
	}

}