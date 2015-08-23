package models
{
	public class Vertex3D
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		public function Vertex3D()
		{
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

	}
}