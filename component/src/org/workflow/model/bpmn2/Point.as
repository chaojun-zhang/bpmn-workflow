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
 */package org.workflow.model.bpmn2 {

	[Bindable]

	[XmlClass(alias="Point",uri="http://www.omg.org/spec/DD/20100524/DC",prefix="dc",idField="id",ordered="true")]
	[Namespace(prefix="dc",uri="http://www.omg.org/spec/DD/20100524/DC")]
	[Namespace(prefix="di",uri="http://www.omg.org/spec/DD/20100524/DI")]
	
	public class Point  {

		// Fields

		
		
		[XmlAttribute(alias="x")]
		public var x:Number;
		
		
		[XmlAttribute(alias="y")]
		public var y:Number;

		
	
	}

}
