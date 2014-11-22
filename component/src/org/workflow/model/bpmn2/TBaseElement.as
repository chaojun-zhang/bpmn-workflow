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
	
	import org.workflow.model.bpmn2.TExtensionElements;
    
	[Bindable]

	[XmlClass(alias="baseElement",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	
	public class TBaseElement  {

		// Fields
		
		[ArrayElementType("org.workflow.model.bpmn2.TDocumentation")]
		[XmlArray(memberName="documentation",type="org.workflow.model.bpmn2.TDocumentation")]
		public var documentation:ArrayCollection;
		
		
//		[XmlElement(order="2")]
		public var extensionElements:TExtensionElements;
		
		
		[XmlAttribute(alias="id")]
		public var id:String;
		
		
//		[XmlAttribute]
		public var otherAttributes:Object;

		
	
	}

}
