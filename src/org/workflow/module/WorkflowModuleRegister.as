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

	public class WorkflowModuleRegister
	{
		private static var  _instance:WorkflowModuleRegister = new WorkflowModuleRegister();
		private var _workflowModules:Array = [];
		
		public function WorkflowModuleRegister()
		{
			var workflowModule:IWorkflowModule = new SemanticModule();
			workflowModule.registerWorkflowModelClassAlias();
			_workflowModules.push(workflowModule);
			
			workflowModule = new BPMNDIModule();
			workflowModule.registerWorkflowModelClassAlias();
			_workflowModules.push(workflowModule);
			
			workflowModule = new DCModule();
			workflowModule.registerWorkflowModelClassAlias();
			_workflowModules.push(workflowModule);
			
			workflowModule = new DIModule();
			workflowModule.registerWorkflowModelClassAlias();
			_workflowModules.push(workflowModule);
			
			workflowModule = new DroolsModule();
			workflowModule.registerWorkflowModelClassAlias();
			_workflowModules.push(workflowModule);
		}
		
		
		[ArrayElementType("org.workflow.module.IWorkflowModule")]
		public function get workflowModules():Array
		{
			return _workflowModules;
		}

		public static function getInstance():WorkflowModuleRegister
		{
			return _instance;
		}
		
	}
}