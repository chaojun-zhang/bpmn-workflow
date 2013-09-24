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
 */
package org.workflow.view.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.graphics.ImageSnapshot;
	
	import org.workflow.view.components.prototype.GraphLinkPrototype;
	import org.workflow.view.components.prototype.GraphNodePrototype;
	import org.workflow.view.components.prototype.GraphPrototype;
	import org.workflow.view.constants.GraphCommandMode;
	import org.workflow.view.constants.GraphHitTest;
	import org.workflow.view.events.GraphMouseEvent;
	import org.workflow.view.skins.GraphContainerSkin;
	import org.workflow.view.utils.CollectionUtils;
	import org.workflow.view.utils.RectangleUtils;
	
	import spark.components.SkinnableContainer;
	import spark.primitives.Rect;
	
	
	[Event(name="graphDblClick", type="org.workflow.view.events.GraphMouseEvent")]
	[Event(name="graphUpdated", type="org.workflow.view.events.GraphUpdatedEvent")]
	
	
	
	public class GraphContainer extends SkinnableContainer
	{
		public var selectedGraphs:ArrayList;
		
		private var draggingGraphs:ArrayList;
		
		private var graphAtCursor:GraphBase;

		[SkinPart(required="false")]
		public var dragMarker:Rect;
		
		private var _draggingMarketArea:Rectangle;
		
		private var _prototype:GraphPrototype;
		
		private var dragSourcePt: Point;
		private var dragTargetPt: Point;
		
		private var isPan:Boolean;
		
		public var dragHitTest:Number;
		public var dragSource:GraphBase;
		private var _graphCommandMode:Number ;
		
		public var focusGraph:GraphBase;
		
		public function GraphContainer()
		{
			super();
			this.doubleClickEnabled = true;
			this.setStyle("skinClass",GraphContainerSkin);
			selectedGraphs = new ArrayList();
			draggingGraphs  = new ArrayList();
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			this.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClick);
			
			this.addEventListener(FlexEvent.REMOVE,onRemove);
		}
		
		public function snapshot():void
		{
			var maxX :Number = Number.MIN_VALUE;
			var maxY :Number = Number.MIN_VALUE;
			this.forEachGraph(function (graph:GraphBase):void{
				if (graph.getGraphBounds().right >maxX){
					maxX = graph.getGraphBounds().right;
				}
				if (graph.getGraphBounds().bottom >maxY){
					maxY = graph.getGraphBounds().bottom;
				}
			});
			
			var point:Point = new Point(maxX,maxY);
			var matrix:Matrix = new Matrix();
			matrix.scale(this.width/maxX,this.height/maxY);
			var bitmapData:BitmapData = ImageSnapshot.captureBitmapData(this , matrix); 
			var bitMap:Bitmap = new Bitmap();
				
		}
		

		public function get graphCommandMode():Number
		{
			return _graphCommandMode;
		}

		public function set graphCommandMode(value:Number):void
		{
			if (_graphCommandMode == value){
				return;
			}
			_graphCommandMode = value;
			this.useHandCursor = _graphCommandMode == GraphCommandMode.PAN;
		}

		public function get prototype():GraphPrototype
		{
			return _prototype;
		}

		public function set prototype(value:GraphPrototype):void
		{
			_prototype = value;
		}

		private function get draggingMarketArea():Rectangle
		{
			return _draggingMarketArea;
		}

		private function set draggingMarketArea(value:Rectangle):void
		{
			
			_draggingMarketArea = value;
			if (!this.dragMarker ){
				this.dragMarker = new Rect();
			}
			if (_draggingMarketArea){
				this.dragMarker.visible = true;
				this.dragMarker.x = _draggingMarketArea.x;
				this.dragMarker.y = _draggingMarketArea.y;
				this.dragMarker.width = _draggingMarketArea.width;
				this.dragMarker.height = _draggingMarketArea.height;
			}else{
				this.dragMarker.visible = false;
			}
		}
		
		private function doubleClick(event:MouseEvent):void
		{
			var localPt:Point = new Point(event.localX,event.localY);
			this.graphAtCursor = this.findTopGraphAt(localPt);
			if (this.graphAtCursor){
				var graphMouseEvent:GraphMouseEvent  = new GraphMouseEvent(GraphMouseEvent.DOUBLE_CLICK);
				graphMouseEvent.graph = this.graphAtCursor;
				graphMouseEvent.mouseEvent = event.clone() as MouseEvent;
				this.dispatchEvent(graphMouseEvent);
			}
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			if (this.graphCommandMode == GraphCommandMode.VIEW){
				return;
			}
			var localPt:Point = new Point(event.localX,event.localY);
			
//			if (event.ctrlKey){
//				this.graphCommandMode = GraphCommandMode.PAN;
//			}
			switch (this.graphCommandMode){
				case GraphCommandMode.INSERT_LINK:
				case GraphCommandMode.INSERT_NODE:
					var graphBase:GraphBase = this.createGraphAt(localPt);
					if (graphBase){
						graphBase.onGraphMouseDown(event);
					}
					break;
				case GraphCommandMode.PAN:
					this.dragSourcePt = localPt;
					this.dragTargetPt = localPt;
					this.isPan = true;
					break;
				default :
					this.graphAtCursor = this.findTopGraphAt(localPt);
					if (this.graphAtCursor!=null)
					{
						this.graphAtCursor.onGraphMouseDown(event);
					}else{
						this.dragSourcePt = localPt;
						this.dragTargetPt = localPt;
						this.draggingMarketArea = RectangleUtils.makeRectWith2Pt(this.dragTargetPt,this.dragSourcePt);
					}
					break;
			}
		}
		
		public function beginDragGraph(graphBase:GraphBase,localPt:Point,ht:Number):void
		{
			this.dragSource = graphBase;
			this.dragHitTest = ht;
			this.dragSourcePt = localPt;
			this.dragTargetPt = localPt;
			
			for each (var graph:GraphBase in this.selectedGraphs.source)
			{
				if (graph.id != dragSource.id ){
					graph.beginFollowDrag();
				}
			}
		}
		
		public function endDragGraph(graphBase:GraphBase):void
		{
			//remember to release dragSource
			this.dragSource = null;
			
			for (var i:int= this.draggingGraphs.length-1; i>=0 ;i--)
			{
				var graph:GraphBase = this.draggingGraphs.getItemAt(i) as GraphBase;
				if (graph.id != graphBase.id ){
					graph.endFollowDrag();
				}
			}
			this.draggingGraphs.removeAll();
			
			if (this.graphCommandMode == GraphCommandMode.INSERT_LINK || this.graphCommandMode == GraphCommandMode.INSERT_NODE){
				this.graphCommandMode = GraphCommandMode.EDIT;
			}
		}
		
		private function createGraphAt(localPt:Point):GraphBase
		{
			if (!prototype){
				if (this.graphCommandMode == GraphCommandMode.INSERT_NODE){
					prototype = new GraphNodePrototype();
				}else {
					prototype = new GraphLinkPrototype();
				}
			}
			return prototype.createGraph(localPt,this);
		}
		
		
		private function removeAllSelectedGraphs():void
		{
			this.selectedGraphs.removeAll();
		}
		
		
		private function panContainer(event:MouseEvent):void
		{
			var offsetX :Number = event.localX - this.dragTargetPt.x;
			var offsetY:Number = event.localY - this.dragTargetPt.y;
			this.x += offsetX;
			this.y += offsetY;
			this.dragTargetPt.x += offsetX;
			this.dragTargetPt.y += offsetY;
			this.width -= offsetX;
			this.height -= offsetY;
			if (this.x >0){
				this.width += x;
				this.x = 0;
			}
			if (this.y>0){
				this.height += y;
				this.y = 0;
			}
			trace("x=" + this.x + ",y=" + this.y + ",width=" + this.width + ",height=" + this.height);
		}
		
		private function mouseMove(event:MouseEvent):void
		{
			if (this.graphCommandMode == GraphCommandMode.VIEW){
				return;
			}
			
			if (graphCommandMode == GraphCommandMode.PAN && this.isPan ){
				panContainer(event);
			}else{
				if (this.draggingMarketArea){
					this.dragTargetPt = new Point(event.localX,event.localY);
					this.draggingMarketArea = RectangleUtils.makeRectWith2Pt(this.dragTargetPt,this.dragSourcePt);
				}else{
					if (dragSource){
						dragSource.onGraphMouseMove(event);
					}
				}
			}
		}
		private function mouseUp(event:MouseEvent):void
		{
			if (this.graphCommandMode == GraphCommandMode.VIEW){
				return;
			}
			if (this.graphCommandMode == GraphCommandMode.PAN){
				this.isPan = false;
			}else{
				if (this.draggingMarketArea){
					if (event.shiftKey){
						toggleGraphSelection(true);
					}else{
						toggleGraphSelection(false);
					}
					this.draggingMarketArea = null;
				}else{
					if (this.dragSource)
					{
						this.dragSource.onGraphMouseUp(event);
					}
				}
			}
			this.graphCommandMode = GraphCommandMode.EDIT;
		}
		
		public function forEachGraph(fun:Function):void
		{
			for (var i:int = numElements -1; i >= 0; i--){
				var element:Object = this.getElementAt(i);			
				if (element && element is GraphBase){
					fun.apply(this,[element]);
				}
			}
		}
		
		private function toggleGraphSelection(keepOld:Boolean):void{
			
			forEachGraph(function (graph:GraphBase):void{
				if (graph.containsMarkerRect(this.draggingMarketArea) ){
					if (!graph.selected ){
						graph.selected = true;
					}
				}else{
					graph.selected = false;
				}
			});
		}
		
		public function findTopGraphAt(localPt:Point):GraphBase{
			
			//find from top to bottom
			for (var i:int = numElements-1; i >= 0; i--){
				var element:Object = this.getElementAt(i);			
				if (element is GraphBase){
					var graph:GraphBase = element as GraphBase;	
					if (graph.queryHitTest(localPt) != GraphHitTest.HT_NOWHERE){
						return graph;
					}
				}
			}
			return null;
		}
		
		public function findTopGraphNodeAt(localPt:Point,graphParent:GraphBase= null):GraphNode{
			
			//find from top to bottom
			for (var i:int = numElements -1; i >= 0; i--){
				var element:Object = this.getElementAt(i);			
				if (element is GraphNode){
					var graph:GraphNode = element as GraphNode;	
					if (graphParent && graph.graphParent == graphParent && graph.queryHitTest(localPt) != GraphHitTest.HT_NOWHERE){
						return graph;
					}else{
						if (graph.queryHitTest(localPt) != GraphHitTest.HT_NOWHERE){
							return graph;
						}
					}
					
				}
			}
			return null;
		}
		
		public function findTopGraphLinkAt(localPt:Point):GraphLink{
			
			//find from top to bottom
			for (var i:int = numElements -1; i >= 0; i--){
				var element:Object = this.getElementAt(i);			
				if (element is GraphLink){
					var graph:GraphLink = element as GraphLink;	
					if (graph.queryHitTest(localPt) != GraphHitTest.HT_NOWHERE){
						return graph;
					}
				}
			}
			return null;
		}
		
		public function removeAllGraph():void{
			forEachGraph(function (graph:GraphBase):void{
				if (graph is GraphNode){
					this.removeElement(graph);
				}
			});
			this.selectedGraphs.removeAll();
			this.draggingGraphs.removeAll();
			this.dragSource = null;
			this.draggingMarketArea = null;
		}
		
		public function removeAllSelected():void{
			
			for (var i:int = selectedGraphs.length-1; i>=0 ; i--){
				var graph:GraphBase = selectedGraphs.getItemAt(i) as GraphBase;
				graph.selected = false;
			}
		}
		
		public function performDragBy(localPt:Point):void
		{
			var dx:Number = localPt.x - this.dragTargetPt.x;
			var dy:Number = localPt.y - this.dragTargetPt.y;
			if (this.dragSource!= null && (dx!=0 || dy!= 0 )){
				for each( var graph:GraphBase in this.draggingGraphs.source)
				{
					graph.offSetByHitTest(dx,dy,this.dragHitTest);
				}
				this.dragTargetPt.x +=  dx;
				this.dragTargetPt.y += dy;
			}
		}
		
		
		public function addSelectedGraph(graph:GraphBase):void
		{
				this.selectedGraphs.addItem(graph);
		}
		
		public function removeSelectedGraph(graph:GraphBase):void
		{
				this.selectedGraphs.removeItem(graph);
		}
		
		public function addDraggingGraph(graph:GraphBase):void
		{
				this.draggingGraphs.addItem(graph);
		}
		
		public function removeDraggingGraph(graph:GraphBase):void
		{
				this.draggingGraphs.removeItem(graph);
		}
		
		public function getFirstChild(graphParent:GraphBase=null):GraphBase
		{
			for (var i:int = 0 ; i<numElements; i++){
				var obj:Object = this.getElementAt(i); 
				if (obj is GraphBase )
				{
					if (GraphBase(obj).graphParent == graphParent){
						return obj as GraphBase;
					}
				}
			}
			return null;
		}
		
		public function getLastChild(graphParent:GraphBase=null):GraphBase
		{
			for (var i:int = numElements-1 ; i>=0; i--){
				var obj:Object = this.getElementAt(i); 
				if (obj is GraphBase )
				{
					if (GraphBase(obj).graphParent == graphParent){
						return obj as GraphBase;
					}
				}
			}
			return null;
		}
		
		
		public function bringToFront():void
		{
			CollectionUtils.forEach(this,selectedGraphs,function (graph:GraphBase):void{
				graph.bringToFront();
			},true);
		}
		
		public function sendToBack():void
		{
			CollectionUtils.forEach(this,selectedGraphs,function (graph:GraphBase):void{
				graph.sendToBack();
			},true);
		}
		
		public function deleteSelected():void
		{
			CollectionUtils.forEach(this,selectedGraphs,function (graph:GraphBase):void{
				this.removeElement(graph);
			},true);
			this.selectedGraphs.removeAll();
		}
		
		public function getAllGraph():Array{
			var result:Array = [];
			for (var i:int = 0 ; i<numElements; i++){
				var obj:Object = this.getElementAt(i); 
				if (obj is GraphBase )
				{
					result.push(obj);
				}
			}
			return result;
		}
		
		private function onRemove(event:FlexEvent):void{
			
			this.selectedGraphs.removeAll();
			this.draggingGraphs.removeAll();
			this.dragSource = null;
			this.focusGraph = null;
			this._draggingMarketArea = null;
			this._prototype = null;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,doubleClick);
			
			this.removeEventListener(FlexEvent.REMOVE,onRemove);
		}
		
	}
}