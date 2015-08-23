package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.ExhibitionRoom;
	
	import rd.flash.Application;
	import rd.flash.components.FComboBox;
	import rd.flash.components.FLoadingAlert;
	
	[SWF(width="1280",height="800",frameRate="30",backgroundColor="0x000000")]
	public class ZSHExhibition extends Application
	{
		private static const CONFIG_FILE_PATH:String = "config.xml";
		
		private var configArr:Array;
		private var cbxGroup:FComboBox;
		private var currentIndexSWF:IExhibition; //当前显示的展厅主页
		
		public function ZSHExhibition()
		{
			this.background = false;
		}
		
		override protected function startApp():void{
			ErrorAlert.setStage(stage);
			FLoadingAlert.getInstance().show("载入数据");
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadFault);
			urlloader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urlloader.load(new URLRequest(CONFIG_FILE_PATH));
		}
		
		private function onXMLLoadFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("配置数据加载失败！");
		}
		
		private function onXMLLoaded(e:Event):void{
			FLoadingAlert.getInstance().hide();
			try
			{
				var xml:XML = new XML(e.target.data);
				configArr = [];
				var xl:XMLList = xml.cell;
				for(var i:int=0; i<xl.length(); i++){
					var em:ExhibitionRoom = new ExhibitionRoom();
					em.config = xl[i].@config;
					em.index = xl[i].@index;
					em.name = xl[i].@name;
					em.type = xl[i].@type;
					configArr.push(em);
				}
				if(configArr.length > 0){
					afterLoadConfig();
				}else{
					ErrorAlert.show("配置数据中没有定义任何子展厅！");
				}
			} 
			catch(error:Error) 
			{
				ErrorAlert.show("配置数据解析失败！");
				return;
			}
			trace(xml.toXMLString());
		}
		
		private function afterLoadConfig():void{
			cbxGroup = new FComboBox();
			cbxGroup.fontSize = 14;
//			cbxGroup.bgColorNormal = 0x333333;
//			cbxGroup.bgColorDown = 0x000000;
//			cbxGroup.bgColorOver = 0x5f3c1f;
			cbxGroup.labelField = "name";
			cbxGroup.data = configArr;
			cbxGroup.selectedIndex = 0;
			cbxGroup.x = 10;
			cbxGroup.y = 10;
			addChild(cbxGroup);
			cbxGroup.addEventListener(Event.CHANGE, onCbxChange);
			loadExhibitionRoomIndex();
		}
		
		private function onCbxChange(e:Event):void{
			loadExhibitionRoomIndex();
		}
		
		private function loadExhibitionRoomIndex():void{
			FLoadingAlert.getInstance().show("加载展厅");
			disposeCurrentSwf();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSwfLoadFault);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoadComplete);
			var curEm:ExhibitionRoom = cbxGroup.selectedData as ExhibitionRoom;
			loader.load(new URLRequest(curEm.index));
		}
		
		private function onSwfLoadFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("展厅主页加载失败！");
		}
		
		private function onSwfLoadComplete(e:Event):void{
			FLoadingAlert.getInstance().hide();
			currentIndexSWF = e.target.content as IExhibition;
			if(currentIndexSWF){
				currentIndexSWF.rootPath = (cbxGroup.selectedData as ExhibitionRoom).rootPath;
				this.addChildAt(currentIndexSWF as DisplayObject, 0);
			}else{
				ErrorAlert.show("展厅主页类型有误！");
			}
		}
		
		private function disposeCurrentSwf():void{
			if(currentIndexSWF){
				if((currentIndexSWF as DisplayObject).parent){
					(currentIndexSWF as DisplayObject).parent.removeChild(currentIndexSWF as DisplayObject);
				}
				currentIndexSWF = null;
			}
		}
		
		
	}
}