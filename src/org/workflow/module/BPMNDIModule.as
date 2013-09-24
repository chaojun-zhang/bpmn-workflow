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
	import org.workflow.model.bpmn2.BPMNDiagram;
	import org.workflow.model.bpmn2.BPMNEdge;
	import org.workflow.model.bpmn2.BPMNLabel;
	import org.workflow.model.bpmn2.BPMNLabelStyle;
	import org.workflow.model.bpmn2.BPMNPlane;
	import org.workflow.model.bpmn2.BPMNShape;

	public class BPMNDIModule extends BaseWorkflowModule
	{
		
		public function BPMNDIModule()
		{
			dictionary["BPMNDiagram"] = BPMNDiagram;
			dictionary["BPMNEdge"] = BPMNEdge;
			dictionary["BPMNLabel"] = BPMNLabel;
			dictionary["BPMNLabelStyle"] = BPMNLabelStyle;
			dictionary["BPMNPlane"] = BPMNPlane;
			dictionary["BPMNShape"] = BPMNShape;
		}
		
		override public function getNamespace():String
		{
			return "http://www.omg.org/spec/BPMN/20100524/DI";
		}
		
	}
}