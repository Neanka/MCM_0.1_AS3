package mcm
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import flash.geom.ColorTransform;
	import Shared.GlobalFunc;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.LineScaleMode;
	import flash.text.TextLineMetrics;

	public class SettingsOptionItem extends BSScrollingListEntry
	{

		public static const VALUE_CHANGE: String = "mcmSettingsOptionItem::value_change";
		public static const MOVIETYPE_SCROLLBAR: int = 0;
		public static const MOVIETYPE_STEPPER: int = 1;
		public static const MOVIETYPE_CHECKBOX: int = 2;
		public static const MOVIETYPE_SECTION: int = 3;
		public static const MOVIETYPE_EMPTY: int = 4;
		public static const MOVIETYPE_DROPDOWN: int = 5;
		public static const MOVIETYPE_TEXT: int = 6;
		public static const MOVIETYPE_BUTTON: int = 7;
		public static const MOVIETYPE_KEYMAP: int = 8;
		public static const MOVIETYPE_TEXTINPUT: int = 9;
		public static const MOVIETYPE_MENU: int = 10;
		public static const MOVIETYPE_COLORPICKER: int = 11;

		private var OptionItem: MovieClip;
		private var uiMovieType: uint;
		private var uiID: uint;

		public function SettingsOptionItem()
		{
			this.uiID = uint.MAX_VALUE;
			addEventListener(mcm.Option_Checkbox.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_OptionStepper.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_Scrollbar.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_DropDown.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.Option_Keymap.VALUE_CHANGE, this.onValueChange);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField, "shrink");
		}

		public function get movieType(): uint
		{
			return (this.uiMovieType);
		}

		public function set movieType(_arg_1: uint)
		{
			this.uiMovieType = _arg_1;
			if (this.OptionItem != null)
			{
				removeChild(this.OptionItem);
				this.OptionItem = null;
			};
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
				case MOVIETYPE_CHECKBOX:
					this.OptionItem = new mcm.Option_Checkbox();
					break;
				case MOVIETYPE_SECTION:
					this.OptionItem = new mcm.Option_Section();
					this.textField.x = 5;
					break;
				case MOVIETYPE_EMPTY:
					this.OptionItem = new mcm.Option_Empty();
					break;
				case MOVIETYPE_DROPDOWN:
					this.OptionItem = new mcm.Option_DropDown();
					break;
				case MOVIETYPE_TEXT:
					this.OptionItem = new mcm.Option_Text();
					break;
				case MOVIETYPE_TEXTINPUT:
					this.OptionItem = new mcm.Option_TextInput();
					break;
				case MOVIETYPE_MENU:
					this.OptionItem = new mcm.Option_Menu();
					break;
				case MOVIETYPE_BUTTON:
					this.OptionItem = new mcm.Option_Button();
					break;
				case MOVIETYPE_KEYMAP:
					this.OptionItem = new mcm.Option_Keymap();
					break;
				case MOVIETYPE_COLORPICKER:
					this.OptionItem = new mcm.Option_ColorPicker();
					break;
				default:
					this.OptionItem = new MovieClip();
					break;
			};
			addChild(this.OptionItem);
			this.OptionItem.x = 550; // orig 210
			this.OptionItem.y = -1;
		}

		public function get ID(): uint
		{
			return (this.uiID);
		}

		public function set ID(_arg_1: uint)
		{
			this.uiID = _arg_1;
		}

		public function get value(): Number
		{
			var _local_1: Number;
			switch (this.uiMovieType)
			{
				case MOVIETYPE_SCROLLBAR:
					_local_1 = (this.OptionItem as mcm.Option_Scrollbar).value;
					break;
				case MOVIETYPE_STEPPER:
					_local_1 = (this.OptionItem as mcm.Option_OptionStepper).index;
					break;
				case MOVIETYPE_CHECKBOX:
					_local_1 = (((this.OptionItem as mcm.Option_Checkbox).checked) ? 1 : 0);
					break;
				case MOVIETYPE_DROPDOWN:
					_local_1 = (this.OptionItem as mcm.Option_DropDown).index;
					break;
				default:
					_local_1 = 0;
					break;
			};
			return (_local_1);
		}

		public function set value(_arg_1: Number)
		{
			switch (this.uiMovieType)
			{
				case MOVIETYPE_SCROLLBAR:
					(this.OptionItem as mcm.Option_Scrollbar).value = _arg_1;
					return;
				case MOVIETYPE_STEPPER:
					(this.OptionItem as mcm.Option_OptionStepper).index = _arg_1;
					return;
				case MOVIETYPE_CHECKBOX:
					(this.OptionItem as mcm.Option_Checkbox).checked = (((_arg_1 == 1)) ? true : false);
					return;
				case MOVIETYPE_DROPDOWN:
					(this.OptionItem as mcm.Option_DropDown).index = _arg_1;
					return;
				default:
					break;
			};
		}

		public function SetOptionStepperOptions(_arg_1: Array)
		{
			if (this.uiMovieType == MOVIETYPE_STEPPER)
			{
				(this.OptionItem as mcm.Option_OptionStepper).options = _arg_1;
			}
			else if (this.uiMovieType == MOVIETYPE_DROPDOWN)
			{
				(this.OptionItem as mcm.Option_DropDown).options = _arg_1;
			};
		}

		public function SetOptionSlider(minvalue: Number, maxvalue: Number, step: Number)
		{
			if (this.uiMovieType == MOVIETYPE_SCROLLBAR)
			{
				(this.OptionItem as mcm.Option_Scrollbar).MinValue = minvalue;
				(this.OptionItem as mcm.Option_Scrollbar).MaxValue = maxvalue;
				(this.OptionItem as mcm.Option_Scrollbar).StepSize = step;
			};
		}

		override public function SetEntryText(_arg_1: Object, _arg_2: String)
		{
			var _local_3: ColorTransform;
			TextFieldEx.setTextAutoSize(textField, "fit");
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
					return;
					break;
				case MOVIETYPE_TEXT:
					this.border.alpha = 0;
					GlobalFunc.SetText(this.textField, " ", true);
					(this.OptionItem as mcm.Option_Text).textArea.text = _arg_1.text;
					(this.OptionItem as mcm.Option_Text).textArea.height = (this.OptionItem as mcm.Option_Text).textArea.textHeight + 4;
					return;
					break;
				default:
			}
			if (this.border != null)
			{
				this.border.alpha = ((this.selected) ? GlobalFunc.SELECTED_RECT_ALPHA : 0);
			};
			if (this.textField != null)
			{
				this.textField.textColor = ((this.selected) ? 0 : 0xFFFFFF);
			};
			if (this.OptionItem != null)
			{
				_local_3 = this.OptionItem.transform.colorTransform;
				_local_3.redOffset = ((this.selected) ? -255 : 0);
				_local_3.greenOffset = ((this.selected) ? -255 : 0);
				_local_3.blueOffset = ((this.selected) ? -255 : 0);
				this.OptionItem.transform.colorTransform = _local_3;
			};

		}

		private function repositionSectionBar()
		{
			var _local_1: TextLineMetrics = this.textField.getLineMetrics(0);
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
					case MOVIETYPE_CHECKBOX:
						(this.OptionItem as mcm.Option_Checkbox).onItemPressed();
						return;
					case MOVIETYPE_DROPDOWN:
						(this.OptionItem as mcm.Option_DropDown).onItemPressed();
						return;
				};
			};
		}

		public function HandleKeyboardInput(_arg_1: KeyboardEvent)
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
					case MOVIETYPE_CHECKBOX:
						(this.OptionItem as mcm.Option_Checkbox).HandleKeyboardInput(_arg_1);
						return;
					case MOVIETYPE_DROPDOWN:
						(this.OptionItem as mcm.Option_DropDown).HandleKeyboardInput(_arg_1);
						return;
				};
			};
		}

		private function onValueChange(_arg_1: Event)
		{
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
	}
}