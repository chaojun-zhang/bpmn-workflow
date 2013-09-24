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
 */package org.workflow.view.components.bpmn.node
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.FlexEvent;
	
	import org.workflow.model.bpmn2.TActivity;
	import org.workflow.model.bpmn2.TBoundaryEvent;
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.events.GraphLoadEvent;
	
	public class BoundaryEventNode extends EventNode
	{
		
		private var _activityNode:ActivityNode;
		
		public function BoundaryEventNode()
		{
			super();
		}
		
		public function get activityNode():ActivityNode
		{
			return _activityNode;
		}

		public function set activityNode(value:ActivityNode):void
		{
			if (_activityNode == value)
			{
				return;
			}
			var oldActivityNode :ActivityNode = this._activityNode;
			if (oldActivityNode){
				oldActivityNode.boundaryEvents.removeItem(this);
			}
			_activityNode = value;
			if (_activityNode){
				_activityNode.boundaryEvents.addItem(this);
			}
		}

		override protected function adjustPosition():void
		{
			super.adjustPosition();
			this.adjustBoundaryPosition(getCenterPoint());
		}
		
		
		private function adjustBoundaryPosition(centrePt:Point):void
		{
			var graphRect:Rectangle = activityNode.getGraphBounds();
			var topPt:Point = new Point(centrePt.x,graphRect.top);
			var leftPt:Point = new Point(graphRect.left,centrePt.y);
			var bottomPt:Point = new Point(centrePt.x,graphRect.bottom);
			var rightPt:Point = new Point(graphRect.right,centrePt.y);
			var topLeftPt:Point = graphRect.topLeft;
			var bottomRightPt:Point = graphRect.bottomRight;
			var topRightPt:Point = new Point(graphRect.right,graphRect.top);
			var bottomLeftPt:Point  = new Point(graphRect.left,graphRect.bottom);
			
			var distanceToTop :Number = Point.distance(centrePt,topPt);
			var distanceToLeft:Number = Point.distance(centrePt,leftPt);
			var distanceToBottom:Number = Point.distance(centrePt,bottomPt);
			var distanceToRight:Number = Point.distance(centrePt,rightPt);
			
			var distanceToTopLeft:Number = Point.distance(centrePt,topLeftPt);
			var distanceToTopRight:Number = Point.distance(centrePt,topRightPt);
			var distanceToBottomLeft:Number = Point.distance(centrePt,bottomLeftPt);
			var distanceToBottomRight:Number = Point.distance(centrePt,bottomRightPt);
			
			
			var min:Number = Math.min(distanceToTop,distanceToLeft,distanceToBottom,distanceToRight,
				distanceToTopLeft,distanceToTopRight,distanceToBottomLeft,distanceToBottomRight);
			
			if (min == distanceToTop){
				this.x = topPt.x;
				this.y = topPt.y;
			}else if (min == distanceToTopLeft){
				this.x = topLeftPt.x;
				this.y = topLeftPt.y ;
			}else if (min == distanceToTopRight){
				this.x = topRightPt.x ;
				this.y = topRightPt.y ;
			}else if (min == distanceToLeft){
				this.x = leftPt.x ;
				this.y = leftPt.y;
			}else if (min == distanceToBottomLeft){
				this.x = bottomLeftPt.x ;
				this.y = bottomLeftPt.y ;
			}
			else if (min == distanceToBottom){
				this.x = bottomPt.x ;
				this.y = bottomPt.y ;
			}
			else if (min == distanceToBottomRight){
				this.x = bottomRightPt.x ;
				this.y = bottomRightPt.y ;
			}
			else if (min == distanceToRight){
				this.x = rightPt.x;
				this.y = rightPt.y;
			}
			if (this.x < graphRect.left ){
				this.x = graphRect.left;
			} else if (this.x > graphRect.right){
				this.x = graphRect.right;
			}
			if (this.y< graphRect.top){
				this.y = graphRect.top;
			}else if (this.y > graphRect.bottom){
				this.y = graphRect.bottom;
			}
			this.x -= this.width /2;
			this.y -= this.height/2;
		}
		
		override protected function onGraphLoaded(event:GraphLoadEvent):void
		{
			var boundaryEvent:TBoundaryEvent = this.model as TBoundaryEvent;
			if (boundaryEvent && boundaryEvent.attachedToRef){
				var attachedToRef:TActivity = boundaryEvent.attachedToRef;
				
				for each (var graph:GraphBase in graphContainer.getAllGraph()){
					if (graph is ActivityNode){
						var activity:TActivity = graph.model as TActivity;
						if (activity && activity == attachedToRef){
							this.activityNode = graph as ActivityNode;
							return ;
						}
					}
				}
			}
		}
		
		protected override function onGraphRemove(event:FlexEvent):void{
			super.onGraphRemove(event);
			this.activityNode = null;
				
		}
		
	}
}