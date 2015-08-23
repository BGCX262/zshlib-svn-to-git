package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ErrorAlert extends Sprite
	{
		private var w:Number = 300;
		private var h:Number = 150;
		
		private var _tf:TextField;
		private var _btnClose:CloseButton;
		
		private static var _stage:Stage;
		private static var _alert:ErrorAlert;
		private static var maskSpr:Sprite;
		
		public static function setStage($stage:Stage):void{
			_stage = $stage;
		}
		
		public static function show(msg:String):void{
			if(!_alert){
				_alert = new ErrorAlert();
				_alert.btnClose.addEventListener(MouseEvent.CLICK,onCloseClick);
			}
			_alert.tf.text = msg;
			_alert.tf.height = _alert.tf.textHeight+4;
			_alert.tf.y = (_alert.height - _alert.tf.height) / 2;
			if(!maskSpr){
				maskSpr = new Sprite();
			}
			drawMaskSpr();
			_stage.addChild(maskSpr);
			_stage.addChild(_alert);
			_alert.x = (_stage.stageWidth - _alert.width) / 2;
			_alert.y = (_stage.stageHeight - _alert.height) / 2;
		}
		
		private static function drawMaskSpr():void{
			maskSpr.graphics.clear();
			maskSpr.graphics.beginFill(0x000000,0.3);
			maskSpr.graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			maskSpr.graphics.endFill();
		}
		
		private static function onCloseClick(e:MouseEvent):void{
			if(maskSpr && maskSpr.parent){
				_stage.removeChild(maskSpr);
			}
			if(_alert && _alert.parent){
				_stage.removeChild(_alert);
			}
		}
		
		public function ErrorAlert()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0xffffff,0.9);
			this.graphics.drawRoundRect(0,0,w,h,10,10);
			this.graphics.endFill();
			
			_tf = new TextField();
			_tf.selectable = false;
			_tf.defaultTextFormat = new TextFormat("Microsoft YaHei",14,0x000000);
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.width = w - 40;
			addChild(_tf);
			_tf.x = (w - _tf.width) / 2;
			_tf.y = (h - _tf.height) / 2;
			
			_btnClose = new CloseButton();
			_btnClose.x = w - _btnClose.width - 5;
			_btnClose.y = -5;
			addChild(_btnClose);
		}
		
		public function get tf():TextField
		{
			return _tf;
		}
		
		public function get btnClose():CloseButton
		{
			return _btnClose;
		}
		
		
	}
}