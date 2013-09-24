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
package org.workflow.service
{
	import com.ericfeminella.collections.IMap;
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.workflow.model.bpmn2.BPMNEdge;
	import org.workflow.model.bpmn2.BPMNShape;
	import org.workflow.model.bpmn2.DiagramElement;
	import org.workflow.model.bpmn2.Point;
	import org.workflow.model.bpmn2.TBaseElement;
	import org.workflow.model.bpmn2.TDefinitions;
	import org.workflow.model.bpmn2.TFlowElement;
	import org.workflow.model.bpmn2.TLane;
	import org.workflow.model.bpmn2.TLaneSet;
	import org.workflow.model.bpmn2.TProcess;
	import org.workflow.model.bpmn2.TSequenceFlow;
	import org.workflow.model.bpmn2.TSubProcess;
	import org.workflow.utils.BPMNUtil;
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.components.GraphContainer;
	import org.workflow.view.components.GraphLink;
	import org.workflow.view.components.GraphNode;
	import org.workflow.view.components.prototype.GraphLinkPrototype;
	import org.workflow.view.components.prototype.GraphNodePrototype;
	import org.workflow.view.components.prototype.GraphPrototype;
	import org.workflow.view.constants.GraphState;
	import org.workflow.view.events.GraphLoadEvent;
	import org.workflow.xml.annotation.XmlCDATA;
	import org.workflow.xml.annotation.XmlText;
	import org.workflow.xml.serializer.XmlArraySerializer;
	import org.workflow.xml.serializer.XmlCDATASerializer;
	import org.workflow.xml.serializer.XmlTextSerializer;
	
	public class WorkflowServiceImpl implements IWorkflowService
	{		
		private static var flexXbEngine:FlexXBEngine = FlexXBEngine.instance;
		
		private var prototypeDict:IMap;
		
		private var graphContainer:GraphContainer;
		
		public function WorkflowServiceImpl(prototypeDict:IMap,graphContainer:GraphContainer)
		{
			this.prototypeDict = prototypeDict;
			this.graphContainer = graphContainer;
			flexXbEngine.registerAnnotation(XmlArray.ANNOTATION_NAME,XmlArray,XmlArraySerializer,true);
			flexXbEngine.registerAnnotation(XmlCDATA.ANNOTATION_NAME,XmlCDATA,XmlCDATASerializer,false);
			flexXbEngine.registerAnnotation(XmlText.ANNOTATION_NAME,XmlText,XmlTextSerializer,false);
			flexXbEngine.configuration.enableLogging = true;
		}
		
		public function loadFromXML(xml:XML):TDefinitions
		{
			var definition:TDefinitions = flexXbEngine.deserialize(xml,TDefinitions) as TDefinitions;
			var process:TProcess = BPMNUtil.getProcessFromDefinition(definition);
			if (process){
				if (process.flowElement){
					for each (var flowElement:TBaseElement in process.flowElement.source){
						loadGraph(flowElement,definition);
					}
				}
				
				if (process.laneSet){
					for each (var laneSet:TLaneSet in process.laneSet.source){
						if (laneSet.lane){
							for each(var lane:TLane in laneSet.lane.source){
								loadGraph(lane,definition);
							}
						}
					}
				}
			}
			var allGraphs:Array = graphContainer.getAllGraph();
			for each (var graph:GraphBase in allGraphs){
				graph.state = GraphState.LOADED;
				graph.dispatchEvent(new GraphLoadEvent(GraphLoadEvent.LOADED));
			}
			
			return definition;
		}

		private function loadGraphNode(bpmnShape:BPMNShape,graphParent:GraphBase):GraphNode
		{
			var graphPrototype:GraphNodePrototype = findPrototype(bpmnShape.bpmnElement) as GraphNodePrototype;
			
			var GraphNodeClass:Class = graphPrototype.graphClass;
			
			var graphNode:GraphNode = new GraphNodeClass() as GraphNode;
			graphNode.state = GraphState.LOADING;
			
			if (bpmnShape.bpmnElement is TLane){
				graphNode.caption = (bpmnShape.bpmnElement as TLane).name;
			}else if (bpmnShape.bpmnElement is TFlowElement){
				graphNode.caption = (bpmnShape.bpmnElement as TFlowElement).name;
			}
			
			graphNode.id = bpmnShape.id;
			graphNode.x = bpmnShape.bounds.x;
			graphNode.y = bpmnShape.bounds.y;
			graphNode.width = bpmnShape.bounds.width;
			graphNode.height = bpmnShape.bounds.height;
			if (graphNode.width == 0 ){
				graphNode.width = graphPrototype.width;
			}
			if (graphNode.height == 0){
				graphNode.height = graphPrototype.height;
			}
		
			graphNode.minHeight = graphPrototype.minHeight;
			graphNode.minWidth = graphPrototype.minWidth;
			graphNode.canMove = graphPrototype.canMove;
			graphNode.canResize = graphPrototype.canResize;
			graphNode.setStyle("skinClass",graphPrototype.skinClass);
			graphNode.imageUrl = graphPrototype.imageUrl;
			graphNode.model = bpmnShape.bpmnElement;
		
			graphNode.graphContainer = graphContainer;
			graphContainer.addElementAt(graphNode,0);
			graphNode.graphParent = graphParent;
			
			return graphNode;
		}
		
		private function loadGraph(flowElement:TBaseElement,definition:TDefinitions, parentFlowElement:TBaseElement=null, graphParent:GraphBase=null):void
		{
			var bpmnDiagramElement:DiagramElement = BPMNUtil.findBpmnDiagramByBaseElement(flowElement,definition);
			var graph:GraphBase ;
			if (bpmnDiagramElement is BPMNShape){
				graph = this.loadGraphNode(bpmnDiagramElement as BPMNShape,graphParent);
			}else if (bpmnDiagramElement is BPMNEdge){
				graph = this.loadGraphLink(bpmnDiagramElement as BPMNEdge,graphParent);
			}
			var childLane:TLane;
			if (flowElement is TSubProcess  ){
				if ((flowElement as TSubProcess).flowElement){
					for each(var subFlowElement:TBaseElement in (flowElement as TSubProcess).flowElement.source){
						loadGraph(subFlowElement,definition,flowElement,graph);
					}
				}
				
				if ((flowElement as TSubProcess).laneSet){
					for each(var laneSet:TLaneSet in (flowElement as TSubProcess).laneSet.source){
						for each( childLane in laneSet.lane.source){
							loadGraph(childLane,definition,flowElement,graph);
						}
					}
				}
			}else if (flowElement is TLane){
				var lane:TLane = flowElement as TLane;
				if (lane.childLaneSet && lane.childLaneSet.lane ){
					for each( childLane in lane.childLaneSet.lane.source){
						loadGraph(childLane,definition,flowElement,graph);
					}
				}
			}
		}
		
		/**
		 * create graph link base on the bpmnEdge
		 */ 
		private function loadGraphLink(bpmnEdge:BPMNEdge,graphParent:GraphBase):GraphLink
		{
			var graphPrototype:GraphLinkPrototype = findPrototype(bpmnEdge.bpmnElement) as GraphLinkPrototype;
			
			var element:TBaseElement =  bpmnEdge.bpmnElement;
			var GraphLinkClass:Class = graphPrototype.graphClass;
			
			var graphLink:GraphLink = new GraphLinkClass() as GraphLink;
			graphLink.state = GraphState.LOADING;
			graphLink.id = bpmnEdge.id;
			graphLink.caption = (bpmnEdge.bpmnElement as TSequenceFlow).name;
			
			graphLink.setStyle("skinClass",graphPrototype.skinClass);
			graphLink.canMove = graphPrototype.canMove;
			graphLink.canResize = graphPrototype.canResize;
			graphLink.lineStyle = graphPrototype.lineStyle;
			graphLink.points
			for each(var p:org.workflow.model.bpmn2.Point in bpmnEdge.waypoint.source)
			{
				graphLink.points.addItem(new flash.geom.Point(p.x,p.y));
			}
			graphLink.model = element;
		
			graphLink.graphContainer = graphContainer;
			graphContainer.addElement(graphLink);
			
			graphLink.graphParent = graphParent;
			return graphLink;
		}
		
		
		
		private function findPrototype(model:TBaseElement):GraphPrototype
		{
			var modelClass:Class = getDefinitionByName(getQualifiedClassName(model)) as Class;
			return prototypeDict.getValue(modelClass);
		}
	}
}