// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//SettingsOptionItem

package mcm
{
    import Shared.AS3.BSScrollingListEntry;
    import flash.display.MovieClip;
    import scaleform.gfx.Extensions;
    import scaleform.gfx.TextFieldEx;
    import flash.geom.ColorTransform;
    import Shared.GlobalFunc;
    import flash.events.KeyboardEvent;
    import flash.events.Event;

    public class SettingsOptionItem extends BSScrollingListEntry 
    {

        public static const VALUE_CHANGE:String = "mcmSettingsOptionItem::value_change";

        private var OptionItem:MovieClip;
        private var uiMovieType:uint;
        private var uiID:uint;
        private var bHUDColorUpdate:Boolean;
        private var bPipboyColorUpdate:Boolean;
        private var bDifficultyUpdate:Boolean;

        public function SettingsOptionItem()
        {
            this.uiID = uint.MAX_VALUE;
            this.bHUDColorUpdate = false;
            this.bPipboyColorUpdate = false;
            addEventListener(mcm.Option_Checkbox.VALUE_CHANGE, this.onValueChange);
            addEventListener(mcm.Option_OptionStepper.VALUE_CHANGE, this.onValueChange);
            addEventListener(mcm.Option_Scrollbar.VALUE_CHANGE, this.onValueChange);
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(textField, "shrink");
        }

        public function get movieType():uint
        {
            return (this.uiMovieType);
        }

        public function set movieType(_arg_1:uint)
        {
            this.uiMovieType = _arg_1;
            if (this.OptionItem != null)
            {
                removeChild(this.OptionItem);
                this.OptionItem = null;
            };
            switch (this.uiMovieType)
            {
                case 0:
                    this.OptionItem = new mcm.Option_Scrollbar();
                    break;
                case 1:
                    this.OptionItem = new mcm.Option_OptionStepper();
                    break;
                case 2:
                    this.OptionItem = new mcm.Option_Checkbox();
                    break;
				default:
					this.OptionItem = new mcm.Option_Checkbox();
					break;
            };
            addChild(this.OptionItem);
            this.OptionItem.x = 550; // orig 210
            this.OptionItem.y = -1;
        }

        public function get ID():uint
        {
            return (this.uiID);
        }

        public function set ID(_arg_1:uint)
        {
            this.uiID = _arg_1;
        }

        public function get hudColorUpdate():Boolean
        {
            return (this.bHUDColorUpdate);
        }

        public function set hudColorUpdate(_arg_1:Boolean)
        {
            this.bHUDColorUpdate = _arg_1;
        }

        public function get pipboyColorUpdate():Boolean
        {
            return (this.bPipboyColorUpdate);
        }

        public function set pipboyColorUpdate(_arg_1:Boolean)
        {
            this.bPipboyColorUpdate = _arg_1;
        }

        public function get difficultyUpdate():Boolean
        {
            return (this.bDifficultyUpdate);
        }

        public function set difficultyUpdate(_arg_1:Boolean):void
        {
            this.bDifficultyUpdate = _arg_1;
        }

        public function get value():Number
        {
            var _local_1:Number;
            switch (this.uiMovieType)
            {
                case 0:
                    _local_1 = (this.OptionItem as mcm.Option_Scrollbar).value;
                    break;
                case 1:
                    _local_1 = (this.OptionItem as mcm.Option_OptionStepper).index;
                    break;
                case 2:
                    _local_1 = (((this.OptionItem as mcm.Option_Checkbox).checked) ? 1 : 0);
                    break;
            };
            return (_local_1);
        }

        public function set value(_arg_1:Number)
        {
            switch (this.uiMovieType)
            {
                case 0:
                    (this.OptionItem as mcm.Option_Scrollbar).value = _arg_1;
                    return;
                case 1:
                    (this.OptionItem as mcm.Option_OptionStepper).index = _arg_1;
                    return;
                case 2:
                    (this.OptionItem as mcm.Option_Checkbox).checked = (((_arg_1 == 1)) ? true : false);
                    return;
            };
        }

        public function SetOptionStepperOptions(_arg_1:Array)
        {
            if (this.uiMovieType == 1)
            {
                (this.OptionItem as mcm.Option_OptionStepper).options = _arg_1;
            };
        }

        override public function SetEntryText(_arg_1:Object, _arg_2:String)
        {
            var _local_3:ColorTransform;
            super.SetEntryText(_arg_1, _arg_2);
            if (this.border != null)
            {
                this.border.alpha = ((this.selected) ? GlobalFunc.SELECTED_RECT_ALPHA : 0);
            };
            if (this.textField != null)
            {
                this.textField.textColor = ((this.selected) ? 0 : 0xFFFFFF);
            };
            if (this.OptionItem != null)
            {
                _local_3 = this.OptionItem.transform.colorTransform;
                _local_3.redOffset = ((this.selected) ? -255 : 0);
                _local_3.greenOffset = ((this.selected) ? -255 : 0);
                _local_3.blueOffset = ((this.selected) ? -255 : 0);
                this.OptionItem.transform.colorTransform = _local_3;
            };
        }

        public function onItemPressed()
        {
            if (this.OptionItem != null)
            {
                switch (this.uiMovieType)
                {
                    case 1:
                        (this.OptionItem as mcm.Option_OptionStepper).onItemPressed();
                        return;
                    case 2:
                        (this.OptionItem as mcm.Option_Checkbox).onItemPressed();
                        return;
                };
            };
        }

        public function HandleKeyboardInput(_arg_1:KeyboardEvent)
        {
            if (this.OptionItem != null)
            {
                switch (this.uiMovieType)
                {
                    case 0:
                        (this.OptionItem as mcm.Option_Scrollbar).HandleKeyboardInput(_arg_1);
                        return;
                    case 1:
                        (this.OptionItem as mcm.Option_OptionStepper).HandleKeyboardInput(_arg_1);
                        return;
                    case 2:
                        (this.OptionItem as mcm.Option_Checkbox).HandleKeyboardInput(_arg_1);
                        return;
                };
            };
        }

        private function onValueChange(_arg_1:Event)
        {
            dispatchEvent(new Event(VALUE_CHANGE, true, true));
        }


    }
}//package 

