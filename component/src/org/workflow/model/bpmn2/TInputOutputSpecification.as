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

	import org.workflow.model.bpmn2.TBaseElement;
    
	[Bindable]

	[XmlClass(alias="inputOutputSpecification",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	[Namespace(prefix="tns",uri="http://www.jboss.org/drools")]
	
	public class TInputOutputSpecification extends TBaseElement {

		// Fields

		
		[ArrayElementType("org.workflow.model.bpmn2.TDataInput")]
		[XmlArray(type="org.workflow.model.bpmn2.TDataInput")]
		public var dataInput:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TDataOutput")]
		[XmlArray(type="org.workflow.model.bpmn2.TDataInput")]
		public var dataOutput:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TInputSet")]
		[XmlArray(type="org.workflow.model.bpmn2.TInputSet")]
		public var inputSet:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TOutputSet")]
		[XmlArray(type="org.workflow.model.bpmn2.TOutputSet")]
		public var outputSet:ArrayCollection;

		
	
	}

}
