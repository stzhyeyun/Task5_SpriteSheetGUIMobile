package com.bamkie.terminator;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import android.app.AlertDialog;
import android.content.DialogInterface;

public class Alert implements FREFunction {

	private FREContext _context;
	
	public FREObject call(FREContext context, FREObject[] args)
	{
		_context = context;
		
		AlertDialog.Builder builder = new AlertDialog.Builder(_context.getActivity());
		
		builder.setMessage("Teminate Program?");
		builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {

				dialog.dismiss();
				_context.getActivity().onBackPressed();
				_context.dispose();
			}
		});
		builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				
				dialog.dismiss();				
			}
		});
		
		builder.show();
		
		return null;
	}
	
}
