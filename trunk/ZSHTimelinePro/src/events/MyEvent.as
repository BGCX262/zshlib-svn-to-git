package events
{
	import flash.events.Event;
	
	public class MyEvent extends Event
	{
		public static const WALK_BG_LOADED:String = "walkBgLoaded";
		public static const WALK_GO_END:String = "walkGoEnd";
		public static const WALK_GO_START:String = "walkGoStart";
		public static const WALK_SELECT:String = "walkSelect";
		
		private var _data:Object;
		
		public function MyEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data():Object
		{
			return _data;
		}

	}
}