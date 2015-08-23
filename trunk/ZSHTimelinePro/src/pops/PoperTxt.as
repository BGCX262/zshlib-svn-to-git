package pops
{
	import flash.text.TextField;
	
	public class PoperTxt extends PoperBaseWindow
	{
		private var uiMC:TextPoper;
		private var _scrollContorler:ScrollViewControler;
		
		public function PoperTxt()
		{
			super();
			uiMC = new TextPoper();
			bg.addChild(uiMC);
			bg.addChild(bg.closeBtn);
			bg.addChild(bg.btnMore);
			bg.addChild(bg.btn3d);
			uiMC.y = bg.closeBtn.y;
			uiMC.x = (bg.width - uiMC.width) / 2;
			var tfContent:TextField = uiMC.txtMc.txt as TextField;
			tfContent.wordWrap = true;
			tfContent.multiline = true;
			_scrollContorler = new ScrollViewControler(uiMC.slider, uiMC.scroll_bg, uiMC.txtMc.txt, uiMC.txtMc.maskMC.height);
			
			bg.btn3d.visible = false;
			bg.btnMore.visible = false;
		}
		
		override public function set xmlData(value:XML):void{
			_xmlData = value;
			_poper.hideLoading();
			bg.bg.gotoAndStop(int(_v3dData.bg));
			uiMC.firstTitle.text = _xmlData.@name;
			uiMC.secondTitle.text = _xmlData.@summary;
			uiMC.txtMc.txt.text = _xmlData.@description;
			(uiMC.txtMc.txt as TextField).height = (uiMC.txtMc.txt as TextField).textHeight+4;
			_scrollContorler.update();
		}
		
		
	}
}