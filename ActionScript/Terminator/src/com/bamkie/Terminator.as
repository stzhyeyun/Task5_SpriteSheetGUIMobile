package com.bamkie
{
	import flash.external.ExtensionContext;
	
	public class Terminator
	{
		private var _context:ExtensionContext;
		
		public function Terminator()
		{
			try
			{
				if(!_context)
				{
					_context = ExtensionContext.createExtensionContext("com.bamkie.Terminator", null);
				}
			}
			catch (e:Error)
			{
				trace(e.message);	
			}
		}
		
		public function alert():void
		{
			_context.call("alert");
		}
		
		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
			}
		}
	}
}