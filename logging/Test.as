package
{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	
	// Ideas to try:
	// separate x and y
	// 1 bit to say whether we need a second byte
	// superdiff: bit packing to the rescue
	
	[SWF (width=640, height=480, frameRate=50)]
	public class Test extends Sprite
	{
		public var xarr: Array = new Array();
		public var yarr: Array = new Array();
		
		public var file: FileReference;
		
		public function Test ()
		{
			file = new FileReference();
			
			file.addEventListener(Event.SELECT, onFileSelected);
			
			file.browse();
		}
		
		private function onFileSelected (e: Event): void
		{
			file.addEventListener(Event.COMPLETE, onComplete);
			
			file.load();
		}
		
		private function onComplete (e: Event): void
		{
			extract(file.data);
			
			//compress1();
			//compress2();
			//compress3();
			//compress4();
			compress7();
		}
		
		private function extract (byteArray: ByteArray): void
		{
			var lines: Array = byteArray.toString().split("\n");
			
			for (var i: uint = 0; i < lines.length; i++)
			{
				var line: String = lines[i];
				
				var pair: Array = line.split(", ");
				
				if (pair.length != 2) { continue; }
				
				xarr.push(int(pair[0]));
				yarr.push(int(pair[1]));
			}
		}
		
		private function byteify (): ByteArray
		{
			var bytes: ByteArray = new ByteArray();
			
			bytes.length = xarr.length * 4;
			
			for (var i: uint = 0; i < xarr.length; i++)
			{
				bytes.writeShort(xarr[i]);
				bytes.writeShort(yarr[i]);
			}
			
			return bytes;
		}
		
		private function byteifyXOR (): ByteArray
		{
			var bytes: ByteArray = new ByteArray();
			
			bytes.length = xarr.length * 4;
			
			var x: int = 0;
			var y: int = 0;
			
			var xxor: int = 0;
			var yxor: int = 0;
			
			for (var i: uint = 0; i < xarr.length; i++)
			{
				xxor = xarr[i] ^ x;
				yxor = yarr[i] ^ y;
				
				x = xarr[i];
				y = yarr[i];
				
				bytes.writeShort(xxor);
				bytes.writeShort(yxor);
			}
			
			return bytes;
		}
		
		private function byteifyDiff (): ByteArray
		{
			var bytes: ByteArray = new ByteArray();
			
			bytes.length = xarr.length * 4;
			
			var x: int = 0;
			var y: int = 0;
			
			var dx: int = 0;
			var dy: int = 0;
			
			for (var i: uint = 0; i < xarr.length; i++)
			{
				dx = xarr[i] - x;
				dy = yarr[i] - y;
				
				x = xarr[i];
				y = yarr[i];
				
				bytes.writeShort(dx);
				bytes.writeShort(dy);
			}
			
			return bytes;
		}
		
		private function byteifySuperDiff (): ByteArray
		{
			var bytes: ByteArray = new ByteArray();
			
			bytes.length = xarr.length * 4;
			
			var x: int = 0;
			var y: int = 0;
			
			var dx: int = 0;
			var dy: int = 0;
			
			var bits: uint = 0;
			
			for (var i: uint = 0; i < xarr.length; i++)
			{
				dx = xarr[i] - x;
				dy = yarr[i] - y;
				
				x = xarr[i];
				y = yarr[i];
				
				//bytes.writeShort(dx);
				//bytes.writeShort(dy);
				
				bits += 4;
				bits += bitsRequired(dx, dy) * 2;
			}
			
			bytes.length = bits / 8;
			
			return bytes;
		}
		
		private function bitsRequired (dx: int, dy: int = 0): uint
		{
			if (dy != 0)
			{
				var bitsforx: uint = bitsRequired(dx);
				var bitsfory: uint = bitsRequired(dy);
				
				if (bitsforx > bitsfory)
				{
					return bitsforx;
				}
				else
				{
					return bitsfory;
				}
			}
			
			if (dx == 0)
			{
				return 0;
			}
			
			if (dx < 0) { dx *= -1; }
			
			dx -= 1;
			
			var max: uint = 1;
			
			for (var i:uint = 1; i < 16; i++)
			{
				if (dx < max)
				{
					return i;
				}
				
				max *= 2;
			}
			
			return 0;
		}
		
		private function compress1 (): void
		{
			save(byteify(), "mouse.raw");
		}
		
		private function compress2 (): void
		{
			save(byteifyDiff(), "mouse.diff.raw");
		}
		
		private function compress3 (): void
		{
			var bytes: ByteArray = byteify();
			
			bytes.compress();
			
			save(bytes, "mouse.zlib");
		}
		
		private function compress4 (): void
		{
			var bytes: ByteArray = byteifyDiff();
			
			bytes.compress();
			
			save(bytes, "mouse.diff.zlib");
		}
		
		private function compress5 (): void
		{
			var bytes: ByteArray = byteifySuperDiff();
			
			save(bytes, "mouse.superdiff");
		}
		
		private function compress6 (): void
		{
			var bytes: ByteArray = byteifySuperDiff();
			
			bytes.compress();
			
			save(bytes, "mouse.superdiff.zlib");
		}
		
		private function compress7 (): void
		{
			var bytes: ByteArray = byteifyXOR();
			
			save(bytes, "mouse.xor");
		}
		
		private function compress8 (): void
		{
			var bytes: ByteArray = byteifyXOR();
			
			bytes.compress();
			
			save(bytes, "mouse.xor.zlib");
		}
		
		private function save (bytes: ByteArray, name: String = ""): void
		{
			file = new FileReference();
			
			file.save(bytes, name);
		}
	}
}
