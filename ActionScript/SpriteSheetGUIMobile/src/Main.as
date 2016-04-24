package
{
	import com.bamkie.FileList;
	import com.bamkie.Terminator;
	import com.bamkie.ToastExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Align;
	
	public class Main extends Sprite
	{
		private const SPRITE_SHEET:String = "SpriteSheet";
		private const SPRITE:String = "Sprite";
		private const SPRITE_SHEET_BTN_MSG:String = "Select Sprite Sheet";
		private const DELAY:Number = 1500;
		
		private var _dataFolder:File;
		private var _dataList:Array;
		private var _fileLister:FileList;
		private var _toaster:ToastExtension
		private var _terminator:Terminator;
		
		// UI
		private var _viewArea:Canvas;
		private var _importButton:TextButton;
		private var _spriteSheetButton:TextButton;
		private var _animationButton:TextButton;
		private var _imageButton:TextButton;
		private var _modes:Dictionary; // Mode
		private var _currMode:String;
		
		// Animation -> 별도 클래스로 구성?
		private var _timer:Timer;
		
		private var _selectedSpriteSheet:SpriteSheet;
		private var _numSprite:int;
		private var _currSpriteIndex:int = -1;
		private var _isPlaying:Boolean = false;
		
		public function Main()
		{
			var screen:Rectangle = Screen.mainScreen.bounds;
			UISpec.getInstance().initialize(screen.width, screen.height * 0.98);
			
			// TEST
			
			// End of TEST
			
			// UI 에셋 로딩
			_dataFolder = File.applicationDirectory.resolvePath("data"); 
			_dataList = new Array();
			
			var files:Array = _dataFolder.getDirectoryListing();
			for (var i:int = 0; i < files.length; i++)
			{
				if (i == 0)
				{
					_dataList.push("");
				}
				
				if (File(files[i]).extension == "png")
				{
					var filename:String = File(files[i]).name;
					_dataList.push(filename.substring(0, filename.indexOf(".")));
				}
			}			
			_dataList.sort();
			
			InputManager.getInstance().loadRequest(
				ResourceType.UI_ASSET, _dataFolder, "icons",
				onCompleteUIAssetLoad, true);
				
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onClickBackButton);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
		}
				
		/**
		 * AnimationMode와 ImageMode를 세팅합니다. 
		 * 
		 */
		private function setMode():void
		{
			_modes = new Dictionary();
			_currMode = Mode.ANIMATION_MODE;
			
			// Animation Mode
			_modes[Mode.ANIMATION_MODE] = new AnimationMode(
				Mode.ANIMATION_MODE, onClickPlayButton, onClickStopButton, onClickReleaseButton);
			var animModeUI:Vector.<DisplayObject> = _modes[Mode.ANIMATION_MODE].setUI(true);
			
			if (animModeUI)
			{
				for (var i:int = 0; i < animModeUI.length; i++)
				{
					addChild(animModeUI[i]);
				}
			}
			
			// Image Mode
			_modes[Mode.IMAGE_MODE] = new ImageMode(
				Mode.IMAGE_MODE, onClickSpriteButton, onClickPrevButton, onClickNextButton);
			var imgModeUI:Vector.<DisplayObject> = _modes[Mode.IMAGE_MODE].setUI();
			
			if (imgModeUI)
			{
				for (var i:int = 0; i < imgModeUI.length; i++)
				{
					addChild(imgModeUI[i]);
				}
			}
		}
		
		/**
		 * 실질적 View 영역보다 큰 스프라이트의 크기를 조정합니다. 
		 * @param item 크기를 조정하고자 하는 DisplayOfbject입니다.
		 * @return 크기가 조정된 DisplayObject를 반환합니다.
		 * 
		 */
		private function adjustViewingItem(item:DisplayObject):DisplayObject // 개선 필요
		{
			var scale:Number = item.scale;
			
			if (item.width > UISpec.getInstance().actualViewAreaWidth)
			{
				scale = UISpec.getInstance().actualViewAreaWidth / item.width;
				item.scale = scale;
			}
						
			if (item.height > UISpec.getInstance().actualViewAreaHeight)
			{
				scale = scale * UISpec.getInstance().actualViewAreaHeight / item.height;
				item.scale = scale;
			}
						
			item.x = (_viewArea.width / 2) - (item.width / 2);
			item.y = (_viewArea.height / 2) - (item.height / 2) - UISpec.getInstance().playButtonHeight;
			
			return item;
		}
		
		/**
		 * 애니메이션 관련 객체를 초기화합니다. 
		 * 
		 */
		private function resetAnimator():void
		{
			if (!_selectedSpriteSheet)
			{
				return;
			}
			
			if (_timer)
			{
				_timer.stop();
				_timer.reset();
			}
			
			_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = false;
			
			for (var i:int = 0; i < _selectedSpriteSheet.sprites.length; i++)
			{
				_selectedSpriteSheet.sprites[i].visible = false;
			}
			
			_currSpriteIndex = -1;
			_isPlaying = false;
		}
		
		/**
		 * 애니메이션 관련 객체를 제거합니다.
		 * 
		 */
		private function cleanAnimator():void
		{
			resetAnimator();
			
			_viewArea.removeChild(_selectedSpriteSheet.spriteSheet);
			_selectedSpriteSheet = null;
			
			_numSprite = 0;
		}
		
		/**
		 * UI 에셋 리소스의 로딩이 완료되면 에셋을 생성하고 세팅합니다. 
		 * call by InputManager
		 */
		private function onCompleteUIAssetLoad():void
		{
			// _viewArea
			_viewArea = new Canvas();
			_viewArea.beginFill();
			_viewArea.drawRectangle(
				0, 0, UISpec.getInstance().viewAreaWidth, UISpec.getInstance().viewAreaHeight);
			_viewArea.endFill();
			_viewArea.x = UISpec.getInstance().viewAreaX;
			_viewArea.y = UISpec.getInstance().viewAreaY;
			_viewArea.touchable = false;
			addChild(_viewArea);

			// _importButton
			_importButton = new TextButton(
				UISpec.getInstance().importButtonX, UISpec.getInstance().importButtonY,
				UISpec.getInstance().importButtonWidth, UISpec.getInstance().importButtonHeight,
				"Import Sprite Sheet", Align.CENTER, true);
			_importButton.addEventListener(TouchEvent.TOUCH, onClickImportButton);
			addChild(_importButton);
			
			// _spriteSheetButton
			_spriteSheetButton = new TextButton(
				UISpec.getInstance().spriteSheetButtonX, UISpec.getInstance().spriteSheetButtonY,
				UISpec.getInstance().spriteSheetButtonWidth, UISpec.getInstance().spriteSheetButtonHeight,
				SPRITE_SHEET_BTN_MSG, Align.CENTER, true);
			_spriteSheetButton.addEventListener(TouchEvent.TOUCH, onClickSpriteSheetButton);
			addChild(_spriteSheetButton);
			
			// _animationButton
			_animationButton = new TextButton(
				UISpec.getInstance().animationButtonX, UISpec.getInstance().animationButtonY,
				UISpec.getInstance().animationButtonWidth, UISpec.getInstance().animationButtonHeight,
				Mode.ANIMATION_MODE, Align.CENTER, true);
			_animationButton.addEventListener(TouchEvent.TOUCH, onSelectMode);
			addChild(_animationButton);
						
			// _imageButton
			_imageButton = new TextButton(
				UISpec.getInstance().imageButtonX, UISpec.getInstance().imageButtonY,
				UISpec.getInstance().imageButtonWidth, UISpec.getInstance().imageButtonHeight,
				Mode.IMAGE_MODE, Align.CENTER, true);
			_imageButton.addEventListener(TouchEvent.TOUCH, onSelectMode);
			addChild(_imageButton);
			
			// Mode
			setMode();			
		}
		
		/**
		 * _importButton 클릭 시 스프라이트 시트를 선택하여 불러올 수 있도록 파일 브라우저(기기)를 호출합니다.
		 * @param event 터치 이벤트입니다.
		 * 
		 */
		private function onClickImportButton(event:TouchEvent):void
		{			
			if (!_toaster)
			{
				_toaster = new ToastExtension();
			}
			_toaster.toast("Under construction..."); 
		}
		
		/**
		 * 파일 브라우저에서 선택된 스프라이트 시트 파일을 앱이 생성한 저장소 디렉토리에 복사하고 작업 완료 팝업을 호출합니다.
		 * @param event 선택 이벤트입니다.
		 * 
		 */
		private function onSelectFile(event:Event):void
		{	
			// to do

		}
		
		/**
		 * _spriteSheetButton 클릭 시 출력할 스프라이트 시트를 선택할 수 있도록 파일 브라우저(앱이 생성한 저장소 디렉토리)를 호출합니다.
		 * @param event 터치 이벤트입니다.
		 * 
		 */
		private function onClickSpriteSheetButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (!action || !_modes || !_modes[Mode.ANIMATION_MODE] || !_modes[Mode.IMAGE_MODE])
			{
				return;
			}
			
			var target:TextButton = action.target.parent as TextButton;
			
			if (!this.hitTest(action.getLocation(this)) || target != this.hitTest(action.getLocation(this)).parent)
			{
				return;
			}
			
			if (_dataList && _dataList.length > 1)
			{
				_dataList[0] = SPRITE_SHEET;
			}
			else
			{
				if (!_toaster)
				{
					_toaster = new ToastExtension();
				}
				_toaster.toast("No data."); 
			}
			
			if (!_fileLister)
			{
				_fileLister = new FileList(onSelectItem);
			}
			_fileLister.showFileList(_dataList);	
		}
		
		private function onSelectItem(type:String, item:String):void
		{
			switch (type)
			{
				case SPRITE_SHEET:
				{
					resetAnimator();
					
					ImageMode(_modes[Mode.IMAGE_MODE]).spriteButtonText = "Select Sprite";
					
					InputManager.getInstance().loadRequest(
						ResourceType.SPRITE_SHEET, _dataFolder, item,
						onCompleteSpriteSheetLoad, true);
				}
					break;
				
				case SPRITE:
				{
					_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = false;
					
					if (_currSpriteIndex >= 0)
					{
						_viewArea.getChildByName(_selectedSpriteSheet.sprites[_currSpriteIndex].name).visible = false;	
					}
					
					var object:DisplayObject = _viewArea.getChildByName(ImageMode(_modes[Mode.IMAGE_MODE]).spriteButtonText);
					if (object)
					{
						object.visible = false;
					}
					
					_viewArea.addChild(adjustViewingItem(_selectedSpriteSheet.find(item)));
					_viewArea.getChildByName(item).visible = true;
					
					ImageMode(_modes[Mode.IMAGE_MODE]).spriteButtonText = item;
					
					_currSpriteIndex = _selectedSpriteSheet.getIndex(item);
				}
					break;
			}
		}
		
		/**
		 * 스프라이트 시트의 로딩이 완료되면 시트를 View 영역에 출력합니다. 
		 * @param contents 로드된 스프라이트 시트입니다.
		 * call by InputManager
		 */
		private function onCompleteSpriteSheetLoad(contents:SpriteSheet):void
		{
			if (contents)
			{
				_selectedSpriteSheet = contents;
				_numSprite = _selectedSpriteSheet.sprites.length;

				_spriteSheetButton.text = _selectedSpriteSheet.spriteSheet.name;			
				
				_viewArea.addChild(adjustViewingItem(_selectedSpriteSheet.spriteSheet));
				_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = true;
			}
		}
		
		/**
		 * 현재 선택된 스프라이트 시트를 재생합니다.
		 * call by AnimationMode
		 */
		private function onClickPlayButton():void
		{
			if (!_selectedSpriteSheet)
			{
				return;
			}
				
			if (!_timer)
			{
				_timer = new Timer(DELAY);
				_timer.addEventListener(TimerEvent.TIMER, onTick);
			}
			_timer.start();
			_isPlaying = true;
			
			_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = false;
		}
		
		/**
		 * 스프라이트 재생을 정지하고 선택된 스트라이트 시트를 출력합니다. 
		 * call by AnimationMode
		 */
		private function onClickStopButton():void
		{
			if (_isPlaying)
			{
				resetAnimator();
				_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = true;
			}
		}
		
		/**
		 * 선택된 스프라이트 시트를 메모리(InputManager) 및 앱 저장소에서 제거합니다. 
		 * call by AnimationMode
		 */
		private function onClickReleaseButton():void
		{
			if (!_selectedSpriteSheet)
			{
				return;
			}
			
			var name:String = _selectedSpriteSheet.spriteSheet.name;
			
			// @this
			cleanAnimator();
			var index:int = _dataList.indexOf(name);
			_dataList[index] = null;
			_dataList.removeAt(index);
			
			// @_spriteSheetButton
			_spriteSheetButton.text = SPRITE_SHEET_BTN_MSG;
			
			// @InputManager
			InputManager.getInstance().releaseRequest(name);
		}

		/**
		 * _spriteButton 클릭 시 출력할 스프라이트를 선택할 수 있도록 파일 목록을 호출합니다. 
		 * @param event 터치 이벤트입니다.
		 * 
		 */
		private function onClickSpriteButton():void
		{
			if (!_selectedSpriteSheet)
			{
				if (!_toaster)
				{
					_toaster = new ToastExtension();
				}
				_toaster.toast("Select Sprite sheet First."); 
				
				return;
			}
			
			var names:Array = new Array(_selectedSpriteSheet.sprites.length + 1);
			for (var i:int = 0; i < names.length; i++)
			{
				if (i != 0)
				{
					names[i] = _selectedSpriteSheet.sprites[i - 1].name;	
				}
				else
				{
					names[i] = SPRITE;
				}
			}
						
			if (!_fileLister)
			{
				_fileLister = new FileList(onSelectItem);
			}
			_fileLister.showFileList(names);			
		}
		
		/**
		 * 현재 출력된 스프라이트의 이전 스프라이트를 출력합니다. 맨 처음 스프라이트일 경우 마지막 스프라이트를 출력합니다.
		 * call by ImageMode
		 */
		private function onClickPrevButton():void
		{
			if (!_selectedSpriteSheet)
			{
				return;
			}
			
			_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = false;
			
			var prevIndex:int = _currSpriteIndex;
			_currSpriteIndex--;
			
			if (_currSpriteIndex < 0)
			{
				_currSpriteIndex = _numSprite - 1;
			}
			
			if (prevIndex >= 0)
			{
				_viewArea.getChildByName(_selectedSpriteSheet.sprites[prevIndex].name).visible = false;
			}
			
			_viewArea.addChild(adjustViewingItem(_selectedSpriteSheet.sprites[_currSpriteIndex]));
			_viewArea.getChildByName(_selectedSpriteSheet.sprites[_currSpriteIndex].name).visible = true;
			
			ImageMode(_modes[Mode.IMAGE_MODE]).spriteButtonText = _selectedSpriteSheet.sprites[_currSpriteIndex].name;
		}
		
		/**
		 * 현재 출력된 스프라이트의 다음 스프라이트를 출력합니다. 마지막 스프라이트일 경우 맨 처음 스프라이트를 출력합니다.
		 * call by ImageMode
		 */
		private function onClickNextButton():void
		{
			if (!_selectedSpriteSheet)
			{
				return;
			}
			
			_viewArea.getChildByName(_selectedSpriteSheet.spriteSheet.name).visible = false;
			
			var prevIndex:int = _currSpriteIndex;
			_currSpriteIndex++;
			
			if (_currSpriteIndex > _numSprite - 1)
			{
				_currSpriteIndex = 0;
			}
			
			if (prevIndex >= 0)
			{
				_viewArea.getChildByName(_selectedSpriteSheet.sprites[prevIndex].name).visible = false;
			}
			
			_viewArea.addChild(adjustViewingItem(_selectedSpriteSheet.sprites[_currSpriteIndex]));
			_viewArea.getChildByName(_selectedSpriteSheet.sprites[_currSpriteIndex].name).visible = true;
			
			ImageMode(_modes[Mode.IMAGE_MODE]).spriteButtonText = _selectedSpriteSheet.sprites[_currSpriteIndex].name;
		}
		
		/**
		 * 모드를 변환합니다. 
		 * @param mode 변환할 모드의 이름입니다.
		 * 
		 */
		private function onSelectMode(event:TouchEvent):void
		{
			var action:Touch = event.getTouch(this, TouchPhase.ENDED);

			if (!action || !_modes || !_modes[Mode.ANIMATION_MODE] || !_modes[Mode.IMAGE_MODE])
			{
				return;
			}
			
			var target:TextButton = action.target.parent as TextButton;
			
			if (!this.hitTest(action.getLocation(this)) || target != this.hitTest(action.getLocation(this)).parent)
			{
				return;
			}
			
			switch (target.text)
			{
				case Mode.ANIMATION_MODE:
				{
					_modes[Mode.IMAGE_MODE].deactivate();
					_modes[Mode.ANIMATION_MODE].activate();
					
					if (_selectedSpriteSheet)
					{
						var object:DisplayObject;	
						if (_currSpriteIndex >= 0 && _currSpriteIndex < _numSprite)
						{
							object = _viewArea.getChildByName(_selectedSpriteSheet.sprites[_currSpriteIndex].name);
							
							if (object)
							{
								object.visible = false;
							}
						}
						
						_spriteSheetButton.text = SPRITE_SHEET_BTN_MSG;
						_selectedSpriteSheet = null;
					}
					
					_currMode = target.text;
				}
					break;
				
				case Mode.IMAGE_MODE:
				{
					_modes[Mode.ANIMATION_MODE].deactivate();
					_modes[Mode.IMAGE_MODE].activate();
					
					if (_selectedSpriteSheet)
					{
						resetAnimator();
						
						_spriteSheetButton.text = SPRITE_SHEET_BTN_MSG;
						_selectedSpriteSheet = null;
					}
					
					_currMode = target.text;
				}
					break;
			}
		}
		
		/**
		 * 애니메이션 재생 시 설정한 딜레이마다 호출되는 함수입니다. 현재 출력 중인 스프라이트를 숨기고 다음 인덱스의 스프라이트를 보이게 합니다. 
		 * @param event 타이머 이벤트입니다.
		 * 
		 */
		private function onTick(event:TimerEvent):void
		{
			var prevIndex:int = _currSpriteIndex;
			_currSpriteIndex++;
			
			if (_currSpriteIndex > _numSprite - 1)
			{
				_currSpriteIndex = 0;
			}
			
			if (prevIndex >= 0)
			{
				_viewArea.getChildByName(_selectedSpriteSheet.sprites[prevIndex].name).visible = false;
			}
			
			_viewArea.addChild(adjustViewingItem(_selectedSpriteSheet.sprites[_currSpriteIndex]));
			_viewArea.getChildByName(_selectedSpriteSheet.sprites[_currSpriteIndex].name).visible = true;
		}
		
		/**
		 * Back 버튼을 클릭하면 프로그램 종료 여부를 묻는 Alert를 호출합니다.
		 * @param event 키보드 이벤트입니다.
		 * 
		 */
		private function onClickBackButton(event:KeyboardEvent):void
		{
			event.preventDefault();
			
			if (!_terminator)
			{
				_terminator = new Terminator();
			}
			_terminator.alert();
		}
		
		private function onExit(event:Event):void
		{
			// UI
			removeChildren();
			
			_modes = null;
			_currMode = null;
						
			// Animation
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTick);
			}
			_timer = null;
			
			_dataFolder = null;
			_selectedSpriteSheet = null;
			
			_terminator.dispose();
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onClickBackButton);
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
		}
	}
}