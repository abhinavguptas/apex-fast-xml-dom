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
	NOTE: Please exclude this class from your production builds.
	This class was created to easily benchmark various operations on Fast XML DOM and optimize the weak areas.
	Google Code Project : https://code.google.com/p/apex-fast-xml-dom/
	@author Abhinav(https://www.tgerm.com)	
*/

public class TG_XMLDOM_BenchMarks {
	/**
		- Change this to any other URL.
		- Goto Setup > Security Controls > Remote Site Settings 
			to white list the domain for your new xml sample.
		
		For making this sample work just whitelist "http://code.google.com"
	*/
	public static String XML_URL = 'http://code.google.com/feeds/p/apex-atom/svnchanges/basic';
	
	private static BenchmarkManager benchMarker = new BenchmarkManager ();
		
	public static void benchmark() {
		String xml = loadSampleXML();
		benchMark_XmlDom(xml);
		benchMark_TG_XmlDom(xml);
		
		for (Benchmark b : benchMarker.benchmarks) {
			System.debug(System.logginglevel.info, b.result);
		}
	}

	private static string loadSampleXML() {
		benchMarker.startOp('Http', 'send'); 
			// Instantiate a new http object
			Http h = new Http();
			// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
			HttpRequest req = new HttpRequest();
			req.setEndpoint(XML_URL);
			req.setMethod('GET');
			// Send the request, and return a response
			HttpResponse res = h.send(req);
		benchMarker.endOp('-');
		return res.getBody();	
	}	
	
	private static void benchMark_TG_XmlDom(String x) {
		Integer nodeCount ;
		benchMarker.startOp('TG_XmlDom', 'constructor'); 
			TG_XmlDom dom = new TG_XmlDom(x);
		benchMarker.endOp('-');

		benchMarker.startOp('TG_XmlDom' , 'getElementsByTagName');
			nodeCount = dom.root.getElementsByTagName('title').size();
		benchMarker.endOp('nodeCount:' + nodeCount);
	}

	private static void benchMark_XmlDom(String x) {
		Integer nodeCount;  

		benchMarker.startOp('XmlDom', 'constructor'); 
			XmlDom xmlDom  = new XmlDOM(x);
		benchMarker.endOp('-');
		
		benchMarker.startOp('XmlDom', 'getElementsByTagName');
			nodeCount = xmlDom.root.getElementsByTagName('title').size();
		benchMarker.endOp('nodeCount:' + nodeCount);
	}
	
	public class Benchmark {
		public Long timeConsumed {get;set;}
		public Integer scriptConsumed {get;set;}
		public String operation {get;set;}
		public String forClass {get;set;}
		public String otherInfo {get;set;}
		public String result { get
			{
				return '' + forClass +'.' + operation + '() -> Scripts Used : ' + scriptConsumed  
							+ ' ,timeTaken : ' + timeConsumed 
							+ ' , ' + otherInfo;
		
			}
		}
	
	}
		
	public class BenchmarkManager {
		Integer beforeUse, afterUse;  
		Long startTime, endTime;
		Benchmark benchmark ;
		public List<Benchmark> benchmarks {get;set;}
		
		public BenchmarkManager() {
			benchmarks = new List<Benchmark>();
		}
		
		public void startOp(String clsName, String operation) {
			benchmark = new Benchmark ();
			benchmark.forClass = clsName;
			benchmark.operation = operation;
			 
			startTime = System.now().getTime();
			beforeUse = Limits.getScriptStatements();
		}
		
		public void endOp (String otherInfo) {
			afterUse = Limits.getScriptStatements();
			endTime = System.now().getTime();

			benchmark.timeConsumed = endTime - startTime;
			benchmark.scriptConsumed = afterUse - beforeUse;
			benchmark.otherInfo = otherInfo; 
			benchmarks.add(benchmark);	
		}
	}
	
}