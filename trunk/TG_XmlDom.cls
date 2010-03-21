/*
Copyright (c) 2010 tgerm.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
	Simple Wrapper over Spring 10 Apex DOM Classes. This class will try avoiding complexity involved in using Apex DOM classes.
	You can get the source and more details at the google project hosting.
	@link Google Code Project : https://code.google.com/p/apex-fast-xml-dom/
	@author Abhinav(https://www.tgerm.com)	
*/
public class TG_XmlDom {
	
	private Dom.Document domDoc = new Dom.Document();
	// everything in the dom is found as childNodes under this root element
	public TG_XmlNode root {get; private set;}
	
	// utility dom functions
	public Dom.Document ownerDocument { get {return domDoc;} private set; }

	// dump out the element tree
	public String toXmlString() { return domDoc.toXmlString(); }
	
	// Constructor
	public TG_XmlDom(String xml) {
		domDoc.load(xml);
		Dom.XmlNode rootXmlNode = domDoc.getRootElement();
		root = new TG_XmlNode(rootXmlNode); 
	}
	
	public TG_XmlDom(String rootElementName, String rootElementNamespace, String rootElementPrefix) { 
		Dom.XmlNode rootXmlNode  = domDoc.createRootElement(rootElementName, rootElementNamespace, rootElementPrefix);
		root = new TG_XmlNode(rootXmlNode);
	}
	
	 
	// FACTORY METHODS //
	public static TG_XmlDom createForRootElement(String rootElementName) {
		return new TG_XmlDom(rootElementName, null, null);	
	}	
	
	public static TG_XmlDom createForRootElement(String rootElementName, String rootElementNamespace, String rootElementPrefix) {
		return new TG_XmlDom(rootElementName, rootElementNamespace, rootElementPrefix);
	}		
	
	public static TG_XmlDom createFromXml(String xml) {
		return new TG_XmlDom(xml);
	}
}