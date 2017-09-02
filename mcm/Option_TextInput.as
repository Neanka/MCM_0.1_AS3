package mcm
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Option_TextInput extends MovieClip
   {
      
      public var TextEntryAnim:MovieClip;
      
      public var TextEntryBackground:MovieClip;
      
      private var bUseBackground:Boolean = true;
      
      public function TextEntry()
      {
         super();
         addFrameScript(11,this.frame12,23,this.frame24);
         gotoAndStop("FadedOut");
      }
      
      public function set useBackground(param1:Boolean) : *
      {
         var _loc2_:MovieClip = this["TextEntryAnim"] as MovieClip;
         if(param1)
         {
            this.TextEntryBackground.visible = true;
         }
         else
         {
            this.TextEntryBackground.visible = false;
         }
         this.bUseBackground = param1;
      }
      
      public function GetEnteringText() : Boolean
      {
         return stage.focus == (this["TextEntryAnim"] as MovieClip).EntryTextField;
      }
      
      public function GetText() : String
      {
         return (this["TextEntryAnim"] as MovieClip).EntryTextField.text;
      }
      
      public function FadeIn() : *
      {
         gotoAndPlay("FadeIn");
         var _loc1_:TextField = (this["TextEntryAnim"] as MovieClip).EntryTextField;
         _loc1_.selectable = true;
         _loc1_.maxChars = 26;
         GlobalFunc.SetText(_loc1_,"",false);
         stage.focus = _loc1_;
      }
      
      public function FadeOut() : *
      {
         gotoAndPlay("FadeOut");
      }
      
      public function SetPlatform(param1:uint, param2:Boolean) : *
      {
         var _loc3_:MovieClip = this["TextEntryAnim"] as MovieClip;
         _loc3_.AcceptButton.SetPlatform(param1,param2);
         _loc3_.CancelButton.SetPlatform(param1,param2);
      }
      
      public function SetTitleText(param1:String) : *
      {
         var _loc2_:MovieClip = this["TextEntryAnim"] as MovieClip;
         GlobalFunc.SetText(_loc2_.TitleTextField,param1,true);
      }
      
      function frame12() : *
      {
         stop();
      }
      
      function frame24() : *
      {
         stop();
      }
   }
}
