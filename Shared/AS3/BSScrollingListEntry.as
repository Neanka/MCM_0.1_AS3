// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSScrollingListEntry

package Shared.AS3
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import scaleform.gfx.Extensions;
    import scaleform.gfx.TextFieldEx;
    import flash.text.TextFieldAutoSize;
    import Shared.GlobalFunc;

    public class BSScrollingListEntry extends MovieClip 
    {

        public var border:MovieClip;
        public var textField:TextField;
        protected var _clipIndex:uint;
        protected var _itemIndex:uint;
        protected var _selected:Boolean;
        public var ORIG_BORDER_HEIGHT:Number;
        protected var _HasDynamicHeight:Boolean;

        public function BSScrollingListEntry()
        {
            Extensions.enabled = true;
            this.ORIG_BORDER_HEIGHT = (((this.border)!=null) ? this.border.height : 0);
            this._HasDynamicHeight = true;
        }

        public function get clipIndex():uint
        {
            return (this._clipIndex);
        }

        public function set clipIndex(_arg_1:uint)
        {
            this._clipIndex = _arg_1;
        }

        public function get itemIndex():uint
        {
            return (this._itemIndex);
        }

        public function set itemIndex(_arg_1:uint)
        {
            this._itemIndex = _arg_1;
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean)
        {
            this._selected = _arg_1;
        }

        public function get hasDynamicHeight():Boolean
        {
            return (this._HasDynamicHeight);
        }

        public function get defaultHeight():Number
        {
            return (this.ORIG_BORDER_HEIGHT);
        }

        public function SetEntryText(_arg_1:Object, _arg_2:String)
        {
            var _local_3:Number;
            if (((this.textField != null) && (_arg_1 != null)) && _arg_1.hasOwnProperty("text"))
            {
                if (_arg_2 == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
                {
                    TextFieldEx.setTextAutoSize(this.textField, "shrink");
                } else
                {
                    if (_arg_2 == BSScrollingList.TEXT_OPTION_MULTILINE)
                    {
                        this.textField.autoSize = TextFieldAutoSize.LEFT;
                        this.textField.multiline = true;
                        this.textField.wordWrap = true;
                    };
                };
                if (_arg_1.text != undefined)
                {
                    GlobalFunc.SetText(this.textField, _arg_1.text, true);
                } else
                {
                    GlobalFunc.SetText(this.textField, " ", true);
                };
                this.textField.textColor = ((this.selected) ? 0 : 0xFFFFFF);
            };
            if (this.border != null)
            {
                this.border.alpha = ((this.selected) ? GlobalFunc.SELECTED_RECT_ALPHA : 0);
                if ((((((!((this.textField == null)))) && ((_arg_2 == BSScrollingList.TEXT_OPTION_MULTILINE)))) && ((this.textField.numLines > 1))))
                {
                    _local_3 = (this.textField.y - this.border.y);
                    this.border.height = ((this.textField.textHeight + (_local_3 * 2)) + 5);
                } else
                {
                    this.border.height = this.ORIG_BORDER_HEIGHT;
                };
            };
        }


    }
}//package Shared.AS3

