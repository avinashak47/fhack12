var videoPlaying = false;
var audioPlaying = false;

$("body").click(function() { killVideo(); });

function killVideo() {
	if(videoPlaying) {
		$("#video").remove();
		videoPlaying = false;
	}
}

function killAudio() {
	if(audioPlaying) {
		$(".jp-stop").click();
		$("#jp_container_1").hide();
		audioPlaying = false;
	}
}



SongModel = Backbone.Model.extend({
    defaults: {
        title: "Born to be Wild",
        album: "Steppenwolf",
        artist: "Steppenwolf",
        art: "52661047",
        rank: 3
    },
    initialize: function() {
        console.log("model initialized");
    },
    update: function(data) {
        // pass in data
        this.set();
    }
});

SongView = Backbone.View.extend({


	template: _.template($("#song-template").html()),

	events: {
		"hover .overlay0"	: "toggleButtons",
		"hover .overlay1"	: "toggleButtons",
		"hover .overlay2"	: "toggleButtons",
		"click .videoButton"	: "playVideo",
		"click .audioButton"	: "playAudio"
	},

	initialize: function(options) {
		this.model.bind('change', this.render, this);
		this.render();
	},

	render: function(){
		console.log("rendering view");

		/*var query = "http://query.yahooapis.com/v1/public/yql?q=%20SELECT%20*%20FROM%20lastfm.album.getinfo%20WHERE%20api_key%3D%22b25b959554ed76058ac220b7b2e0a026%22%20and%20artist%3D%22"+escape(this.model.get("artist"))+"%22%20and%20album%3D%22"+escape(this.model.get("album"))+"%22&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";

		var link = "poop";
		var m = this.model;
		$.get(query,
			function(data) {
				var link = data.query.results.lfm.album.image[3].content;
				m.set("art", link);
			},
			"json");*/
		var html = this.template(this.model.toJSON());
		//$("#sample").html();
		//console.log(html);
		$(this.el).html(html);
		return this;
	},

	toggleButtons: function() {
		this.$(".links").toggle();
	},

	playVideo: function() {
		if(videoPlaying) killVideo();
		if(audioPlaying) killAudio();
		var q = this.model.get("artist") +" "+ this.model.get("title");
		var query = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20youtube.search%20where%20query%3D%22"+escape(q)+"%22&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
		console.log(query);
	$.get(query,
            function (data) {
                var id = data.query.results.video[0].id;
		$("#content").append($('<iframe id="video" style="margin:auto; position:fixed; left:28%" width="560" height="315" src="http://www.youtube.com/embed/'+id+'" frameborder="0" allowfullscreen></iframe>'));
		videoPlaying = true;
            }, 
            "json");
	},

	playAudio: function() {
		if(videoPlaying) killVideo();
		if(audioPlaying) killAudio();
		var artist = this.model.get("artist");
		var title = this.model.get("title");
		//var query = "http://itunes.apple.com/search?term="+escape(artist).replace(/%20/g, "+")+"+"+escape(title).replace(/%20/g,"+");

		var query = "http://developer.echonest.com/api/v4/song/search?api_key=N6E4NIOVYMTHNDM8J&format=json&results=1&artist="+escape(artist)+"&title="+escape(title)+"&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks";
		var url = "";
		$.get(query,
			function(data) {
				url = data.response.songs[0].tracks[0].preview_url;
				$("#jp_container_1").jPlayer("setMedia", url);
				console.log(url);
			}, 
			"json");
		$("#jp_container_1").show();
		$(".jp-title ul li").html(artist + " - " + title);
		$(".jp-play").click();
		audioPlaying = true;
	}
	
});

SongCollection = Backbone.Collection.extend({
	model: SongModel
});

AppView = Backbone.View.extend({
	template: _.template($("#app-template").html()),	

	events: {
		"click .rank1" : "test"
	},

	initialize: function(options) {
		console.log("application initialized");
		Songs.bind("add", this.addOne, this);
		Songs.bind("all", this.render, this);
		// Songs.fetch();
	},
	
	render: function() {
		console.log("render application");
		// this.$("").html(this.template());
	},
	addOne: function(song, $container) {
		console.log("adding a song");
		var view = new SongView({model: song});
		var view_render = $(view.render().el);
		
		$container.append(view_render).masonry('appended', view_render);
	},
	test: function() {
		console.log("test click appview event");
	}
});


// initializations
var i;
var s = [];
Songs = new SongCollection();

// simulation
var titles = ["Born to be Wild", "Party Rock", "I Want It That Way", "Rolling in the Deep", "Not Afraid"];
var albums = ["Steppenwolf", "Party Rock", "Millennium", "21", "Recovery"];
var artists = ["Steppenwolf", "Lmfao", "Backstreet Boys", "Adele", "Eminem"];
var arts = ["52661047", "70529764", "70938188", "55125087", "68343678"];
for (i = 0; i < 20; i++) {
	var ind = Math.floor(Math.random()*5);
	console.log("index " + ind);
	Songs.add(new SongModel({
		title: titles[ind],
        album: albums[ind],
        artist: artists[ind],
        art: arts[ind],
        rank: Math.floor(Math.random()*3) 
     }));
} 

$(function() {
	App = new AppView();

	$container = $("#content");
	$container.masonry({
		itemSelector: ".song",
		isFitWidth: true,
		columnWidth: 100
	});
	
	for(var i = 0; i < Songs.length; i++) {
		App.addOne(Songs.models[i], $container);
	}
	//var test = new SongModel();
	//var view = new SongView({ model: test });

//	App.addOne(test, $container);
});
