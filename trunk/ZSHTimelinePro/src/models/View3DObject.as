package models
{
	
	import flash.display.DisplayObject;
	
	public class View3DObject extends Vertex3D
	{
		private var _isLeft:Boolean;
		private var _name:String;
		private var _thumbnail:String;
		private var _type:String;
		private var _ui:*;
		private var _config:String;
		
		private var _bg:String;
		private var _mode:int;
		private var _isReal:Boolean;
		
		public function get isReal():Boolean
		{
			return _isReal;
		}
		
		public function set isReal(value:Boolean):void
		{
			_isReal = value;
		}
		
		public function get mode():int
		{
			return _mode;
		}
		
		public function set mode(value:int):void
		{
			_mode = value;
		}
		
		public function get bg():String
		{
			return _bg;
		}
		
		public function set bg(value:String):void
		{
			_bg = value;
		}
		
		public function get isLeft():Boolean
		{
			return _isLeft;
		}
		
		public function set isLeft(value:Boolean):void
		{
			_isLeft = value;
		}
		
		public function get config():String
		{
			return _config;
		}
		
		public function set config(value:String):void
		{
			_config = value;
		}
		
		public function get ui():*
		{
			return _ui;
		}
		
		public function set ui(value:*):void
		{
			_ui = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get thumbnail():String
		{
			return _thumbnail;
		}
		
		public function set thumbnail(value:String):void
		{
			_thumbnail = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
	}
}