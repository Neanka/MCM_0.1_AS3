﻿package mcm
{
	
	import Shared.AS3.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class ConfigPanel extends MovieClip
	{
		
		public var configList_mc:mcm.OptionsList;//mcm.ConfigList
		public var HelpPanelBackground_mc:MovieClip;
		public var HelpPanelBrackets_mc:MovieClip;
		public var hint_tf:TextField;
		public var DD_popup_mc:mcm.DD_popup_window;
		public var hotkey_conflict_mc:mcm.hotkey_conflict_window;
		
		public function ConfigPanel()
		{
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.hint_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			setprops();
		}
		
		function setprops()
		{
			try
			{
				this.configList_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.configList_mc.listEntryClass = "mcm.SettingsOptionItem";//mcm.ConfigListEntry
			this.configList_mc.numListItems = 15;
			this.configList_mc.restoreListIndex = false;
			this.configList_mc.textOption = "Multi-Line";
			this.configList_mc.verticalSpacing = 0;
			try
			{
				this.configList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
	
	}

}
