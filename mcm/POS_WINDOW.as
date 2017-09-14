package mcm
{
	
	import Shared.GlobalFunc;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class POS_WINDOW extends MovieClip
	{
		public var CONFIRM_POP:confirm_popup;
		public var request:URLRequest;
		public var loader:Loader;
		
		public var plch:MovieClip;
		public var _target:InteractiveObject;
		public var allowMove:Boolean;
		public var allowScale:Boolean;
		public var allowRot:Boolean;
		public var allowAlpha:Boolean;
		public var linkedXYscale:Boolean;
		
		public var cname:String;
		public var posx:Number;
		public var posy:Number;
		public var scalex:Number;
		public var scaley:Number;
		public var arotation:Number;
		public var aalpha:Number;
		
		public var text_mc:pos_window_text;
		private var _shift: Boolean;
		private var _alt: Boolean;
		private var _ctrl: Boolean;
		public var numOptions: uint;
		private var _dataChanged: Boolean = true;
		
		public function POS_WINDOW()
		{
			// constructor code
		
		}
		
		function completeHandler(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			plch.addChild(loader.content);
			fillplch();
		}
		
		function fillplch():void
		{
			plch.getChildAt(0).graphics.beginFill(0xFFFFFF, 0.01);
			plch.getChildAt(0).graphics.drawRect(0, 0, plch.getChildAt(0).width, plch.getChildAt(0).height);
			plch.getChildAt(0).graphics.endFill();
			plch.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
		}
		
		public function Open(target:InteractiveObject)
		{
			dataChanged = false;
			numOptions = 0;
			allowMove = false;
			allowScale = false;
			allowRot = false;
			allowAlpha = false;
			linkedXYscale = true;
			_shift = false;
			_alt = false;
			_ctrl = false;
			_target = target;
			cname = _target.OptionItem._clip;
			posx = _target.OptionItem._x;
			posy = _target.OptionItem._y;
			scalex = _target.OptionItem._scalex;
			scaley = _target.OptionItem._scaley;
			arotation = _target.OptionItem._rotation;
			aalpha = _target.OptionItem._alpha;
			plch = new MovieClip();
			this.addChild(plch);
			
			loader = new Loader();
			if (cname.indexOf("|") > 0)
			{
				plch.addChild(MCM_Menu.instance.getMcFromLib(cname.substring(0,cname.indexOf("|")), cname.substring(cname.indexOf("|") + 1)));
				fillplch();
			}
			else
			{
				request = new URLRequest(cname);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.load(request);
			}
			parent.visible = true;
			
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = true;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = true;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = true;
			MCM_Menu.instance.configPanel_mc.alpha = 0.05;
			MCM_Menu.instance.HelpPanel_mc.alpha = 0.05;
			MCM_Menu.instance.MainMenu.setChildIndex(MCM_Menu.instance.MainMenu.BethesdaLogo_mc, MCM_Menu.instance.MainMenu.numChildren - 1);
			
			if (posx != int.MAX_VALUE)
			{
				plch.x = posx;
				allowMove = true;
				text_mc.tf_x.y = 14+30*numOptions;
				numOptions++;
				if (posy != int.MAX_VALUE)
				{
					plch.y = posy;
					text_mc.tf_y.y = 14+30*numOptions;
					numOptions++;
				}
			}
			if (scalex != int.MAX_VALUE)
			{
				plch.scaleX = scalex;
				allowScale = true;
				text_mc.tf_scalex.y = 14+30*numOptions;
				numOptions++;
				if (scaley != int.MAX_VALUE)
				{
					plch.scaleY = scaley;
					text_mc.tf_scaley.y = 14+30*numOptions;
					numOptions++;
					linkedXYscale = false;
				}
				else 
				{
					plch.scaleY = plch.scaleX;
				}
			}
			if (arotation != int.MAX_VALUE)
			{
				plch.rotation = arotation;
				allowRot = true;
				text_mc.tf_rotation.y = 14+30*numOptions;
				numOptions++;
			}
			if (aalpha != int.MAX_VALUE)
			{
				plch.alpha = aalpha;
				allowAlpha = true;
				text_mc.tf_alpha.y = 14+30*numOptions;
				numOptions++;
			}
			this.text_mc.bg.height = 20 + numOptions * 30;
			text_mc.tf_x.visible = allowMove;
			text_mc.tf_y.visible = allowMove;
			text_mc.tf_scalex.visible = allowScale;
			text_mc.tf_scaley.visible = allowScale && !linkedXYscale;
			text_mc.tf_rotation.visible = allowRot;
			text_mc.tf_alpha.visible = allowAlpha;
			
			RefreshText();
			MCM_Menu.iMode = MCM_Menu.MCM_POSITIONER_MODE;
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.setChildIndex(CONFIRM_POP, this.numChildren-1);
		}
		
		public function startlisteners():void 
		{
			plch.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function stoplisteners():void 
		{
			plch.removeEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function RefreshText():void
		{
			text_mc.x = (plch.x > 640) ? 30 : 1100;
			text_mc.y = (plch.y > 360) ? 30 : 440+(30*(6-numOptions)); //490
			text_mc.tf_x.text = "x: " + MCM_Menu.RoundDecimal(plch.x);
			text_mc.tf_y.text = "y: " + MCM_Menu.RoundDecimal(plch.y);
			text_mc.tf_scalex.text = (linkedXYscale?"scale: ":"scaleX: ") + MCM_Menu.RoundDecimal(plch.scaleX);
			text_mc.tf_scaley.text = "scaleY: " + MCM_Menu.RoundDecimal(plch.scaleY);
			text_mc.tf_rotation.text = "rotation: " + MCM_Menu.RoundDecimal(plch.rotation);
			text_mc.tf_alpha.text = "alpha: " + MCM_Menu.RoundDecimal(plch.alpha);
		}
		
		private function onThumbMouseDown(e:MouseEvent):void
		{
			plch.startDrag(false, new Rectangle(-1280, -720, 2560, 1440));//e.currentTarget
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		private function onThumbMouseMove(e:MouseEvent):void
		{
			dataChanged = true;
			RefreshText();
		}
		
		private function onThumbMouseUp(e:MouseEvent):void
		{
			plch.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		public function Close(bNoSave: Boolean = true)
		{
			if (bNoSave)
			{
				_target.OptionItem._x = allowMove ? plch.x : int.MAX_VALUE;
				_target.OptionItem._y = allowMove ? plch.y : int.MAX_VALUE;
				_target.OptionItem._scalex = allowScale ? plch.scaleX : int.MAX_VALUE;
				_target.OptionItem._scaley = (allowScale && !linkedXYscale) ? plch.scaleY : int.MAX_VALUE;
				_target.OptionItem._rotation = allowRot ? plch.rotation : int.MAX_VALUE;
				_target.OptionItem._alpha = allowAlpha ? plch.alpha : int.MAX_VALUE;
				_target.OptionItem.value = 0;
				_target.dispatchEvent(new Event(Option_pos.VALUE_CHANGE, true, true));
			}
			_target = null;
			parent.visible = false;
			MCM_Menu.iMode = MCM_Menu.MCM_MAIN_MODE;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableInput = false;
			MCM_Menu.instance.configPanel_mc.configList_mc.disableSelection = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableInput = false;
			MCM_Menu.instance.HelpPanel_mc.HelpList_mc.disableSelection = false;
			MCM_Menu.instance.configPanel_mc.alpha = 1;
			MCM_Menu.instance.HelpPanel_mc.alpha = 1;
			MCM_Menu.instance.MainMenu.setChildIndex(MCM_Menu.instance.MainMenu.BethesdaLogo_mc, 0);
			//loader.unload();
			
			plch.removeChildAt(0);
			plch = null;
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//this.removeChildAt(0);
		}
		
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (e.shiftKey) 
			{
				fscalex(e.delta);
			}
			else if (e.ctrlKey) 
			{
				fscaley(e.delta);
			}
			else if (e.altKey) 
			{
				falpha(e.delta);
			}
		}
		
		public function ProcessKeyEvent(keyCode:int, isDown:Boolean):void
		{
			
			if (!isDown)
			{
				switch (keyCode)
				{
				case Keyboard.TAB: 
					MCM_Menu.instance.onCancelPress();
					break;
				case Keyboard.ESCAPE: 
					MCM_Menu.instance.onQuitPressed();
					break;
				case Keyboard.T: 
					MCM_Menu.instance.onResetButtonClicked();
					break;
				case mcm.Option_ButtonMapping.KEY_LSHIFT: 
				case mcm.Option_ButtonMapping.KEY_RSHIFT: 
					_shift = false;
					break;
				case mcm.Option_ButtonMapping.KEY_LCTRL: 
				case mcm.Option_ButtonMapping.KEY_RCTRL: 
					_ctrl = false;
					break;
				case mcm.Option_ButtonMapping.KEY_LALT: 
				case mcm.Option_ButtonMapping.KEY_RALT: 
					_alt = false;
					break;
				case Keyboard.Q: 
					frot(_alt?-20:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.E: 
					frot(_alt?20:(_ctrl?1:(_shift?5:10)));
					break;
				case Keyboard.W: 
					fposy(_alt?-100:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.S: 
					fposy(_alt?100:(_ctrl?1:(_shift?5:10)));
					break;
				case Keyboard.A: 
					fposx(_alt?-100:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.D: 
					fposx(_alt?100:(_ctrl?1:(_shift?5:10)));
					break;
				default: 
				}
			}
			else 
			{
				switch (keyCode)
				{
				case mcm.Option_ButtonMapping.KEY_LSHIFT: 
				case mcm.Option_ButtonMapping.KEY_RSHIFT: 
					_shift = true;
					break;
				case mcm.Option_ButtonMapping.KEY_LCTRL: 
				case mcm.Option_ButtonMapping.KEY_RCTRL: 
					_ctrl = true;
					break;
				case mcm.Option_ButtonMapping.KEY_LALT: 
				case mcm.Option_ButtonMapping.KEY_RALT: 
					_alt = true;
					break;
				default: 
				}
				//text_mc.tf_x.text = String(keyCode)+String(isDown);
			}
		}
		
		public function Reset():void 
		{
			dataChanged = false;
			if (posx != int.MAX_VALUE)
			{
				plch.x = posx;
				if (posy != int.MAX_VALUE)
				{
					plch.y = posy;
				}
			}
			if (scalex != int.MAX_VALUE)
			{
				plch.scaleX = scalex;
				if (scaley != int.MAX_VALUE)
				{
					plch.scaleY = scaley;
				}
				else 
				{
					plch.scaleY = plch.scaleX;
				}
			}
			if (arotation != int.MAX_VALUE)
			{
				plch.rotation = arotation;
			}
			if (aalpha != int.MAX_VALUE)
			{
				plch.alpha = aalpha;
			}
			RefreshText();
		}
		
		private function frot(val: Number):void 
		{
			if (allowRot) 
			{
				plch.rotation = ((plch.rotation + val) % 360);
				dataChanged = true;
				RefreshText();
			}
		}
		
		private function fposx(val: Number):void 
		{
			if (allowMove) 
			{
				plch.x += val;
				dataChanged = true;
				RefreshText();
			}
		}
		
		private function fposy(val: Number):void 
		{
			if (allowMove) 
			{
				plch.y += val;
				dataChanged = true;
				RefreshText();
			}
		}
		
		public function fscalex(val: Number):void 
		{
			if (allowScale) 
			{
				plch.scaleX += val * 0.1;
				dataChanged = true;
				if (linkedXYscale) 
				{
					plch.scaleY = plch.scaleX;
				}
				RefreshText();
			}
		}
		
		public function fscaley(val: Number):void 
		{
			if (allowScale) 
			{
				plch.scaleY += val * 0.1;
				dataChanged = true;
				if (linkedXYscale) 
				{
					plch.scaleX = plch.scaleY;
				}
				RefreshText();
			}
		}
		
		private function falpha(val: Number):void 
		{
			if (allowAlpha && ((plch.alpha> 0.04 && val<0) || (plch.alpha < 0.96 && val>0)))
			{
				plch.alpha += val * 0.05;
				dataChanged = true;
				RefreshText();
			}
		}
		
		public function get dataChanged():Boolean 
		{
			return _dataChanged;
		}
		
		public function set dataChanged(value:Boolean):void 
		{
			_dataChanged = value;
			MCM_Menu.instance.ResetButton.ButtonVisible = value;
		}
	}

}
