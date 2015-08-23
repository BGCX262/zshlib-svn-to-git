package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.ItemModel;
	
	import rd.flash.Application;
	import rd.flash.components.FLoadingAlert;
	
	import view.SearchPanel;
	
	[SWF(width="1280",height="800",frameRate="30",backgroundColor="0xffffff")]
	public class ZSHSearch extends Application
	{
		public static const CELL_PATH:String = "cells/";
		private static const ALL_DATA_FILE_PATH:String = "config.xml";
		private static const BG_PATH:String = "bg.swf";
		
		private var searchPanel:SearchPanel;
		
		override protected function startApp():void{
			ErrorAlert.setStage(stage);
			FLoadingAlert.getInstance().show("加载背景");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadBgFault);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBgComplete);
			loader.load(new URLRequest(BG_PATH));
		}
		
		private function onLoadBgFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("背景文件加载失败！");
		}
		
		private function onLoadBgComplete(e:Event):void{
			var bg:MovieClip = e.target.content as MovieClip;
			(e.target as LoaderInfo).loader.unload();
			(e.target as LoaderInfo).addEventListener(IOErrorEvent.IO_ERROR, onLoadBgFault);
			(e.target as LoaderInfo).addEventListener(Event.COMPLETE, onLoadBgComplete);
			addChild(bg);
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			FLoadingAlert.getInstance().show("加载数据");
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadFault);
			urlloader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urlloader.load(new URLRequest(CELL_PATH+ALL_DATA_FILE_PATH));
		}
		
		private function onXMLLoadFault(e:IOErrorEvent):void{
			FLoadingAlert.getInstance().hide();
			ErrorAlert.show("配置数据加载失败！");
		}
		
		private function onXMLLoaded(e:Event):void{
			FLoadingAlert.getInstance().hide();
			var arr:Array = [];
			try
			{
				var xml:XML = new XML(e.target.data);
				var xl:XMLList = xml.item;
				for(var i:int=0; i<xl.length(); i++){
					var im:ItemModel = new ItemModel();
					im.xml = xl[i];
					im.description = xl[i].@description;
					im.id = xl[i].@id;
					im.name = xl[i].@name;
					im.summary = xl[i].@summary;
					im.type = xl[i].@type;
					arr.push(im);
				}
			} 
			catch(error:Error) 
			{
				ErrorAlert.show("配置数据解析失败！");
				return;
			}
			
			var maskSpr:Sprite = new Sprite();
			maskSpr.graphics.beginFill(0x000000,0.3);
			maskSpr.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			maskSpr.graphics.endFill();
			addChild(maskSpr);
			
			searchPanel = new SearchPanel();
			searchPanel.x = (stage.stageWidth - searchPanel.width) / 2;
			searchPanel.y = (stage.stageHeight - searchPanel.height) / 2;
			addChild(searchPanel);
			searchPanel.allData = arr;
		}
		
		
	}
}