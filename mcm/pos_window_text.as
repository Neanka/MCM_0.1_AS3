package mcm {
	
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class pos_window_text extends BSUIComponent {

		public var tf_x: TextField;
		public var tf_y: TextField;
		public var tf_scalex: TextField;
		public var tf_scaley: TextField;
		public var tf_rotation: TextField;
		public var tf_alpha: TextField;
		public var bg: BSUIComponent;
		
		public function pos_window_text() {
			bg.bShowBrackets = true;
			bg.BracketStyle = "vertical";
			bg.bUseShadedBackground = true;
		}
	}
	
}
