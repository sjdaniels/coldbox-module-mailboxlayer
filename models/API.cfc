component {

	property name="settings" inject="coldbox:setting:mailboxlayer";

	public function init() {
		variables.serviceURL = "https://apilayer.net/api";
		return this;
	}

	public struct function check(required string email, boolean smtp=true, boolean catchall=false) {
		var cfhttp;

		http url="#getServiceURL()#/check" method="get" {
			httpparam type="url" name="access_key" value="#settings.apiKey#";
			httpparam type="url" name="email" value="#arguments.email#";
			httpparam type="url" name="smtp" value="#arguments.smtp?1:0#";
			httpparam type="url" name="catch_all" value="#arguments.catchall?1:0#";
		}

		try {
			var result = deserializeJSON(cfhttp.filecontent);
		}
		catch (any var e) {
			throw(type="com.braunsmedia.MailboxLayer",message="MailBoxLayer API Error",detail="Unable to deserialize response.",extendedinfo=serializeJSON(cfhttp));
		}

		if (structkeyexists(result,"error")) {
			throw(type="com.braunsmedia.MailboxLayer",message="MailBoxLayer API Error",extendedinfo="Error #result.error.code# response from API: #result.error.type#",details=result.error.info?:"No additional info.");
		}

		return result;
	}

	public string function getServiceURL() {
		return variables.serviceURL;
	}
}