
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
	return $(box);
}

function appendBox(song, container) {
	container.append(song).masonry('appended', $box);
}


