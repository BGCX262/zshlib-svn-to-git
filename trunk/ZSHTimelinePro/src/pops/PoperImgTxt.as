package pops
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	public class PoperImgTxt extends PoperBaseWindow
	{
		private var uiMC:ImgTxtPoper;
		private var loader:Loader;
		private var imgs:Vector.<Bitmap>;
		private var container:Sprite;
		private var loadArr:Array;
		private var _scrollContorler:ScrollViewControler;
		private var _url:String;
		
		public function PoperImgTxt()
		{
			super();
			uiMC = new ImgTxtPoper();
			bg.addChild(uiMC);
			bg.addChild(bg.closeBtn);
			bg.addChild(bg.btnMore);
			bg.addChild(bg.btn3d);
			uiMC.y = bg.closeBtn.y;
			uiMC.x = (bg.width - uiMC.width) / 2;
			(uiMC.txtMc.txt as TextField).wordWrap = true;
			(uiMC.txtMc.txt as TextField).multiline = true;
			uiMC.btPrev.addEventListener(MouseEvent.CLICK,onPreClick);
			uiMC.btNext.addEventListener(MouseEvent.CLICK,onNextClick);
			container = new Sprite();
			container.x = uiMC.imgContainer.x;
			container.y = uiMC.imgContainer.y;
			uiMC.addChild(container);
			_scrollContorler = new ScrollViewControler(uiMC.slider, uiMC.scroll_bg, uiMC.txtMc.txt, uiMC.txtMc.maskMC.height);
			
			bg.btn3d.addEventListener(MouseEvent.CLICK, onJumpClick);
			bg.btnMore.addEventListener(MouseEvent.CLICK, onJumpClick);
		}
		
		override public function set xmlData(value:XML):void{
			_xmlData = value;
			_poper.hideLoading();
			uiMC.firstTitle.text = _xmlData.@name;
			uiMC.secondTitle.text = _xmlData.@summary;
			uiMC.txtMc.txt.text = _xmlData.@description;
			(uiMC.txtMc.txt as TextField).height = (uiMC.txtMc.txt as TextField).textHeight+4;
			_scrollContorler.update();
			bg.bg.gotoAndStop(int(_v3dData.bg));
			uiMC.btPrev.mouseEnabled = false;
			uiMC.btNext.mouseEnabled = false;
			uiMC.ldMc.visible = true;
			bg.btn3d.visible = false;
			bg.btnMore.visible = false;
			
			var configPath:String = _v3dData.config.slice(0,_v3dData.config.lastIndexOf("/"));
			if(_xmlData.@type == "antique"){
				bg.btnMore.visible = true;
			}else if(_xmlData.@type == "scene"){
				bg.btn3d.visible = true;
			}
			if(_xmlData.resource != undefined){
				_url = ZSHTimelinePro.ROOT_PATH+configPath+"/"+_xmlData.resource[0].@src;
			}
			var photos:XMLList = _xmlData.photos.photo;
			uiMC.total_txt.text = photos.length().toString();
			uiMC.curr_txt.text = "1";
			imgs = new Vector.<Bitmap>();
			loadArr = [];
			for(var i:int=0; i<photos.length(); i++){
				loadArr.push(ZSHTimelinePro.ROOT_PATH+configPath+"/"+photos[i].@src);
			}
			if(loadArr.length > 0){
				loadImg();
			}else{
				uiMC.ldMc.visible = false;
			}
			bg.btn3d.mouseEnabled = true;
			bg.btnMore.mouseEnabled = true;
		}
		
		private function onJumpClick(e:MouseEvent):void{
			if(_url){
				navigateToURL(new URLRequest(_url));
			}else{
				ErrorAlert.show("没有找到跳转链接");
			}
		}
		
		private function loadImg():void{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadFault);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			loader.load(new URLRequest(loadArr[0]));
		}
		
		private function onLoadFault(e:IOErrorEvent):void{
			disposeLoader();
			loadArr.shift();
			var tf:TextField = new TextField();
			tf.text = "加载失败";
			var bd:BitmapData = new BitmapData(tf.width,tf.height);
			bd.draw(tf);
			var bmp:Bitmap = new Bitmap(bd);
			tf = null;
			imgs.push(bmp);
			if(loadArr.length > 0){
				loadImg();
			}else{
				allLoaded();
			}
		}
		
		private function onLoadComplete(e:Event):void{
			var bmp:Bitmap = e.target.content as Bitmap;
			bmp.smoothing = true;
			bmp.width = uiMC.imgContainer.width;
			bmp.height = uiMC.imgContainer.height;
			(e.target as LoaderInfo).loader.unload();
			disposeLoader();
			loadArr.shift();
			imgs.push(bmp);
			if(loadArr.length > 0){
				loadImg();
			}else{
				allLoaded();
			}
		}
		
		private function allLoaded():void{
			container.addChild(imgs[0]);
			uiMC.btPrev.mouseEnabled = true;
			uiMC.btNext.mouseEnabled = true;
			uiMC.ldMc.visible = false;
		}
		
		private function onPreClick(e:MouseEvent):void{
			var cur:int = int(uiMC.curr_txt.text);
			if(cur == 1){
				return;
			}else{
				cur--;
				uiMC.curr_txt.text = cur.toString();
				container.removeChildren();
				container.addChild(imgs[cur-1]);
			}
		}
		
		private function onNextClick(e:MouseEvent):void{
			var cur:int = int(uiMC.curr_txt.text);
			if(cur == imgs.length){
				return;
			}else{
				cur++;
				uiMC.curr_txt.text = cur.toString();
				container.removeChildren();
				container.addChild(imgs[cur-1]);
			}
		}
		
		private function disposeLoader():void{
			if(loader){
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadFault);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
				try
				{
					loader.close();
				}
				catch(error:Error){}
				loader = null;
			}
		}
		
		override protected function onCloseClick(e:MouseEvent):void{
			dispose();
			super.onCloseClick(e);
		}
		
		private function dispose():void{
			container.removeChildren();
			disposeLoader();
			if(imgs){
				for(var i:int=0; i<imgs.length; i++){
					if(imgs[i].bitmapData){
						imgs[i].bitmapData.dispose();
						imgs[i].bitmapData = null;
					}
					imgs[i] = null;
				}
				imgs = null;
			}
			if(loadArr){
				loadArr = null;
			}
		}
		
		
	}
}