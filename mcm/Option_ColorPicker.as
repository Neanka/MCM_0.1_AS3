package mcm
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.events.Event;
	
	public class Option_ColorPicker extends MovieClip 
	{
		public var ColorChooser: MovieClip;
		public var ColorSelectCursor: Sprite;
		public var HueChooser: MovieClip;
		public var HueSelectCursor: Sprite;
		public var SwatchColorHolder: MovieClip;
		public var SwatchColor: Sprite;
		public var HueColor: Sprite;
		public var CurrentColor: uint;
		public var DefaultColor: uint = 0;
		public var PreviousColor: Array; //if the user selects a color and closes the picker, the color's hue, saturation and value are stored here
		private var Hue: uint;
		private var Saturation: uint;
		private var Value: uint;
		private var colortransform: ColorTransform;
		private var ColorBounds: Rectangle;
		private var HueBounds: Rectangle;
		private var DoOnce: Boolean = false;
		private var bChangedColor: Boolean = false;
		private var DefaultArr: Array = new Array(3);
		private var BackgroundMask: Shape = new Shape();
			
		public function ColorPickerMenu(): *
		{
			this.ColorSelectCursor.visible = false;
			this.ColorChooser.visible = false;
			this.HueSelectCursor.visible = false;
			this.HueChooser.visible = false;
			this.SwatchColorHolder.addEventListener(MouseEvent.CLICK, this.onSwatchButtonClick);
		}
		
		public function open(): *
		{
			this.addChildAt((this.BackroundMask), 0);
			this.BackgroundMask.graphics.beginFill(0x000000, .5);
			this.BackgroundMask.graphics.drawRect(0, 0, (stage.width), (stage.height));
			this.SwatchColorHolder.removeEventListener(MouseEvent.CLICK, this.onSwatchButtonClick);
			this.ColorSelectCursor.visible = true;
			this.ColorChooser.visible = true;
			this.HueSelectCursor.visible = true;
			this.HueChooser.visible = true;
			this.HueColor = this.ColorChooser.HueColor;
			this.SwatchColor = this.SwatchColorHolder.SwatchColor;
			this.ColorBounds = new Rectangle((this.ColorChooser.x - (this.ColorChooser.width / 2) - (this.ColorSelectCursor.width / 2)), (this.ColorChooser.y - (this.ColorChooser.height / 2) - (this.ColorSelectCursor.height / 2)), (this.ColorChooser.width + (this.ColorSelectCursor.width / 2)), (this.ColorChooser.height + (this.ColorSelectCursor.height / 2))); 
			this.HueBounds = new Rectangle((this.HueChooser.x + (this.HueChooser.width / 2)), (this.HueChooser.y), (.001), (this.HueChooser.height));
			this.ColorChooser.addEventListener(MouseEvent.MOUSE_DOWN, this.onColorChooserMouseDown);
			this.HueChooser.addEventListener(MouseEvent.MOUSE_DOWN, this.onHueChooserMouseDown);
			this.SetColorsAndCursors();
		}
		
		public function close(): *
		{
			this.ColorSelectCursor.visible = false;
			this.ColorChooser.visible = false;
			this.HueSelectCursor.visible = false;
			this.HueChooser.visible = false;
			this.BackgroundMask.graphics.clear();
			if(bChangedColor == true)
			{
				this.PreviousColor[0] = this.Hue;
				this.PreviousColor[1] = this.Saturation;
				this.PreviousColor[2] = this.Value;
			}
			this.SwatchColorHolder.addEventListener(MouseEvent.CLICK, this.onSwatchButtonClick);
		}
		
		
		public function onSwatchButtonClick(e:MouseEvent): *
		{
			this.open();
		}
		
		public function SetColorsAndCursors(): * //only to be used at colorpicker startup
		{
			if(DoOnce == false) //haven't chosen a color
			{
				if(this.DefaultColor == 0) //haven't set a default color
				{
					this.Hue = 180;
					this.Saturation = 0;
					this.Value = 0;
					//huecolor
					this.CurrentColor = this.HSVToRGB((this.Hue), 100, 100);
					this.UpdateColorSprite(this.HueColor, this.CurrentColor);
					//colorswatch
					this.CurrentColor = 0x000000;
					this.HueSelectCursor.y = (((this.Hue / 360) * this.HueChooser.height) + this.HueChooser.y);
					this.ColorSelectCursor.x = (((this.Saturation / 100) * this.ColorChooser.width) + (this.ColorChooser.x - (this.ColorChooser.width / 2)));
					this.ColorSelectCursor.y = (((this.Value / 100) * this.ColorChooser.height) + (this.ColorChooser.y - (this.ColorChooser.height / 2)));
					this.UpdateColorSprite(this.SwatchColor, this.CurrentColor);
				}
				else //have set a default color
				{
					this.DefaultArr = this.RGBToHSV((this.DefaultColor));
					this.DefaultArr[0] = this.Hue;
					this.DefaultArr[1] = this.Saturation;
					this.DefaultArr[2] = this.Value;
					this.CurrentColor = this.DefaultColor;
					this.HueSelectCursor.y = (((this.Hue / 360) * this.HueChooser.height) + this.HueChooser.y);
					this.ColorSelectCursor.x = (((this.Saturation / 100) * this.ColorChooser.width) + (this.ColorChooser.x - (this.ColorChooser.width / 2)));
					this.ColorSelectCursor.y = (((this.Value / 100) * this.ColorChooser.height) + (this.ColorChooser.y - (this.ColorChooser.height / 2)));
				}
			}
			else //have chosen a color
			{
				this.PreviousColor[0] = this.Hue;
				this.PreviousColor[1] = this.Saturation;
				this.PreviousColor[2] = this.Value;
				this.CurrentColor = this.HSVToRGB((this.Hue), (this.Saturation), (this.Value));
				this.HueSelectCursor.y = (((this.Hue / 360) * this.HueChooser.height) + this.HueChooser.y);
				this.ColorSelectCursor.x = (((this.Saturation / 100) * this.ColorChooser.width) + (this.ColorChooser.x - (this.ColorChooser.width / 2)));
				this.ColorSelectCursor.y = (((this.Value / 100) * this.ColorChooser.height) + (this.ColorChooser.y - (this.ColorChooser.height / 2)));
			}
		}
		
		public function SetColor(HueCursorY:Number, ColorCursorX:Number, ColorCursorY:Number): *
		{
			this.Hue = (((HueCursorY - this.HueChooser.y) / this.HueChooser.height) * 360);
			this.Saturation = (((ColorCursorX - (this.ColorChooser.x - (this.ColorChooser.width / 2)))  / this.ColorChooser.width) * 100);
			this.Value = (((ColorCursorY - (this.ColorChooser.y - (this.ColorChooser.height / 2))) / this.ColorChooser.height) * 100);
			this.CurrentColor = this.HSVToRGB((this.Hue), (this.Saturation), (this.Value));
		}
		
		public function UpdateColorSprite(colorObj:DisplayObject, myColor: uint): *
		{
			this.colortransform = new ColorTransform();
			this.colortransform.color = myColor;
			colorObj.transform.colorTransform = this.colortransform;
			this.bChangedColor = true;
		}
		
		public function onColorChooserMouseDown(e:MouseEvent): *
		{
			this.ColorChooser.addEventListener(MouseEvent.MOUSE_MOVE, this.onColorChooserMouseMove);
			this.ColorSelectCursor.x = mouseX;
			this.ColorSelectCursor.y = mouseY;
			Mouse.hide();
			this.ColorSelectCursor.startDrag(true, (this.ColorBounds));
		}
		
		public function onColorChooserMouseMove(e:MouseEvent): *
		{
			this.ColorChooser.addEventListener(MouseEvent.MOUSE_UP, this.onColorChooserMouseUp);
			this.ColorSelectCursor.x = mouseX;
			this.ColorSelectCursor.y = mouseY;
			this.SetColor((this.ColorSelectCursor.x), (this.ColorSelectCursor.y), (this.HueSelectCursor.y));
			this.UpdateColorSprite((this.SwatchColor), (this.CurrentColor));
			e.updateAfterEvent();
		}
		
		public function onColorChooserMouseUp(e:MouseEvent): *
		{
			this.ColorChooser.removeEventListener(MouseEvent.MOUSE_MOVE, this.onColorChooserMouseMove);
			this.ColorSelectCursor.stopDrag();
			Mouse.show();
		}
		
		public function onHueChooserMouseDown(e:MouseEvent): *
		{
			this.HueChooser.addEventListener(MouseEvent.MOUSE_MOVE, this.onHueChooserMouseMove);
			this.HueSelectCursor.y = mouseY;
			Mouse.hide();
			this.HueSelectCursor.startDrag(true, (this.HueBounds));
		}
		
		public function onHueChooserMouseMove(e:MouseEvent): *
		{
			this.HueChooser.addEventListener(MouseEvent.MOUSE_UP, this.onHueChooserMouseUp);
			this.HueSelectCursor.y = mouseY;
			this.SetColor((this.HueSelectCursor.y), 100, 100);
			this.UpdateColorSprite((this.HueColor), (this.CurrentColor));
			e.updateAfterEvent();
		}
		
		public function onHueChooserMouseUp(e:MouseEvent): *
		{
			this.HueChooser.removeEventListener(MouseEvent.MOUSE_MOVE, this.onHueChooserMouseMove);
			this.HueSelectCursor.stopDrag();
			Mouse.show();
		}
		
		public function RGBToHSV(rgb: uint): Array
		{
			var red: Number = 0;
			var green: Number = 0;
			var blue: Number = 0;
			
			var Max: uint = Math.max(red, green, blue);
			var Min: uint = Math.min(red, green, blue);
			
			var hue: Number = 0;
			var saturation: Number = 0;
			var value: Number = 0;
			
			var hsv: Array = [];
			
			red = rgb >> 16;
			green = rgb >> 8 & 255;
			blue = rgb & 255;
			
			if (Max == Min)
			{
				hue = 0;
			}
			else if (Max == red)
			{
				hue = (60 * (green - blue) / (Max - Min) + 360) % 360;
			}
			else if (Max == green)
			{
				hue = (60 * (blue - red) / (Max - Min) + 120);
			}
			else if (Max == blue)
			{
				hue = (60 * (red - green) / (Max - Min) + 240);
			}
			
			value = Max;
			
			if (Max == 0)
			{
				saturation = 0;
			}
			else
			{
				saturation = (Max - Min) / Max;
			}
			
			hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
			return hsv;
		}
		
		public function HSVToRGB(hue: Number, saturation: Number, value: Number): uint
		{
			var red: Number = 0;
			var green: Number = 0;
			var blue: Number = 0;
			var hex: uint = 0;
			
			var nType: int = Math.floor(hue / 60) % 6;
			
			switch (nType)
			{
				case 0:
					red = (value / 100);
					green = ((value / 100) * (1 - (1 - ((hue / 60) - Math.floor(hue / 60))) * ( saturation / 100)));
					blue = ((value / 100) * (1 - (saturation / 100)));
					break;
				case 1:
					red = ((value / 100) * (1 - ((hue / 60) - Math.floor(hue / 60)) * ( saturation / 100)));
					green = (value / 100);
					blue = ((value / 100) * (1 - (saturation / 100)));
					break;
				case 2:
					red = ((value / 100) * (1 - (saturation / 100)));
					green = (value / 100);
					blue = ((value / 100) * (1 - (1 - ((hue / 60) - Math.floor(hue / 60))) * ( saturation / 100)));
					break;
				case 3:
					red = ((value / 100) * (1 - (saturation / 100)));
					green = ((value / 100) * (1 - ((hue / 60) - Math.floor(hue / 60)) * ( saturation / 100)));
					blue = (value / 100);
					break;
				case 4:
					red = ((value / 100) * (1 - (1 - ((hue / 60) - Math.floor(hue / 60))) * ( saturation / 100)));
					green = ((value / 100) * (1 - (saturation / 100)));
					blue = (value / 100);
					break;
				case 5:
					red = (value / 100);
					green = ((value / 100) * (1 - (saturation / 100)));
					blue = ((value / 100) * (1 - ((hue / 60) - Math.floor(hue / 60)) * ( saturation / 100)));
					break;
			}
			red = Math.round(red * 255);
			green = Math.round(green * 255);
			blue = Math.round(blue * 255);
			hex = (red << 16 | green << 8 | blue);
			return hex;
		}
	}
}