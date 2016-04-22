package com.bamkie.filelist;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

public class ShowFileList implements FREFunction {

	private final String SPRITE_SHEET = "SpriteSheet";
	private final String SPRITE = "Sprite";
	
	private FREContext _context;
	
	private String tag = "ShowFileList";
	
	public FREObject call(FREContext context, FREObject[] objects)
	{
		
Log.d(tag, "call");
		
		if (objects == null || objects.length <= 1)
		{
			return null;
		}
			
		String type = new String();
		String[] items = new String[objects.length - 1];
		
		for (int i = 0; i < objects.length; i++)
		{
			try
			{
				if (i != 0)
				{
					items[i] = objects[i].getAsString();
				}
				else
				{
					type = objects[i].getAsString();
				}
			}
			catch (IllegalStateException e)
			{
				e.printStackTrace();
			} 
			catch (FRETypeMismatchException e) 
			{
				e.printStackTrace();
			} 
			catch (FREInvalidObjectException e) 
			{
				e.printStackTrace();
			} 
			catch (FREWrongThreadException e) 
			{
				e.printStackTrace();
			}
		}
		
Log.d(tag, "objects saved");
		
		_context = context;	
		
		AlertDialog.Builder builder = new AlertDialog.Builder(_context.getActivity());
				
Log.d(tag, "builder");
		
		if (type == SPRITE_SHEET)
		{
			builder.setTitle("Select Sprite Sheet");
			builder.setItems(items, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int item) {
					
					_context.dispatchStatusEventAsync(SPRITE_SHEET, String.valueOf(item));
					dialog.dismiss();
					_context.dispose();
				}
			});
		}
		else if (type == SPRITE)
		{
			builder.setTitle("Select Sprite");
			builder.setItems(items, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int item) {
					
					_context.dispatchStatusEventAsync(SPRITE, String.valueOf(item));
					dialog.dismiss();
					_context.dispose();
				}
			});
		}
		
Log.d(tag, "set AlertDialog");
		
		builder.show();
		
Log.d(tag, "show");
		
		return null;
	}
	
}
