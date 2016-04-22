package com.bamkie.filelist;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class FileListExtension implements FREExtension {

	@Override
	public FREContext createContext(String arg0)
	{
		return new FileListContext();
	}
	
	@Override
	public void dispose()
	{
		
	}
	
	@Override
	public void initialize()
	{
		
	}
	
}
