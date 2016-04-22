package
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class ImageMode extends Mode
	{
		private const SPRITE_BTN_MSG:String = "Select Sprite";
		
		private var _spriteButton:TextButton;
		private var _prevButton:ImageButton;
		private var _nextButton:ImageButton;
//		private var _quantityField:TextField;
//		private var _nameField:TextField;
		
		private var _onClickSpriteButton:Function;
		private var _onClickPrevButton:Function;
		private var _onClickNextButton:Function;
		
		public function ImageMode(id:String, onClickSpriteButton:Function, onClickPrevButton:Function, onClickNextButton:Function)
		{
			_id = id;
			_onClickSpriteButton = onClickSpriteButton;
			_onClickPrevButton = onClickPrevButton;
			_onClickNextButton = onClickNextButton;	
		}
		
		public function setUI(visible:Boolean = false):Vector.<DisplayObject>
		{
			var objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			// _spriteButton
			_spriteButton = new TextButton(
				UISpec.getInstance().spriteButtonX, UISpec.getInstance().spriteButtonY,
				UISpec.getInstance().spriteButtonWidth, UISpec.getInstance().spriteButtonHeight,
				SPRITE_BTN_MSG, Align.CENTER, true);
			_spriteButton.addEventListener(TouchEvent.TOUCH, onClickSpriteButton);
			_spriteButton.visible = visible;
			objects.push(_spriteButton);
			
			// _prevButton
			var prevBtnTex:Texture = InputManager.getInstance().getTexture("previous");
			if (prevBtnTex)
			{		
				_prevButton = new ImageButton(
					UISpec.getInstance().prevButtonX, UISpec.getInstance().prevButtonY,
					UISpec.getInstance().prevButtonWidth, UISpec.getInstance().prevButtonHeight,
					prevBtnTex);
				_prevButton.visible = visible;
				_prevButton.addEventListener(TouchEvent.TOUCH, onClickPrevButton);
				objects.push(_prevButton);
			}
			
			// _nextButton
			var nextBtnTex:Texture = InputManager.getInstance().getTexture("next");
			if (nextBtnTex)
			{		
				_nextButton = new ImageButton(
					UISpec.getInstance().nextButtonX, UISpec.getInstance().nextButtonY,
					UISpec.getInstance().nextButtonWidth, UISpec.getInstance().nextButtonHeight,
					nextBtnTex);
				_nextButton.visible = visible;
				_nextButton.addEventListener(TouchEvent.TOUCH, onClickNextButton);
				objects.push(_nextButton);
			}
			
			return objects;
		}
		
		public function activate():void
		{
			if (_spriteButton)
			{
				_spriteButton.visible = true;
				_spriteButton.touchable = true;
			}
			
			if (_prevButton)
			{
				_prevButton.visible = true;
				_prevButton.touchable = true;
			}
			
			if (_nextButton)
			{
				_nextButton.visible = true;
				_nextButton.touchable = true;
			}
			
//			if (_quantityField)
//			{
//				_quantityField.visible = true;
//			}
//			
//			if (_nameField)
//			{
//				_nameField.visible = true;
//			}
		}
		
		public function deactivate():void
		{
			if (_spriteButton)
			{
				_spriteButton.text = SPRITE_BTN_MSG;
				_spriteButton.visible = false;
			}
			
			if (_prevButton)
			{
				_prevButton.visible = false;
			}
			
			if (_nextButton)
			{
				_nextButton.visible = false;
			}
			
//			if (_quantityField)
//			{
//				_quantityField.visible = false;
//			}
//			
//			if (_nameField)
//			{
//				_nameField.visible = false;
//			}
		}
		
		public override function dispose():void
		{
			if (_spriteButton)
			{
				_spriteButton.dispose();
			}
			_spriteButton = null;
			
			if (_prevButton)
			{
				_prevButton.dispose();
			}
			_prevButton = null;
			
			if (_nextButton)
			{
				_nextButton.dispose();
			}
			_nextButton = null;
			
			super.dispose();
		}
		
		private function onClickSpriteButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_spriteButton, TouchPhase.ENDED);
			
			if (action)
			{
				_onClickSpriteButton(); // ImageMode에서 제어할 수 없을까?
			}
		}
		
		private function onClickPrevButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_prevButton, TouchPhase.ENDED);
			
			if (action)
			{
				_onClickPrevButton();
			}
		}
		
		private function onClickNextButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_nextButton, TouchPhase.ENDED);
			
			if (action)
			{
				_onClickNextButton();				
			}
		}
	}
}