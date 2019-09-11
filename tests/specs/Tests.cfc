component extends="testbox.system.BaseSpec" {
/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		api = new root.models.API();
		prepareMock( api );
		settings = deserializeJSON(fileread(expandpath("/root/tests/.env")));
		api.$property(propertyName:"SETTINGS", mock:settings);
		successresult = api.check("sean@braunsmedia.com");
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		// MinFraud model
		describe( "Mailboxlayer Model", function(){

			it("has a service URL", function(){
				expect( api.getServiceURL() ).notToBeNull();		
			});

			it("returns struct", function(){
				expect( successresult ).toBeStruct();		
			});

			it("has correct user", function(){
				expect( successresult.user ).toBe("sean");		
			});

			it("has correct domain", function(){
				expect( successresult.domain ).toBe("braunsmedia.com");		
			});

			it("has valid format", function(){
				expect( successresult.format_valid ).toBeTrue();		
			});

			it("has all expected keys", function(){
				expect( successresult ).toHaveKey( "mx_found" );		
				expect( successresult ).toHaveKey( "email" );		
				expect( successresult ).toHaveKey( "did_you_mean" );		
				expect( successresult ).toHaveKey( "user" );		
				expect( successresult ).toHaveKey( "domain" );		
				expect( successresult ).toHaveKey( "format_valid" );		
				expect( successresult ).toHaveKey( "smtp_check" );		
				expect( successresult ).toHaveKey( "role" );		
				expect( successresult ).toHaveKey( "disposable" );		
				expect( successresult ).toHaveKey( "free" );		
				expect( successresult ).toHaveKey( "score" );		
			});

			it("invalid format checks", function(){
				failresult = api.check("sean");
				expect( failresult.format_valid ).toBeFalse();		
			});

			it("throws correct exception", function(){
				api.$property(propertyName:"SETTINGS", mock:{apiKey="badkey"});
				expect( function(){ api.check("sean@braunsmedia.com") }).toThrow( type="com.braunsmedia.MailboxLayer" );		
			});

		});
	}
}