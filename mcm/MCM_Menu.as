package mcm
{
	import Shared.AS3.*;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import com.adobe.serialization.json.*;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import scaleform.gfx.Extensions;
	
	/**
	 * ...
	 */
	public class MCM_Menu extends MovieClip
	{
		static public var MCM_UI_VERSION:uint = 2;
				
		public var MainMenu:MovieClip;
		public var configPanel_mc:mcm.ConfigPanel;
		public var HelpPanel_mc:mcm.LeftPanel;
		public var ButtonHintBar_mc:Shared.AS3.BSButtonHintBar;
		public var mcmCodeObj:Object = new Object();
		public var bmForInput:InteractiveObject = null;
		private static var _instance:mcm.MCM_Menu;
		public var selectedPage:int;
		public var swfsobject:Object = new Object;
		private var modsNum:int = 0;
		private var modsCount:int = 0;
		private var hotkeyManagerList:Array = new Array();
		private var MCMConfigObject: Object = new Object();
		public var POS_WIN: POS_WINDOW = new POS_WINDOW();
		
		private var standardButtonHintDataV:Vector.<BSButtonHintData>;
		private var ConfirmButton:BSButtonHintData;
		private var CancelButton:BSButtonHintData;
		private var BackButton:BSButtonHintData;
		private var ConfigButton:BSButtonHintData;
		//private var SwitchButtonLeft:BSButtonHintData;
		//private var SwitchButtonRight:BSButtonHintData;
		
		static private var _iMode:uint = 0;
		static public var MCM_MAIN_MODE:uint = 0;
		static public var MCM_REMAP_MODE:uint = 1;
		static public var MCM_CONFLICT_MODE:uint = 2;
		static public var MCM_DD_MODE:uint = 3;
		static public var MCM_POSITIONER_MODE:uint = 4;
		
		static public var mcmLoaded:Boolean = false;

		public function MCM_Menu()
		{
			super();
			this.ConfirmButton = new BSButtonHintData("$CONFIRM", "Enter", "PSN_A", "Xenon_A", 1, this.onAcceptPress);
			this.BackButton = new BSButtonHintData("$Back", "Tab", "PSN_X", "Xenon_X", 1, this.onBackPress);
			this.CancelButton = new BSButtonHintData("$Cancel", "Esc", "PSN_B", "Xenon_B", 1, this.onCancelPress);
			//this.ConfigButton = new BSButtonHintData("$MCM_settings", "Q", "PSN_Select", "Xenon_Select", 1, this.onConfigButtonPress); //TODO: need translation
			//this.SwitchButtonLeft = new BSButtonHintData("$MCM_SWITCH_TO_LEFT", "Q", "PSN_L1", "Xenon_L1", 1, this.switchToLeft);
			//this.SwitchButtonRight = new BSButtonHintData("$MCM_SWITCH_TO_RIGHT", "D", "PSN_R1", "Xenon_R1", 1, this.switchToRight);
			MCM_Menu._instance = this;
			addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			addEventListener(BSScrollingList1.SELECTION_CHANGE, selectionchanged);
			addEventListener(BSScrollingList1.ITEM_PRESS, this.onListItemPress);
			addEventListener(mcm.Option_ButtonMapping.START_INPUT, this.StartInput);
			addEventListener(mcm.Option_ButtonMapping.END_INPUT, this.EndInput);
			
			if (stage)
			{
				onAddedToStage(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			}
			iMode = 0;
		}
		
		/*private function onConfigButtonPress():void 
		{
			this.configPanel_mc.configList_mc.disableInput = false;
			this.configPanel_mc.configList_mc.disableSelection = false;
			this.configPanel_mc.configList_mc.entryList = MCMConfigObject;
			this.configPanel_mc.configList_mc.InvalidateData();
			tryToSelectRightPanel();
		}*/
		
		public function SetButtons():void
		{
			switch (iMode)
			{
			case MCM_MAIN_MODE:
				
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$Back";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			case MCM_REMAP_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$Cancel";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonText = "$MCM_CLEAR_HOTKEY";
				this.BackButton.ButtonVisible = true;
				break;
			case MCM_CONFLICT_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$Cancel";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			case MCM_DD_MODE:
				
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$Back";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			case MCM_POSITIONER_MODE:				
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$Back";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			default: 
			}
			//this.ConfigButton.ButtonVisible = (iMode == MCM_MAIN_MODE);
		/*	if (stage)
		   {
		   this.SwitchButtonLeft.ButtonVisible = (iMode == MCM_MAIN_MODE) && (stage.focus != this.HelpPanel_mc.HelpList_mc);
		   this.SwitchButtonRight.ButtonVisible = (iMode == MCM_MAIN_MODE) && (stage.focus == this.HelpPanel_mc.HelpList_mc);
		   }*/
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			this.ButtonHintBar_mc = MainMenu.ButtonHintBar_mc;
			MainMenu["BethesdaLogo_mc"].addChild(POS_WIN);
			SetButtons();
		}
		
		private function onKeyUpHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case Keyboard.ESCAPE: 
				onCancelPress();
				break;
			default: 
			}
		}
		
		public function onQuitPressed():void
		{
			switch (iMode)
			{
			case MCM_MAIN_MODE: 
				stage.getChildAt(0)["Menu_mc"].EndState();				
				break;
			case MCM_CONFLICT_MODE: 
				this.configPanel_mc.hotkey_conflict_mc.Close(true);
				break;
			case MCM_DD_MODE: 
				this.configPanel_mc.DD_popup_mc.Close(true);
				this.configPanel_mc.configList_mc.UpdateList();
				break;
			default: 
			}
		}
		
		private function onCancelPress():void
		{
			switch (iMode)
			{
			case MCM_MAIN_MODE: 
				if (stage.focus == this.HelpPanel_mc.HelpList_mc)
				{
					onQuitPressed();
				}
				else
				{
					stage.focus = this.HelpPanel_mc.HelpList_mc;
					this.configPanel_mc.configList_mc.selectedIndex = -1;
					this.HelpPanel_mc.HelpList_mc.UpdateEntry(this.HelpPanel_mc.HelpList_mc.selectedEntry);
				}
				
				break;
			case MCM_CONFLICT_MODE: 
				this.configPanel_mc.hotkey_conflict_mc.Close(true);
				break;
			case MCM_REMAP_MODE: 
				(bmForInput as mcm.Option_ButtonMapping).onEscPressed();
				break;
			case MCM_DD_MODE: 
				this.configPanel_mc.DD_popup_mc.Close(true);
				this.configPanel_mc.configList_mc.UpdateList();
				break;
			case MCM_POSITIONER_MODE: 
				POS_WIN.Close();
				break;
			default: 
			}
		}
		
		private function onBackPress():void
		{
			switch (iMode)
			{
			case MCM_MAIN_MODE:
				
				break;
			case MCM_CONFLICT_MODE:
				
				break;
			case MCM_REMAP_MODE: 
				(bmForInput as mcm.Option_ButtonMapping).onTabPressed();
				break;
			default: 
			}
		}
		
		private function onAcceptPress():void
		{
			trace("onAcceptPress");
		}
		
		public function PopulateButtonBar():void
		{
			this.standardButtonHintDataV = new Vector.<BSButtonHintData>();
			//this.standardButtonHintDataV.push(this.SwitchButtonLeft);
			//this.standardButtonHintDataV.push(this.SwitchButtonRight);	
			this.standardButtonHintDataV.push(this.ConfirmButton);
			this.standardButtonHintDataV.push(this.BackButton);
			this.standardButtonHintDataV.push(this.CancelButton);
			//this.standardButtonHintDataV.push(this.ConfigButton);
			this.ButtonHintBar_mc.SetButtonHintData(this.standardButtonHintDataV);
		}
		
		public function requestHotkeyControlsUpdate():void
		{
			for each (var entry in this.HelpPanel_mc.HelpList_mc.entryList)
			{
				if (entry.dataobj)
				{
					checkHotkeyByRequest(entry.dataobj);
				}
			}
			checkHotkeyByRequest(this.configPanel_mc.configList_mc.entryList); //TODO: needs only for hotkey manager ?
			this.configPanel_mc.configList_mc.UpdateList();
		/*for each (var entry1 in this.configPanel_mc.configList_mc.entryList)
		   {
		   if (getQualifiedClassName(entry1) == "Object" && entry1.hasOwnProperty("movieType") && entry1.movieType == mcm.SettingsOptionItem.MOVIETYPE_HOTKEY)
		   {
		   this.configPanel_mc.configList_mc.UpdateEntry(entry1);
		   }
		
		   }*/
		}
		
		public function checkHotkeyByRequest(obj:Object):void
		{
			for each (var control in obj)
			{
				if (getQualifiedClassName(control) == "Object" && control.hasOwnProperty("movieType") && control.movieType == mcm.SettingsOptionItem.MOVIETYPE_HOTKEY)
				{
					try
					{
						var tempobj:Object = mcmCodeObj.GetKeybind(control.modName, control.id);
						var temparr:Array = new Array();
						if (tempobj)
						{
							temparr.push(tempobj.keycode);
							temparr.push(tempobj.modifiers);
						}
						else
						{
							temparr.push(0);
							temparr.push(0);
						}
						control.keys = temparr;
					}
					catch (err:Error)
					{
						trace("Failed to GetKeybind");
					}
				}
			}
		}
		
		public function RefreshMCM_internal():void
		{
			for each (var entry in this.HelpPanel_mc.HelpList_mc.entryList)
			{
				if (entry.dataobj)
				{
					checkEntriesByRequest(entry.dataobj);
				}
			}
			//checkEntriesByRequest(this.configPanel_mc.configList_mc.entryList);
			this.configPanel_mc.configList_mc.filterer.itemFilter = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["filterFlagControl"];
			this.configPanel_mc.configList_mc.UpdateList();
		}
		
		public function checkEntriesByRequest(obj:Object):void
		{
			trace("checkEntriesByRequest");
			var filterFlagControl:uint = 2147483647;// uint.MAX_VALUE;
			for each (var control in obj)
			{
				if (getQualifiedClassName(control) == "Object")
				{
					if (control["valueOptions"])
					{
						if (control["valueOptions"]["sourceType"])
						{
							switch (control["valueOptions"]["sourceType"])
							{
							case "ModSettingBool": 
								try
								{
									control.value = mcmCodeObj.GetModSettingBool(control.modName, control["id"]) ? 1 : 0;
								}
								catch (e:Error)
								{
									control.value = 0;
									trace("Failed to GetModSettingBool");
								}
								break;
							case "GlobalValue": 
								try
								{
									control.value = mcmCodeObj.GetGlobalValue(control["valueOptions"]["sourceForm"]);
								}
								catch (e:Error)
								{
									control.value = 0;
									trace("Failed to GetGlobalValue");
								}
								break;
							case "ModSettingString": 
								try
								{
									control.valueString = mcmCodeObj.GetModSettingString(control.modName, control["id"]);
								}
								catch (e:Error)
								{
									control.valueString = " ";
									trace("Failed to GetModSettingString");
								}
								break;
							case "ModSettingInt": 
								try
								{
									control.value = mcmCodeObj.GetModSettingInt(control.modName, control["id"]);
								}
								catch (e:Error)
								{
									control.value = 0;
									trace("Failed to GetModSettingInt");
								}
								break;
							case "ModSettingFloat": 
								try
								{
									control.value = mcmCodeObj.GetModSettingFloat(control.modName, control["id"]);
								}
								catch (e:Error)
								{
									control.value = 0.0;
									trace("Failed to GetModSettingFloat");
								}
								break;
							case "PropertyValueBool": 
								try
								{
									control.value = mcmCodeObj.GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]) ? 1 : 0;
								}
								catch (e:Error)
								{
									control.value = 0;
									trace("Failed to GetPropertyValueBool");
								}
								break;
							case "PropertyValueString": 
								try
								{
									control.valueString = GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
								}
								catch (e:Error)
								{
									control.valueString = " ";
									trace("Failed to GetPropertyValueString");
								}
								break;
							case "PropertyValueInt": 
								try
								{
									control.value = GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
								}
								catch (e:Error)
								{
									control.value = 0;
									trace("Failed to GetPropertyValueInt");
								}
								break;
							case "PropertyValueFloat": 
								try
								{
									control.value = GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
								}
								catch (e:Error)
								{
									control.value = 0.0;
									trace("Failed to GetPropertyValueFloat");
								}
								break;
							default: 
							}
							if (control["groupControl"])
							{
								if (control.value == 0)
								{
									filterFlagControl = filterFlagControl & ~Math.pow(2, control["groupControl"]);
								}
							}
						}
					}
				}
			}
			obj.filterFlagControl = filterFlagControl;
		}
		
		private function StartInput(e:Event):void
		{
			try
			{
				bmForInput = e.target;
					//mcmCodeObj.StartKeyCapture();
			}
			catch (e:Error)
			{
				trace("Failed to StartKeyCapture");
			}
		}
		
		private function EndInput(e:Event):void
		{
			try
			{
				bmForInput = null;
					//mcmCodeObj.StopKeyCapture();
			}
			catch (e:Error)
			{
				trace("Failed to StopKeyCapture");
			}
		}
		
		public static function get instance():MCM_Menu
		{
			return _instance;
		}
		
		static public function set iMode(value:uint):void
		{
			_iMode = value;
			MCM_Menu.instance.SetButtons();
		}
		
		static public function get iMode():uint
		{
			return _iMode;
		}
		
		function listcreated(param1:Event)
		{
			//log(param1.target.name + " created");
			switch (param1.target.name)
			{
			case "HelpList_mc": 
				this.HelpPanel_mc.HelpList_mc.filterer.filterType = ListFiltererEx.FILTER_TYPE_LEFTPANEL;
				this.HelpPanel_mc.HelpList_mc.filterer.itemFilter = 1;
				loadLibs(); //TODO find best place to call
				try
				{
					var jsonsArray:Array = mcmCodeObj.GetConfigList(true);
					modsNum = jsonsArray.length;
					if (modsNum == 0)
					{
						//this.HelpPanel_mc.HelpList_mc.entryList.push({text: "No supported mods installed"})
						//this.HelpPanel_mc.HelpList_mc.InvalidateData();
						onAllModsLoad();
					}
					else
					{
						for (var i in jsonsArray)
						{
							JSONLoader("../../" + jsonsArray[i]);
						}
					}
						//trace("JSON LOADED");
				}
				catch (e:Error)
				{
					trace("Failed to GetDirectoryListing for JSON");
					modsNum = 2;
					JSONLoader("../../Data/MCM/Config/cc_cleaner/config.json");
					JSONLoader("../../Data/MCM/Config/MCM_Demo/config.json");
				}
				
				break;
			case "configList_mc": 
				this.configPanel_mc.configList_mc.InvalidateData();
				loadWelcomePage();
				this.configPanel_mc.configList_mc.disableInput = true;
				this.configPanel_mc.configList_mc.disableSelection = true;
				break;
			case "confirmlist_mc": 
				var yesno:Array = new Array();
				yesno.push({text: "$YES"});
				yesno.push({text: "$Cancel"});
				this.configPanel_mc.hotkey_conflict_mc.confirmlist_mc.entryList = yesno;
				this.configPanel_mc.hotkey_conflict_mc.confirmlist_mc.InvalidateData();
				this.configPanel_mc.hotkey_conflict_mc.confirmlist_mc.selectedIndex = 0;
				break;
			default: 
			}
		}
		
		public function loadWelcomePage():void
		{
			var temparray:Array = new Array();
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "image", "libName": "builtin", "className": "logotest", "width": 345});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"type": "spacer"});
			temparray.push({"text": "MCM FALLOUT 4 EDITION", "align": "center", "type": "text"});
			temparray.push({"text": "VERSION " + String(GetMCMVersionString()), "align": "center", "type": "text"});
			this.configPanel_mc.configList_mc.entryList = processDataObj(temparray);
			this.configPanel_mc.configList_mc.InvalidateData();
		}
		
		function loadLibs():void
		{
			try
			{
				var swfsArray:Array = mcmCodeObj.GetConfigList(true, "lib.swf");
				//trace(swfsArray);
				for (var i in swfsArray)
				{
					var swfloader:Loader = new Loader();
					swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSWFLoaded, false, 0, true);
					swfloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
					swfloader.load(new URLRequest("../../" + swfsArray[i]));
				}
			}
			catch (e:Error)
			{
				trace("Failed to GetDirectoryListing for Libs");
				var swfloader1:Loader = new Loader();
				swfloader1.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSWFLoaded, false, 0, true);
				swfloader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
				swfloader1.load(new URLRequest("../../Data/MCM/Config/MCM_Demo/lib.swf"));
				var swfloader2:Loader = new Loader();
				swfloader2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSWFLoaded, false, 0, true);
				swfloader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
				swfloader2.load(new URLRequest("../../Data/MCM/Config/cc_cleaner/lib.swf"));
			}
		}
		
		function selectionchanged(param1:Event)
		{
			switch (param1.target)
			{
			case this.HelpPanel_mc.HelpList_mc:
				
				break;
			case this.configPanel_mc.configList_mc: 
				if (this.configPanel_mc.configList_mc.selectedIndex > -1)
				{
					if (this.configPanel_mc.configList_mc.entryList[this.configPanel_mc.configList_mc.selectedIndex].help)
					{
						GlobalFunc.SetText(this.configPanel_mc.hint_tf, this.configPanel_mc.configList_mc.entryList[this.configPanel_mc.configList_mc.selectedIndex].help, true);
					}
					else
					{
						GlobalFunc.SetText(this.configPanel_mc.hint_tf, " ", true);
					}
					
						//stage.focus = this.configPanel_mc.configList_mc; // temp string
				}
				break;
			default: 
			}
		}
		
		private function onListItemPress(_arg_1:Event)
		{
			if (_arg_1.target == this.configPanel_mc.configList_mc)
			{
				(this.configPanel_mc.configList_mc as mcm.OptionsList).onListItemPressed();
			}
			else if (_arg_1.target == this.configPanel_mc.DD_popup_mc.DD_popup_list_mc)
			{
				this.configPanel_mc.DD_popup_mc.Close(false);
			}
			else if (_arg_1.target == this.HelpPanel_mc.HelpList_mc)
			{
				if (stage.focus != this.HelpPanel_mc.HelpList_mc) 
				{
					stage.focus = this.HelpPanel_mc.HelpList_mc;
				}
				for each (var obj in this.HelpPanel_mc.HelpList_mc.entryList)
				{
					obj.pageSelected = false;
				}
				this.HelpPanel_mc.HelpList_mc.selectedEntry.pageSelected = true;
				this.selectedPage = this.HelpPanel_mc.HelpList_mc.selectedIndex;
				if (this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj)
				{
					this.configPanel_mc.configList_mc.entryList = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj;
					this.configPanel_mc.configList_mc.filterer.itemFilter = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["filterFlagControl"];
					stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuOpen");
					stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuOpen");
				}
				else if (this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].hotkeyManager)
				{
					populateHotkeyArray();
					this.configPanel_mc.configList_mc.entryList = processDataObj(hotkeyManagerList, "Hotkey manager");
					this.configPanel_mc.configList_mc.filterer.itemFilter = 2147483647;// uint.MAX_VALUE;
				}
				else
				{
					this.configPanel_mc.configList_mc.entryList = new Array();
					this.configPanel_mc.configList_mc.filterer.itemFilter = 2147483647;// uint.MAX_VALUE;
					GlobalFunc.SetText(this.configPanel_mc.hint_tf, " ", true);
				}
				this.configPanel_mc.configList_mc.InvalidateData();
				
				if (this.HelpPanel_mc.HelpList_mc.selectedEntry.filterFlag == 1)
				{
					stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuOpen|"+this.HelpPanel_mc.HelpList_mc.selectedEntry.modName);
					if (this.HelpPanel_mc.HelpList_mc.filterer.modName == this.HelpPanel_mc.HelpList_mc.selectedEntry.modName)
					{
						tryToSelectRightPanel();
					}
					else
					{
						this.HelpPanel_mc.HelpList_mc.filterer.modName = this.HelpPanel_mc.HelpList_mc.selectedEntry.modName;
					}
				}
				else
				{
					tryToSelectRightPanel();
				}
				this.HelpPanel_mc.HelpList_mc.UpdateList();
				this.configPanel_mc.configList_mc.disableInput = false;
				this.configPanel_mc.configList_mc.disableSelection = false;
			}
			else if (_arg_1.target == this.configPanel_mc.hotkey_conflict_mc.confirmlist_mc)
			{
				switch (this.configPanel_mc.hotkey_conflict_mc.confirmlist_mc.selectedIndex)
				{
				case 0: 
					this.configPanel_mc.hotkey_conflict_mc.Close(false);
					break;
				case 1: 
					this.configPanel_mc.hotkey_conflict_mc.Close(true);
					break;
				default: 
				}
			}
		}
		
		function tryToSelectRightPanel():void
		{
			this.configPanel_mc.configList_mc.selectedIndex = -1;
			this.configPanel_mc.configList_mc.moveSelectionDown();
			if (this.configPanel_mc.configList_mc.selectedIndex != -1)
			{
				stage.focus = this.configPanel_mc.configList_mc;
			}
			else 
			{
				stage.focus = this.HelpPanel_mc.HelpList_mc;
				SetButtons();
				this.HelpPanel_mc.HelpList_mc.UpdateEntry(this.HelpPanel_mc.HelpList_mc.selectedEntry);
			}
		}
		
		public function JSONLoader(filename:String)
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}
		
		private function onSWFLoaded(event:Event):void
		{
			var path:String = event.target.url;
			if (Extensions.isScaleform)  // no need for game but need for testing in IDE
			{
				path = path.substring(0, path.lastIndexOf("\\"));
				path = path.substring(path.lastIndexOf("\\") + 1);
			}
			else
			{
				path = path.substring(0, path.lastIndexOf("/"));
				path = path.substring(path.lastIndexOf("/") + 1);
			}
			swfsobject[path] = (event.target as LoaderInfo).loader;
		}
		
		public function getMcFromLib(libname:String, classname:String):MovieClip
		{
			var myClass:Class;
			if (libname == "builtin")
			{
				myClass = getDefinitionByName(classname);
			}
			else
			{
				myClass = swfsobject[libname].contentLoaderInfo.applicationDomain.getDefinition(classname) as Class;
			}
			return new myClass() as MovieClip;
		
		}
		
		private function IOSWFErrorHandler(errorEvent:IOErrorEvent):void
		{
			trace(errorEvent.text);
		}
		
		private function decodeJSON(e:Event):void
		{
			var dataObj:Object = com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			var reqsstatus:Array = new Array();
			var mcmstatus:Boolean = true;
			var modName:String = dataObj["modName"];
			var displayName:String;
			if (dataObj["displayName"])
			{
				displayName = dataObj["displayName"];
			}
			else
			{
				displayName = modName;
			}
			if (dataObj["pluginRequirements"])
			{
				
				for (var reqs in dataObj["pluginRequirements"])
				{
					try
					{
						if (!mcmCodeObj.IsPluginInstalled(dataObj["pluginRequirements"][reqs]))
						{
							reqsstatus.push(dataObj["pluginRequirements"][reqs]);
						}
					}
					catch (err:Error)
					{
						trace("Failed to check IsPluginInstalled");
					}
				}
			}
			if (dataObj["minMcmVersion"])
			{
				try
				{
					if (Number(dataObj["minMcmVersion"]) > Number(GetVersionCode()))
					{
						mcmstatus = false;
					}
				}
				catch (err:Error)
				{
					trace("Failed to check GetVersionCode");
				}
			}
			if ((reqsstatus.length > 0) || !mcmstatus)
			{
				var temparray:Array = new Array();
				temparray.push({"type": "spacer"});
				temparray.push({"type": "image", "libName": "builtin", "className": "exclamation_icon"});
				temparray.push({"type": "spacer"});
				if ((reqsstatus.length > 0))
				{
					temparray.push({"text": Translator("$MCM_MISSING_PLUGINS"), "align": "center", "type": "text"});
					for (var count in reqsstatus)
					{
						temparray.push({"text": String(count + 1) + ". " + reqsstatus[count], "align": "center", "type": "text"});
					}
					temparray.push({"type": "spacer"});
				}
				
				if (!mcmstatus)
				{
					temparray.push({"text": Translator("$MCM_WRONG_VERSION") + " " + String(GetVersionCode()) + " (" + Translator("$MCM_REQUIRED") + " " + dataObj["minMcmVersion"] + ")", "align": "center", "type": "text"});
				}
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(temparray, dataObj["modName"]), text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false, reqsStatus: 1});
				this.HelpPanel_mc.HelpList_mc.InvalidateData();
				checkModsLoad();
				return;
			}
			if (dataObj["content"])
			{
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(dataObj["content"], dataObj["modName"]), text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false
				
				});
			}
			else
			{
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: null, text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false
				
				});
			}
			for (var i in dataObj["pages"])
			{
				var checkreqsarray: Array = checkreqs(dataObj["pages"][i]);
				if (checkreqsarray.length >0) 
				{
					if (!dataObj["pages"][i].hideIfMissingReqs) 
					{
						if (dataObj["pages"][i].messageIfMissingReqs) 
						{
							checkreqsarray.push({"text": dataObj["pages"][i].messageIfMissingReqs, "align": "center", "type": "text"});
						}
						this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(checkreqsarray, dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: dataObj["modName"], filterFlag: 2, pageSelected: false});
					}
				}
				else 
				{
					this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(dataObj["pages"][i]["content"], dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: dataObj["modName"], filterFlag: 2, pageSelected: false});
				}
			}
			
			this.HelpPanel_mc.HelpList_mc.InvalidateData();
			checkModsLoad();
		
			//this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			//onListItemPress(null);
		
		}
		
		private function checkreqs(dataObj: Object): Array
		{
			var reqsstatus:Array = new Array();
			var mcmstatus:Boolean = true;
			if (dataObj["pluginRequirements"])
			{
				
				for (var reqs in dataObj["pluginRequirements"])
				{
					try
					{
						if (!mcmCodeObj.IsPluginInstalled(dataObj["pluginRequirements"][reqs]))
						{
							reqsstatus.push(dataObj["pluginRequirements"][reqs]);
						}
					}
					catch (err:Error)
					{
						trace("Failed to check IsPluginInstalled");
					}
				}
			}
			if (dataObj["minMcmVersion"])
			{
				try
				{
					if (Number(dataObj["minMcmVersion"]) > Number(GetVersionCode()))
					{
						mcmstatus = false;
					}
				}
				catch (err:Error)
				{
					trace("Failed to check GetVersionCode");
				}
			}
			if ((reqsstatus.length > 0) || !mcmstatus)
			{
				var temparray:Array = new Array();
				temparray.push({"type": "spacer"});
				temparray.push({"type": "image", "libName": "builtin", "className": "exclamation_icon"});
				temparray.push({"type": "spacer"});
				if ((reqsstatus.length > 0))
				{
					temparray.push({"text": Translator("$MCM_MISSING_PLUGINS"), "align": "center", "type": "text"});
					for (var count in reqsstatus)
					{
						temparray.push({"text": String(count + 1) + ". " + reqsstatus[count], "align": "center", "type": "text"});
					}
					temparray.push({"type": "spacer"});
				}				
				if (!mcmstatus)
				{
					temparray.push({"text": Translator("$MCM_WRONG_VERSION") + " " + String(GetVersionCode()) + " (" + Translator("$MCM_REQUIRED") + " " + dataObj["minMcmVersion"] + ")", "align": "center", "type": "text"});
					temparray.push({"type": "spacer"});
				}

				return temparray;
			}
			return new Array();
		}
		
		private function processDataObj(dataObj:Object, modName:String = "MCM"):Object
		{
			var filterFlagControl:uint = 2147483647;// uint.MAX_VALUE;
			var tempObj:Object = dataObj;
			for (var num in tempObj)
			{
				if (!tempObj[num].modName)
				{
					tempObj[num].modName = modName;
				}
				if (tempObj[num]["valueOptions"])
				{
					if (tempObj[num]["valueOptions"]["sourceType"])
					{
						switch (tempObj[num]["valueOptions"]["sourceType"])
						{
						case "ModSettingBool": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetModSettingBool(tempObj[num].modName, tempObj[num]["id"]) ? 1 : 0;
							}
							catch (e:Error)
							{
								tempObj[num].value = 0;
								trace("Failed to GetModSettingBool");
							}
							break;
						case "GlobalValue": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetGlobalValue(tempObj[num]["valueOptions"]["sourceForm"]);
							}
							catch (e:Error)
							{
								tempObj[num].value = 0;
								trace("Failed to GetGlobalValue");
							}
							break;
						case "ModSettingString": 
							try
							{
								tempObj[num].valueString = mcmCodeObj.GetModSettingString(tempObj[num].modName, tempObj[num]["id"]);
							}
							catch (e:Error)
							{
								tempObj[num].valueString = " ";
								trace("Failed to GetModSettingString");
							}
							break;
						case "ModSettingInt": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetModSettingInt(tempObj[num].modName, tempObj[num]["id"]);
							}
							catch (e:Error)
							{
								tempObj[num].value = 0;
								trace("Failed to GetModSettingInt");
							}
							break;
						case "ModSettingFloat": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetModSettingFloat(tempObj[num].modName, tempObj[num]["id"]);
							}
							catch (e:Error)
							{
								tempObj[num].value = 0.0;
								trace("Failed to GetModSettingFloat");
							}
							break;
						case "PropertyValueInt":
							try
							{
								tempObj[num].value = mcmCodeObj.GetPropertyValue(tempObj[num]["valueOptions"]["sourceForm"], tempObj[num]["valueOptions"]["propertyName"]);
							}
							catch (e:Error)
							{
								tempObj[num].value = 0;
								trace("Failed to GetPropertyValueInt");
							}
							break;
						case "PropertyValueFloat": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetPropertyValue(tempObj[num]["valueOptions"]["sourceForm"], tempObj[num]["valueOptions"]["propertyName"]);
							}
							catch (e:Error)
							{
								tempObj[num].value = 0.0;
								trace("Failed to GetPropertyValueFloat");
							}
							break;
						case "PropertyValueString": 
							try
							{
								tempObj[num].valueString = mcmCodeObj.GetPropertyValue(tempObj[num]["valueOptions"]["sourceForm"], tempObj[num]["valueOptions"]["propertyName"]);
							}
							catch (e:Error)
							{
								tempObj[num].valueString = " ";
								trace("Failed to GetPropertyValueString");
							}
							break;
						case "PropertyValueBool": 
							try
							{
								tempObj[num].value = mcmCodeObj.GetPropertyValue(tempObj[num]["valueOptions"]["sourceForm"], tempObj[num]["valueOptions"]["propertyName"]) ? 1 : 0;;
							}
							catch (e:Error)
							{
								tempObj[num].value = 0;
								trace("Failed to GetPropertyValueBool");
							}
							break;
						default: 
						}
						if (tempObj[num]["groupControl"])
						{
							if (tempObj[num].value == 0)
							{
								filterFlagControl = filterFlagControl & ~Math.pow(2, tempObj[num]["groupControl"]);
							}
						}
					}
				}
				
				switch (tempObj[num]["type"])
				{
				case "switcher": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SWITCHER;
					break;
				case "hiddenSwitcher": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SWITCHER;
					//tempObj[num].filterFlag = 2147483648;
					break;
				case "stepper": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_STEPPER;
					tempObj[num].options = tempObj[num]["valueOptions"]["options"];
					break;
				case "slider": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SCROLLBAR;
					tempObj[num].minvalue = tempObj[num]["valueOptions"].min;
					tempObj[num].maxvalue = tempObj[num]["valueOptions"].max;
					tempObj[num].step = tempObj[num]["valueOptions"].step;
					break;
				case "section": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SECTION;
					break;
				case "spacer": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
					break;
				case "dropdown": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_DROPDOWN;
					tempObj[num].options = tempObj[num]["valueOptions"]["options"];
					break;
				case "dropdownFiles": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_DD_FILES;
					try 
					{
						var filesArray: Array = stage.getChildAt(0).f4se.GetDirectoryListing(tempObj[num]["valueOptions"].path, tempObj[num]["valueOptions"].mask);
						var optionsArray: Array = new Array();
						optionsArray.push("None");
						tempObj[num].value = 0;
						var fileName: String = "";
						for (var i:int = 0; i < filesArray.length; i++) 
						{
							fileName = filesArray[i].name.substring(filesArray[i].name.lastIndexOf("\\") + 1);
							optionsArray.push(fileName);
							if (fileName == tempObj[num].valueString) 
							{
								tempObj[num].value = i+1;
							}
						}
						tempObj[num].options = optionsArray;
					}
					catch (err:Error)
					{
						trace("Failed to GetDirectoryListing");
					}

					break;
				case "text": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXT;
					break;
				case "positioner": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_POSITIONER;
					break;
				case "button": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_BUTTON;
					break;
				case "keyinput": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_KEYINPUT;
					tempObj[num].keys = tempObj[num].valueString.split(",");
					break;
				case "image": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_IMAGE;
					break;
				case "hotkey": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_HOTKEY;
					try
					{
						var tempobj:Object = mcmCodeObj.GetKeybind(tempObj[num].modName, tempObj[num].id);
						var temparr:Array = new Array();
						if (tempobj)
						{
							temparr.push(tempobj.keycode);
							temparr.push(tempobj.modifiers);
						}
						else
						{
							temparr.push(0);
							temparr.push(0);
						}
						tempObj[num].keys = temparr;
					}
					catch (err:Error)
					{
						trace("Failed to GetKeybind");
					}
					break;
				default: 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
					break;
				}
				
				if (tempObj[num]["groupCondition"])
				{
					switch (getQualifiedClassName(tempObj[num]["groupCondition"]))
					{
					case "int": // for Flash
					case "Number": //for Scaleform
						tempObj[num].filterOperator = "OR";
						tempObj[num].filterFlag = Math.pow(2, int(tempObj[num]["groupCondition"]));
						break;
					case "Array": 
						tempObj[num].filterOperator = "OR";
						tempObj[num].filterFlag = 0;
						for (var j in tempObj[num]["groupCondition"])
						{
							tempObj[num].filterFlag += Math.pow(2, int(tempObj[num]["groupCondition"][j]));
						}
						break;
					case "Object": 
						if (tempObj[num]["groupCondition"]["AND"])
						{
							tempObj[num].filterOperator = "AND";
							tempObj[num].filterFlag = 0;
							for (var k in tempObj[num]["groupCondition"]["AND"])
							{
								tempObj[num].filterFlag += Math.pow(2, int(tempObj[num]["groupCondition"]["AND"][k]));
							}
						}
						else if (tempObj[num]["groupCondition"]["OR"])
						{
							tempObj[num].filterOperator = "OR";
							tempObj[num].filterFlag = 0;
							for (var m in tempObj[num]["groupCondition"]["OR"])
							{
								tempObj[num].filterFlag += Math.pow(2, int(tempObj[num]["groupCondition"]["OR"][m]));
							}
						}
						break;
					default: 
						tempObj[num].filterOperator = "OR";
						tempObj[num].filterFlag = 1;
						break;
					}
				}
				else
				{
					tempObj[num].filterOperator = "OR";
					tempObj[num].filterFlag = 1;
				}
				if (tempObj[num].type == "hiddenSwitcher") 
				{
					tempObj[num].filterFlag = 2147483648;
				}
			}
			tempObj.filterFlagControl = filterFlagControl;
			return tempObj;
		}
		
		private function checkModsLoad():void
		{
			modsCount += 1;
			if (modsCount == modsNum)
			{
				onAllModsLoad();
			}
		}
		
		private function onAllModsLoad():void
		{
			trace(modsCount + "/" + modsNum + " mod configs loaded");
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				dataobj: createMCMConfigObject(), 
				text: "MCM Settings", //TODO: need translation
				modName: "MCM", 
				filterFlag: 1, 
				pageSelected: false			
			});		
			this.MCMConfigObject = createMCMConfigObject();
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				dataobj: null, 
				text: "$MCM_HOTKEY_MANAGER", 
				modName: "Hotkey manager", 
				hotkeyManager: true, 
				filterFlag: 1, 
				pageSelected: false			
			});
			this.HelpPanel_mc.HelpList_mc.InvalidateData();
			this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			if (stage)
			{
				stage.focus = this.HelpPanel_mc.HelpList_mc;
				SetButtons();
				this.HelpPanel_mc.HelpList_mc.UpdateEntry(this.HelpPanel_mc.HelpList_mc.selectedEntry);
			}
			mcmLoaded = true;
		}
		
		private function createMCMConfigObject(): Object 
		{
			var temparray:Array = new Array();
			temparray.push({
				"type": "section",
				"text": "MCM Settings" //TODO: need translation
			});
			temparray.push({
				"id": "iPosition:Main",
				"type": "slider",
				"text": "MCM position in the main menu", //TODO: need translation
				"valueOptions": {
					"min": 0,
					"max": 7,
					"step": 1,
					"sourceType": "ModSettingInt"
				}
			});
			return processDataObj(temparray);
		}
		
		public function populateHotkeyArray():void
		{
			hotkeyManagerList = new Array();
			var tempmodname:String = "";
			try
			{
				var temparray:Array = mcmCodeObj.GetAllKeybinds();
				//trace("===========trace all keybinds=========");
				//traceObj(temparray);
				//trace("EOF ===========trace all keybinds=========");
				if (temparray.length == 0)
				{
					hotkeyManagerList.push({"type": "text", "text": "$MCM_NO_HOTKEYS"});
				}
				else
				{
					temparray.sortOn(["modName"]);
					for each (var obj in temparray)
					{
						if (obj.modName != tempmodname)
						{
							if (tempmodname != "")
							{
								hotkeyManagerList.push({"type": "spacer"});
							}
							tempmodname = obj.modName;
							hotkeyManagerList.push({"type": "section", "text": tempmodname});
						}
						var tempObject:Object = {"type": "hotkey", "modName": obj.modName, "text": obj.keybindName, "id": obj.keybindID, "help": "", "hotkeyAction": {}};
						hotkeyManagerList.push(tempObject);
					}
				}
			}
			catch (err:Error)
			{
				trace("Failed to GetAllKeybinds");
			}
		}
		
		public function ProcessKeyEvent(keyCode:int, isDown:Boolean):void
		{
			//stage.getChildAt(0).f4se.plugins.def_plugin.papMessageBox(String(keyCode));
			if (bmForInput)
			{
				bmForInput.ProcessKeyEvent(keyCode, isDown);
			}
			else
			{
				if (!isDown)
				{
					switch (keyCode)
					{
					case Keyboard.TAB: 
						onCancelPress();
						break;
					case Keyboard.ESCAPE: 
						onQuitPressed();
						break;
				/*	case Keyboard.Q: 
						if (iMode == MCM_MAIN_MODE) 
						{
							onConfigButtonPress();
						}
						break;*/
					default: 
					}
				}
			}
			//log("Key event! keyCode: " + keyCode + " isDown: " + isDown);
		}
		
		public function ProcessUserEvent(controlName:String, isDown:Boolean, deviceType:int):void
		{
			//log("User event! controlName: " + controlName + " isDown: " + isDown);
			/*if (!isDown && iMode == MCM_MAIN_MODE && deviceType == 2)
			   {
			   switch (controlName)
			   {
			   case "LShoulder":
			   switchToLeft();
			   break;
			   case "RShoulder":
			   switchToRight();
			   break;
			   default:
			   }
			   }*/
			if (!isDown && deviceType == 2)
			{
				switch (controlName) 
				{
					case "Cancel":
						onCancelPress();
					break;
				/*	case "Select":
						if (iMode == MCM_MAIN_MODE) 
						{
							onConfigButtonPress();
						}
					break;*/
					case "LShoulder":
						switchToLeft();
					break;
					case "RShoulder":
						switchToRight();
					break;
					default:
				}
				
				
			}

		}
		
		private function switchToLeft()
		{ //used for LShoulder
			stage.focus = this.HelpPanel_mc.HelpList_mc;
			SetButtons();
		}
		
		private function switchToRight()
		{ //used for RShoulder
			stage.focus = this.configPanel_mc.configList_mc;
			this.configPanel_mc.configList_mc.selectedIndex = -1;
			this.configPanel_mc.configList_mc.moveSelectionDown();
			this.HelpPanel_mc.HelpList_mc.selectedIndex = selectedPage;
			SetButtons();
		}
		
		public function RefreshMCM():void
		{
			RefreshMCM_internal();
		}
		
		// *********************************
		// =========== UTILITIES ===========
		// *********************************
		
		private function traceObj(obj:Object):void
		{
			for (var id:String in obj)
			{
				var value:Object = obj[id];
				
				if (getQualifiedClassName(value) == "Object")
				{
					trace("-->");
					traceObj(value);
				}
				else
				{
					trace(id + " = " + value);
				}
			}
		}
		
		private function log(str:String):void
		{
			trace("[MCM_Menu] " + str);
		}
		
		private function GetVersionCode():String
		{
			if (!Extensions.isScaleform)
			{
				return String(1);
			}
			return mcmCodeObj.GetMCMVersionCode();
		}
		
		private function GetMCMVersionString():String
		{
			if (!Extensions.isScaleform)
			{
				return String("1.0.0");
			}
			return mcmCodeObj.GetMCMVersionString();
		}
		
		
		static public function Translator(str:String):String
		{
			var translator:TextField = new TextField();
			translator.visible = false;
			if (str == "")
			{
				translator = null;
				return "";
			}
			if (str.charAt(0) != "$")
			{
				translator = null;
				return str;
			}
			GlobalFunc.SetText(translator, str, false);
			str = translator.text;
			translator = null;
			return str;
		}
		
		private function delay(func:Function, params:Array, delay:int = 350, repeat:int = 1):void
		{
			var f:Function;
			var timer:Timer = new Timer(delay, repeat);
			timer.addEventListener(TimerEvent.TIMER, f = function():void
			{
				func.apply(null, params);
				if (timer.currentCount == repeat)
				{
					timer.removeEventListener(TimerEvent.TIMER, f);
					timer = null;
				}
			});
			timer.start();
		}
	
	}

}