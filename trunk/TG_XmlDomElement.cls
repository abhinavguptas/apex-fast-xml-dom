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
public virtual class TG_XmlDomElement {
	public static final Integer DEPTH_TILL_LEAF = -1;
	public static final Integer DEPTH_BASE = 0;
	public static final Integer MAX_ELEMENTS_TILL_LEAF = -1; 
	
	//NEW ATTRIBS
	public Dom.XmlNode xmlNode {get;private set;}
		
	//	Element(Element p, string n) {		parentNode = p;			nodeName = n;		}
	public TG_XmlDomElement(Dom.XmlNode node) {
		xmlNode = node;
	}
	
	public String nodeName {
		get{
			return xmlNode.getName();
		} protected set;}
		
	protected Map<String,String> attributes {
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
		} protected set;
	}
		
	public virtual String getAttribute(string name) {
		return attributes.get(name); 
	}
	
	/**
		Returns all the Elements matching the specified tag name. 
		However one can speed up the lookup, if he doesn't wants to 
		digg till leaf now. For ex. if one is at root node and wants to 
		get all matching child elements upto depth 2 only, then this param
		can be used for this. 
	*/
	public virtual List<TG_XmlDomElement> getElementsByTagName(String nam, Integer depth, Integer maxElements) {
		// matching elements by tag name
		List<TG_XmlDomElement> ret = new List<TG_XmlDomElement>{};
		
		// Check if this node is matching the mentioned tag name.
		if (xmlNode.getName().toLowerCase().equals(nam)) ret.add(this);
		
		//System.debug('>> NODE:' + xmlNode.getName() + ' depth : ' + depth + ' max : ' + maxElements);
		
		// If we have reached till required depth, then return
		if (depth == DEPTH_BASE) return ret;		

		// This flag will enforce return of limited no. of elements, instead of 
		// full fledged search inside DOM. Thi will speed up specially when one wants
		// just the first element for a tag name
		boolean limitReturnedElements = maxElements > 0;
		// If required number of elements are fetched then return
		if (limitReturnedElements && (ret.size() >= maxElements)) {
			return ret;
		}
			
						
		// Add kids and their kids
		Dom.XmlNode [] kids = xmlNode.getChildElements();
		if (kids != null && !kids.isEmpty()) {
			// we are diving into kids so reduce the depth, if we don't need to dive till leaf
			depth = depth == DEPTH_TILL_LEAF ? DEPTH_TILL_LEAF : depth - 1;
			for (Dom.XmlNode kid: kids) {
				TG_XmlDomElement kidElement = new TG_XmlDomElement(kid);
				Integer childMaxElements = limitReturnedElements ? (maxElements - ret.size()) : MAX_ELEMENTS_TILL_LEAF;
				//System.debug('>> KID-NODE:' + kidElement.xmlNode.getName() + ' depth : ' + depth + ' max : ' + childMaxElements);
				ret.addAll(kidElement.getElementsByTagName(nam, depth, childMaxElements));
				
				// if we have fetched the required number of elements that return
				if (limitReturnedElements && ret.size() >= maxElements) break;
			} 
		}  
		return ret;
	}
		
	/**
		Returns all the Elements matching the specified tag name.
	*/
	public virtual List<TG_XmlDomElement> getElementsByTagName(String nam) {
		return getElementsByTagName(nam, DEPTH_TILL_LEAF, MAX_ELEMENTS_TILL_LEAF);
	}

	public virtual TG_XmlDomElement getElementByTagName(String nam) {
		List<TG_XmlDomElement> elem = getElementsByTagName(nam, DEPTH_TILL_LEAF, 1); 
		return elem != null && !elem.isEmpty() ? elem[0] : null;
	}
}