package mcm
{
	import Shared.AS3.*;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import com.adobe.serialization.json.*;
	import flash.display.DisplayObjectContainer;
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
		static public var MCM_UI_VERSION:uint = 4;
		
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
		private var MCMConfigObject:Object = new Object();
		public var POS_WIN:POS_WINDOW = new POS_WINDOW();
		
		private var standardButtonHintDataV:Vector.<BSButtonHintData>;
		private var ConfirmButton:BSButtonHintData;
		private var CancelButton:BSButtonHintData;
		private var BackButton:BSButtonHintData;
		private var ResetButton:BSButtonHintData;
		//private var ConfigButton:BSButtonHintData;
		//private var SwitchButtonLeft:BSButtonHintData;
		//private var SwitchButtonRight:BSButtonHintData;
		private var POS_Move_Button:BSButtonHintData;
		private var POS_ScaleX_Button:BSButtonHintData;
		private var POS_ScaleY_Button:BSButtonHintData;
		private var POS_Rot_Button:BSButtonHintData;
		private var POS_Alpha_Button:BSButtonHintData;
		
		private var oldModNameForEvent:String = "";
		
		static private var _iMode:uint = 0;
		static public var MCM_MAIN_MODE:uint = 0;
		static public var MCM_REMAP_MODE:uint = 1;
		static public var MCM_CONFLICT_MODE:uint = 2;
		static public var MCM_DD_MODE:uint = 3;
		static public var MCM_POSITIONER_MODE:uint = 4;
		static public var MCM_POSITIONER_CONFIRM_MODE:uint = 5;
		static public var MCM_TEXTINPUT_MODE:uint = 6;
		
		static public var mcmLoaded:Boolean = false;
		
		private var queuedEntries:Array = new Array();
		private var def_w_count:int = 0;					//def_w
		
		public var sharedLists: Object = new Object();
		
		public function MCM_Menu()
		{
			super();
			this.ConfirmButton = new BSButtonHintData("$CONFIRM", "Enter", "PSN_A", "Xenon_A", 1, this.onAcceptPress);
			this.BackButton = new BSButtonHintData("$BACK", "Tab", "PSN_X", "Xenon_X", 1, this.onBackPress);
			this.CancelButton = new BSButtonHintData("$CANCEL", "Esc", "PSN_B", "Xenon_B", 1, this.onCancelPress);
			this.POS_Move_Button = new BSButtonHintData("$MOVE", "LMouse", "s", "s", 1, null);
			this.POS_ScaleX_Button = new BSButtonHintData("$MCM_SCALEX", "Shift-MWheel", "G", "G", 1, null);
			this.POS_ScaleX_Button.SetSecondaryButtons("", "L", "L");
			this.POS_ScaleY_Button = new BSButtonHintData("$MCM_SCALEY", "Ctrl-MWheel", "", "", 1, null);
			this.POS_Rot_Button = new BSButtonHintData("$ROTATE", "Q", "PSN_L2_Alt", "Xenon_L2_Alt", 1, null);
			this.POS_Rot_Button.SetSecondaryButtons("E", "PSN_R2_Alt", "Xenon_R2_Alt");
			this.ResetButton = new BSButtonHintData("$RESET", "T", "PSN_Y", "Xenon_Y", 1, onResetButtonClicked);
			this.POS_Alpha_Button = new BSButtonHintData("$MCM_OPACITY", "Alt-MWheel", "", "", 1, null);
			MCM_Menu._instance = this;
			addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			addEventListener(BSScrollingList1.SELECTION_CHANGE, selectionchanged);
			addEventListener(BSScrollingList1.ITEM_PRESS, this.onListItemPress);
			addEventListener(mcm.Option_ButtonMapping.START_INPUT, this.StartInput);
			addEventListener(mcm.Option_ButtonMapping.END_INPUT, this.EndInput);
			addEventListener(mcm.Option_textinput.START_INPUT, this.StartInput);
			addEventListener(mcm.Option_textinput.END_INPUT, this.EndInput);
			POS_WIN.addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			POS_WIN.addEventListener(BSScrollingList1.ITEM_PRESS, this.onListItemPress);
			
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
		
		public function onResetButtonClicked():void
		{
			switch (iMode)
			{
			case MCM_POSITIONER_MODE: 
				this.POS_WIN.Reset();
				break;
			default: 
			}
		}
		
		public function SetButtons():void
		{
			switch (iMode)
			{
			case MCM_MAIN_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.ResetButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$BACK";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				this.POS_Move_Button.ButtonVisible = false;
				this.POS_ScaleX_Button.ButtonVisible = false;
				this.POS_ScaleY_Button.ButtonVisible = false;
				this.POS_Rot_Button.ButtonVisible = false;
				this.POS_Alpha_Button.ButtonVisible = false;
				break;
			case MCM_REMAP_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$CANCEL";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonText = "$MCM_CLEAR_HOTKEY";
				this.BackButton.ButtonVisible = true;
				break;
			case MCM_CONFLICT_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$CANCEL";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			case MCM_DD_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$BACK";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				break;
			case MCM_POSITIONER_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.ResetButton.ButtonVisible = this.POS_WIN.dataChanged;
				this.CancelButton.ButtonText = "$BACK";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				this.POS_Move_Button.ButtonVisible = this.POS_WIN.allowMove;
				this.POS_ScaleX_Button.ButtonVisible = this.POS_WIN.allowScale;
				this.POS_ScaleX_Button.ButtonText = this.POS_WIN.linkedXYscale ? "$SCALE" : "$MCM_SCALEX";
				this.POS_ScaleY_Button.ButtonVisible = this.POS_WIN.allowScale && !this.POS_WIN.linkedXYscale;
				this.POS_Rot_Button.ButtonVisible = this.POS_WIN.allowRot;
				this.POS_Alpha_Button.ButtonVisible = this.POS_WIN.allowAlpha;
				break;
			case MCM_POSITIONER_CONFIRM_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.ResetButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$CANCEL";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = false;
				this.POS_Move_Button.ButtonVisible = false;
				this.POS_ScaleX_Button.ButtonVisible = false;
				this.POS_ScaleY_Button.ButtonVisible = false;
				this.POS_Rot_Button.ButtonVisible = false;
				this.POS_Alpha_Button.ButtonVisible = false;
				break;
			case MCM_TEXTINPUT_MODE: 
				this.ConfirmButton.ButtonVisible = false;
				this.CancelButton.ButtonText = "$CANCEL";
				this.CancelButton.ButtonVisible = true;
				this.BackButton.ButtonVisible = true;
				this.BackButton.ButtonText = "$MCM_CLEAR"; // TODO: need translation
				break;
			default: 
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.ButtonHintBar_mc = MainMenu.ButtonHintBar_mc;
			MainMenu["BethesdaLogo_mc"].addChild(POS_WIN);
			SetButtons();
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
			case MCM_POSITIONER_MODE: 
				if (this.POS_WIN.dataChanged)
				{
					POS_WIN.CONFIRM_POP.Open();
				}
				else
				{
					POS_WIN.Close(false);
				}
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
			case MCM_TEXTINPUT_MODE: 
				(bmForInput as mcm.Option_textinput).onEscPressed();
				break;
			case MCM_DD_MODE: 
				this.configPanel_mc.DD_popup_mc.Close(true);
				this.configPanel_mc.configList_mc.UpdateList();
				break;
			case MCM_POSITIONER_MODE: 
				if (this.POS_WIN.dataChanged)
				{
					POS_WIN.CONFIRM_POP.Open();
				}
				else
				{
					POS_WIN.Close(false);
				}
				break;
			case MCM_POSITIONER_CONFIRM_MODE: 
				this.POS_WIN.CONFIRM_POP.Close(2);
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
			case MCM_TEXTINPUT_MODE: 
				(bmForInput as mcm.Option_textinput).onTabPressed();
				break;
			default: 
			}
		}
		
		private function onAcceptPress():void
		{
			switch (iMode)
			{
			default: 
			}
		}
		
		public function PopulateButtonBar():void
		{
			this.standardButtonHintDataV = new Vector.<BSButtonHintData>();
			//this.standardButtonHintDataV.push(this.SwitchButtonLeft);
			//this.standardButtonHintDataV.push(this.SwitchButtonRight);	
			this.standardButtonHintDataV.push(this.POS_Move_Button);
			this.standardButtonHintDataV.push(this.POS_ScaleX_Button);
			this.standardButtonHintDataV.push(this.POS_ScaleY_Button);
			this.standardButtonHintDataV.push(this.POS_Rot_Button);
			this.standardButtonHintDataV.push(this.POS_Alpha_Button);
			//this.standardButtonHintDataV.push(this.ConfirmButton);
			this.standardButtonHintDataV.push(this.ResetButton);
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
			var filterFlagControl:uint = 1;// uint.MAX_VALUE;
			for each (var control in obj)
			{
				if (getQualifiedClassName(control) == "Object")
				{
					if (control["valueOptions"])
					{
						if (control["valueOptions"]["sourceType"])
						{
							readValue(control);
							if (control["groupControl"])
							{
								if (control.value == 0)
								{
									filterFlagControl = filterFlagControl & ~Math.pow(2, control["groupControl"]);
								}
								else if (control.value == 1)
								{
									filterFlagControl = filterFlagControl | Math.pow(2, control["groupControl"]);
								}
							}
						}
						if (control["valueOptions"]["clipSource"])
						{
							processPositioner(control);
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
					var orderArray:Array = mcmCodeObj.GetModSettingString("MCM", "sOrder:Main").split(",");
					var newJsonsArray:Array = new Array();
					//if (orderArray.length>0) 
					//{
					var iCounter:int = 1000;
					for each (var name in jsonsArray)
					{
						var iIndex:int = orderArray.indexOf(truncName(name));
						newJsonsArray.push({"name": name, "index": (iIndex > -1) ? iIndex : iCounter});
						//trace("name ", name, "index ", iIndex, "counter ", iCounter);
						iCounter++;
					}
					newJsonsArray.sortOn("index", Array.NUMERIC);
					//traceObj(newJsonsArray);
					//}
					modsNum = jsonsArray.length;
					if (modsNum == 0)
					{
						//this.HelpPanel_mc.HelpList_mc.entryList.push({text: "No supported mods installed"})
						//this.HelpPanel_mc.HelpList_mc.InvalidateData();
						onAllModsLoad();
					}
					else
					{
						for (var i in newJsonsArray)
						{
							JSONLoader("../../" + newJsonsArray[i].name);
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
			case "confirm_popup_list_mc": 
				var yesnocancel:Array = new Array();
				yesnocancel.push({text: "$YES"});
				yesnocancel.push({text: "$NO"});
				yesnocancel.push({text: "$CANCEL"});
				this.POS_WIN.CONFIRM_POP.confirm_popup_list_mc.entryList = yesnocancel;
				this.POS_WIN.CONFIRM_POP.confirm_popup_list_mc.InvalidateData();
				this.POS_WIN.CONFIRM_POP.confirm_popup_list_mc.selectedIndex = 0;
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
					try
					{
						stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuOpen");
					}
					catch (err:Error)
					{
						trace("failed to send OnMCMMenuOpen event");
					}
				}
				else if (this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].hotkeyManager)
				{
					populateHotkeyArray();
					this.configPanel_mc.configList_mc.entryList = processDataObj(hotkeyManagerList, "Hotkey manager");
					this.configPanel_mc.configList_mc.filterer.itemFilter = 1;// uint.MAX_VALUE;
				}
				else
				{
					this.configPanel_mc.configList_mc.entryList = new Array();
					this.configPanel_mc.configList_mc.filterer.itemFilter = 1;// uint.MAX_VALUE;
					GlobalFunc.SetText(this.configPanel_mc.hint_tf, " ", true);
				}
				this.configPanel_mc.configList_mc.InvalidateData();
				
				if (this.HelpPanel_mc.HelpList_mc.selectedEntry.filterFlag == 1)
				{
					if (this.HelpPanel_mc.HelpList_mc.selectedEntry.modName != oldModNameForEvent)
					{
						try
						{
							stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuClose|" + oldModNameForEvent);
						}
						catch (err:Error)
						{
							trace("failed to send OnMCMMenuClose| event");
						}
						oldModNameForEvent = this.HelpPanel_mc.HelpList_mc.selectedEntry.modName;
					}
					try
					{
						stage.getChildAt(0).f4se.SendExternalEvent("OnMCMMenuOpen|" + this.HelpPanel_mc.HelpList_mc.selectedEntry.modName);
					}
					catch (err:Error)
					{
						trace("failed to send OnMCMMenuOpen| event");
					}
					if (this.HelpPanel_mc.HelpList_mc.filterer.modName == this.HelpPanel_mc.HelpList_mc.selectedEntry.modName)
					{
						tryToSelectRightPanel();
					}
					else
					{
						this.HelpPanel_mc.HelpList_mc.filterer.modName = this.HelpPanel_mc.HelpList_mc.selectedEntry.modName;
						this.HelpPanel_mc.HelpList_mc.InvalidateData();
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
			else if (_arg_1.target == this.POS_WIN.CONFIRM_POP.confirm_popup_list_mc)
			{
				this.POS_WIN.CONFIRM_POP.Close(this.POS_WIN.CONFIRM_POP.confirm_popup_list_mc.selectedIndex)
			}
		}
		
		function tryToSelectRightPanel():void
		{
			this.configPanel_mc.configList_mc.InvalidateData();
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
			var loader:MyURLLoader = new MyURLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}
		
		private function onSWFLoaded(event:Event):void
		{
			var path:String = truncName(event.target.url);
			/*if (Extensions.isScaleform)  // no need for game but need for testing in IDE
			   {
			   path = path.substring(0, path.lastIndexOf("\\"));
			   path = path.substring(path.lastIndexOf("\\") + 1);
			   }
			   else
			   {
			   path = path.substring(0, path.lastIndexOf("/"));
			   path = path.substring(path.lastIndexOf("/") + 1);
			   }*/
			swfsobject[path] = (event.target as LoaderInfo).loader;
			try
			{
				(event.target as LoaderInfo).loader.content.onLibLoaded(mcmCodeObj, stage.getChildAt(0).f4se);
			}
			catch (err:Error)
			{
				trace("onLibLoaded function not found in loaded lib", path);
			}
		
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
		
		private function truncName(astr:String):String
		{
			if (Extensions.isScaleform)  // no need for game but need for testing in IDE
			{
				astr = astr.substring(0, astr.lastIndexOf("\\"));
				astr = astr.substring(astr.lastIndexOf("\\") + 1);
			}
			else
			{
				astr = astr.substring(0, astr.lastIndexOf("/"));
				astr = astr.substring(astr.lastIndexOf("/") + 1);
			}
			return astr;
		}
		
		private function decodeJSON(e:Event):void
		{
			try
			{
				var dataObj:Object = com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			}
			catch (err:Error)
			{
				trace("\nERROR PARSE JSON\n" + (e.target as MyURLLoader).url + "\n" + err.message + "\n");
				var errModName:String = (e.target as MyURLLoader).url;
				errModName = truncName(errModName);
				/*if (Extensions.isScaleform)  // no need for game but need for testing in IDE
				   {
				   errModName = errModName.substring(0, errModName.lastIndexOf("\\"));
				   errModName = errModName.substring(errModName.lastIndexOf("\\") + 1);
				   }
				   else
				   {
				   errModName = errModName.substring(0, errModName.lastIndexOf("/"));
				   errModName = errModName.substring(errModName.lastIndexOf("/") + 1);
				   }
				 */
				trace(errModName);
				var errarray:Array = new Array();
				errarray.push({"type": "spacer"});
				errarray.push({"type": "image", "libName": "builtin", "className": "error_icon"});
				errarray.push({"type": "spacer"});
				errarray.push({"text": Translator("$MCM_MENU_LOAD_ERROR"), "align": "center", "type": "text"});
				errarray.push({"type": "spacer"});
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(errarray, errModName), text: errModName, modName: errModName, filterFlag: 1, pageSelected: false, reqsStatus: 2});
				
				checkModsLoad();
				return;
			}
			
			var reqsstatus:Array = new Array();
			var mcmstatus:Boolean = true;
			var modName:String = dataObj["modName"];
			var ownerModName:String = "";
			if (dataObj["sharedLists"]) 
			{
				trace(modName, "using shared libs");
				sharedLists = dataObj["sharedLists"];
			}
			if (dataObj["ownerModName"])
			{
				ownerModName = dataObj["ownerModName"];
				if (ownerModName == "def_w_core") 			//def_w
				{											//def_w
					def_w_count += 1;						//def_w
				}											//def_w
			}
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
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(temparray, dataObj["modName"]), text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false, reqsStatus: 1, numPages: 0});
				this.HelpPanel_mc.HelpList_mc.InvalidateData();
				checkModsLoad();
				return;
			}
			if (ownerModName == "")
			{
				if (dataObj["content"])
				{
					this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(dataObj["content"], dataObj["modName"]), text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false, numPages: 0});
				}
				else
				{
					this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: null, text: displayName, modName: dataObj["modName"], filterFlag: 1, pageSelected: false, numPages: 0});
				}
			}
			var numPages:int = 0;
			var loadedModPos:int = -1;
			for (var i in dataObj["pages"])
			{
				var checkreqsarray:Array = checkreqs(dataObj["pages"][i]);
				if (checkreqsarray.length > 0)
				{
					if (!dataObj["pages"][i].hideIfMissingReqs)
					{
						if (dataObj["pages"][i].messageIfMissingReqs)
						{
							checkreqsarray.push({"text": dataObj["pages"][i].messageIfMissingReqs, "align": "center", "type": "text"});
						}
						if (ownerModName == "")
						{
							this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(checkreqsarray, dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: dataObj["modName"], filterFlag: 2, pageSelected: false});
							numPages += 1;
						}
						else
						{
							loadedModPos = getIndexByModName(this.HelpPanel_mc.HelpList_mc.entryList, ownerModName);
							if (loadedModPos == -1)
							{
								this.queuedEntries.push({dataobj: processDataObj(checkreqsarray, dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: ownerModName, filterFlag: 2, pageSelected: false});
							}
							else
							{
								this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(checkreqsarray, dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: ownerModName, filterFlag: 2, pageSelected: false});
								HelpPanel_mc.HelpList_mc.entryList[loadedModPos].numPages += 1;
							}
						}
					}
				}
				else
				{
					if (ownerModName == "")
					{
						this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(dataObj["pages"][i]["content"], dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: dataObj["modName"], filterFlag: 2, pageSelected: false});
						numPages += 1;
					}
					else
					{
						loadedModPos = getIndexByModName(this.HelpPanel_mc.HelpList_mc.entryList, ownerModName);
						if (loadedModPos == -1)
						{
							this.queuedEntries.push({dataobj: processDataObj(dataObj["pages"][i]["content"], dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: ownerModName, filterFlag: 2, pageSelected: false});
						}
						else
						{
							this.HelpPanel_mc.HelpList_mc.entryList.splice(loadedModPos + HelpPanel_mc.HelpList_mc.entryList[loadedModPos].numPages + 1, 0, {dataobj: processDataObj(dataObj["pages"][i]["content"], dataObj["modName"]), text: dataObj["pages"][i]["pageDisplayName"], modName: dataObj["modName"], ownerModName: ownerModName, filterFlag: 2, pageSelected: false});
							HelpPanel_mc.HelpList_mc.entryList[loadedModPos].numPages += 1;
						}
					}
					
				}
				if (ownerModName != "def_w_core") 
				{
					this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.entryList.length - numPages - 1].numPages = numPages;
				}
			}
			this.HelpPanel_mc.HelpList_mc.InvalidateData();
			checkModsLoad();
			//this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			//onListItemPress(null);
		
		}
		
		function getIndexByModName(array:Array, search:String):int
		{
			for (var i:int = 0; i < array.length; i++)
			{
				if (array[i].modName == search)
				{
					return i;
				}
			}
			return -1;
		}
		
		private function checkreqs(dataObj:Object):Array
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
			var filterFlagControl:uint = 1;// uint.MAX_VALUE;
			var tempObj:Object = dataObj;
			var nameText:String = "";
			for (var num in tempObj)
			{
				if (tempObj[num].text != null)
				{
					if (tempObj[num].textFromFormName)
					{
						nameText = mcmCodeObj.GetFullName(tempObj[num].text);
						if (nameText != "")
						{
							tempObj[num].text = nameText;
						}
					}
					else if (tempObj[num].textFromFormDescription)
					{
						nameText = mcmCodeObj.GetDescription(tempObj[num].text);
						if (nameText != "")
						{
							tempObj[num].text = nameText;
						}
					}
				}
				if (tempObj[num].textFromStringProperty) 
				{
					tempObj[num].text = mcmCodeObj.GetPropertyValueEx(tempObj[num].textFromStringProperty.form, tempObj[num].textFromStringProperty.scriptName, tempObj[num].textFromStringProperty.propertyName);
				}
				else if (tempObj[num].textFromStringArrayProperty) 
				{
					tempObj[num].text = mcmCodeObj.GetPropertyValueEx(tempObj[num].textFromStringArrayProperty.form, tempObj[num].textFromStringArrayProperty.scriptName, tempObj[num].textFromStringArrayProperty.propertyName)[tempObj[num].textFromStringArrayProperty.index];
				}
				if (tempObj[num].help != null)
				{
					if (tempObj[num].helpFromFormName)
					{
						nameText = mcmCodeObj.GetFullName(tempObj[num].help);
						if (nameText != "")
						{
							tempObj[num].help = nameText;
						}
					}
					else if (tempObj[num].helpFromFormDescription)
					{
						nameText = mcmCodeObj.GetDescription(tempObj[num].help);
						if (nameText != "")
						{
							tempObj[num].help = nameText;
						}
					}
				}
				if (tempObj[num].helpFromStringProperty) 
				{
					tempObj[num].help = mcmCodeObj.GetPropertyValueEx(tempObj[num].helpFromStringProperty.form, tempObj[num].helpFromStringProperty.scriptName, tempObj[num].helpFromStringProperty.propertyName);
				}
				else if (tempObj[num].helpFromStringArrayProperty) 
				{
					tempObj[num].help = mcmCodeObj.GetPropertyValueEx(tempObj[num].helpFromStringArrayProperty.form, tempObj[num].helpFromStringArrayProperty.scriptName, tempObj[num].helpFromStringArrayProperty.propertyName)[tempObj[num].helpFromStringArrayProperty.index];
				}
				/*if (tempObj[num].text != null)
				   {
				   nameText = tempObj[num].text;
				   if ((nameText.search(/{GetFullName}/) == 0))
				   {
				   nameText = mcmCodeObj.GetFullName(nameText.replace(/{GetFullName}/, ""));
				   if (nameText != "")
				   {
				   tempObj[num].text = nameText;
				   }
				   }
				   else if ((nameText.search(/{GetDescription}/) == 0))
				   {
				   nameText = mcmCodeObj.GetDescription(nameText.replace(/{GetDescription}/, ""));
				   if (nameText != "")
				   {
				   tempObj[num].text = nameText;
				   }
				   }
				   }
				
				   if (tempObj[num].help != null)
				   {
				   nameText = tempObj[num].help;
				   if ((nameText.search(/{GetFullName}/) == 0))
				   {
				   nameText = mcmCodeObj.GetFullName(nameText.replace(/{GetFullName}/, ""));
				   if (nameText != "")
				   {
				   tempObj[num].help = nameText;
				   }
				   }
				   else if ((nameText.search(/{GetDescription}/) == 0))
				   {
				   nameText = mcmCodeObj.GetDescription(nameText.replace(/{GetDescription}/, ""));
				   if (nameText != "")
				   {
				   tempObj[num].help = nameText;
				   }
				   }
				   }
				 */
				
				//tempObj[num].text = mcmCodeObj.GetFullName(tempObj[num].text);
				
				if (!tempObj[num].modName)
				{
					tempObj[num].modName = modName;
				}
				if (tempObj[num]["valueOptions"])
				{
					if (tempObj[num]["valueOptions"]["sourceType"])
					{
						readValue(tempObj[num]);
						if (tempObj[num]["groupControl"])
						{
							if (tempObj[num].value == 0)
							{
								filterFlagControl = filterFlagControl & ~Math.pow(2, tempObj[num]["groupControl"]);
							}
							else if (tempObj[num].value == 1)
							{
								filterFlagControl = filterFlagControl | Math.pow(2, tempObj[num]["groupControl"]);
							}
						}
					}
					if (tempObj[num]["valueOptions"]["clipSource"])
					{
						processPositioner(tempObj[num]);
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
					if (tempObj[num]["valueOptions"]["sharedOptions"]) 
					{
						tempObj[num].options = sharedLists[tempObj[num]["valueOptions"]["sharedOptions"]];
					}
					else if (tempObj[num].valueOptions.listFromForm) 
					{
						tempObj[num].options = mcmCodeObj.GetListFromForm(tempObj[num].valueOptions.listFromForm);
					}
					else if (tempObj[num].valueOptions.listFromProperty) 
					{
						tempObj[num].options = mcmCodeObj.GetPropertyValueEx(tempObj[num].valueOptions.listFromProperty.form, tempObj[num].valueOptions.listFromProperty.scriptName, tempObj[num].valueOptions.listFromProperty.propertyName);
					}
					else
					{
						tempObj[num].options = tempObj[num]["valueOptions"]["options"];
					}
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
					if (tempObj[num]["valueOptions"]["sharedOptions"]) 
					{
						tempObj[num].options = sharedLists[tempObj[num]["valueOptions"]["sharedOptions"]];
					}
					else if (tempObj[num].valueOptions.listFromForm) 
					{
						tempObj[num].options = mcmCodeObj.GetListFromForm(tempObj[num].valueOptions.listFromForm);
					}
					else if (tempObj[num].valueOptions.listFromProperty) 
					{
						tempObj[num].options = mcmCodeObj.GetPropertyValueEx(tempObj[num].valueOptions.listFromProperty.form, tempObj[num].valueOptions.listFromProperty.scriptName, tempObj[num].valueOptions.listFromProperty.propertyName);
					}
					else 
					{
						tempObj[num].options = tempObj[num]["valueOptions"]["options"];
					}
					break;
				case "dropdownFiles": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_DD_FILES;
					try
					{
						var filesArray:Array = stage.getChildAt(0).f4se.GetDirectoryListing(tempObj[num]["valueOptions"].path, tempObj[num]["valueOptions"].mask);
						var optionsArray:Array = new Array();
						optionsArray.push("None");
						tempObj[num].value = 0;
						var fileName:String = "";
						for (var i:int = 0; i < filesArray.length; i++)
						{
							fileName = filesArray[i].name.substring(filesArray[i].name.lastIndexOf("\\") + 1);
							optionsArray.push(fileName);
							if (fileName == tempObj[num].valueString)
							{
								tempObj[num].value = i + 1;
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
				case "textinputInt": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXTINPUT_INT;
					break;
				case "textinputFloat": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXTINPUT_FLOAT;
					break;
				case "textinput": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXTINPUT_STRING;
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
						else if (tempObj[num]["groupCondition"]["ONLY"])
						{
							tempObj[num].filterOperator = "ONLY";
							tempObj[num].filterFlag = 0;
							for (var n in tempObj[num]["groupCondition"]["ONLY"])
							{
								tempObj[num].filterFlag += Math.pow(2, int(tempObj[num]["groupCondition"]["ONLY"][n]));
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
		
		private function processPositioner(control:Object):void
		{
			if (control.valueOptions.xSource)
			{
				control._x = readFloatValue(control.valueOptions.xSource, control.modName);
			}
			else
			{
				control._x = int.MAX_VALUE;
			}
			if (control.valueOptions.ySource)
			{
				control._y = readFloatValue(control.valueOptions.ySource, control.modName);
			}
			else
			{
				control._y = int.MAX_VALUE;
			}
			if (control.valueOptions.scalexSource)
			{
				control._scalex = readFloatValue(control.valueOptions.scalexSource, control.modName);
			}
			else
			{
				control._scalex = int.MAX_VALUE;
			}
			if (control.valueOptions.scaleySource)
			{
				control._scaley = readFloatValue(control.valueOptions.scaleySource, control.modName);
			}
			else
			{
				control._scaley = int.MAX_VALUE;
			}
			if (control.valueOptions.rotationSource)
			{
				control._rotation = readFloatValue(control.valueOptions.rotationSource, control.modName);
			}
			else
			{
				control._rotation = int.MAX_VALUE;
			}
			if (control.valueOptions.alphaSource)
			{
				control._alpha = readFloatValue(control.valueOptions.alphaSource, control.modName);
			}
			else
			{
				control._alpha = int.MAX_VALUE;
			}
		}
		
		private function readFloatValue(object:Object, modName:String):Number
		{
			var val:* = int.MAX_VALUE;
			switch (object.sourceType)
			{
			case "PropertyValueFloat": 
			case "PropertyValueInt": 
				if (object.scriptName)
				{
					val = mcmCodeObj.GetPropertyValueEx(object.sourceForm, object.scriptName, object.propertyName);
				}
				else
				{
					val = mcmCodeObj.GetPropertyValue(object.sourceForm, object.propertyName);
				}
				break;
			
			case "ModSettingInt": 
				val = mcmCodeObj.GetModSettingInt(modName, object.id);
				break;
			case "ModSettingFloat": 
				val = mcmCodeObj.GetModSettingFloat(modName, object.id);
				break;
			case "GlobalValue": 
				val = mcmCodeObj.GetGlobalValue(object.sourceForm);
				break;
			default: 
			}
			return GlobalFunc.RoundDecimal(val, 2)
		}
		
		public function processPositionerWrite(control:Object):void
		{
			if (control.valueOptions.xSource)
			{
				writeFloatValue(control.valueOptions.xSource, control.modName, control._x);
			}
			if (control.valueOptions.ySource)
			{
				writeFloatValue(control.valueOptions.ySource, control.modName, control._y);
			}
			if (control.valueOptions.scalexSource)
			{
				writeFloatValue(control.valueOptions.scalexSource, control.modName, control._scalex);
			}
			if (control.valueOptions.scaleySource)
			{
				writeFloatValue(control.valueOptions.scaleySource, control.modName, control._scaley);
			}
			if (control.valueOptions.rotationSource)
			{
				writeFloatValue(control.valueOptions.rotationSource, control.modName, control._rotation);
			}
			if (control.valueOptions.alphaSource)
			{
				writeFloatValue(control.valueOptions.alphaSource, control.modName, control._alpha);
			}
		}
		
		private function writeFloatValue(control:Object, modName:String, val:Number):void
		{
			switch (control.sourceType)
			{
			case "PropertyValueFloat": 
				if (control.scriptName)
				{
					mcmCodeObj.SetPropertyValueEx(control.sourceForm, control.scriptName, control.propertyName, val);
				}
				else
				{
					mcmCodeObj.SetPropertyValue(control.sourceForm, control.propertyName, val);
				}
				break;
			case "PropertyValueInt": 
				if (control.scriptName)
				{
					mcmCodeObj.SetPropertyValueEx(control.sourceForm, control.scriptName, control.propertyName, int(val));
				}
				else
				{
					mcmCodeObj.SetPropertyValue(control.sourceForm, control.propertyName, int(val));
				}
				break;
			case "ModSettingInt": 
				mcmCodeObj.SetModSettingInt(modName, control.id, int(val));
				break;
			case "ModSettingFloat": 
				mcmCodeObj.SetModSettingFloat(modName, control.id, val);
				break;
			case "GlobalValue": 
				mcmCodeObj.SetGlobalValue(control.sourceForm, val);
				break;
			default: 
			}
		}
		
		function readValue(control:Object):void
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
					if (control["valueOptions"]["scriptName"])
					{
						control.value = mcmCodeObj.GetPropertyValueEx(control["valueOptions"]["sourceForm"], control["valueOptions"]["scriptName"], control["valueOptions"]["propertyName"]) ? 1 : 0;
					}
					else
					{
						control.value = mcmCodeObj.GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]) ? 1 : 0;
					}
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
					if (control["valueOptions"]["scriptName"])
					{
						control.valueString = mcmCodeObj.GetPropertyValueEx(control["valueOptions"]["sourceForm"], control["valueOptions"]["scriptName"], control["valueOptions"]["propertyName"]);
					}
					else
					{
						control.valueString = mcmCodeObj.GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
					}
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
					if (control["valueOptions"]["scriptName"])
					{
						control.value = mcmCodeObj.GetPropertyValueEx(control["valueOptions"]["sourceForm"], control["valueOptions"]["scriptName"], control["valueOptions"]["propertyName"]);
					}
					else
					{
						control.value = mcmCodeObj.GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
					}
					
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
					if (control["valueOptions"]["scriptName"])
					{
						control.value = mcmCodeObj.GetPropertyValueEx(control["valueOptions"]["sourceForm"], control["valueOptions"]["scriptName"], control["valueOptions"]["propertyName"]);
					}
					else
					{
						control.value = mcmCodeObj.GetPropertyValue(control["valueOptions"]["sourceForm"], control["valueOptions"]["propertyName"]);
					}
				}
				catch (e:Error)
				{
					control.value = 0.0;
					trace("Failed to GetPropertyValueFloat");
				}
				break;
			default: 
			}
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
			//def_w
			if (def_w_count > 0)
			{
				this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: createDefWidgetsEntry(), text: "DEF Mods", modName: "def_w_core", filterFlag: 1, pageSelected: false, numPages: def_w_count});
			}
			//def_w
			if (queuedEntries.length > 0)
			{
				for (var i:int = 0; i < queuedEntries.length; i++)
				{
					var ownerModName:String = queuedEntries[i].ownerModName;
					var loadedModPos:int = getIndexByModName(this.HelpPanel_mc.HelpList_mc.entryList, ownerModName);
					if (loadedModPos == -1)
					{
						//owner mod not loaded
					}
					else
					{
						this.HelpPanel_mc.HelpList_mc.entryList.splice(loadedModPos + HelpPanel_mc.HelpList_mc.entryList[loadedModPos].numPages + 1, 0, queuedEntries[i]);
						HelpPanel_mc.HelpList_mc.entryList[loadedModPos].numPages += 1;
					}
				}
			}
			trace(modsCount + "/" + modsNum + " mod configs loaded");
			this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: createMCMConfigObject(), text: "$MCM_SETTINGS", modName: "MCM", filterFlag: 1, pageSelected: false});
			this.MCMConfigObject = createMCMConfigObject();
			this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: null, text: "$MCM_HOTKEY_MANAGER", modName: "Hotkey manager", hotkeyManager: true, filterFlag: 1, pageSelected: false});
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
		
		//def_w
		private function createDefWidgetsEntry():Object
		{
			var temparray:Array = new Array();
			temparray.push({"type": "text", "text": "<font size=\"40\"><p align = \"center\">DEF Widgets</p></font>", "html": true});
			return processDataObj(temparray);
		}
		
		//def_w
		
		private function createMCMConfigObject():Object
		{
			var temparray:Array = new Array();
			temparray.push({"type": "section", "text": "$MCM_SETTINGS"});
			temparray.push({"id": "iPosition:Main", "type": "slider", "text": "$MCM_MENU_POSITION", "valueOptions": {"min": 1, "max": 8, "step": 1, "sourceType": "ModSettingInt"}});
			temparray.push({"id": "sOrder:Main", "type": "textinput", "text": "$MCM_MENU_MODS_ORDER", "valueOptions": {"sourceType": "ModSettingString"}});
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
			if (iMode == MCM_POSITIONER_MODE)
			{
				this.POS_WIN.ProcessKeyEvent(keyCode, isDown);
			}
			else if (iMode == MCM_POSITIONER_CONFIRM_MODE)
			{
				if (!isDown && (keyCode == Keyboard.TAB || keyCode == Keyboard.ESCAPE))
				{
					this.POS_WIN.CONFIRM_POP.Close(2);
				}
			}
			else if (bmForInput)
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
					default: 
					}
				}
			}
			//log("Key event! keyCode: " + keyCode + " isDown: " + isDown);
		}
		
		public function ProcessUserEvent(controlName:String, isDown:Boolean, deviceType:int):void
		{
			//log("User event! controlName: " + controlName + " isDown: " + isDown+ " deviceType: " + deviceType);
			if (!isDown && deviceType == 2)
			{
				switch (controlName)
				{
				case "Cancel": 
					onCancelPress();
					break;
				case "LShoulder": 
					LShoulderPressed();
					break;
				case "RShoulder": 
					RShoulderPressed();
					break;
				case "LTrigger": 
					LTriggerPressed();
					break;
				case "RTrigger": 
					RTriggerPressed();
					break;
				case "ResetToDefault": 
					onResetButtonClicked();
					break;
				case "Up": 
					ProcessKeyEvent(Keyboard.W, false)
					break;
				case "Down": 
					ProcessKeyEvent(Keyboard.S, false)
					break;
				case "Left": 
					ProcessKeyEvent(Keyboard.A, false)
					break;
				case "Right": 
					ProcessKeyEvent(Keyboard.D, false)
					break;
				default: 
				}
				
			}
		
		}
		
		public function RTriggerPressed():void
		{
			if (iMode == MCM_POSITIONER_MODE)
			{
				POS_WIN.ProcessKeyEvent(Keyboard.E, false)
			}
		}
		
		public function LTriggerPressed():void
		{
			if (iMode == MCM_POSITIONER_MODE)
			{
				POS_WIN.ProcessKeyEvent(Keyboard.Q, false)
			}
		}
		
		private function LShoulderPressed()
		{ //used for LShoulder switchToLeft
			if (iMode == MCM_MAIN_MODE)
			{
				stage.focus = this.HelpPanel_mc.HelpList_mc;
				SetButtons();
			}
			else if (iMode == MCM_POSITIONER_MODE)
			{
				POS_WIN.fscalex(-1);
				if (!POS_WIN.linkedXYscale)
				{
					POS_WIN.fscaley(-1);
				}
			}
		}
		
		private function RShoulderPressed()
		{ //used for RShoulder switchToRight
			if (iMode == MCM_MAIN_MODE)
			{
				stage.focus = this.configPanel_mc.configList_mc;
				this.configPanel_mc.configList_mc.selectedIndex = -1;
				this.configPanel_mc.configList_mc.moveSelectionDown();
				this.HelpPanel_mc.HelpList_mc.selectedIndex = selectedPage;
				SetButtons();
			}
			else if (iMode == MCM_POSITIONER_MODE)
			{
				POS_WIN.fscalex(1);
				if (!POS_WIN.linkedXYscale)
				{
					POS_WIN.fscaley(1);
				}
			}
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
		
		public static function traceDisplayObject(dOC:DisplayObjectContainer, recursionLevel:int = 0)
		{
			var numCh = dOC.numChildren;
			for (var i = 0; i < numCh; i++)
			{
				var child = dOC.getChildAt(i);
				var indentation:String = "";
				for (var j:int = 0; j < recursionLevel; j++)
				{
					indentation += "----";
				}
				trace(indentation + "[" + i + "] " + child.name + " Alpha: " + child.alpha + " Visible: " + child.visible + " " + child);
				
				if (getQualifiedClassName(child) == "Object")
				{
					traceObj(child);
				}
				
				if (child is DisplayObjectContainer && child.numChildren > 0)
				{
					traceDisplayObject(child, recursionLevel + 1);
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
		
		public static function RoundDecimal(aNumber:Number, aPrecision:int = 2):String
		{
			var i:int = Math.pow(10, aPrecision);
			var str:String = String(Math.round(aNumber * i) / i);
			var idx:int = str.lastIndexOf('.');
			if (idx == -1) return str;
			return str.substring(0, idx + aPrecision + 1);
		}
	
	}

}