SongModel = Backbone.Model.extend({
    defaults: {
        title: "Born to be Wild",
        artist: "Steppenwolf"
    },
    initialize: function() {
        console.log("model initialized");
    },
    update: function(data) {
        // pass in data
        this.set();
    }
});

SongCollection = Backbone.Collection.extend({
	model: SongModel
});

AppView = Backbone.View.extend({
	template: _.template($("#app-template").html()),

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
	addOne: function() {
		console.log("adding a song");
	},
});


// initializations
test = new SongModel();
Songs = new SongCollection();
Songs.add(test);
App = new AppView();
