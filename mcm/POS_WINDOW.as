package mcm {
	
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
		public var tf_x: TextField;
		public var tf_y: TextField;
		public var tf_scalex: TextField;
		public var tf_scaley: TextField;
		public var tf_rotation: TextField;
		public var tf_alpha: TextField;
		public var plch: MovieClip;
		
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
		public function Open(name: String = "DEF_WIDGETS_SURVIVAL1.swf", posx: Number = 0, posy: Number = 0, scalex: Number = 1, scaley: Number = 1, rotation: Number = 0, alpha: Number = 1)
		{		
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
			

 
			plch.x = posx;
			plch.y = posy;

			tf_x.text = "x: " + posx;
			tf_y.text = "y: " + posy;
			tf_scalex.text = "scaleX: " + scalex;
			tf_scaley.text = "scaleY: " + scaley;
			tf_rotation.text = "rotation: " + rotation;
			tf_alpha.text = "alpha: " + alpha;
		}
		
		private function onThumbMouseDown(e:MouseEvent):void 
		{
            plch.startDrag(false, new Rectangle(-1280, -720, 2560, 1440));//e.currentTarget
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		private function onThumbMouseMove(e:MouseEvent):void 
		{
			tf_x.text = "x: " + plch.x;
			tf_y.text = "y: " + plch.y;
		}
		
		private function onThumbMouseUp(e:MouseEvent):void 
		{
            plch.stopDrag();
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		public function Close()
		{
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
			this.removeChildAt(0);
		}
	}
	
}
