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
 */////////////////////////////////////////////////////////////////////////////////
//
//  ChaoJun Zhang
//  All Rights Reserved.
//  zcj23085@gmail.com
//
//  NOTICE: I permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package org.workflow.view.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.workflow.view.constants.GraphHitTest;

	public class MathUtils
	{
		
		
		public static  function lineSlopeAngle(linePt1:Point, linePt2: Point):Number
		{
			
			var result:Number = 0;
			if (linePt1.x != linePt2.x) {
				result = Math.atan2(linePt2.y - linePt1.y, linePt2.x - linePt1.x);
			}else if (linePt1.y > linePt2.y){
				result = -Math.PI / 2
			}
			else if( linePt1.y < linePt2.y ){
				result = Math.PI / 2
			}
			return result;
			
		}
		
		public static  function normalizeAngle( angle: Number): Number{
			var result : Number = angle;
			while (result > Math.PI ){
				result = result - 2 * Math.PI;
			}
			while (result < -Math.PI ){
				result = result + 2 * Math.PI;
			}
			return result;
		}

		
		public static  function nextPointOfLine( lineAngle: Number,  ThisPt: Point,
									    DistanceFromThisPt: Number):Point
		{
			var x:Number;
			var y:Number;
			var m:Number;
			var Angle:Number;
			var result:Point = new Point(0,0);
			Angle = normalizeAngle(lineAngle);
			if (Math.abs(Angle) != Math.PI / 2){
				m = Math.tan(lineAngle);
				if (Math.abs(Angle) < Math.PI /2){
					x = ThisPt.x - DistanceFromThisPt / Math.sqrt(1 + MathUtils.sqr(m));
				}
				else{
					x = ThisPt.x + DistanceFromThisPt / Math.sqrt(1 + MathUtils.sqr(m));
				}
				y = ThisPt.y + m * (x - ThisPt.x);
				result.x = Math.round(x);
				result.y = Math.round(y);
			}
			else
			{
				result.x = ThisPt.x;
				if (Angle > 0){
					result.y = ThisPt.y - Math.round(DistanceFromThisPt);
				}
				else{
					result.y = ThisPt.y + Math.round(DistanceFromThisPt);
				}
			}
			return result;
		}
			
		public static function intersectLineRect( linePt: Point,  lineAngle: Number ,rect: Rectangle): Array
		{
			var corners: Array = [];
			corners[0] = new Point( Math.round(rect.left),Math.round(rect.top));
			corners[1] = new Point( Math.round(rect.right), Math.round(rect.top));
			corners[2] = new Point( Math.round(rect.right),Math.round(rect.bottom));
			corners[3] = new Point(  Math.round(rect.left),Math.round(rect.bottom));
			return intersectLinePolygon(linePt, lineAngle, corners);
		}
		
		
		public static function intersectLinePolygon( linePt: Point, lineAngle: Number,
											 vertices: Array): Array
		{
			var i: int;
			var v1:int;
			var v2: int;
			var edgeAngle: Number = 0;
			
			var result :Array = [];
			for (i =0; i < vertices.length ;i++)
			{
				var intersect: Point = new Point();
				v1 = i;
				v2 = (i+1) % vertices.length;
				edgeAngle = lineSlopeAngle(vertices[v1], vertices[v2]);
				var isInterSectLines:Boolean = intersectLines( linePt, lineAngle, vertices[v1], edgeAngle, intersect);
				var isBetweenV1:Boolean = isBetween(intersect.x, vertices[v1].x, vertices[v2].x);
				var isBetweenV2:Boolean = isBetween(intersect.y, vertices[v1].y, vertices[v2].y);
				if (isInterSectLines && isBetweenV1
				 && isBetweenV2)
				{
					result[result.length] = intersect;
				}
				
			}
			return result;
		}
		
		public static function intersectLines( line1Pt: Point,  line1Angle: Number,
										line2Pt: Point,  line2Angle: Number, intersect: Point): Boolean
		{
			var m1:Number
			var m2: Number;
			var c1:Number;
			var c2: Number;
			var result:Boolean = true;
			if (((Math.abs(line1Angle) == Math.PI / 2) && (Math.abs(line2Angle) == Math.PI / 2))){
				result = false;
			}else if (Math.abs(line1Angle) == Math.PI / 2 )
			{
				m2 = Math.tan(line2Angle);
				c2 = line2Pt.y - m2 * line2Pt.x;
				intersect.x = line1Pt.x;
				intersect.y = Math.round(m2 * intersect.x + c2);
			}
			else if (Math.abs(line2Angle) == Math.PI / 2 )
			{
				m1 = Math.tan(line1Angle);
				c1 = line1Pt.y - m1 * line1Pt.x;
				intersect.x = line2Pt.x;
				intersect.y = Math.round(m1 * intersect.x + c1);
			}
			else
			{
				m1 = Math.tan(line1Angle);
				m2 = Math.tan(line2Angle);
				if (m1 == m2 ){
					result = false;
				}else
				{
					c1 = line1Pt.y - m1 * line1Pt.x;
					c2 = line2Pt.y - m2 * line2Pt.x;
					intersect.x = Math.round((c1 - c2) / (m2 - m1));
					intersect.y = Math.round((m2 * c1 - m1 * c2) / (m2 - m1));
				}
			}
			return result;
		}

		
		public static function isBetween(Value: int, Bound1:int, Bound2: int): Boolean
		{
			if (Bound1 <= Bound2){
				return  (Value >= Bound1) && (Value <= Bound2);
			}
			else{
				return(Value >= Bound2) && (Value <= Bound1);
			}
		
		}
		
		public static function intersectLineEllipse( linePt: Point,  lineAngle: Number,
											  bounds: Rectangle): Array
		{
			var x:Number ;
			var y:Number;
			var c:Number ;
			var d:Number
			var result:Array = [];
			if (bounds.isEmpty()) { 
				return result;
			}
			var Xc:Number = (bounds.left + bounds.right) / 2;
			var Yc:Number = (bounds.top + bounds.bottom) / 2;
			var A2:Number = MathUtils.sqr((bounds.right - bounds.left) / 2);
			var B2:Number = MathUtils.sqr((bounds.bottom - bounds.top) / 2);
			if (Math.abs(lineAngle) == Math.PI / 2)
			{
				d = 1 - (MathUtils.sqr(linePt.x - Xc) / A2);
				if (d >= 0) 
				{
					if (d == 0) 
					{
						result[0] = new Point(linePt.x,Math.round(Yc));
					}
					else{
						c = Math.sqrt(B2) * Math.sqrt(d);
						result[0] = new Point( linePt.x, Math.round(Yc - c));
						result[1] = new Point( linePt.x , Math.round(Yc + c));
					}
				}
				else
				{
					var M:Number = Math.tan(lineAngle);
					c = linePt.y - M * linePt.x;
					var a:Number = (B2 + A2 * MathUtils.sqr(M));
					var b:Number  = (A2 * M * (c - Yc)) - B2 * Xc;
					d = MathUtils.sqr(b) - a * (B2 * MathUtils.sqr(Xc) + A2 * MathUtils.sqr(c - Yc) - A2 * B2);
					if ((d >= 0) && (a != 0 )) 
					{
						if (d == 0) 
						{
						    x = -b / a;
							y = M * x + c;
							result[0] = new Point(Math.round(x), Math.round(y));
						}
						else
						{
							x  = (-b - Math.sqrt(d)) / a;
							y = M * x + c;
							result[0] = new Point( Math.round(x), Math.round(y));
							x = (-b + Math.sqrt(d)) / a;
							y = M * x + c;
							result[1] = new Point( Math.round(x), Math.round(y));
						}
					}
				}
			}
			return result;
		}
			
		
		public static function intersectLineRoundRect( linePt: Point,  lineAngle: Number,
												bounds: Rectangle, cw:int ,ch: int): Array{
			var i: int;
			var cornerIntersects: Array = [];
			var w:int;
			var h:int;
			var  xc:int
			var  yc:int ;
			var dX:int;
			var dY: int;
			var result:Array = intersectLineRect(linePt, lineAngle, bounds);
			if (result.length > 0) 
			{
				w = bounds.right - bounds.left;
				h = bounds.bottom - bounds.top;
				xc = (bounds.left + bounds.right) / 2;
				yc = (bounds.top + bounds.bottom) / 2;
				for (i = 0 ;i < result.length; i++ )
				{
					dX = result[i].x - xc;
					dY = result[i].y - yc;
					if (((w / 2) - (Math.abs(dX)) < (cw / 2)) && (((h / 2) - Math.abs(dY)) < (ch / 2))) 
					{
						var cornerBounds: Rectangle = new Rectangle();
						cornerBounds.left = bounds.left;
						cornerBounds.top = bounds.top;
						cornerBounds.right = bounds.left + cw;
						cornerBounds.bottom = bounds.top + ch;
						
						if (dX > 0) {
							cornerBounds.offset(w-cw,0);
						}  
						if (dY > 0) {
							cornerBounds.offset(0,h-ch);
						}  
						cornerIntersects = intersectLineEllipse(linePt, lineAngle, cornerBounds);
						if ( cornerIntersects.length == 2 ){
							if (dX < 0){ 
								result[i] = cornerIntersects[0];
							}else{
								result[i] = cornerIntersects[1];
							}
						}
					}
				}
			}
			cornerIntersects = [];
			return result;
		}
		
		
		public static function nearestPoint( points:Array , refPt: Point): int
		{
			var i: int;
			var nearestDistance: Number = Number.MAX_VALUE;
			var result:int = -1;
			for (i = 0; i<points.length ; i++){
				var distance: Number = Point.distance(points[i], refPt);
				if (distance < nearestDistance ){
					nearestDistance = distance;
					result = i;
				}
				
			}
			return result;
		}
		
		public static function sqr(n:Number):Number
		{
			return n* n;
		}
	
	}
}