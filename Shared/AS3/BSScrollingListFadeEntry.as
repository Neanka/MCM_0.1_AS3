// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSScrollingListFadeEntry

package Shared.AS3
{
    public class BSScrollingListFadeEntry extends BSScrollingListEntry 
    {

        const fUnselectedBorderAlpha:Number = 0.5;


        override public function SetEntryText(_arg_1:Object, _arg_2:String)
        {
            super.SetEntryText(_arg_1, _arg_2);
            var _local_3 = (stage.focus == this.parent);
            if ((((!(_local_3))) && ((!((this.parent == null))))))
            {
                _local_3 = (stage.focus == this.parent.parent);
            };
            if ((((!(_local_3))) && (this.selected)))
            {
                border.alpha = this.fUnselectedBorderAlpha;
            };
        }


    }
}//package Shared.AS3

