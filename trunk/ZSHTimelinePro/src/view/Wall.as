package view
{
	
	import events.MyEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	public class Wall extends Sprite
	{
		
		//private var v3d:View3DObject;
		private var ui:*;
		public function Wall(wallname:String)
		{
			super();
			var loader:Loader=new Loader();
			
			trace(wallname);
			loader.load(new URLRequest(ZSHTimelinePro.ROOT_PATH+wallname));
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFault);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			//addChild(loader);
		}
		
		private function onLoadFault(e:IOErrorEvent):void{
			var spr:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("Microsoft YaHei",150,0x000000);
			tf.background = true;
			tf.mouseEnabled = false;
			tf.backgroundColor = 0xffffff;
			tf.text = "缩略图加载失败";
			tf.width = tf.textWidth + 10;
			tf.height = tf.textHeight + 10;
			tf.cacheAsBitmap = true;
			addChild(spr);
			spr.addChild(tf);
			spr.buttonMode = true;
		}
		
		protected function completeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var loader:Loader=event.target.loader;
			var content:DisplayObject = loader.content;
			if(content is Bitmap){
				var mc:MovieClip = new MovieClip();
				mc.addChild(content);
				ui = mc;
			}else if(content is MovieClip){
				ui = content;
			}
			//			if(ui.hitarea){
			//				ui.hitarea.addEventListener(MouseEvent.CLICK,clickHandler);
			//			}
			(ui as MovieClip).buttonMode = true;
			addChild(ui);
		}

		public function get view():*{
			return ui;
		}
		
		
	}
}