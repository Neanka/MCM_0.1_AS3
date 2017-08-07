package mcm
{
	import Shared.AS3.BSUIComponent;
	
	public class dd_popup_bg extends BSUIComponent
	{
		
		public function dd_popup_bg()
		{
			this.bShowBrackets = true;
			ShadedBackgroundMethod = "Shader";
			ShadedBackgroundType = "normal";
			bUseShadedBackground = true;
			this.BracketStyle = "vertical";
		}
	}
}