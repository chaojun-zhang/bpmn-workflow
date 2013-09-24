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
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayList;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.workflow.view.constants.GraphConstants;
	import org.workflow.view.constants.GraphHitTest;
	import org.workflow.view.skins.ActivityNodeSkin;
	import org.workflow.view.utils.CollectionUtils;
	import org.workflow.view.utils.MathUtils;
	import org.workflow.view.utils.RectangleUtils;

	public class GraphNode extends GraphBase 
	{
		[ArrayElementType("org.workflow.view.components.GraphLink")]
		public var incomings:ArrayList;
		
		[ArrayElementType("org.workflow.view.components.GraphLink")]
		public var outgoings:ArrayList;
		
		private var _imageUrl:String;
		
		
		[SkinPart(required="false")]
		public var img:Image;
		
		private var loader:Loader;
		
		[SkinPart(required="true")]
		public var marker:UIComponent;
		
		public function GraphNode(){
			super();
			incomings = new ArrayList();
			outgoings = new ArrayList();
		}
		

		public function get imageUrl():String
		{
			return _imageUrl;
		}
		
		public function set imageUrl(value:String):void
		{
			if (_imageUrl == value){
				return;
			}
			
			if (value){
				if (!loader){
					loader = new Loader();
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
					if (!img){
						img = new Image();
					}
					img.source = e.currentTarget.content;
				});
				loader.load(new URLRequest(value));
			}
			_imageUrl = value;
		}
		
		protected function getSkinClass():Class
		{
			return ActivityNodeSkin;
		}

		public override function offSetByHitTest(offSetX:Number,offSetY:Number,hitTest:Number):void{
			var offsetWidth:Number = 0;
			var offsetHeight:Number = 0;
			if (offSetX!=0 || offSetY!=0)
			{
				switch ( hitTest){
					case GraphHitTest.HT_TOPLEFT:
						if (this.canMove){
							this.x += offSetX;
							this.y += offSetY;
						}
						if (this.canResize){
						
							offsetWidth = - offSetX;
							offsetHeight = - offSetY;
						}
						break;
					case GraphHitTest.HT_TOP:
						if (this.canMove){
							this.y += offSetY;
						}
						if (canResize){
							offsetHeight = - offSetY;
						}
						break;
					case GraphHitTest.HT_TOPRIGHT:
						if (this.canMove){
							this.y += offSetY;
						}
						if (canResize){
							offsetWidth =  offSetX;
							offsetHeight = - offSetY;
						}
						break;
					case GraphHitTest.HT_LEFT:
						if (this.canMove){
							this.x += offSetX;
						}
						if (canResize){
							offsetWidth = - offSetX;
						}
						break;
					case GraphHitTest.HT_RIGHT:
						if (canResize){
							offsetWidth =  offSetX;
						}
						break;
					case GraphHitTest.HT_BOTTOMLEFT:
						if (this.canMove){
							this.x += offSetX;
						}
						if (canResize){
							offsetWidth = - offSetX;
							offsetHeight =  offSetY;
						}
						break;
					case GraphHitTest.HT_BOTTOM:
						if (canResize){
							offsetHeight =  offSetY;
						}
						break;
					case GraphHitTest.HT_BOTTOMRIGHT:
						if (canResize){
							offsetWidth =  offSetX;
							offsetHeight =  offSetY;
						}
						break;
					case GraphHitTest.HT_CLIENT:
						if (canMove){
							this.x += offSetX;
							this.y += offSetY;
						}
						break;
				}
				
				if (canResize && (!graphParent || !graphParent.dragging)) {
					this.width += offsetWidth;
					this.height += offsetHeight;
				}
			}
		
		}
		
		public override function queryHitTest(localPt:Point):Number
		{
			var result:Number = GraphHitTest.HT_NOWHERE;
			
			if (this.selected ||  getGraphBounds().containsPoint(localPt)) {
				if ( canResize && RectangleUtils.makeRect(new Point(this.x,this.y),GraphConstants.MARKER_RADIOUS).containsPoint(localPt) ){
					result = GraphHitTest.HT_TOPLEFT;
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x + this.width/2,this.y),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_TOP;
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x + this.width,this.y),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_TOPRIGHT
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x,this.y + this.height /2 ),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_LEFT;
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x ,this.y + this.height),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_BOTTOMLEFT
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x + this.width /2 ,this.y + this.height),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_BOTTOM;
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x + this.width,this.y + this.height),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_BOTTOMRIGHT;
				}else if (canResize && RectangleUtils.makeRect(new Point(this.x + this.width ,this.y + this.height /2 ),GraphConstants.MARKER_RADIOUS).containsPoint(localPt)  ){
					result = GraphHitTest.HT_RIGHT;
				}else if (canMove && getGraphBounds().containsPoint(localPt) ){
					result = GraphHitTest.HT_CLIENT;
				}
			}
			return result;
		}
		
		public function addInCommingLink(link:GraphLink):void{
			
			if (link && incomings.getItemIndex(link)==-1){
				incomings.addItem(link);
			}
		}
		
		public function removeIncommingLink(link:GraphLink):void{
			
			if (link && incomings.getItemIndex(link)!=-1){
				incomings.removeItem(link);
			}
		}
		
		public function addOutgoingLink(link:GraphLink):void{
			
			if (link && outgoings.getItemIndex(link)==-1){
				outgoings.addItem(link);
			}
		}
		
		public function removeOutgoingLink(link:GraphLink):void{
			
			if (link && outgoings.getItemIndex(link)!=-1){
				outgoings.removeItem(link);
			}
		}

		
		override protected function onGraphRemove(event:FlexEvent):void
		{
			
			CollectionUtils.forEach(this,incomings,function(link:GraphLink):void{
				graphContainer.removeElement(link);
			
			},true);
			CollectionUtils.forEach(this,outgoings,function(link:GraphLink):void{
				graphContainer.removeElement(link);
				
			},true);
			
			this.incomings.removeAll();
			this.outgoings.removeAll();
			super.onGraphRemove(event);
		}
		
		
		public function relativeHookAnchor(queryPt: Point): Point{
			var markerBounds:Rectangle =  getGraphBounds();
			var centerPt :Point = new Point(markerBounds.x + markerBounds.width /2,markerBounds.y + markerBounds.height /2);
			var result:Point  = centerPt;
			
			if (!markerBounds.containsPoint(queryPt)){
				var Angle: Number = MathUtils.lineSlopeAngle(queryPt, centerPt);
				var intersects:Array = linkIntersect(queryPt,Angle);
				var nearestPointIndex:int = MathUtils.nearestPoint(intersects, queryPt);
				if (nearestPointIndex <0){
					result = centerPt;
				}else{
					result = intersects[nearestPointIndex];
				}
			}
			return result;
		}
		
		protected function linkIntersect(linkPt: Point, linkAngle: Number): Array{
			return  MathUtils.intersectLineRect(linkPt, linkAngle, getGraphBounds());
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			validateGraphRect();
		}
		
		protected function validateGraphRect():void
		{
			if (this.width < this.minWidth ){
				this.width = this.minWidth;
			}
			
			if (this.height < this.minHeight){
				this.height = this.minHeight;
			}
			
			if (graphParent){
				if (this.x < graphParent.x){
					this.move(graphParent.x,this.y);
				}
				if (this.y < graphParent.y){
					this.move(this.x,graphParent.y);
				}
			}
			CollectionUtils.forEach(this,graphChilds,function (graph:GraphBase):void{
				if (graph is GraphNode){
					var childRect:Rectangle = graph.getBounds(this.graphContainer);
					
					if (!this.getBounds(this.graphContainer).containsRect(childRect)){
						if (this.x > childRect.left )
						{
							this.move(childRect.left,this.y);
						}
						if (this.y > childRect.top)
						{
							this.move(this.x,childRect.top);
						}
						
						if ((this.x + this.width) < childRect.right){
							this.width += (childRect.right - (this.x + this.width));
						}
						
						if ((this.y + this.height) < childRect.bottom )
						{
							this.height += (childRect.bottom - (this.y + this.height ));
						}
						
					}
				}
				
			});
			
		}
		
		override protected function notifiyDependencies(event:Event):void
		{
			super.notifiyDependencies(event);
			var g:GraphLink;
			for each(g in incomings.source)
			{
				g.dispatchEvent(event.clone());
			}
			for each( g in outgoings.source)
			{
				g.dispatchEvent(event.clone());
			}
		}
		
		override public function containsMarkerRect(markerRect:Rectangle):Boolean
		{
			return markerRect.containsRect(getGraphBounds());
		}
		
		protected function getCenterPoint():Point
		{
			
			var rect:Rectangle = this.getGraphBounds();
			var point :Point = new Point();
			point.x = rect.x + rect.width /2;
			point.y = rect.y + rect.height /2;
			return point;
		}
		
		override public function set selected(value:Boolean):void
		{
			if (this.selected == value){
				return;
			}
			super.selected = value;
			
			marker.visible = this.selected;
		}
		
		public function canAddIncoming():Boolean
		{
			return true;
		}
		
		public function canAddOutgoing():Boolean
		{
			return true;
		}
		
		public function getGraphMarkerSize():Number
		{
			return GraphConstants.MARKER_RADIOUS * 2;
		}

		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName,instance);
			if (instance == marker){
				marker.visible = this.selected;
			}
		}
		
		override public function getGraphBounds():Rectangle
		{
			return this.marker.getBounds(this.graphContainer);
		}
	}
}