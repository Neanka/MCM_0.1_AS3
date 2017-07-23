// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.COMPANIONAPP.MobileButtonHint

package Shared.AS3.COMPANIONAPP
{
    import Shared.AS3.BSButtonHint;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.ColorTransform;

    public dynamic class MobileButtonHint extends BSButtonHint 
    {

        private const BUTTON_MARGIN:Number = 4;

        public var background:MovieClip;

        public function MobileButtonHint()
        {
            addEventListener(MouseEvent.MOUSE_DOWN, this.onButtonPress);
        }

        private function onButtonPress(_arg_1:MouseEvent):void
        {
            if ((((!(ButtonDisabled))) && (ButtonVisible)))
            {
                this.setPressState();
            };
        }

        override protected function onMouseOut(_arg_1:MouseEvent)
        {
            super.onMouseOut(_arg_1);
            if ((((!(ButtonDisabled))) && (ButtonVisible)))
            {
                this.setNormalState();
            };
        }

        override public function onTextClick(_arg_1:Event):void
        {
            super.onTextClick(_arg_1);
            if ((((!(ButtonDisabled))) && (ButtonVisible)))
            {
                this.setNormalState();
            };
        }

        override public function redrawUIComponent():void
        {
            this.background.width = 1;
            this.background.height = 1;
            super.redrawUIComponent();
            this.background.width = (textField_tf.width + this.BUTTON_MARGIN);
            this.background.height = (textField_tf.height + this.BUTTON_MARGIN);
            if (Justification == JUSTIFY_RIGHT)
            {
                this.background.x = 0;
                this.textField_tf.x = 0;
                if (hitArea)
                {
                    hitArea.x = 0;
                };
            };
            if (hitArea)
            {
                hitArea.width = this.background.width;
                hitArea.height = this.background.height;
            };
            if (ButtonVisible)
            {
                if (ButtonDisabled)
                {
                    this.setDisableState();
                } else
                {
                    this.setNormalState();
                };
            };
        }

        protected function setNormalState():void
        {
            this.background.gotoAndPlay("normal");
            var _local_1:ColorTransform = textField_tf.transform.colorTransform;
            _local_1.redOffset = 0;
            _local_1.greenOffset = 0;
            _local_1.blueOffset = 0;
            textField_tf.transform.colorTransform = _local_1;
        }

        protected function setDisableState():void
        {
            this.setNormalState();
            this.background.gotoAndPlay("disabled");
        }

        protected function setPressState():void
        {
            this.background.gotoAndPlay("press");
            var _local_1:ColorTransform = textField_tf.transform.colorTransform;
            _local_1.redOffset = 0xFF;
            _local_1.greenOffset = 0xFF;
            _local_1.blueOffset = 0xFF;
            textField_tf.transform.colorTransform = _local_1;
        }


    }
}//package Shared.AS3.COMPANIONAPP

