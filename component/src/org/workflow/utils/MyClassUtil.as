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
 */package org.workflow.utils
{
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class MyClassUtil
	{
		/**
		 *  @private
		 */
		private static var typeCache:Object = {};
		
		/**
		 * 
		 * @param className
		 * @return 
		 * 
		 */
		public static function getClass(className:String):Class
		{
			return Class(getDefinitionByName(className));
		}
		
		/**
		 * 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getClassName(obj:Object):String
		{
			return getQualifiedClassName(obj);
		}
		
		public static function getPropTypeName(obj:Object,propName:String):String
		{
			if (propName && obj)
			{
				var type:String ;
				var propNameChain:Array = propName.split(".");
				for each(var prop:String in propNameChain)
				{
				
					for each( var propXml:XML in getDescribeType(obj).typeDescription.accessor)
					{
						if (propXml.@name == prop)
						{
							type = propXml.@type;
							try{
								var ClassRef:Class = getClass(type);
								obj = new ClassRef();
							}catch(e:Error){
								
							}
							break;
						}
					}
					
				}
				return type;
			}
			
			return null;
		}
		
		
		/**
		 *  Calls <code>flash.utils.describeType()</code> for the first time and caches
		 *  the return value so that subsequent calls return faster.
		 *
		 *  @param o Can be either a string describing a fully qualified class name or any
		 *  ActionScript value, including all available ActionScript types, object instances,
		 *  primitive types (such as <code>uint</code>), and class objects.
		 *
		 *  @return Returns the cached record.
		 *
		 *  @see flash.utils#describeType()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getDescribeType(o:*):DescribeTypeCacheHolder
		{
			var className:String;
			var cacheKey:String;
			
			if (o is String)
				cacheKey = className = o;
			else
				cacheKey = className = getQualifiedClassName(o);
			
			//Need separate entries for describeType(Foo) and describeType(myFoo)
			if (o is Class)
				cacheKey += "$";
			
			if (cacheKey in typeCache)
			{
				return typeCache[cacheKey];
			}
			else
			{
				if (o is String)
				{
					try
					{
						o = getDefinitionByName(o);
					}
					catch (error:ReferenceError)
					{
						// The o parameter doesn't refer to an ActionScript 
						// definition, it's just a string value.
					}
				}
				var typeDescription:XML = flash.utils.describeType(o);
				var record:DescribeTypeCacheHolder = new DescribeTypeCacheHolder();
				record.typeDescription = typeDescription;
				record.typeName = className;
				typeCache[cacheKey] = record;
				
				return record;
			}
		}
		
		 
	}
}