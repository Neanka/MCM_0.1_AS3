//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.core
{
    import flash.display.Stage;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import scaleform.gfx.Extensions;
    import scaleform.clik.managers.FocusHandler;
    import scaleform.clik.managers.PopUpManager;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import __AS3__.vec.*;

    public dynamic class CLIK 
    {

        public static var stage:Stage;
        public static var initialized:Boolean = false;
        public static var disableNullFocusMoves:Boolean = false;
        public static var disableDynamicTextFieldFocus:Boolean = false;
        public static var disableTextFieldToNullFocusMoves:Boolean = true;
        public static var useImmediateCallbacks:Boolean = false;
        protected static var isInitListenerActive:Boolean = false;
        protected static var firingInitCallbacks:Boolean = false;
        protected static var initQueue:Dictionary;
        protected static var validDictIndices:Vector.<uint>;


        public static function initialize(stage:Stage, component:UIComponent):void
        {
            if (initialized)
            {
                return;
            };
            CLIK.stage = stage;
            Extensions.enabled = true;
            initialized = true;
            FocusHandler.init(stage, component);
            PopUpManager.init(stage);
            initQueue = new Dictionary(true);
            validDictIndices = new Vector.<uint>();
        }

        public static function getTargetPathFor(clip:DisplayObjectContainer):String
        {
            var targetPath:String;
            if (!(clip.parent))
            {
                return (clip.name);
            };
            targetPath = clip.name;
            return (getTargetPathImpl((clip.parent as DisplayObjectContainer), targetPath));
        }

        public static function queueInitCallback(ref:UIComponent):void
        {
            var parents:Array;
            var numParents:uint;
            var dict:Dictionary;
            var path:String = getTargetPathFor(ref);
            if (((useImmediateCallbacks) || (firingInitCallbacks)))
            {
                Extensions.CLIK_addedToStageCallback(ref.name, path, ref);
            }
            else
            {
                parents = path.split(".");
                numParents = (parents.length - 1);
                dict = initQueue[numParents];
                if (dict == null)
                {
                    dict = new Dictionary(true);
                    initQueue[numParents] = dict;
                    validDictIndices.push(numParents);
                    if (validDictIndices.length > 1)
                    {
                        validDictIndices.sort(sortFunc);
                    };
                };
                dict[ref] = path;
                if (!(isInitListenerActive))
                {
                    isInitListenerActive = true;
                    stage.addEventListener(Event.EXIT_FRAME, fireInitCallback, false, 0, true);
                };
            };
        }

        protected static function fireInitCallback(e:Event):void
        {
            var i:uint;
            var numParents:uint;
            var dict:Dictionary;
            var ref:Object;
            var comp:UIComponent;
            firingInitCallbacks = true;
            stage.removeEventListener(Event.EXIT_FRAME, fireInitCallback, false);
            isInitListenerActive = false;
            while (i < validDictIndices.length)
            {
                numParents = validDictIndices[i];
                dict = (initQueue[numParents] as Dictionary);
                for (ref in dict)
                {
                    comp = (ref as UIComponent);
                    Extensions.CLIK_addedToStageCallback(comp.name, dict[comp], comp);
                    dict[comp] = null;
                };
                i++;
            };
            validDictIndices.length = 0;
            clearQueue();
            firingInitCallbacks = false;
        }

        protected static function clearQueue():void
        {
            var numDict:*;
            for (numDict in initQueue)
            {
                initQueue[numDict] = null;
            };
        }

        protected static function sortFunc(a:uint, b:uint):Number
        {
            if (a < b)
            {
                return (-1);
            };
            if (a > b)
            {
                return (1);
            };
            return (0);
        }

        protected static function getTargetPathImpl(clip:DisplayObjectContainer, targetPath:String=""):String
        {
            var _name:String;
            if (!(clip))
            {
                return (targetPath);
            };
            _name = ((clip.name) ? (clip.name + ".") : "");
            targetPath = (_name + targetPath);
            return (getTargetPathImpl((clip.parent as DisplayObjectContainer), targetPath));
        }


    }
}//package scaleform.clik.core
