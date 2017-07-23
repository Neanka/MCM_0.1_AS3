// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.BGSExternalInterface

package Shared
{
    public class BGSExternalInterface 
    {


        public static function call(_arg_1:Object, ... _args):void
        {
            var _local_3:String;
            var _local_4:Function;
            if (_arg_1 != null)
            {
                _local_3 = _args.shift();
                _local_4 = _arg_1[_local_3];
                if (_local_4 != null)
                {
                    _local_4.apply(null, _args);
                } else
                {
                    trace((("BGSExternalInterface::call -- Can't call function '" + _local_3) + "' on BGSCodeObj. This function doesn't exist!"));
                };
            } else
            {
                trace((("BGSExternalInterface::call -- Can't call function '" + _local_3) + "' on BGSCodeObj. BGSCodeObj is null!"));
            };
        }


    }
}//package Shared

