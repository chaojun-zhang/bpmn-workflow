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
 */
package org.workflow.view.components
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	
	import org.workflow.view.constants.GraphConstants;
	import org.workflow.view.constants.GraphHitTest;
	import org.workflow.view.utils.PointUtils;
	import org.workflow.view.utils.RectangleUtils;

	public class GraphLink extends GraphBase
	{
		public static const SOLID_LINE :Number = 1;
		public static const DASHED_LINE :Number = 2;
		private var _fromNode:GraphNode;
		
		private var _toNode:GraphNode;
		
		//all points are relative to the graph container
		public var points:ArrayList;
		
		private var hitPointIndex:Number;
		
		private var _lineStyle:Number = SOLID_LINE;
		
		public function GraphLink()
		{
			super();
			points = new ArrayList();
		}
		
		public function get lineStyle():Number
		{
			return _lineStyle;
		}

		public function set lineStyle(value:Number):void
		{
			if (value == _lineStyle){
				return;
			}
			_lineStyle = value;
			
			if (skin){
				skin.invalidateDisplayList();
			}
			
		}

		override protected function onGraphRemove(event:FlexEvent):void
		{
			super.onGraphRemove(event);
			this.fromNode = null;
			this.toNode = null;
			this.points.removeAll();
			
		}
		
		private function getHitTestPoint():Point
		{
			return this.points.getItemAt(this.hitPointIndex) as Point;
		}
		
		
		override public function offSetByHitTest(offSetX:Number, offSetY:Number, hitTest:Number):void
		{
			if (offSetX!=0 || offSetY != 0){
				switch ( hitTest){
					case GraphHitTest.HT_POINT:
					case GraphHitTest.HT_START_POINT:
					case GraphHitTest.HT_END_POINT:
					case GraphHitTest.HT_DRAG_POINT:
						var hitPoint:Point = getHitTestPoint();
						hitPoint.x += offSetX;
						hitPoint.y += offSetY;
						break;
					case GraphHitTest.HT_LINE:
						break;
					case GraphHitTest.HT_CLIENT:
						if (this.fromNode && this.fromNode.dragging && this.toNode && this.toNode.dragging){
							for each(var p:Point  in points.source)
							{
								p.x += offSetX;
								p.y += offSetY;
							}
						}
						break;
					default :
						break;
				}
				if (graphParent && graphParent.isDragging())
				{
					offSetByGraphParent(offSetX,offSetY,hitTest);
				}
			}
			
			this.dispatchEvent(new MoveEvent(MoveEvent.MOVE));
		}
		
		private function offSetByGraphParent(offSetX:Number, offSetY:Number, hitTest:Number):void{
			var pointOffsetX:Number = 0;
			var pointOffsetY:Number = 0;
			switch ( hitTest){
				case GraphHitTest.HT_TOPLEFT:
					pointOffsetX = offSetX;
					pointOffsetY = offSetY;
					break;
				case GraphHitTest.HT_TOP:
					pointOffsetY = offSetY;
					break;
				case GraphHitTest.HT_TOPRIGHT:
					pointOffsetY = offSetY;
					break;
				case GraphHitTest.HT_LEFT:
					pointOffsetX = offSetX;
					break;
				case GraphHitTest.HT_RIGHT:
					break;
				case GraphHitTest.HT_BOTTOMLEFT:
					pointOffsetX = offSetX;
					break;
				case GraphHitTest.HT_BOTTOM:
					break;
				case GraphHitTest.HT_BOTTOMRIGHT:
					break;
				default:
					break;
			}
			
			for each(var p:Point  in points.source)
			{
				p.x += pointOffsetX;
				p.y += pointOffsetY;
			}
				
		}
		
		override protected function endDrag(localPt:Point):void 
		{
			super.endDrag(localPt);
			var wasDraggingSourcePt :Boolean = isDraggingSourcePt();
			var wasDraggingTargetPt :Boolean = isDraginggTargetPt();
			if (wasDraggingSourcePt || wasDraggingTargetPt){
				var graphNode:GraphNode = graphContainer.findTopGraphNodeAt(localPt);
				//can only link to the same graphParent
				if (graphNode )
				{
					if (wasDraggingSourcePt){
						this.fromNode = graphNode;
					}else{
						this.toNode = graphNode;
					}
				}
				
			}
			
		
			
		}
		
		public function getSourcePoint():Point
		{
			if (this.points.length >0){
				return this.points.getItemAt(0) as Point;
			}else{
				return null;
			}
		}
		
		public function getTargetPoint():Point
		{
			if (this.points.length >0){
				return this.points.getItemAt(this.points.length-1) as Point;
			}else {
				return null;
			}
		}
		
		override protected function adjustPosition():void
		{
			//remove points at the same position ,but exclude source and target point
			super.adjustPosition();
			if (points.length>=2){
				var relativePt:Point;
				if (this.fromNode != null)
				{
					var sourcePt:Point = getSourcePoint();
					relativePt =  fromNode.relativeHookAnchor(points.getItemAt(1) as Point);
					sourcePt.x = relativePt.x;
					sourcePt.y = relativePt.y;
				}
				
				if (this.toNode != null)
				{
					var targetPt:Point = getTargetPoint();
					relativePt = toNode.relativeHookAnchor(points.getItemAt(points.length -2) as Point);
					targetPt.x = relativePt.x;
					targetPt.y = relativePt.y;
				}
				//remove points which have same  postion
				for (var i:int = points.length-1 ;i >0 ; i--){
					var prevPt:Point = points.getItemAt(i-1) as Point;
					var currPoint:Point = points.getItemAt(i) as Point;
					
					if (RectangleUtils.makeRect(prevPt,GraphConstants.MARKER_RADIOUS).containsPoint(currPoint)
						|| RectangleUtils.makeRect(currPoint,GraphConstants.MARKER_RADIOUS).containsPoint(prevPt))
					{
						if (points.length >2){
							
							if (this.dragging){
								if (i <=this.hitPointIndex){
									this.hitPointIndex = this.hitPointIndex -1;
								}
							}
							this.removePoint(i);
						}
					}
				}
				
				
				if (skin){
					skin.invalidateDisplayList();
				}
				
			}
			
		}
		
		public function get toNode():GraphNode
		{
			return _toNode;
		}

		public function set toNode(value:GraphNode):void
		{
			if (_toNode == value){
				return;
			}
			if (_toNode){
				_toNode.removeIncommingLink(this);
			}
			
			if (value ){
				if ( value != this.fromNode && value.canAddIncoming()){
					value.addInCommingLink(this);
				}
				
			}
			
			_toNode = value;
			adjustPosition();
		}

		public function get fromNode():GraphNode
		{
			return _fromNode;
		}

		public function set fromNode(value:GraphNode):void
		{
			if (_fromNode == value){
				return;
			}
			if (_fromNode){
				_fromNode.removeOutgoingLink(this);
			}
			
			if (value){
				if (value != this.toNode && value.canAddOutgoing()){
					value.addOutgoingLink(this);
				}
				
			}
			_fromNode = value;
			adjustPosition();
			
		}
		
		
		override public function queryHitTest(localPt:Point):Number
		{
			if (selected ||  getGraphBounds().containsPoint(localPt))
			{
				var i:int;
				var currPt:Point ;
				var nextPt:Point ;
				var centerPt:Point ;
				for  (i =points.length -1 ;i>=0  ;i--)
				{
					currPt = points.getItemAt(i) as Point;
					if (RectangleUtils.makeRect(currPt,GraphConstants.MARKER_RADIOUS * 3).containsPoint(localPt)){
						this.hitPointIndex = i;
						if (i == 0){
							return GraphHitTest.HT_START_POINT;
						}else if (i==points.length -1){
							return GraphHitTest.HT_END_POINT;
						}else{
							return GraphHitTest.HT_POINT;
						}
					}else if (i >0) { // check point on the dragging point
						nextPt = points.getItemAt(i-1) as Point;
						centerPt = new Point((currPt.x + nextPt.x)/2, (currPt.y + nextPt.y)/2);
						if (RectangleUtils.makeRect(centerPt,GraphConstants.MARKER_RADIOUS * 2).containsPoint(localPt)){
							this.hitPointIndex = i;
							return GraphHitTest.HT_DRAG_POINT;
						}
						if (PointUtils.distanceToLine(currPt,nextPt,localPt) <= GraphConstants.MARKER_RADIOUS *3 ){
							return GraphHitTest.HT_LINE;
						}
					}
				}
				
			}
			return GraphHitTest.HT_NOWHERE;
		}
		
		
		private function isDraggingSourcePt():Boolean
		{
			var pt:Point = this.getHitTestPoint();
			if ( pt && points.getItemIndex(pt ) == 0){
				return true;
			}else{
				return false;
			}
		}
		
		private function isDraginggTargetPt():Boolean
		{
			var pt:Point = this.getHitTestPoint();
			if ( pt && points.getItemIndex(pt ) == points.length-1){
				return true;
			}else{
				return false;
			}
		}
		
		public function insertPoint(pt:Point):void
		{
			points.addItem(pt);
		}
		
		protected function insertPointAt(index:int ,pt:Point):void
		{
			points.addItemAt(pt,index);
		}
		
		protected function removePoint(index:Number):void
		{
			if (points.getItemAt(index)){
				points.removeItemAt(index);
			}
		}
		
		protected function link(fromNode:GraphNode,toNode:GraphNode):void
		{
			this.fromNode = fromNode;
			this.toNode = toNode;
		}
		
		override protected function beginDrag(pt:Point,ht:Number):void
		{
			if (ht == GraphHitTest.HT_DRAG_POINT)
			{
				var nearestPrevPt:Point = points.getItemAt(hitPointIndex-1) as Point;
				var nearestNextPt:Point = points.getItemAt(hitPointIndex) as Point;
				var p:Point = new Point((nearestPrevPt.x + nearestNextPt.x)/2, (nearestPrevPt.y + nearestNextPt.y)/2);
				this.insertPointAt(hitPointIndex,p);
			}else if (ht == GraphHitTest.HT_START_POINT)
			{
				this.fromNode = null;
			}else if (ht == GraphHitTest.HT_END_POINT)
			{
				this.toNode = null;
			}
			
			super.beginDrag(pt,ht);
		}
		
		override public function containsMarkerRect(markerRect:Rectangle):Boolean
		{
			for each(var p:Point in points.source ){
				if (!markerRect.containsPoint(p)){
					return false;
				}
			}
			return true;
			
		}
		
		override public function getGraphBounds():Rectangle
		{
			return RectangleUtils.getRectangle(this.points.source);
		}
		
		override protected function isLink():Boolean
		{
			return true;
		}
		
		override public function scale(factor:Number):void{
			super.scale(factor);
			var newPoints:Array = [];
			var i:int= 0;
			for each(var p:Point in this.points.source){
				newPoints[i] = p.clone();
				i++;
			}
			if (this.canMove && this.points.length > 1)
			{
				PointUtils.scalePoints(newPoints, this.scaleX, PointUtils.centerOfPoints(newPoints));
				this.points.removeAll();
				for each(p in newPoints){
					this.points.addItem(p);
				}
				adjustPosition();
				
			}
		}
		
	
	}
}