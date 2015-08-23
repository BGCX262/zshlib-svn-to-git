package view
{
	import events.MyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import models.Vertex3D;
	import models.View3DObject;
	
	import rd.flash.components.FLoadingAlert;
	
	public class NWalk extends Sprite
	{
		private var v3ds:V3DScene = new V3DScene();
		private var step:int = 250;
		private var keyArr:Array=new Array();
		private var viewobjList:Array=new Array();
		private var bg:*;
		private var currentArr:*=0;
		private var camerazsite:int=-2000;
		private var camera3dView:View3DObject;
		private var camera3dViewY:int=0;
		
		private var bgcontainer:Sprite=new Sprite();
		private var piancontainer:Sprite=new Sprite();
		
		private var dic:Dictionary=new Dictionary();
		private var _wall:String="A";
		private var isRun:Boolean=false;
		private var currobj:Object;
		
		public function NWalk()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE,removeStage);
		}
		
		protected function removeStage(event:Event):void
		{
			clearKey();
		}
		
		public function setWall(str:String):void{
			_wall=str;
		}
		
		private function initEn():void{
			keyArr[0]=0;
			keyArr[1]=0;
			keyArr[2]=0;
			keyArr[3]=0;
			
			v3ds.camera.y=400;
			v3ds.camera.z=camerazsite;
			v3ds.camera.pan=90;
			v3ds.camera.width=1280;
			v3ds.camera.height=800;
		}
		
		public function stop():void{
			removeEventListener(Event.ENTER_FRAME,cd);
		}
		
		public function loadBG(bgpath:String):void
		{
			clearKey();
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,bgCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,bgLoadFault);
			loader.load(new URLRequest(bgpath));
			FLoadingAlert.getInstance().show("载入背景");
		}
		
		private function bgLoadFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("背景文件加载失败");
			bg = new MovieClip();
			initKey();
			dispatchEvent(new MyEvent(MyEvent.WALK_BG_LOADED));
			addChild(piancontainer);
		}
		
		private function progressHandler(e:ProgressEvent):void
		{
			//
		}
		
		protected function bgCompleteHandler(event:Event):void
		{
			FLoadingAlert.getInstance().hide();
			var loader:Loader=event.target.loader;
			bg=loader.content;
			
			isRun=true;
			
			initKey();
			dispatchEvent(new MyEvent(MyEvent.WALK_BG_LOADED));
			
			addChild(piancontainer);
		}
		
		public function setXMLCells(xml:XML):void{
			isRun=true;
			viewobjList=[];
			dic=new Dictionary();
			initEn();
			clear();
			
			var xl:XMLList=xml.cell;
			
			for(var i:int=0;i<xl.length();i++)
			{
				var bool:Boolean=Boolean(int(i%2));
				var obj:View3DObject=new View3DObject();
				obj.isLeft=!bool;
				obj.config=xl[i].@config;
				obj.type=xl[i].@type;
				obj.bg=xl[i].@ui;
				obj.mode = int(xl[i].@mode);
				obj.thumbnail=xl[i].@thumbnail;
				//obj.tagid=String(xl[i].@tagid);
				//obj.tagname = String(xl[i].@tagname);
				var _x:int=int(xl[i].@x);
				var _y:int=int(xl[i].@y);
				var _z:int=int(xl[i].@z)//+10000;
				var px:Number = xl[i].@px
				var py:Number = xl[i].@py
				
				trace(_x,_y,_z);
				//trace("-------------------->>>",_wall+"L",obj.swf);
				if(obj.isLeft){
					//obj.ui=new Wall(_wall+"L")//new UIStyle1L();
					obj.ui=new Wall(obj.thumbnail);
					//obj.ui.name="wall"
				}else{
					//obj.ui=new Wall(_wall+"R")//new UIStyle2L();
					obj.ui=new Wall(obj.thumbnail);
					//obj.ui.name="wall"
				}
				/*var pop:*;
				
				switch(obj.type)
				{
				case "txt":
				{
				pop=new TextPOP();
				
				break;
				}
				case "video":
				{
				pop=new VideoPOP();
				break;
				}
				case "imgtxt":
				{
				pop=new ImgTextPOP();
				break;
				}
				case "swf":
				{
				pop=new  SwfPop;
				break;
				}
				default:
				{
				break;
				}
				}
				pop.addEventListener(CustomEvent.EVENT_NAME,handler);
				dic[pop]=obj;
				
				if(pop as WindowBG){
				//trace(obj+"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
				//obj.ui.bmp_container.addChild(pop)
				pop.updata("configs/window/"+obj.config,true);
				pop.setBg(obj)
				//pop.addEventListener(CustomEvent.EVENT_NAME,popEventHander)
				pop.start()
				//obj.ui.cacheAsBitmap=true;
				//var sb:Sprite;
				//obj.ui.mouseChildren=false;
				}
				else{
				(pop as SwfPop).start("configs/window/"+obj.config)
				}*/
				obj.ui.addEventListener(MouseEvent.CLICK, onCellClick);
				obj.ui.name=""+i;
				/*if(obj.isLeft){
				obj.x=-1000;
				}else{
				obj.x=1000;
				}*/
				obj.x=_x;
				obj.y=_y;
				obj.z=_z;//Math.floor(i/2)*6000+7000+Math.random()*5000-2500;
				viewobjList.push(obj);
			}
			render(null);
		}
		
		protected function onCellClick(event:MouseEvent):void
		{
			var mc:DisplayObject=event.currentTarget as DisplayObject;
			camera3dView=viewobjList[mc.name];
			dispatchEvent(new MyEvent(MyEvent.WALK_SELECT,camera3dView));
		}
		
		public function initKey():void{
			if(stage!=null){
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP,keyupHandler);
				stage.addEventListener(Event.ENTER_FRAME,handlerKey);
			}
			
		}
		public function clearKey():void{
			if(stage!=null){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);
				stage.removeEventListener(KeyboardEvent.KEY_UP,keyupHandler);
				stage.removeEventListener(Event.ENTER_FRAME,handlerKey);
			}
		}
		
		private function keydownHandler(e:KeyboardEvent):void {
			stage.addEventListener(Event.ENTER_FRAME,handlerKey);
			
			switch(e.keyCode) {
				
				case 38:
					if(keyArr[1]==1) return;
					keyArr[1]=1;
					
					gotoView()
					camera3dView=null
					break;
				case 40:
					if(keyArr[3]==1) return;
					keyArr[3]=1;
					gotoView();
					camera3dView=null
					break; 
			}
			
		}
		private function keyupHandler(e:KeyboardEvent):void{
			stage.removeEventListener(Event.ENTER_FRAME,handlerKey);
			
			switch(e.keyCode) {
				
				case 38:
					
					if(keyArr[1]==0) return;
					keyArr[1]=0;
					gotoMovie();
					break;
				case 40:
					if(keyArr[3]==0) return;
					keyArr[3]=0;
					gotoMovie();
					break;
				
			}
			bg.stop();
			
		}
		
		private function handlerKey(e:Event):void{
			
			if(keyArr[1]==1){
				
				v3ds.camera.z+=step;
				render(null);
			}
			if(keyArr[3]==1){
				if(currentArr>0){
					v3ds.camera.z-=step;
					render(null);
				}else{
					if(v3ds.camera.z>camerazsite){
						v3ds.camera.z-=step;
						render(null);
					}else{
						
						if(isRun==true){
							//isRun=false;
							dispatchEvent(new MyEvent(MyEvent.WALK_GO_START));
						}
					}
				}
				
			}
			
		}
		
		public function setobj(obj:Object):void{
			currobj = obj;
			addEventListener(Event.ENTER_FRAME,cd);
		}
		
		private function cd(e:Event):void{
			flyto(currobj);
		}
		
		public function render(e:Event):void{
			clear();
			addChild(bg);
			addChild(piancontainer)
			if(keyArr[1]==1){
				bg.nextFrame();
				if(bg.currentFrame==bg.totalFrames){
					bg.gotoAndStop(1);
				}
			}
			if(keyArr[3]==1){
				bg.prevFrame();
				
				
				if(bg.currentFrame==1){
					
					bg.gotoAndStop(bg.totalFrames);
				}
			}
			
			viewobjList.sortOn("z",Array.NUMERIC);
			
			currentArr=getArrayCurrent();
			
			var a:Array=viewobjList//getNewArray(currentArr,50);
			
			var bp:View3DObject=a[viewobjList.length-1] as View3DObject;
			if(bp){
				if(bp.z-v3ds.camera.z<5000){
					
					if(isRun==true){
						isRun=false;
						dispatchEvent(new MyEvent(MyEvent.WALK_GO_END));
					}
					
				}
			}	
			for(var i:int=a.length-1;i>=0;i--){
				var ver:Vertex3D=new Vertex3D();
				var obj:View3DObject=a[i] as View3DObject;
				ver.x=obj.x;
				ver.y=obj.y;
				ver.z=obj.z;
				
				var j:int=i;
				var point:Point=v3ds.getPoint2D(ver);
				
				if(point==null){
					continue;
				}
				var lengs:int=ver.z-v3ds.camera.z;
				
				var alpha:Number
				if(lengs<0){
					alpha=0;
					
				}else if(lengs<5500){
					alpha=lengs/5500;
				}else{
					alpha=(20000-lengs+20000)/20000;
				}
				
				var scale:Number=v3ds.getScale(ver);
				var sp:*=obj.ui;
				
				sp.x=point.x;
				
				sp.y=point.y;
				sp.scaleX=sp.scaleY=scale;
				
				if(alpha==0){
					sp.visible=false;
				}else{
					sp.alpha=alpha;
					sp.visible=true;
				}
				
				
				//addChild(sp);
				
				if(lengs<30000){
					piancontainer.addChild(sp);
				}
			}
		}
		private  function flyto(obj:Object):void{
			trace(v3ds.camera.z-obj.z+5000)
			if(-1000<=v3ds.camera.z-obj.z+5000&&v3ds.camera.z-obj.z+5000<=1000){
				v3ds.camera.z=obj.z-5000;
				removeEventListener(Event.ENTER_FRAME,cd);
				return;
			}
			if(v3ds.camera.z>obj.z-5000){
				v3ds.camera.z-=1000;
				render(null);
			}else if(v3ds.camera.z<obj.z-5000){
				
				v3ds.camera.z+=1000;
				render(null);	
				
			}
			
		}
		public function getObject(id:String):void{
			
			for(var i:int=0;i<viewobjList.length;i++){
				if(viewobjList[i].tagid==id){
					setobj( viewobjList[i])
					//				if(v3ds.camera.z>viewobjList[i].z){
					//					v3ds.camera.z-=step;
					//					render(null);
					//				}else{
					//					
					//					v3ds.camera.z+=step;
					//					render(null);	
					//					
					//				}
					break;
				}
			}
			
		}
		private function gotoView():void{
			for(var i:int=0;i<piancontainer.numChildren;i++){
				var m:*=piancontainer.getChildAt(i);
				var b:*=m.view;
				if(b){
					b["gotoAndStop"](1);
				}
				
			}
		}
		private function gotoMovie():void{
			for(var i:int=0;i<piancontainer.numChildren;i++){
				var m:*=piancontainer.getChildAt(i);
				var b:*=m.view;
				if(b){
					b["gotoAndStop"](2);
				}
				
			}
		}
		private function clear():void{
			while(piancontainer.numChildren>0){
				piancontainer.removeChildAt(0);
			}
		}
		
		public function getArrayCurrent():int{
			//viewobjList
			var c:int=0;
			for(var i:int=0;i<viewobjList.length;i++){
				var ver:Vertex3D=new Vertex3D();
				var obj:View3DObject=viewobjList[i] as View3DObject;
				//trace(obj.z,v3ds.camera.z);
				if(obj.z<v3ds.camera.z){
					c=i;
				}
				
			}
			
			return c;
			
		}
		/**
		 * 
		 * 在数组中获取指定的长度的数组，如果位数不够 自动补齐；
		 * 
		 * */
		public function getNewArray(startindex:int,count:int):Array{
			var cz:int=viewobjList.length-startindex-1;
			var arr:Array;
			if(cz>count){
				arr=viewobjList.slice(startindex,startindex+count);
			}else{
				arr=viewobjList.slice(startindex,viewobjList.length);
				
				for(var i:int=viewobjList.length;i<count;i++){
					var bool:Boolean=Boolean(int(i%2));
					var obj:View3DObject=new View3DObject();
					obj.isLeft=!bool;
					obj.isReal=false;
					if(obj.isLeft){
						//obj.ui=new Wall(_wall+"L")//new UIStyle1L();
						obj.ui=new Wall(obj.thumbnail);
						//obj.ui.name="wall"
					}else{
						//obj.ui=new Wall(_wall+"R")//new UIStyle2L();
						obj.ui=new Wall(obj.thumbnail);
						//obj.ui.name="wall"
					}
					if(obj.isLeft){
						obj.x=-1000;
					}else{
						obj.x=1000;
					}
					obj.y=0;
					obj.z=Math.floor(i/2)*3500;
					
					arr.push(obj);
				}
				
			}
			return arr;
		}
		
	}
}