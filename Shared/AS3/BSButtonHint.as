package Shared.AS3
{
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	public dynamic class BSButtonHint extends BSUIComponent
	{
		
		private static const DISABLED_GREY_OUT_ALPHA:Number = 0.5;
		
		public static const JUSTIFY_RIGHT:uint = 0;
		
		public static const JUSTIFY_LEFT:uint = 1;
		
		private static const DYNAMIC_MOVIE_CLIP_BUFFER = 3;
		
		private static const NameToTextMap:Object = {"Xenon_A": "A", "Xenon_B": "B", "Xenon_X": "C", "Xenon_Y": "D", "Xenon_Select": "E", "Xenon_LS": "F", "Xenon_L1": "G", "Xenon_L3": "H", "Xenon_L2": "I", "Xenon_L2R2": "J", "Xenon_RS": "K", "Xenon_R1": "L", "Xenon_R3": "M", "Xenon_R2": "N", "Xenon_Start": "O", "_Positive": "P", "_Negative": "Q", "_Question": "R", "_Neutral": "S", "Left": "T", "Right": "U", "Down": "V", "Up": "W", "Xenon_R2_Alt": "X", "Xenon_L2_Alt": "Y", "PSN_A": "a", "PSN_Y": "b", "PSN_X": "c", "PSN_B": "d", "PSN_Select": "z", "PSN_L3": "f", "PSN_L1": "g", "PSN_L1R1": "h", "PSN_LS": "i", "PSN_L2": "j", "PSN_L2R2": "k", "PSN_R3": "l", "PSN_R1": "m", "PSN_RS": "n", "PSN_R2": "o", "PSN_Start": "p", "_DPad_LR": "q", "_DPad_UD": "r", "_DPad_Left": "t", "_DPad_Right": "u", "_DPad_Down": "v", "_DPad_Up": "w", "PSN_R2_Alt": "x", "PSN_L2_Alt": "y"};
		
		public var textField_tf:TextField;
		
		public var IconHolderInstance:MovieClip;
		
		public var SecondaryIconHolderInstance:MovieClip;
		
		private var _hitArea:Sprite;
		
		private var DynamicMovieClip:MovieClip;
		
		private var bButtonFlashing:Boolean;
		
		private var _strCurrentDynamicMovieClipName:String;
		
		private var _DyanmicMovieHeight:Number;
		
		private var _DynamicMovieY:Number;
		
		private var _buttonHintData:BSButtonHintData;
		
		var _bButtonPressed:Boolean = false;
		
		var _bMouseOver:Boolean = false;
		
		public function BSButtonHint()
		{
			super();
			visible = false;
			mouseChildren = false;
			this.bButtonFlashing = false;
			this._strCurrentDynamicMovieClipName = "";
			this.DynamicMovieClip = null;
			this._DyanmicMovieHeight = this.textField_tf.height;
			this._DynamicMovieY = this.textField_tf.y;
			this.SetUpTextFields(this.textField_tf);
			this.SetUpTextFields(this.IconHolderInstance.IconAnimInstance.Icon_tf);
			this.SetUpTextFields(this.SecondaryIconHolderInstance.IconAnimInstance.Icon_tf);
			this._hitArea = new Sprite();
			this._hitArea.graphics.beginFill(0);
			this._hitArea.graphics.drawRect(0, 0, 1, 1);
			this._hitArea.graphics.endFill();
			this._hitArea.visible = false;
			this._hitArea.mouseEnabled = false;
			addEventListener(MouseEvent.CLICK, this.onTextClick);
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
		}
		
		public function set ButtonHintData(value:BSButtonHintData):void
		{
			if (this._buttonHintData)
			{
				this._buttonHintData.removeEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
			}
			this._buttonHintData = value;
			if (this._buttonHintData)
			{
				this._buttonHintData.addEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
			}
			SetIsDirty();
		}
		
		private function onButtonHintDataDirtyEvent(arEvent:Event):void
		{
			SetIsDirty();
		}
		
		public function get PCKey():String
		{
			if (this._buttonHintData.PCKey)
			{
				return this.Justification == JUSTIFY_LEFT ? this._buttonHintData.PCKey + ")" : "(" + this._buttonHintData.PCKey;
			}
			return "";
		}
		
		public function get SecondaryPCKey():String
		{
			if (this._buttonHintData.SecondaryPCKey)
			{
				return "(" + this._buttonHintData.SecondaryPCKey;
			}
			return "";
		}
		
		private function get UsePCKey():Boolean
		{
			return iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && !NameToTextMap.hasOwnProperty(this._buttonHintData.PCKey);
		}
		
		public function get ControllerButton():String
		{
			var controllerButtonName:String = "";
			if (iPlatform != PlatformChangeEvent.PLATFORM_MOBILE && this.UsePCKey)
			{
				controllerButtonName = this.PCKey;
			}
			else
			{
				switch (iPlatform)
				{
				case PlatformChangeEvent.PLATFORM_PC_KB_MOUSE: 
					controllerButtonName = this._buttonHintData.PCKey;
					break;
				case PlatformChangeEvent.PLATFORM_PC_GAMEPAD: 
				case PlatformChangeEvent.PLATFORM_XB1: 
				default: 
					controllerButtonName = this._buttonHintData.XenonButton;
					break;
				case PlatformChangeEvent.PLATFORM_PS4: 
					controllerButtonName = this._buttonHintData.PSNButton;
					break;
				case PlatformChangeEvent.PLATFORM_MOBILE: 
					controllerButtonName = "";
				}
				if (NameToTextMap.hasOwnProperty(controllerButtonName))
				{
					controllerButtonName = NameToTextMap[controllerButtonName];
				}
			}
			return controllerButtonName;
		}
		
		public function get SecondaryControllerButton():String
		{
			var controllerButtonName:String = "";
			if (this._buttonHintData.hasSecondaryButton)
			{
				if (iPlatform != PlatformChangeEvent.PLATFORM_MOBILE && this.UsePCKey)
				{
					controllerButtonName = this.SecondaryPCKey;
				}
				else
				{
					switch (iPlatform)
					{
					case PlatformChangeEvent.PLATFORM_PC_KB_MOUSE: 
						controllerButtonName = this._buttonHintData.SecondaryPCKey;
						break;
					case PlatformChangeEvent.PLATFORM_PC_GAMEPAD: 
					case PlatformChangeEvent.PLATFORM_XB1: 
					default: 
						controllerButtonName = this._buttonHintData.SecondaryXenonButton;
						break;
					case PlatformChangeEvent.PLATFORM_PS4: 
						controllerButtonName = this._buttonHintData.SecondaryPSNButton;
						break;
					case PlatformChangeEvent.PLATFORM_MOBILE: 
						controllerButtonName = "";
					}
					if (NameToTextMap.hasOwnProperty(controllerButtonName))
					{
						controllerButtonName = NameToTextMap[controllerButtonName];
					}
				}
			}
			return controllerButtonName;
		}
		
		public function get ButtonText():String
		{
			return this._buttonHintData.ButtonText;
		}
		
		public function get Justification():uint
		{
			if (CompanionAppMode.isOn)
			{
				return this._buttonHintData != null ? uint(this._buttonHintData.Justification) : uint(JUSTIFY_LEFT);
			}
			return this._buttonHintData.Justification;
		}
		
		public function get ButtonDisabled():Boolean
		{
			return this._buttonHintData.ButtonDisabled;
		}
		
		public function get SecondaryButtonDisabled():Boolean
		{
			return this._buttonHintData.SecondaryButtonDisabled;
		}
		
		public function get AllButtonsDisabled():Boolean
		{
			return this.ButtonDisabled && (!this._buttonHintData.hasSecondaryButton || this.SecondaryButtonDisabled);
		}
		
		public function get ButtonVisible():Boolean
		{
			return this._buttonHintData && this._buttonHintData.ButtonVisible;
		}
		
		public function get UseDynamicMovieClip():Boolean
		{
			return this._buttonHintData.DynamicMovieClipName.length > 0;
		}
		
		public function onTextClick(MouseEvent:Event):void
		{
			if (!this.ButtonDisabled && this.ButtonVisible)
			{
				this._buttonHintData.onTextClick();
			}
		}
		
		public function get bButtonPressed():Boolean
		{
			return this._bButtonPressed;
		}
		
		public function set bButtonPressed(abButtonPressed:Boolean):*
		{
			if (this._bButtonPressed != abButtonPressed)
			{
				this._bButtonPressed = abButtonPressed;
				SetIsDirty();
			}
		}
		
		public function get bMouseOver():Boolean
		{
			return this._bMouseOver;
		}
		
		public function set bMouseOver(abMouseOver:Boolean):*
		{
			if (this._bMouseOver != abMouseOver)
			{
				this._bMouseOver = abMouseOver;
				SetIsDirty();
			}
		}
		
		private function onMouseOver(event:MouseEvent):*
		{
			this.bMouseOver = true;
		}
		
		protected function onMouseOut(event:MouseEvent):*
		{
			this.bMouseOver = false;
		}
		
		override public function redrawUIComponent():void
		{
			super.redrawUIComponent();
			hitArea = null;
			if (contains(this._hitArea))
			{
				removeChild(this._hitArea);
			}
			visible = this.ButtonVisible;
			if (visible)
			{
				this.redrawPrimaryButton();
				this.redrawDynamicMovieClip();
				this.redrawTextField();
				this.redrawSecondaryButton();
				this.SetFlashing(this._buttonHintData.ButtonFlashing);
				this.redrawHitArea();
				addChild(this._hitArea);
				hitArea = this._hitArea;
			}
		}
		
		public function SetFlashing(abFlash:Boolean):*
		{
			if (abFlash != this.bButtonFlashing)
			{
				this.bButtonFlashing = abFlash;
				this.IconHolderInstance.gotoAndPlay(!!abFlash ? "Flashing" : "Default");
			}
		}
		
		private function UpdateIconTextField(icon_tf:TextField, controllerText:String):*
		{
			var formatUpdate:* = undefined;
			icon_tf.text = controllerText;
			var expectedFont:String = this.GetExpectedFont();
			var currentFont:String = icon_tf.getTextFormat().font;
			if (expectedFont != currentFont)
			{
				formatUpdate = new TextFormat(expectedFont);
				icon_tf.setTextFormat(formatUpdate);
			}
			var expectedY:Number = !!this.UsePCKey ? Number(-1.5) : Number(0);
			if (icon_tf.y != expectedY)
			{
				icon_tf.y = expectedY;
			}
		}
		
		private function redrawDynamicMovieClip():void
		{
			var clipClass:Class = null;
			var clipScale:Number = NaN;
			if (this._buttonHintData.DynamicMovieClipName != this._strCurrentDynamicMovieClipName)
			{
				if (this.DynamicMovieClip)
				{
					removeChild(this.DynamicMovieClip);
				}
				if (this.UseDynamicMovieClip)
				{
					clipClass = getDefinitionByName(this._buttonHintData.DynamicMovieClipName) as Class;
					this.DynamicMovieClip = new (clipClass as Class)();
					addChild(this.DynamicMovieClip);
					clipScale = this._DyanmicMovieHeight / this.DynamicMovieClip.height;
					this.DynamicMovieClip.scaleX = clipScale;
					this.DynamicMovieClip.scaleY = clipScale;
					this.DynamicMovieClip.alpha = !!this.AllButtonsDisabled ? Number(DISABLED_GREY_OUT_ALPHA) : Number(1);
					this.DynamicMovieClip.x = this.Justification == JUSTIFY_LEFT ? Number(this.IconHolderInstance.width + DYNAMIC_MOVIE_CLIP_BUFFER) : Number(this.IconHolderInstance.x - this.DynamicMovieClip.width - DYNAMIC_MOVIE_CLIP_BUFFER);
					this.DynamicMovieClip.y = this._DynamicMovieY;
				}
			}
		}
		
		private function redrawTextField():void
		{
			this.textField_tf.visible = !this.UseDynamicMovieClip;
			if (this.textField_tf.visible)
			{
				GlobalFunc.SetText(this.textField_tf, this.ButtonText, false, true, false);
				this.textField_tf.alpha = !!this.AllButtonsDisabled ? Number(DISABLED_GREY_OUT_ALPHA) : Number(1);
				this.textField_tf.x = this.Justification == JUSTIFY_LEFT ? Number(this.IconHolderInstance.width) : Number(this.IconHolderInstance.x - this.textField_tf.width);
			}
		}
		
		private function redrawSecondaryButton():void
		{
			this.SecondaryIconHolderInstance.visible = this._buttonHintData.hasSecondaryButton;
			if (this.SecondaryIconHolderInstance.visible)
			{
				this.UpdateIconTextField(this.SecondaryIconHolderInstance.IconAnimInstance.Icon_tf, this.SecondaryControllerButton);
				this.SecondaryIconHolderInstance.alpha = !!this.SecondaryButtonDisabled ? Number(DISABLED_GREY_OUT_ALPHA) : Number(1);
				this.SecondaryIconHolderInstance.x = !!this.UseDynamicMovieClip ? Number(this.DynamicMovieClip.x + this.DynamicMovieClip.width + DYNAMIC_MOVIE_CLIP_BUFFER) : Number(this.textField_tf.x + this.textField_tf.width);
			}
		}
		
		private function redrawPrimaryButton():void
		{
			this.UpdateIconTextField(this.IconHolderInstance.IconAnimInstance.Icon_tf, this.ControllerButton);
			this.IconHolderInstance.alpha = !!this.ButtonDisabled ? Number(DISABLED_GREY_OUT_ALPHA) : Number(1);
			this.IconHolderInstance.x = this.Justification == JUSTIFY_LEFT ? Number(0) : Number(-this.IconHolderInstance.width);
		}
		
		private function redrawHitArea():void
		{
			var bounds:* = this.getBounds(this);
			this._hitArea.x = bounds.x;
			this._hitArea.width = bounds.width;
			this._hitArea.y = bounds.y;
			this._hitArea.height = bounds.height;
		}
		
		private function GetExpectedFont():String
		{
			var expectedFormat:String = null;
			var bUseInverted:Boolean = false;
			if (this.UsePCKey)
			{
				expectedFormat = "$MAIN_Font";
			}
			else
			{
				bUseInverted = !this.bMouseOver && !this.bButtonPressed;
				expectedFormat = !!bUseInverted ? "$Controller_buttons_inverted" : "$Controller_buttons";
			}
			return expectedFormat;
		}
		
		private function SetUpTextFields(aTextField:TextField):*
		{
			aTextField.autoSize = TextFieldAutoSize.LEFT;
			aTextField.antiAliasType = AntiAliasType.NORMAL;
		}
	}
}