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
	import flash.geom.Rectangle;

	public class RectangleUtils
	{
		 
		public static function getMaxRect(rects:Array):Rectangle
		{
			var result:Rectangle = new Rectangle();
			result.x = Number.MAX_VALUE;
			result.y = Number.MAX_VALUE;
			result.right = Number.MIN_VALUE;
			result.bottom = Number.MIN_VALUE;
			for each(var rect:Rectangle in rects)
			{
				if (rect.x < result.x)
				{
					result.x = rect.x;
				}
				
				if (rect.y < result.y){
					result.y = rect.y;
				}
				
				if (rect.right > result.right)
				{
					result.right = rect.right;
				}
				
				if (rect.bottom > result.bottom)
				{
					result.bottom = rect.bottom;
				}
			}
			return result;
		}
		
		public static function getRectangle( points:Array):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			var top:Number = Number.MAX_VALUE;
			var left:Number = Number.MAX_VALUE;
			var right:Number = Number.MIN_VALUE;
			var bottom:Number = Number.MIN_VALUE;
			
			for each(var p:Point in points)
			{
				if (top >=  p.y){
					top = p.y;
				}
				if (left >= p.x){
					left = p.x;
				}
				
				if (right <= p.x)
				{
					right = p.x;
				}
				
				if (bottom <= p.y)
				{
					bottom = p.y;
				}
			}
			
			rect.left = left;
			rect.right = right;
			rect.top = top;
			rect.bottom = bottom;
			return rect;
		}
		
		public static function makeRect(centerPt:Point,radious:Number):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.left = centerPt.x - radious;
			rect.top = centerPt.y - radious;
			rect.width = radious *2;
			rect.height = radious * 2;
			return rect;
		}
		
		public static function makeRectWith2Pt(pt1:Point, pt2:Point):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			if (pt1.x > pt2.x)
			{
				rect.left = pt2.x;
			}else{
				rect.left = pt1.x;
			}
			if (pt1.y > pt2.y){
				rect.top = pt2.y;
			}else{
				rect.top = pt1.y;
			}
			rect.width = Math.abs(pt1.x - pt2.x);
			rect.height = Math.abs(pt1.y - pt2.y);
			return rect;
		}
		
	}
}