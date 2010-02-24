/**
	Simple Wrapper over Spring 10 Apex DOM Classes. This class will try avoiding complexity involved in using Apex DOM classes.
	You can get the source and more details at the google project hosting.
	Google Code Project : https://code.google.com/p/apex-fast-xml-dom/
	TODO: add links to API docs 
	
	@author Abhinav(https://www.tgerm.com)	
*/
@isTest
private class Test_TG_XmlDom {

	// Used example XML from http://www.w3schools.com/dom/books.xml
	public static String sampleXml = '<bookstore>'   
									 + ' <book xmlns:c="http://www.w3schools.com/children/" category="CHILDREN">' 
										 + ' <c:title c:lang="en">Harry Potter</c:title>' 
										 + ' <c:author>J K. Rowling</c:author> ' 
										 + ' <c:year>2005</c:year> ' 
										 + ' <c:price>29.99</c:price> ' 
									 + ' </book> ' 
									 + ' <book xmlns:x="http://www.w3schools.com/xml/" category="WEB"> ' 
										 + ' <x:title x:lang="en">Learning XML</x:title> ' 
										 + ' <x:author>Erik T. Ray</x:author> ' 
										 + ' <x:year>2003</x:year> ' 
										 + ' <x:price>39.95</x:price> ' 
									 + ' </book> ' 
								 + ' </bookstore> ';
								 	
    static testMethod void testGetElementsByTagName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlDomElement root = dom.root;
    	List<TG_XmlDomElement> books = root.getElementsByTagName('book');
    	System.assertEquals(2, books.size());
    	// with uptoLead flag as false
    	List<TG_XmlDomElement> titles = root.getElementsByTagName('title', 1, TG_XmlDomElement.MAX_ELEMENTS_TILL_LEAF);
    	System.assertEquals(0, titles.size());
    	// this should digg till leaf for a tag
    	titles = root.getElementsByTagName('title', 2, TG_XmlDomElement.MAX_ELEMENTS_TILL_LEAF);
    	System.assertEquals(2, titles.size());
    	
    	titles = root.getElementsByTagName('title');
    	System.assertEquals(2, titles.size());
    	
    	titles = root.getElementsByTagName('title', TG_XmlDomElement.DEPTH_TILL_LEAF, 1);
    	System.assertEquals(1, titles.size());	    		    	
    }

	static testMethod void testGetElementByTagName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlDomElement root = dom.root;
    	TG_XmlDomElement book = root.getElementByTagName('book');
    	System.assertNotEquals(null, book);
	}
	
	static testMethod void testNodeName() {
		TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlDomElement root = dom.root;
    	System.assertEquals('bookstore', root.nodeName);
    	TG_XmlDomElement book = root.getElementByTagName('book');
    	System.assertNotEquals(null, book);
    	System.assertEquals('book', book.nodeName);
	}   
	 								 	
    static testMethod void testGetAttribute() {
    	TG_XmlDom dom = new TG_XmlDom(sampleXml);
    	TG_XmlDomElement root = dom.root;
    	List<TG_XmlDomElement> books = root.getElementsByTagName('book');
    	System.assertEquals(2, books.size());
    	System.assertEquals('CHILDREN', books[0].getAttribute('category'));
    	System.assertEquals('WEB', books[1].getAttribute('category'));
    }
}