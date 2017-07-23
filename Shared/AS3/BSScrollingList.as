// Decompiled by AS3 Sorcerer 4.99
// www.as3sorcerer.com

//Shared.AS3.BSScrollingList

package Shared.AS3
{
    import flash.display.MovieClip;
    import Mobile.ScrollList.MobileScrollList;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import Shared.AS3.COMPANIONAPP.CompanionAppMode;
    import Shared.PlatformChangeEvent;
    import flash.ui.Keyboard;
    import flash.geom.Point;
    import flash.utils.getDefinitionByName;
    import __AS3__.vec.Vector;
    import Shared.AS3.COMPANIONAPP.BSScrollingListInterface;
    import Mobile.ScrollList.MobileListItemRenderer;
    import Mobile.ScrollList.EventWithParams;
    import __AS3__.vec.*;

    public class BSScrollingList extends MovieClip 
    {

        public static const TEXT_OPTION_NONE:String = "None";
        public static const TEXT_OPTION_SHRINK_TO_FIT:String = "Shrink To Fit";
        public static const TEXT_OPTION_MULTILINE:String = "Multi-Line";
        public static const SELECTION_CHANGE:String = "BSScrollingList::selectionChange";
        public static const ITEM_PRESS:String = "BSScrollingList::itemPress";
        public static const LIST_PRESS:String = "BSScrollingList::listPress";
        public static const LIST_ITEMS_CREATED:String = "BSScrollingList::listItemsCreated";
        public static const PLAY_FOCUS_SOUND:String = "BSScrollingList::playFocusSound";
        public static const MOBILE_ITEM_PRESS:String = "BSScrollingList::mobileItemPress";

        public var scrollList:MobileScrollList;
        private var _itemRendererClassName:String;
        public var border:MovieClip;
        public var ScrollUp:MovieClip;
        public var ScrollDown:MovieClip;
        protected var EntriesA:Array;
        protected var EntryHolder_mc:MovieClip;
        protected var _filterer:ListFilterer;
        protected var iSelectedIndex:int;
        protected var iSelectedClipIndex:int;
        protected var bRestoreListIndex:Boolean;
        protected var iListItemsShown:uint;
        protected var uiNumListItems:uint;
        protected var ListEntryClass:Class;
        protected var fListHeight:Number;
        protected var fVerticalSpacing:Number;
        protected var iScrollPosition:uint;
        protected var iMaxScrollPosition:uint;
        protected var bMouseDrivenNav:Boolean;
        protected var fShownItemsHeight:Number;
        protected var iPlatform:Number;
        protected var bInitialized:Boolean;
        protected var strTextOption:String;
        protected var bDisableSelection:Boolean;
        protected var bAllowSelectionDisabledListNav:Boolean;
        protected var bDisableInput:Boolean;
        protected var bReverseList:Boolean;
        protected var bUpdated:Boolean;

        public function BSScrollingList()
        {
            this.EntriesA = new Array();
            this._filterer = new ListFilterer();
            addEventListener(ListFilterer.FILTER_CHANGE, this.onFilterChange);
            this.strTextOption = TEXT_OPTION_NONE;
            this.fVerticalSpacing = 0;
            this.uiNumListItems = 0;
            this.bRestoreListIndex = true;
            this.bDisableSelection = false;
            this.bAllowSelectionDisabledListNav = false;
            this.bDisableInput = false;
            this.bMouseDrivenNav = false;
            this.bReverseList = false;
            this.bUpdated = false;
            this.bInitialized = false;
            if (loaderInfo != null)
            {
                loaderInfo.addEventListener(Event.INIT, this.onComponentInit);
            };
            addEventListener(Event.ADDED_TO_STAGE, this.onStageInit);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onStageDestruct);
            addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            if (!this.needMobileScrollList)
            {
                addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            };
            if (this.border == null)
            {
                throw (new Error("No 'border' clip found.  BSScrollingList requires a border rect to define its extents."));
            };
            this.EntryHolder_mc = new MovieClip();
            this.addChildAt(this.EntryHolder_mc, (this.getChildIndex(this.border) + 1));
            this.iSelectedIndex = -1;
            this.iSelectedClipIndex = -1;
            this.iScrollPosition = 0;
            this.iMaxScrollPosition = 0;
            this.iListItemsShown = 0;
            this.fListHeight = 0;
            this.iPlatform = 1;
        }

        private function get needMobileScrollList():Boolean
        {
            return (CompanionAppMode.isOn);
        }

        public function onComponentInit(_arg_1:Event):*
        {
            if (this.needMobileScrollList)
            {
                this.createMobileScrollingList();
                if (this.border != null)
                {
                    this.border.alpha = 0;
                };
            };
            if (loaderInfo != null)
            {
                loaderInfo.removeEventListener(Event.INIT, this.onComponentInit);
            };
            if (!this.bInitialized)
            {
                this.SetNumListItems(this.uiNumListItems);
            };
        }

        protected function onStageInit(_arg_1:Event):*
        {
            stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatform);
            if (!this.bInitialized)
            {
                this.SetNumListItems(this.uiNumListItems);
            };
            if (((!(this.ScrollUp == null)) && (!(CompanionAppMode.isOn))))
            {
                this.ScrollUp.addEventListener(MouseEvent.CLICK, this.onScrollArrowClick);
            };
            if (((!(this.ScrollDown == null)) && (!(CompanionAppMode.isOn))))
            {
                this.ScrollDown.addEventListener(MouseEvent.CLICK, this.onScrollArrowClick);
            };
        }

        protected function onStageDestruct(_arg_1:Event):*
        {
            stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatform);
            if (this.needMobileScrollList)
            {
                this.destroyMobileScrollingList();
            };
        }

        public function onScrollArrowClick(_arg_1:Event):*
        {
            if (((!(this.bDisableInput)) && ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav))))
            {
                this.doSetSelectedIndex(-1);
                if (((_arg_1.target == this.ScrollUp) || (_arg_1.target.parent == this.ScrollUp)))
                {
                    this.scrollPosition = (this.scrollPosition - 1);
                }
                else
                {
                    if (((_arg_1.target == this.ScrollDown) || (_arg_1.target.parent == this.ScrollDown)))
                    {
                        this.scrollPosition = (this.scrollPosition + 1);
                    };
                };
                _arg_1.stopPropagation();
            };
        }

        public function onEntryRollover(_arg_1:Event):*
        {
            var _local_2:*;
            this.bMouseDrivenNav = true;
            if (((!(this.bDisableInput)) && (!(this.bDisableSelection))))
            {
                _local_2 = this.iSelectedIndex;
                this.doSetSelectedIndex((_arg_1.currentTarget as BSScrollingListEntry).itemIndex);
                if (_local_2 != this.iSelectedIndex)
                {
                    dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
                };
            };
        }

        public function onEntryPress(_arg_1:MouseEvent):*
        {
            _arg_1.stopPropagation();
            this.bMouseDrivenNav = true;
            this.onItemPress();
        }

        public function ClearList():*
        {
            this.EntriesA.splice(0, this.EntriesA.length);
        }

        public function GetClipByIndex(_arg_1:uint):BSScrollingListEntry
        {
            return ((_arg_1 < this.EntryHolder_mc.numChildren) ? (this.EntryHolder_mc.getChildAt(_arg_1) as BSScrollingListEntry) : null);
        }

        public function GetEntryFromClipIndex(_arg_1:int):int
        {
            var _local_2:int = -1;
            var _local_3:uint;
            while (_local_3 < this.EntriesA.length)
            {
                if (this.EntriesA[_local_3].clipIndex <= _arg_1)
                {
                    _local_2 = _local_3;
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function onKeyDown(_arg_1:KeyboardEvent):*
        {
            if (!this.bDisableInput)
            {
                if (_arg_1.keyCode == Keyboard.UP)
                {
                    this.moveSelectionUp();
                    _arg_1.stopPropagation();
                }
                else
                {
                    if (_arg_1.keyCode == Keyboard.DOWN)
                    {
                        this.moveSelectionDown();
                        _arg_1.stopPropagation();
                    };
                };
            };
        }

        public function onKeyUp(_arg_1:KeyboardEvent):*
        {
            if ((((!(this.bDisableInput)) && (!(this.bDisableSelection))) && (_arg_1.keyCode == Keyboard.ENTER)))
            {
                this.onItemPress();
                _arg_1.stopPropagation();
            };
        }

        public function onMouseWheel(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            if ((((!(this.bDisableInput)) && ((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav))) && (this.iMaxScrollPosition > 0)))
            {
                _local_2 = this.scrollPosition;
                if (_arg_1.delta < 0)
                {
                    this.scrollPosition = (this.scrollPosition + 1);
                }
                else
                {
                    if (_arg_1.delta > 0)
                    {
                        this.scrollPosition = (this.scrollPosition - 1);
                    };
                };
                this.SetFocusUnderMouse();
                _arg_1.stopPropagation();
                if (_local_2 != this.scrollPosition)
                {
                    dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
                };
            };
        }

        private function SetFocusUnderMouse():*
        {
            var _local_2:BSScrollingListEntry;
            var _local_3:MovieClip;
            var _local_4:Point;
            var _local_1:int;
            while (_local_1 < this.iListItemsShown)
            {
                _local_2 = this.GetClipByIndex(_local_1);
                _local_3 = _local_2.border;
                _local_4 = localToGlobal(new Point(mouseX, mouseY));
                if (_local_2.hitTestPoint(_local_4.x, _local_4.y, false))
                {
                    this.selectedIndex = _local_2.itemIndex;
                };
                _local_1++;
            };
        }

        public function get filterer():ListFilterer
        {
            return (this._filterer);
        }

        public function get itemsShown():uint
        {
            return (this.iListItemsShown);
        }

        public function get initialized():Boolean
        {
            return (this.bInitialized);
        }

        public function get selectedIndex():int
        {
            return (this.iSelectedIndex);
        }

        public function set selectedIndex(_arg_1:int):*
        {
            this.doSetSelectedIndex(_arg_1);
        }

        public function get selectedClipIndex():int
        {
            return (this.iSelectedClipIndex);
        }

        public function set selectedClipIndex(_arg_1:int):*
        {
            this.doSetSelectedIndex(this.GetEntryFromClipIndex(_arg_1));
        }

        public function set filterer(_arg_1:ListFilterer):*
        {
            this._filterer = _arg_1;
        }

        public function get shownItemsHeight():Number
        {
            return (this.fShownItemsHeight);
        }

        protected function doSetSelectedIndex(_arg_1:int):*
        {
            var _local_2:int;
            var _local_3:Boolean;
            var _local_4:int;
            var _local_5:BSScrollingListEntry;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:uint;
            if (((!(this.bInitialized)) || (this.numListItems == 0)))
            {
                trace("BSScrollingList::doSetSelectedIndex -- Can't set selection before list has been created.");
            };
            if (((!(this.bDisableSelection)) && (!(_arg_1 == this.iSelectedIndex))))
            {
                _local_2 = this.iSelectedIndex;
                this.iSelectedIndex = _arg_1;
                if (this.EntriesA.length == 0)
                {
                    this.iSelectedIndex = -1;
                };
                if ((((!(_local_2 == -1)) && (_local_2 < this.EntriesA.length)) && (!(this.EntriesA[_local_2].clipIndex == int.MAX_VALUE))))
                {
                    this.SetEntry(this.GetClipByIndex(this.EntriesA[_local_2].clipIndex), this.EntriesA[_local_2]);
                };
                if (this.iSelectedIndex != -1)
                {
                    this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
                    if (this.iSelectedIndex == int.MAX_VALUE)
                    {
                        this.iSelectedIndex = -1;
                    };
                    if (((!(this.iSelectedIndex == -1)) && (!(_local_2 == this.iSelectedIndex))))
                    {
                        _local_3 = false;
                        if (this.textOption == TEXT_OPTION_MULTILINE)
                        {
                            _local_4 = this.GetEntryFromClipIndex((this.uiNumListItems - 1));
                            if ((((!(_local_4 == -1)) && (_local_4 == this.iSelectedIndex)) && (!(this.EntriesA[_local_4].clipIndex == int.MAX_VALUE))))
                            {
                                _local_5 = this.GetClipByIndex(this.EntriesA[_local_4].clipIndex);
                                if (((!(_local_5 == null)) && ((_local_5.y + _local_5.height) > this.fListHeight)))
                                {
                                    _local_3 = true;
                                };
                            };
                        };
                        if (((!(this.EntriesA[this.iSelectedIndex].clipIndex == int.MAX_VALUE)) && (!(_local_3))))
                        {
                            this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex), this.EntriesA[this.iSelectedIndex]);
                        }
                        else
                        {
                            _local_6 = this.GetEntryFromClipIndex(0);
                            _local_7 = this.GetEntryFromClipIndex((this.uiNumListItems - 1));
                            _local_9 = 0;
                            if (this.iSelectedIndex < _local_6)
                            {
                                _local_8 = _local_6;
                                do 
                                {
                                    _local_8 = this._filterer.GetPrevFilterMatch(_local_8);
                                    _local_9--;
                                } while (_local_8 != this.iSelectedIndex);
                            }
                            else
                            {
                                if (this.iSelectedIndex > _local_7)
                                {
                                    _local_8 = _local_7;
                                    do 
                                    {
                                        _local_8 = this._filterer.GetNextFilterMatch(_local_8);
                                        _local_9++;
                                    } while (_local_8 != this.iSelectedIndex);
                                }
                                else
                                {
                                    if (_local_3)
                                    {
                                        _local_9++;
                                    };
                                };
                            };
                            this.scrollPosition = (this.scrollPosition + _local_9);
                        };
                    };
                    if (this.needMobileScrollList)
                    {
                        if (this.scrollList != null)
                        {
                            if (this.iSelectedIndex != -1)
                            {
                                _local_10 = this.EntriesA[this.iSelectedIndex].clipIndex;
                                _local_11 = 0;
                                while (_local_11 < this.scrollList.data.length)
                                {
                                    if (this.EntriesA[this.iSelectedIndex] == this.scrollList.data[_local_11])
                                    {
                                        _local_10 = _local_11;
                                        break;
                                    };
                                    _local_11++;
                                };
                                this.scrollList.selectedIndex = _local_10;
                            }
                            else
                            {
                                this.scrollList.selectedIndex = -1;
                            };
                        };
                    };
                };
                if (_local_2 != this.iSelectedIndex)
                {
                    this.iSelectedClipIndex = ((this.iSelectedIndex != -1) ? this.EntriesA[this.iSelectedIndex].clipIndex : -1);
                    dispatchEvent(new Event(SELECTION_CHANGE, true, true));
                };
            };
        }

        public function get scrollPosition():uint
        {
            return (this.iScrollPosition);
        }

        public function get maxScrollPosition():uint
        {
            return (this.iMaxScrollPosition);
        }

        public function set scrollPosition(_arg_1:uint):*
        {
            if ((((!(_arg_1 == this.iScrollPosition)) && (_arg_1 >= 0)) && (_arg_1 <= this.iMaxScrollPosition)))
            {
                this.updateScrollPosition(_arg_1);
            };
        }

        protected function updateScrollPosition(_arg_1:uint):*
        {
            this.iScrollPosition = _arg_1;
            this.UpdateList();
        }

        public function get selectedEntry():Object
        {
            return (this.EntriesA[this.iSelectedIndex]);
        }

        public function get entryList():Array
        {
            return (this.EntriesA);
        }

        public function set entryList(_arg_1:Array):*
        {
            this.EntriesA = _arg_1;
            if (this.EntriesA == null)
            {
                this.EntriesA = new Array();
            };
        }

        public function get disableInput():Boolean
        {
            return (this.bDisableInput);
        }

        public function set disableInput(_arg_1:Boolean):*
        {
            this.bDisableInput = _arg_1;
        }

        public function get textOption():String
        {
            return (this.strTextOption);
        }

        public function set textOption(_arg_1:String):*
        {
            this.strTextOption = _arg_1;
        }

        public function get verticalSpacing():*
        {
            return (this.fVerticalSpacing);
        }

        public function set verticalSpacing(_arg_1:Number):*
        {
            this.fVerticalSpacing = _arg_1;
        }

        public function get numListItems():uint
        {
            return (this.uiNumListItems);
        }

        public function set numListItems(_arg_1:uint):*
        {
            this.uiNumListItems = _arg_1;
        }

        public function set listEntryClass(_arg_1:String):*
        {
            this.ListEntryClass = (getDefinitionByName(_arg_1) as Class);
            this._itemRendererClassName = _arg_1;
        }

        public function get restoreListIndex():Boolean
        {
            return (this.bRestoreListIndex);
        }

        public function set restoreListIndex(_arg_1:Boolean):*
        {
            this.bRestoreListIndex = _arg_1;
        }

        public function get disableSelection():Boolean
        {
            return (this.bDisableSelection);
        }

        public function set disableSelection(_arg_1:Boolean):*
        {
            this.bDisableSelection = _arg_1;
        }

        public function set allowWheelScrollNoSelectionChange(_arg_1:Boolean):*
        {
            this.bAllowSelectionDisabledListNav = _arg_1;
        }

        protected function SetNumListItems(_arg_1:uint):*
        {
            var _local_2:uint;
            var _local_3:MovieClip;
            if (((!(this.ListEntryClass == null)) && (_arg_1 > 0)))
            {
                _local_2 = 0;
                while (_local_2 < _arg_1)
                {
                    _local_3 = this.GetNewListEntry(_local_2);
                    if (_local_3 != null)
                    {
                        _local_3.clipIndex = _local_2;
                        _local_3.addEventListener(MouseEvent.MOUSE_OVER, this.onEntryRollover);
                        _local_3.addEventListener(MouseEvent.CLICK, this.onEntryPress);
                        this.EntryHolder_mc.addChild(_local_3);
                    }
                    else
                    {
                        trace("BSScrollingList::SetNumListItems -- List Entry Class is invalid or does not derive from BSScrollingListEntry.");
                    };
                    _local_2++;
                };
                this.bInitialized = true;
                dispatchEvent(new Event(LIST_ITEMS_CREATED, true, true));
            };
        }

        protected function GetNewListEntry(_arg_1:uint):BSScrollingListEntry
        {
            return (new this.ListEntryClass() as BSScrollingListEntry);
        }

        public function UpdateList():*
        {
            var _local_7:BSScrollingListEntry;
            var _local_8:BSScrollingListEntry;
            if (((!(this.bInitialized)) || (this.numListItems == 0)))
            {
                trace("BSScrollingList::UpdateList -- Can't update list before list has been created.");
            };
            var _local_1:Number = 0;
            var _local_2:Number = this._filterer.ClampIndex(0);
            var _local_3:Number = _local_2;
            var _local_4:uint;
            while (_local_4 < this.EntriesA.length)
            {
                this.EntriesA[_local_4].clipIndex = int.MAX_VALUE;
                if (_local_4 < this.iScrollPosition)
                {
                    _local_2 = this._filterer.GetNextFilterMatch(_local_2);
                };
                _local_4++;
            };
            var _local_5:uint;
            while (_local_5 < this.uiNumListItems)
            {
                _local_7 = this.GetClipByIndex(_local_5);
                if (_local_7)
                {
                    _local_7.visible = false;
                    _local_7.itemIndex = int.MAX_VALUE;
                };
                _local_5++;
            };
            var _local_6:Vector.<Object> = new Vector.<Object>();
            this.iListItemsShown = 0;
            if (this.needMobileScrollList)
            {
                while (((((!(_local_3 == int.MAX_VALUE)) && (!(_local_3 == -1))) && (_local_3 < this.EntriesA.length)) && (_local_1 <= this.fListHeight)))
                {
                    _local_6.push(this.EntriesA[_local_3]);
                    _local_3 = this._filterer.GetNextFilterMatch(_local_3);
                };
            };
            while ((((((!(_local_2 == int.MAX_VALUE)) && (!(_local_2 == -1))) && (_local_2 < this.EntriesA.length)) && (this.iListItemsShown < this.uiNumListItems)) && (_local_1 <= this.fListHeight)))
            {
                _local_8 = this.GetClipByIndex(this.iListItemsShown);
                if (_local_8)
                {
                    this.SetEntry(_local_8, this.EntriesA[_local_2]);
                    this.EntriesA[_local_2].clipIndex = this.iListItemsShown;
                    _local_8.itemIndex = _local_2;
                    _local_8.visible = (!(this.needMobileScrollList));
                    _local_1 = (_local_1 + _local_8.height);
                    if (((_local_1 <= this.fListHeight) && (this.iListItemsShown < this.uiNumListItems)))
                    {
                        _local_1 = (_local_1 + this.fVerticalSpacing);
                        this.iListItemsShown++;
                    }
                    else
                    {
                        if (this.textOption != TEXT_OPTION_MULTILINE)
                        {
                            this.EntriesA[_local_2].clipIndex = int.MAX_VALUE;
                            _local_8.visible = false;
                        }
                        else
                        {
                            this.iListItemsShown++;
                        };
                    };
                };
                _local_2 = this._filterer.GetNextFilterMatch(_local_2);
            };
            if (this.needMobileScrollList)
            {
                this.setMobileScrollingListData(_local_6);
            };
            this.PositionEntries();
            if (this.ScrollUp != null)
            {
                this.ScrollUp.visible = (this.scrollPosition > 0);
            };
            if (this.ScrollDown != null)
            {
                this.ScrollDown.visible = (this.scrollPosition < this.iMaxScrollPosition);
            };
            this.bUpdated = true;
        }

        protected function PositionEntries():*
        {
            var _local_1:Number = 0;
            var _local_2:Number = this.border.y;
            var _local_3:int;
            while (_local_3 < this.iListItemsShown)
            {
                this.GetClipByIndex(_local_3).y = (_local_2 + _local_1);
                _local_1 = (_local_1 + (this.GetClipByIndex(_local_3).height + this.fVerticalSpacing));
                _local_3++;
            };
            this.fShownItemsHeight = _local_1;
        }

        public function InvalidateData():*
        {
            var _local_1:Boolean;
            this._filterer.filterArray = this.EntriesA;
            this.fListHeight = this.border.height;
            this.CalculateMaxScrollPosition();
            if (!this.restoreListIndex)
            {
                if (this.iSelectedIndex >= this.EntriesA.length)
                {
                    this.iSelectedIndex = (this.EntriesA.length - 1);
                    _local_1 = true;
                };
            };
            if (this.iScrollPosition > this.iMaxScrollPosition)
            {
                this.iScrollPosition = this.iMaxScrollPosition;
            };
            this.UpdateList();
            if (((this.restoreListIndex) && (!(this.needMobileScrollList))))
            {
                this.selectedClipIndex = this.iSelectedClipIndex;
            }
            else
            {
                if (_local_1)
                {
                    dispatchEvent(new Event(SELECTION_CHANGE, true, true));
                };
            };
        }

        public function UpdateSelectedEntry():*
        {
            if (this.iSelectedIndex != -1)
            {
                this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex), this.EntriesA[this.iSelectedIndex]);
            };
        }

        public function UpdateEntry(_arg_1:Object):*
        {
            this.SetEntry(this.GetClipByIndex(_arg_1.clipIndex), _arg_1);
        }

        public function onFilterChange():*
        {
            this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
            this.CalculateMaxScrollPosition();
        }

        protected function CalculateMaxScrollPosition():*
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_1:int = ((this._filterer.EntryMatchesFilter(this.EntriesA[(this.EntriesA.length - 1)])) ? (this.EntriesA.length - 1) : this._filterer.GetPrevFilterMatch((this.EntriesA.length - 1)));
            if (_local_1 == int.MAX_VALUE)
            {
                this.iMaxScrollPosition = 0;
            }
            else
            {
                _local_2 = this.GetEntryHeight(_local_1);
                _local_3 = _local_1;
                _local_4 = 1;
                while ((((!(_local_3 == int.MAX_VALUE)) && (_local_2 < this.fListHeight)) && (_local_4 < this.uiNumListItems)))
                {
                    _local_5 = _local_3;
                    _local_3 = this._filterer.GetPrevFilterMatch(_local_3);
                    if (_local_3 != int.MAX_VALUE)
                    {
                        _local_2 = (_local_2 + (this.GetEntryHeight(_local_3) + this.fVerticalSpacing));
                        if (_local_2 < this.fListHeight)
                        {
                            _local_4++;
                        }
                        else
                        {
                            _local_3 = _local_5;
                        };
                    };
                };
                if (_local_3 == int.MAX_VALUE)
                {
                    this.iMaxScrollPosition = 0;
                }
                else
                {
                    _local_6 = 0;
                    _local_7 = this._filterer.GetPrevFilterMatch(_local_3);
                    while (_local_7 != int.MAX_VALUE)
                    {
                        _local_6++;
                        _local_7 = this._filterer.GetPrevFilterMatch(_local_7);
                    };
                    this.iMaxScrollPosition = _local_6;
                };
            };
        }

        protected function GetEntryHeight(_arg_1:Number):Number
        {
            var _local_2:BSScrollingListEntry = this.GetClipByIndex(0);
            var _local_3:Number = 0;
            if (_local_2 != null)
            {
                if (_local_2.hasDynamicHeight)
                {
                    this.SetEntry(_local_2, this.EntriesA[_arg_1]);
                    _local_3 = _local_2.height;
                }
                else
                {
                    _local_3 = _local_2.defaultHeight;
                };
            };
            return (_local_3);
        }

        public function moveSelectionUp():*
        {
            var _local_1:Number;
            if (((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav)))
            {
                if (this.selectedIndex > 0)
                {
                    _local_1 = this._filterer.GetPrevFilterMatch(this.selectedIndex);
                    if (_local_1 != int.MAX_VALUE)
                    {
                        this.selectedIndex = _local_1;
                        this.bMouseDrivenNav = false;
                        dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
                    };
                };
            }
            else
            {
                this.scrollPosition = (this.scrollPosition - 1);
            };
        }

        public function moveSelectionDown():*
        {
            var _local_1:Number;
            if (((!(this.bDisableSelection)) || (this.bAllowSelectionDisabledListNav)))
            {
                if (this.selectedIndex < (this.EntriesA.length - 1))
                {
                    _local_1 = this._filterer.GetNextFilterMatch(this.selectedIndex);
                    if (_local_1 != int.MAX_VALUE)
                    {
                        this.selectedIndex = _local_1;
                        this.bMouseDrivenNav = false;
                        dispatchEvent(new Event(PLAY_FOCUS_SOUND, true, true));
                    };
                };
            }
            else
            {
                this.scrollPosition = (this.scrollPosition + 1);
            };
        }

        protected function onItemPress():*
        {
            if ((((!(this.bDisableInput)) && (!(this.bDisableSelection))) && (!(this.iSelectedIndex == -1))))
            {
                dispatchEvent(new Event(ITEM_PRESS, true, true));
            }
            else
            {
                dispatchEvent(new Event(LIST_PRESS, true, true));
            };
        }

        protected function SetEntry(_arg_1:BSScrollingListEntry, _arg_2:Object):*
        {
            if (_arg_1 != null)
            {
                _arg_1.selected = (_arg_2 == this.selectedEntry);
                _arg_1.SetEntryText(_arg_2, this.strTextOption);
            };
        }

        protected function onSetPlatform(_arg_1:Event):*
        {
            var _local_2:PlatformChangeEvent = (_arg_1 as PlatformChangeEvent);
            this.SetPlatform(_local_2.uiPlatform, _local_2.bPS3Switch);
        }

        public function SetPlatform(_arg_1:Number, _arg_2:Boolean):*
        {
            this.iPlatform = _arg_1;
            this.bMouseDrivenNav = ((this.iPlatform == 0) ? true : false);
        }

        protected function createMobileScrollingList():void
        {
            var _local_1:Number;
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:String;
            var _local_5:Boolean;
            var _local_6:Boolean;
            if (this._itemRendererClassName != null)
            {
                _local_1 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).maskDimension;
                _local_2 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).spaceBetweenButtons;
                _local_3 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).scrollDirection;
                _local_4 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).linkageId;
                _local_5 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).clickable;
                _local_6 = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).reversed;
                this.scrollList = new MobileScrollList(_local_1, _local_2, _local_3);
                this.scrollList.itemRendererLinkageId = _local_4;
                this.scrollList.noScrollShortList = true;
                this.scrollList.clickable = _local_5;
                this.scrollList.endListAlign = _local_6;
                this.scrollList.textOption = this.strTextOption;
                this.scrollList.setScrollIndicators(this.ScrollUp, this.ScrollDown);
                this.scrollList.x = 0;
                this.scrollList.y = 0;
                addChild(this.scrollList);
                this.scrollList.addEventListener(MobileScrollList.ITEM_SELECT, this.onMobileScrollListItemSelected, false, 0, true);
            };
        }

        protected function destroyMobileScrollingList():void
        {
            if (this.scrollList != null)
            {
                this.scrollList.removeEventListener(MobileScrollList.ITEM_SELECT, this.onMobileScrollListItemSelected);
                removeChild(this.scrollList);
                this.scrollList.destroy();
            };
        }

        protected function onMobileScrollListItemSelected(_arg_1:EventWithParams):void
        {
            var _local_2:MobileListItemRenderer = (_arg_1.params.renderer as MobileListItemRenderer);
            if (_local_2.data == null)
            {
                return;
            };
            var _local_3:int = _local_2.data.id;
            var _local_4:* = this.iSelectedIndex;
            this.iSelectedIndex = this.GetEntryFromClipIndex(_local_3);
            var _local_5:uint;
            while (_local_5 < this.EntriesA.length)
            {
                if (this.EntriesA[_local_5] == _local_2.data)
                {
                    this.iSelectedIndex = _local_5;
                    break;
                };
                _local_5++;
            };
            if (!this.EntriesA[this.iSelectedIndex].isDivider)
            {
                if (_local_4 != this.iSelectedIndex)
                {
                    this.iSelectedClipIndex = ((this.iSelectedIndex != -1) ? this.EntriesA[this.iSelectedIndex].clipIndex : -1);
                    dispatchEvent(new Event(SELECTION_CHANGE, true, true));
                    if (this.scrollList.itemRendererLinkageId == BSScrollingListInterface.PIPBOY_MESSAGE_RENDERER_LINKAGE_ID)
                    {
                        this.onItemPress();
                    };
                    dispatchEvent(new Event(MOBILE_ITEM_PRESS, true, true));
                }
                else
                {
                    if ((((((this.scrollList.itemRendererLinkageId == BSScrollingListInterface.RADIO_RENDERER_LINKAGE_ID) || (this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_RENDERER_LINKAGE_ID)) || (this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_OBJECTIVES_RENDERER_LINKAGE_ID)) || (this.scrollList.itemRendererLinkageId == BSScrollingListInterface.INVENTORY_RENDERER_LINKAGE_ID)) || (this.scrollList.itemRendererLinkageId == BSScrollingListInterface.PIPBOY_MESSAGE_RENDERER_LINKAGE_ID)))
                    {
                        this.onItemPress();
                    };
                };
            };
        }

        protected function setMobileScrollingListData(_arg_1:Vector.<Object>):void
        {
            if (_arg_1 != null)
            {
                if (_arg_1.length > 0)
                {
                    this.scrollList.setData(_arg_1);
                }
                else
                {
                    this.scrollList.invalidateData();
                };
            }
            else
            {
                trace("setMobileScrollingListData::Error: No data received to display List Items!");
            };
        }


    }
}//package Shared.AS3

