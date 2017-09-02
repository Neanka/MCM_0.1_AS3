package mcm
{
   import Shared.AS3.BSButtonHelp;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class TextEntryAnim extends MovieClip
   {
       
      
      public var AcceptButton:BSButtonHelp;
      
      public var EntryTextField:TextField;
      
      public var TitleTextField:TextField;
      
      public var CancelButton:BSButtonHelp;
      
      public function TextEntryAnim()
      {
         super();
         this.setCancelButton();
         this.setAcceptButton();
      }
      
      function setCancelButton() : *
      {
         try
         {
            this.CancelButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.CancelButton.buttonText = "$CANCEL";
         this.CancelButton.Justification = 0;
         this.CancelButton.PCKey = "";
         this.CancelButton.PSNButton = "PSN_B";
         this.CancelButton.XenonButton = "Xenon_B";
         try
         {
            this.CancelButton["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function setAcceptButton() : *
      {
         try
         {
            this.AcceptButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AcceptButton.buttonText = "$CONFIRM";
         this.AcceptButton.Justification = 0;
         this.AcceptButton.PCKey = "";
         this.AcceptButton.PSNButton = "PSN_A";
         this.AcceptButton.XenonButton = "Xenon_A";
         try
         {
            this.AcceptButton["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
