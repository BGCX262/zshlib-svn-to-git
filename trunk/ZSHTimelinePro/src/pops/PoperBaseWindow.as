package pops
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import models.View3DObject;
	
	public class PoperBaseWindow extends Sprite
	{
		protected var bg:BaseWindwBG;
		protected var _xmlData:XML;
		protected var _v3dData:View3DObject;
		protected var _poper:PoperBase;
		
		public function PoperBaseWindow()
		{
			super();
			bg = new BaseWindwBG();
			addChild(bg);
			bg.closeBtn.addEventListener(MouseEvent.CLICK, onCloseClick);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void{
			_poper.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get v3dData():View3DObject
		{
			return _v3dData;
		}

		public function set v3dData(value:View3DObject):void
		{
			_v3dData = value;
		}

		public function set poper(value:PoperBase):void
		{
			_poper = value;
		}

		public function get xmlData():XML
		{
			return _xmlData;
		}

		public function set xmlData(value:XML):void
		{
			_xmlData = value;
		}
		
		protected function onCloseClick(e:MouseEvent):void{
			_poper.hide();
		}
		
		
	}
}