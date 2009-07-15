package
{
	import flash.display.*;
	import flash.text.*;
	import gs.*;
	
	public class Score extends Sprite
	{
		private var scoreText: NumberTextField;
		private var highScoreText: NumberTextField;
		private var comboText: NumberTextField;
		private var bestComboText: NumberTextField;
		private var livesText: NumberTextField;
		
		public function Score()
		{
			scoreText = new NumberTextField(640/2, 15, "", TextFieldAutoSize.CENTER, 40);
			
			var textX : Number = 640 - 15;
			var textY : Number = 10;
			
			/*livesText = new NumberTextField(textX, textY, "Lives: ", TextFieldAutoSize.RIGHT);
			textY += 20;*/
			
			comboText = new NumberTextField(textX, textY, "Combo: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			bestComboText = new NumberTextField(textX, textY, "Best Combo: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			highScoreText = new NumberTextField(textX, textY, "High score: ", TextFieldAutoSize.RIGHT);
			textY += 20;
			
			//livesText.value = 5;
			
			addChild(scoreText);
			//addChild(livesText);
			addChild(highScoreText);
			addChild(comboText);
			addChild(bestComboText);
		}
		
		public function plus (c : Circle): void
		{
			var scoreAdd : int = 10 * (combo + 1);
			
			if (! c.touched)
			{
				scoreAdd *= 10;
			}
			
			score += scoreAdd;
			combo += 1;
			
			c.y = 450; // hackish
			
			var text : MyTextField = new MyTextField(c.x, c.y, "+" + scoreAdd, TextFieldAutoSize.CENTER);
			
			if (! c.touched)
			{
				text.text += "\nNo hands!";
				c.y -= 16;
			}
			
			addChild(text);
			
			TweenLite.to(text, 1.0, {y: (c.y - 65)});
			
			TweenLite.to(text, 0.5, {
				alpha: 0,
				delay: 0.6,
				overwrite: 0,
				onComplete: removeChild,
				onCompleteParams: [text]
			});
		}
		
		public function minus (c : Circle): void
		{
			score -= 100;
			combo = 0;
			
			c.y = 450; // hackish
			
			var text : MyTextField = new MyTextField(c.x, c.y, "-100", TextFieldAutoSize.CENTER);
			
			addChild(text);
			
			TweenLite.to(text, 1.0, {y: (c.y - 65)});
			
			TweenLite.to(text, 0.5, {
				alpha: 0,
				delay: 0.6,
				overwrite: 0,
				onComplete: removeChild,
				onCompleteParams: [text]
			});
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

