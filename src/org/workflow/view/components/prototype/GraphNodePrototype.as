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
	
	import org.workflow.view.components.GraphBase;
	import org.workflow.view.components.GraphContainer;
	import org.workflow.view.components.GraphNode;
	import org.workflow.view.constants.GraphConstants;
	import org.workflow.view.skins.ActivityNodeSkin;

	public class GraphNodePrototype extends GraphPrototype
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public var minWidth:Number;
		public var minHeight:Number;
		public var imageUrl:String;
		
		public function GraphNodePrototype()
		{
			super();
			this.skinClass = ActivityNodeSkin;
			this.width = GraphConstants.GRAPH_MIN_WIDTH;
			this.height = GraphConstants.GRAPH_MIN_HEIGHT;
			this.minHeight = GraphConstants.GRAPH_MIN_HEIGHT;
			this.minWidth = GraphConstants.GRAPH_MIN_WIDTH;
			this.modelClass = Object;
			this.graphClass = GraphNode;
		}
		
		override protected function doCreateGraph(localPt:Point,graphContainer:GraphContainer,graphNodeAtCursor:GraphNode):GraphBase
		{
			var graph:GraphNode = super.doCreateGraph(localPt,graphContainer,graphNodeAtCursor) as GraphNode;
			graph.x = localPt.x;
			graph.y = localPt.y;
			graph.width = this.width;
			graph.height = this.height;
			graph.minHeight = this.minHeight;
			graph.imageUrl = this.imageUrl;
			return graph;
		}
		
	}
}