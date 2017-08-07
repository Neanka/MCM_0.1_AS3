package mcm
{
	import flash.display.MovieClip;
	import Shared.AS3.*;

	public class LeftPanel extends MovieClip
	{
		public var HelpList_mc: mcm.EntryList;
		public var background_mc: MovieClip;
		public var HelpListBrackets_mc: MovieClip;

		public function LeftPanel()
		{
			setprops();
		}

		function setprops()
		{
			try
			{
				this.HelpList_mc["componentInspectorSetting"] = true;
			}
			catch (e: Error)
			{
			}
			this.HelpList_mc.listEntryClass = "mcm.UniversalListEntry";
			this.HelpList_mc.numListItems = 18;
			this.HelpList_mc.restoreListIndex = false;
			this.HelpList_mc.textOption = "None";
			this.HelpList_mc.verticalSpacing = 0;
			try
			{
				this.HelpList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e: Error)
			{
				return;
			}
		}
	}
}