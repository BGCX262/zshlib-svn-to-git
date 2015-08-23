package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Popuper
	{
		private static var stage:Stage;
		public static function setStage($stage:Stage):void{
			stage = $stage;
		}
		
		private static var maskSpr:Sprite;
		
		private static var currentObj:DisplayObject;
		public static function show(display:DisplayObject):void{
			if(!maskSpr){
				maskSpr = new Sprite();
			}
			drawMaskSpr();
			stage.addChild(maskSpr);
			if(display){
				currentObj = display;
				stage.addChild(currentObj);
				onCurrentObjResize(null);
				currentObj.addEventListener(Event.RESIZE, onCurrentObjResize);
			}
		}
		
		private static function onCurrentObjResize(e:Event):void{
			currentObj.x = (stage.stageWidth - currentObj.width) / 2;
			currentObj.y = (stage.stageHeight - currentObj.height) / 2;
		}
		
		public static function hide():void{
			if(currentObj){
				if(currentObj.parent) stage.removeChild(currentObj);
				currentObj.removeEventListener(Event.RESIZE, onCurrentObjResize);
				currentObj = null;
			}
			if(maskSpr && maskSpr.parent){
				stage.removeChild(maskSpr);
			}
		}
		
		private static function drawMaskSpr():void{
			maskSpr.graphics.clear();
			maskSpr.graphics.beginFill(0x000000,0.6);
			maskSpr.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			maskSpr.graphics.endFill();
		}
		
		
	}
}