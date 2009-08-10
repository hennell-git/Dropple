package
{
	import flash.display.*;
	import gs.*;
	
	public class Target extends Sprite
	{
		public var isProtected: Boolean = true;
		
		public var protectionImage: Shape;
		
		public var id: int;
		
		public function Target(id: int)
		{
			this.id = id;
			
			graphics.beginFill(Wsaf.colour(id));
			graphics.drawRect(0, 0, 640/4, 50);
			graphics.endFill();
			
			/*graphics.beginFill(0x000000);
			graphics.drawRect(0, -25, 1, 75);
			graphics.drawRect(640/4 - 1, -25, 1, 75);
			graphics.endFill();*/
			
			graphics.lineStyle(2, 0x000000);
			
			if (id != 0)
			{
				graphics.moveTo(0, -25);
				graphics.lineTo(0, 50);
			}
			
			if (id != 3)
			{
				graphics.moveTo(160, -25);
				graphics.lineTo(160, 50);
			}
			
			x = id * 640/4;
			y = 430;
			
			protectionImage = new Shape();
			
			protectionImage.graphics.beginFill(Wsaf.darkColour(id));
			protectionImage.graphics.drawRect(1, 0, width - 2, 4);
			protectionImage.graphics.endFill();
			
			/*protectionImage.graphics.beginFill(0xFFFFFF);
			protectionImage.graphics.drawRect(0, 2, width, 2);
			protectionImage.graphics.endFill();*/
			
			addChild(protectionImage);
		}
		
		public function test (c: Circle, game: Wsaf): void
		{
			if (! c.active || c.mergeTarget) { return; }
			
			var score: Score = game.score;
			
			if (c.x > x && c.x < x + 160 && c.y + c.radius > 430)
			{
				if (id == c.id)
				{
					score.plus(c);
					AudioControl.playGood();
					
					TweenLite.to(protectionImage, 0.5, {alpha: 1});
					
					isProtected = true;
				}
				else
				{
					if (isProtected)
					{
						score.minus(c);
						
						isProtected = false;
					
						TweenLite.to(protectionImage, 0.5, {alpha: 0});
					
						AudioControl.playWrong();
					}
					else
					{
						score.gameOver(c);
					
						AudioControl.playGameOver();
						
						TweenLite.to(game.peopleLayer, 2.0, {alpha: 0, delay: 2.0});
					}
					
					c.vy = -Math.min(0.25, Math.abs(c.vy));
					c.vx = 0;
					c.y = 430 - c.radius;
				}
				
				c.active = false;
				
				TweenLite.to(c, 0.5, {alpha: 0, onComplete: mergeComplete, onCompleteParams: [c]});
				
				MouseControl.dragTarget = null;
				MouseControl.highlight = null;
			}
		}
		
		private static function mergeComplete (c: Circle): void
		{
			c.dead = true;
		}
	}
}

