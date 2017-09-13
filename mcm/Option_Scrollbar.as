// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Option_Scrollbar

package mcm
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;
	import flash.text.TextField;

    public class Option_Scrollbar extends MovieClip 
    {

        public static const VALUE_CHANGE:String = "mcmOption_Scrollbar::VALUE_CHANGE";

        public var val_tf:TextField;
		public var Track_mc:MovieClip;
        public var Thumb_mc:MovieClip;
        public var LeftArrow_mc:MovieClip;
        public var RightArrow_mc:MovieClip;
        public var LeftCatcher_mc:MovieClip;
        public var RightCatcher_mc:MovieClip;
        public var BarCatcher_mc:MovieClip;
        private var fValue:Number;
        protected var fMinThumbX:Number;
        protected var fMaxThumbX:Number;
        private var fMinValue:Number = 0;
        private var fMaxValue:Number = 1;
        private var fStepSize:Number = 0.05;
        private var iStartDragThumb:int;
        private var fStartValue:Number;
		private var fOldValue:Number;
		private var _isDragging;

        public function Option_Scrollbar()
        {
            this.fMinThumbX = this.Track_mc.x;
            this.fMaxThumbX = ((this.Track_mc.x + this.Track_mc.width) - this.Thumb_mc.width);
            addEventListener(MouseEvent.CLICK, this.onClick);
            this.Thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
        }

        public function get MinValue():Number
        {
            return (this.fMinValue);
        }

        public function set MinValue(_arg_1:Number)
        {
            this.fMinValue = _arg_1;
        }

        public function get MaxValue():Number
        {
            return (this.fMaxValue);
        }

        public function set MaxValue(_arg_1:Number)
        {
            this.fMaxValue = _arg_1;
        }

        public function get StepSize():Number
        {
            return (this.fStepSize);
        }

        public function set StepSize(_arg_1:Number)
        {
            this.fStepSize = _arg_1;
        }

        public function get value():Number
        {
            return (this.fValue);
        }

        public function set value(_arg_1:Number)
        {
			var atemp:Number = Math.min(Math.max(_arg_1, this.fMinValue), this.fMaxValue); //TODO: Tune math.round position in whole script
			atemp = Math.round(atemp / fStepSize) * fStepSize;
			this.fValue = atemp;
            //this.fValue = Math.min(Math.max(_arg_1, this.fMinValue), this.fMaxValue);
            var _local_2:* = ((this.fValue - this.fMinValue) / (this.fMaxValue - this.fMinValue));
            if (!_isDragging) 
			{
				this.Thumb_mc.x = (this.fMinThumbX + (_local_2 * (this.fMaxThumbX - this.fMinThumbX)));
			}
			val_tf.text = String(this.fValue);
        }

        public function Decrement()
        {
            this.value = (this.value - this.fStepSize);
            dispatchEvent(new Event(VALUE_CHANGE, true, true));
        }

        public function Increment()
        {
            this.value = (this.value + this.fStepSize);
            dispatchEvent(new Event(VALUE_CHANGE, true, true));
        }

        public function HandleKeyboardInput(_arg_1:KeyboardEvent)
        {
            if ((((_arg_1.keyCode == Keyboard.LEFT)) && ((this.value > this.fMinValue))))
            {
                this.Decrement();
            } else
            {
                if ((((_arg_1.keyCode == Keyboard.RIGHT)) && ((this.value < this.fMaxValue))))
                {
                    this.Increment();
                };
            };
        }

        public function onClick(_arg_1:MouseEvent)
        {
            if (_arg_1.target == this.LeftCatcher_mc)
            {
                this.Decrement();
            } else
            {
                if (_arg_1.target == this.RightCatcher_mc)
                {
                    this.Increment();
                } else
                {
                    if (_arg_1.target == this.BarCatcher_mc)
                    {
						//var atemp:Number = ((_arg_1.currentTarget.mouseX / this.BarCatcher_mc.width) * (this.fMaxValue - this.fMinValue));
						//atemp = Math.round(atemp / fStepSize) * fStepSize;
						//this.value = atemp;
						this.value = ((_arg_1.currentTarget.mouseX-3) / this.BarCatcher_mc.width) * (this.fMaxValue - this.fMinValue); //_arg_1.currentTarget.mouseX-3 to tune position thumb sunder mouse
                        dispatchEvent(new Event(VALUE_CHANGE, true, true));
                    };
                };
            };
        }

        private function onThumbMouseDown(_arg_1:MouseEvent)
        {
			this._isDragging = true;
            this.Thumb_mc.startDrag(false, new Rectangle(3, this.Thumb_mc.y, (this.fMaxThumbX - this.fMinThumbX)+3, 0));
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
        }

        private function onThumbMouseMove(_arg_1:MouseEvent)
        {
			this.fOldValue = this.fValue;
			var offset:* = (this.Thumb_mc.x - this.fMinThumbX);
            var newValue: Number = this.fMinValue+Math.round((offset / fStepSize / (this.fMaxThumbX - this.fMinThumbX)) * (this.fMaxValue - this.fMinValue)) * fStepSize;
			if (newValue != this.fOldValue) 
			{
				this.value = newValue;
			    //dispatchEvent(new Event(VALUE_CHANGE, true, true));
			}
        }

        private function onThumbMouseUp(_arg_1:MouseEvent)
        {
            this.Thumb_mc.stopDrag();
			this._isDragging = false;
			dispatchEvent(new Event(VALUE_CHANGE, true, true));
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
        }


    }
}//package 

