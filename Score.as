package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import gs.*;
	
	public class Score extends Sprite
	{
		private var scoreText: NumberTextField;
		private var highScoreText: NumberTextField;
		private var comboText: NumberTextField;
		private var bestComboText: NumberTextField;
		private var livesText: NumberTextField;
		
		public var debug: NumberTextField;
		
		public var isGameOver: Boolean = false;
		
		public var messagesLayer: Sprite = new Sprite();
		public var gameOverLayer: Sprite = new Sprite();
		
		private var game: Wsaf;
		
		public function Score(_game: Wsaf)
		{
			game = _game;
			
			scoreText = new NumberTextField(640/2, 15, "", TextFieldAutoSize.CENTER, 40);
			
			var textX : Number = 640 - 15;
			var textY : Number = 10;
			
			/*livesText = new NumberTextField(textX, textY, "Lives: ", TextFieldAutoSize.RIGHT);
			textY += 20;*/
			
			comboText = new NumberTextField(textX, textY, "Combo: ", TextFieldAutoSize.RIGHT);
			//textY += 20;
			
			bestComboText = new NumberTextField(textX, textY, "Best Combo: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			highScoreText = new NumberTextField(textX, textY, "High score: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			debug = new NumberTextField(textX, textY, "Debug: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			//livesText.value = 5;
			
			addChild(scoreText);
			//addChild(livesText);
			addChild(highScoreText);
			//addChild(comboText);
			addChild(bestComboText);
			addChild(debug);
		}
		
		public function plus (c : Circle, t: Target): void
		{
			var scoreAdd : int = 10 * (combo + 1);
			
			if (! c.touched)
			{
				scoreAdd *= 10;
			}
			
			score += scoreAdd;
			combo += 1;
			
			var text : String = "+" + scoreAdd;
			
			if (! c.touched)
			{
				text += "\nNo hands!";
			}
			
			spawnText(text, c, t);
		}
		
		public function minus (c : Circle, t: Target): void
		{
			combo = 0;
		}
		
		public function gameOver (c: Circle, t: Target): void
		{
			isGameOver = true;
			
			var retryButton: Button = new Button("Again!", 32, 200, 0x0080FF);
			
			retryButton.x = 320 - retryButton.width / 2;
			retryButton.y = 245 - retryButton.height / 2;
			retryButton.alpha = 0;
			
			retryButton.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Main.screen = new Wsaf();
			});
			
			var menuButton: Button = new Button("Menu", 32, 200, 0x00FF00);
			
			menuButton.x = 320 - menuButton.width / 2;
			menuButton.y = 330 - menuButton.height / 2;
			menuButton.alpha = 0;
			
			menuButton.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				Main.screen = new MainMenu();
			});
			
			gameOverLayer.addChild(this);
			gameOverLayer.addChild(retryButton);
			gameOverLayer.addChild(menuButton);
			
			TweenLite.to(retryButton, 1.0, {alpha: 1, delay: 1.0});
			TweenLite.to(menuButton, 1.0, {alpha: 1, delay: 1.0});
			
			spawnText("Game Over", c, t);
		}
		
		public function spawnText (s: String, circle: Circle, target: Target): void
		{
			var spawnX: Number = circle.x;
			var spawnY: Number = target.y;
			
			var font: String = null;
			
			if (s == "Game Over")
			{
				font = "Maian";
			}
			
			var text : MyTextField = new MyTextField(spawnX, spawnY, s, TextFieldAutoSize.CENTER, 16, font);
			
			var noOfLines: int = s.split("\n").length;
			
			spawnY -= 16 * (noOfLines - 1);
			
			messagesLayer.addChild(text);
			
			if (s == "Game Over")
			{
				TweenLite.to(text, 1.0, {
					y: (spawnY - 65),
					onComplete: gameOverLayer.addChild,
					onCompleteParams: [text]
				});
				
				TweenLite.to(text, 1.0, {
					x: 320 - text.width * 5 / 2,
					y: 140 - text.height * 5 / 2,
					scaleX: 5,
					scaleY: 5,
					delay: 1.0,
					overwrite: 0
				});
			}
			else
			{
				TweenLite.to(text, 1.0, {y: (spawnY - 65)});
				
				TweenLite.to(text, 0.5, {
					alpha: 0,
					delay: 0.6,
					overwrite: 0,
					onComplete: messagesLayer.removeChild,
					onCompleteParams: [text]
				});
			}
		}
		
		public function set score(_score:int):void
		{
			scoreText.value = _score;
			
			if (highScoreText.value < _score)
			{
				highScoreText.value = _score;
				highScoreText.textColor = 0xFF0000;
			}
			else
			{
				highScoreText.textColor = 0x000000;
			}
		}
		
		public function get score():int
		{
			return scoreText.value;
		}
		
		public function set combo(_combo: int): void
		{
			comboText.value = _combo;
			
			if (bestComboText.value < _combo)
			{
				bestComboText.value = _combo;
				bestComboText.textColor = 0xFF0000;
			}
			else
			{
				bestComboText.textColor = 0x000000;
			}
		}
		
		public function get combo():int
		{
			return comboText.value;
		}
		
	}
}

