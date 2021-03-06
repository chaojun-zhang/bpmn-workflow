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

	import mx.collections.ArrayCollection;

	import org.workflow.model.bpmn2.TEvent;
	import org.workflow.model.bpmn2.TInputSet;
    
	[Bindable]

	[XmlClass(alias="throwEvent",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	[Namespace(uri="http://www.omg.org/spec/BPMN/20100524/MODEL")]
	[Namespace(prefix="tns",uri="http://www.jboss.org/drools")]
	
	public class TThrowEvent extends TEvent {

		// Fields

		
		[ArrayElementType("org.workflow.model.bpmn2.TDataInput")]
		[XmlArray(memberName="dataInput",type="org.workflow.model.bpmn2.TDataInput")]
		public var dataInput:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TDataInputAssociation")]
		[XmlArray(memberName="dataInputAssociation",type="org.workflow.model.bpmn2.TDataInputAssociation")]
		public var dataInputAssociation:ArrayCollection;
		
		
		[XmlElement(order="3")]
		public var inputSet:TInputSet;
		
		[ArrayElementType("org.workflow.model.bpmn2.TEventDefinition")]
		[XmlArray(type="org.workflow.model.bpmn2.TEventDefinition",order="4",getRuntimeType="true")]
		public var eventDefinition:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TEventDefinition")]
		[XmlArray(idref="true",type="org.workflow.model.bpmn2.TEventDefinition")]
		public var eventDefinitionRef:ArrayCollection;

		
	
	}

}
