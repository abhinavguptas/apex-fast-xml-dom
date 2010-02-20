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
	public Element root {get; private set;}
	
	// utility dom functions
	public Element ownerDocument() { return root; }

	// dump out the element tree
	public String toXmlString() { return domDoc.toXmlString(); }
	
	// Constructor
	public TG_XmlDom(String xml) {
		domDoc.load(xml);
		Dom.XmlNode rootXmlNode = domDoc.getRootElement();
		root = new Element(rootXmlNode); 
	}
	
	public TG_XmlDom(String rootElementName, String rootElementNamespace, String rootElementPrefix) { 
		Dom.XmlNode rootXmlNode  = domDoc.createRootElement(rootElementName, rootElementNamespace, rootElementPrefix);
		root = new Element(rootXmlNode);
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
	
	
/* 
 *  Element  class definition
 
	This following class implements a small portion of the wc3 xml dom model.  
	Generally useful for simple XML return objects. 
	
	for a properties and methods complete list see: 
	http://www.w3schools.com/dom/dom_node.asp
	
	For simplicity, Nodes are the same as Elements in this class.
	Nodes have text directly in them, rather than a seperate text node child
	The following describes the implemented portion, some w3c properties are now methods.	
	
	Property 	Description 	
	 
	nodeName 	Returns the name of a node, depending on its type 
	nodeValue 	Sets or returns the value of a node, depending on its type 
	childNodes 	Returns a NodeList of child nodes for a node
	parentNode 	Returns the parent node of a node 
	attributes  	Returns a NamedNodeMap of attributes for the element, also contains name space entries
	
	getElementByTagName() Returns list of elements matching tag name (document and element)
	firstChild() 	Returns the first child of a node 
	removeChild() 	Removes a child node 
	appendChild() 	Adds a new child node to the end of the list of children of a node 
	getAttribute() 	Returns the value of an attribute 
	hasChildNodes() 	Returns whether the element has any child nodes 
	isEqualNode() 	Checks if two nodes are equal 
	textContent() 	returns the textual content of a node 
	cloneNode() 	Clones a node 
	hasAttributes() 	Returns whether the element has any attributes 
	isSameNode() 	Checks if two nodes are the same node 
	ownerDocument() 	Returns the root element (document object) for a node 
	
	
	*** NOT Implemented at this time *** 
	
	lastChild() 	Returns the last child of a node 
	nodeType 	Returns the type of a node , all nodes are the same type currently
	baseURI 	Returns the absolute base URI of a node 
	localName 	Returns the local part of the name of a node 
	namespaceURI 	Returns the namespace URI of a node 
	nextSibling 	Returns the node immediately following a node 
	insertBefore() 	Inserts a new child node before an existing child node 
	replaceChild() 	Replaces a child node 

 */
 public class Element {
	//NEW ATTRIBS
	public Dom.XmlNode xmlNode {get;private set;}
		
	//	Element(Element p, string n) {		parentNode = p;			nodeName = n;		}
	public Element(Dom.XmlNode node) {
		xmlNode = node;
	}
	 
	private Map<String,String> attributes {
		get {
 			if (attributes != null) return attributes;
			attributes = new Map<String, String>();
			Integer attribCount = xmlNode.getAttributeCount();
			for (Integer idx = 0 ; idx < attribCount ; idx ++) {
				String aNs = xmlNode.getAttributeKeyNsAt(idx);
				String aKey = xmlNode.getAttributeKeyAt(idx);
				String aVal = xmlNode.getAttributeValue(aKey, aNs);
				attributes.put(aKey, aVal);
			}
			return attributes;
		} private set;
	}
		
	public String getAttribute(string name) {
		return attributes.get(name); 
	}
	
		// traverse below this node, returning all matching nodes by name
	public List<Element> getElementsByTagName(String nam, boolean uptoLeaf) {
		List<Element> ret = new List<Element>{};
		// Make case insensitive
		nam = nam.toLowerCase();
		// Check self
		if (xmlNode.getName().toLowerCase().equals(nam)) ret.add(this);
		// Add kids and their kids
		Dom.XmlNode [] kids = xmlNode.getChildElements();
		if (kids != null && !kids.isEmpty()) {
			for (Dom.XmlNode kid: kids) {
				Element kidElement = new Element(kid);
				if (uptoLeaf) 
					ret.addAll(kidElement.getElementsByTagName(nam, uptoLeaf));
				else if (kid.getName().toLowerCase().equals(nam))
					ret.add(new Element(kid));
			} 
		}  
		return ret;
	}
		
	// traverse below this node, returning all matching nodes by name
	public List<Element> getElementsByTagName(String nam) {
		boolean uptoLeaf = true;
		return getElementsByTagName(nam, uptoLeaf);
	}

 }
}