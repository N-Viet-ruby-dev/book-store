$(document).ready(function() {
  // var canvasMyChart = document.getElementById("myChart");
  var newCharts;
  $('.order-year').click(function(){
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
            var canvasMyChart = document.getElementById("myChartByMonth");
            var ctx = canvasMyChart.getContext("2d");
            var chartByYear = new Chart(ctx, {
              type: 'line',
              data: {
                labels : keys,
                datasets : [
                  {
                    label: "Number oder",
                    backgroundColor: "#B0E0E6",
                    data: values
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
          }
        });
      } else {
        return false;
      }
    }
  });
});
