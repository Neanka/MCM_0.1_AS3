package Shared.AS3
{
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.MobileButtonHint;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public dynamic class BSButtonHintBar extends BSUIComponent
	{
		
		public var ButtonBracket_Left_mc:MovieClip;
		
		public var ButtonBracket_Right_mc:MovieClip;
		
		public var ShadedBackground_mc:MovieClip;
		
		private var ButtonHintBarInternal_mc:MovieClip;
		
		private var _buttonHintDataV:Vector.<BSButtonHintData>;
		
		private var ButtonPoolV:Vector.<BSButtonHint>;
		
		private var _bRedirectToButtonBarMenu:Boolean = true;
		
		private var _backgroundColor:uint = 0;
		
		private var _backgroundAlpha:Number = 1.0;
		
		private var _bShowBrackets_Override:Boolean = true;
		
		private var _bUseShadedBackground_Override:Boolean = true;
		
		public var SetButtonHintData:Function;
		
		public function BSButtonHintBar()
		{
			this.SetButtonHintData = this.SetButtonHintData_Impl;
			super();
			visible = false;
			this.ButtonHintBarInternal_mc = new MovieClip();
			addChild(this.ButtonHintBarInternal_mc);
			this._buttonHintDataV = new Vector.<BSButtonHintData>();
			this.ButtonPoolV = new Vector.<BSButtonHint>();
		}
		
		public function get bRedirectToButtonBarMenu():Boolean
		{
			return this._bRedirectToButtonBarMenu;
		}
		
		public function set bRedirectToButtonBarMenu(abRedirectToButtonBarMenu:Boolean):*
		{
			if (this._bRedirectToButtonBarMenu != abRedirectToButtonBarMenu)
			{
				this._bRedirectToButtonBarMenu = abRedirectToButtonBarMenu;
				SetIsDirty();
			}
		}
		
		public function get BackgroundColor():uint
		{
			return this._backgroundColor;
		}
		
		public function set BackgroundColor(abBackgroundColor:uint):*
		{
			if (this._backgroundColor != abBackgroundColor)
			{
				this._backgroundColor = abBackgroundColor;
				SetIsDirty();
			}
		}
		
		public function get BackgroundAlpha():Number
		{
			return this._backgroundAlpha;
		}
		
		public function set BackgroundAlpha(abBackgroundAlpha:Number):*
		{
			if (this._backgroundAlpha != abBackgroundAlpha)
			{
				this._backgroundAlpha = abBackgroundAlpha;
			}
		}
		
		override public function get bShowBrackets():Boolean
		{
			return this._bShowBrackets_Override;
		}
		
		override public function set bShowBrackets(abShowBrackets:Boolean):*
		{
			this._bShowBrackets_Override = abShowBrackets;
			SetIsDirty();
		}
		
		override public function get bUseShadedBackground():Boolean
		{
			return this._bUseShadedBackground_Override;
		}
		
		override public function set bUseShadedBackground(abUseShadedBackground:Boolean):*
		{
			this._bUseShadedBackground_Override = abUseShadedBackground;
			SetIsDirty();
		}
		
		private function CanBeVisible():Boolean
		{
			return !this.bRedirectToButtonBarMenu || !bAcquiredByNativeCode;
		}
		
		override public function onAcquiredByNativeCode():*
		{
			var emptyButtonHintDataV:Vector.<BSButtonHintData> = null;
			super.onAcquiredByNativeCode();
			if (this.bRedirectToButtonBarMenu)
			{
				this.SetButtonHintData(this._buttonHintDataV);
				emptyButtonHintDataV = new Vector.<BSButtonHintData>();
				this.SetButtonHintData_Impl(emptyButtonHintDataV);
				SetIsDirty();
			}
		}
		
		private function SetButtonHintData_Impl(abuttonHintDataV:Vector.<BSButtonHintData>):void
		{
			this._buttonHintDataV.forEach(function(item:BSButtonHintData, index:int, vector:Vector.<BSButtonHintData>):*
			{
				if (item)
				{
					item.removeEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
				}
			}, this);
			this._buttonHintDataV = abuttonHintDataV;
			this._buttonHintDataV.forEach(function(item:BSButtonHintData, index:int, vector:Vector.<BSButtonHintData>):*
			{
				if (item)
				{
					item.addEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
				}
			}, this);
			this.CreateButtonHints();
		}
		
		public function onButtonHintDataDirtyEvent(arEvent:Event):void
		{
			SetIsDirty();
		}
		
		private function CreateButtonHints():*
		{
			visible = false;
			while (this.ButtonPoolV.length < this._buttonHintDataV.length)
			{
				if (CompanionAppMode.isOn)
				{
					this.ButtonPoolV.push(new MobileButtonHint());
				}
				else
				{
					this.ButtonPoolV.push(new BSButtonHint());
				}
			}
			for (var i:int = 0; i < this.ButtonPoolV.length; i++)
			{
				this.ButtonPoolV[i].ButtonHintData = i < this._buttonHintDataV.length ? this._buttonHintDataV[i] : null;
			}
			SetIsDirty();
		}
		
		override public function redrawUIComponent():void
		{
			var curButtonHelp:BSButtonHint = null;
			var ourBounds:Rectangle = null;
			var bgGraphics:Graphics = null;
			super.redrawUIComponent();
			if (this.ShadedBackground_mc && contains(this.ShadedBackground_mc))
			{
				removeChild(this.ShadedBackground_mc);
			}
			var bHasVisibleButtons:* = false;
			var nextX:Number = 0;
			var nextRightAlignedX:Number = 0;
			if (CompanionAppMode.isOn)
			{
				nextRightAlignedX = stage.stageWidth - 75;
			}
			for (var i:Number = 0; i < this.ButtonPoolV.length; i++)
			{
				curButtonHelp = this.ButtonPoolV[i];
				if (curButtonHelp.ButtonVisible && this.CanBeVisible())
				{
					bHasVisibleButtons = true;
					if (!this.ButtonHintBarInternal_mc.contains(curButtonHelp))
					{
						this.ButtonHintBarInternal_mc.addChild(curButtonHelp);
					}
					if (curButtonHelp.bIsDirty)
					{
						curButtonHelp.redrawUIComponent();
					}
					if (CompanionAppMode.isOn && curButtonHelp.Justification == BSButtonHint.JUSTIFY_RIGHT)
					{
						nextRightAlignedX = nextRightAlignedX - curButtonHelp.width;
						curButtonHelp.x = nextRightAlignedX;
					}
					else
					{
						curButtonHelp.x = nextX;
						nextX = nextX + (curButtonHelp.width + 20);
					}
				}
				else if (this.ButtonHintBarInternal_mc.contains(curButtonHelp))
				{
					this.ButtonHintBarInternal_mc.removeChild(curButtonHelp);
				}
			}
			if (this.ButtonPoolV.length > this._buttonHintDataV.length)
			{
				this.ButtonPoolV.splice(this._buttonHintDataV.length, this.ButtonPoolV.length - this._buttonHintDataV.length);
			}
			if (!CompanionAppMode.isOn)
			{
				this.ButtonHintBarInternal_mc.x = -this.ButtonHintBarInternal_mc.width / 2;
			}
			var internalBounds:Rectangle = this.ButtonHintBarInternal_mc.getBounds(this);
			this.ButtonBracket_Left_mc.x = internalBounds.left - this.ButtonBracket_Left_mc.width;
			this.ButtonBracket_Right_mc.x = internalBounds.right;
			this.ButtonBracket_Left_mc.visible = this.bShowBrackets && !CompanionAppMode.isOn;
			this.ButtonBracket_Right_mc.visible = this.bShowBrackets && !CompanionAppMode.isOn;
			if (ShadedBackgroundMethod == "Flash" && this.bUseShadedBackground)
			{
				if (!this.ShadedBackground_mc)
				{
					this.ShadedBackground_mc = new MovieClip();
				}
				ourBounds = getBounds(this);
				addChildAt(this.ShadedBackground_mc, 0);
				bgGraphics = this.ShadedBackground_mc.graphics;
				bgGraphics.clear();
				bgGraphics.beginFill(this.BackgroundColor, this.BackgroundAlpha);
				bgGraphics.drawRect(ourBounds.x, ourBounds.y, ourBounds.width, ourBounds.height);
				bgGraphics.endFill();
			}
			visible = bHasVisibleButtons;
		}
	}
}