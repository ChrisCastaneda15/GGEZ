//Ass

// Getting UserID
Parse.Cloud.define("getSummonerID", function(request, response){

	//Summoner Name
	var summonerName = request.params.summonerName
	var api_key = Parse.Config.get(RIOT_API_KEY)

	// API CALL
	var url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/" + summonerName + "?api_key=" + api_key

	
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", url, false ); // false for synchronous request
    xmlHttp.send( null );
    var response = xmlHttp.responseText;
    var str = JSON.stringify(response);
    var jsonResponse = JSON.parse(str);

    console.log("RESPONSE\n" + response);
    console.log("STR\n" + str);
    console.log("JSON\n" + jsonResponse);

    // Grab the ID

	//response.success( jsonResponse[summonerName]["id"] )

});


/*Parse.Cloud.run("getSummonerID", { summonerName: "Paluc0" }, {
	success: function(summonerID){

	},
	error: function(error){

	}
});*/
