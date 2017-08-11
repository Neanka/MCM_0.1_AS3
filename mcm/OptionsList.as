// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//OptionsList

package mcm
{
    import Shared.AS3.BSScrollingList1;
	import fl.controls.Slider;
    import flash.events.KeyboardEvent;
    import flash.display.MovieClip;
    import flash.events.Event;
    import Shared.AS3.BSScrollingListEntry;
    import flash.ui.Keyboard;

    public class OptionsList extends mcm.ItemList
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
			switch (EntriesA[_arg_1.target.itemIndex].action) {
				case "GameSettingBool":
					try 
					{
						root.f4se.plugins.def_plugin.SetGSBool(EntriesA[_arg_1.target.itemIndex].id,EntriesA[_arg_1.target.itemIndex].value);
					}
					catch(e:Error)
					{
						trace("Failed to SetGSBool");
					}
					break;
				case "GlobalValue":
					try 
					{
						parent.parent.mcmCodeObj.SetGlobalValue(EntriesA[_arg_1.target.itemIndex].actionparams,Number(EntriesA[_arg_1.target.itemIndex].value));
					}
					catch(e:Error)
					{
						trace("Failed to SetGlobalValue");
					}
					break;
				default:
				
					break;
			}
			if (EntriesA[_arg_1.target.itemIndex].groupcontrol) 
			{
				if (EntriesA[_arg_1.target.itemIndex].value == 1) 
				{
					trace("checked");
					addfilterflag(EntriesA[_arg_1.target.itemIndex].groupcontrol);
				}
				else 
				{
					trace("unchecked");
					removefilterflag(EntriesA[_arg_1.target.itemIndex].groupcontrol);
				}
			}
        }
		
		public function setfilterflag(iFilterFlag: Number):*{
			this.filterer.itemFilter = Math.pow(2,iFilterFlag);			// move math.pow
			InvalidateData();
		}
		public function addfilterflag(iFilterFlag: Number):*{
			this.filterer.itemFilter = this.filterer.itemFilter | Math.pow(2,iFilterFlag);			
			InvalidateData();
		}
		public function removefilterflag(iFilterFlag: Number):*{
			this.filterer.itemFilter = this.filterer.itemFilter & ~Math.pow(2,iFilterFlag);			
			InvalidateData();
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
                    if (_arg_2.maxvalue != undefined)
                    {
                        _local_3.SetOptionSlider(_arg_2.minvalue,_arg_2.maxvalue,_arg_2.step);
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
		
		override protected function onItemPress(){
			if (((!this.bDisableInput) && (!this.bDisableSelection)) && (!(this.iSelectedIndex == -1))){
				dispatchEvent(new Event(ITEM_PRESS, true, true));
			} else {
				dispatchEvent(new Event(LIST_PRESS, true, true));
			};
		}

        override public function onKeyDown(_arg_1:KeyboardEvent)
        {
            var _local_2:BSScrollingListEntry;
            if (!bDisableInput)
            {
                super.onKeyDown(_arg_1);
                if ((!(this.selectedEntry == null)) && ((_arg_1.keyCode == Keyboard.LEFT) || (_arg_1.keyCode == Keyboard.RIGHT)))
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
		
		override public function moveSelectionUp(){
			var iprevFilterMatch:Number;
			if ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav)){
				if (this.selectedIndex > 0){
					var i: int = this.selectedIndex;
					while (i>0) 
					{
						iprevFilterMatch = this._filterer.GetPrevFilterMatch(i);
						switch (EntriesA[iprevFilterMatch].movieType)
						{
							case mcm.SettingsOptionItem.MOVIETYPE_SECTION:
							case mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE:
							case mcm.SettingsOptionItem.MOVIETYPE_TEXT:								
								break;
							default:
								if (iprevFilterMatch != int.MAX_VALUE){
									this.selectedIndex = iprevFilterMatch;
									this.bMouseDrivenNav = false;
									dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
									return;
								};
								break;
						}
						i--;
					}
				};
			} else {
				this.scrollPosition = (this.scrollPosition - 1);
			};
		}
		
		override public function moveSelectionDown(){
			var inextFilterMatch:Number;
            if ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav)){
				if (this.selectedIndex < (this.EntriesA.length - 1)){
					
					var i: int = this.selectedIndex;
					while (i<this.EntriesA.length - 1) 
					{
						inextFilterMatch = this._filterer.GetNextFilterMatch(i);
						switch (EntriesA[inextFilterMatch].movieType)
						{
							case mcm.SettingsOptionItem.MOVIETYPE_SECTION:
							case mcm.SettingsOptionItem.MOVIETYPE_EMPTY_LINE:
							case mcm.SettingsOptionItem.MOVIETYPE_TEXT:	
								
								break;
							default:
								if (inextFilterMatch != int.MAX_VALUE){
									this.selectedIndex = inextFilterMatch;
									this.bMouseDrivenNav = false;
									dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
									return;
								};
								break;
						}
						i++;
					}
				};
			} else {
				this.scrollPosition = (this.scrollPosition + 1);
			};
		}


    }
}//package 

