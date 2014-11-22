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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.workflow.view.constants.GraphHitTest;
	import org.workflow.view.constants.GraphState;
	import org.workflow.view.events.GraphLoadEvent;
	import org.workflow.view.utils.CollectionUtils;

	
	public class GraphBase extends  SkinnableComponent   
	{
	
		private var _selected:Boolean;
		
		private var _caption:String;
		
		private var _dragging:Boolean;
		
		public var graphContainer:GraphContainer;
		
		private var _graphParent:GraphBase;
		
		protected var _graphChilds:ArrayList;
		
		private var _model:Object;
		
		private var _canResize:Boolean = true;
		
		private var _canMove:Boolean = true;
		
		private var _state:int;
		
		[SkinPart(required="false")]
		public var labelDisplay:Label;
		
		public function GraphBase()
		{
			super();
			this.state = GraphState.CREATE;
			mouseChildren = false;
			mouseEnabled = false;
			_graphChilds = new ArrayList();
			
			this.addEventListener(FlexEvent.REMOVE,onGraphRemove);
			this.addEventListener(ResizeEvent.RESIZE,onGraphMoveResize);
			this.addEventListener(MoveEvent.MOVE,onGraphMoveResize);
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onGraphMoveResize);
			
			this.addEventListener(GraphLoadEvent.LOADED,onGraphLoaded);
		}
		
		

		[ArrayElementType("org.workflow.view.components.GraphBase")]
		public function get graphChilds():ArrayList
		{
			return _graphChilds;
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			if (_state == value){
				return;
			}
				
			_state = value;
		}



		public function get canMove():Boolean
		{
			return _canMove;
		}

		public function set canMove(value:Boolean):void
		{
			_canMove = value;
		}

		public function get canResize():Boolean
		{
			return _canResize;
		}
		
		public function set canResize(value:Boolean):void
		{
			_canResize = value;
		}


		public function get model():Object
		{
			return _model;
		}

		public function set model(value:Object):void
		{
			if (_model == value)
			{
				return;
			}
			_model = value;
			
		}

		public function get graphParent():GraphBase
		{
			return _graphParent;
		}

		public function set graphParent(value:GraphBase):void
		{
			if (_graphParent == value){
				return;
			}
		
			if ((value &&  value.canAddChild(this)) || value == null ){
				var oldGraphParent :GraphBase = _graphParent;
				if (oldGraphParent){
					oldGraphParent.graphChilds.removeItem(this);
				}
				if (value){
					value.graphChilds.addItem(this);
				}
				_graphParent = value;
			}
		}
		
		
		public function canAddChild(child:GraphBase):Boolean
		{ 
			return false;
		}

		public function get dragging():Boolean
		{
			return _dragging;
		}

		public function set dragging(value:Boolean):void
		{
			if (_dragging == value){
				return;
			}
			
			_dragging = value;
			if (value){
				graphContainer.addDraggingGraph(this);
				CollectionUtils.forEach(this,graphChilds,function (graph:GraphBase):void{
					graph.dragging = true;
				});
				
			}else{
				graphContainer.removeDraggingGraph(this);
				CollectionUtils.forEach(this,graphChilds,function (graph:GraphBase):void{
					graph.dragging = false;
				});
			}
			
			
		}

		public function get caption():String
		{
			return _caption;
		}

		public function set caption(value:String):void
		{
			if (_caption == value){
				return;
			}
			_caption = value;
			
			if (labelDisplay){
				labelDisplay.text = _caption;
			}
			if (skin){
				skin.invalidateDisplayList();
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected == value)
			{
				return;
			}else{
				_selected = value;
				
				if (_selected){
					this.graphContainer.addSelectedGraph(this);
				}else{
					this.graphContainer.removeSelectedGraph(this);
				}
				
				if (this == graphContainer.focusGraph){
					//set all child selected false
					CollectionUtils.forEach(this,graphChilds,function(graph:GraphBase):void{
						graph.selected = false;
					});
					//set parent selected false
					setParentSelected(this,false);
				}

				if (skin)
				{
					skin.invalidateDisplayList();
				}
			}
		}
		
		private function setParentSelected(graph:GraphBase,selected:Boolean):void
		{
			var parent:GraphBase = graph.graphParent;
			while (parent ){
				parent.selected = selected;
				parent = parent.graphParent;
			}  
			
		}
		
		public function onGraphMouseDown(event:MouseEvent):void
		{
			graphContainer.focusGraph = this;
			if (this.selected && event.shiftKey){
				this.selected = false;
			}else if (!this.selected){
				if (!event.shiftKey){
					graphContainer.removeAllSelected();
				}
				this.selected = true;
			}
			
			if (canMove || canResize){
				var localPt:Point = new Point(event.localX,event.localY);
				var ht:Number = queryHitTest(localPt);
				if (this.selected ){
					this.beginDrag(localPt,ht);
				}
			}
		}
		
		
		protected function beginDrag(localPt:Point,ht:Number):void
		{
			this.dragging = true;
			graphContainer.beginDragGraph(this,localPt,ht);
		}
		
		
		public function beginFollowDrag():void
		{
			this.dragging = true;
		}
		
		public function onGraphMouseMove(event:MouseEvent):void
		{
			if (dragging)
			{
				drageTo(new Point(event.localX,event.localY));
			}
			
		}
		
		public function endFollowDrag():void
		{
			this.dragging = false;
		}
		
		protected function drageTo(localPt:Point):void{
			graphContainer.performDragBy(localPt);
		}
		
		
		public function offSetByHitTest(offSetX:Number,offSetY:Number,hitTest:Number):void{}
		
		public function queryHitTest(localPt:Point):Number
		{
			return GraphHitTest.HT_NOWHERE;
		}
		
		
		public function onGraphMouseUp(event:MouseEvent):void
		{
			if (this.dragging){
				endDrag(new Point(event.localX,event.localY));
			}
			graphContainer.focusGraph = null;
		}
		
		protected function endDrag(localPt:Point):void
		{
			dragging = false;
			graphContainer.endDragGraph(this);
		}
		
		public function isDragging():Boolean
		{
			return this.dragging ;
		}
		
		public function getGraphBounds():Rectangle
		{
			return this.getBounds(this.graphContainer);
		}
		
		public function containsMarkerRect(markerRect:Rectangle):Boolean
		{
			return false;
		}
		
		
		protected function onGraphMoveResize(event:Event):void{
			adjustPosition();
			notifiyDependencies(event);
			if (graphParent)
			{
				graphParent.invalidateSize();
				graphParent.invalidateDisplayList();
			}
		}
		
		/**
		 * 
		 * to do ,should use a layout constraints  
		 */
		protected function adjustPosition():void
		{
			if (this.x <0 ){
				this.x =0;
			}
			if (this.y <0 ){
				this.y =0;
			}
		}
		
		protected function notifiyDependencies(event:Event):void
		{
		}
		
		protected function onGraphRemove(event:FlexEvent):void{
		
			//first remove all child
			CollectionUtils.forEach(this,graphChilds,function(graph:GraphBase):void{
				graphContainer.removeElement(graph);
			},true);
			
			//set graph parent to null 
			this.graphParent = null;
			this.graphChilds.removeAll();
			
			this.removeEventListener(FlexEvent.REMOVE,onGraphRemove);
			this.removeEventListener(ResizeEvent.RESIZE,onGraphMoveResize);
			this.removeEventListener(MoveEvent.MOVE,onGraphMoveResize);
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,onGraphMoveResize);
			
			this.removeEventListener(GraphLoadEvent.LOADED,onGraphLoaded);
		}
		
		public function sendToBack():void
		{
			var thisIndex :int = this.graphContainer.getElementIndex(this);
			var firstIndex:int =  this.graphContainer.getElementIndex(this.graphContainer.getFirstChild());
			//if have graph parent ,don't send to back
			if (graphParent){
				firstIndex =  this.graphContainer.getElementIndex(graphParent);
				if (thisIndex < firstIndex){
					graphContainer.swapElementsAt(thisIndex,firstIndex);
				}
			}else{
				graphContainer.swapElementsAt(thisIndex,firstIndex);
			}
		
		}
		
		
		public function bringToFront():void
		{
			var thisIndex :int = this.graphContainer.getElementIndex(this);
			var lastIndex:int =  this.graphContainer.getElementIndex(this.graphContainer.getLastChild());
			if (graphParent){
				lastIndex = this.graphContainer.getElementIndex(graphParent);
			}
			
			if (lastIndex > thisIndex){
				graphContainer.swapElementsAt(thisIndex,lastIndex);
			}
			
			if (graphChilds){
				for (var i:int = graphChilds.length -1 ; i>=0 ; i--){
					(graphChilds.getItemAt(i) as GraphBase).bringToFront();
				}
			}
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == labelDisplay){
				labelDisplay.text = caption;
			}
		}
		
		protected function isLink():Boolean
		{
			return false;
		}
		
		public function scale(factor:Number):void{
			this.scaleX += factor;
			this.scaleY += factor;
			if (this.scaleX <=1){
				this.scaleX = 1;
			}
			
			if (this.scaleY <= 1){
				this.scaleY = 1;
			}
		}
		
		protected function onGraphLoaded(event:GraphLoadEvent):void{
//			onGraphMoveResize(null);
		};
			
		
		public function canCreateGraphUnderPoint(pt:Point,graph:GraphBase):Boolean
		{
			return true;
		}
		
		protected function isLoading():Boolean
		{
			return this.state == GraphState.LOADING;
		}
		
		protected function isLoaded():Boolean
		{
			return this.state == GraphState.LOADED;
		}
		
		protected function isCreating():Boolean
		{
			return this.state == GraphState.CREATE;
		}
		
		
	}
}