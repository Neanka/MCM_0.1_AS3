package mcm
{
	
	import Shared.GlobalFunc;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Option_textinput extends MovieClip
	{
		
		public static const VALUE_CHANGE:String = "mcmOption_textinput::VALUE_CHANGE";
		public static const START_INPUT:String = "mcmOption_textinput::START_INPUT";
		public static const END_INPUT:String = "mcmOption_textinput::END_INPUT";
		
		public static const TYPE_INT:int = 0;
		public static const TYPE_FLOAT:int = 1;
		public static const TYPE_STRING:int = 2;
		
		public var textArea:TextField;
		public var oldText:String = "";
		private var _valueString:String;
		private var _value:Number;
		private var _type:int;
		private var _precision:int = 6;
		
		public function Option_textinput()
		{
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textArea, "shrink");
		}
		
		public function set value(_arg_1:Number)
		{
			_value = _arg_1;
			this.RefreshText();
		}
		
		public function set valueString(_arg_1:String)
		{
			_valueString = _arg_1
			this.RefreshText();
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function get valueString():String
		{
			return _valueString;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(_arg_1:int):void
		{
			switch (_arg_1)
			{
			case TYPE_FLOAT: 
				this.textArea.restrict = "0-9.";
				break;
			case TYPE_INT: 
				this.textArea.restrict = "0-9";
				break;
			case TYPE_STRING: 
				this.textArea.restrict = null;
				break;
			default: 
			}
			_type = _arg_1;
		}
		
		public function get precision():int 
		{
			return _precision;
		}
		
		public function set precision(value:int):void 
		{
			_precision = value;
		}
		
		public function RefreshText():void
		{
			switch (type)
			{
			case TYPE_FLOAT: 
				GlobalFunc.SetText(textArea, MCM_Menu.RoundDecimal(value,_precision), false);
				break;
			case TYPE_INT: 
				GlobalFunc.SetText(textArea, String(int(value)), false);
				break;
			case TYPE_STRING: 
				GlobalFunc.SetText(textArea, valueString, false);
				break;
			default: 
			}
			tunePosition();
		}
		
		private function tunePosition():void
		{
			textArea.x = (textArea.textWidth < 175) ? -330 - (175 - textArea.textWidth) / 2 : -330;
		}
		
		public function onItemPressed()
		{
			MCM_Menu.iMode = MCM_Menu.MCM_TEXTINPUT_MODE;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = true;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = true;
			dispatchEvent(new Event(START_INPUT, true, true));
			StartEditText();
		}
		
		public function ProcessKeyEvent(keyCode:int, isDown:Boolean):void
		{
			if (keyCode == Keyboard.ESCAPE && !isDown)
			{
				onEscPressed();
				return;
			}
			if (keyCode == Keyboard.TAB && !isDown)
			{
				onTabPressed();
				return;
			}
			if ((keyCode == Keyboard.ENTER || keyCode == Keyboard.NUMPAD_ENTER) && !isDown)
			{
				onEnterPressed();
				return;
			}
		
		}
		
		public function onEscPressed():void
		{
			textArea.text = oldText;
			tunePosition();
			EndEditText();
			dispatchEvent(new Event(END_INPUT, true, true));
			TweenMax.delayedCall(0.02, DelayTimerAction);
		}
		
		public function onTabPressed():void
		{
			textArea.text = "";
		}
		
		public function onEnterPressed():void
		{
			EndEditText();
			dispatchEvent(new Event(END_INPUT, true, true));
			if (this.textArea.text != oldText)
			{
				switch (type)
				{
				case TYPE_FLOAT: 
					_value = Number(this.textArea.text);
					break;
				case TYPE_INT: 
					_value = int(this.textArea.text);
					break;
				case TYPE_STRING: 
					_valueString = this.textArea.text;
					break;
				default: 
				}
				dispatchEvent(new Event(VALUE_CHANGE, true, true));
			}
			TweenMax.delayedCall(0.02, DelayTimerAction);
		}
		
		public function StartEditText()
		{
			oldText = textArea.text;
			textArea.type = TextFieldType.INPUT;
			textArea.selectable = true;
			textArea.maxChars = 100;
			stage.focus = textArea;
			textArea.setSelection(textArea.text.length, textArea.text.length);
			textArea.addEventListener(Event.CHANGE, textChangeHandler);
			textArea.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			//textArea.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			try
			{
				MCM_Menu.instance.mcmCodeObj.AllowTextInput(true);
			}
			catch (e:Error)
			{
				trace("Failed to enable text input");
			}
		}
		
		private function textChangeHandler(e:Event):void 
		{
			tunePosition();
		}
		
		private function textInputHandler(e:TextEvent):void
		{
			var minusPos: int = this.textArea.text.indexOf("-");
			var carPos: int = this.textArea.caretIndex;
			switch (type)
			{
			case TYPE_FLOAT: 
				var dotPos: int = this.textArea.text.indexOf(".");	
				var leng: int = this.textArea.length;
				if (e.text == "." && dotPos>-1)
				{
					e.preventDefault();
				}
				if (dotPos>-1 && dotPos<leng-precision && carPos>dotPos) //
				{
					e.preventDefault();
				}
				if (e.text == "-") 
				{
					if (minusPos == -1) 
					{
						this.textArea.text = "-" + this.textArea.text;
						textArea.setSelection(carPos+1,carPos+1);
					}
					else 
					{
						this.textArea.text = this.textArea.text.slice(1);
						textArea.setSelection(carPos-1,carPos-1);
					}					
				}
				break;
			case TYPE_INT: 
				if (e.text == "-") 
				{
					if (minusPos == -1) 
					{
						this.textArea.text = "-" + this.textArea.text;
						textArea.setSelection(carPos+1,carPos+1);
					}
					else 
					{
						this.textArea.text = this.textArea.text.slice(1);
						textArea.setSelection(carPos-1,carPos-1);
					}					
				}
				break;
			default: 
			}
		}
		
		public function EndEditText()
		{
			textArea.removeEventListener(Event.CHANGE, textChangeHandler);
			textArea.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			//textArea.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			textArea.type = TextFieldType.DYNAMIC;
			textArea.setSelection(0, 0);
			textArea.selectable = false;
			textArea.maxChars = 0;
			stage.focus = MCM_Menu.instance.configPanel_mc.configList_mc;
			try
			{
				MCM_Menu.instance.mcmCodeObj.AllowTextInput(false);
			}
			catch (e:Error)
			{
				trace("Failed to disable text input");
			}
		}
		
		//private function focusOutHandler(e:FocusEvent):void 
		//{
		//	onEscPressed();
		//}
		
		private function DelayTimerAction()
		{
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = false;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = false;
			MCM_Menu.iMode = MCM_Menu.MCM_MAIN_MODE;
		}
	}

}
