package
{
	public class UISpec
	{
		private static var _instance:UISpec;
		
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		
		private var _viewAreaX:Number;
		private var _viewAreaY:Number;
		private var _viewAreaWidth:Number;
		private var _viewAreaHeight:Number;
		private var _actualViewAreaWidth:Number;
		private var _actualViewAreaHeight:Number;

		private var _importButtonX:Number;
		private var _importButtonY:Number;
		private var _importButtonWidth:Number;
		private var _importButtonHeight:Number;
		
		private var _spriteSheetButtonX:Number;
		private var _spriteSheetButtonY:Number;
		private var _spriteSheetButtonWidth:Number;
		private var _spriteSheetButtonHeight:Number;
		
		private var _spriteButtonX:Number;
		private var _spriteButtonY:Number;
		private var _spriteButtonWidth:Number;
		private var _spriteButtonHeight:Number;
		
		private var _animationButtonX:Number;
		private var _animationButtonY:Number;
		private var _animationButtonWidth:Number;
		private var _animationButtonHeight:Number;
		
		private var _imageButtonX:Number;
		private var _imageButtonY:Number;
		private var _imageButtonWidth:Number;
		private var _imageButtonHeight:Number;
		
		private var _playButtonX:Number;
		private var _playButtonY:Number;
		private var _playButtonWidth:Number;
		private var _playButtonHeight:Number;
		
		private var _stopButtonX:Number;
		private var _stopButtonY:Number;
		private var _stopButtonWidth:Number;
		private var _stopButtonHeight:Number;
		
		private var _releaseButtonX:Number;
		private var _releaseButtonY:Number;
		private var _releaseButtonWidth:Number;
		private var _releaseButtonHeight:Number;
		
		private var _prevButtonX:Number;
		private var _prevButtonY:Number;
		private var _prevButtonWidth:Number;
		private var _prevButtonHeight:Number;
				
		private var _nextButtonX:Number;
		private var _nextButtonY:Number;
		private var _nextButtonWidth:Number;
		private var _nextButtonHeight:Number;
		
		public function UISpec()
		{
			_instance = this;
		}
		
		public static function getInstance():UISpec
		{
			if (!_instance)
			{
				_instance = new UISpec();
			}
			return _instance;
		}
		
		public function dispose():void
		{
			_instance = null;
		}
		
		public function initialize(screenWidth:Number, screenHeight:Number):void
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;	
			
			var actualViewAreaRatio:Number = 0.85;
			
			_viewAreaX = 0;
			_viewAreaY = 0;
			_viewAreaWidth = _screenHeight;
			_viewAreaHeight = _screenHeight;
			_actualViewAreaWidth = _viewAreaWidth * actualViewAreaRatio;
			_actualViewAreaHeight = _viewAreaHeight * actualViewAreaRatio;
			
			var selectionBtnWidth:Number = (_screenWidth - _viewAreaWidth) * 0.8;
			var selectionBtnHeight:Number = _screenHeight * 0.1;
			var margin:Number = (_screenWidth - _viewAreaWidth - selectionBtnWidth) / 2;
			var modeBtnWidth:Number = (selectionBtnWidth - margin) / 2;
			var modeBtnHeight:Number = selectionBtnHeight;			
			var modeBtnY:Number = _screenHeight - margin * 1.5 - modeBtnHeight;
			
			_importButtonX = _viewAreaWidth + margin;
			_importButtonY = margin;
			_importButtonWidth = selectionBtnWidth;
			_importButtonHeight = selectionBtnHeight;
			
			_spriteSheetButtonX = _viewAreaWidth + margin;
			_spriteSheetButtonY = _importButtonY + _importButtonHeight + margin;
			_spriteSheetButtonWidth = selectionBtnWidth;
			_spriteSheetButtonHeight = selectionBtnHeight;
			
			_spriteButtonX = _viewAreaWidth + margin;
			_spriteButtonY = _spriteSheetButtonY + _spriteSheetButtonHeight + margin;
			_spriteButtonWidth = selectionBtnWidth;
			_spriteButtonHeight = selectionBtnHeight;
			
			_animationButtonX = _viewAreaWidth + margin;
			_animationButtonY = modeBtnY;
			_animationButtonWidth = modeBtnWidth;
			_animationButtonHeight = modeBtnHeight;
			
			_imageButtonX = _animationButtonX + _animationButtonWidth + margin;
			_imageButtonY = modeBtnY;
			_imageButtonWidth = modeBtnWidth;
			_imageButtonHeight = modeBtnHeight;
			
			var animCtrlMargin:Number = margin * 2;
			var imageCtrlMargin:Number = margin * 4;
			var ctrlBtnSize:Number = _viewAreaHeight * 0.05;
			var ctrlBtnY:Number = _screenHeight - margin - ctrlBtnSize;
			
			_playButtonX = animCtrlMargin;
			_playButtonY = modeBtnY;
			_playButtonWidth = ctrlBtnSize;
			_playButtonHeight = ctrlBtnSize;
			
			_stopButtonX = _playButtonX + _playButtonWidth + animCtrlMargin;
			_stopButtonY = modeBtnY;
			_stopButtonWidth = ctrlBtnSize;
			_stopButtonHeight = ctrlBtnSize;
			
			_releaseButtonX = _stopButtonX + _stopButtonWidth + animCtrlMargin;
			_releaseButtonY = modeBtnY;
			_releaseButtonWidth = ctrlBtnSize;
			_releaseButtonHeight = ctrlBtnSize;
			
			_prevButtonX = _playButtonX;
			_prevButtonY = modeBtnY;
			_prevButtonWidth = ctrlBtnSize;
			_prevButtonHeight = ctrlBtnSize;
			
			_nextButtonX = _prevButtonX + imageCtrlMargin;
			_nextButtonY = modeBtnY;
			_nextButtonWidth = ctrlBtnSize;
			_nextButtonHeight = ctrlBtnSize;
		}
		
		public function get screenWidth():Number
		{
			return _screenWidth;
		}
		
		public function get screenHeight():Number
		{
			return _screenHeight;
		}
		
		public function get viewAreaX():Number
		{
			return _viewAreaX;
		}
		
		public function get viewAreaY():Number
		{
			return _viewAreaY;
		}
		
		public function get viewAreaWidth():Number
		{
			return _viewAreaWidth;
		}
		
		public function get viewAreaHeight():Number
		{
			return _viewAreaHeight;
		}
		
		public function get actualViewAreaWidth():Number
		{
			return _actualViewAreaWidth;
		}
		
		public function get actualViewAreaHeight():Number
		{
			return _actualViewAreaHeight;
		}

		public function get importButtonX():Number
		{
			return _importButtonX;
		}
		
		public function get importButtonY():Number
		{
			return _importButtonY;
		}
		
		public function get importButtonWidth():Number
		{
			return _importButtonWidth;
		}
		
		public function get importButtonHeight():Number
		{
			return _importButtonHeight;
		}
		
		public function get spriteSheetButtonX():Number
		{
			return _spriteSheetButtonX;
		}
		
		public function get spriteSheetButtonY():Number
		{
			return _spriteSheetButtonY;
		}
		
		public function get spriteSheetButtonWidth():Number
		{
			return _spriteSheetButtonWidth;
		}
		
		public function get spriteSheetButtonHeight():Number
		{
			return _spriteSheetButtonHeight;
		}
		
		public function get spriteButtonX():Number
		{
			return _spriteButtonX;
		}
		
		public function get spriteButtonY():Number
		{
			return _spriteButtonY;
		}
		
		public function get spriteButtonWidth():Number
		{
			return _spriteButtonWidth;
		}
		
		public function get spriteButtonHeight():Number
		{
			return _spriteButtonHeight;
		}
		
		public function get animationButtonX():Number
		{
			return _animationButtonX;
		}
		
		public function get animationButtonY():Number
		{
			return _animationButtonY;
		}
		
		public function get animationButtonWidth():Number
		{
			return _animationButtonWidth;
		}
		
		public function get animationButtonHeight():Number
		{
			return _animationButtonHeight;
		}
		
		public function get imageButtonX():Number
		{
			return _imageButtonX;
		}
		
		public function get imageButtonY():Number
		{
			return _imageButtonY;
		}
		
		public function get imageButtonWidth():Number
		{
			return _imageButtonWidth;
		}
		
		public function get imageButtonHeight():Number
		{
			return _imageButtonHeight;
		}
		
		public function get playButtonX():Number
		{
			return _playButtonX;
		}
		
		public function get playButtonY():Number
		{
			return _playButtonY;
		}
		
		public function get playButtonWidth():Number
		{
			return _playButtonWidth;
		}
		
		public function get playButtonHeight():Number
		{
			return _playButtonHeight;
		}
		
		public function get stopButtonX():Number
		{
			return _stopButtonX;
		}
		
		public function get stopButtonY():Number
		{
			return _stopButtonY;
		}
		
		public function get stopButtonWidth():Number
		{
			return _stopButtonWidth;
		}
		
		public function get stopButtonHeight():Number
		{
			return _stopButtonHeight;
		}
		
		public function get releaseButtonX():Number
		{
			return _releaseButtonX;
		}
		
		public function get releaseButtonY():Number
		{
			return _releaseButtonY;
		}
		
		public function get releaseButtonWidth():Number
		{
			return _releaseButtonWidth;
		}
		
		public function get releaseButtonHeight():Number
		{
			return _releaseButtonHeight;
		}
		
		public function get prevButtonX():Number
		{
			return _prevButtonX;
		}
		
		public function get prevButtonY():Number
		{
			return _prevButtonY;
		}
		
		public function get prevButtonWidth():Number
		{
			return _prevButtonWidth;
		}
		
		public function get prevButtonHeight():Number
		{
			return _prevButtonHeight;
		}
		
		public function get nextButtonX():Number
		{
			return _nextButtonX;
		}
		
		public function get nextButtonY():Number
		{
			return _nextButtonY;
		}
		
		public function get nextButtonWidth():Number
		{
			return _nextButtonWidth;
		}
		
		public function get nextButtonHeight():Number
		{
			return _nextButtonHeight;
		}
	}
}