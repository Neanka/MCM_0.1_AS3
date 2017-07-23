// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.ListFilterer

package Shared.AS3
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class ListFilterer extends EventDispatcher 
    {

        public static const FILTER_CHANGE:String = "ListFilterer::filter_change";

        private var iItemFilter:int;
        private var _filterArray:Array;

        public function ListFilterer()
        {
            this.iItemFilter = 0xFFFFFFFF;
        }

        public function get itemFilter():int
        {
            return (this.iItemFilter);
        }

        public function set itemFilter(_arg_1:int)
        {
            var _local_2 = (!((this.iItemFilter == _arg_1)));
            this.iItemFilter = _arg_1;
            if (_local_2 == true)
            {
                dispatchEvent(new Event(FILTER_CHANGE, true, true));
            };
        }

        public function get filterArray():Array
        {
            return (this._filterArray);
        }

        public function set filterArray(_arg_1:Array)
        {
            this._filterArray = _arg_1;
        }

        public function EntryMatchesFilter(_arg_1:Object):Boolean
        {
            return ((((!((_arg_1 == null)))) && ((((!(_arg_1.hasOwnProperty("filterFlag")))) || ((!(((_arg_1.filterFlag & this.iItemFilter) == 0))))))));
        }

        public function GetPrevFilterMatch(_arg_1:int):int
        {
            var _local_3:int;
            var _local_2:int = int.MAX_VALUE;
            if ((((!((_arg_1 == int.MAX_VALUE)))) && ((!((this._filterArray == null))))))
            {
                _local_3 = (_arg_1 - 1);
                while ((((_local_3 >= 0)) && ((_local_2 == int.MAX_VALUE))))
                {
                    if (this.EntryMatchesFilter(this._filterArray[_local_3]))
                    {
                        _local_2 = _local_3;
                    };
                    _local_3--;
                };
            };
            return (_local_2);
        }

        public function GetNextFilterMatch(_arg_1:int):int
        {
            var _local_3:int;
            var _local_2:int = int.MAX_VALUE;
            if ((((!((_arg_1 == int.MAX_VALUE)))) && ((!((this._filterArray == null))))))
            {
                _local_3 = (_arg_1 + 1);
                while ((((_local_3 < this._filterArray.length)) && ((_local_2 == int.MAX_VALUE))))
                {
                    if (this.EntryMatchesFilter(this._filterArray[_local_3]))
                    {
                        _local_2 = _local_3;
                    };
                    _local_3++;
                };
            };
            return (_local_2);
        }

        public function ClampIndex(_arg_1:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:* = _arg_1;
            if ((((((!((_arg_1 == int.MAX_VALUE)))) && ((!((this._filterArray == null)))))) && ((!(this.EntryMatchesFilter(this._filterArray[_local_2]))))))
            {
                _local_3 = this.GetNextFilterMatch(_local_2);
                _local_4 = this.GetPrevFilterMatch(_local_2);
                if (_local_3 != int.MAX_VALUE)
                {
                    _local_2 = _local_3;
                } else
                {
                    if (_local_4 != int.MAX_VALUE)
                    {
                        _local_2 = _local_4;
                    } else
                    {
                        _local_2 = int.MAX_VALUE;
                    };
                };
                if ((((((((((!((_local_3 == int.MAX_VALUE)))) && ((!((_local_4 == int.MAX_VALUE)))))) && ((!((_local_4 == _local_3)))))) && ((_local_2 == _local_3)))) && ((this._filterArray[_local_4].text == this._filterArray[_arg_1].text))))
                {
                    _local_2 = _local_4;
                };
            };
            return (_local_2);
        }

        public function IsFilterEmpty(_arg_1:int):Boolean
        {
            var _local_3:Boolean;
            var _local_2:int = this.iItemFilter;
            this.iItemFilter = _arg_1;
            _local_3 = (this.ClampIndex(0) == int.MAX_VALUE);
            this.iItemFilter = _local_2;
            return (_local_3);
        }


    }
}//package Shared.AS3

