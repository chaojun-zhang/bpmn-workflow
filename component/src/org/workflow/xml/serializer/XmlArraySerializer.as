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
package org.workflow.xml.serializer {
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.util.isVector;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	import com.googlecode.flexxb.xml.XmlConfiguration;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.flexxb.xml.annotation.XmlClass;
	import com.googlecode.flexxb.xml.annotation.XmlMember;
	import com.googlecode.flexxb.xml.serializer.XmlElementSerializer;
	import com.googlecode.flexxb.xml.util.XmlUtils;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.ListCollectionView;
	
	import org.workflow.module.IWorkflowModule;
	import org.workflow.module.WorkflowModuleRegister;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlArray annotation.
	 * @author Alexutz
	 *
	 */
	public final class XmlArraySerializer extends XmlElementSerializer {
		
		
		private static const LOG : ILogger = LogFactory.getLog(XmlArraySerializer);
		/**
		 *Constructor
		 *
		 */
		public function XmlArraySerializer(context : DescriptionContext) {
			super(context);
		}
		
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializationCore) : void {
			var result : XML = <xml />;
			var xmlArray : XmlArray = annotation as XmlArray;
			var child : XML;
			for each (var member : Object in object) {
				if(xmlArray.isIDRef){
					child = XML(serializer.getObjectId(member));
					var xmlName:QName = annotation.xmlName;
					if (xmlArray.memberName){
						xmlName = xmlArray.memberName;
					}
					var temp : XML = <xml/>;
					temp.setName(xmlName);
					temp.appendChild(child);
					child = temp;
				}else if (isComplexType(member)) {
					child = serializer.serialize(member, xmlArray.serializePartialElement) as XML;
					if (xmlArray.memberName) {
						child.setName(xmlArray.memberName);
					}
				} else {
					var stringValue : String = serializer.converterStore.objectToString(member, xmlArray.type);
					var xmlValue : XML;
					try {
						xmlValue = XML(stringValue);
					} catch (error : Error) {
						xmlValue = escapeValue(stringValue, serializer.configuration as XmlConfiguration);
					}

					if (xmlArray.memberName) {
						child = <xml />;
						child.setName(xmlArray.memberName);
						child.appendChild(xmlValue);
					} else {
						child = xmlValue;
					}
				}
				
				if (XmlArray(annotation).setXsiType)
				{
					child.addNamespace(XmlUtils.xsiNamespace);
					var childAnnotation:XmlClass=serializer.descriptorStore.getDescriptor(member, annotation.version) as XmlClass;
					if (childAnnotation.hasNamespaceDeclaration())
					{
						//if child has namespace, then xsi type needs to include it
						child.addNamespace(childAnnotation.nameSpace);
						child.@[XmlUtils.xsiType]=childAnnotation.nameSpace.prefix + ":" + childAnnotation.alias;
					}
					else
					{
						child.@[XmlUtils.xsiType]=childAnnotation.alias;
					}
				}
				result.appendChild(child);
			}

			for each (var subChild : XML in result.children()) {
				parentXml.appendChild(subChild);
			}
		}
		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializationCore) : Object {
			if(serializer.configuration.enableLogging){
				LOG.info("Deserializing array element <<{0}>> to field {1} with items of type <<{2}>>", xmlName, element.name, XmlArray(element).type);
			}
			var result : Object = new element.type();

			var array : XmlArray = element as XmlArray;
			xmlName = array.xmlName;
			if (array.memberName){
				xmlName = array.memberName;
			}
			
			var xmlArray : XMLList = xmlData.child(xmlName);
			if (array.xmlName.localName == "eventDefinition"){
				trace();
			}
			if(array.getRuntimeType){
				xmlArray = xmlData.children();
			}
			//extract the items from xml, build the result array and return it
			if (xmlArray && xmlArray.length() > 0) {
				var list : Array = [];
				if(!array.memberName && xmlArray.length() == 1 && xmlArray[0].nodeKind() == "text"){
					// we need to handle differently the case in which we have items of simple type 
					// and have no item name defined
					var values : Array = xmlArray[0].toString().split("\n");
					for each(var value : String in values){
						list.push(getValue(XML(value), array.memberType, array.getFromCache, serializer))
					}
				}else{
					var type : Class = array.memberType;
					for each (var xmlChild : XML in xmlArray) {
						
						if(array.isIDRef){
							serializer.idResolver.addResolutionTask(list, null, xmlChild.toString());
						}else{
							if (array.getRuntimeType) {
								type = this.getRunTimeType(xmlChild);
							
							}
							if (type) {
								var member : Object = getValue(xmlChild, type, array.getFromCache, serializer);
								
								if (member != null) {
									if (array.getRuntimeType  ){
										if (member is array.memberType){
											list.push(member);
										}
									}else{
										list.push(member);
									}
									
								}
							}
							
						}
					}
				}
				addMembersToResult(list, result);
			}
			return result;
		}

		private function addMembersToResult(members : Array, result : Object) : void {
			if (result is Array) {
				(result as Array).push.apply(null, members);
			} else if (result is ArrayCollection) {
				ArrayCollection(result).source = members;
			} else if (result is ListCollectionView) {
				ListCollectionView(result).list = new ArrayList(members);
			}else if(isVector(result)){
				result.push.apply(null, members);
			}
		}
		
		
		private function getRunTimeType(xmlChild:XML):Class{
			for each (var module:IWorkflowModule in WorkflowModuleRegister.getInstance().workflowModules) 
			{
				var qname:QName = xmlChild.name();
				if (module.getNamespace() == qname.uri){
					return module.getTypeByXmlName(qname.localName);
				}
			}
			
			return null;
		}
	}
}