/**
 * Implements cookie-less JavaScript session variables
 * v1.0
 *
 * By Craig Buckler, Optimalworks.net
 *
 * As featured on SitePoint.com
 * Please use as you wish at your own risk.
*
 * Usage:
 *
 * // store a session value/object
 * Session.set(name, object);
 *
 * // retreive a session value/object
 * Session.get(name);
 *
 * // clear all session data
 * Session.clear();
 *
 * // dump session data
 * Session.dump();
 */

 if (JSON && JSON.stringify && JSON.parse) var Session = Session || (function() {

	// window object
	var win = window.top || window;

	// Firefox sometimes contain random characters here, breaking the JSON parser
	if ((typeof(win.name) != "string") || (win.name.substring(2, 7) != "ouiDB")) {
			win.name = "";
	}

	// session store
	var store = (win.name ? JSON.parse(win.name) : {});

	// save store on page unload
	function Save() {
		win.name = JSON.stringify(store);
	};

	// page unload event
	if (window.addEventListener) window.addEventListener("unload", Save, false);
	else if (window.attachEvent) window.attachEvent("onunload", Save);
	else window.onunload = Save;

	// public methods
	return {

		// set a session variable
		set: function(name, value) {
			store[name] = value;
		},

		// get a session value
		get: function(name) {
			return (store[name] ? store[name] : undefined);
		},

		// clear session
		clear: function() { store = {}; },

		// dump session data
		dump: function() { return JSON.stringify(store); }

	};

 })();

var ouiClientListArray = new Array();
ouiClientListArray = Session.get("ouiDB");
if(ouiClientListArray == undefined) {
	ouiClientListArray = [];
	//Download OUI DB
	setTimeout(function() {
		var ouiBDjs = document.createElement("script");
		ouiBDjs.type = "application/javascript";
		ouiBDjs.src = "/ouiDB.js";
		window.document.body.appendChild(ouiBDjs);
	}, 1000);
}

/* Exported from device-map/clients.asp */

lan_ipaddr = "<% nvram_get("lan_ipaddr"); %>";
lan_netmask = "<% nvram_get("lan_netmask"); %>";

/* get client info form dhcp lease log */
loadXMLDoc("/getdhcpLeaseInfo.asp");
var _xmlhttp;
function loadXMLDoc(url){
	if(parent.sw_mode != 1) return false;

	var ie = window.ActiveXObject;
	if(ie)
		_loadXMLDoc_ie(url);
	else
		_loadXMLDoc(url);
}

var _xmlDoc_ie;
function _loadXMLDoc_ie(file){
	_xmlDoc_ie = new ActiveXObject("Microsoft.XMLDOM");
	_xmlDoc_ie.async = false;
	if (_xmlDoc_ie.readyState==4){
		_xmlDoc_ie.load(file);
		setTimeout("parsedhcpLease(_xmlDoc_ie);", 1000);
	}
}

function _loadXMLDoc(url) {
	_xmlhttp = new XMLHttpRequest();
	if (_xmlhttp && _xmlhttp.overrideMimeType)
		_xmlhttp.overrideMimeType('text/xml');
	else
		return false;

	_xmlhttp.onreadystatechange = state_Change;
	_xmlhttp.open('GET', url, true);
	_xmlhttp.send(null);
}

function state_Change(){
	if(_xmlhttp.readyState==4){// 4 = "loaded"
		if(_xmlhttp.status==200){// 200 = OK
			parsedhcpLease(_xmlhttp.responseXML);    
		}else{
			return false;
		}
	}
}

var leasehostname;
var leasemac;
function parsedhcpLease(xmldoc){
	var dhcpleaseXML = xmldoc.getElementsByTagName("dhcplease");
	leasehostname = dhcpleaseXML[0].getElementsByTagName("hostname");
	leasemac = dhcpleaseXML[0].getElementsByTagName("mac");
	populateCache();
}

var retHostName = function(_mac){
	if(parent.sw_mode != 1 || !leasemac) return false;
	if(leasemac == "") return "";

	for(var idx=0; idx<leasemac.length; idx++){
		if(!(leasehostname[idx].childNodes[0].nodeValue.split("value=")[1]) || !(leasemac[idx].childNodes[0].nodeValue.split("value=")[1]))
			continue;

		if( _mac.toLowerCase() == leasemac[idx].childNodes[0].nodeValue.split("value=")[1].toLowerCase()){
			if(leasehostname[idx].childNodes[0].nodeValue.split("value=")[1] != "*")
				return leasehostname[idx].childNodes[0].nodeValue.split("value=")[1];
			else
				return "";
		}
	}
	return "";
}
/* end */


hostnamecache = { "ready":0 };

function populateCache() {
	var s;

	var client_list_array = '<% get_client_detail_info(); %>';

	if (client_list_array) {
		s = client_list_array.split('<');
		for (var i = 0; i < s.length; ++i) {
			var t = s[i].split('>');
			if (t.length == 7) hostnamecache[t[2]] = t[1].trim();
		}
	}

	hostnamecache[fixIP(ntoa(aton(lan_ipaddr) & aton(lan_netmask)))] = 'LAN';
	hostnamecache["ready"] = 1;
	return;
}

function updateManufacturer(_ouiDBArray) {  //from ASUS ouidatabase
	ouiClientListArray = [];
	ouiClientListArray = _ouiDBArray;
	Session.set("ouiDB", _ouiDBArray);
}

function oui_query_web(mac) {
	var tab = new Array()
	tab = mac.split(mac.substr(2,1));

  $j.ajax({
    url: 'https://www.macvendorlookup.com/api/v2/'+ tab[0] + tab[1] + tab[2] + '/xml',
		type: 'GET',
    error: function(xhr) {
			if(overlib.isOut)
				return true;
			else
				oui_query_web(mac);
    },
    success: function(response) {
			if(overlib.isOut)
				return nd();
			var retData = response.responseText.split("<company>")[1].split("</company>");
			overlib_str_tmp += "<p><span>.....................................</span></p>";
			return overlib(overlib_str_tmp + "<p style='margin-top:5px'><#Manufacturer#> :</p>" + retData[0]);
		}    
  });
}

function oui_query(mac){
	setTimeout(function(){
		var manufacturer_id = mac.replace(/\:/g,"").substring(0, 6);

		if(ouiClientListArray[manufacturer_id] != undefined) {
			overlib_str_tmp += "<p><span>.....................................</span></p><p style='margin-top:5px'><#Manufacturer#>:</p>";
			return overlib(overlib_str_tmp + "<p style='margin-top:5px'></p>" + ouiClientListArray[manufacturer_id]);
		} else {
			return oui_query_web(mac);
		}
	}, 1);
}
