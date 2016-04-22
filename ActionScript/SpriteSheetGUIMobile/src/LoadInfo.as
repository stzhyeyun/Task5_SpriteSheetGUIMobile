package 
{
	import flash.display.BitmapData;
	import flash.filesystem.File;

	public class LoadInfo
	{
		private var _type:String;
		private var _path:File;
		private var _name:String;
		private var _spriteSheetBitmapData:BitmapData;
				
		public function LoadInfo(type:String, path:File, name:String)
		{
			_type = type;
			_path = path;
			_name = name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get path():File
		{
			return _path;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get spriteSheetBitmapData():BitmapData
		{
			return _spriteSheetBitmapData;
		}
		
		public function set spriteSheetBitmapData(bitmapData:BitmapData):void
		{
			_spriteSheetBitmapData = bitmapData;
		}
		
		public function dispose():void
		{
			_type = null;
			_path = null;
			_name = null;
		}
	}
}