

/**
 * Get total of all sold
 */
var CreateTotalChart = function($el, data) {
  
  var maxPoint = data.data[0];
  for ( var i in data.data ) {
    var point = data.data[i]; 
    if ( maxPoint.y < point.y ) {
      maxPoint = point;
    }
  }
  
  if ( maxPoint ) {
    point['sliced']   = true;
    point['selected'] = true;
  }

  var chartConfig = {
    chart: {
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false,
      type: 'pie'
    },
    title: {
      text: 'All drinks. Starting from the beginning.'
    },
    tooltip: {
      pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
         enabled: true,
         format: '<b>{point.name}</b>: {point.y} ({point.percentage:.1f} %)',
         style: {
           color: 'white'
          },
        },
        showInLegend: true
      }
    },
    series: [ data ]
  };

  // Build chart
  $el.highcharts(chartConfig);
};

/**
 * New line graph
 */
var CreateLineGraph = function($el, data) {
  
  // Preparte timeseries data
  for ( var i in data ) {
    var series = data[i];
    for ( var j in series.data ) {
      var point = series.data[j];
      point[0] = Date.parse(point[0]);
    }
  }


  var chartConfig = {
        title: {
            text: 'Drinks'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            },
            title: {
                text: 'Date'
            }
        },
        yAxis: {
            title: {
                text: 'Sold drinks'
            },
            min: 0
        },
        tooltip: {
            headerFormat: '<b>{series.name}</b><br>',
            pointFormat: '{point.x:%e. %b}: {point.y:.2f} m'
        },

        /*
        plotOptions: {
            spline: {
                marker: {
                    enabled: true
                }
            }
        },
        */

        series: data
  };
  // Build chart
  $el.highcharts(chartConfig);
};


$(document).ready(function () {
  var $chartTotal       = $('.chart-total');
  var $chartDrinksTimes = $('.chart-drinks-times');

  $.getJSON( '/stats/drinks_total.json', function(series) {
    CreateTotalChart($chartTotal, series);
  });

  $.getJSON( '/stats/drinks_times.json', function(series) {
    CreateLineGraph($chartDrinksTimes, series);
  });
});
