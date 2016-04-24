package
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class AnimationMode extends Mode
	{
		private var _playButton:ImageButton;
		private var _stopButton:ImageButton;
		private var _releaseButton:ImageButton;
		
		private var _onClickPlayButton:Function;
		private var _onClickStopButton:Function;
		private var _onClickReleaseButton:Function;
		
		public function AnimationMode(
			id:String, playSpriteSheet:Function, stopAnimation:Function, releaseSpriteSheet:Function)
		{
			_id = id;			
			_onClickPlayButton = playSpriteSheet;
			_onClickStopButton = stopAnimation;
			_onClickReleaseButton = releaseSpriteSheet;
		}
		
		public function setUI(visible:Boolean = false):Vector.<DisplayObject> // track button scale
		{
			var objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			// _playButton
			var playBtnTex:Texture = InputManager.getInstance().getTexture("play");
			if (playBtnTex)
			{		
				_playButton = new ImageButton(
					UISpec.getInstance().playButtonX, UISpec.getInstance().playButtonY,
					UISpec.getInstance().playButtonWidth, UISpec.getInstance().playButtonHeight,
					playBtnTex);
				
				var scale:Number = _playButton.scale;
				if (_playButton.width > UISpec.getInstance().playButtonWidth)
				{
					scale = UISpec.getInstance().playButtonWidth / _playButton.width;
					_playButton.scale = scale;
				}
				if (_playButton.height > UISpec.getInstance().playButtonHeight)
				{
					scale = scale * UISpec.getInstance().playButtonHeight / _playButton.height;
					_playButton.scale = scale;
				}
				_playButton.visible = visible;
				_playButton.addEventListener(TouchEvent.TOUCH, onClickPlayButton);
				objects.push(_playButton);
			}
			
			// _stopButton
			var stopBtnTex:Texture = InputManager.getInstance().getTexture("stop");
			if (stopBtnTex)
			{	
				_stopButton = new ImageButton(
					UISpec.getInstance().stopButtonX, UISpec.getInstance().stopButtonY,
					UISpec.getInstance().stopButtonWidth, UISpec.getInstance().stopButtonHeight,
					stopBtnTex);
				
				var scale:Number = _stopButton.scale;
				if (_stopButton.width > UISpec.getInstance().stopButtonWidth)
				{
					scale = UISpec.getInstance().stopButtonWidth / _stopButton.width;
					_stopButton.scale = scale;
				}
				if (_stopButton.height > UISpec.getInstance().stopButtonHeight)
				{
					scale = scale * UISpec.getInstance().stopButtonHeight / _stopButton.height;
					_stopButton.scale = scale;
				}
				_stopButton.visible = visible;
				_stopButton.addEventListener(TouchEvent.TOUCH, onClickStopButton);
				objects.push(_stopButton);
			}
			
			// _releaseButton
			var releaseBtnTex:Texture = InputManager.getInstance().getTexture("release");
			if (releaseBtnTex)
			{		
				_releaseButton = new ImageButton(
					UISpec.getInstance().releaseButtonX, UISpec.getInstance().releaseButtonY,
					UISpec.getInstance().releaseButtonWidth, UISpec.getInstance().releaseButtonHeight,
					releaseBtnTex);
				
				var scale:Number = _releaseButton.scale;
				if (_releaseButton.width > UISpec.getInstance().releaseButtonWidth)
				{
					scale = UISpec.getInstance().releaseButtonWidth / _releaseButton.width;
					_releaseButton.scale = scale;
				}
				if (_releaseButton.height > UISpec.getInstance().releaseButtonHeight)
				{
					scale = scale * UISpec.getInstance().releaseButtonHeight / _releaseButton.height;
					_releaseButton.scale = scale;
				}
				_releaseButton.visible = visible;
				_releaseButton.addEventListener(TouchEvent.TOUCH, onClickReleaseButton);
				objects.push(_releaseButton);
			}
			
			return objects;
		}
		
		public function activate():void
		{
			if (_playButton)
			{
				_playButton.visible = true;
				_playButton.touchable = true;
			}
			
			if (_stopButton)
			{
				_stopButton.visible = true;
				_stopButton.touchable = true;
			}
			
			if (_releaseButton)
			{
				_releaseButton.visible = true;
				_releaseButton.touchable = true;
			}
		}
		
		public function deactivate():void
		{
			if (_playButton)
			{
				_playButton.visible = false;
			}
			
			if (_stopButton)
			{
				_stopButton.visible = false;
			}
			
			if (_releaseButton)
			{
				_releaseButton.visible = false;
			}
		}
		
		public override function dispose():void
		{
			if (_playButton)
			{
				_playButton.dispose();
			}
			_playButton = null;

			if (_stopButton)
			{
				_stopButton.dispose();
			}
			_stopButton = null;
			
			if (_releaseButton)
			{
				_releaseButton.dispose();
			}
			_releaseButton = null;
			
			super.dispose();
		}
		
		private function onClickPlayButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_playButton, TouchPhase.ENDED);
			
			if (action)
			{
				if (_onClickPlayButton)
				{
					_onClickPlayButton();
				}
			}
		}
		
		private function onClickStopButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_stopButton, TouchPhase.ENDED);
			
			if (action)
			{
				if (_onClickStopButton)
				{
					_onClickStopButton();
				}
			}
		}
		
		private function onClickReleaseButton(event:TouchEvent):void
		{			
			var action:Touch = event.getTouch(_releaseButton, TouchPhase.ENDED);
			
			if (action)
			{
				if (_onClickReleaseButton)
				{
					_onClickReleaseButton();
				}
			}
		}
	}
}