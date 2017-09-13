package mcm
{
	
	import Shared.AS3.BSScrollingList1;
	import Shared.AS3.BSUIComponent;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class confirm_popup extends BSUIComponent
	{
		
		public var confirmtext_tf:TextField;
		public var confirm_popup_list_mc:mcm.confirm_popup_list;
		
		public var opened:Boolean;
		private var _sender:InteractiveObject;
		private var _lastfocus:InteractiveObject;
		
		public function confirm_popup()
		{
			setprops();
			bShowBrackets = true;
			BracketStyle = "full";
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.confirmtext_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			opened = false;
			visible = false;
		}

		public function Open(text: String = "$MCM_CONFIRM_CHANGES", sender: InteractiveObject = null)
		{
			this.confirmtext_tf.text = text;
			this.confirm_popup_list_mc.selectedIndex = 0;
			_lastfocus = stage.focus;
			stage.focus = this.confirm_popup_list_mc;
			_sender = sender;
			visible = true;
			opened = true;
			MCM_Menu.iMode = MCM_Menu.MCM_POSITIONER_CONFIRM_MODE;
			MCM_Menu.instance.POS_WIN.stoplisteners();
		}
		
		public function Close(state:int = 0)
		{
			//stage.focus = MCM_Menu.instance.configPanel_mc.configList_mc;
			switch (state) 
			{
				case 0:
					MCM_Menu.instance.POS_WIN.Close(true);
				break;
				case 1:
					MCM_Menu.instance.POS_WIN.Close(false);
				break;
				case 2:
					MCM_Menu.iMode = MCM_Menu.MCM_POSITIONER_MODE;
					MCM_Menu.instance.POS_WIN.startlisteners();
				break;
				default:
			}
			_sender = null;
			visible = false;
			opened = false;
			stage.focus = _lastfocus;
			_lastfocus = null;
			//this.confirmlist_mc.disableInput = true;
		}
		
		function setprops()
		{
			try
			{
				this.confirm_popup_list_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.confirm_popup_list_mc.listEntryClass = "mcm.confirm_listentry";
			this.confirm_popup_list_mc.numListItems = 3;
			this.confirm_popup_list_mc.restoreListIndex = false;
			this.confirm_popup_list_mc.textOption = "None";
			this.confirm_popup_list_mc.verticalSpacing = 0;
			try
			{
				this.confirm_popup_list_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
	}
}
