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
 */package org.workflow.module
{
	import org.workflow.model.bpmn2.Diagram;
	import org.workflow.model.bpmn2.DiagramElement;
	import org.workflow.model.bpmn2.Edge;
	import org.workflow.model.bpmn2.Font;
	import org.workflow.model.bpmn2.Label;
	import org.workflow.model.bpmn2.LabeledEdge;
	import org.workflow.model.bpmn2.LabeledShape;
	import org.workflow.model.bpmn2.Node;
	import org.workflow.model.bpmn2.Plane;
	import org.workflow.model.bpmn2.Shape;
	import org.workflow.model.bpmn2.Style;

	public class DIModule extends BaseWorkflowModule
	{
		
		
		public function DIModule()
		{
			dictionary["Diagram"] = Diagram;
			dictionary["DiagramElement"] = DiagramElement;
			dictionary["Edge"] = Edge;
			dictionary["Font"] = Font;
			dictionary["Label"] = Label;
			dictionary["LabeledEdge"] = LabeledEdge;
			dictionary["LabeledShape"] = LabeledShape;
			dictionary["Node"] = Node;
			dictionary["Plane"] = Plane;
			dictionary["Shape"] = Shape;
			dictionary["Style"] = Style;
		}
		
		override public function getNamespace():String
		{
			return "http://www.omg.org/spec/DD/20100524/DI";
		}
		
		
		
	}
}