package mcm {
	
	import flash.display.MovieClip;
	import Shared.AS3.*;
    import scaleform.gfx.Extensions;
    import scaleform.gfx.TextFieldEx;
	
	public class ConfigListEntry extends Shared.AS3.BSScrollingListEntry {
		

		
		public function ConfigListEntry() {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
	}
	
}
