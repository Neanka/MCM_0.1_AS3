package mcm
{
	import Shared.AS3.BSUIComponent;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class DD_popup_window extends MovieClip
	{

		public var opened: Boolean;
		public var DD_popup_list_mc: mcm.DD_popup_list;
		public var dd_popup_bg_mc: BSUIComponent;
		private var _target: InteractiveObject;

		public function DD_popup_window()
		{
			super();
			setprops();
			opened = false;
			visible = false;
		}

		public function Open(aTarget: InteractiveObject)
		{
			_target = aTarget;
			listprocedures();
			visible = true;
			opened = true;
			stage.focus = this.DD_popup_list_mc;

			if (aTarget.localToGlobal(new Point(0, 0)).y < 280)
			{
				this.y = parent.globalToLocal(aTarget.localToGlobal(new Point(0, 0))).y + aTarget.height + 2;
			}
			else
			{
				this.y = parent.globalToLocal(aTarget.localToGlobal(new Point(0, 0))).y - 2 - this.dd_popup_bg_mc.height;
			}
		}

		public function Close(bNoSave: Boolean)
		{
			if (!bNoSave)
			{
				_target.index = this.DD_popup_list_mc.selectedIndex;
				_target.dispatchEvent(new Event(Option_DropDown.VALUE_CHANGE, true, true));
			}
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = false;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = false;
			stage.focus = MCM_Menu.instance.configPanel_mc.configList_mc;
			_target = null;
			visible = false;
			opened = false;
		}

		function listprocedures(): *
		{
			this.DD_popup_list_mc.InvalidateData();
			this.dd_popup_bg_mc.height = 12 + this.DD_popup_list_mc.itemsShown * 28;
			this.DD_popup_list_mc.UpdateList();
			this.DD_popup_list_mc.selectedIndex = _target.index; //this.DD_popup_list_mc.GetEntryFromClipIndex(0);
			stage.focus = this.DD_popup_list_mc;
		}

		function setprops()
		{
			try
			{
				this.DD_popup_list_mc["componentInspectorSetting"] = true;
			}
			catch (e: Error)
			{}
			this.DD_popup_list_mc.listEntryClass = "mcm.DD_popup_list_entry";
			this.DD_popup_list_mc.numListItems = 7;
			this.DD_popup_list_mc.restoreListIndex = false;
			this.DD_popup_list_mc.textOption = "None";
			this.DD_popup_list_mc.verticalSpacing = 0;
			try
			{
				this.DD_popup_list_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e: Error)
			{
				return;
			}
		}
	}
}