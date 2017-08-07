package mcm
{

	import flash.display.MovieClip;
	import Shared.AS3.*;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;

	public class UniversalListEntry extends Shared.AS3.BSScrollingListEntry
	{

		public function UniversalListEntry()
		{
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
	}

}