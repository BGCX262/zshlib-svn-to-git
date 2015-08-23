package pops
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.View3DObject;
	
	public class PoperBase extends Sprite
	{
		private var poperSwf:PoperSwf;
		private var poperImgtxt:PoperImgTxt;
		private var poperTxt:PoperTxt;
		private var poperVideo:PoperVideo;
		
		private var loading:MyLoading;
		private var _data:View3DObject;
		private var urlloader:URLLoader;
		
		public function PoperBase()
		{
			super();
			loading = new MyLoading();
			loading.x = loading.width / 2;
			loading.y = loading.height / 2;
			addChild(loading);
		}
		
		public function get data():View3DObject
		{
			return _data;
		}
		
		public function set data(value:View3DObject):void
		{
			this.removeChildren();
			_data = value;
			addChild(loading);
			loadConfigXML();
		}
		
		private function loadConfigXML():void{
			urlloader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,onLoadXMLFault);
			urlloader.addEventListener(Event.COMPLETE,onLoadXMLComplete);
			urlloader.load(new URLRequest(ZSHTimelinePro.ROOT_PATH+_data.config));
		}
		
		private function onLoadXMLFault(e:IOErrorEvent):void{
			disposeURLLoader();
			hide();
			ErrorAlert.show("展品XML文件加载失败");
		}
		
		private function onLoadXMLComplete(e:Event):void{
			disposeURLLoader();
			try
			{
				var xml:XML = new XML(e.target.data);
				xmlLoaded(xml);
			} 
			catch(error:Error) 
			{
				hide();
				ErrorAlert.show("展品XML解析失败");
			}
		}
		
		private function disposeURLLoader():void{
			if(urlloader){
				urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onLoadXMLFault);
				urlloader.removeEventListener(Event.COMPLETE,onLoadXMLComplete);
				try
				{
					urlloader.close();
				} 
				catch(error:Error){}
				urlloader = null;
			}
		}
		
		protected function xmlLoaded(xml:XML):void{
			var type:String = xml.@type;
			switch(type){
				case "swf":
					if(!poperSwf){
						poperSwf = new PoperSwf();
						poperSwf.poper = this;
					}
					poperSwf.v3dData = _data;
					poperSwf.xmlData = xml;
					addChild(poperSwf);
					break;
				case "scene":
				case "antique":
				case "imgtxt":
					if(!poperImgtxt){
						poperImgtxt = new PoperImgTxt();
						poperImgtxt.poper = this;
					}
					poperImgtxt.v3dData = _data;
					poperImgtxt.xmlData = xml;
					addChild(poperImgtxt);
					break;
				case "txt":
					if(!poperTxt){
						poperTxt = new PoperTxt();
						poperTxt.poper = this;
					}
					poperTxt.v3dData = _data;
					poperTxt.xmlData = xml;
					addChild(poperTxt);
					break;
				case "video":
					if(!poperVideo){
						poperVideo = new PoperVideo();
						poperVideo.poper = this;
					}
					poperVideo.v3dData = _data;
					poperVideo.xmlData = xml;
					addChild(poperVideo);
					break;
				default:
					hide();
					ErrorAlert.show("展品XML类型无法识别");
					break;
			}
		}
		
		public function show():void{
			Popuper.show(this);
		}
		
		public function hide():void{
			Popuper.hide();
		}
		
		public function hideLoading():void{
			if(loading.parent){
				this.removeChild(loading);
			}
		}
		
		
	}
}