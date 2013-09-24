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
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.utils.CollectionUtils;
	
	public class ActivityNode extends FlowNode
	{
		private  static const BOUNDARY_DISTANCE:Number = 5;
		private var _boundaryEvents:ArrayList;
		
		
		public function ActivityNode()
		{
			super();
			
			this._boundaryEvents = new ArrayList();
		}

		public function get boundaryEvents():ArrayList
		{
			return _boundaryEvents;
		}

		public function set boundaryEvents(value:ArrayList):void
		{
			_boundaryEvents = value;
		}
		
		override protected function notifiyDependencies(event:Event):void
		{
			super.notifiyDependencies(event);
			
			for each( var boundaryEventNode:GraphBase in boundaryEvents.source){
				
				boundaryEventNode.dispatchEvent(event.clone());
			}
		}
		
		override public function set dragging(value:Boolean):void
		{
			if (super.dragging == value){
				return;
			}
			
			super.dragging = value;
			if (value){
			
				CollectionUtils.forEach(this,_boundaryEvents,function (graph:GraphBase):void{
					graph.dragging = true;
				});
				
			}else{
			
				CollectionUtils.forEach(this,_boundaryEvents,function (graph:GraphBase):void{
					graph.dragging = false;
				});
			}
			
			
		}
		
		override protected function onGraphRemove(event:FlexEvent):void{
			super.onGraphRemove(event);
			
			CollectionUtils.forEach(this,boundaryEvents,function(graph:GraphBase):void{
				graphContainer.removeElement(graph);
				
			},true);
			
			this.boundaryEvents.removeAll();
			super.onGraphRemove(event);
		}
		
		override public function canCreateGraphUnderPoint(localPt:Point,graph:GraphBase):Boolean
		{
			if (graph && graph is BoundaryEventNode){
				if (  this.getGraphBounds().containsPoint(localPt)){
					(graph as BoundaryEventNode).activityNode = this;
					return true;
				}else{
					return false;
				}
			}
			return super.canCreateGraphUnderPoint(localPt,graph);
		}
		

	}
}