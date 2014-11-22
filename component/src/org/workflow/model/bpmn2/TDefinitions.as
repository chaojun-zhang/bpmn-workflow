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
    
	[Bindable]

	[XmlClass(alias="definitions",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	[Namespace(uri="http://www.omg.org/spec/BPMN/20100524/MODEL")]
	[Namespace(prefix="tns",uri="http://www.jboss.org/drools")]
	[Namespace(prefix="bpmndi",uri="http://www.omg.org/spec/BPMN/20100524/DI")]
	
	public class TDefinitions  {

		// Fields

		
		[ArrayElementType("org.workflow.model.bpmn2.TImport")]
		[XmlArray(memberName="import",type="org.workflow.model.bpmn2.TImport")]
		public var _import:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TExtension")]
		[XmlArray(memberName="extension",type="org.workflow.model.bpmn2.TExtension")]
		public var extension:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TRootElement")]
		[XmlArray(getRuntimeType="true",order="3",type="org.workflow.model.bpmn2.TRootElement")]
		public var rootElement:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.BPMNDiagram")]
		[XmlArray(memberNamespace="bpmndi",order="4",memberName="BPMNDiagram",type="org.workflow.model.bpmn2.BPMNDiagram")]
		public var bpmnDiagram:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TRelationship")]
		[XmlArray(memberName="relationship",type="org.workflow.model.bpmn2.TRelationship")]
		public var relationship:ArrayCollection;
		
		
		[XmlAttribute(alias="id")]
		public var id:String;
		
		
		[XmlAttribute(alias="name")]
		public var name:String;
		
		
		[XmlAttribute(alias="targetNamespace")]
		public var targetNamespace:String;
		
		
		[XmlAttribute(alias="expressionLanguage")]
		public var expressionLanguage:String;
		
		
		[XmlAttribute(alias="typeLanguage")]
		public var typeLanguage:String;
		
		
		[XmlAttribute(alias="exporter")]
		public var exporter:String;
		
		
		[XmlAttribute(alias="exporterVersion")]
		public var exporterVersion:String;
		
		
//		[XmlAttribute]
		public var otherAttributes:Object;

		
	
	}

}
