// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSReversedScrollingList

package Shared.AS3
{
    public class BSReversedScrollingList extends BSScrollingList 
    {

        private var fTopY:Number;

        public function BSReversedScrollingList()
        {
            this.fTopY = 0;
        }

        public function get topmostY():Number
        {
            return (this.fTopY);
        }

        override protected function PositionEntries()
        {
            var _local_4:BSScrollingListEntry;
            var _local_1:Number = 0;
            var _local_2:Number = (border.y + border.height);
            this.fTopY = _local_2;
            var _local_3:int = (iListItemsShown - 1);
            while (_local_3 >= 0)
            {
                _local_4 = GetClipByIndex(_local_3);
                _local_4.y = ((_local_2 - _local_1) - _local_4.height);
                _local_1 = (_local_1 + (_local_4.height + fVerticalSpacing));
                if (_local_4.itemIndex != int.MAX_VALUE)
                {
                    this.fTopY = _local_4.y;
                };
                _local_3--;
            };
        }


    }
}//package Shared.AS3

