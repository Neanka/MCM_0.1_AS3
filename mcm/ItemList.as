package mcm
{
	import flash.display.*;
	import flash.events.*;
	import Shared.AS3.*;

	public class ItemList extends BSScrollingList1
	{
		public static const MOUSE_OVER: String = "ItemList::mouse_over";

		public function ItemList()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
		}
		private function onMouseOver(event: MouseEvent)
		{
			dispatchEvent(new Event(MOUSE_OVER, true, true));
		}
	}
}