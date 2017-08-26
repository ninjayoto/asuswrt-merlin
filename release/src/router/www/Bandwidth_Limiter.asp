<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title><#Web_Title#> - Bandwidth Limiter</title>
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">

<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/detect.js"></script>

<style>
.Portrange{
	font-size: 12px;
	font-family: Lucida Console;
}

#ClientList_Block_PC{
	border:1px outset #999;
	background-color:#576D73;
	position:absolute;
	margin-top:25px;
	margin-left:3px;
	*margin-left:-125px;
	width:255px;
	*width:259px;
	text-align:left;
	height:auto;
	overflow-y:auto;
	z-index:200;
	padding: 1px;
	display:none;
}
#ClientList_Block_PC div{
	background-color:#576D73;
	height:20px;
	line-height:20px;
	text-decoration:none;
	font-family: Lucida Console;
	padding-left:2px;
}

#ClientList_Block_PC a{
	background-color:#EFEFEF;
	color:#FFF;
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
	text-decoration:none;
}
#ClientList_Block_PC div:hover, #ClientList_Block a:hover{
	background-color:#3366FF;
	color:#FFFFFF;
	cursor:default;
}
</style>
<script>
<% login_state_hook(); %>
var qos_bw_rulelist = "<% nvram_get("qos_bw_rulelist"); %>".replace(/&#62/g, ">").replace(/&#60/g, "<");
var ctf_disable = '<% nvram_get("ctf_disable"); %>';
var ctf_fa_mode = '<% nvram_get("ctf_fa_mode"); %>';
var over_var = 0;
var isMenuopen = 0;
var scaling = 1;
var label = "";

function key_event(evt){
	if(evt.keyCode != 27 || isMenuopen == 0)
		return false;
	pullQoSList($("pull_arrow"));
}

function initial(){
	show_menu();
	changeScale("qos_bw_units");
//	showqos_bw_rulelist();

	showLANIPList();
}

function applyRule(){
		save_table();
		showLoading();
		document.form.submit();
}

function changeScale(obj){
	if($(obj).value == 0){
		scaling = 1;
		label = "Kb/s";
	} else {
		scaling = 1024;
		label = "Mb/s";
	}
	$("bw_down").innerHTML = label;
	$("bw_up").innerHTML = label;

	showqos_bw_rulelist();
}

function save_table(){
	var qos_bw_rulelist_tmp = "";
	if(qos_bw_rulelist == "")
		return false;
//	qos_bw_rulelist_tmp += "<"
	qos_bw_rulelist_tmp += qos_bw_rulelist;
	document.form.qos_bw_rulelist.value = qos_bw_rulelist_tmp;
}

function done_validating(action){
	refreshpage();
}

function bandwidth_code(o,event){
	var keyPressed = event.keyCode ? event.keyCode : event.which;
	var target = o.value.split(".");

	if (is_functionButton(event))
		return true;

	if((keyPressed == 46) && (target.length > 1))
		return false;

	if((target.length > 1) && (target[1].length > 0))
		return false;

	if ((keyPressed == 46) || (keyPressed > 47 && keyPressed < 58))
		return true;
	else
		return false;
}

function addRow(obj, head){
	if(head == 1)
		qos_rulelist_array += "<"
	else
		qos_rulelist_array += ">"

	qos_rulelist_array += obj.value;
	obj.value= "";
}

function deleteRow_main(obj){
	var item_index = obj.parentNode.parentNode.rowIndex;
		document.getElementById(obj.parentNode.parentNode.parentNode.parentNode.id).deleteRow(item_index);

	var target_mac = obj.parentNode.parentNode.children[1].title;
	var qos_bw_rulelist_row = qos_bw_rulelist.split("<");
	var qos_bw_rulelist_tmp = "";
	var priority = 0;
	for(i=0;i<qos_bw_rulelist_row.length;i++){
		var qos_bw_rulelist_col = qos_bw_rulelist_row[i].split(">");
		if((qos_bw_rulelist_col[1] != target_mac) && (qos_bw_rulelist_col[1] != undefined)){
			var string_temp = qos_bw_rulelist_row[i].substring(0,qos_bw_rulelist_row[i].length-1) + priority; // reorder priority number

			if(qos_bw_rulelist_tmp == ""){
				qos_bw_rulelist_tmp += string_temp;
			}
			else{
//				qos_bw_rulelist_tmp += "<" + string_temp + ">" + priority;  // reorder priority number
				qos_bw_rulelist_tmp += "<" + string_temp;
			}
			priority++;
		}

	}

	if(qos_bw_rulelist_tmp == "")
		qos_bw_rulelist = "";
	else
		qos_bw_rulelist = "<" + qos_bw_rulelist_tmp;

	showqos_bw_rulelist();
}

function addRow_main(obj, length){
	//var enable_checkbox = $(obj.parentNode).siblings()[0].children[0];
	var invalid_char = "";
	var qos_bw_rulelist_row =  qos_bw_rulelist.split("<");
	var max_priority = 0;
	if(qos_bw_rulelist != "")
		max_priority = qos_bw_rulelist_row.length - 1;

	if(!validate_string(document.form.PC_devicename))
		return false;

	if(document.form.PC_devicename.value == ""){
		alert("<#JS_fieldblank#>");
		document.form.PC_devicename.focus();
		return false;
	}

	if(qos_bw_rulelist.search(PC_mac) > -1 && PC_mac != ""){		//check same target
		alert("<#JS_duplicate#>");
		document.form.PC_devicename.focus();
		PC_mac = "";
		return false;
	}

	if(!valid_Target(document.form.PC_devicename)){
                return false;
        }

	if(qos_bw_rulelist.search(document.form.PC_devicename.value) > -1){
		alert("<#JS_duplicate#>");
		document.form.PC_devicename.focus();
		return false;
	}

	if(document.getElementById("download_rate").value == ""){
		alert("<#JS_fieldblank#>");
		document.getElementById("download_rate").focus();
		return false;
	}

	if(document.getElementById("upload_rate").value == ""){
		alert("<#JS_fieldblank#>");
		document.getElementById("upload_rate").focus();
		return false;
	}

	for(var i = 0; i < document.form.PC_devicename.value.length; ++i){
		if(document.form.PC_devicename.value.charAt(i) == '<' || document.form.PC_devicename.value.charAt(i) == '>'){
			invalid_char += document.form.PC_devicename.value.charAt(i);
			document.form.PC_devicename.focus();
			alert("<#JS_validstr2#> ' "+invalid_char + " '");
			return false;
		}
	}

	if(document.form.PC_devicename.value.indexOf('-') != -1
	|| document.form.PC_devicename.value.indexOf('~') != -1
	||(document.form.PC_devicename.value.indexOf(':') != -1 && document.form.PC_devicename.value.indexOf('.') != -1)){
		var space_count = 0;
		space_count = document.form.PC_devicename.value.split(" ").length - 1;
		for(i=0;i < space_count;i++){		// filter space
			document.form.PC_devicename.value = document.form.PC_devicename.value.replace(" ", "");
		}

		document.form.PC_devicename.value = document.form.PC_devicename.value.replace(":", "-");
		document.form.PC_devicename.value = document.form.PC_devicename.value.replace("~", "-");
	}

//	if(qos_bw_rulelist == ""){
//		qos_bw_rulelist += $("selRow").checked ? 1:0;
//	}
//	else{
		qos_bw_rulelist += "<";
		qos_bw_rulelist += $("selRow").checked ? 1:0;
//	}

	if(PC_mac == "")
		qos_bw_rulelist += ">" + document.form.PC_devicename.value + ">";
	else
		qos_bw_rulelist += ">" + PC_mac + ">";

	qos_bw_rulelist += document.getElementById("download_rate").value*scaling + ">" + document.getElementById("upload_rate").value*scaling;
	qos_bw_rulelist += ">" + max_priority;
	PC_mac = "";
	document.form.PC_devicename.value = "";
	max_priority++;
	showqos_bw_rulelist();
}

function showqos_bw_rulelist(){
	var qos_bw_rulelist_row = qos_bw_rulelist.split("<");
	var client_list_array = '<% get_client_detail_info(); %>';
	var client_list_row = client_list_array.split('<');
	var code = "";
	code +='<table width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" class="list_table" id="qos_bw_rulelist_table">';
	if(qos_bw_rulelist == ""){
		code += '<tr><td style="color:#FFCC00;" colspan="10"><#IPConnection_VSList_Norule#></td></tr>';
	}
	else{
		var wid=[5, 45, 20, 20, 10];
		for(i=0;i< qos_bw_rulelist_row.length;i++){
			if(qos_bw_rulelist_row[i] == "")
				continue;
			code +='<tr id="row'+i+'">';
			var qos_bw_rulelist_col = qos_bw_rulelist_row[i].split('>');
			for(var j = 0; j < qos_bw_rulelist_col.length; j++){
				var apps_client_name = "";
				var apps_client_id = qos_bw_rulelist_col[1];
				for(var k = 1; k < client_list_row.length; k += 1) {
					var client_list_col = client_list_row[k].split('>');
					if(apps_client_id == client_list_col[3]){ // lookup name based on mac
						apps_client_name = client_list_col[1];
					}
					if(apps_client_id == client_list_col[2]){ // lookup name based on ipaddr
						apps_client_name = client_list_col[1];
					}
					if(apps_client_name != "")
						break;
				}
			}
			code += '<tr>';
			code += '<td title="<#WLANConfig11b_WirelessCtrl_button1name#>/<#btn_disable#>">';

			if(qos_bw_rulelist_col[0] == 1)
				code += '<input width="'+wid[0]+'%" id="'+i+'" type="checkbox" onclick="enable_check(this)" checked>';
			else
				code += '<input width="'+wid[0]+'%" id="'+i+'" type="checkbox" onclick="enable_check(this)">';

			code += '</td>';

			if(apps_client_name != "")
				code += '<td width="'+wid[1]+'%" title="' + apps_client_id + '">'+ apps_client_name + '<br>(' +  apps_client_id +')</td>';
			else
				code += '<td width="'+wid[1]+'%" title="' + apps_client_id + '">' + apps_client_id + '</td>';

			code += '<td width="'+wid[2]+'%" style="text-align:center;">'+Math.round((qos_bw_rulelist_col[2]/scaling)*1000)/1000+' '+label+'</td>';

			code += '<td width="'+wid[3]+'%" style="text-align:center;">'+Math.round((qos_bw_rulelist_col[3]/scaling)*1000)/1000+' '+label+'</td>';

			code += '<td><input width="'+wid[4]+'%" class="remove_btn" type="button" onclick="deleteRow_main(this);"></td>';
			code += '</tr>';
		}
	}
	code += '</table>';
	document.getElementById('qos_bwlist_Block').innerHTML = code;
	showLANIPList();
}

function switchPage(page){
	if(page == "1")
		location.href = "/QoS_EZQoS.asp";
	else if(page == "2")
		location.href = "/Advanced_QOSUserRules_Content.asp";
	else if(page == "3")
		location.href = "/Advanced_QOSUserPrio_Content.asp";
	else
		return false;
}

var isMenuopen = 0;
function pullQoSList(obj){
	if(isMenuopen == 0){
		obj.src = "/images/arrow-top.gif"
		$("QoSList_Block").style.display = 'block';
		//document.form.qos_service_name_x_0.focus();
		isMenuopen = 1;
	}
	else{
		$("pull_arrow").src = "/images/arrow-down.gif";
		$('QoSList_Block').style.display='none';
		isMenuopen = 0;
	}
}

function hideClients_Block(evt){
	if(typeof(evt) != "undefined"){
		if(!evt.srcElement)
			evt.srcElement = evt.target; // for Firefox

		if(evt.srcElement.id == "pull_arrow" || evt.srcElement.id == "ClientList_Block_PC"){
			return;
		}
	}

	$("pull_arrow").src = "/images/arrow-down.gif";
	$('ClientList_Block_PC').style.display='none';
	isMenuopen = 0;
}

function valid_Target(obj){

	if(obj.value == ""){
			return true;
	}else{
			var hwaddr = new RegExp("(([a-fA-F0-9]{2}(\:|$)){6})", "gi");		// ,"g" whole erea match & "i" Ignore Letter
			var legal_hwaddr = new RegExp("(^([a-fA-F0-9][aAcCeE02468])(\:))", "gi"); // for legal MAC, unicast & globally unique (OUI enforced)

			if(obj.value.split(":").length >= 2){
				if(!hwaddr.test(obj.value)){
					obj.focus();
					alert("<#LANHostConfig_ManualDHCPMacaddr_itemdesc#>");
					return false;
				}else if(!legal_hwaddr.test(obj.value)){
					obj.focus();
					alert("<#IPConnection_x_illegal_mac#>");
					return false;
				}else
					return true;
			}
			else if(obj.value.split("*").length >= 2){
				if(!valid_IP_subnet(obj))
					return false;
				else
					return true;
			}
			else if(obj.value.split("-").length >=2){
				if(!valid_IP_range(obj))
					return false;
				else
					return true;
			}
			else if((obj.value.indexOf("wl0") == 0) || (obj.value.indexOf("wl1") == 0)){ // valid guest network
					return true;
			}
			else if(!validate_ipcidr(obj)){
					return false;
			}
			else
					return true;
	}
}

function device_filter(obj){
	var target_obj = document.getElementById("ClientList_Block_PC");
	if(obj.value == ""){
		hideClients_Block_mac();
		showLANIPList();
	}
	else{
		obj.src = "/images/arrow-top.gif"
		document.getElementById("ClientList_Block_PC").style.display = 'block';
		document.form.PC_devicename.focus();
		var code = "";
		var client_list_array = '<% get_client_detail_info(); %>';
		var client_list_row = client_list_array.split('<');
		for(var i = 1; i < client_list_row.length; i += 1) {
			var client_list_col = client_list_row[i].split('>');
			if(client_list_col[1])
				code += '<a title=' + client_list_col + '><div style="height:auto;" onmouseover="over_var=1;" onmouseout="over_var=0;" onclick="setClientIP_mac(\''+client_list_col[1]+'\', \''+client_list_col[3]+'\');"><strong>'+client_list_col[2]+'</strong> ';
			else
				code += '<a title=' + client_list_col + '><div style="height:auto;" onmouseover="over_var=1;" onmouseout="over_var=0;" onclick="setClientIP_mac(\''+client_list_col[3]+'\', \''+client_list_col[3]+'\');"><strong>'+client_list_col[2]+'</strong> ';
			code += '( '+client_list_col[1]+' )';
			code += ' </div></a>';
		}

		document.getElementById("ClientList_Block_PC").innerHTML = code;
	}
}

function showLANIPList(){
	var code = "";
	var show_name = "";
	var client_list_array = '<% get_client_detail_info(); %>';
	var client_list_row = client_list_array.split('<');

	for(var i = 1; i < client_list_row.length; i++){
		var client_list_col = client_list_row[i].split('>');
		if(client_list_col[1] && client_list_col[1].length > 20)
			show_name = client_list_col[1].substring(0, 16) + "..";
		else
			show_name = client_list_col[1];

		if(client_list_col[1])
			code += '<a><div onmouseover="over_var=1;" onmouseout="over_var=0;" onclick="setClientIP_mac(\''+client_list_col[1]+'\', \''+client_list_col[3]+'\');"><strong>'+client_list_col[2]+'</strong> ';
		else
			code += '<a><div onmouseover="over_var=1;" onmouseout="over_var=0;" onclick="setClientIP_mac(\''+client_list_col[3]+'\', \''+client_list_col[3]+'\');"><strong>'+client_list_col[2]+'</strong> ';
			if(show_name && show_name.length > 0)
				code += '( '+show_name+' )';
			code += ' </div></a>';
	}
	code +='<!--[if lte IE 6.5]><iframe class="hackiframe2"></iframe><![endif]-->';
	$("ClientList_Block_PC").innerHTML = code;
}

function pullLANIPList(obj){
	if(isMenuopen_mac == 0){
		obj.src = "/images/arrow-top.gif";
		$("ClientList_Block_PC").style.display = 'block';
		document.form.PC_devicename.focus();
		isMenuopen_mac = 1;
	}
	else
		hideClients_Block_mac();
}

var over_var = 0;
var isMenuopen_mac = 0;

function hideClients_Block_mac(){
	$("pull_arrow").src = "/images/arrow-down.gif";
	$('ClientList_Block_PC').style.display='none';
	isMenuopen_mac = 0;
}

var PC_mac = "";
function setClientIP_mac(devname, macaddr){
	document.form.PC_devicename.value = macaddr;
	PC_mac = macaddr;
	hideClients_Block_mac();
	over_var = 0;
}

function enable_check(obj){
	var qos_bw_rulelist_row = qos_bw_rulelist.split("<");
	var rulelist_row_temp = "";
	for(i=0;i<qos_bw_rulelist_row.length;i++){
		var qos_bw_rulelist_col = qos_bw_rulelist_row[i].split(">");
		var rulelist_col_temp = "";
		for(j=0;j<qos_bw_rulelist_col.length;j++){
			if(obj.id == i && j == 0){
				qos_bw_rulelist_col[j] = obj.checked ? 1 : 0;
			}
			else if(obj.id == "selAll" && j == 0 && i > 0){
				qos_bw_rulelist_col[j] = obj.checked ? 1 : 0;
			}

			rulelist_col_temp += qos_bw_rulelist_col[j];
			if(j != qos_bw_rulelist_col.length-1)
				rulelist_col_temp += ">";
		}

		rulelist_row_temp += rulelist_col_temp;
		if(i != qos_bw_rulelist_row.length-1)
			rulelist_row_temp += "<";

		rulelist_col_temp = "";
	}

	qos_bw_rulelist = rulelist_row_temp;
	showqos_bw_rulelist();
}

</script>
</head>

<body onkeydown="key_event(event);" onclick="if(isMenuopen){hideClients_Block(event)}" onLoad="initial();" onunLoad="return unload_body();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="current_page" value="Bandwidth_Limiter.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="5">
<input type="hidden" name="action_script" value="restart_qos">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="qos_enable" value="<% nvram_get("qos_enable"); %>">
<input type="hidden" name="qos_type" value="<% nvram_get("qos_type"); %>">
<input type="hidden" name="qos_bw_rulelist" value="">

<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
		<!--===================================Beginning of Main Content===========================================-->
		<table width="95%" border="0" align="left" cellpadding="0" cellspacing="0" class="FormTitle" id="FormTitle">
		<tr>
			<td bgcolor="#4D595D" valign="top">
			<table width="760px" border="0" cellpadding="4" cellspacing="0">
				<tr>
						<td bgcolor="#4D595D" valign="top">
							<table width="100%">
								<tr>
									<td  class="formfonttitle" align="left">
										<div style="margin-top:5px;"><#menu5_3_2#> - Bandwidth Limiter</div>
									</td>
									<td align="right" >
										<div>
											<select onchange="switchPage(this.options[this.selectedIndex].value)" class="input_option">
												<!--option><#switchpage#></option-->
												<option value="1"><#qos_automatic_mode#></option>
												<option value="2"><#qos_user_rules#></option>
												<option value="3"><#qos_user_prio#></option>
												<option value="4" selected>User-defined Bandwidth Limiting</option>
											</select>
										</div>
									</td>
								</tr>
							</table>
						</td>
				</tr>
				<tr>
					<td height="5" bgcolor="#4D595D" valign="top"><img src="images/New_ui/export/line_export.png" /></td>
				</tr>
				<tr>
					<td height="30" align="left" valign="top" bgcolor="#4D595D">
						<div>
							<table width="650px">
								<tr>
									<td width="130px">
										<img id="guest_image" src="/images/New_ui/Bandwidth_Limiter.png">
									</td>
									<td style="font-style: italic;font-size: 14px;">
										<!--untranslated-->
										<div>Bandwidth Limiter allows you to control the max connection speed of the client device. You can select the host name from target or fill in IP address / IP Range / MAC address for limited speed profile setting.</div>
										<div><a style="text-decoration:underline;" href="http://www.asus.com/support/FAQ/1013333/" target="_blank">Bandwidth Limiter FAQ</a></div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>

				<tr>
					<td valign="top">
						<table style="margin-left:3px;" width="99%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">

							<tr>
								<th>Bandwidth Limiter units</a></th>
								<td colspan="2">
									<select id="qos_bw_units" name="qos_bw_units" class="input_option" onChange="changeScale(this);">
										<option value="0"<% nvram_match("qos_bw_units", "0","selected"); %>>Kb/s</option>
										<option value="1"<% nvram_match("qos_bw_units", "1","selected"); %>>Mb/s</option>
									</select>
							</tr>

						</table>
					</td>
				</tr>

			</table>

						<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top:8px">
							<thead>
							<tr>
								<td colspan="5"><#ConnectedClient#>&nbsp;(<#List_limit#>&nbsp;32)</td>
							</tr>
							</thead>
							<tr>
								<th width="6%" height="30px" title="<#select_all#>">
									<input id="selAll" type="checkbox" onclick="enable_check(this);">
								</th>
								<th width="45%"><#NetworkTools_target#></th>
								<th width="20%"><#download_bandwidth#></th>
								<th width="20%"><#upload_bandwidth#></th>
								<th width="10%"><#list_add_delete#></th>
							</tr>
							<tr id="main_element">
								<td style="border-bottom:2px solid #000;" title="<#WLANConfig11b_WirelessCtrl_button1name#>/<#btn_disable#>">
									<input id="selRow" type="checkbox" checked>
								</td>
								<td style="border-bottom:2px solid #000;">
									<input type="text" style="margin-left:10px;float:left;width:285px;" class="input_20_table" name="PC_devicename" onkeyup="device_filter(this);" onblur="if(!over_var){hideClients_Block_mac();}" placeholder="Enter IP Range, MAC or Guest Network" autocorrect="off" autocapitalize="off" autocomplete="off">
									<img id="pull_arrow" height="14px;" src="/images/arrow-down.gif" onclick="pullLANIPList(this);" title="<#select_client#>" onmouseover="over_var=1;" onmouseout="over_var=0;">
									<div id="ClientList_Block_PC" class="ClientList_Block_PC"></div>
								</td>
								<td style="border-bottom:2px solid #000;text-align:right;">
									<input type="text" id="download_rate" class="input_6_table" maxlength="6" onkeypress="return bandwidth_code(this, event);"><span id="bw_down" style="margin: 0 5px;color:#FFF;">Mb/s</span>
								</td>
								<td style="border-bottom:2px solid #000;text-align:right;">
									<input type="text" id="upload_rate" class="input_6_table" maxlength="6" onkeypress="return bandwidth_code(this, event);"><span id="bw_up" style="margin: 0 5px;color:#FFF;">Mb/s</span>
								</td>
								<td style="border-bottom:2px solid #000;">
									<input type="button" class="add_btn" onclick="addRow_main(this, 32)" value="">
								</td>
							</tr>
						</table>
						<div id="qos_bwlist_Block"></div>

						<div class="apply_gen">
								<input name="button" id="applybutton" style="color:#FFFFFF" type="button" class="button_gen" onClick="applyRule()" value="<#CTL_apply#>"/>
						</div>
						</td>
					</tr>
					</tbody>
				</table>
			</td>
			</form>
		</tr>
	</table>
	</td>
	<td width="10" align="center" valign="top">&nbsp;</td>
	</tr>
</table>
<div id="footer"></div>
</body>
</html>
