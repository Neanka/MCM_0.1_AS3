package mcm
{
	
	import Shared.AS3.BSUIComponent;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import Shared.GlobalFunc;
	
	public class hotkey_conflict_window extends BSUIComponent
	{
		public var opened:Boolean;
		public var confirmlist_mc:mcm.confirmlist;
		public var confirmtext_tf: TextField;
		private var _sender: InteractiveObject;
		private var _keysarray: Array;
		
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
		}
		
		public function Open(state: int, keys: Array, modname: String, hotkeyAction: String, sender: InteractiveObject)
		{
			_sender = sender;
			_keysarray = keys;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = true;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = true;
			var str: String = "";
			switch (state) 
			{
				case 1:
					this.confirmlist_mc.EntriesA[0].text = "$Replace Keybind";
					this.confirmlist_mc.UpdateList();
					str = MCM_Menu.Translator("$This key is in use by the following mod:");
					str += "<br><b>" + modname + "</b><br>";
					str += MCM_Menu.Translator("$for the following action:");
					str += "<br><b>" + hotkeyAction + "</b>";
					GlobalFunc.SetText(confirmtext_tf, str, true);
				break;
			case 2:
					this.confirmlist_mc.EntriesA[0].text = "$Bind Anyway";
					this.confirmlist_mc.UpdateList();
					str = MCM_Menu.Translator("$Warning: this key is in use for the following game action:");
					str += "<br><b>" + MCM_Menu.Translator("$"+hotkeyAction) + "</b><br>";
					str += MCM_Menu.Translator("$You may choose to bind the key anyway, but doing so will result in multiple actions when the key is pressed.");
					GlobalFunc.SetText(confirmtext_tf, str, true);
				break;
				default:
			}
			
			visible = true;
			opened = true;
			stage.focus = this.confirmlist_mc;
		}
		
		public function Close(bNoSave: Boolean)
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
