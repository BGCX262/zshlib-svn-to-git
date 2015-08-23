package pops
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ScrollViewControler
	{
		private var _slider:Sprite;
		private var _sliderBg:DisplayObject;
		private var _content:DisplayObject;
		private var _disHeight:Number;
		
		public function ScrollViewControler(slider:Sprite, sliderBg:DisplayObject, content:DisplayObject, disHeight:Number)
		{
			_slider = slider;
			_sliderBg = sliderBg;
			_content = content;
			_disHeight = disHeight;
			_slider.buttonMode = true;
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			update();
		}
		
		public function update():void{
			_content.y = 0;
			_slider.y = _sliderBg.y;
			_slider.visible = _content.height > _disHeight;
			if(_slider.visible){
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}else{
				_content.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
		}
		
		private function onWheel(e:MouseEvent):void{
			e.stopImmediatePropagation();
			var dis:Number = e.delta * 10;
			var yy:Number = _content.y + dis;
			if(yy > 0){
				yy = 0;
			}
			if(yy < _disHeight-_content.height){
				yy = _disHeight-_content.height;
			}
			_content.y = yy;
			var scale:Number = yy / (_content.height - _disHeight);
			_slider.y = _sliderBg.y + (_slider.height - _sliderBg.height) * scale;
		}
		
		private function onDown(e:MouseEvent):void{
			_slider.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_slider.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_slider.startDrag(false, new Rectangle(_sliderBg.x,_sliderBg.y,0,_sliderBg.height-_slider.height));
		}
		
		private function onMove(e:MouseEvent):void{
			var scale:Number = (_slider.y - _sliderBg.y) / (_slider.height - _sliderBg.height);
			_content.y = scale * (_content.height - _disHeight);
		}
		
		private function onUp(e:MouseEvent):void{
			_slider.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_slider.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_slider.stopDrag();
		}
		
		
	}
}