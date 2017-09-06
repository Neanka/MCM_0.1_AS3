// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//OptionsList

package mcm
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class OptionsList extends mcm.ItemList
	{
		
		private var bAllowValueOverwrite:Boolean;
		
		public function OptionsList()
		{
			this.bAllowValueOverwrite = false;
			addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			addEventListener(mcm.SettingsOptionItem.VALUE_CHANGE, this.onValueChange);
			addEventListener(mcm.SettingsOptionItem.BUTTON_PRESSED, this.onButtonPressed);
		}
		
		public function get allowValueOverwrite():Boolean
		{
			return (this.bAllowValueOverwrite);
		}
		
		public function set allowValueOverwrite(_arg_1:Boolean)
		{
			this.bAllowValueOverwrite = _arg_1;
		}
		
		override protected function GetEntryHeight(_arg_1:Number):Number
		{
			var _local_2:MovieClip = GetClipByIndex(0);
			return (_local_2.height);
		}
		
		public function onValueChange(_arg_1:Event)
		{
			EntriesA[_arg_1.target.itemIndex].value = _arg_1.target.value;
			if (_arg_1.target.movieType == mcm.SettingsOptionItem.MOVIETYPE_KEYINPUT)
			{
				EntriesA[_arg_1.target.itemIndex].keys = _arg_1.target.OptionItem.keys;
				EntriesA[_arg_1.target.itemIndex].valueString = _arg_1.target.OptionItem.keys.join();
			}
			if (_arg_1.target.movieType == mcm.SettingsOptionItem.MOVIETYPE_HOTKEY)
			{
				EntriesA[_arg_1.target.itemIndex].keys = _arg_1.target.OptionItem.keys;
				try
				{
					var modName:String = EntriesA[_arg_1.target.itemIndex].modName;// MCM_Menu.instance.HelpPanel_mc.HelpList_mc.entryList[MCM_Menu.instance.selectedPage]["modName"];
					var keybindID:String = EntriesA[_arg_1.target.itemIndex].id;
					var keycode:int = EntriesA[_arg_1.target.itemIndex].keys[0];
					//trace(modName, keybindID,keycode);
					if (keycode == 0)
					{
						parent.parent.mcmCodeObj.ClearKeybind(modName, keybindID);
					}
					else
					{
						var modifiers:int = EntriesA[_arg_1.target.itemIndex].keys[1];
						var keyobj:Object = parent.parent.mcmCodeObj.GetKeybind(modName, keybindID);
						//trace(keyobj.keycode);
						if (keyobj.keycode != 0)
						{
							parent.parent.mcmCodeObj.RemapKeybind(modName, keybindID, keycode, modifiers);
						}
						else
						{
							parent.parent.mcmCodeObj.SetKeybind(modName, keybindID, keycode, modifiers);
						}
					}
				}
				catch (e:Error)
				{
					trace("Failed to handle Keybind");
				}
					//trace("MCM_Menu.instance.requestHotkeyControlsUpdate();");
					//MCM_Menu.instance.requestHotkeyControlsUpdate();
			}
			if (EntriesA[_arg_1.target.itemIndex].valueOptions)
			{
				if (EntriesA[_arg_1.target.itemIndex].valueOptions.sourceType)
				{
					switch (EntriesA[_arg_1.target.itemIndex].valueOptions.sourceType)
					{
					case "GlobalValue": 
						try
						{
							parent.parent.mcmCodeObj.SetGlobalValue(EntriesA[_arg_1.target.itemIndex].valueOptions.sourceForm, Number(EntriesA[_arg_1.target.itemIndex].value));
						}
						catch (e:Error)
						{
							trace("Failed to SetGlobalValue");
						}
						break;
					case "ModSettingString": 
						try
						{
							parent.parent.mcmCodeObj.SetModSettingString(EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id, EntriesA[_arg_1.target.itemIndex].valueString);
						}
						catch (e:Error)
						{
							trace("Failed to SetModSettingString");
						}
						break;
					case "ModSettingInt": 
						try
						{
							parent.parent.mcmCodeObj.SetModSettingInt(EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id, int(EntriesA[_arg_1.target.itemIndex].value));
						}
						catch (e:Error)
						{
							trace("Failed to SetModSettingInt");
						}
						break;
					case "ModSettingFloat": 
						try
						{
							//trace(Number(EntriesA[_arg_1.target.itemIndex].value));
							parent.parent.mcmCodeObj.SetModSettingFloat(EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id, Number(EntriesA[_arg_1.target.itemIndex].value));
						}
						catch (e:Error)
						{
							trace("Failed to SetModSettingFloat");
						}
						break;
					case "ModSettingBool": 
						try
						{
							parent.parent.mcmCodeObj.SetModSettingBool(EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id, Boolean(EntriesA[_arg_1.target.itemIndex].value));
						}
						catch (e:Error)
						{
							trace("Failed to SetModSettingBool");
						}
						break;
					default:
						
						break;
					}
				}
			}
			
			if (EntriesA[_arg_1.target.itemIndex].groupControl)
			{
				if (EntriesA[_arg_1.target.itemIndex].value == 1)
				{
					addfilterflag(EntriesA[_arg_1.target.itemIndex].groupControl);
				}
				else
				{
					removefilterflag(EntriesA[_arg_1.target.itemIndex].groupControl);
				}
			}
			stage.getChildAt(0).f4se.SendExternalEvent("OnMCMSettingChange", EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id);
			stage.getChildAt(0).f4se.SendExternalEvent("OnMCMSettingChange|" + EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].modName, EntriesA[_arg_1.target.itemIndex].id);
		}
		
		public function onButtonPressed(_arg_1:Event)
		{
			switch (EntriesA[_arg_1.target.itemIndex].action.type)
			{
			case "CallFunction": 
				cqf(EntriesA[_arg_1.target.itemIndex].action.form, EntriesA[_arg_1.target.itemIndex].action["function"], EntriesA[_arg_1.target.itemIndex].action.params);
				break;
			case "CallGlobalFunction": 
				cgf(EntriesA[_arg_1.target.itemIndex].action.script, EntriesA[_arg_1.target.itemIndex].action["function"], EntriesA[_arg_1.target.itemIndex].action.params);
				break;
			default: 
				trace("unknown button action");
				break;
			}
		}
		
		public function cqf(aQuest:String, aFunc:String, aArgs:Array = null):void
		{
			var tempArgs:Array = new Array();
			tempArgs.push(aQuest);
			tempArgs.push(aFunc);
			tempArgs = tempArgs.concat(aArgs)
			try
			{
				parent.parent.mcmCodeObj.CallQuestFunction.apply(null, tempArgs);
			}
			catch (e:Error)
			{
				trace("Failed to CallQuestFunction");
			}
		}
		
		public function cgf(aScript:String, aFunc:String, aArgs:Array = null):void
		{
			var tempArgs:Array = new Array();
			tempArgs.push(aScript);
			tempArgs.push(aFunc);
			tempArgs = tempArgs.concat(aArgs)
			try
			{
				parent.parent.mcmCodeObj.CallGlobalFunction.apply(null, tempArgs);
			}
			catch (e:Error)
			{
				trace("Failed to CallGlobalFunction");
			}
		}
		
		public function setfilterflag(iFilterFlag:Number):*
		{
			this.filterer.itemFilter = Math.pow(2, iFilterFlag);			// move math.pow
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.entryList[MCM_Menu.instance.selectedPage].dataobj["filterFlagControl"] = this.filterer.itemFilter;
			InvalidateData();
		}
		
		public function addfilterflag(iFilterFlag:Number):*
		{
			this.filterer.itemFilter = this.filterer.itemFilter | Math.pow(2, iFilterFlag);
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.entryList[MCM_Menu.instance.selectedPage].dataobj["filterFlagControl"] = this.filterer.itemFilter;
			InvalidateData();
		}
		
		public function removefilterflag(iFilterFlag:Number):*
		{
			this.filterer.itemFilter = this.filterer.itemFilter & ~Math.pow(2, iFilterFlag);
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.entryList[MCM_Menu.instance.selectedPage].dataobj["filterFlagControl"] = this.filterer.itemFilter;
			InvalidateData();
		}
		
		override protected function SetEntry(_arg_1:BSScrollingListEntry, _arg_2:Object)
		{
			var _local_3:mcm.SettingsOptionItem;
			if (_arg_1 != null)
			{
				_local_3 = (_arg_1 as mcm.SettingsOptionItem);
				if (((this.allowValueOverwrite) || ((!((_local_3.ID == _arg_2.ID))))))
				{
					_local_3.movieType = _arg_2.movieType;
					if (_arg_2.options != undefined)
					{
						_local_3.SetOptionStepperOptions(_arg_2.options);
					}
					;
					if (_arg_2.maxvalue != undefined)
					{
						_local_3.SetOptionSlider(_arg_2.minvalue, _arg_2.maxvalue, _arg_2.step);
					}
					if (_arg_2.keys != undefined)
					{
						if (_arg_2.valueOptions != undefined && _arg_2.valueOptions.allowModifierKeys != undefined)
						{
							_local_3.SetOptionKeyInput(_arg_2.keys, _arg_2.valueOptions.allowModifierKeys, _arg_2.modName, _arg_2.id);
						}
						else
						{
							_local_3.SetOptionKeyInput(_arg_2.keys, 1, _arg_2.modName, _arg_2.id);
						}
					}
					;
					_local_3.ID = _arg_2.ID;
					_local_3.value = _arg_2.value;
					_local_3.hudColorUpdate = _arg_2.hudColorUpdate;
					_local_3.pipboyColorUpdate = _arg_2.pipboyColorUpdate;
					_local_3.difficultyUpdate = _arg_2.difficultyUpdate;
				}
				;
				super.SetEntry(_arg_1, _arg_2);
			}
			;
		}
		
		public function onListItemPressed()
		{
			var _local_1:BSScrollingListEntry;
			if (!bDisableInput)
			{
				if (this.selectedEntry != null)
				{
					_local_1 = GetClipByIndex(this.selectedEntry.clipIndex);
					if (_local_1 != null)
					{
						(_local_1 as mcm.SettingsOptionItem).onItemPressed();
					}
					;
				}
				;
			}
			;
		}
		
		override protected function onItemPress()
		{
			if (((!this.bDisableInput) && (!this.bDisableSelection)) && (!(this.iSelectedIndex == -1)))
			{
				dispatchEvent(new Event(ITEM_PRESS, true, true));
			}
			else
			{
				dispatchEvent(new Event(LIST_PRESS, true, true));
			}
			;
		}
		
		override public function onKeyDown(_arg_1:KeyboardEvent)
		{
			var _local_2:BSScrollingListEntry;
			if (!bDisableInput)
			{
				super.onKeyDown(_arg_1);
				if ((!(this.selectedEntry == null)) && ((_arg_1.keyCode == Keyboard.LEFT) || (_arg_1.keyCode == Keyboard.RIGHT)))
				{
					_local_2 = GetClipByIndex(this.selectedEntry.clipIndex);
					if (_local_2 != null)
					{
						(_local_2 as mcm.SettingsOptionItem).HandleKeyboardInput(_arg_1);
						_arg_1.stopPropagation();
					}
					;
				}
				;
			}
			;
		}
		
		override public function moveSelectionUp()
		{
			var iprevFilterMatch:Number;
			if ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav))
			{
				if (this.selectedIndex > 0)
				{
					var i:int = this.selectedIndex;
					while (i > 0)
					{
						iprevFilterMatch = this._filterer.GetPrevFilterMatch(i);
						switch (EntriesA[iprevFilterMatch].movieType)
						{
						case mcm.SettingsOptionItem.MOVIETYPE_SECTION: 
						case mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE: 
						case mcm.SettingsOptionItem.MOVIETYPE_TEXT: 
						case mcm.SettingsOptionItem.MOVIETYPE_IMAGE: 
							break;
						default: 
							if (iprevFilterMatch != int.MAX_VALUE)
							{
								this.selectedIndex = iprevFilterMatch;
								this.bMouseDrivenNav = false;
								dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
								return;
							}
							;
							break;
						}
						i--;
					}
				}
				;
			}
			else
			{
				this.scrollPosition = (this.scrollPosition - 1);
			}
			;
		}
		
		override public function moveSelectionDown()
		{
			var inextFilterMatch:Number;
			if ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav))
			{
				if (this.selectedIndex < (this.EntriesA.length - 1))
				{
					
					var i:int = this.selectedIndex;
					while (i < this.EntriesA.length - 1)
					{
						inextFilterMatch = this._filterer.GetNextFilterMatch(i);
						switch (EntriesA[inextFilterMatch].movieType)
						{
						case mcm.SettingsOptionItem.MOVIETYPE_SECTION: 
						case mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE: 
						case mcm.SettingsOptionItem.MOVIETYPE_TEXT: 
						case mcm.SettingsOptionItem.MOVIETYPE_IMAGE:
							
							break;
						default: 
							if (inextFilterMatch != int.MAX_VALUE)
							{
								this.selectedIndex = inextFilterMatch;
								this.bMouseDrivenNav = false;
								dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
								return;
							}
							;
							break;
						}
						i++;
					}
				}
				;
			}
			else
			{
				this.scrollPosition = (this.scrollPosition + 1);
			}
			;
		}
	
	}
}//package 

