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
 */package org.workflow.model.bpmn2 {

	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	
	import org.workflow.model.bpmn2.TExpression;
	import org.workflow.model.bpmn2.TFlowElement;
    
	[Bindable]

	[XmlClass(alias="sequenceFlow",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	[Namespace(prefix="tns",uri="http://www.jboss.org/drools")]
	
	public class TSequenceFlow extends TFlowElement {

		// Fields
		
		[XmlElement(order="1")]
		public var conditionExpression:TExpression;
		
		
		[XmlAttribute(alias="sourceRef",idref="true")]
		public var sourceRef:TFlowNode;
		
		
		[XmlAttribute(alias="targetRef",idref="true")]
		public var targetRef:TFlowNode;
		
		
		[XmlAttribute(alias="isImmediate")]
		public var isImmediate:Boolean;
		
		[XmlAttribute(namespace="tns")]
		public var priority:String = "1";

		
	
	}

}
