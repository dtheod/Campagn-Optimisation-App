var dimensionId = '%s';
var dimension = [0, 0];

$(document).on('shiny:connected', function(e) {
        dimension[0] = window.innerWidth;
        dimension[1] = window.innerHeight;
        Shiny.onInputChange(dimensionId, dimension);
      });

$(window).resize(function(e) {
        dimension[0] = window.innerWidth;
        dimension[1] = window.innerHeight;
        Shiny.onInputChange(dimensionId, dimension);
      })