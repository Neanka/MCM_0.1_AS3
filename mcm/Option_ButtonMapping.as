package mcm
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public dynamic class Option_ButtonMapping extends MovieClip
	{
		
		public static const VALUE_CHANGE:String = "mcmOption_ButtonMapping::VALUE_CHANGE";
		public static const START_INPUT:String = "mcmOption_ButtonMapping::START_INPUT";
		public static const END_INPUT:String = "mcmOption_ButtonMapping::END_INPUT";
		public static const KEY_LSHIFT:int = 160;
		public static const KEY_RSHIFT:int = 161;
		public static const KEY_LCTRL:int = 162;
		public static const KEY_RCTRL:int = 163;
		public static const KEY_LALT:int = 164;
		public static const KEY_RALT:int = 165;
		
		public var _shiftpressed:Boolean = false;
		public var _ctrlpressed:Boolean = false;
		public var _altpressed:Boolean = false;
		public var _epressed:Boolean = false;
		
		public var PCKey_tf:TextField;
		public var allowModifierKeys:int = 0;
		private var DelayTimer:Timer;
		private var KeysArray:Array;
		
		public function Option_ButtonMapping()
		{
			this.DelayTimer = new Timer(300, 1);
			this.DelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, DelayTimerAction);
		}
		
		private function DelayTimerAction(e:TimerEvent)
		{
			this.DelayTimer.reset();
			stage.getChildAt(0)["Menu_mc"]["bRemapMode"] = false;
			dispatchEvent(new Event(END_INPUT, true, true));
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
		}
		
		public function onItemPressed()
		{
			stage.getChildAt(0)["Menu_mc"]["bRemapMode"] = true;
			dispatchEvent(new Event(START_INPUT, true, true));
		}
		
		public function ProcessKeyEvent(keyCode:int, isDown:Boolean):void
		{
			if (keyCode == Keyboard.ESCAPE || keyCode == Keyboard.TAB && !isDown) 
			{
				DelayTimer.start();
				return;
			}
			//MCM_Menu.instance.configPanel_mc.hint_tf.text = keytostring(keyCode);
			if (allowModifierKeys == 0)
			{
				switch (keyCode)
				{
				case Keyboard.SHIFT: 
				case KEY_LSHIFT: 
				case KEY_RSHIFT: 
					_shiftpressed = isDown;
					//MCM_Menu.instance.configPanel_mc.hint_tf.text = "SHIFT PRESSED";
					break;
				case Keyboard.ALTERNATE: 
				case KEY_LALT: 
				case KEY_RALT:
					_altpressed = isDown;
					//MCM_Menu.instance.configPanel_mc.hint_tf.text = "ALT PRESSED";
					break;
				case Keyboard.CONTROL: 
				case KEY_LCTRL: 
				case KEY_RCTRL: 
					_ctrlpressed = isDown;
					//MCM_Menu.instance.configPanel_mc.hint_tf.text = "CTRL PRESSED";
					break;
				default: 
					if (!isDown) 
					{
						var temparray: Array = new Array();
						if (_shiftpressed) 
						{
							temparray.push(Keyboard.SHIFT);
						}
						if (_ctrlpressed) 
						{
							temparray.push(Keyboard.CONTROL);
						}
						if (_altpressed) 
						{
							temparray.push(Keyboard.ALTERNATE);
						}
						temparray.push(keyCode);
						//setKeys(temparray);
						keys = temparray;
						DelayTimer.start();
					}
				}
			}
			else 
			{
				if (!isDown)
				{
					var temparray2: Array = new Array();
					temparray2.push(keyCode);
					keys = temparray2;
					DelayTimer.start();
				}
			}
			//
		}
		
		public function get keys():Array
		{
			return (this.KeysArray);
		}
		
		public function set keys(_arg_1:Array)
		{
			this.KeysArray = _arg_1;
			this.RefreshText();
		}
		
		private function RefreshText()
		{
			var tempText:String = "";
			for (var key in KeysArray)
			{
				tempText += keytostring(KeysArray[key]);
				if (key < KeysArray.length - 1)
				{
					tempText += "-";
				}
				else
				{
					tempText += ")";
				}
			}
			this.PCKey_tf.text = tempText;
		}
		
		public function keytostring(auKeyCode:uint):String
		{
			switch (auKeyCode)
			{
			case Keyboard.A: 
				return "A";
				break;
			case Keyboard.B: 
				return "B";
				break;
			case Keyboard.C: 
				return "C";
				break;
			case Keyboard.D: 
				return "D";
				break;
			case Keyboard.E: 
				return "E";
				break;
			case Keyboard.F: 
				return "F";
				break;
			case Keyboard.G: 
				return "G";
				break;
			case Keyboard.H: 
				return "H";
				break;
			case Keyboard.I: 
				return "I";
				break;
			case Keyboard.J: 
				return "J";
				break;
			case Keyboard.K: 
				return "K";
				break;
			case Keyboard.L: 
				return "L";
				break;
			case Keyboard.M: 
				return "M";
				break;
			case Keyboard.N: 
				return "N";
				break;
			case Keyboard.O: 
				return "O";
				break;
			case Keyboard.P: 
				return "P";
				break;
			case Keyboard.Q: 
				return "Q";
				break;
			case Keyboard.R: 
				return "R";
				break;
			case Keyboard.S: 
				return "S";
				break;
			case Keyboard.T: 
				return "T";
				break;
			case Keyboard.U: 
				return "U";
				break;
			case Keyboard.V: 
				return "V";
				break;
			case Keyboard.W: 
				return "W";
				break;
			case Keyboard.X: 
				return "X";
				break;
			case Keyboard.Y: 
				return "Y";
				break;
			case Keyboard.Z: 
				return "Z";
				break;
			case Keyboard.F1: 
				return "F1";
				break;
			case Keyboard.F2: 
				return "F2";
				break;
			case Keyboard.F3: 
				return "F3";
				break;
			case Keyboard.F4: 
				return "F4";
				break;
			case Keyboard.F5: 
				return "F5";
				break;
			case Keyboard.F6: 
				return "F6";
				break;
			case Keyboard.F7: 
				return "F7";
				break;
			case Keyboard.F8: 
				return "F8";
				break;
			case Keyboard.F9: 
				return "F9";
				break;
			case Keyboard.F10: 
				return "F10";
				break;
			case Keyboard.F11: 
				return "F11";
				break;
			case Keyboard.F12: 
				return "F12";
				break;
			case Keyboard.NUMBER_0: 
				return "0";
				break;
			case Keyboard.NUMBER_1: 
				return "1";
				break;
			case Keyboard.NUMBER_2: 
				return "2";
				break;
			case Keyboard.NUMBER_3: 
				return "3";
				break;
			case Keyboard.NUMBER_4: 
				return "4";
				break;
			case Keyboard.NUMBER_5: 
				return "5";
				break;
			case Keyboard.NUMBER_6: 
				return "6";
				break;
			case Keyboard.NUMBER_7: 
				return "7";
				break;
			case Keyboard.NUMBER_8: 
				return "8";
				break;
			case Keyboard.NUMBER_9: 
				return "9";
				break;
			case Keyboard.MINUS: 
				return "-";
				break;
			case Keyboard.EQUAL: 
				return "=";
				break;
			case Keyboard.LEFTBRACKET: 
				return "[";
				break;
			case Keyboard.RIGHTBRACKET: 
				return "]";
				break;
			case Keyboard.SEMICOLON: 
				return ";";
				break;
			case Keyboard.QUOTE: 
				return "'";
				break;
			case Keyboard.BACKSLASH: 
				return "\\";
				break;
			case Keyboard.SLASH: 
				return "/";
				break;
			case Keyboard.COMMA: 
				return ",";
				break;
			case Keyboard.PERIOD: 
				return ".";
				break;
			case Keyboard.BACKQUOTE: 
				return "`";
				break;
			case Keyboard.NUMPAD_0: 
				return "NumPad0";
				break;
			case Keyboard.NUMPAD_1: 
				return "NumPad1";
				break;
			case Keyboard.NUMPAD_2: 
				return "NumPad2";
				break;
			case Keyboard.NUMPAD_3: 
				return "NumPad3";
				break;
			case Keyboard.NUMPAD_4: 
				return "NumPad4";
				break;
			case Keyboard.NUMPAD_5: 
				return "NumPad5";
				break;
			case Keyboard.NUMPAD_6: 
				return "NumPad6";
				break;
			case Keyboard.NUMPAD_7: 
				return "NumPad7";
				break;
			case Keyboard.NUMPAD_8: 
				return "NumPad8";
				break;
			case Keyboard.NUMPAD_9: 
				return "NumPad9";
				break;
			case Keyboard.NUMPAD_ADD: 
				return "NumPad+";
				break;
			case Keyboard.NUMPAD_DECIMAL: 
				return "NumPad.";
				break;
			case Keyboard.NUMPAD_DIVIDE: 
				return "NumPad/";
				break;
			case Keyboard.NUMPAD_MULTIPLY: 
				return "NumPad*";
				break;
			case Keyboard.NUMPAD_SUBTRACT: 
				return "NumPad-";
				break;
			case Keyboard.TAB: 
				return "Tab";
				break;
			case Keyboard.INSERT: 
				return "Insert";
				break;
			case Keyboard.DELETE: 
				return "Delete";
				break;
			case Keyboard.HOME: 
				return "Home";
				break;
			case Keyboard.END: 
				return "End";
				break;
			case Keyboard.PAGE_UP: 
				return "PgUp";
				break;
			case Keyboard.PAGE_DOWN: 
				return "PgDn";
				break;
			case Keyboard.BACKSPACE: 
				return "Backspace";
				break;
			case Keyboard.ESCAPE: 
				return "Escape";
				break;
			case Keyboard.SHIFT: 
				return "Shift";
				break;
			case KEY_LSHIFT: 
				return "L Shift";
				break;
			case KEY_RSHIFT: 
				return "R Shift";
				break;
			case Keyboard.ALTERNATE: 
				return "Alt";
				break;
			case KEY_LALT: 
				return "L Alt";
				break;
			case KEY_RALT: 
				return "R Alt";
				break;
			case Keyboard.CONTROL: 
				return "Ctrl";
				break;
			case KEY_LCTRL: 
				return "L Ctrl";
				break;
			case KEY_RCTRL: 
				return "R Ctrl";
				break;
			case Keyboard.SPACE: 
				return "Space";
				break;
			case Keyboard.LEFT: 
				return "Left";
				break;
			case Keyboard.RIGHT: 
				return "Right";
				break;
			case Keyboard.UP: 
				return "Up";
				break;
			case Keyboard.DOWN: 
				return "Down";
				break;
			case Keyboard.ENTER: 
				return "Enter";
				break;
			default: 
				return "";
				
			}
		}
	
	}

}//package 

