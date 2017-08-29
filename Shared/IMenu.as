package Shared
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class IMenu extends MovieClip
	{
		
		private var _uiPlatform:uint;
		
		private var _bPS3Switch:Boolean;
		
		private var _bRestoreLostFocus:Boolean;
		
		private var safeX:Number = 0.0;
		
		private var safeY:Number = 0.0;
		
		private var textFieldSizeMap:Object;
		
		public function IMenu()
		{
			this.textFieldSizeMap = new Object();
			super();
			this._uiPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			this._bPS3Switch = false;
			this._bRestoreLostFocus = false;
			GlobalFunc.MaintainTextFormat();
			addEventListener(Event.ADDED_TO_STAGE, this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onStageDestruct);
			addEventListener(PlatformRequestEvent.PLATFORM_REQUEST, this.onPlatformRequestEvent, true);
		}
		
		public function get uiPlatform():uint
		{
			return this._uiPlatform;
		}
		
		public function get bPS3Switch():Boolean
		{
			return this._bPS3Switch;
		}
		
		public function get SafeX():Number
		{
			return this.safeX;
		}
		
		public function get SafeY():Number
		{
			return this.safeY;
		}
		
		protected function onPlatformRequestEvent(arEvent:Event):*
		{
			if (this.uiPlatform != PlatformChangeEvent.PLATFORM_INVALID)
			{
				(arEvent as PlatformRequestEvent).RespondToRequest(this.uiPlatform, this.bPS3Switch);
			}
		}
		
		protected function onStageInit(event:Event):*
		{
			stage.stageFocusRect = false;
			stage.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
		}
		
		protected function onStageDestruct(event:Event):*
		{
			stage.removeEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
			stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
		}
		
		public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean):*
		{
			this._uiPlatform = auiPlatform;
			this._bPS3Switch = this.bPS3Switch;
			dispatchEvent(new PlatformChangeEvent(this.uiPlatform, this.bPS3Switch));
		}
		
		public function SetSafeRect(aSafeX:Number, aSafeY:Number):*
		{
			this.safeX = aSafeX;
			this.safeY = aSafeY;
			this.onSetSafeRect();
		}
		
		protected function onSetSafeRect():void
		{
		}
		
		private function onFocusLost(event:FocusEvent):*
		{
			if (this._bRestoreLostFocus)
			{
				this._bRestoreLostFocus = false;
				stage.focus = event.target as InteractiveObject;
			}
		}
		
		protected function onMouseFocus(event:FocusEvent):*
		{
			if (event.target == null || !(event.target is InteractiveObject))
			{
				stage.focus = null;
			}
			else
			{
				this._bRestoreLostFocus = true;
			}
		}
		
		public function ShrinkFontToFit(textField:TextField, amaxScrollV:int):*
		{
			var tfSize:int = 0;
			var textFormat:TextFormat = textField.getTextFormat();
			if (this.textFieldSizeMap[textField] == null)
			{
				this.textFieldSizeMap[textField] = textFormat.size;
			}
			textFormat.size = this.textFieldSizeMap[textField];
			textField.setTextFormat(textFormat);
			var maxVScroll:int = textField.maxScrollV;
			while (maxVScroll > amaxScrollV && textFormat.size > 4)
			{
				tfSize = textFormat.size as int;
				textFormat.size = tfSize - 1;
				textField.setTextFormat(textFormat);
				maxVScroll = textField.maxScrollV;
			}
		}
	}
}