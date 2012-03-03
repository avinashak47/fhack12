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
        rank: Math.floor(Math.random()*3) + 1
     }));
}
// Songs.add(s1);
App = new AppView();
