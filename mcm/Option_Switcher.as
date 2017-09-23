// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Option_Checkbox

package mcm
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import Shared.GlobalFunc;
    import flash.events.Event;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class Option_Switcher extends MovieClip 
    {

        public static const VALUE_CHANGE:String = "mcmOption_Checkbox::VALUE_CHANGE";

        public var textField:TextField;
        private var bChecked:Boolean;

        public function Option_Switcher()
        {
            this.bChecked = false;
            addEventListener(MouseEvent.CLICK, this.onClick);
        }

        public function get checked():Boolean
        {
            return (this.bChecked);
        }

        public function set checked(_arg_1:Boolean)
        {
            this.bChecked = _arg_1;
            GlobalFunc.SetText(this.textField, ((this.bChecked) ? "$ON" : "$OFF"), false);
        }

        private function Toggle()
        {
            this.checked = (!(this.checked));
            dispatchEvent(new Event(VALUE_CHANGE, true, true));
        }

        public function onItemPressed()
        {
            this.Toggle();
        }

        public function HandleKeyboardInput(_arg_1:KeyboardEvent)
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.Toggle();
                _arg_1.stopPropagation();
            };
        }

        private function onClick(_arg_1:MouseEvent)
        {
			if (MCM_Menu.iMode == MCM_Menu.MCM_TEXTINPUT_MODE) 
			{
				return;
			}
            this.Toggle();
            _arg_1.stopPropagation();
        }


    }
}//package 

