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
	Google Code Project : https://code.google.com/p/apex-fast-xml-dom/
	TODO: add links to API docs 
	@author Abhinav(https://www.tgerm.com)	
*/
@isTest
private class Test_TG_XmlNode {

	// Used example XML from http://www.w3schools.com/dom/books.xml
	public static String sampleXml = '<bookstore>'   
									 + '<book xmlns:c="http://www.w3schools.com/children/" category="CHILDREN">'
									  	 + '<!-- Test Comment 1 -->'
									 	 + '<c:title c:lang="en">Harry Potter</c:title>' 
							 			 + '<c:author>J K. Rowling</c:author>' 
										 + '<c:year>2005</c:year>'
										 + '<!-- Test Comment 2 -->' 
										 + '<c:price>29.99</c:price>' 
									 + '</book>' 
									 + '<book xmlns:x="http://www.w3schools.com/xml/" category="WEB">' 
										 + '<x:title x:lang="en">Learning XML</x:title>' 
										 + '<x:author>Erik T. Ray</x:author>' 
										 + '<x:year>2003</x:year>' 
										 + '<x:price>39.95</x:price>' 
									 + '</book>' 
								 + '</bookstore>';
								 	
    static testMethod void testGetElementsByTagName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	List<TG_XmlNode> books = root.getElementsByTagName('book');
    	System.assertEquals(2, books.size());
    	// with uptoLead flag as false
    	List<TG_XmlNode> titles = null; 
    	
    	titles = root.getElementsByTagName('title');
    	System.assertEquals(2, titles.size());
    }

    static testMethod void testGetElementsByTagNameNS() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	List<TG_XmlNode> titles = root.getElementsByTagNameNS('http://www.w3schools.com/children/','title');
    	System.assertEquals(1, titles.size());
    }


	static testMethod void testGetElementByTagName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertNotEquals(null, book);
	}
	
	static testMethod void testChildNodes() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertNotEquals(null, book);
    	List<TG_XmlNode> childNodes = book.childNodes;
    	Integer commentCount = 0;
    	Integer elementCount = 0;
    	Integer textNodeCount = 0;
    	for (TG_XmlNode child: childNodes) {
    		if (child.nodeType == 8) commentCount++;
    		if (child.nodeType == 1) elementCount++; 
    		if (child.nodeType == 3) textNodeCount++;  
    	}
    	System.assertEquals(2, commentCount);
    	// There is no direct textnode under book.
    	System.assertEquals(0, textNodeCount);
    	System.assertEquals(4, elementCount);
    	
    	TG_XmlNode title = book.getElementByTagName('c:title');
    	childNodes = title.childNodes;
    	commentCount = 0;
    	elementCount = 0;
    	textNodeCount = 0;
    	for (TG_XmlNode child: childNodes) {
    		if (child.nodeType == 8) commentCount++;
    		if (child.nodeType == 1) elementCount++; 
    		if (child.nodeType == 3) textNodeCount++;  
    	}
    	System.assertEquals(0, commentCount);// no comments are there
    	// There is no direct textnode under book.
    	System.assertEquals(1, textNodeCount);
    	System.assertEquals(0, elementCount);
    	
	}
	
	static testMethod void testNodeName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	System.assertEquals('bookstore', root.nodeName);
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertNotEquals(null, book);
    	System.assertEquals('book', book.nodeName);
	}   
	 								 	
    static testMethod void testGetAttribute() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	List<TG_XmlNode> books = root.getElementsByTagName('book');
    	System.assertEquals(2, books.size());
    	System.assertEquals('CHILDREN', books[0].getAttribute('category'));
    	System.assertEquals('WEB', books[1].getAttribute('category'));
    }
    
    static testMethod void testToXmlString() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		TG_XmlNode book = root.getElementByTagName('book');
 		TG_XmlNode title = book.getElementByTagName('c:title');
 		System.assertEquals('<c:title c:lang=\'en\'>Harry Potter</c:title>', title.toXmlString());   	
    }
     
     static testMethod void testTextContent() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		TG_XmlNode book = root.getElementByTagName('book');
 		System.assertEquals('Harry Potter J K. Rowling 2005 29.99', book.textContent);
 		TG_XmlNode title = book.getElementByTagName('c:title');
 		System.assertEquals('Harry Potter', title.textContent);
 		title.textContent = 'Modified Text Content';
    	System.assertEquals('Modified Text Content', title.textContent);   	
    }
    
     static testMethod void testNodeValue() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		TG_XmlNode book = root.getElementByTagName('book');
 		TG_XmlNode title = book.getElementByTagName('c:title');
 		System.assertEquals('Harry Potter', title.nodeValue);   
 		String newVal = 'Abhinav Gupta';
 		title.nodeValue = newVal;
 		System.assertEquals(newVal, title.nodeValue);
    }
 	
 	static testMethod void testFirstChild() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		TG_XmlNode fc = root.firstChild;
 		TG_XmlNode book = root.getElementByTagName('book');
 		System.assertEquals(fc.xmlNode, book.xmlNode);
 	}
 	
 	static testMethod void testLastChild() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		TG_XmlNode book = root.getElementByTagName('book');
 		TG_XmlNode lc = book.lastChild;
 		System.assertEquals('price', lc.nodeName);
 	}
 	
 	static testMethod void testNamespaceURI() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
 		System.assertEquals(null, root.namespaceURI);
 		root.namespaceURI = 'http://www.tgerm.com';
 		System.assertEquals('http://www.tgerm.com', root.namespaceURI);
 	}
 	
 	static testMethod void testNextSibling() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	//must be a book tag
    	TG_XmlNode firstKid = root.firstChild;
 		TG_XmlNode nextBookTag = firstKid.nextSibling;
		System.assertEquals('book', nextBookTag.nodeName); 		
 		String category = nextBookTag.getAttribute('category');
 		System.assertEquals('WEB', category);
 	}
 	
 	static testMethod void testParentNode() {
 		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.firstChild;
    	System.assertEquals(root.xmlNode, book.parentNode.xmlNode);
 	}
 	
 	static testmethod void testPrefix() {
 		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	System.assertEquals(null, root.prefix);
 	}
 	
 	
 	static testMethod void testPreviousSibling() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode[] books = root.getElementsByTagName('book');
    	System.assertEquals(2, books.size());
    	TG_XmlNode secondBook = books[1];
    	System.assertEquals(books[0].xmlNode, secondBook.previousSibling.xmlNode); 
 	}	
    
	static testMethod void testHasAttributes() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertEquals(true, book.hasAttributes()); 
 	}	
    
	static testMethod void testHasChildNodes() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertEquals(true, book.hasChildNodes()); 
 	}	
    
	static testMethod void testIsDefaultNamespace() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertEquals(true, book.isDefaultNamespace(root.namespaceURI)); 
 	}	    

	static testMethod void testRemoveChild() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	TG_XmlNode title = book.getElementByTagName('title');
    	Boolean deleted = book.removeChild(title);
    	System.assertEquals(true, deleted);
    	//fetch the same again
    	title = book.getElementByTagName('title');
    	System.assertEquals(null, title);
 	}
 
 	static testMethod void testRoot() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode title = root.getElementByTagName('title');
    	System.assertEquals(root.xmlNode, title.root.xmlNode);
 	}
 	
 	static testMethod void testLookupPrefix() {
 		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertEquals('c', book.lookupPrefix('http://www.w3schools.com/children/'));
 	}
 	
 	 static testMethod void testLookupNamespaceURI() {
 		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	System.assertEquals('http://www.w3schools.com/children/', book.lookupNamespaceURI('c'));
 	}
 	
 	static testMethod void testCloneNode() {
 		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
    	TG_XmlNode book = root.getElementByTagName('book');
    	TG_XmlNode bookCloned = book.cloneNode(true);
 		System.assertEquals(book.xmlNode.getChildren().size(), bookCloned.xmlNode.getChildren().size());
 		System.assertEquals(book.getAttribute('category'), bookCloned.getAttribute('category'));
 		
 		TG_XmlNode title = book.getElementByTagName('title');
 		TG_XmlNode titleCloned = bookCloned.getElementByTagName('title');
 		
 		System.assertEquals(title.nodeValue, titleCloned.nodeValue);		
 		System.assertEquals(title.nodeType, titleCloned.nodeType);
 	
 		// Now lets try without deep cloning
 		bookCloned = book.cloneNode(false);
 		// No child should be there in the cloned node
 		System.assertEquals(0, bookCloned.xmlNode.getChildren().size());
 		// Attributes should be copied
 		System.assertEquals(book.getAttribute('category'), bookCloned.getAttribute('category'));
 	}
 	
 	static testMethod void testAppendChild() {
		String xmlToAppend = '<book xmlns:x="http://www.w3schools.com/xml/" category="MODDED">' 
										 + '<x:title x:lang="en">TGerm</x:title>' 
										 + '<x:author>Abhinav Gupta</x:author>' 
										 + '<x:year>2010</x:year>' 
										 + '<x:price>100.00</x:price>' 
									 + '</book>' ;
								 	
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlNode root = dom.root;
	
	    TG_XmlNode book = root.getElementByTagName('book');

    	TG_XmlNode nodeToAppend = new TG_XmlDom(xmlToAppend).root;

		root.appendChild(nodeToAppend);

		TG_XmlNode[] books = root.getElementsByTagName('book');
		
		System.assertEquals(3, books.size());
		System.assertEquals('Abhinav Gupta', books[2].getElementByTagName('author').nodeValue);
		System.assertEquals('TGerm', books[2].getElementByTagName('title').nodeValue);
		System.assertEquals('2010', books[2].getElementByTagName('year').nodeValue);
		System.assertEquals('100.00', books[2].getElementByTagName('price').nodeValue);
 	}
}