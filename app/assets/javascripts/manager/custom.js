$(document).ready(function() {
  var yearChart;
  var bgColors

  // Charts Order by the month in year
  $(document).on('click', '#myChart', function(event){
    debugger
    var activePoints = yearChart.getElementsAtEvent(event);
    var year = $('.order-year').val();
    if (activePoints[0]) {
      var chartData = activePoints[0]['_chart'].config.data;
      var idx = activePoints[0]['_index'];
      var label = chartData.labels[idx];
      month = label;
      debugger
      // var value = chartData.datasets[0].data[idx];
      if(label) {
        $.ajax({
          url: '/manager/charts/revenue_in_month',
          type: 'GET',
          dataType: 'JSON',
          data: {
            month: label,
            year: year
          },
          success: function(data) {
            $('#myChartByMonth').remove();
            $('.to_month_order').append('<canvas id="myChartByMonth"></canvas>');
            var keys = Object.keys(data);
            var values = Object.values(data);
            var ctx = $('#myChartByMonth');
            responseBarChart('horizontalBar', keys, values, month, 'Revenue In ' + month + ' ' + year, ctx, '#008080', '#008080', '#3e95cd', 'Currency($)', 'Day' );
          }
        });
      } else {
        return false;
      }
    }
  });

  $('.with-year').click(function(){
    var year = $('#year').val();
    if (year) {
      $.ajax({
        url: '/manager/charts/compare_between_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year
        },
        success: function(data) {
          $('#year_2').empty();
          for(var i in data) {
            var option = '<option value=' + data[i] + '>' + data[i] + '</option>';
            $('#year_2').append(option);
          }
        }
      });
    }
    $('#year_2').show();
    $('.btn_compare').show();
  });

  refreshPage();

  // auto load ajax after load page, displayed order by the year
  function refreshPage() {
    var year = (new Date).getFullYear();
    $.ajax({
      url: '/manager/charts/revenue_in_year',
      type: 'GET',
      dataType: 'JSON',
      data: {
        year: year
      },
      success: function(data) {
        $('#myChart').remove();
        $('.to_day_order').append('<canvas class="chart_by_year" id="myChart"></canvas>');
        var keys = Object.keys(data);
        var values = Object.values(data);
        var ctx = $('#myChart');
        responseBarChart('bar', keys, values, year, 'Revenue In ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Month', 'Currency($)');
      }
    });
  }

  // function to callback Charts
  function responseBarChart(type='', keys, values, label='', text='', ctx, backgroundColor='', fontColor='', borderColor='', xLabel, yLabel) {
    var chartByYear = new Chart(ctx, {
      type: type,
      data: {
        labels: keys,
        datasets: [
          {
            label: label,
            backgroundColor: backgroundColor,
            data: values,
            borderColor: borderColor,
            fill: false
          }
        ]
      },
      options: {
        title: {
          display: true,
          text: text,
          fontSize: 15
        },
        legend: {
          display: true,
          labels: {
            fontColor: fontColor
          }
        },
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            },
            scaleLabel: {
              display: true,
              labelString: yLabel
            }
          }],
          xAxes: [{
            ticks: {
              beginAtZero: true
            },
            scaleLabel: {
              display: true,
              labelString: xLabel
            }
          }]
        },
        tooltips: {
          intersect: false
        }
      }
    });
    yearChart = chartByYear;
  };

  // Charts compare between 2 year
  $('.compare-year').click(function() {
    years = [];
    yearChart.data.datasets.forEach(function(dataset){
      years.push(dataset.label);
    });
    var year = $('#year').val();
    if ( !years.includes(year) ) {
      $.ajax({
        url: '/manager/charts/revenue_in_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year,
        },
        success: function(data) {
          var values = Object.values(data);
          dataset = {
            label: year,
            backgroundColor: getRandomColor(),
            data: values,
            borderColor: '#fff',
            fill: false
          };
          addData(yearChart, dataset);
          // responseBarChart('bar', keys, [values1, values2], [year1, year2], 'Revenue In ' + year1 + ' AND' + year2, ctx, '#A52A2A', '#A52A2A', '');
        }
      });
    }
  });

  // Charts compare between the year
  $('#to_year').click(function() {
    var from_year = $('#from_year').val();
    var to_year = $('#to_year').val();
    $.ajax({
      url: 'manager/charts/statistics_by_the_year',
      type: 'GET',
      dataType: 'JSON',
      data: {
        year1: from_year,
        year2: to_year
      },
      success: function(data) {
        $('#chart_statistics').remove();
        $('.chart_statistics_the_year').append('<canvas class="chart_statistics_the_year" id="chart_statistics"></canvas>');
        var keys = Object.keys(data);
        var values = Object.values(data);
        var ctx = $('#chart_statistics');
        var chartByYear = new Chart(ctx, {
          type: 'doughnut',
          data: {
            labels: keys,
            datasets: [
              {
                label: "Number oder",
                backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f"],
                data: values,
                fill: false
              }
            ]
          },
          options: {
            title: {
              display: true,
              text: 'Quantity Order Chart For In The Years',
              fontSize: 15
            },
            legend: {
              display: true,
              labels: {
                fontColor: '#A52A2A'
              }
            },
            // tooltips: {
            //   enabled: false
            // },
            plugins: {
              datalabels: {
                formatter: (value, ctx) => {
                  let sum = 0;
                  let dataArr = ctx.chart.data.datasets[0].data;
                  dataArr.map(data => {
                    sum += data;
                  });
                  let percentage = (value*100 / sum).toFixed(2)+"%";
                  return percentage;
                },
                color: '#fff',
              }
            }
          }
        });
      }
    });
  });

  function addData(chart, dataset) {
    chart.data.datasets.push(dataset);
    chart.options.title.text += " and " + dataset.label;
    chart.update();
  }

  function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

});

