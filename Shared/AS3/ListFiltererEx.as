package Shared.AS3 {
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class ListFiltererEx extends EventDispatcher {

		public static const FILTER_CHANGE: String = "ListFiltererEx::filter_change";
		public static const FILTER_TYPE_DEFAULT: int = 0;
		public static const FILTER_TYPE_LEFTPANEL: int = 1;


		private var iItemFilter: int;
		
		private var _iFilterType: int;
		private var _sModName: String;

		private var iItemFilterString: String;

		private var _filterArray: Array;

		public function ListFiltererEx() {
			super();
			this.iItemFilter = uint.MAX_VALUE;//4294967295;
			this._iFilterType = FILTER_TYPE_DEFAULT;
			this._sModName = "";
			this.iItemFilterString = "";
		}
		
		

		public function get itemFilter(): int {
			return this.iItemFilter;
		}

		public function set itemFilter(param1: int): * {
			var _loc2_: * = this.iItemFilter != param1;
			this.iItemFilter = param1;
			if (_loc2_ == true) {
				dispatchEvent(new Event(FILTER_CHANGE, true, true));
			}
		}

		public function get itemFilterString(): String {
			return this.iItemFilterString;
		}

		public function set itemFilterString(param1: String): * {
			var _loc2_: * = this.iItemFilterString != param1;
			this.iItemFilterString = param1;
			if (_loc2_ == true) {
				dispatchEvent(new Event(FILTER_CHANGE, true, true));
			}
		}

		public function get filterArray(): Array {
			return this._filterArray;
		}

		public function set filterArray(param1: Array): * {
			this._filterArray = param1;
		}
		
		public function get filterType():int 
		{
			return _iFilterType;
		}
		
		public function set filterType(value:int):void 
		{
			_iFilterType = value;
		}
		
		public function get modName(): String {
			return this._sModName;
		}

		public function set modName(param1: String): * {
			var _loc2_: * = this._sModName != param1;
			this._sModName = param1;
			if (_loc2_ == true) {
				dispatchEvent(new Event(FILTER_CHANGE, true, true));
			}
		}

		private function checktext(param1: Object): Boolean {
			if (this.iItemFilterString == "") {
				return true;
			}
			if (param1.text.toUpperCase().search(this.iItemFilterString.toUpperCase()) > -1) {
				return true;
			}
			return false;
		}

		public function EntryMatchesFilter(param1: Object): Boolean {
			if (_iFilterType == FILTER_TYPE_LEFTPANEL) 
			{
				if (param1 != null && param1.hasOwnProperty("ownerModName")) 
				{
					return (param1.ownerModName == _sModName);
				}
			}
			if (param1 != null && param1.hasOwnProperty("filterOperator")) 
			{
				if (param1.filterOperator == "AND") {
					return param1 != null && (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag & this.iItemFilter) == param1.filterFlag) && this.checktext(param1);
				} else if (param1.filterOperator == "OR") 
				{
					return param1 != null && (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag & this.iItemFilter) != 0) && this.checktext(param1);
				} else if (param1.filterOperator == "ONLY") 
				{
					return param1 != null && (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag == (this.iItemFilter & ~1))) && this.checktext(param1);
				}
			} else 
			{
				return param1 != null && (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag & this.iItemFilter) != 0) && this.checktext(param1);
			}

			
		}

		public function GetPrevFilterMatch(param1: int): int {
			var _loc2_: int = 0;
			var _loc3_: int = int.MAX_VALUE;
			if (param1 != int.MAX_VALUE && this._filterArray != null) {
				_loc2_ = param1 - 1;
				while (_loc2_ >= 0 && _loc3_ == int.MAX_VALUE) {
					if (this.EntryMatchesFilter(this._filterArray[_loc2_])) {
						_loc3_ = _loc2_;
					}
					_loc2_--;
				}
			}
			return _loc3_;
		}

		public function GetNextFilterMatch(param1: int): int {
			var _loc2_: int = 0;
			var _loc3_: int = int.MAX_VALUE;
			if (param1 != int.MAX_VALUE && this._filterArray != null) {
				_loc2_ = param1 + 1;
				while (_loc2_ < this._filterArray.length && _loc3_ == int.MAX_VALUE) {
					if (this.EntryMatchesFilter(this._filterArray[_loc2_])) {
						_loc3_ = _loc2_;
					}
					_loc2_++;
				}
			}
			return _loc3_;
		}

		public function ClampIndex(param1: int): int {
			var _loc2_: int = 0;
			var _loc3_: int = 0;
			var _loc4_: * = param1;
			if (param1 != int.MAX_VALUE && this._filterArray != null && !this.EntryMatchesFilter(this._filterArray[_loc4_])) {
				_loc2_ = this.GetNextFilterMatch(_loc4_);
				_loc3_ = this.GetPrevFilterMatch(_loc4_);
				if (_loc2_ != int.MAX_VALUE) {
					_loc4_ = _loc2_;
				} else if (_loc3_ != int.MAX_VALUE) {
					_loc4_ = _loc3_;
				} else {
					_loc4_ = int.MAX_VALUE;
				}
				if (_loc2_ != int.MAX_VALUE && _loc3_ != int.MAX_VALUE && _loc3_ != _loc2_ && _loc4_ == _loc2_ && this._filterArray[_loc3_].text == this._filterArray[param1].text) {
					_loc4_ = _loc3_;
				}
			}
			return _loc4_;
		}

		public function IsFilterEmpty(param1: int): Boolean {
			var _loc2_: * = false;
			var _loc3_: int = this.iItemFilter;
			this.iItemFilter = param1;
			_loc2_ = this.ClampIndex(0) == int.MAX_VALUE;
			this.iItemFilter = _loc3_;
			return _loc2_;
		}
	}
}