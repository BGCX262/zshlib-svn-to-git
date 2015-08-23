package pops
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import models.View3DObject;
	
	public class PoperSwf extends Sprite
	{
		private var currentSwf:MovieClip;
		private var _poper:PoperBase;
		
		private var _xmlData:XML;
		private var _v3dData:View3DObject;
		
		public function PoperSwf()
		{
			super();
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
			var configPath:String = _v3dData.config.slice(0,_v3dData.config.lastIndexOf("/"));
			loadSwf(ZSHTimelinePro.ROOT_PATH+configPath+"/"+_xmlData.resource[0].@src);
		}
		
		private function loadSwf(swfPath:String):void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadSwfError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSwfComplete);
			loader.load(new URLRequest(swfPath));
		}
		
		private function onLoadSwfError(e:IOErrorEvent):void{
			_poper.hide();
			ErrorAlert.show("展品swf加载失败");
		}
		
		private function onLoadSwfComplete(e:Event):void{
			currentSwf = e.target.content as MovieClip;
			(e.target as LoaderInfo).loader.unload();
			if(currentSwf){
				currentSwf.addEventListener("close",onCloseSwf);
				addChild(currentSwf);
				currentSwf.x = 0;
				currentSwf.y = 0;
				_poper.hideLoading();
				_poper.dispatchEvent(new Event(Event.RESIZE));
			}else{
				_poper.hide();
				ErrorAlert.show("内容不是swf");
			}
		}
		
		private function onCloseSwf(e:Event):void{
			if(currentSwf){
				if(currentSwf.parent){
					removeChild(currentSwf);
				}
				currentSwf.removeEventListener("close",onCloseSwf);
				currentSwf = null;
			}
			_poper.hide();
		}
		

	}
}