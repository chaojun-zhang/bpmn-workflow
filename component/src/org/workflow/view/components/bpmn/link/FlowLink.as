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
package org.workflow.view.components.bpmn.link
{
	import org.workflow.model.bpmn2.TFlowNode;
	import org.workflow.model.bpmn2.TSequenceFlow;
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.components.GraphLink;
	import org.workflow.view.components.GraphNode;
	import org.workflow.view.components.bpmn.node.FlowNode;
	import org.workflow.view.events.GraphLoadEvent;
	
	public class FlowLink extends GraphLink
	{
		public function FlowLink()
		{
			super();
		}
		
		override protected function onGraphLoaded(event:GraphLoadEvent):void
		{
			var sequenceFlow:TSequenceFlow = this.model as TSequenceFlow;
			
			for each(var graph:GraphBase in graphContainer.getAllGraph()){
				
				if (graph is GraphNode && graph.model is TFlowNode ){
					if (sequenceFlow.sourceRef && sequenceFlow.sourceRef == graph.model){
						this.fromNode = graph as GraphNode;
					}
					if (sequenceFlow.targetRef && sequenceFlow.targetRef == graph.model){
						this.toNode = graph as GraphNode;
					}
				}
			}
				
		}
		
		override public function set toNode(value:GraphNode):void
		{
			if (this.toNode == value){
				return;
			}
			
			if ((value &&  value is FlowNode) || (value == null)){
				super.toNode = value;
			}
		}
		
		override public function set fromNode(value:GraphNode):void
		{
			if (this.fromNode == value){
				return;
			}
			
			if ((value &&  value is FlowNode) || (value == null)){
				super.fromNode = value;
			}
		}
	}
}