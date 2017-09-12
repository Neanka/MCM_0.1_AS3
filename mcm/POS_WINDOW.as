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
		
		public var request:URLRequest;
		public var loader:Loader;
		
		public var plch:MovieClip;
		public var _target:InteractiveObject;
		public var allowMove:Boolean;
		public var allowScale:Boolean;
		public var allowRot:Boolean;
		public var allowAlpha:Boolean;
		public var text_mc:pos_window_text;
		private var _shift: Boolean;
		private var _alt: Boolean;
		private var _ctrl: Boolean;
		
		public function POS_WINDOW()
		{
			// constructor code
		
		}
		
		function completeHandler(event:Event):void
		{
			plch.addChild(loader.content);
			fillplch();
		}
		
		function fillplch():void
		{
			plch.graphics.beginFill(0xFFFFFF, 0.01);
			plch.graphics.drawRect(0, 0, plch.width, plch.height);
			plch.graphics.endFill();
			plch.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
		}
		
		public function Open(target:InteractiveObject) //, name: String = "DEF_WIDGETS_SURVIVAL1.swf", posx: Number = int.MAX_VALUE, posy: Number = int.MAX_VALUE, scalex: Number = int.MAX_VALUE, scaley: Number = int.MAX_VALUE, rotation: Number = int.MAX_VALUE, alpha: Number = int.MAX_VALUE)
		{
			allowMove = false;
			allowScale = false;
			allowRot = false;
			allowAlpha = false;
			_shift = false;
			_alt = false;
			_ctrl = false;
			_target = target;
			var name:String = _target.OptionItem._clip;
			var posx:Number = _target.OptionItem._x;
			var posy:Number = _target.OptionItem._y;
			var scalex:Number = _target.OptionItem._scalex;
			var scaley:Number = _target.OptionItem._scaley;
			var rotation:Number = _target.OptionItem._rotation;
			var alpha:Number = _target.OptionItem._alpha;
			plch = new MovieClip();
			this.addChild(plch);
			
			loader = new Loader();
			if (name.indexOf("|") > 0)
			{
				plch.addChild(MCM_Menu.instance.getMcFromLib("MCM_Demo", "s1"));
				fillplch();
			}
			else
			{
				request = new URLRequest(name);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.load(request);
			}
			parent.visible = true;
			MCM_Menu.iMode = MCM_Menu.MCM_POSITIONER_MODE;
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
			}
			if (posy != int.MAX_VALUE)
			{
				plch.y = posy;
			}
			if (scalex != int.MAX_VALUE)
			{
				plch.scaleX = scalex;
				allowScale = true;
			}
			if (scaley != int.MAX_VALUE)
			{
				plch.scaleY = scaley;
			}
			if (rotation != int.MAX_VALUE)
			{
				plch.rotation = rotation;
				allowRot = true;
			}
			if (alpha != int.MAX_VALUE)
			{
				plch.alpha = alpha;
				allowAlpha = true;
			}
			
			text_mc.tf_x.visible = allowMove;
			text_mc.tf_y.visible = allowMove;
			text_mc.tf_scalex.visible = allowScale;
			text_mc.tf_scaley.visible = allowScale;
			text_mc.tf_rotation.visible = allowRot;
			text_mc.tf_alpha.visible = allowAlpha;
			
			RefreshText();
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function RefreshText():void
		{
			text_mc.x = (plch.x > 640) ? 30 : 1100;
			text_mc.y = (plch.y > 360) ? 30 : 490;
			text_mc.tf_x.text = "x: " + GlobalFunc.RoundDecimal(plch.x, 2);
			text_mc.tf_y.text = "y: " + GlobalFunc.RoundDecimal(plch.y, 2);
			text_mc.tf_scalex.text = "scaleX: " + GlobalFunc.RoundDecimal(plch.scaleX, 2);
			text_mc.tf_scaley.text = "scaleY: " + GlobalFunc.RoundDecimal(plch.scaleY, 2);
			text_mc.tf_rotation.text = "rotation: " + GlobalFunc.RoundDecimal(plch.rotation, 2);
			text_mc.tf_alpha.text = "alpha: " + GlobalFunc.RoundDecimal(plch.alpha, 2);
		}
		
		private function onThumbMouseDown(e:MouseEvent):void
		{
			plch.startDrag(false, new Rectangle(-1280, -720, 2560, 1440));//e.currentTarget
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		private function onThumbMouseMove(e:MouseEvent):void
		{
			RefreshText();
		}
		
		private function onThumbMouseUp(e:MouseEvent):void
		{
			plch.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		public function Close()
		{
			if (true)
			{
				trace(allowAlpha);
				trace();
				_target.OptionItem._x = allowMove ? plch.x : int.MAX_VALUE;
				_target.OptionItem._y = allowMove ? plch.y : int.MAX_VALUE;
				_target.OptionItem._scalex = allowScale ? plch.scaleX : int.MAX_VALUE;
				_target.OptionItem._scaley = allowScale ? plch.scaleY : int.MAX_VALUE;
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
				scalex(e.delta);
			}
			else if (e.ctrlKey) 
			{
				scaley(e.delta);
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
					rot(_alt?-20:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.E: 
					rot(_alt?20:(_ctrl?1:(_shift?5:10)));
					break;
				case Keyboard.W: 
					posy(_alt?-100:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.S: 
					posy(_alt?100:(_ctrl?1:(_shift?5:10)));
					break;
				case Keyboard.A: 
					posx(_alt?-100:(_ctrl?-1:(_shift?-5:-10)));
					break;
				case Keyboard.D: 
					posx(_alt?100:(_ctrl?1:(_shift?5:10)));
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
		
		private function rot(val: Number):void 
		{
			if (allowRot) 
			{
				plch.rotation += val;
				RefreshText();
			}
		}
		
		private function posx(val: Number):void 
		{
			if (allowMove) 
			{
				plch.x += val;
				RefreshText();
			}
		}
		
		private function posy(val: Number):void 
		{
			if (allowMove) 
			{
				plch.y += val;
				RefreshText();
			}
		}
		
		private function scalex(val: Number):void 
		{
			if (allowScale) 
			{
				plch.scaleX += val*0.1;
				RefreshText();
			}
		}
		
		private function scaley(val: Number):void 
		{
			if (allowScale) 
			{
				plch.scaleY += val*0.1;
				RefreshText();
			}
		}
		
		private function falpha(val: Number):void 
		{
			if (allowAlpha && plch.alpha> 0.04 && plch.alpha < 0.96) 
			{
				plch.alpha += val*0.05;
				RefreshText();
			}
		}
	}

}
