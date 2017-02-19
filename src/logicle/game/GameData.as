package logicle.game  
{
	
	import flash.net.FileReference;	//TODO: delete when done
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.events.Event;		
	import flash.net.URLRequest;
	import flash.desktop.NativeApplication;
	import logicle.leveltools.utils.export;

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	
	import logicle.leveltools.utils.clone;
	
	/**
	 * ...
	 * @author Feilan Jiang
	 */
	
	public class GameData
	{
		static private const _APP_XML:XML = NativeApplication.nativeApplication.applicationDescriptor;
		static private const _APP_XML_NAMESPACE:Namespace = _APP_XML.namespace();
		static private const _VERSION_NUMBER:String = _APP_XML._APP_XML_NAMESPACE::versionNumber;
		
		static private const _LEVELS_DIRECTORY:String = '../levels/';
		static private const _INDEX_LOCATION:String = _LEVELS_DIRECTORY + 'index.json';
		static private var _levelPackIndex:Vector.<String>;
		static private var _categoryOrder:Object;
		
		//TODO: make events for these
		static private var _isLoadingComplete:Boolean = false;
		static private var _isStartupComplete:Boolean = false;		
		
		static private var _playerData:SharedObject;
		static private var _levelPacks:Object;		
		
		static private var _currentLevelPack:String;
		static private var _currentCategory:String;
		static private var _currentLevel:int;
		static private var _currentPage:int;
		
		static private var _queue:LoaderMax;
		
		static public function get playerData():Object
		{
			return _playerData.data;
		}
		
		static public function get levelPacks():Object
		{
			return _levelPacks;
		}
		
		static public function get queue():LoaderMax 
		{
			return _queue;
		}
		
		static public function get currentLevelPack():String 
		{
			return _currentLevelPack;
		}
		
		static public function get currentCategory():String 
		{
			return _currentCategory;
		}
		
		static public function get currentLevel():int 
		{
			return _currentLevel;
		}
		
		static public function get currentPage():int 
		{
			return _currentPage;
		}
		
		static public function set currentLevelPack(value:String):void 
		{
			_currentLevelPack = value;
		}
		
		static public function set currentCategory(value:String):void 
		{
			_currentCategory = value;
		}
		
		static public function set currentLevel(value:int):void 
		{
			_currentLevel = value;
		}
		
		static public function set currentPage(value:int):void 
		{
			_currentPage = value;
		}
		
		static public function get isLoadingComplete():Boolean 
		{
			return _isLoadingComplete;
		}
		
		static public function set isLoadingComplete(value:Boolean):void 
		{
			_isLoadingComplete = value;
		}
		
		static public function get isMusicOn():Boolean
		{
			return _playerData.data.settings.isMusicOn;
		}
		
		static public function set isMusicOn(value:Boolean):void
		{
			_playerData.data.settings.isMusicOn = value;
			_playerData.flush();
		}

		static public function get isSfxOn():Boolean
		{
			return _playerData.data.settings.isSfxOn;
		}
		
		static public function set isSfxOn(value:Boolean):void
		{
			_playerData.data.settings.isSfxOn = value;
			_playerData.flush();
		}
		
		static public function get isColorBlindModeOn():Boolean
		{
			return _playerData.data.settings.isColorBlindModeOn;
		}
		
		static public function set isColorBlindModeOn(value:Boolean):void
		{
			_playerData.data.settings.isColorBlindModeOn = value;
			_playerData.flush();
		}		
		
		static public function get isStartupComplete():Boolean 
		{
			return _isStartupComplete;
		}
		
		static public function set isStartupComplete(value:Boolean):void 
		{
			_isStartupComplete = value;
		}
		
		static public function get currentLevelData():Object 
		{
			return _levelPacks[_currentLevelPack][_currentCategory][_currentLevel];
		}
		
		static public function get currentLevelStats():Object 
		{
			return _playerData.data.stats[_currentLevelPack][_currentCategory][_currentLevel];
		}
		
		static public function get stats():Object
		{
			return _playerData.data.stats;
		}
		
		static public function get levelPackIndex():Vector.<String> 
		{
			return _levelPackIndex;
		}
		
		static public function get categoryOrder():Object 
		{
			return _categoryOrder;
		}
		
		static private function get statsBlock():Object 
		{
			return {
				fewestMoves: 0,
				isUnlocked: false,
				isComplete: {
					overall: false, 
					recent: false
				},
				isPerfect: {
					overall: false,
					recent: false
				}
			}
		}
		
		static public function loadPlayerData():void
		{
			_playerData = SharedObject.getLocal('playerData');			
			
			if(!_playerData.data.hasOwnProperty('settings'))
			{
				createNewPlayerData();
			}
		}
		
		static public function createNewPlayerData():void
		{		
			_playerData.data.settings = {isSfxOn:true, isMusicOn:true, isColorBlindModeOn: false};
			_playerData.data.stats = {};	// stats are set up when levels are loaded
			_playerData.data.versionNumber = _VERSION_NUMBER;
			_playerData.data.isBeginner = true;
			_playerData.flush();
		}
		
		static public function resetProgress():void 
		{
			for(var levelPack:String in _playerData.data.stats) {
				_playerData.data.stats[levelPack] = null;
				addStats(levelPack);
			}
			_playerData.data.isBeginner = true;			
			_playerData.flush();
		}
		
		//TODO: create an event (ON_LEVEL_COMPLETE) that calls this
		static public function updateStatsForLevel(levelPack:String, category:String, level:uint, numMoves:uint):void
		{
			var isComplete:Boolean = numMoves <= _levelPacks[levelPack][category][level].longestSolution;
			var isPerfect:Boolean = numMoves == _levelPacks[levelPack][category][level].shortestSolution;			
			if(numMoves < _playerData.data.stats[levelPack][category][level].fewestMoves
				|| _playerData.data.stats[levelPack][category][level].fewestMoves == 0) 
			{				
				_playerData.data.stats[levelPack][category][level].fewestMoves = numMoves;
			}												
			_playerData.data.stats[levelPack][category][level].isComplete.recent = isComplete;
			if(!_playerData.data.stats[levelPack][category][level].isComplete.overall) 
			{
				_playerData.data.stats[levelPack][category][level].isComplete.overall = isComplete;
			}
			_playerData.data.stats[levelPack][category][level].isPerfect.recent = isPerfect;			
			if(!_playerData.data.stats[levelPack][category][level].isPerfect.overall) 
			{
				_playerData.data.stats[levelPack][category][level].isPerfect.overall = isPerfect;				
			}
			
			if(isComplete && levelPack == Constants.VANILLA_LEVEL_PACK && 
				((category == Constants.TUTORIAL_CATEGORY && level == Constants.NUM_TUTORIAL_LEVELS - 1) || (category != Constants.TUTORIAL_CATEGORY && Constants.VANILLA_CATEGORIES.indexOf(category) != -1)))
			{
				_playerData.data.isBeginner = false;
			}
			
			_playerData.flush();
		}
		
		//TODO: create an event (ON_LEVEL_COMPLETE) that calls this
		static public function unlockNextLevel(levelPack:String, category:String, level:uint):void
		{
			if(_playerData.data.stats[levelPack][category][level].isComplete.recent) 
			{
				var nextLevel:int = 0;
				_currentLevel = level;
				nextLevel = _currentLevel + 1;
				if(!isLastLevelInCategory(_currentLevel, levelPack, category) && !_playerData.data.stats[levelPack][category][nextLevel].isUnlocked) 
				{
					_playerData.data.stats[levelPack][category][nextLevel].isUnlocked = true;
				}
				_playerData.flush();			
			}			
		}
		
		static public function levelUp(levelPack:String, category:String, level:uint):void 
		{
			if(_playerData.data.stats[levelPack][category][level].isComplete.recent) 
			{
				var categoryIndex:int = _categoryOrder[levelPack].indexOf(category);							
				if(!isLastLevelInLevelPack(_currentLevel, levelPack, category))
				{
					if(isLastLevelInCategory(_currentLevel, levelPack, category)) 
					{
						_currentLevel = 0;
						categoryIndex++;
						_currentCategory = _categoryOrder[levelPack][categoryIndex];
					} 
					else 
					{
						_currentLevel++;	
					}							
				}
			}
		}
		
		/**
		 * 
		 * @param	levelPack:String--the name of the level pack
		 * @param	category:String--the name of the category
		 * @return	int--the index of the highest unlocked level in the category
		 */
		static public function getIndexOfHighestLevelInCategory(levelPack:String, category:String):int
		{
			var isHighestLevel:Boolean = false;
			var level:int = -1;
			var length:int = _levelPacks[levelPack][category].length;
			
			if(levelPack in _levelPacks && category in _levelPacks[levelPack]) {
				while (!isHighestLevel) {
					level++;				
					isHighestLevel = level == length ? true : !_playerData.data.stats[levelPack][category][level].isUnlocked;
				};
				
				level--;
			}
			
			return level;
		}
		
		/**
		 * 
		 * @param	levelPack:String--the name of the level pack
		 * @param	category:String--the name of the category
		 * @return	int--the number of completed levels in the category specified by the parameter
		 */
		static public function getNumCompletedLevels(levelPack:String, category:String):int
		{
			var level:int = -1;
			var length:int = _levelPacks[levelPack][category].length;
			var numCompletedLevels:int = 0;
			var isComplete:Boolean;
			
			if(levelPack in _levelPacks && category in _levelPacks[levelPack]) {
				do {					
					level++;	
					isComplete = _playerData.data.stats[levelPack][category][level].isComplete.overall;
					if(isComplete) {
						numCompletedLevels++;
					}								
				} while(isComplete && level < length - 1);
			}
			
			return numCompletedLevels;			
		}
		
		/**
		 * 
		 * @param	levelPack The name of the level pack
		 * @param	category The name of the category
		 * @return	int--the index of the last level in the category
		 */
		static public function getIndexOfLastLevelInCategory(levelPack:String, category:String):int
		{
			return _levelPacks[levelPack][category].length - 1;
		}
		
		static public function getNameOfLastCategory(levelPack:String):String
		{
			var lastCategory:String = '';
			var lastIndex:int;
			
			if(levelPack in _categoryOrder) {
				lastIndex = _categoryOrder[levelPack].length - 1;
				lastCategory = _categoryOrder[levelPack][lastIndex];
			}				
			
			return lastCategory;
		}
		
		//parameters default to currentLevel, currentLevelPack, and currentCategory
		static public function isHighestLevelInCategory(level:int = 0, levelPack:String = '', category:String = ''):Boolean
		{
			var isHighestLevelInCategory:Boolean = level == 0 && levelPack == '' && category == '' ?
				_currentLevel == getIndexOfHighestLevelInCategory(_currentLevelPack, _currentCategory) :
				level == getIndexOfHighestLevelInCategory(levelPack, category);
			
			return isHighestLevelInCategory;
		}
		
		//parameters default to currentLevelPack and currentCategory
		static public function isLastLevelInCategory(level:int = 0, levelPack:String = '', category:String = ''):Boolean
		{
			var isLastLevelInCategory:Boolean = level == 0 && levelPack == '' && category == '' ?
				_currentLevel == getIndexOfLastLevelInCategory(_currentLevelPack, _currentCategory) :
				level == getIndexOfLastLevelInCategory(levelPack, category);
			
			return isLastLevelInCategory;
		}
		
		//parameters default to currentLevel, currentLevelPack, and currentCategory
		static public function isLastCategory(category:String = '', levelPack:String = ''):Boolean
		{
			var isLastCategory:Boolean = category == '' && levelPack == '' ?
				_currentCategory == getNameOfLastCategory(_currentLevelPack) : 
				category == getNameOfLastCategory(levelPack );
				
			return isLastCategory;
		}		
		
		//parameters default to currentLevel, currentLevelPack, and currentCategory
		static public function isLastLevelInLevelPack(level:int = 0, levelPack:String = '', category:String = ''):Boolean
		{
			var isLastLevelInLevelPack:Boolean = level == 0 && levelPack == '' && category == '' ? 
				isLastLevelInCategory(_currentLevel, _currentLevelPack, _currentCategory) && isLastCategory(_currentCategory, _currentLevelPack) :
				isLastLevelInCategory(level, levelPack, category) && isLastCategory(category, levelPack);
				
			return isLastLevelInLevelPack;			
		}
		
		static public function initializeLoadQueue():void // tested
		{						
			_queue = new LoaderMax({name: 'levelDataQueue', onComplete: completeHandler, onError: errorHandler, onFail: failHandler});
			
			var loader:URLLoader = new URLLoader(new URLRequest(_INDEX_LOCATION));
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				e.currentTarget.removeEventListener(e.type, arguments.callee); 
				
				_levelPackIndex = Vector.<String>(JSON.parse(loader.data));
				
				for(var i:int = 0, l:int = _levelPackIndex.length; i < l; i++) {
					_queue.append(new DataLoader(_LEVELS_DIRECTORY + _levelPackIndex[i], {name:_levelPackIndex[i], format: 'text'}));				
				}
				
				_queue.load();
			});
			
			function completeHandler(event:LoaderEvent):void // tested
			{
				var name:String;
				var loadedContent:Object;
				
				_levelPacks = {};
				_categoryOrder = {};
				
				var extensionIndex:int;
				var levelPackName:String;
				for(var i:int = 0, l:int = _levelPackIndex.length; i < l; i++) {
					name = _levelPackIndex[i];
					loadedContent = JSON.parse(_queue.getContent(name));
					extensionIndex = name.indexOf('.');
					levelPackName = name.substring(0, extensionIndex);
					levelPackIndex[i] = levelPackName;	// the .json file extension is removed from each level pack in the index
					_levelPacks[levelPackName] = loadedContent.categories;
					_categoryOrder[levelPackName] = loadedContent.categoryOrder;
					if(!(levelPackName in _playerData.data.stats)) 
					{
						addStats(levelPackName);
					}					
				}
				
				if(_playerData.data.versionNumber != _VERSION_NUMBER || _playerData.data.versionNumber == undefined) {
					updateOldPlayerData();
				}
			}
			
			function errorHandler(event:LoaderEvent):void
			{
			}
			
			function failHandler(event:LoaderEvent):void
			{
			}
		}
		
		//TODO: create this function before adding new level packs
		/*static public function addLevelPack():void
		{						
		}*/
		
		static private function updateOldPlayerData():void
		{
			var level:Object;
			var isComplete:Boolean;
			var levelPack:String, category:String;
			var i:int, l:int;
			switch(_playerData.data.versionNumber)
			{													
				/*
				 level stats structure for version 1.0.0:
					fewestMoves: 0,
					numStars: 0,
					isUnlocked: false,
					isComplete: false
				 */
				case undefined:	//1.0.0 or earlier -> 1.2.0
				{								
					// renaming "Tiny Boards" to "Beginner Boards" and transferring the progress made in Tiny Boards
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY] = clone(_playerData.data.stats['Levels']['Tiny Boards']);
					delete _playerData.data.stats['Levels']['Tiny Boards'];
					for(i = 0, l = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].length; i < l; i++)
					{
						level = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][i];
						level.fewestMoves = 0;
					}
					
					// updating the statsBlock structure
					for(levelPack in _playerData.data.stats)
					{
						for(category in _playerData.data.stats[levelPack])
						{
							for(i = 0, l = _playerData.data.stats[levelPack][category].length; i < l; i++)
							{
								level = _playerData.data.stats[levelPack][category][i];
								isComplete = level.isComplete;
								
								delete level.numStars;
								level.isComplete = 
								{
									overall: isComplete,
									recent: false
								}
								level.isPerfect = 
								{
									overall: level.fewestMoves == _levelPacks[levelPack][category][i].shortestSolution,
									recent: false
								}	
							}							
						}
					}
					
					// adding a new statsBlock for Beginner Boards (since it has one more level than Tiny Boards) and unlocking the level if necessary
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].push(statsBlock);
					l = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].length;
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][l - 1].isUnlocked = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][l - 2].isComplete.overall;
					
					// checking whether the player is a beginner
					_playerData.data.isBeginner = true;
					for(category in _playerData.data.stats[Constants.VANILLA_LEVEL_PACK])
					{
						if(category != Constants.TUTORIAL_CATEGORY && getNumCompletedLevels(Constants.VANILLA_LEVEL_PACK, category) > 0)
						{
							_playerData.data.isBeginner = false;
							break;
						}
					}
					
					// adding setting for colour blind mode
					_playerData.data.settings.isColorBlindModeOn = false;
				}
				break;
				
				/*
				 level stats structure for versions 1.1.0-1.1.4:
					fewestMoves: 0,
					isUnlocked: false,
					isComplete: {
						overall: false, 
						recent: false
					},
					isPerfect: {
						overall: false,
						recent: false
					}								
				 */
				case '1.1.0':
				case '1.1.1':
				case '1.1.2':
				case '1.1.3':
				case '1.1.4':	//1.1.0-1.1.4 -> 1.2.0
				{
					// renaming "Tiny Boards" to "Beginner Boards" and transferring the progress made in Tiny Boards
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY] = clone(_playerData.data.stats['Levels']['Tiny Boards']);
					delete _playerData.data.stats['Levels']['Tiny Boards'];
					for(i = 0, l = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].length; i < l; i++)
					{
						level = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][i];
						level.fewestMoves = 0;
					}
					
					// adding a new statsBlock for Beginner Boards (since it has one more level than Tiny Boards) and unlocking the level if necessary
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].push(statsBlock);
					l = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY].length;
					_playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][l - 1].isUnlocked = _playerData.data.stats[Constants.VANILLA_LEVEL_PACK][Constants.TUTORIAL_CATEGORY][l - 2].isComplete.overall;			
					
					// checking whether the player is a beginner					
					_playerData.data.isBeginner = true;
					for(category in _playerData.data.stats[Constants.VANILLA_LEVEL_PACK])
					{
						if(category != Constants.TUTORIAL_CATEGORY && getNumCompletedLevels(Constants.VANILLA_LEVEL_PACK, category) > 0)
						{
							_playerData.data.isBeginner = false;
							break;
						}
					}					
					
					// adding setting for colour blind mode
					_playerData.data.settings.isColorBlindModeOn = false;					
				}
				break;
				
				default:
				break;
			}	
			_playerData.data.versionNumber = _VERSION_NUMBER;			
			_playerData.flush();
		}
		
		static private function addStats(levelPack:String):void
		{
			if(levelPack in _levelPacks) {
				_playerData.data.stats[levelPack] = clone(_levelPacks[levelPack]);
				
				for(var category:String in _levelPacks[levelPack]) {
					for(var level:int = 0, l:int = _levelPacks[levelPack][category].length; level < l; level++) {
						_playerData.data.stats[levelPack][category][level] = GameData.statsBlock;
						_playerData.data.stats[levelPack][category][level].isUnlocked = level == 0;
					}
				}
			}
		}
		
		static private function exportPlayerData():void
		{
			export(_playerData.data, '_playerData.data (1.2.0).json');
		}
		
		static private function importPlayerData(path:String):void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(path));
			var loaded:Object, val:Object;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				loaded = JSON.parse(loader.data);
				_playerData.clear();
				for (var key:String in loaded)
				{
					val = loaded[key];
					_playerData.data[key] = val;
				}
				if(_playerData.data.versionNumber != _VERSION_NUMBER || _playerData.data.versionNumber == undefined) {
					updateOldPlayerData();
				}
			});
		}
	}

}