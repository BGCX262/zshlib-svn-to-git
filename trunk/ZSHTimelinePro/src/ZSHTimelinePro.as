package
{
	import events.MyEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.View3DObject;
	
	import pops.PoperBase;
	
	import rd.flash.Application;
	import rd.flash.components.FComboBox;
	import rd.flash.components.FLoadingAlert;
	import rd.flash.display.FStyle;
	
	import view.NWalk;
	
	[SWF(width="1280",height="800",frameRate="30",backgroundColor="0x000000")]
	public class ZSHTimelinePro extends Application implements IExhibition
	{
		private static const MAIN_NAME:String = "自建时间轴展厅";
		private static const CONFIG_FILE_NAME:String = "exhibitionConfig.xml";
		public static var ROOT_PATH:String = ""; //此项目主页在外层项目的目录
		
		private var btns:UIButtons;
		public var _nwalk:NWalk;
		private var poper:PoperBase;
		private var cbxGroup:FComboBox;
		
		private var configXML:XML;
		private var cbxData:Array;
		private var currentGroupIndex:int = 0;
		
		override protected function startApp():void{
			this.stage.frameRate = 25;
			this.stage.stageFocusRect = false;
			this.background = false;
			ErrorAlert.setStage(stage);
			Popuper.setStage(stage);
			
			FLoadingAlert.getInstance().show("读取数据");
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onLoadConfigFault);
			urlloader.addEventListener(Event.COMPLETE, onConfigXMLLoaded);
			urlloader.load(new URLRequest(ROOT_PATH+CONFIG_FILE_NAME));
		}
		
		/**
		 * 如果这个项目发布的swf被放到别的项目中，别的项目需要设置此项目主页的根目录
		 * @param path 此项目主页在外层项目的目录
		 * 
		 */		
		public function set rootPath(path:String):void{
			ROOT_PATH = path;
		}
		
		private function onLoadConfigFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("找不到"+MAIN_NAME+"配置文件\n这个文件必须放在"+ROOT_PATH+"目录下，并命名为"+CONFIG_FILE_NAME);
		}
		
		private function onConfigXMLLoaded(e:Event):void{
			FLoadingAlert.getInstance().hide();
			try
			{
				configXML = new XML(e.target.data);
				cbxData = [];
				for(var i:int=0; i<configXML.group.length(); i++){
					var obj:Object = {};
					obj.type = configXML.group[i].@type;
					obj.name = configXML.group[i].@name;
					obj.title = configXML.group[i].@title;
					cbxData.push(obj);
				}
				if(cbxData.length > 0){
					initTimelineUI();
				}else{
					ErrorAlert.show(MAIN_NAME+"配置数据中没有任何子展厅数据！");
				}
			} 
			catch(error:Error) 
			{
				ErrorAlert.show(MAIN_NAME+"配置文件解析失败，xml格式可能有误！");
			}
		}
		
		private function initTimelineUI():void{
			_nwalk = new NWalk();
			_nwalk.addEventListener(MyEvent.WALK_BG_LOADED, onWalkBgLoaded);
			_nwalk.addEventListener(MyEvent.WALK_GO_END, onWalkGoEnd);
			_nwalk.addEventListener(MyEvent.WALK_SELECT, onWalkSelect);
			addChild(_nwalk);
			
			btns = new UIButtons();
			btns.go_btn.addEventListener(MouseEvent.MOUSE_DOWN,mousedownH);
			btns.back_btn.addEventListener(MouseEvent.MOUSE_DOWN,mousedownH);
			btns.go_btn.addEventListener(MouseEvent.MOUSE_UP,mouseupH);
			btns.back_btn.addEventListener(MouseEvent.MOUSE_UP,mouseupH);
			btns.x = stage.stageWidth / 2;
			btns.y = stage.stageHeight - btns.height / 2;
			addChild(btns);
			
			poper = new PoperBase();
			cbxGroup = new FComboBox();
			cbxGroup.fontSize = 14;
			cbxGroup.bgColorNormal = 0x333333;
			cbxGroup.bgColorDown = 0x000000;
			cbxGroup.bgColorOver = 0x5f3c1f;
			cbxGroup.labelField = "name";
			cbxGroup.data = cbxData;
			cbxGroup.selectedIndex = currentGroupIndex;
			cbxGroup.x = stage.stageWidth - cbxGroup.width - 10;
			cbxGroup.y = 10;
			addChild(cbxGroup);
			cbxGroup.addEventListener(Event.CHANGE, onCbxChange);
			cbxGroup.mouseEnabled = false;
			showTimeline();
		}
		
		private function onCbxChange(e:Event):void{
			currentGroupIndex = cbxGroup.selectedIndex;
			cbxGroup.mouseEnabled = false;
			showTimeline();
		}
		
		private function showTimeline():void{
			var bgPath:String = ROOT_PATH+configXML.group[currentGroupIndex].@ui;
			_nwalk.loadBG(bgPath);
			stage.focus = _nwalk;
		}
		
		private function onWalkBgLoaded(e:MyEvent):void{
			var cellXML:XML = configXML.group[currentGroupIndex];
			_nwalk.setXMLCells(cellXML);
			cbxGroup.mouseEnabled = true;
		}
		
		private function onWalkGoEnd(e:MyEvent):void{
			_nwalk.stop();
			onWalkBgLoaded(null);
		}
		
		private function onWalkSelect(e:MyEvent):void{
			poper.data = e.data as View3DObject;
			poper.show();
		}
		
		protected function mousedownH(event:MouseEvent):void
		{
			var nam:String=event.currentTarget.name;
			var k:KeyboardEvent;
			switch(nam){
				case "go_btn":
					k = new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,38);
					this.stage.dispatchEvent(k);
					break;
				case "back_btn":
					k=new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,40);
					this.stage.dispatchEvent(k);
					break;
			}
		}
		
		protected function mouseupH(event:MouseEvent):void
		{
			var nam:String=event.currentTarget.name;
			var k:KeyboardEvent;
			switch(nam){
				case "go_btn":
					k=new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,38);
					this.stage.dispatchEvent(k);
					break;
				case "back_btn":
					k=new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,0,40);
					this.stage.dispatchEvent(k);
					break;
			}
		}
		
		
	}
}