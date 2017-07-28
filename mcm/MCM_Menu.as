package mcm {
	import flash.display.MovieClip;
	import Shared.AS3.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import com.adobe.serialization.json.*;
	import Shared.GlobalFunc;
	
	/**
	 * ...
	 */
	public class MCM_Menu extends MovieClip {
		
		
		public var configPanel_mc:mcm.ConfigPanel;
		public var HelpPanel_mc:mcm.LeftPanel;
		public var ButtonHintBar_mc: Shared.AS3.BSButtonHintBar;
		public var mcmCodeObj:Object = new Object();
		
		public function MCM_Menu() {
			super();
			addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			addEventListener(BSScrollingList1.SELECTION_CHANGE, selectionchanged);
			addEventListener(BSScrollingList1.ITEM_PRESS, this.onListItemPress);
		}
		
		function listcreated(param1: Event){
			log(param1.target.name + " created");
			switch (param1.target.name){
				case "HelpList_mc":
					try
					{
						var jsonsArray: Array = root.f4se.GetDirectoryListing("Data/MCM/Config", "*.json", recursive=false);
						if (jsonsArray.length == 0) {
							this.HelpPanel_mc.HelpList_mc.entryList.push({
								text: "No supported mods installed"
							})
							this.HelpPanel_mc.HelpList_mc.InvalidateData();
						} else {
							for (var i in jsonsArray){
								JSONLoader("../../"+jsonsArray[i]["nativePath"]);
							}
						}
					}
					catch(e:Error)
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
		
		function selectionchanged(param1: Event){
			switch (param1.target){
				case this.HelpPanel_mc.HelpList_mc:
					this.configPanel_mc.configList_mc.selectedIndex = -1;
					this.configPanel_mc.configList_mc.entryList = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["content"];
					this.configPanel_mc.configList_mc.filterer.itemFilter = this.HelpPanel_mc.HelpList_mc.entryList[this.HelpPanel_mc.HelpList_mc.selectedIndex].dataobj["filterFlagControl"];
					this.configPanel_mc.configList_mc.InvalidateData();
					this.configPanel_mc.configList_mc.selectedIndex = 0;
					break;
				case this.configPanel_mc.configList_mc:
					if (this.configPanel_mc.configList_mc.selectedIndex > -1) {
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
		}
		
		public function JSONLoader(filename: String) {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}

		private function decodeJSON(e:Event):void {
			var dataObj:Object= com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				dataobj: processDataObj(dataObj),
				text: dataObj["modName"]
			})
			this.HelpPanel_mc.HelpList_mc.InvalidateData();

			
			this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			

		}
		
		private function processDataObj(dataObj: Object) : Object {
			var tempObj: Object = dataObj;
			tempObj.filterFlagControl = uint.MAX_VALUE;
			for (var num in tempObj["content"]){
				switch (tempObj["content"][num]["type"]){
					case "checkbox":
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_CB;
						break;
					case "stepper":
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_STEPPER;
						break;
					case "slider":
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SCROLLBAR;
						break;
					case "section":
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_SECTION;
						break;
					case "empty":
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
						break;
					default:
						tempObj["content"][num].movieType = mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE;
						break;
				}
				
				switch (tempObj["content"][num]["action"]){
					case "GameSettingBool":
						try 
						{
							tempObj["content"][num].value = root.f4se.plugins.def_plugin.GetGSBool(tempObj["content"][num]["id"]);
						}
						catch(e:Error)
						{
							tempObj["content"][num].value = 0;
							trace("Failed to GetGSBool");
						}
						break;
					case "GlobalValue":
						try 
						{
							tempObj["content"][num].value = mcmCodeObj.GetGlobalValue(tempObj["content"][num]["actionparams"]);
						}
						catch(e:Error)
						{
							tempObj["content"][num].value = 0;
							trace("Failed to GetGlobalValue");
						}
						break;
					default:
						tempObj["content"][num].value = 5; // temp value just for test
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
							for (var j in tempObj["content"][num]["groupCondition"]){
								tempObj["content"][num].filterFlag += Math.pow(2, int(tempObj["content"][num]["groupCondition"][j]));
							}							
							break;
						case "Object":
							if (tempObj["content"][num]["groupCondition"]["AND"]) 
							{
								tempObj["content"][num].filterOperator = "AND";
								tempObj["content"][num].filterFlag = 0;
								for (var k in tempObj["content"][num]["groupCondition"]["AND"]){
									tempObj["content"][num].filterFlag += Math.pow(2, int(tempObj["content"][num]["groupCondition"]["AND"][k]));
								}								
							}
							else if (tempObj["content"][num]["groupCondition"]["OR"]) 
							{
								tempObj["content"][num].filterOperator = "OR";
								tempObj["content"][num].filterFlag = 0;
								for (var m in tempObj["content"][num]["groupCondition"]["OR"]){
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
		
		private function traceObj(obj:Object):void {
			for(var id:String in obj) {
				var value:Object = obj[id];
				
				if (getQualifiedClassName(value) == "Object") {
					trace("-->");
					traceObj(value);
				} else {
					trace(id + " = " + value);
				}
			}
        }
		
        private function log(str:String):void {
            trace("[MCM_Menu] " + str);
        }
		

	}

}