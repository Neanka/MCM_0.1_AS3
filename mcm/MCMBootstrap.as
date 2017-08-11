package mcm {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.*;
	
	
	public class MCMBootstrap extends MovieClip {
		
		private var MCM_INDEX:int = 100;
		
		private var MainMenu:MovieClip;
		
		public function MCMBootstrap() {
			trace("mcmm");
			log("MCM loaded.");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			log("Added to stage.");
			if (!stage.getChildAt(0).hasOwnProperty("Menu_mc")) {
				log("FAILED: Not injected into MainMenu.");
				return;
			}
			MainMenu = stage.getChildAt(0)["Menu_mc"] as MovieClip;
			if (getQualifiedClassName(MainMenu) == "MainMenu") {
				makeChanges();
			} else {
				log("FAILED: Not injected into MainMenu.");
			}
		}
		
		private function makeChanges():void {
            log("Successfully injected into MainMenu.");
			
			// Create the MCM object on the root.
			//MainMenu["MCM"] = this;
			
			trace(MainMenu);
			trace(MainMenu.MainPanel_mc);
			
			MainMenu.MainPanel_mc.List_mc.entryList.unshift({
				"text":"Mod Configuration",
				"index":MCM_INDEX
			});
			MainMenu.MainPanel_mc.List_mc.InvalidateData();
		}
		
		// Utility functions
        private function log(str:String):void {
            trace("[MCM] " + str);
        }
		
		private function traceDisplayObject(dOC:DisplayObjectContainer, recursionLevel:int=0) {
			var numCh = dOC.numChildren;
			for(var i = 0; i < numCh; i++) {
                var child = dOC.getChildAt(i);
                var indentation:String = "";
                for (var j:int=0; j<recursionLevel; j++) {
                    indentation += "----";
                }
                trace(indentation + "[" + i + "] " + child.name + " Visible: " + child.visible + " " + child);
				
				if (getQualifiedClassName(child) == "Object") { 
					traceObj(child);
				}

                if (child is DisplayObjectContainer && child.numChildren > 0) {
                    traceDisplayObject(child, recursionLevel+1);
                }
            }
        }
		
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

	}
	
}
