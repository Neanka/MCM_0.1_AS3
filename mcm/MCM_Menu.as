package mcm
{
	import Shared.AS3.*;
	import Shared.GlobalFunc;
	import com.adobe.serialization.json.*;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
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
		public var selectedPage: int;
		public var swfsobject: Object = new Object;
		
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
				this.HelpPanel_mc.HelpList_mc.filterer.filterType = ListFiltererEx.FILTER_TYPE_LEFTPANEL;
				this.HelpPanel_mc.HelpList_mc.filterer.itemFilter = 1;
				loadLibs(); //TODO find best place to call
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
					trace("Failed to GetDirectoryListing for JSON");
					JSONLoader("../../Data/MCM/Config/testmod.json");
					JSONLoader("../../Data/MCM/Config/testmod2.json");
					JSONLoader("../../Data/MCM/Config/testmod3.json");
					JSONLoader("../../Data/MCM/Config/testmod33.json");
				}
				
				break;
			case "configList_mc": 
				this.configPanel_mc.configList_mc.InvalidateData();
				loadWelcomePage();
				break;
			default: 
			}
		}
		
		private function loadWelcomePage():void 
		{
			var temparray: Array = new Array();
			temparray.push({
				"type": "empty"
			});
			temparray.push({
				"type": "image",
				"libName": "builtin",
				"className": "img_builtin_mcmlogo"
			});
			temparray.push({
				"type": "empty"
			});
			temparray.push({
				"text": "                                                            MCM FALLOUT 4 EDITION",
				"type": "text"
			});
			temparray.push({
				"text": "                                                                        VERSION 0.5",
				"type": "text"
			});
			this.configPanel_mc.configList_mc.entryList = processDataObj(temparray);
			this.configPanel_mc.configList_mc.InvalidateData();
		}
		
		function loadLibs():void 
		{
			try
			{
				var swfsArray:Array = root.f4se.GetDirectoryListing("Data/MCM/Libs", "*.swf", recursive = false);
				for (var i in swfsArray)
				{
					var swfloader: Loader = new Loader();
					swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFLoaded,false,0,true);
					swfloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
					swfloader.load(new URLRequest("../../" + swfsArray[i]["nativePath"]));
				}
			}
			catch (e:Error)
			{
				trace("Failed to GetDirectoryListing for Libs");
					var swfloader1: Loader = new Loader();
					swfloader1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFLoaded,false,0,true);
					swfloader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
					swfloader1.load(new URLRequest("../../Data/MCM/Libs/testmod_lib.swf"));
					var swfloader2: Loader = new Loader();
					swfloader2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFLoaded,false,0,true);
					swfloader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOSWFErrorHandler);
					swfloader2.load(new URLRequest("../../Data/MCM/Libs/testmod.swf"));
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
			else if (_arg_1.target == this.HelpPanel_mc.HelpList_mc)
			{
				for each (var obj in this.HelpPanel_mc.HelpList_mc.entryList)
				{
					obj.pageSelected = false;
				}
				this.HelpPanel_mc.HelpList_mc.selectedEntry.pageSelected = true;
				this.configPanel_mc.configList_mc.selectedIndex = -1;
				this.selectedPage = this.HelpPanel_mc.HelpList_mc.selectedIndex;
				if (this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj) 
				{
					this.configPanel_mc.configList_mc.entryList = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj;
					this.configPanel_mc.configList_mc.filterer.itemFilter = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["filterFlagControl"];
				} else 
				{
					this.configPanel_mc.configList_mc.entryList = new Array();
					this.configPanel_mc.configList_mc.filterer.itemFilter = uint.MAX_VALUE;
					GlobalFunc.SetText(this.configPanel_mc.hint_tf, " ", true);
				}
				this.configPanel_mc.configList_mc.InvalidateData();
				this.configPanel_mc.configList_mc.selectedIndex = 0;
				if (this.HelpPanel_mc.HelpList_mc.selectedEntry.filterFlag == 1) 
				{
					this.HelpPanel_mc.HelpList_mc.filterer.modName = this.HelpPanel_mc.HelpList_mc.selectedEntry.modName;
				}
				this.HelpPanel_mc.HelpList_mc.UpdateList();	
			}
		}
		
		public function JSONLoader(filename:String)
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}
		
		private function onSWFLoaded(event:Event) : void
		{
			var path: String = event.target.url;
			path = path.substring(path.lastIndexOf("/") + 1); // no need for game but need for testing in IDE
			path = path.substring(path.lastIndexOf("\\") + 1);
			path = path.substring(0, path.lastIndexOf("."));
			swfsobject[path] = (event.target as LoaderInfo).applicationDomain;
		}
		
		public function getMcFromLib(libname: String, classname: String): MovieClip 
		{
			var myClass: Class;
			if (libname == "builtin") 
			{
				myClass = getDefinitionByName(classname);
			} else 
			{
				myClass = swfsobject[libname].getDefinition(classname) as Class;
			}
			return new myClass() as MovieClip;

		}
	  
		private function IOSWFErrorHandler(errorEvent:IOErrorEvent):void{
			trace(errorEvent.text);
		}
		
		private function decodeJSON(e:Event):void
		{
			var dataObj:Object = com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			if (dataObj["content"]) 
			{
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				dataobj: processDataObj(dataObj["content"]), 
				text: dataObj["modName"], 
				modName: dataObj["modName"], 
				filterFlag: 1,
				pageSelected: false
				
			});
			} else 
			{
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				dataobj: null, 
				text: dataObj["modName"], 
				modName: dataObj["modName"], 
				filterFlag: 1,
				pageSelected: false
				
			});
			}
			for (var i in dataObj["pages"]) 
			{
				this.HelpPanel_mc.HelpList_mc.entryList.push({
					dataobj: processDataObj(dataObj["pages"][i]["content"]), 
					text: dataObj["pages"][i].pageName, 
					ownerModName: dataObj["modName"], 
					filterFlag: 2,
					pageSelected: false
				});
			}

			this.HelpPanel_mc.HelpList_mc.InvalidateData();
			
			//this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			//onListItemPress(null);
		
		}
		
		private function processDataObj(dataObj:Object):Object
		{
			var tempObj:Object = dataObj;
			for (var num in tempObj)
			{
				if (tempObj[num]["action"])
				{
					switch (tempObj[num]["action"]["type"])
					{
					case "GlobalValue": 
						try
						{
							tempObj[num].value = mcmCodeObj.GetGlobalValue(tempObj[num]["action"]["params"]);
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
							tempObj[num].valueString = mcmCodeObj.GetModSettingString(tempObj[num]["action"]["modName"],tempObj[num]["action"]["settingName"]);
						}
						catch (e:Error)
						{
							tempObj[num].valueString = " ";
							trace("Failed to GetModSettingString");
						}
						break;
					default: 
						tempObj[num].value = 5; // temp value just for test
						break;
					}
					
				}
				
				switch (tempObj[num]["type"])
				{
				case "switcher": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SWITCHER;
					break;
				case "stepper": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_STEPPER;
					tempObj[num].options = tempObj[num]["valueOptions"];
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
				case "empty": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
					break;
				case "dropdown": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_DROPDOWN;
					tempObj[num].options = tempObj[num]["valueOptions"];
					break;
				case "text": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_TEXT;
					break;
				case "button": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_BUTTON;
					break;
				case "keyinput": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_KEYINPUT;
					tempObj[num].defaultkeys = tempObj[num]["valueOptions"]["default"];
					if (!tempObj[num].valueString || tempObj[num].valueString == " ") 
					{
						tempObj[num].keys = tempObj[num].defaultkeys
					}
					else 
					{
						tempObj[num].keys = tempObj[num].valueString.split(",");
					}
					break;
				case "image": 
					tempObj[num].movieType = mcm.SettingsOptionItem.MOVIETYPE_IMAGE;
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
				
					//traceObj(tempObj[num]);
				
			}
			tempObj.filterFlagControl = uint.MAX_VALUE;
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