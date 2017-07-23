//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.utils
{
    import flash.utils.Dictionary;

    public class WeakReference 
    {

        protected var _dictionary:Dictionary;

        public function WeakReference(obj:Object)
        {
            this._dictionary = new Dictionary(true);
            this._dictionary[obj] = 1;
        }

        public function get value():Object
        {
            var dvalue:Object;
            for (dvalue in this._dictionary)
            {
                return (dvalue);
            };
            return (null);
        }


    }
}//package scaleform.clik.utils
