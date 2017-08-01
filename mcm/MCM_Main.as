package mcm {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import scaleform.gfx.Extensions;
	
	public class MCM_Main extends MovieClip {
		
		private var done:Boolean = false;
		
		private var MainMenu:MovieClip;
		private var savedMenuProperties:Object = new Object();;
		public var mcmMenu:MCM_Menu = new mcm.MCM_Menu();
		private var mcmCodeObj:Object = new Object();
		
		public function MCM_Main() {
			log("MCM loaded.");
			if (Extensions.isScaleform) {
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			} else {
				log("Not running in-game.");
				addChild(mcmMenu);
			}
		}
		
		private function makeChanges():void {
			MainMenu = stage.getChildAt(0)["Menu_mc"];
			
			savedMenuProperties.LoadPanelBackground_X = MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.x;
			savedMenuProperties.LoadPanelBackground_Y = MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.y;
			savedMenuProperties.LoadPanelBackground_Height = MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.height;
			
			MainMenu["MainPanel_mc"].List_mc.entryList.unshift({
				"text":"MOD CONFIG",
				"index":100
			});
			MainMenu["MainPanel_mc"].List_mc.InvalidateData();
			MainMenu.addEventListener("BSScrollingList::itemPress", itemPressedHandler);
			
			traceObj(MainMenu["MainPanel_mc"].List_mc.entryList);
			
            log("Successfully injected into MainMenu.");
			
			if (stage.getChildAt(0)["mcm"]) {
				mcmCodeObj = stage.getChildAt(0)["mcm"];
				mcmMenu.mcmCodeObj = mcmCodeObj;
				log("MCM native code object registered.");
			} else {
				log("FATAL: MCM native code object not available.");
			}
		}
		
		private function itemPressedHandler(e:Event):void {
			switch (MainMenu.MainPanel_mc.List_mc.selectedEntry.index) {
				case 100:
					// Mod Config
					log("Mod config selected.");
					
					// TEST
					//log("Get Global Value [GameHour]: " + mcmCodeObj.GetGlobalValue("Fallout4.esm|38"));
					//mcmCodeObj.SetGlobalValue("Fallout4.esm|38", Number(0));	// Set gamehour to 0
					//mcmCodeObj.CallGlobalFunction("Debug", "MessageBox", "Hello world!!!");
					//mcmCodeObj.CallQuestFunction("HoloTime.esp|F99", "GiveItems");
					
					MainMenu.MainPanel_mc.visible = false;
					MainMenu.currentState = MainMenu.HELP_STATE;
					
					//MainMenu.BGSCodeObj.SetBackgroundVisible(0, false);		// MAIN_PANEL_BACKGROUND
					//MainMenu.SetToLoading(true);
					//MainMenu.BlackLoading_mc.addChild(new MCM_Menu());
					
					MainMenu.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.getChildAt(0).visible = false;	// Hide existing brackets
					MainMenu.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.addChild(mcmMenu);				// Auto-tint
					MainMenu.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.x = -250;
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.x = -250;
					
					MainMenu.BackgroundAndBrackets_mc.DLCPanelBrackets_mc.y = -250;
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.y = -250;
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.height = mcmMenu.configPanel_mc.height;
					
					MainMenu.setChildIndex(MainMenu.ConfirmPanel_mc,0);
					
					MainMenu.ShowSecondPanelBackground(true, true);
					break;
					
				default:
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.x = savedMenuProperties.LoadPanelBackground_X;
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.y = savedMenuProperties.LoadPanelBackground_Y;
					MainMenu.BackgroundAndBrackets_mc.LoadPanelBackground_mc.height = savedMenuProperties.LoadPanelBackground_Height;
					break;
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			if (!done) {
				var menu:MovieClip = stage.getChildAt(0)["Menu_mc"];
				
				if (menu["MainPanel_mc"].List_mc.entryList.length > 4) {
					done = true;
					if (menu["MainPanel_mc"].List_mc.entryList.length < 8) {
						makeChanges();
					}
				}
			} else {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		// *********************************
		// ===== NATIVE CODE CALLBACKS =====
		// *********************************
		// These functions are called by native code.
		
		public function SetConfigList(configList:Array):void {
			
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
            trace("[MCM] " + str);
        }

	}
	
}
