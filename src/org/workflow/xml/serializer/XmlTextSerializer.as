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
 */package org.workflow.xml.serializer
{
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	import com.googlecode.flexxb.xml.annotation.XmlMember;
	import com.googlecode.flexxb.xml.serializer.XmlElementSerializer;
	
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	public class XmlTextSerializer extends XmlElementSerializer
	{
		private static const LOG : ILogger = LogFactory.getLog(XmlTextSerializer);
		public function XmlTextSerializer(context:DescriptionContext)
		{
			super(context);
		}
		
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializationCore) : void {
			var stringValue : String = serializer.converterStore.objectToString(object, annotation.type);
			parentXml.appendChild(XML(new XMLNode(XMLNodeType.TEXT_NODE, stringValue)));
		}
		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializationCore) : Object {
			if(serializer.configuration.enableLogging){
				LOG.info("Deserializing text <<{0}>> to field {1}", xmlName, element.name);
			}
			var xml : XML = xmlData.children()[0];
			return xml.toString();
		}
	}
}