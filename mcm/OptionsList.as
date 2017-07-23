// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//OptionsList

package mcm
{
    import Shared.AS3.BSScrollingList1;
    import flash.events.KeyboardEvent;
    import flash.display.MovieClip;
    import flash.events.Event;
    import Shared.AS3.BSScrollingListEntry;
    import flash.ui.Keyboard;

    public class OptionsList extends BSScrollingList1
    {

        private var bAllowValueOverwrite:Boolean;

        public function OptionsList()
        {
            this.bAllowValueOverwrite = false;
            addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            addEventListener(mcm.SettingsOptionItem.VALUE_CHANGE, this.onValueChange);
        }

        public function get allowValueOverwrite():Boolean
        {
            return (this.bAllowValueOverwrite);
        }

        public function set allowValueOverwrite(_arg_1:Boolean)
        {
            this.bAllowValueOverwrite = _arg_1;
        }

        override protected function GetEntryHeight(_arg_1:Number):Number
        {
            var _local_2:MovieClip = GetClipByIndex(0);
            return (_local_2.height);
        }

        public function onValueChange(_arg_1:Event)
        {
            EntriesA[_arg_1.target.itemIndex].value = _arg_1.target.value;
        }

        override protected function SetEntry(_arg_1:BSScrollingListEntry, _arg_2:Object)
        {
            var _local_3:mcm.SettingsOptionItem;
            if (_arg_1 != null)
            {
                _local_3 = (_arg_1 as mcm.SettingsOptionItem);
                if (((this.allowValueOverwrite) || ((!((_local_3.ID == _arg_2.ID))))))
                {
                    _local_3.movieType = _arg_2.movieType;
                    if (_arg_2.options != undefined)
                    {
                        _local_3.SetOptionStepperOptions(_arg_2.options);
                    };
                    _local_3.ID = _arg_2.ID;
                    _local_3.value = _arg_2.value;
                    _local_3.hudColorUpdate = _arg_2.hudColorUpdate;
                    _local_3.pipboyColorUpdate = _arg_2.pipboyColorUpdate;
                    _local_3.difficultyUpdate = _arg_2.difficultyUpdate;
                };
                super.SetEntry(_arg_1, _arg_2);
            };
        }

        public function onListItemPressed()
        {
            var _local_1:BSScrollingListEntry;
            if (!bDisableInput)
            {
                if (this.selectedEntry != null)
                {
                    _local_1 = GetClipByIndex(this.selectedEntry.clipIndex);
                    if (_local_1 != null)
                    {
                        (_local_1 as mcm.SettingsOptionItem).onItemPressed();
                    };
                };
            };
        }

        override public function onKeyDown(_arg_1:KeyboardEvent)
        {
            var _local_2:BSScrollingListEntry;
            if (!bDisableInput)
            {
                super.onKeyDown(_arg_1);
                if ((((!((this.selectedEntry == null)))) && ((((_arg_1.keyCode == Keyboard.LEFT)) || ((_arg_1.keyCode == Keyboard.RIGHT))))))
                {
                    _local_2 = GetClipByIndex(this.selectedEntry.clipIndex);
                    if (_local_2 != null)
                    {
                        (_local_2 as mcm.SettingsOptionItem).HandleKeyboardInput(_arg_1);
                        _arg_1.stopPropagation();
                    };
                };
            };
        }


    }
}//package 

