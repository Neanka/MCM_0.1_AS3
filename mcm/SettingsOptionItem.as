// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//SettingsOptionItem

package mcm
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class SettingsOptionItem extends BSScrollingListEntry
	{
		
		public static const VALUE_CHANGE:String = "mcmSettingsOptionItem::value_change";
		public static const BUTTON_PRESSED:String = "mcmSettingsOptionItem::button_pressed";
		public static const MOVIETYPE_SCROLLBAR:int = 0;
		public static const MOVIETYPE_STEPPER:int = 1;
		public static const MOVIETYPE_SWITCHER:int = 2;
		public static const MOVIETYPE_SECTION:int = 3;
		public static const MOVIETYPE_EMPTY_LINE:int = 4;
		public static const MOVIETYPE_DROPDOWN:int = 5;
		public static const MOVIETYPE_TEXT:int = 6;
		public static const MOVIETYPE_BUTTON:int = 7;
		public static const MOVIETYPE_KEYINPUT:int = 8;
		public static const MOVIETYPE_IMAGE:int = 9;
		public static const MOVIETYPE_HOTKEY:int = 10;
		public static const MOVIETYPE_DD_FILES:int = 11;
		
		private var OptionItem:MovieClip;
		private var uiMovieType:uint;
		private var uiID:uint;
		private var bHUDColorUpdate:Boolean;
		private var bPipboyColorUpdate:Boolean;
		private var bDifficultyUpdate:Boolean;
		
		public function SettingsOptionItem()
		{
			this.uiID = uint.MAX_VALUE;
			this.bHUDColorUpdate = false;
			this.bPipboyColorUpdate = false;
			addEventListener(mcm.Option_Switcher.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_OptionStepper.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_Scrollbar.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_DropDown.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_ButtonMapping.VALUE_CHANGE, this.onValueChange);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField, "shrink");
		}
		
		public function get movieType():uint
		{
			return (this.uiMovieType);
		}
		
		public function set movieType(_arg_1:uint)
		{
			this.uiMovieType = _arg_1;
			if (this.OptionItem != null)
			{
				removeChild(this.OptionItem);
				this.OptionItem = null;
			}
			;
			this.textField.x = 20;
			//this.height = 28;
			switch (this.uiMovieType)
			{
			case MOVIETYPE_SCROLLBAR: 
				this.OptionItem = new mcm.Option_Scrollbar();
				break;
			case MOVIETYPE_STEPPER: 
				this.OptionItem = new mcm.Option_OptionStepper();
				break;
			case MOVIETYPE_SWITCHER: 
				this.OptionItem = new mcm.Option_Switcher();
				break;
			case MOVIETYPE_SECTION: 
				this.OptionItem = new mcm.Option_Section();
				this.textField.x = 5;
				break;
			case MOVIETYPE_DROPDOWN: 
			case MOVIETYPE_DD_FILES: 
				this.OptionItem = new mcm.Option_DropDown();
				break;
			case MOVIETYPE_TEXT: 
				this.OptionItem = new mcm.Option_Text();
				break;
			case MOVIETYPE_KEYINPUT: 
				this.OptionItem = new mcm.Option_ButtonMapping();
				break;
			case MOVIETYPE_HOTKEY: 
				this.OptionItem = new mcm.Option_ButtonMapping();
				break;
			default: 
				this.OptionItem = new MovieClip();
				break;
			}
			;
			addChild(this.OptionItem);
			this.OptionItem.x = 550; // orig 210
			this.OptionItem.y = -1;
		}
		
		public function get ID():uint
		{
			return (this.uiID);
		}
		
		public function set ID(_arg_1:uint)
		{
			this.uiID = _arg_1;
		}
		
		public function get hudColorUpdate():Boolean
		{
			return (this.bHUDColorUpdate);
		}
		
		public function set hudColorUpdate(_arg_1:Boolean)
		{
			this.bHUDColorUpdate = _arg_1;
		}
		
		public function get pipboyColorUpdate():Boolean
		{
			return (this.bPipboyColorUpdate);
		}
		
		public function set pipboyColorUpdate(_arg_1:Boolean)
		{
			this.bPipboyColorUpdate = _arg_1;
		}
		
		public function get difficultyUpdate():Boolean
		{
			return (this.bDifficultyUpdate);
		}
		
		public function set difficultyUpdate(_arg_1:Boolean):void
		{
			this.bDifficultyUpdate = _arg_1;
		}
		
		public function get value():Number
		{
			var _local_1:Number;
			switch (this.uiMovieType)
			{
			case MOVIETYPE_SCROLLBAR: 
				_local_1 = (this.OptionItem as mcm.Option_Scrollbar).value;
				break;
			case MOVIETYPE_STEPPER: 
				_local_1 = (this.OptionItem as mcm.Option_OptionStepper).index;
				break;
			case MOVIETYPE_SWITCHER: 
				_local_1 = (((this.OptionItem as mcm.Option_Switcher).checked) ? 1 : 0);
				break;
			case MOVIETYPE_DROPDOWN: 
			case MOVIETYPE_DD_FILES: 
				_local_1 = (this.OptionItem as mcm.Option_DropDown).index;
				break;
			default: 
				_local_1 = 0;
				break;
			}
			;
			return (_local_1);
		}
		
		public function set value(_arg_1:Number)
		{
			switch (this.uiMovieType)
			{
			case MOVIETYPE_SCROLLBAR: 
				(this.OptionItem as mcm.Option_Scrollbar).value = _arg_1;
				return;
			case MOVIETYPE_STEPPER: 
				(this.OptionItem as mcm.Option_OptionStepper).index = _arg_1;
				return;
			case MOVIETYPE_SWITCHER: 
				(this.OptionItem as mcm.Option_Switcher).checked = (((_arg_1 == 1)) ? true : false);
				return;
			case MOVIETYPE_DROPDOWN: 
			case MOVIETYPE_DD_FILES: 
				(this.OptionItem as mcm.Option_DropDown).index = _arg_1;
				return;
			default:
				
				break;
			}
			;
		}
		
		public function SetOptionKeyInput(_arg_1:Array, arg2:int, arg3:String, arg4:String)
		//	public function SetOptionKeyInput(_arg_1:Array, arg2:int)
		{
			(this.OptionItem as mcm.Option_ButtonMapping).type = this.uiMovieType;
			if (this.uiMovieType == MOVIETYPE_KEYINPUT)
			{
				(this.OptionItem as mcm.Option_ButtonMapping).keys = _arg_1;
				(this.OptionItem as mcm.Option_ButtonMapping).allowModifierKeys = arg2;
			}
			;
			if (this.uiMovieType == MOVIETYPE_HOTKEY)
			{
				(this.OptionItem as mcm.Option_ButtonMapping).keys = _arg_1;
				(this.OptionItem as mcm.Option_ButtonMapping).allowModifierKeys = arg2;
				(this.OptionItem as mcm.Option_ButtonMapping).modName = arg3;
				(this.OptionItem as mcm.Option_ButtonMapping).id = arg4;
					//(this.OptionItem as mcm.Option_ButtonMapping).RefreshText();
			}
			;
		}
		
		public function SetOptionStepperOptions(_arg_1:Array)
		{
			if (this.uiMovieType == MOVIETYPE_STEPPER)
			{
				(this.OptionItem as mcm.Option_OptionStepper).options = _arg_1;
			}
			else if (this.uiMovieType == MOVIETYPE_DROPDOWN)
			{
				(this.OptionItem as mcm.Option_DropDown).options = _arg_1;
			}
			else if (this.uiMovieType == MOVIETYPE_DD_FILES)
			{
				(this.OptionItem as mcm.Option_DropDown).options = _arg_1;
			}
		}
		
		public function SetOptionSlider(minvalue:Number, maxvalue:Number, step:Number)
		{
			if (this.uiMovieType == MOVIETYPE_SCROLLBAR)
			{
				(this.OptionItem as mcm.Option_Scrollbar).MinValue = minvalue;
				(this.OptionItem as mcm.Option_Scrollbar).MaxValue = maxvalue;
				(this.OptionItem as mcm.Option_Scrollbar).StepSize = step;
			}
			;
		}
		
		override public function SetEntryText(_arg_1:Object, _arg_2:String)
		{
			var _local_3:ColorTransform;
			//TextFieldEx.setTextAutoSize(textField, "fit");
			super.SetEntryText(_arg_1, _arg_2);
			switch (this.uiMovieType)
			{
			case MOVIETYPE_SECTION: 
				this.border.alpha = 0;
				this.textField.textColor = 0xFFFFFF;
				this.repositionSectionBar();
				return;
				break;
			case MOVIETYPE_EMPTY_LINE: 
				this.border.alpha = 0;
				GlobalFunc.SetText(this.textField, " ", true);
				if (_arg_1.hasOwnProperty("numLines")) 
				{
					this.border.height = _arg_1.numLines*ORIG_BORDER_HEIGHT;
				}
				else if (_arg_1.hasOwnProperty("height")) 
				{
					this.border.height = _arg_1.height;
				}
				else
				{
					this.border.height = ORIG_BORDER_HEIGHT
				}
				return;
				break;
			case MOVIETYPE_TEXT: 
				this.border.alpha = 0;
				GlobalFunc.SetText(this.textField, " ", true);
				if (_arg_1.align)
				{
					var tf:TextFormat = (this.OptionItem as mcm.Option_Text).textArea.getTextFormat();
					tf.align = _arg_1.align;
					(this.OptionItem as mcm.Option_Text).textArea.defaultTextFormat = tf;
				}
				if (_arg_1.html)
				{
					GlobalFunc.SetText((this.OptionItem as mcm.Option_Text).textArea, _arg_1.text, true);
				}
				else
				{
					GlobalFunc.SetText((this.OptionItem as mcm.Option_Text).textArea, _arg_1.text, false);
				}
				(this.OptionItem as mcm.Option_Text).textArea.height = (this.OptionItem as mcm.Option_Text).textArea.textHeight + 4;
				
				return;
				break;
			case MOVIETYPE_IMAGE: 
				this.border.alpha = 0;
				GlobalFunc.SetText(this.textField, " ", true);
				this.OptionItem.x = 0;
				try
				{
					var tempMc:MovieClip = MCM_Menu.instance.getMcFromLib(_arg_1.libName, _arg_1.className);
					if (tempMc.width > 690)
					{
						tempMc.width = 690;
						tempMc.scaleY = tempMc.scaleX;
					}
					if (tempMc.height > 400)
					{
						tempMc.height = 400;
						tempMc.scaleX = tempMc.scaleY;
					}
					if (_arg_1.width)
					{
						tempMc.x = (690 - _arg_1.width) / 2 + 10;
					}
					else
					{
						tempMc.x = (690 - tempMc.width) / 2 + 10;
					}
					this.OptionItem.addChild(tempMc);
					if (_arg_1.height)
					{
						this.border.height = _arg_1.height;
					}
					else
					{
						this.border.height = ORIG_BORDER_HEIGHT;
					}
				}
				catch (err:Error)
				{
					GlobalFunc.SetText(this.textField, "[Error]: Can't load \"" + _arg_1.className + "\" image from \"" + _arg_1.libName + "\" library!", true);
				}
				
				return;
				break;
			default: 
			}
			if (this.border != null)
			{
				this.border.alpha = ((this.selected) ? GlobalFunc.SELECTED_RECT_ALPHA : 0);
			}
			;
			if (this.textField != null)
			{
				this.textField.textColor = ((this.selected) ? 0 : 0xFFFFFF);
			}
			;
			if (this.OptionItem != null)
			{
				_local_3 = this.OptionItem.transform.colorTransform;
				_local_3.redOffset = ((this.selected) ? -255 : 0);
				_local_3.greenOffset = ((this.selected) ? -255 : 0);
				_local_3.blueOffset = ((this.selected) ? -255 : 0);
				this.OptionItem.transform.colorTransform = _local_3;
			}
			;
		
		}
		
		private function repositionSectionBar()
		{
			var _local_1:TextLineMetrics = this.textField.getLineMetrics(0);
			this.OptionItem.graphics.lineStyle(3, 0xFFFFFF, 1, true, LineScaleMode.NONE);
			this.OptionItem.graphics.moveTo(_local_1.width - 535, 14);
			this.OptionItem.graphics.lineTo(150, 14);
			this.OptionItem.graphics.lineTo(150, 20);
		}
		
		public function onItemPressed()
		{
			if (this.OptionItem != null)
			{
				switch (this.uiMovieType)
				{
				case MOVIETYPE_STEPPER: 
					(this.OptionItem as mcm.Option_OptionStepper).onItemPressed();
					return;
				case MOVIETYPE_SWITCHER: 
					(this.OptionItem as mcm.Option_Switcher).onItemPressed();
					return;
				case MOVIETYPE_DROPDOWN: 
				case MOVIETYPE_DD_FILES: 
					(this.OptionItem as mcm.Option_DropDown).onItemPressed();
					return;
				case MOVIETYPE_BUTTON: 
					dispatchEvent(new Event(BUTTON_PRESSED, true, true));
					return;
				case MOVIETYPE_KEYINPUT: 
					(this.OptionItem as mcm.Option_ButtonMapping).onItemPressed();
					return;
				case MOVIETYPE_HOTKEY: 
					(this.OptionItem as mcm.Option_ButtonMapping).onItemPressed();
					return;
				}
				;
			}
			;
		}
		
		public function HandleKeyboardInput(_arg_1:KeyboardEvent)
		{
			if (this.OptionItem != null)
			{
				switch (this.uiMovieType)
				{
				case MOVIETYPE_SCROLLBAR: 
					(this.OptionItem as mcm.Option_Scrollbar).HandleKeyboardInput(_arg_1);
					return;
				case MOVIETYPE_STEPPER: 
					(this.OptionItem as mcm.Option_OptionStepper).HandleKeyboardInput(_arg_1);
					return;
				case MOVIETYPE_SWITCHER: 
					(this.OptionItem as mcm.Option_Switcher).HandleKeyboardInput(_arg_1);
					return;
				case MOVIETYPE_DROPDOWN: 
					(this.OptionItem as mcm.Option_DropDown).HandleKeyboardInput(_arg_1);
					return;
				}
				;
			}
			;
		}
		
		private function onValueChange(_arg_1:Event)
		{
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
	
	}
}//package 

