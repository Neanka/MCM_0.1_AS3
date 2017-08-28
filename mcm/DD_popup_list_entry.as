package mcm
{
	
	import flash.display.MovieClip;
	import Shared.AS3.*;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class DD_popup_list_entry extends Shared.AS3.BSScrollingListEntry
	{
		
		public function DD_popup_list_entry()
		{
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
	}

}
