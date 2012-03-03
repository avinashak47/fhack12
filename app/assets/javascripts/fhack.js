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
		"hover .subtitle"	: "toggleButtons"
	},

	initialize: function(options) {
		this.model.bind('change', this.render, this);
		this.render();
	},

	render: function(){
		console.log("rendering view");
		var html = this.template(this.model.toJSON());
		//$("#sample").html();
		//console.log(html);
		$(this.el).html(html);
		return this;
	},

	toggleButtons: function() {
		this.$(".links").toggle();
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

for (i = 0; i < 20; i++) {
	Songs.add(new SongModel({
		title: "Born to be Wild",
        album: "Steppenwolf",
        artist: "Steppenwolf",
        art: "52661047",
        rank: Math.floor(Math.random()*3) 
     }));
} 

$(function() {
	App = new AppView();

	$container = $("#content");
	$container.masonry({
		itemSelector: ".song",
		columnWidth: 100
	});
	
	for(var i = 0; i < Songs.length; i++) {
		App.addOne(Songs.models[i], $container);
	}
	//var test = new SongModel();
	//var view = new SongView({ model: test });

//	App.addOne(test, $container);
});
