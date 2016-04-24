package com.bamkie.filelist;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import android.app.AlertDialog;
import android.content.DialogInterface;

public class ShowFileList implements FREFunction {

	private final String SPRITE_SHEET = "SpriteSheet";
	private final String SPRITE = "Sprite";
	
	private FREContext _context;
	
	public FREObject call(FREContext context, FREObject[] objects)
	{		
		if (objects == null)
		{
			return null;
		}
		
		FREArray data = (FREArray)objects[0];
		long length = 0;
		
		try
		{
			length = data.getLength();
		}
		catch (FREInvalidObjectException e1)
		{
			e1.printStackTrace();
		}
		catch (FREWrongThreadException e1) 
		{
			e1.printStackTrace();
		}
				
		String type = new String();
		final String[] items = new String[(int)length - 1];
		
		for (int i = 0; i < (int)length; i++)
		{
			try
			{
				if (i != 0)
				{
					items[i - 1] = data.getObjectAt(i).getAsString();
				}
				else
				{
					type = data.getObjectAt(i).getAsString();
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
		
		_context = context;	
		
		AlertDialog.Builder builder = new AlertDialog.Builder(_context.getActivity());
						
		if (type.compareTo(SPRITE_SHEET) == 0)
		{
			builder.setTitle("Select Sprite Sheet");
			builder.setItems(items, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int item) {
					
					_context.dispatchStatusEventAsync(SPRITE_SHEET, items[item]);
					dialog.dismiss();
					_context.dispose();
				}
			});
		}
		else if (type.compareTo(SPRITE) == 0)
		{
			builder.setTitle("Select Sprite");
			builder.setItems(items, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int item) {
					
					_context.dispatchStatusEventAsync(SPRITE, items[item]);
					dialog.dismiss();
					_context.dispose();
				}
			});
		}

		builder.show();
		
		return null;
	}
	
}
