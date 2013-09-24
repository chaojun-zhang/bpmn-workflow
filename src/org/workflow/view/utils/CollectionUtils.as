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
 */package org.workflow.view.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class CollectionUtils
	{
		public static function forEach(invokeTarget:Object,collection:Object,func:Function,reverse:Boolean = false):void
		{
			var item:Object;
			var i:int;
			if (!reverse){
				if (collection is Array){
					for each(item in collection){
						func.apply(invokeTarget,[item]);
					} 
				}
				else if (collection is ArrayList || collection is ArrayCollection){
					for each(item in collection.source){
						func.apply(invokeTarget,[item]);
					} 
				}
				
			}else{
				if (collection is Array && collection.length>0){
					for (i = collection.length-1 ;i>=0 ;i--){
						func.apply(invokeTarget,[collection[i]]);
					} 
				}else if (collection is ArrayList || collection is ArrayCollection){
					if (collection.source.length>0){
						for (i = collection.source.length-1 ;i>=0 ;i--){
							func.apply(invokeTarget,[collection.source[i]]);
						} 
					}
				}
			}
			
			
		}
	}
}