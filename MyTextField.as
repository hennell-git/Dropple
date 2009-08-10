package
{
	import flash.display.*;
	import flash.text.*;
	
	public class MyTextField extends TextField
	{
		[Embed(source="pixelhugger.ttf", fontName='pixelhugger', mimeType='application/x-font')]
		public static var PixelHuggerFontSrc : Class;
		
		public static var pixelHuggerFont : Font = new PixelHuggerFontSrc();
		
		public function MyTextField (_x: Number, _y: Number, _text: String, _align: String = TextFieldAutoSize.CENTER, textSize: Number = 16)
		{
			x = _x;
			y = _y;
			
			textColor = 0x000000;
			
			selectable = false;
			mouseEnabled = false;
			
			var _textFormat : TextFormat = new TextFormat(pixelHuggerFont.fontName, textSize);
			
			_textFormat.align = _align;
			
			defaultTextFormat = _textFormat;
			
			embedFonts = true;
			
			autoSize = _align;
			
			text = _text;
			
			if (_align == TextFieldAutoSize.CENTER)
			{
				x = _x - textWidth / 2;
			}
			else if (_align == TextFieldAutoSize.RIGHT)
			{
				x = _x - textWidth;
			}
			
		}
		
	}
}

