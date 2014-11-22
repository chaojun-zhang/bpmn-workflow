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
	import org.workflow.model.bpmn2.TBaseElement;
	import org.workflow.model.bpmn2.TLane;
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.components.GraphNode;
	import org.workflow.view.components.bpmn.link.FlowLink;
	import org.workflow.view.events.GraphLoadEvent;
	
	public class LaneNode extends GraphNode
	{
		public function LaneNode()
		{
			super();
		}
		
		private function getChildLanes():Array
		{
			var result:Array = [];
			
			if (this.graphChilds){
				for each (var graph:GraphBase in this.graphChilds.source){
					if (graph is LaneNode){
						result.push(graph);
					}
				}
			}
			return result;
		}
		
		
		override public function set graphParent(value:GraphBase):void
		{
			if (graphParent == value){
				return;
			}
			super.graphParent = value;
			if (value && value is LaneNode){
				
				for (var i:int = value.graphChilds.source.length-1; i>=0 ; i --){
					var child:GraphBase = value.graphChilds.getItemAt(i) as GraphBase;
					if (child != this && !(child is LaneNode) ){
						child.graphParent = this;
//						child.bringToFront();
					}
				}
				this.bringToFront();
				if ( this.isCreating()){
					setHeightWidthForCurrentLaneNode();
				}
			}
			
		}
		
		private function setHeightWidthForCurrentLaneNode():void{
			this.x = graphParent.x + 20;
			this.y = graphParent.y;
			
			graphParent.width = graphParent.width + 20;
			
			
			this.width = graphParent.width - 20;
//			this.height = graphParent.height ;
			var sumHeight:Number;
			for each(var childLane:LaneNode in graphChilds.source){
				sumHeight += childLane.height;
			}
			if (sumHeight == 0){
				sumHeight = graphParent.height;
			}
			this.height = sumHeight;
		}
		
		override public function canAddChild(child:GraphBase):Boolean
		{
			if (getChildLanes().length > 0 ){
				return child is LaneNode;
			}
			
			return (child is FlowNode || child is FlowLink || child is LaneNode) && !(child is BoundaryEventNode);
		}
		
		
		override protected function onGraphLoaded(event:GraphLoadEvent):void
		{
			var lane:TLane = model as TLane;
			if (lane.flowNodeRef ){
				
				for each(var flowNoeRef:TBaseElement in lane.flowNodeRef.source){
					
					for each (var graph:GraphBase in graphContainer.getAllGraph()){
						if (graph.model.id == flowNoeRef.id){
							graph.graphParent = this;
//							graph.bringToFront();
						}
					}
				} 
				this.bringToFront();
			}
			super.onGraphLoaded(event);
		}
	}
}