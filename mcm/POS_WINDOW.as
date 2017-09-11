package mcm {
	
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	
	public class POS_WINDOW extends MovieClip {
		
		public var request:URLRequest;
		public var loader:Loader;

		public var plch: MovieClip;
		public var _target: InteractiveObject;
		public var allowMove: Boolean = false;
		public var allowScale: Boolean = false;
		public var allowRot: Boolean = false;
		public var allowAlpha: Boolean = false;
		public var text_mc: pos_window_text;
		
		public function POS_WINDOW() {
			// constructor code

		}
		
		function completeHandler(event:Event):void
		{
			plch.addChild(loader.content);
			fillplch();			
		}
		
		function fillplch():void 
		{
			plch.graphics.beginFill(0xFFFFFF,0.01);
			plch.graphics.drawRect(0,0,plch.width,plch.height);
			plch.graphics.endFill();
			plch.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
		}
		public function Open(target: InteractiveObject) //, name: String = "DEF_WIDGETS_SURVIVAL1.swf", posx: Number = int.MAX_VALUE, posy: Number = int.MAX_VALUE, scalex: Number = int.MAX_VALUE, scaley: Number = int.MAX_VALUE, rotation: Number = int.MAX_VALUE, alpha: Number = int.MAX_VALUE)
		{		
			_target = target;
			var name:String = _target.OptionItem._clip;
			var posx: Number = _target.OptionItem._x;
			var posy: Number = _target.OptionItem._y;
			var scalex: Number = _target.OptionItem._scalex;
			var scaley: Number = _target.OptionItem._scaley;
			var rotation: Number = _target.OptionItem._rotation;
			var alpha: Number = _target.OptionItem._alpha;
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
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE , completeHandler);
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
		}
		
		public function RefreshText():void 
		{
			text_mc.x = (plch.x > 640)? 30:1100;
			text_mc.y = (plch.y > 360)? 30:490;
			text_mc.tf_x.text = "x: " + plch.x;
			text_mc.tf_y.text = "y: " + plch.y;
			text_mc.tf_scalex.text = "scaleX: " + plch.scaleX;
			text_mc.tf_scaley.text = "scaleY: " + plch.scaleY;
			text_mc.tf_rotation.text = "rotation: " + plch.rotation;
			text_mc.tf_alpha.text = "alpha: " + plch.alpha;
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
				_target.OptionItem._x = allowMove? plch.x: int.MAX_VALUE;
				_target.OptionItem._y = allowMove? plch.y: int.MAX_VALUE;
				_target.OptionItem._scalex = allowScale? plch.scaleX: int.MAX_VALUE;
				_target.OptionItem._scaley = allowScale? plch.scaleY: int.MAX_VALUE;
				_target.OptionItem._rotation = allowRot? plch.rotation: int.MAX_VALUE;
				_target.OptionItem._alpha = allowAlpha? plch.alpha: int.MAX_VALUE;
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
			//this.removeChildAt(0);
		}
	}
	
}
