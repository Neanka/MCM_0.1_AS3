package mcm
{
	import Shared.AS3.*;
	import Shared.GlobalFunc;
	import com.adobe.serialization.json.*;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 */
	public class MCM_Menu extends MovieClip
	{
		
		public var configPanel_mc:mcm.ConfigPanel;
		public var HelpPanel_mc:mcm.LeftPanel;
		public var ButtonHintBar_mc:Shared.AS3.BSButtonHintBar;
		public var mcmCodeObj:Object = new Object();
		public var bmForInput:InteractiveObject = null;
		private static var _instance:mcm.MCM_Menu;
		
		public function MCM_Menu()
		{
			super();
			MCM_Menu._instance = this;
			addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			addEventListener(BSScrollingList1.SELECTION_CHANGE, selectionchanged);
			addEventListener(BSScrollingList1.ITEM_PRESS, this.onListItemPress);
			addEventListener(mcm.Option_ButtonMapping.START_INPUT, this.StartInput);
			addEventListener(mcm.Option_ButtonMapping.END_INPUT, this.EndInput);
		}
		
		private function StartInput(e:Event):void 
		{
			try
			{
				bmForInput = e.target;
				mcmCodeObj.StartKeyCapture();
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
				bmForInput = null; //TODO separate null and stopkeycapture
				mcmCodeObj.StopKeyCapture();
			}
			catch (e:Error)
			{
				trace("Failed to StopKeyCapture");
			}
		}
		
		public function ProcessKeyEvent(keyCode:int, isDown:Boolean):void {
			if (bmForInput) 
			{
				bmForInput.ProcessKeyEvent(keyCode, isDown);
			}
			//log("Key event! keyCode: " + keyCode + " isDown: " + isDown);
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			configPanel_mc.hint_tf.text = "PROCESS USER EVENT: " + param1 + " state: " + param2;
		}
		
		public static function get instance():MCM_Menu
		{
			return _instance;
		}
		
		function listcreated(param1:Event)
		{
			log(param1.target.name + " created");
			switch (param1.target.name)
			{
			case "HelpList_mc": 
				try
				{
					var jsonsArray:Array = root.f4se.GetDirectoryListing("Data/MCM/Config", "*.json", recursive = false);
					if (jsonsArray.length == 0)
					{
						this.HelpPanel_mc.HelpList_mc.entryList.push({text: "No supported mods installed"})
						this.HelpPanel_mc.HelpList_mc.InvalidateData();
					}
					else
					{
						for (var i in jsonsArray)
						{
							JSONLoader("../../" + jsonsArray[i]["nativePath"]);
						}
					}
				}
				catch (e:Error)
				{
					trace("Failed to GetDirectoryListing");
					JSONLoader("../../Data/MCM/Config/testmod.json");
					JSONLoader("../../Data/MCM/Config/testmod2.json");
				}
				
				break;
			case "configList_mc": 
				this.configPanel_mc.configList_mc.InvalidateData();
				break;
			default: 
			}
		}
		
		function selectionchanged(param1:Event)
		{
			switch (param1.target)
			{
			case this.HelpPanel_mc.HelpList_mc: 
				this.configPanel_mc.configList_mc.selectedIndex = -1;
				this.configPanel_mc.configList_mc.entryList = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["content"];
				this.configPanel_mc.configList_mc.filterer.itemFilter = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["filterFlagControl"];
				this.configPanel_mc.configList_mc.InvalidateData();
				this.configPanel_mc.configList_mc.selectedIndex = 0;
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
					
					stage.focus = this.configPanel_mc.configList_mc; // temp string
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
		}
		
		public function JSONLoader(filename:String)
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}
		
		private function decodeJSON(e:Event):void
		{
			var dataObj:Object = com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			this.HelpPanel_mc.HelpList_mc.entryList.push({dataobj: processDataObj(dataObj), text: dataObj["modName"]})
			this.HelpPanel_mc.HelpList_mc.InvalidateData();
			
			this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
		
		}
		
		private function processDataObj(dataObj:Object):Object
		{
			var tempObj:Object = dataObj;
			tempObj.filterFlagControl = uint.MAX_VALUE;
			for (var num in tempObj["content"])
			{
				if (tempObj["content"][num]["action"])
				{
					switch (tempObj["content"][num]["action"]["type"])
					{
					case "GlobalValue": 
						try
						{
							tempObj["content"][num].value = mcmCodeObj.GetGlobalValue(tempObj["content"][num]["action"]["params"]);
						}
						catch (e:Error)
						{
							tempObj["content"][num].value = 0;
							trace("Failed to GetGlobalValue");
						}
						break;
					case "ModSettingString": 
						try
						{
							tempObj["content"][num].valueString = mcmCodeObj.GetModSettingString(tempObj["content"][num]["action"]["modName"],tempObj["content"][num]["action"]["settingName"]);
						}
						catch (e:Error)
						{
							tempObj["content"][num].valueString = " ";
							trace("Failed to GetModSettingString");
						}
						break;
					default: 
						tempObj["content"][num].value = 5; // temp value just for test
						break;
					}
					
				}
				
				switch (tempObj["content"][num]["type"])
				{
				case "switcher": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SWITCHER;
					break;
				case "stepper": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_STEPPER;
					tempObj["content"][num].options = tempObj["content"][num]["valueOptions"];
					break;
				case "slider": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SCROLLBAR;
					tempObj["content"][num].minvalue = tempObj["content"][num]["valueOptions"].min;
					tempObj["content"][num].maxvalue = tempObj["content"][num]["valueOptions"].max;
					tempObj["content"][num].step = tempObj["content"][num]["valueOptions"].step;
					break;
				case "section": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SECTION;
					break;
				case "empty": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
					break;
				case "dropdown": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_DROPDOWN;
					tempObj["content"][num].options = tempObj["content"][num]["valueOptions"];
					break;
				case "text": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXT;
					break;
				case "button": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_BUTTON;
					break;
				case "keyinput": 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_KEYINPUT;
					tempObj["content"][num].defaultkeys = tempObj["content"][num]["valueOptions"]["default"];
					if (!tempObj["content"][num].valueString || tempObj["content"][num].valueString == " ") 
					{
						tempObj["content"][num].keys = tempObj["content"][num].defaultkeys
					}
					else 
					{
						tempObj["content"][num].keys = tempObj["content"][num].valueString.split(",");
					}
					break;
				default: 
					tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
					break;
				}
				
				if (tempObj["content"][num]["groupCondition"])
				{
					switch (getQualifiedClassName(tempObj["content"][num]["groupCondition"]))
					{
					case "int": 
						tempObj["content"][num].filterOperator = "OR";
						tempObj["content"][num].filterFlag = Math.pow(2, int(tempObj["content"][num]["groupCondition"]));
						break;
					case "Array": 
						tempObj["content"][num].filterOperator = "OR";
						tempObj["content"][num].filterFlag = 0;
						for (var j in tempObj["content"][num]["groupCondition"])
						{
							tempObj["content"][num].filterFlag += Math.pow(2, int(tempObj["content"][num]["groupCondition"][j]));
						}
						break;
					case "Object": 
						if (tempObj["content"][num]["groupCondition"]["AND"])
						{
							tempObj["content"][num].filterOperator = "AND";
							tempObj["content"][num].filterFlag = 0;
							for (var k in tempObj["content"][num]["groupCondition"]["AND"])
							{
								tempObj["content"][num].filterFlag += Math.pow(2, int(tempObj["content"][num]["groupCondition"]["AND"][k]));
							}
						}
						else if (tempObj["content"][num]["groupCondition"]["OR"])
						{
							tempObj["content"][num].filterOperator = "OR";
							tempObj["content"][num].filterFlag = 0;
							for (var m in tempObj["content"][num]["groupCondition"]["OR"])
							{
								tempObj["content"][num].filterFlag += Math.pow(2, int(tempObj["content"][num]["groupCondition"]["OR"][m]));
							}
						}
						break;
					default: 
						tempObj["content"][num].filterOperator = "OR";
						tempObj["content"][num].filterFlag = 1;
						break;
					}
				}
				else
				{
					tempObj["content"][num].filterOperator = "OR";
					tempObj["content"][num].filterFlag = 1;
				}
				
					//traceObj(tempObj["content"][num]);
				
			}
			
			return tempObj;
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
	
	}

}