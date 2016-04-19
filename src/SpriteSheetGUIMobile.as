package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="1280", height="720", frameRate="60", backgroundColor="#e6e6e6")] // Light gray
	
	public class SpriteSheetGUIMobile extends Sprite
	{
		private var _main:Starling;
		
		public function SpriteSheetGUIMobile()
		{
			super();
			
			_main = new Starling(Main, stage);
			_main.start();
			_main.showStats = true;
		}
	}
}