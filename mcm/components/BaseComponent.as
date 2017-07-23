package mcm.components {
	
	/**
	 * The base class for all menu components.
	 */
	public class BaseComponent extends Sprite {
		private var _id:String;
		private var _value:*;
		
		public function BaseComponent(id:String) {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get value():* {
			return _value;
		}
	}
}