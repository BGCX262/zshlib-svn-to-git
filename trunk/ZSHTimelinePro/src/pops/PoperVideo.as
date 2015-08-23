package pops
{
	import flash.events.MouseEvent;
	
	public class PoperVideo extends PoperBaseWindow
	{
		private var uiMC:VideoPoper;
		private var videoControler:VideoControler;
		
		public function PoperVideo()
		{
			super();
			uiMC = new VideoPoper();
			bg.addChild(uiMC);
			bg.addChild(bg.closeBtn);
			bg.addChild(bg.btnMore);
			bg.addChild(bg.btn3d);
			uiMC.y = bg.closeBtn.y;
			uiMC.x = (bg.width - uiMC.width) / 2;
			videoControler = new VideoControler(uiMC.vf);
			
			bg.btn3d.visible = false;
			bg.btnMore.visible = false;
		}
		
		override public function set xmlData(value:XML):void{
			_xmlData = value;
			_poper.hideLoading();
			bg.bg.gotoAndStop(int(_v3dData.bg));
			uiMC.firstTitle.text = _xmlData.@name;
			uiMC.secondTitle.text = _xmlData.@summary;
			var configPath:String = _v3dData.config.slice(0,_v3dData.config.lastIndexOf("/"));
			videoControler.url = ZSHTimelinePro.ROOT_PATH+configPath+"/"+_xmlData.resource[0].@src;
		}
		
		override protected function onCloseClick(e:MouseEvent):void{
			videoControler.dispose();
			super.onCloseClick(e);
		}
		
		
	}
}