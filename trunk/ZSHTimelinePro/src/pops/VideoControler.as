package pops
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoControler
	{
		private var _videoMC:VideoPlayer;
		private var vContainer:MovieClip;
		private var video:Video;
		private var _url:String;
		private var conn:NetConnection;
		private var stream:NetStream;
		private var _duration:Number;
		private var _videoW:Number = 0;
		private var _videoH:Number = 0;
		private var _isPlaying:Boolean;
		private var _hasMeta:Boolean;
		private var _soundTrans:SoundTransform;
		
		private var vbX:Number;
		private var vbY:Number;
		private var vbW:Number;
		private var vbH:Number;
		
		public function VideoControler(videoMC:VideoPlayer)
		{
			_videoMC = videoMC;
			vContainer = _videoMC.videoBg;
			_videoMC.btnDrag.buttonMode = true;
			_videoMC.volBg.buttonMode = true;
			_videoMC.btnBigPlay.buttonMode = true;
			_videoMC.volBar.mouseEnabled = false;
			_videoMC.volBar.width = _videoMC.volBg.width;
			_videoMC.btnPlay.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			_videoMC.btnPause.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			_videoMC.btnBigPlay.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			_videoMC.btnDrag.addEventListener(MouseEvent.MOUSE_DOWN, onDragDown);
			_videoMC.volBg.addEventListener(MouseEvent.CLICK, onVolClick);
			_videoMC.btnFull.addEventListener(MouseEvent.CLICK, onFullClick);
			_videoMC.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			vbX = vContainer.x;
			vbY = vContainer.y;
			vbW = vContainer.width;
			vbH = vContainer.height;
			
			video = new Video();
			videoMC.videoBg.addChild(video);
			resetView();
			conn = new NetConnection();
			conn.connect(null);
			stream = new NetStream(conn);
			stream.bufferTime = 3;
			stream.client = this;
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			video.attachNetStream(stream);
			_soundTrans = new SoundTransform(1);
		}
		
		private function onAdded(e:Event):void{
			_videoMC.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			_videoMC.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}
		
		private function onFullScreen(e:Event):void{
			if(_videoMC.stage){
				if(_videoMC.stage.displayState == StageDisplayState.FULL_SCREEN){
					_videoMC.stage.addChild(vContainer);
					vContainer.x = 0;
					vContainer.y = 0;
					vContainer.width = _videoMC.stage.stageWidth;
					vContainer.height = _videoMC.stage.stageHeight;
				}else{
					_videoMC.addChild(vContainer);
					vContainer.x = vbX;
					vContainer.y = vbY;
					vContainer.width = vbW;
					vContainer.height = vbH;
				}
			}
		}
		
		private function onFullClick(e:MouseEvent):void{
			_videoMC.stage.displayState = StageDisplayState.FULL_SCREEN;
			//and to do...
		}
		
		private function onVolClick(e:MouseEvent):void{
			_soundTrans.volume = e.localX / _videoMC.volBg.width;
			stream.soundTransform = _soundTrans;
			_videoMC.volBar.width = e.localX;
		}
		
		private function onPlayPauseClick(e:MouseEvent):void{
			_isPlaying = !_isPlaying;
			_videoMC.btnBigPlay.visible = !_isPlaying;
			_videoMC.btnPlay.visible = !_isPlaying;
			_videoMC.btnPause.visible = _isPlaying;
			stream.togglePause();
			if(_isPlaying){
				_videoMC.addEventListener(Event.ENTER_FRAME, onPlayFrame);
			}else{
				_videoMC.removeEventListener(Event.ENTER_FRAME, onPlayFrame);
			}
		}
		
		private function onDragDown(e:MouseEvent):void{
			_videoMC.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
			_videoMC.stage.addEventListener(MouseEvent.MOUSE_UP, onDragUp);
			_videoMC.removeEventListener(Event.ENTER_FRAME, onPlayFrame);
			_videoMC.btnDrag.startDrag(false, new Rectangle(_videoMC.processBg.x,_videoMC.btnDrag.y,_videoMC.loadBar.width,0));
		}
		
		private function onDragMove(e:MouseEvent):void{
			_videoMC.processBar.width = _videoMC.btnDrag.x - _videoMC.processBar.x;
			_videoMC.txtTime.text = formatTime(_duration*(_videoMC.processBar.width/_videoMC.processBg.width)) + " / " + formatTime(_duration);
		}
		
		private function onDragUp(e:MouseEvent):void{
			_videoMC.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
			_videoMC.stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUp);
			_videoMC.btnDrag.stopDrag();
			var time:Number = _duration*(_videoMC.processBar.width/_videoMC.processBg.width);
			stream.seek(time);
			_videoMC.loadingMC.visible = true;
		}
		
		public function onMetaData(mdata:Object):void{
			if(!_hasMeta){
				_hasMeta = true;
				_duration = mdata.duration; //秒
				_videoW = mdata.width;
				_videoH = mdata.height;
				
				video.height = vbH;
				video.width = vbW / (_videoH / video.height);
				video.x = (vbW - video.width) / 2;
				
				_videoMC.mouseChildren = true;
				_videoMC.btnPlay.visible = false;
				_videoMC.btnPause.visible = true;
				_videoMC.addEventListener(Event.ENTER_FRAME, onPlayFrame);
			}
		}
		
		public function onPlayStatus(info:Object):void{
			if(info.code == "NetStream.Play.Complete"){
				_videoMC.removeEventListener(Event.ENTER_FRAME, onPlayFrame);
				_isPlaying = false;
				_videoMC.btnBigPlay.visible = true;
				_videoMC.btnPlay.visible = true;
				_videoMC.btnPause.visible = false;
				_videoMC.txtTime.text = "00:00 / "+formatTime(_duration);
				_videoMC.btnDrag.x = _videoMC.processBg.x;
				_videoMC.processBar.width = 0;
				stream.seek(0);
				stream.pause();
			}
		}
		
		private function onNetStatus(e:NetStatusEvent):void{
			trace(e.info.code);
			switch(e.info.code){
				case "NetStream.Buffer.Empty":
					if(_isPlaying){
						_videoMC.loadingMC.visible = true;
					}
					break;
				case "NetStream.Buffer.Full":
					_videoMC.loadingMC.visible = false;
					break;
				case "NetStream.Seek.Complete":
					_videoMC.loadingMC.visible = false;
					if(_isPlaying){
						_videoMC.addEventListener(Event.ENTER_FRAME, onPlayFrame);
					}
					break;
				case "NetStream.Play.Stop":
					onPlayStatus({code:"NetStream.Play.Complete"});
					break;
				case "NetStream.Play.StreamNotFound":
					ErrorAlert.show("视频加载失败");
					break;
			}
		}
		
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
			_videoMC.loadingMC.visible = true;
			stream.play(_url);
			_isPlaying = true;
			_videoMC.addEventListener(Event.ENTER_FRAME, onLoadFrame);
		}
		
		private function onLoadFrame(e:Event):void{
			var loaded:Number = stream.bytesLoaded / stream.bytesTotal;
			_videoMC.loadBar.width = _videoMC.processBg.width * loaded;
			if(loaded == 1){
				_videoMC.removeEventListener(Event.ENTER_FRAME, onLoadFrame);
			}
		}
		
		private function onPlayFrame(e:Event):void{
			_videoMC.btnDrag.x = _videoMC.processBg.x + _videoMC.processBg.width*(stream.time/_duration);
			_videoMC.processBar.width = _videoMC.btnDrag.x - _videoMC.processBar.x;
			updateTime();
		}
		
		private function updateTime():void{
			_videoMC.txtTime.text = formatTime(stream.time) + " / " + formatTime(_duration);
		}
		
		private function formatTime(time:int):String{
			var m:String = int(time / 60).toString();
			var s:String = int(time % 60).toString();
			if(m.length==1) m = "0"+m;
			if(s.length==1) s = "0"+s;
			return m+":"+s;
		}
		
		public function dispose():void{
			_videoMC.removeEventListener(Event.ENTER_FRAME, onLoadFrame);
			_videoMC.removeEventListener(Event.ENTER_FRAME, onPlayFrame);
			stream.close();
			resetView();
			_isPlaying = false;
			_hasMeta = false;
			_url = null;
			_duration = 0;
			_videoW = 0;
			_videoH = 0;
			video.clear();
		}
		
		private function resetView():void{
			_videoMC.mouseChildren = false;
			_videoMC.btnPlay.visible = true;
			_videoMC.btnPause.visible = false;
			_videoMC.btnBigPlay.visible = false;
			_videoMC.loadingMC.visible = false;
			_videoMC.txtTime.text = "00:00 / 00:00";
			_videoMC.btnDrag.x = _videoMC.processBg.x;
			_videoMC.processBar.width = 0;
			_videoMC.loadBar.width = 0;
		}
		
		public function onXMPData(data:Object):void{
			
		}
		

	}
}