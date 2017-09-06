package mcm
{
	
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.InteractiveObject;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class hotkey_conflict_window extends BSUIComponent
	{
		public var opened:Boolean;
		public var confirmlist_mc:mcm.confirmlist;
		public var confirmtext_tf:TextField;
		private var _sender:InteractiveObject;
		private var _keysarray:Array;
		private var DelayTimer:Timer;
		
		public function hotkey_conflict_window()
		{
			// constructor code
			setprops();
			bShowBrackets = true;
			BracketStyle = "full";
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.confirmtext_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			opened = false;
			visible = false;
			this.confirmlist_mc.disableInput = true;
			this.DelayTimer = new Timer(200, 1);
			this.DelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, DelayTimerAction);
		}
		
		private function DelayTimerAction(e:TimerEvent)
		{
			this.DelayTimer.reset();
			this.confirmlist_mc.disableInput = false;
		}
		
		public function Open(state:int, keys:Array, modname:String, hotkeyAction:String, sender:InteractiveObject)
		{
			MCM_Menu.iMode = MCM_Menu.MCM_CONFLICT_MODE;
			_sender = sender;
			_keysarray = keys;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = true;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = true;
			
			var str:String = "";
			switch (state)
			{
			case 1: 
				this.confirmlist_mc.EntriesA[0].text = "$MCM_KEYBIND_REPLACE";
				this.confirmlist_mc.UpdateList();
				str = MCM_Menu.Translator("$MCM_KEYBIND_IN_USE_MOD_1");
				str += "<br><b>" + modname + "</b><br>";
				str += MCM_Menu.Translator("$MCM_KEYBIND_IN_USE_MOD_2");
				str += "<br><b>" + hotkeyAction + "</b>";
				GlobalFunc.SetText(confirmtext_tf, str, true);
				break;
			case 2: 
				this.confirmlist_mc.EntriesA[0].text = "$MCM_KEYBIND_BIND_ANYWAY";
				this.confirmlist_mc.UpdateList();
				str = MCM_Menu.Translator("$MCM_KEYBIND_IN_USE_GAME_1");
				str += "<br><b>" + MCM_Menu.Translator("$" + hotkeyAction) + "</b><br>";
				str += MCM_Menu.Translator("$MCM_KEYBIND_IN_USE_GAME_2");
				GlobalFunc.SetText(confirmtext_tf, str, true);
				break;
			default: 
			}
			
			visible = true;
			opened = true;
			stage.focus = this.confirmlist_mc;
			this.confirmlist_mc.selectedIndex = 1;
			this.DelayTimer.start();
		}
		
		public function Close(bNoSave:Boolean)
		{
			if (!bNoSave)
			{
				(_sender as mcm.Option_ButtonMapping).EndConfirm(_keysarray);
			}
			else
			{
				(_sender as mcm.Option_ButtonMapping).EndConfirm(null);
			}
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = false;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = false;
			
			stage.focus = MCM_Menu.instance.configPanel_mc.configList_mc;
			_sender = null;
			_keysarray = new Array();
			visible = false;
			opened = false;
			this.confirmlist_mc.disableInput = true;
		}
		
		function setprops()
		{
			try
			{
				this.confirmlist_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.confirmlist_mc.listEntryClass = "mcm.confirm_listentry";
			this.confirmlist_mc.numListItems = 2;
			this.confirmlist_mc.restoreListIndex = false;
			this.confirmlist_mc.textOption = "None";
			this.confirmlist_mc.verticalSpacing = 0;
			try
			{
				this.confirmlist_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
	}

}
