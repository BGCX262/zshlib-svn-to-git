package view
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import models.VCamera;
	import models.Vertex3D;
	
	public class V3DScene extends Sprite
	{
		public var camera:VCamera = new VCamera();
		
		public function V3DScene()
		{
			
		}
		
		
		public function render():void{

		}
		
		public function isRemove(vertex:Vertex3D):Boolean{
			var b:Number=camera.z-(1/Math.tan((camera.pan+90)*Math.PI/180))*camera.x;
			var ny:Number=(1/Math.tan((camera.pan+90)*Math.PI/180))*vertex.x+b;
			if(ny>vertex.z){
				return true;
			}else{
				return false;
			}
		}
		
		public function getPoint2D(vertex:Vertex3D):Point{

			var x_distance:Number = vertex.x - camera.x;
			var y:Number=0;
			var y_distance:Number = vertex.y-camera.y;
			var z_distance:Number =vertex.z-camera.z;
			var tempx:Number, tempy:Number, tempz:Number;
			
			var angle:Number=(360-camera.pan+90)*Math.PI/180;
			
			tempx = Math.cos(angle)*x_distance - Math.sin(angle)*z_distance;
			tempz = Math.sin(angle)*x_distance + Math.cos(angle)*z_distance;
			x_distance = tempx;
			z_distance = tempz;
			
			angle = 0;
			tempy = Math.cos(angle)*y_distance - Math.sin(angle)*z_distance;
			tempz = Math.sin(angle)*y_distance + Math.cos(angle)*z_distance;
			y_distance = tempy;
			z_distance = tempz;
			
			angle = 0;
			tempx = Math.cos(angle)*x_distance - Math.sin(angle)*y_distance;
			tempy = Math.sin(angle)*x_distance + Math.cos(angle)*y_distance;
			x_distance = tempx;
			y_distance = tempy;
			
			var scale:Number=camera.width/(camera.width+z_distance);
			
			var x2d:Number=x_distance*scale+camera.width*.5;
			var y2d:Number=-y_distance*scale+camera.height*.5;
			
			if(z_distance>0){
				return new Point(x2d,y2d);
			}else{
				return null;
			}
		}
		
		public function getScale(vertex:Vertex3D):Number{
			var z_distance:Number =vertex.z-camera.z; 
			var scale:Number=camera.width/(camera.width+z_distance);
			return scale;
		}
		
		
	}
}