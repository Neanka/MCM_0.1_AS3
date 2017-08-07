package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;

	public class Option_Scrollbar1 extends MovieClip
	{

		public static const VALUE_CHANGE: String = "Option_Scrollbar1::VALUE_CHANGE";
		public var Track_mc: MovieClip;
		public var Thumb_mc: MovieClip;
		public var LeftArrow_mc: MovieClip;
		public var RightArrow_mc: MovieClip;
		public var LeftCatcher_mc: MovieClip;
		public var RightCatcher_mc: MovieClip;
		public var BarCatcher_mc: MovieClip;
		private var fValue: Number;
		protected var fMinThumbX: Number;
		protected var fMaxThumbX: Number;
		private var fMinValue: Number = 0;
		private var fMaxValue: Number = 1;
		private var fStepSize: Number = 1;
		private var iStartDragThumb: int;
		private var fStartValue: Number;
		public var oldvalue: Number;

		public function Option_Scrollbar1()
		{
			super();
			Track_mc = new MovieClip();
			Track_mc.graphics.beginFill(0xCCCCCC, 0.1);
			Track_mc.graphics.drawRect(0, 0, 350, 5);
			Track_mc.graphics.endFill();
			addChild(Track_mc);
			Thumb_mc = new MovieClip();
			Thumb_mc.graphics.beginFill(0xCCCCCC, 1);
			Thumb_mc.graphics.drawRect(0, 0, 20, 5);
			Thumb_mc.graphics.endFill();
			addChild(Thumb_mc);
			LeftArrow_mc = new MovieClip();
			LeftArrow_mc.graphics.lineStyle(3, 0xCCCCCC, 1);
			LeftArrow_mc.graphics.moveTo(-3, -4);
			LeftArrow_mc.graphics.lineTo(-8, 3);
			LeftArrow_mc.graphics.lineTo(-3, 10);
			addChild(LeftArrow_mc);
			LeftArrow_mc.x = -2;
			RightArrow_mc = new MovieClip();
			RightArrow_mc.graphics.lineStyle(3, 0xCCCCCC, 1);
			RightArrow_mc.graphics.moveTo(3, -4);
			RightArrow_mc.graphics.lineTo(8, 3);
			RightArrow_mc.graphics.lineTo(3, 10);
			addChild(RightArrow_mc);
			RightArrow_mc.x = 353;
			ValueInit();
			addEventListener(MouseEvent.CLICK, this.onClick);
			this.Thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, this.onThumbMouseDown);
		}
		
		public function get MinValue(): Number
		{
			return (this.fMinValue);
		}
		
		public function set MinValue(afMinValue: Number)
		{
			this.fMinValue = afMinValue;
		}
		
		public function get MaxValue(): Number
		{
			return (this.fMaxValue);
		}
		
		public function ValueInit()
		{
			this.fMinThumbX = this.Track_mc.x;
			this.fMaxThumbX = ((this.Track_mc.x + this.Track_mc.width) - this.Thumb_mc.width);
			this.Track_mc.alpha = 0;
		}
		
		public function set MaxValue(afMaxValue: Number)
		{
			this.fMaxValue = afMaxValue;
		}
		
		public function get StepSize(): Number
		{
			return (this.fStepSize);
		}
		
		public function set StepSize(afStepSize: Number)
		{
			this.fStepSize = afStepSize;
		}
		
		public function get value(): Number
		{
			return (this.fValue);
		}
		
		public function set value(afValue: Number)
		{
			this.oldvalue = this.fValue;
			this.fValue = Math.min(Math.max(afValue, this.fMinValue), this.fMaxValue);
			var finterp: * = ((this.fValue - this.fMinValue) / (this.fMaxValue - this.fMinValue));
			this.Thumb_mc.x = (this.fMinThumbX + (finterp * (this.fMaxThumbX - this.fMinThumbX)));
		}
		
		public function set selfvalue(afValue: Number)
		{
			this.oldvalue = this.fValue;
			this.fValue = Math.min(Math.max(afValue, this.fMinValue), this.fMaxValue);
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
		
		public function HandleKeyboardInput(event: KeyboardEvent)
		{
			if ((((event.keyCode == Keyboard.LEFT)) && ((this.value > 0))))
			{
				this.Decrement();
			}
			else
			{
				if ((((event.keyCode == Keyboard.RIGHT)) && ((this.value < 1))))
				{
					this.Increment();
				};
			};
		}
		
		public function onClick(event: MouseEvent)
		{
			if (event.target == this.LeftCatcher_mc)
			{
				this.Decrement();
			}
			else
			{
				if (event.target == this.RightCatcher_mc)
				{
					this.Increment();
				}
				else
				{
					if (event.target == this.BarCatcher_mc)
					{
						this.value = ((event.currentTarget.mouseX / this.BarCatcher_mc.width) * (this.fMaxValue - this.fMinValue));
						dispatchEvent(new Event(VALUE_CHANGE, true, true));
					};
				};
			};
		}
		
		private function onThumbMouseDown(event: MouseEvent)
		{
			this.Thumb_mc.startDrag(false, new Rectangle(0, this.Thumb_mc.y, (this.fMaxThumbX - this.fMinThumbX), 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
		
		private function onThumbMouseMove(events: MouseEvent)
		{
			var offset: * = (this.Thumb_mc.x - this.fMinThumbX);
			this.selfvalue = this.fMinValue + Math.round((offset / fStepSize / (this.fMaxThumbX - this.fMinThumbX)) * (this.fMaxValue - this.fMinValue)) * fStepSize;
			dispatchEvent(new Event(VALUE_CHANGE, true, true));

		}
		
		private function onThumbMouseUp(event: MouseEvent)
		{
			this.Thumb_mc.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.onThumbMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onThumbMouseMove);
		}
	}
}