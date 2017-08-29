package Shared.AS3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public dynamic class BSButtonHintData extends EventDispatcher
	{
		
		public static const BUTTON_HINT_DATA_CHANGE:String = "ButtonHintDataChange";
		
		private var _strButtonText:String;
		
		private var _strPCKey:String;
		
		private var _strPSNButton:String;
		
		private var _strXenonButton:String;
		
		private var _uiJustification:uint;
		
		private var _callbackFunction:Function;
		
		private var _bButtonDisabled:Boolean;
		
		private var _bSecondaryButtonDisabled:Boolean;
		
		private var _bButtonVisible:Boolean;
		
		private var _bButtonFlashing:Boolean;
		
		private var _hasSecondaryButton:Boolean;
		
		private var _strSecondaryPCKey:String;
		
		private var _strSecondaryXenonButton:String;
		
		private var _strSecondaryPSNButton:String;
		
		private var _secondaryButtonCallback:Function;
		
		private var _strDynamicMovieClipName:String;
		
		public var onAnnounceDataChange:Function;
		
		public var onTextClick:Function;
		
		public var onSecondaryButtonClick:Function;
		
		public function BSButtonHintData(astrButtonText:String, astrPCKey:String, astrPSNButton:String, astrXenonButton:String, auiJustification:uint, aFunction:Function)
		{
			this.onAnnounceDataChange = this.onAnnounceDataChange_Impl;
			this.onTextClick = this.onTextClick_Impl;
			this.onSecondaryButtonClick = this.onSecondaryButtonClick_Impl;
			super();
			this._strPCKey = astrPCKey;
			this._strButtonText = astrButtonText;
			this._strXenonButton = astrXenonButton;
			this._strPSNButton = astrPSNButton;
			this._uiJustification = auiJustification;
			this._callbackFunction = aFunction;
			this._bButtonDisabled = false;
			this._bButtonVisible = true;
			this._bButtonFlashing = false;
			this._hasSecondaryButton = false;
			this._strSecondaryPCKey = "";
			this._strSecondaryPSNButton = "";
			this._strSecondaryXenonButton = "";
			this._secondaryButtonCallback = null;
			this._strDynamicMovieClipName = "";
		}
		
		public function get PCKey():String
		{
			return this._strPCKey;
		}
		
		public function get PSNButton():String
		{
			return this._strPSNButton;
		}
		
		public function get XenonButton():String
		{
			return this._strXenonButton;
		}
		
		public function get Justification():uint
		{
			return this._uiJustification;
		}
		
		public function get SecondaryPCKey():String
		{
			return this._strSecondaryPCKey;
		}
		
		public function get SecondaryPSNButton():String
		{
			return this._strSecondaryPSNButton;
		}
		
		public function get SecondaryXenonButton():String
		{
			return this._strSecondaryXenonButton;
		}
		
		public function get DynamicMovieClipName():String
		{
			return this._strDynamicMovieClipName;
		}
		
		public function set DynamicMovieClipName(aDynamicMovieClipName:String):void
		{
			if (this._strDynamicMovieClipName != aDynamicMovieClipName)
			{
				this._strDynamicMovieClipName = aDynamicMovieClipName;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonDisabled():Boolean
		{
			return this._bButtonDisabled;
		}
		
		public function set ButtonDisabled(abButtonDisabled:Boolean):*
		{
			if (this._bButtonDisabled != abButtonDisabled)
			{
				this._bButtonDisabled = abButtonDisabled;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonEnabled():Boolean
		{
			return !this.ButtonDisabled;
		}
		
		public function set ButtonEnabled(abButtonEnabled:Boolean):void
		{
			this.ButtonDisabled = !abButtonEnabled;
		}
		
		public function get SecondaryButtonDisabled():Boolean
		{
			return this._bSecondaryButtonDisabled;
		}
		
		public function set SecondaryButtonDisabled(abSecondaryButtonDisabled:Boolean):*
		{
			if (this._bSecondaryButtonDisabled != abSecondaryButtonDisabled)
			{
				this._bSecondaryButtonDisabled = abSecondaryButtonDisabled;
				this.AnnounceDataChange();
			}
		}
		
		public function get SecondaryButtonEnabled():Boolean
		{
			return !this.SecondaryButtonDisabled;
		}
		
		public function set SecondaryButtonEnabled(abSecondaryButtonEnabled:Boolean):void
		{
			this.SecondaryButtonDisabled = !abSecondaryButtonEnabled;
		}
		
		public function get ButtonText():String
		{
			return this._strButtonText;
		}
		
		public function set ButtonText(astrButtonText:String):void
		{
			if (this._strButtonText != astrButtonText)
			{
				this._strButtonText = astrButtonText;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonVisible():Boolean
		{
			return this._bButtonVisible;
		}
		
		public function set ButtonVisible(abButtonVisible:Boolean):void
		{
			if (this._bButtonVisible != abButtonVisible)
			{
				this._bButtonVisible = abButtonVisible;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonFlashing():Boolean
		{
			return this._bButtonFlashing;
		}
		
		public function set ButtonFlashing(abButtonFlashing:Boolean):void
		{
			if (this._bButtonFlashing != abButtonFlashing)
			{
				this._bButtonFlashing = abButtonFlashing;
				this.AnnounceDataChange();
			}
		}
		
		public function get hasSecondaryButton():Boolean
		{
			return this._hasSecondaryButton;
		}
		
		private function AnnounceDataChange():void
		{
			dispatchEvent(new Event(BUTTON_HINT_DATA_CHANGE));
			if (this.onAnnounceDataChange is Function)
			{
				this.onAnnounceDataChange();
			}
		}
		
		private function onAnnounceDataChange_Impl():void
		{
		}
		
		public function SetButtons(astrPCKey:String, astrPSNButton:String, astrXenonButton:String):*
		{
			var buttonChange:Boolean = false;
			if (this._strPCKey != astrPCKey)
			{
				this._strPCKey = astrPCKey;
				buttonChange = true;
			}
			if (this._strPSNButton != astrPSNButton)
			{
				this._strPSNButton = astrPSNButton;
				buttonChange = true;
			}
			if (this._strXenonButton != astrXenonButton)
			{
				this._strXenonButton = astrXenonButton;
				buttonChange = true;
			}
			if (buttonChange)
			{
				this.AnnounceDataChange();
			}
		}
		
		public function SetSecondaryButtons(astrSecondaryPCKey:String, astrSecondaryPSNButton:String, astrSecondaryXenonButton:String):*
		{
			this._hasSecondaryButton = true;
			var buttonChange:Boolean = false;
			if (this._strSecondaryPCKey != astrSecondaryPCKey)
			{
				this._strSecondaryPCKey = astrSecondaryPCKey;
				buttonChange = true;
			}
			if (this._strSecondaryPSNButton != astrSecondaryPSNButton)
			{
				this._strSecondaryPSNButton = astrSecondaryPSNButton;
				buttonChange = true;
			}
			if (this._strSecondaryXenonButton != astrSecondaryXenonButton)
			{
				this._strSecondaryXenonButton = astrSecondaryXenonButton;
				buttonChange = true;
			}
			if (buttonChange)
			{
				this.AnnounceDataChange();
			}
		}
		
		public function set secondaryButtonCallback(aSecondaryFunction:Function):*
		{
			this._secondaryButtonCallback = aSecondaryFunction;
		}
		
		private function onTextClick_Impl():void
		{
			if (this._callbackFunction is Function)
			{
				this._callbackFunction.call();
			}
		}
		
		private function onSecondaryButtonClick_Impl():void
		{
			if (this._secondaryButtonCallback is Function)
			{
				this._secondaryButtonCallback.call();
			}
		}
	}
}