package mcm
{
	import Shared.AS3.BSScrollingList1;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ItemList extends BSScrollingList1
	{
		public static const MOUSE_OVER:String = "ItemList::mouse_over";
		public static const MOUSE_OUT:String = "ItemList::mouse_out";
		
		public function ItemList()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
		}
		
		private function onMouseOver(event:MouseEvent)
		{
			dispatchEvent(new Event(MOUSE_OVER, true, true));
			//stage.focus = this; //TODO: THIS IS PRETTY BAD THING FOR KB NAVIGATION!
		}
		
		private function onMouseOut(event:MouseEvent)
		{
			dispatchEvent(new Event(MOUSE_OUT, true, true));
			if (this.name == "HelpList_mc")
			{
				//this.selectedIndex = MCM_Menu.instance.selectedPage; // caused bug: scroll to selected index on mouse move
			}
		}
	}
}
