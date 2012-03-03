
function makeBox(song) {
	var title = song.get("title");
	var album = song.get("album");
	var artist = song.get("artist");
	var art = song.get("art");
	var rank = song.get("rank");

	var box = document.createElement("div");
	var title = document.createTextNode(title);
	var img = document.createElement("img");

	box.className = "box rank" + rank;
	img.src = "http://userserve-ak.last.fm/serve/300x300/"+art+".png";
	img.className = "rank"+rank;
	box.appendChild(img);
	return box;
}

function appendBox(song, container) {
	var $box = $(makeBox(song));
	//container.append($box);
	container.append($box).masonry('appended', $box);
}

$(function() {
	var $container = $("#content");
	$container.masonry({
		itemSelector: ".box",
		columnWidth: 100
	});
	// 
	// alert(Songs.length);
	for(var i = 0; i < Songs.length; i++) {
		appendBox(Songs.models[i], $container);
	}
});
