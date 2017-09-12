package mcm {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import Shared.GlobalFunc;
	
	
	public class Option_pos extends MovieClip {
		
		public static const VALUE_CHANGE:String = "mcmOption_pos::VALUE_CHANGE";
		public var _clip: String;
		public var _x: Number;
		public var _y: Number;
		public var _scalex: Number;
		public var _scaley: Number;
		public var _rotation: Number;
		public var _alpha: Number;
		public var textArea: TextField;		
		
		public function Option_pos() {
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textArea, "shrink");
		}
		
		public function set value(_arg_1:uint)
		{
			this.RefreshText();
		}
		
		public function RefreshText():void 
		{
			var astr: String = "";
			if (_x != int.MAX_VALUE) 
			{
				astr += "x: " + _x + "   ";
			}
			if (_y != int.MAX_VALUE) 
			{
				astr += "y: " + _y + "   ";
			}
			if (_scalex != int.MAX_VALUE) 
			{
				astr += "scaleX: " + _scalex + "   ";
			}
			if (_scaley != int.MAX_VALUE) 
			{
				astr += "scaleY: " + _scaley + "   ";
			}
			if (_rotation != int.MAX_VALUE) 
			{
				astr += "rot: " + _rotation + "   ";
			}
			if (_alpha != int.MAX_VALUE) 
			{
				astr += "alpha: " + _alpha + "   ";
			}
			GlobalFunc.SetText(textArea, astr, false);
			textArea.x = (textArea.textWidth < 175) ? -330 - (175 - textArea.textWidth) / 2: -330;
		}
	}
	
}
