
package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import gs.*;

	public class MainMenu extends Sprite
	{
		[Embed(source="images/title.png")]
		public static var titleSrc: Class;
		
		public var eyes: Array = new Array();
		
		public function MainMenu ()
		{
			/*var title: DisplayObject = new titleSrc();
			
			title.x = 320 - title.width / 2;
			title.y = 30;
			
			addChild(title);
			
			eyes.push(new Eye(155, 38));
			eyes.push(new Eye(170, 40));
			
			eyes.push(new Eye(217, 55));
			eyes.push(new Eye(237, 54));
			
			eyes.push(new Eye(263, 55));
			eyes.push(new Eye(286, 55));
			
			eyes.push(new Eye(322, 55));
			eyes.push(new Eye(350, 55));
			
			eyes.push(new Eye(385, 55));
			eyes.push(new Eye(413, 55));
			
			eyes.push(new Eye(445, 35));
			eyes.push(new Eye(458, 35));
			
			eyes.push(new Eye(480, 55));
			eyes.push(new Eye(506, 55));
			
			for each (var eye: Eye in eyes)
			{
				addChild(eye);
			}*/
			
			var title: MyTextField = new MyTextField(320, 130, "DROPPLE", "center", 72, Button.maianFont.fontName);
			
			addChild(title);
			
			var menu: DisplayObject = this;
			
			var button: Button;
			
			button = new Button("Play Uneventful Mode", 32, 300, 0xFF0000);
			button.x = 320 - button.width / 2;
			button.y = 250;
			
			button.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Settings.absorb = false;
				Settings.eventful = false;
				Main.screen = new Wsaf();
			});
			
			addChild(button);
			
			button = new Button("Play Eventful Mode", 32, 300, 0x0080FF);
			button.x = 320 - button.width / 2;
			button.y = 330;
			
			button.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Settings.absorb = false;
				Settings.eventful = true;
				Main.screen = new Wsaf();
			});
			
			addChild(button);
			
			/*button = new Button("Absorbathon Mode", 32, 300, 0x0080FF);
			button.x = 320 - button.width / 2;
			button.y = 270;
			
			button.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Settings.absorb = true;
				Main.screen = new Wsaf();
			});
			
			addChild(button);
			
			button = new Button("Classic Mode", 32, 300, 0x00FF00);
			button.x = 320 - button.width / 2;
			button.y = 350;
			
			button.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Settings.absorb = false;
				Main.screen = new Wsaf();
			});
			
			addChild(button);
			
			addChild(new MyTextField(320, 330, "(Absorbathon mode still in early development)", "center", 16, 'Maian'));*/
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame (e: Event): void
		{
			for each (var eye: Eye in eyes)
			{
				eye.draw();
			}
		}
		
	}

}


