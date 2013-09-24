/**
 Copyright (c) 2011  ChaoJun Zhang  <zcj23085@gmail.com>
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 @internal
 */package org.workflow.view.utils
{
	import flash.geom.Point;

	public class PointUtils
	{
		
		public static function distanceToLine(pt1:Point,pt2:Point,queryPt:Point):Number
		{
			var length:Number;
			var b:Number = getLenWithPoints(pt1,  queryPt);
			var c:Number = getLenWithPoints(pt2, queryPt);
			var a:Number = getLenWithPoints(pt1, pt2);
			
			if ((c + b) == a) {
				length =   0;
			} else if (c * c >= (a * a + b * b)) { 
				length = b;
			} else if (b * b >= (a * a + c * c)) {
				length = c;
			} else {
				var  p:Number = (a + b + c) / 2;
				var s:Number = Math.sqrt(p * (p - a) * (p - b) * (p - c));
				length = 2 * s / c;
			}
			
			return length;
		}
		
		
		private static function getLenWithPoints(pt1:Point,pt2:Point):Number {
			return Math.sqrt(Math.pow(pt2.x - pt1.x, 2) + Math.pow(pt2.y - pt1.y, 2));
		}
		
		public static function centerOfPoints(points:Array): Point{
			var sum: Point = new Point(0,0);
			for each(var p:Point in points){
				sum.x +=  p.x;
				sum.y +=  p.y;
			}
			sum.x = sum.x / points.length;
			sum.y = sum.y / points.length;
			return sum;
		}
		
		
		public static function scalePoints(points:Array, factor: Number,refPt: Point):void{
			for (var i:int =0 ; i <points.length ;i ++ )
			{
				var angle:Number = MathUtils.lineSlopeAngle(points[i], refPt);
				var distance:Number =  Point.distance(points[i], refPt);
				points[i] = MathUtils.nextPointOfLine(angle, refPt, distance * factor);
			}
		}
		
	}
}