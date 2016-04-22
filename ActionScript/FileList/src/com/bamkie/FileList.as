package com.bamkie
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class FileList
	{
		private var _context:ExtensionContext;		
		private var _onSelectItem:Function;
		
		public function FileList(onSelectItem:Function)
		{
			try
			{
				if(!_context)
				{
					_context = ExtensionContext.createExtensionContext("com.bamkie.FileList", null);
				}
			}
			catch (e:Error)
			{
				trace(e.message);	
			}
			
			_context.addEventListener(StatusEvent.STATUS, onSelectItem);
			_onSelectItem = onSelectItem;
		}
		
		public function showFileList(objects:Array):void
		{
			_context.call("showFileList", objects);
		}
		
		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
			}
		}
		
		private function onSelectItem(event:StatusEvent):void
		{
			_onSelectItem(event.code, event.type);
		}
	}
}