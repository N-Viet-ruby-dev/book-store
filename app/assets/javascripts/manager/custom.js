$(document).ready(function() {
  var newCharts;
  var chartOrderDetails;
  var month;

  $('.order-year').click(function(){
    $('#myChartByMonth').remove();
    $('#chartOrderDetails').remove();
    var year = $('.order-year').val();
    if (year) {
      $.ajax({
        url: '/manager/charts/order_by_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year
        },
        success: function(data) {
          responseChart(data);
        }
      });
    } else {
      $('#myChart').empty();
    }
  });

  $(document).on('click', '#myChart', function(evt){
    var activePoints = newCharts.getElementsAtEvent(evt);
    var year = $('.order-year').val();
    if (activePoints[0]) {
      var chartData = activePoints[0]['_chart'].config.data;
      var idx = activePoints[0]['_index'];
      var label = chartData.labels[idx];
      month = label;
      // var value = chartData.datasets[0].data[idx];
      if(label) {
        $.ajax({
          url: '/manager/charts/order_by_month',
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
            var chartByYear = new Chart(ctx, {
              type: 'line',
              data: {
                labels : keys,
                datasets : [
                  {
                    label: "Number oder",
                    backgroundColor: "#B0E0E6",
                    data: values,
                    fill: false
                  }
                ]
              },
              options: {
                title: {
                  display: true,
                  text: 'Number Order By Month',
                  fontSize: 15
                },
                legend: {
                  display: true,
                  labels: {
                    fontColor: '#A0522D'
                  }
                },
                scales: {
                  yAxes: [{
                    ticks: {
                      beginAtZero: true
                    }
                  }]
                }
              }
            });
            chartOrderDetails = chartByYear;
          }
        });
      } else {
        return false;
      }
    }
  });

  $(document).on('click', '#myChartByMonth', function(evt){
    var activePoints = chartOrderDetails.getElementsAtEvent(evt);
    if (activePoints[0]) {
      var chartData = activePoints[0]['_chart'].config.data;
      var idx = activePoints[0]['_index'];
      var label = chartData.labels[idx];
      var year = $('#year').val();
      if(label) {
        $.ajax({
          url: '/manager/charts/order_details_by_date',
          type: 'GET',
          dataType: 'JSON',
          data: {
            day: label,
            month: month,
            year: year
          },
          success: function(data) {
            var keys = [];
            var values = [];
            $.each(data, function(key, value) {
              keys.push(value[0]);
              values.push(value[1]);
            });
            $('#chartOrderDetails').remove();
            $('.chart_oder_details').append('<canvas id="chartOrderDetails"></canvas>');
            var ctx = $('#chartOrderDetails');
            var chartByYear = new Chart(ctx, {
              type: 'line',
              data: {
                labels : keys,
                datasets : [
                  {
                    label: "quantity",
                    backgroundColor: "#B0E0E6",
                    data: values,
                  }
                ]
              },
              options: {
                title: {
                  display: true,
                  text: 'All Number Books By Day',
                  fontSize: 15
                },
                legend: {
                  display: true,
                  labels: {
                    fontColor: '#A0522D'
                  }
                },
                scales: {
                  yAxes: [{
                    ticks: {
                      beginAtZero: true
                    }
                  }]
                }
              }
            });
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

  function refreshPage() {
    var year = (new Date).getFullYear();
    $.ajax({
      url: '/manager/charts/order_by_year',
      type: 'GET',
      dataType: 'JSON',
      data: {
        year: year
      },
      success: function(data) {
        responseChart(data);
      }
    });
  }

  function responseChart(data) {
    $('#myChart').remove();
    $('.to_day_order').append('<canvas class="chart_by_year" id="myChart"></canvas>');
    var keys = Object.keys(data);
    var values = Object.values(data);
    var ctx = $('#myChart');
    var chartByYear = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: keys,
        datasets: [
          {
            label: "Number oder",
            backgroundColor: "#A52A2A",
            data: values
          }
        ]
      },
      options: {
        title: {
          display: true,
          text: 'Number Order By Year',
          fontSize: 15
        },
        legend: {
          display: true,
          labels: {
            fontColor: '#A52A2A'
          }
        },
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    });
    newCharts = chartByYear;
  }

  $('.btn_compare').click(function() {
    var year1 = $('#year').val();
    var year2 = $('#year_2').val();
    if (year1 && year2) {
      $.ajax({
        url: 'manager/charts/chart_compare_the_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year1: year1,
          year2: year2
        },
        success: function(data) {
          data1 = data.year1;
          data2 = data.year2;
          $('#compare-charts').remove();
          $('.compare-charts').append('<canvas class="chart_by_year" id="compare-charts"></canvas>');
          var keys1 = Object.keys(data1);
          var values1 = Object.values(data1);
          var values2 = Object.values(data2);
          var ctx = $('#compare-charts');
          var chartByYear = new Chart(ctx, {
            type: 'bar',
            data: {
              labels: keys1,
              datasets: [
                {
                  label: "Number oder " + year1,
                  backgroundColor: "#A52A2A",
                  data: values1
                },
                {
                  label: "Number oder " + year2,
                  backgroundColor: "blue",
                  data: values2
                }
              ]
            },
            options: {
              title: {
                display: true,
                text: 'Quantity Order Chart For Two Years',
                fontSize: 15
              },
              legend: {
                display: true,
                labels: {
                  fontColor: '#A52A2A'
                }
              },
              scales: {
                yAxes: [{
                  ticks: {
                    beginAtZero: true
                  }
                }]
              }
            }
          });
        }
      });
    }
  });

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
              text: 'Quantity Order Chart For Two Years',
              fontSize: 15
            },
            legend: {
              display: true,
              labels: {
                fontColor: '#A52A2A'
              }
            }
          }
        });
      }
    });
  });
});
