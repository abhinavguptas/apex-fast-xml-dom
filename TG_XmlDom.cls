/**
	Simple Wrapper over Spring 10 Apex DOM Classes. This class will try avoiding complexity involved in using Apex DOM classes.
	You can get the source and more details at the google project hosting.
	Google Code Project : https://code.google.com/p/apex-fast-xml-dom/
	TODO: add links to API docs 
	
	@author Abhinav(https://www.tgerm.com)	
*/
public class TG_XmlDom {

public static boolean debug = false;
	private Dom.Document domDoc = new Dom.Document();
	// everything in the dom is found as childNodes under this root element
	public TG_XmlDomElement root {get; private set;}
	
	// utility dom functions
	public TG_XmlDomElement ownerDocument() { return root; }

	// dump out the element tree
	public String toXmlString() { return domDoc.toXmlString(); }
	
	// Constructor
	public TG_XmlDom(String xml) {
		domDoc.load(xml);
		Dom.XmlNode rootXmlNode = domDoc.getRootElement();
		root = new TG_XmlDomElement(rootXmlNode); 
	}
	
	public TG_XmlDom(String rootElementName, String rootElementNamespace, String rootElementPrefix) { 
		Dom.XmlNode rootXmlNode  = domDoc.createRootElement(rootElementName, rootElementNamespace, rootElementPrefix);
		root = new TG_XmlDomElement(rootXmlNode);
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