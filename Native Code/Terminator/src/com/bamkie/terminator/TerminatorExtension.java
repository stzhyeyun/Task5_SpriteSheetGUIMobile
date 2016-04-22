package com.bamkie.terminator;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class TerminatorExtension implements FREExtension {

	@Override
	public FREContext createContext(String arg0)
	{
		return new TerminatorContext();
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
