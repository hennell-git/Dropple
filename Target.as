package
{
	import flash.display.*;
	import gs.*;
	
	public class Target extends Sprite
	{
		public var isProtected: Boolean = true;
		
		public var protectionImage: Shape;
		
		public var id: int;
		
		public var size: int;
		
		public function Target(id: int)
		{
			this.id = id;
			
			graphics.beginFill(Wsaf.colour(id));
			graphics.drawRect(0, 0, 640/4, 480);
			graphics.endFill();
			
			/*graphics.beginFill(0x000000);
			graphics.drawRect(0, -25, 1, 75);
			graphics.drawRect(640/4 - 1, -25, 1, 75);
			graphics.endFill();*/
			
			graphics.lineStyle(2, 0x000000);
			
			if (id != 0)
			{
				graphics.moveTo(0, -25);
				graphics.lineTo(0, 480);
			}
			
			if (id != 3)
			{
				graphics.moveTo(160, -25);
				graphics.lineTo(160, 480);
			}
			
			x = id * 640/4;
			y = 430;
			
			size = 2;
			
			protectionImage = new Shape();
			
			protectionImage.graphics.beginFill(Wsaf.darkColour(id));
			protectionImage.graphics.drawRect(1, 0, width - 2, 4);
			protectionImage.graphics.endFill();
			
			/*protectionImage.graphics.beginFill(0xFFFFFF);
			protectionImage.graphics.drawRect(0, 2, width, 2);
			protectionImage.graphics.endFill();*/
			
			addChild(protectionImage);
		}
		
		public function update (game: Wsaf): void
		{
			if (! isProtected && Math.random() < 0.5)
			{
				var r: Number = Math.random() * 5 + 2;
				var px: Number = Math.random() * (160 - r*2) + r + x;
				var py: Number = y + r;
				var vx: Number = Math.random() * 0.04 - 0.02;
				var vy: Number = -Math.random() * 0.1 - 0.1 + r * 0.01;
				
				var p: Particle = new Particle(px, py, vx, vy);
				
				p.graphics.beginFill(Wsaf.colour(id));
				p.graphics.drawCircle(0, 0, r);
				p.graphics.endFill();
				
				var t: Number = Math.random() * 0.5 + 0.9;
				var d: Number = Math.random() * 0.2 + 0.2;
				
				TweenLite.to(p, t, {alpha: 0, scaleX: 0, scaleY: 0, delay: d, onComplete: fadeoutComplete, onCompleteParams: [p]});
				
				game.addParticle(p);
			}
		}
		
		public function test (c: Circle, game: Wsaf): void
		{
			if (! c.active || c.mergeTarget) { return; }
			
			var score: Score = game.score;
			
			if (c.x > x && c.x < x + 160 && c.y + c.radius > y)
			{
				c.active = false;
				
				if (c == MouseControl.dragTarget)
				{
					MouseControl.dragTarget = null;
					MouseControl.highlight = null;
				}
				
				if (id == c.id)
				{
					score.plus(c, this);
					AudioControl.playGood();
					
					TweenLite.to(protectionImage, 0.5, {alpha: 1});
					
					if (isProtected)
					{
						size += 1;
						
						if (Settings.eventful) {
							TweenLite.to(this, 0.5, {y: 480 - size*25});
						}
					}
					
					isProtected = true;
				}
				else
				{
					if (isProtected)
					{
						score.minus(c, this);
						
						isProtected = false;
					
						TweenLite.to(protectionImage, 0.5, {alpha: 0});
						
						size = 2;
						
						if (Settings.eventful) {
							TweenLite.to(this, 0.5, {y: 430});
						}
					
						AudioControl.playWrong();
					}
					else
					{
						score.gameOver(c, this);
					
						AudioControl.playGameOver();
						
						TweenLite.to(game.circleLayer, 2.0, {alpha: 0.5, delay: 2.0});
						TweenLite.to(game.targetLayer, 2.0, {alpha: 0.5, delay: 2.0});
						
						MouseControl.dragTarget = null;
						MouseControl.highlight = null;
						
						return; // this stops the offending circle from fading out early
					}
					
					c.vy = -Math.min(0.25, Math.abs(c.vy));
					c.vx = 0;
					c.y = y - c.radius;
				}
				
				TweenLite.to(c, 0.5, {alpha: 0, onComplete: fadeoutComplete, onCompleteParams: [c]});
			}
		}
		
		private static function fadeoutComplete (c: *): void
		{
			c.dead = true;
		}
	}
}

