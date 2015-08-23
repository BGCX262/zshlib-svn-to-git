package models
{
	public class ExhibitionRoom
	{
		private var _type:String;
		private var _name:String;
		private var _config:String;
		private var _index:String;
		private var _rootPath:String;
		
		public function ExhibitionRoom()
		{
		}

		public function get rootPath():String
		{
			return _rootPath;
		}

		public function get index():String
		{
			return _index;
		}

		public function set index(value:String):void
		{
			_index = value;
			_rootPath = _index.slice(0,_index.lastIndexOf("/"))+"/";
		}

		public function get config():String
		{
			return _config;
		}

		public function set config(value:String):void
		{
			_config = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}