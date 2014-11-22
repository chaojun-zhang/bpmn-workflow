bpmn-workflow
=============
main.mxml

<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
			   xmlns:s="library://ns.adobe.com/flex/spark" 
			   xmlns:mx="library://ns.adobe.com/flex/mx" minWidth="955" minHeight="600" xmlns:designer="org.workflow.view.components.bpmn.designer.*">
	
	<fx:Script>
		<![CDATA[
			protected function button1_clickHandler(event:MouseEvent):void
			{
				// TODO Auto-generated method stub
				
				workflowViewer.workflowComponent.processXmlUrl = "process.xml";
			}
		]]>
	</fx:Script>
	
	<fx:Declarations>
		<!-- Place non-visual elements (e.g., services, value objects) here -->
	</fx:Declarations>
	<designer:WorkflowDesigner id="workflowViewer" width="100%" height="100%" />
	<s:Button click="button1_clickHandler(event)" label="load" />
</s:Application>
