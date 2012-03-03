$(document).ready(function() {
	$("#jquery_jplayer").jPlayer({
    	ready: function (event) {
    		console.log("ready");
    		var $this = $(this);
 			$("h1").click(function(e) {
       			console.log("playing");
       			$this.jPlayer("setMedia", { m4a: "http://a1.mzstatic.com/us/r1000/008/Music/6d/e2/e7/mzi.vmmixjty.aac.p.m4a" });
        		$this.jPlayer("play");
        		e.preventDefault();
        	});
    	},
	swfPath: "javascripts",
    	    	supplied: "m4a"
	});
});
