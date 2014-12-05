$(function() {

  var xhr;
  var _url = location.protocol + '//' + location.host;

  var iframeElement = document.querySelector('iframe');
  var widget = SC.Widget(iframeElement); // reference to widget object

  $("#search_box").keyup(function(event) {
    var query = $("#search_box").val().trim();
    if (query == "" || localStorage.getItem("query") == query) { return; }
    localStorage.setItem("query", query);
    instantSearch(query);
  });

  $(document.documentElement).keydown(function(e) {
    switch (e.keyCode) {
      case 38:
        console.log("pressed up");
        playPrevTrack();
        break;
      case 40:
        console.log("press down");
        playNextTrack();
        break;
    }
  })

  function playPrevTrack() {
  }

  function playNextTrack() {
  }

  function instantSearch(query) {
    if (xhr && xhr.readyState != 4) { xhr.abort(); }
    xhr = $.get(_url + "/search", { q: query }, function(uri) {
      widget.load(uri, { auto_play: true, visual: true })
        $.post(_url + "/save", { uri: uri }, function(_) {} );
    });
  }

})
