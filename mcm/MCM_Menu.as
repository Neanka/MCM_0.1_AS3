package mcm {
	import flash.display.MovieClip;
	import Shared.AS3.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 */
	public class MCM_Menu extends MovieClip {
		
		
		public var configPanel_mc:mcm.ConfigPanel;
		public var HelpPanel_mc:mcm.LeftPanel;
		public var ButtonHintBar_mc: Shared.AS3.BSButtonHintBar;
		public var mods: Array;
		
		public function MCM_Menu() {
			mods = new Array();
			super();
			addEventListener(BSScrollingList1.LIST_ITEMS_CREATED, listcreated);
			addEventListener(BSScrollingList1.SELECTION_CHANGE, selectionchanged);
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
			log(param1.target.name + " selectionchanged");
			switch (param1.target.name){
				case "HelpList_mc":
					this.configPanel_mc.configList_mc.selectedIndex = -1;
					this.configPanel_mc.configList_mc.entryList = mods[this.HelpPanel_mc.HelpList_mc.selectedIndex]["content"];
					this.configPanel_mc.configList_mc.InvalidateData();
					this.configPanel_mc.configList_mc.selectedIndex = 0;
					break;
				case "configList_mc":
				if (this.configPanel_mc.configList_mc.selectedIndex > -1) {
					//this.configPanel_mc.hint_tf.text = this.configPanel_mc.configList_mc.entryList[this.configPanel_mc.configList_mc.selectedIndex].help;
					stage.focus = this.configPanel_mc.configList_mc;
					}
					break;
				default:
			}
		}
		
		public function JSONLoader(filename: String) {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, decodeJSON);
			loader.load(new URLRequest(filename));
		}

		private function decodeJSON(e:Event):void {
			var dataObj:Object= com.adobe.serialization.json.JSON.decode(e.target.data) as Object;
			traceObj(dataObj);
			mods.push(dataObj);
			this.HelpPanel_mc.HelpList_mc.entryList.push({
				text: dataObj["modName"]
			})
			this.HelpPanel_mc.HelpList_mc.InvalidateData();


			
			this.HelpPanel_mc.HelpList_mc.selectedIndex = 0;
			

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