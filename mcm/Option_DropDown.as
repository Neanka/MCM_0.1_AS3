package mcm
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Option_DropDown extends MovieClip
	{
		
		public static const VALUE_CHANGE:String = "mcmOption_DropDown::VALUE_CHANGE";
		
		public var textField:TextField;
		//public var LeftArrow_mc:MovieClip;
		public var RightArrow_mc:MovieClip;
		//public var LeftCatcher_mc:MovieClip;
		public var RightCatcher_mc:MovieClip;
		private var OptionArray:Array;
		private var uiSelectedIndex:uint;
		
		public function Option_DropDown()
		{
			this.uiSelectedIndex = 0;
			addEventListener(MouseEvent.CLICK, this.onClick);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textField, "shrink");
		}
		
		public function get options():Array
		{
			return (this.OptionArray);
		}
		
		public function set options(_arg_1:Array)
		{
			this.OptionArray = _arg_1;
			this.RefreshText();
		}
		
		public function get index():uint
		{
			return (this.uiSelectedIndex);
		}
		
		public function set index(_arg_1:uint)
		{
			if (this.OptionArray != null)
			{
				this.uiSelectedIndex = Math.min(_arg_1, (this.OptionArray.length - 1));
			}
			else
			{
				this.uiSelectedIndex = 0;
			}
			;
			this.RefreshText();
		}
		
		private function RefreshText()
		{
			GlobalFunc.SetText(this.textField, this.OptionArray[this.uiSelectedIndex], false);
			var _local_1:TextLineMetrics = this.textField.getLineMetrics(0);
			//this.LeftArrow_mc.x = (this.textField.x + _local_1.x);
			this.RightArrow_mc.x = (((this.textField.x + _local_1.x) + _local_1.width) + 18); // +6
			this.RightArrow_mc.rotation = 90;
			this.RightArrow_mc.y = 12;
		}
		
		private function Decrement()
		{
			this.index--;
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
		
		private function Increment()
		{
			this.index = (this.index + 1);
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
		
		public function onItemPressed()
		{
			//this.index = ((this.index + 1) % this.OptionArray.length);
			if (MCM_Menu.instance.configPanel_mc.DD_popup_mc.opened) 
			{
				MCM_Menu.instance.configPanel_mc.DD_popup_mc.Close(true);
				RefreshText();
			} 
			else 
			{
				var tempar: Array = new Array();
				for (var obj in OptionArray)
				{
					tempar.push({
						"text": OptionArray[obj]
					});
				}
				MCM_Menu.instance.configPanel_mc.DD_popup_mc.DD_popup_list_mc.entryList = tempar;
				MCM_Menu.instance.configPanel_mc.DD_popup_mc.Open(this);
				this.RightArrow_mc.rotation = 270;
				this.RightArrow_mc.x -= 12;
				this.RightArrow_mc.y = 18;
			
				MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = true;
				MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = true;
				MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = true;
				MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = true;
			}

			//dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
		
		public function HandleKeyboardInput(_arg_1:KeyboardEvent)
		{
			if ((_arg_1.keyCode == Keyboard.LEFT) && (this.index > 0))
			{
				this.Decrement();
			}
			else
			{
				if ((_arg_1.keyCode == Keyboard.RIGHT) && (this.index < (this.OptionArray.length - 1)))
				{
					this.Increment();
				}
				;
			}
			;
		}
		
		private function onClick(_arg_1:MouseEvent)
		{
			if (MCM_Menu.iMode == MCM_Menu.MCM_TEXTINPUT_MODE) 
			{
				return;
			}
			//if ((_arg_1.target == this.LeftCatcher_mc) && (this.index > 0))
			//{
			//    this.Decrement();
			//    _arg_1.stopPropagation();
			// } else
			//{
			if (_arg_1.target == this.RightCatcher_mc)// && (this.index < (this.OptionArray.length - 1)))
			{
				
				//this.Increment();
				this.onItemPressed();
				_arg_1.stopPropagation();
			}
			;
			//};
		}
	
	}
}//package 

