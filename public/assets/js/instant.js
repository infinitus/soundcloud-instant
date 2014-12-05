$(function() {

  var xhr;
  var _url = location.protocol + '//' + location.host;
  var currentPlayingIndex = 0;

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
        playPrevTrack();
        break;
      case 40:
        playNextTrack();
        break;
    }
  })

  function playPrevTrack() {
    if (currentPlayingIndex == 0) {
      return;
    }
    results = JSON.parse(localStorage.getItem("results"));
    currentPlayingIndex--;
    loadWidgetURI(results[currentPlayingIndex]);
  }

  function playNextTrack() {
    results = JSON.parse(localStorage.getItem("results"));
    if (currentPlayingIndex == results.length - 1) {
      return;
    }
    currentPlayingIndex++;
    loadWidgetURI(results[currentPlayingIndex]);
  }

  function loadWidgetURI(uri) {
    widget.load(uri, { auto_play: true, visual: true });
  }

  function instantSearch(query) {
    if (xhr && xhr.readyState != 4) { xhr.abort(); }
    xhr = $.get(_url + "/search", { q: query }, function(uri_results) {
      currentPlayingIndex = 0; 
      localStorage.setItem("results", uri_results);
      uri = JSON.parse(uri_results)[currentPlayingIndex];
      loadWidgetURI(uri);
      // $.post(_url + "/save", { uri: uri }, function(_) {} );
    });
  }

})
