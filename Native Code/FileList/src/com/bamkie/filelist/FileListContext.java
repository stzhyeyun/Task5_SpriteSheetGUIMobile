package com.bamkie.filelist;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class FileListContext extends FREContext {
	
	@Override
	public void dispose()
	{
		
	}
	
	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("showFileList", new ShowFileList());
		
		return functions;
	}

}
