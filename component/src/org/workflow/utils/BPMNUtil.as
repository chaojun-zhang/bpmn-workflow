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
package org.workflow.utils
{
	import mx.collections.ArrayCollection;
	
	import org.workflow.model.bpmn2.BPMNDiagram;
	import org.workflow.model.bpmn2.BPMNEdge;
	import org.workflow.model.bpmn2.BPMNShape;
	import org.workflow.model.bpmn2.DiagramElement;
	import org.workflow.model.bpmn2.TBaseElement;
	import org.workflow.model.bpmn2.TDefinitions;
	import org.workflow.model.bpmn2.TProcess;
	import org.workflow.model.bpmn2.TRootElement;

	public class BPMNUtil
	{
		
		public static function getProcessFromDefinition(definition:TDefinitions):TProcess
		{
			for each(var rootelement:TRootElement in definition.rootElement.source)
			{
				if (rootelement is TProcess)
				{
					return rootelement as TProcess;
				}
			}
			return null;
		}
		
		public static  function getBpmnDiagram(definition:TDefinitions):BPMNDiagram
		{
			var bpmnDiagrams:ArrayCollection = definition.bpmnDiagram;
			var bpmnDiagram:BPMNDiagram = bpmnDiagrams.getItemAt(0) as BPMNDiagram;
			return bpmnDiagram;
		}
		
		public static  function findBpmnDiagramById(diagrameElementId:String,definition:TDefinitions):DiagramElement
		{
			var diagram:BPMNDiagram = BPMNUtil.getBpmnDiagram(definition);
			
			for each(var diagramElement:DiagramElement in diagram.bpmnPlane.diagramElement.source){
				
				if (diagramElement.id == diagrameElementId){
					return diagramElement;
				}
			}
			return null;
		}
		
		public static  function findBpmnDiagramByBaseElement(baseElement:TBaseElement,definition:TDefinitions):DiagramElement
		{
			var diagram:BPMNDiagram = BPMNUtil.getBpmnDiagram(definition);
			
			for each(var diagramElement:DiagramElement in diagram.bpmnPlane.diagramElement.source){
				if (diagramElement is BPMNShape && (diagramElement as BPMNShape).bpmnElement.id == baseElement.id){
					return diagramElement;
				}else if (diagramElement is BPMNEdge && (diagramElement as BPMNEdge).bpmnElement.id == baseElement.id){
					return diagramElement;
				}
			}
			return null;
		}

		
	}
	
}