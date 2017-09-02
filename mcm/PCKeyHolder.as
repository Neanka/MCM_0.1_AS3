package mcm
{
   import flash.display.MovieClip;
   
   public dynamic class PCKeyHolder extends MovieClip
   {
       
      
      public var PCKeyAnimInstance:MovieClip;
      
      public function PCKeyHolder()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame16() : *
      {
         gotoAndPlay("Flashing");
      }
   }
}
