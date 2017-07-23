// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.COMPANIONAPP.BSScrollingListInterface

package Shared.AS3.COMPANIONAPP
{
    import Mobile.ScrollList.MobileScrollList;

    public class BSScrollingListInterface 
    {

        public static const STATS_SPECIAL_ENTRY_LINKAGE_ID:String = "SPECIALListEntry";
        public static const STATS_PERKS_ENTRY_LINKAGE_ID:String = "PerksListEntry";
        public static const INVENTORY_ENTRY_LINKAGE_ID:String = "InvListEntry";
        public static const INVENTORY_COMPONENT_ENTRY_LINKAGE_ID:String = "ComponentListEntry";
        public static const INVENTORY_COMPONENT_OWNERS_ENTRY_LINKAGE_ID:String = "ComponentOwnersListEntry";
        public static const DATA_STATS_CATEGORIES_ENTRY_LINKAGE_ID:String = "Stats_CategoriesListEntry";
        public static const DATA_STATS_VALUES_ENTRY_LINKAGE_ID:String = "Stats_ValuesListEntry";
        public static const DATA_WORKSHOPS_ENTRY_LINKAGE_ID:String = "WorkshopsListEntry";
        public static const QUEST_ENTRY_LINKAGE_ID:String = "QuestsListEntry";
        public static const QUEST_OBJECTIVES_ENTRY_LINKAGE_ID:String = "ObjectivesListEntry";
        public static const RADIO_ENTRY_LINKAGE_ID:String = "RadioListEntry";
        public static const PIPBOY_MESSAGE_ENTRY_LINKAGE_ID:String = "MessageBoxButtonEntry";
        public static const STATS_SPECIAL_RENDERER_LINKAGE_ID:String = "SPECIALItemRendererMc";
        public static const STATS_PERKS_RENDERER_LINKAGE_ID:String = "PerksItemRendererMc";
        public static const INVENTORY_RENDERER_LINKAGE_ID:String = "InventoryItemRendererMc";
        public static const INVENTORY_COMPONENT_OWNERS_RENDERER_LINKAGE_ID:String = "ComponentOwnersItemRendererMc";
        public static const DATA_STATS_CATEGORIES_RENDERER_LINKAGE_ID:String = "StatsCategoriesItemRendererMc";
        public static const DATA_STATS_VALUES_RENDERER_LINKAGE_ID:String = "StatsValuesItemRendererMc";
        public static const DATA_WORKSHOPS_RENDERER_LINKAGE_ID:String = "WorkshopsItemRendererMc";
        public static const QUEST_RENDERER_LINKAGE_ID:String = "QuestsItemRendererMc";
        public static const QUEST_OBJECTIVES_RENDERER_LINKAGE_ID:String = "QuestsObjectivesItemRendererMc";
        public static const RADIO_RENDERER_LINKAGE_ID:String = "RadioItemRendererMc";
        public static const PIPBOY_MESSAGE_RENDERER_LINKAGE_ID:String = "PipboyMessageItemRenderer";


        public static function GetMobileScrollListProperties(_arg_1:String):MobileScrollListProperties
        {
            var _local_2:MobileScrollListProperties = new MobileScrollListProperties();
            switch (_arg_1)
            {
                case STATS_SPECIAL_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = STATS_SPECIAL_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 450;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 0;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case STATS_PERKS_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = STATS_PERKS_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 0;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case INVENTORY_COMPONENT_ENTRY_LINKAGE_ID:
                case INVENTORY_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = INVENTORY_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 405;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 0;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case INVENTORY_COMPONENT_OWNERS_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = INVENTORY_COMPONENT_OWNERS_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 0;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case DATA_STATS_CATEGORIES_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = DATA_STATS_CATEGORIES_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 2.25;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case DATA_STATS_VALUES_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = DATA_STATS_VALUES_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 2.75;
                    _local_2.clickable = false;
                    _local_2.reversed = false;
                    break;
                case DATA_WORKSHOPS_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = DATA_WORKSHOPS_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 2.75;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case QUEST_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = QUEST_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 1.4;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case QUEST_OBJECTIVES_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = QUEST_OBJECTIVES_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 200;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 1.75;
                    _local_2.clickable = false;
                    _local_2.reversed = false;
                    break;
                case RADIO_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = RADIO_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 400;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 1.4;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                case PIPBOY_MESSAGE_ENTRY_LINKAGE_ID:
                    _local_2.linkageId = PIPBOY_MESSAGE_RENDERER_LINKAGE_ID;
                    _local_2.maskDimension = 150;
                    _local_2.scrollDirection = MobileScrollList.VERTICAL;
                    _local_2.spaceBetweenButtons = 4;
                    _local_2.clickable = true;
                    _local_2.reversed = false;
                    break;
                default:
                    trace((("Error: No mapping found between ListItemRenderer '" + _arg_1) + "' used InGame and mobile ListItemRenderer"));
            };
            return (_local_2);
        }


    }
}//package Shared.AS3.COMPANIONAPP

