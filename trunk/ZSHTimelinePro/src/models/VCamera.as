package models
{
	public class VCamera extends Vertex3D
	{
		private var _tilt:Number = 0;
		private var _pan:Number = 90;
		private var _width:Number = 1024;
		private var _height:Number = 768;
		
		public function VCamera()
		{
			super();
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get pan():Number
		{
			return _pan;
		}

		public function set pan(value:Number):void
		{
			_pan = value;
		}

		public function get tilt():Number
		{
			return _tilt;
		}

		public function set tilt(value:Number):void
		{
			_tilt = value;
		}

	}
}