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

	import org.workflow.model.bpmn2.TRootElement;
    
	[Bindable]

	[XmlClass(alias="collaboration",uri="http://www.omg.org/spec/BPMN/20100524/MODEL",idField="id",ordered="true")]
	[Namespace(uri="http://www.omg.org/spec/BPMN/20100524/MODEL")]
	[Namespace(prefix="tns",uri="http://www.jboss.org/drools")]
	
	public class TCollaboration extends TRootElement {

		// Fields

		
		[ArrayElementType("org.workflow.model.bpmn2.TParticipant")]
		[XmlArray(memberName="participant",type="org.workflow.model.bpmn2.TParticipant")]
		public var participant:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TMessageFlow")]
		[XmlArray(memberName="messageFlow",type="org.workflow.model.bpmn2.TMessageFlow")]
		public var messageFlow:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TArtifact")]
		[XmlArray(memberName="artifact",type="org.workflow.model.bpmn2.TArtifact")]
		public var artifact:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TConversationNode")]
		[XmlArray(memberName="conversationNode",type="org.workflow.model.bpmn2.TConversationNode")]
		public var conversationNode:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TConversationAssociation")]
		[XmlArray(memberName="conversationAssociation",type="org.workflow.model.bpmn2.TConversationAssociation")]
		public var conversationAssociation:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TParticipantAssociation")]
		[XmlArray(memberName="participantAssociation",type="org.workflow.model.bpmn2.TParticipantAssociation")]
		public var participantAssociation:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TMessageFlowAssociation")]
		[XmlArray(memberName="messageFlowAssociation",type="org.workflow.model.bpmn2.TMessageFlowAssociation")]
		public var messageFlowAssociation:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TCorrelationKey")]
		[XmlArray(memberName="correlationKey",type="org.workflow.model.bpmn2.TCorrelationKey")]
		public var correlationKey:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TChoreography")]
		[XmlArray(idref="true")]
		public var choreographyRef:ArrayCollection;
		
		[ArrayElementType("org.workflow.model.bpmn2.TConversationLink")]
		[XmlArray(memberName="conversationLink",type="org.workflow.model.bpmn2.TConversationLink")]
		public var conversationLink:ArrayCollection;
		
		
		[XmlAttribute(alias="name")]
		public var name:String;
		
		
		[XmlAttribute(alias="isClosed")]
		public var isClosed:Boolean;

		
	
	}

}
