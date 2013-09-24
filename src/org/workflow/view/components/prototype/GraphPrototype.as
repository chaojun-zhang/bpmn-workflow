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
 */package org.workflow.view.components.prototype
{
	import flash.geom.Point;
	
	import mx.utils.UIDUtil;
	
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.components.GraphContainer;
	import org.workflow.view.components.GraphNode;

	public class GraphPrototype
	{
		public var label:String;
		public var elementIconUrl:String;
		
		public var skinClass:Class;
		
		public var modelClass:Class;
		public var graphClass:Class;
		
		public var canMove:Boolean = true;
		
		public var canResize:Boolean = true;
		
		public var canCreateIndepent:Boolean = true;
		
		public function GraphPrototype()
		{
		}
		
		public function createGraph(localPt:Point,graphContainer:GraphContainer):GraphBase
		{
			var graph:GraphBase ;
			var graphNodeAtCursor:GraphNode = graphContainer.findTopGraphNodeAt(localPt);
			if (graphNodeAtCursor){
				graph = doCreateGraph(localPt,graphContainer,graphNodeAtCursor);
				if (  graphNodeAtCursor.canCreateGraphUnderPoint(localPt,graph)){
					if ( graphNodeAtCursor.canAddChild(graph)){
						graph.graphParent = graphNodeAtCursor;
					}
				}else{
					graphContainer.removeElement(graph);
					graph = null;
				}
			}else{
				if (canCreateIndepent){
					graph = doCreateGraph(localPt,graphContainer,graphNodeAtCursor);
				}
			}
		
			return graph;
		}
		
		protected function doCreateGraph(localPt:Point,graphContainer:GraphContainer,graphNodeAtCursor:GraphNode):GraphBase
		{
			var GraphClass:Class = this.graphClass;
			var graph:GraphBase   = new GraphClass() as GraphBase;
			graph.graphContainer = graphContainer;
			graph.id = UIDUtil.createUID();
			graph.canMove = graph.canMove;
			graph.canResize = this.canResize;
			graph.setStyle("skinClass",this.skinClass);
			graph.caption = this.label;
			var ModelClass:Class = this.modelClass;
			if (ModelClass){
				graph.model =  new ModelClass();
			}
			
			if (this is GraphNodePrototype){
				graphContainer.addElement(graph);
			}else{
				graphContainer.addElement(graph);
			}
			
			
			return graph;
		}
		
	}
}