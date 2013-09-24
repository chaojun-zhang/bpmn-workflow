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
	import org.workflow.model.bpmn2.*;
	
	public class SemanticModule extends BaseWorkflowModule
	{
		
		public function SemanticModule()
		{
			dictionary["activity"] = TActivity;
			dictionary["adHocSubProcess"] = TAdHocSubProcess;
			dictionary["artifact"] = TArtifact;
			dictionary["assignment"] = TAssignment;
			dictionary["association"] = TAssociation;
			dictionary["auditing"] = TAuditing;
			dictionary["baseElement"] = TBaseElement;
			dictionary["baseElementWithMixedContent"] = TBaseElementWithMixedContent;
			dictionary["boundaryEvent"] = TBoundaryEvent;
			dictionary["businessRuleTask"] = TBusinessRuleTask;
			dictionary["callableElement"] = TCallableElement;
			dictionary["callActivity"] = TCallActivity;
			dictionary["callChoreography"] = TCallChoreography;
			dictionary["callConversation"] = TCallConversation;
			dictionary["cancelEventDefinition"] = TCancelEventDefinition;
			dictionary["catchEvent"] = TCatchEvent;
			dictionary["category"] = TCategory;
			dictionary["categoryValue"] = TCategoryValue;
			dictionary["choreography"] = TChoreography;
			dictionary["choreographyActivity"] = TChoreographyActivity;
			dictionary["choreographyTask"] = TChoreographyTask;
			dictionary["collaboration"] = TCollaboration;
			dictionary["compensateEventDefinition"] = TCompensateEventDefinition;
			dictionary["complexBehaviorDefinition"] = TComplexBehaviorDefinition;
			dictionary["complexGateway"] = TComplexGateway;
			dictionary["conditionalEventDefinition"] = TConditionalEventDefinition;
			dictionary["conversation"] = TConversation;
			dictionary["conversationAssociation"] = TConversationAssociation;
			dictionary["conversationLink"] = TConversationLink;
			dictionary["conversationNode"] = TConversationNode;
			dictionary["correlationKey"] = TCorrelationKey;
			dictionary["correlationProperty"] = TCorrelationProperty;
			dictionary["correlationPropertyBinding"] = TCorrelationPropertyBinding;
			dictionary["correlationPropertyRetrievalExpression"] = TCorrelationPropertyRetrievalExpression;
			dictionary["correlationSubscription"] = TCorrelationSubscription;
			dictionary["dataAssociation"] = TDataAssociation;
			dictionary["dataInput"] = TDataInput;
			dictionary["dataInputAssociation"] = TDataInputAssociation;
			dictionary["dataObject"] = TDataObject;
			dictionary["dataObjectReference"] = TDataObjectReference;
			dictionary["dataOutput"] = TDataOutput;
			dictionary["dataOutputAssociation"] = TDataOutputAssociation;
			dictionary["dataState"] = TDataState;
			dictionary["dataStore"] = TDataStore;
			dictionary["dataStoreReference"] = TDataStoreReference;
			dictionary["definitions"] = TDefinitions;
			dictionary["documentation"] = TDocumentation;
			dictionary["endEvent"] = TEndEvent;
			dictionary["endPoint"] = TEndPoint;
			dictionary["error"] = TError;
			dictionary["errorEventDefinition"] = TErrorEventDefinition;
			dictionary["escalation"] = TEscalation;
			dictionary["escalationEventDefinition"] = TEscalationEventDefinition;
			dictionary["event"] = TEvent;
			dictionary["eventBasedGateway"] = TEventBasedGateway;
			dictionary["eventDefinition"] = TEventDefinition;
			dictionary["exclusiveGateway"] = TExclusiveGateway;
			dictionary["expression"] = TExpression;
			dictionary["extension"] = TExtension;
			dictionary["extensionElements"] = TExtensionElements;
			dictionary["flowElement"] = TFlowElement;
			dictionary["flowNode"] = TFlowNode;
			dictionary["formalExpression"] = TFormalExpression;
			dictionary["gateway"] = TGateway;
			dictionary["globalBusinessRuleTask"] = TGlobalBusinessRuleTask;
			dictionary["globalChoreographyTask"] = TGlobalChoreographyTask;
			dictionary["globalConversation"] = TGlobalConversation;
			dictionary["globalManualTask"] = TGlobalManualTask;
			dictionary["globalScriptTask"] = TGlobalScriptTask;
			dictionary["globalTask"] = TGlobalTask;
			dictionary["globalUserTask"] = TGlobalUserTask;
			dictionary["group"] = TGroup;
			dictionary["humanPerformer"] = THumanPerformer;
			dictionary["implicitThrowEvent"] = TImplicitThrowEvent;
			dictionary["import"] = TImport;
			dictionary["inclusiveGateway"] = TInclusiveGateway;
			dictionary["inputOutputBinding"] = TInputOutputBinding;
			dictionary["inputOutputSpecification"] = TInputOutputSpecification;
			dictionary["inputSet"] = TInputSet;
			dictionary["interface"] = TInterface;
			dictionary["intermediateCatchEvent"] = TIntermediateCatchEvent;
			dictionary["intermediateThrowEvent"] = TIntermediateThrowEvent;
			dictionary["itemDefinition"] = TItemDefinition;
			dictionary["lane"] = TLane;
			dictionary["laneSet"] = TLaneSet;
			dictionary["linkEventDefinition"] = TLinkEventDefinition;
			dictionary["loopCharacteristics"] = TLoopCharacteristics;
			dictionary["manualTask"] = TManualTask;
			dictionary["message"] = TMessage;
			dictionary["messageEventDefinition"] = TMessageEventDefinition;
			dictionary["messageFlow"] = TMessageFlow;
			dictionary["messageFlowAssociation"] = TMessageFlowAssociation;
			dictionary["monitoring"] = TMonitoring;
			dictionary["multiInstanceLoopCharacteristics"] = TMultiInstanceLoopCharacteristics;
			dictionary["operation"] = TOperation;
			dictionary["outputSet"] = TOutputSet;
			dictionary["parallelGateway"] = TParallelGateway;
			dictionary["participant"] = TParticipant;
			dictionary["participantAssociation"] = TParticipantAssociation;
			dictionary["participantMultiplicity"] = TParticipantMultiplicity;
			dictionary["partnerEntity"] = TPartnerEntity;
			dictionary["partnerRole"] = TPartnerRole;
			dictionary["performer"] = TPerformer;
			dictionary["potentialOwner"] = TPotentialOwner;
			dictionary["process"] = TProcess;
			dictionary["property"] = TProperty;
			dictionary["receiveTask"] = TReceiveTask;
			dictionary["relationship"] = TRelationship;
			dictionary["rendering"] = TRendering;
			dictionary["resource"] = TResource;
			dictionary["resourceAssignmentExpression"] = TResourceAssignmentExpression;
			dictionary["resourceParameter"] = TResourceParameter;
			dictionary["resourceParameterBinding"] = TResourceParameterBinding;
			dictionary["resourceRole"] = TResourceRole;
			dictionary["rootElement"] = TRootElement;
			dictionary["script"] = TScript;
			dictionary["scriptTask"] = TScriptTask;
			dictionary["sendTask"] = TSendTask;
			dictionary["sequenceFlow"] = TSequenceFlow;
			dictionary["serviceTask"] = TServiceTask;
			dictionary["signal"] = TSignal;
			dictionary["signalEventDefinition"] = TSignalEventDefinition;
			dictionary["standardLoopCharacteristics"] = TStandardLoopCharacteristics;
			dictionary["startEvent"] = TStartEvent;
			dictionary["subChoreography"] = TSubChoreography;
			dictionary["subConversation"] = TSubConversation;
			dictionary["subProcess"] = TSubProcess;
			dictionary["task"] = TTask;
			dictionary["terminateEventDefinition"] = TTerminateEventDefinition;
			dictionary["text"] = TText;
			dictionary["textAnnotation"] = TTextAnnotation;
			dictionary["throwEvent"] = TThrowEvent;
			dictionary["timerEventDefinition"] = TTimerEventDefinition;
			dictionary["transaction"] = TTransaction;
			dictionary["userTask"] = TUserTask;
			
		}
		
		
		override public function getNamespace():String
		{
			return "http://www.omg.org/spec/BPMN/20100524/MODEL";
		}
	}
}