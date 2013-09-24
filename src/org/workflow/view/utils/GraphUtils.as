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
	import flash.display.Graphics;
	import flash.geom.Point;
	

	public class GraphUtils
	{
		public static function drawDashedLine(graphics:Graphics,  p1:Point, p2:Point, 
									pointLength:Number, twoPointDistance:Number):void
		{              
			
			var max:Number = Point.distance(p1, p2);              
			var dis:Number = 0;              
			var p3:Point;              
			var p4:Point;              
			while(dis < max){                  
				p3 = Point.interpolate(p2, p1, dis / max);                  
				dis += pointLength;                  
				if(dis > max){                     
					dis = max;                  
				}                  
				p4 = Point.interpolate(p2, p1, dis / max);                  
				graphics.moveTo(p3.x, p3.y);                  
				graphics.lineTo(p4.x, p4.y);                  
				dis += twoPointDistance;              
			}              
		}   
	}
}