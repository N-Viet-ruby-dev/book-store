$(document).ready(function() {
  var yearChart;
  var monthChart;
  var totalChart;
  var bookChartInYear;

  refreshPage();

  // Charts Order by the month in year
  $(document).on('click', '#myChart', function(event){
    var activePoint = yearChart.getElementAtEvent(event)[0];
    if (activePoint) {
      var month = activePoint['_model'].label;
      var year = activePoint['_model'].datasetLabel;
      if(month) {
        $.ajax({
          url: '/manager/charts/revenue_in_month',
          type: 'GET',
          dataType: 'JSON',
          data: {
            month: month,
            year: year
          },
          success: function(data) {
            $('#myChartByMonth').remove();
            $('.to_month_order').append('<canvas id="myChartByMonth"></canvas>');
            var keys = Object.keys(data);
            var values = Object.values(data);
            var ctx = $('#myChartByMonth');
            monthChart = responseBarChart('horizontalBar', keys, values, month, 'Revenue In ' + month + ' ' + year, ctx, getRandomColor(), '#008080', '#3e95cd', 'Currency($)', 'Day' );
          }
        });
      } else {
        return false;
      }
    }
  });

  //Charts compare between 2 year
  var arr = [(new Date).getFullYear().toString()];
  $('.year-1').click(function() {
    if (arr.includes($(this).val()) != true) {
      var year = $(this).val();
      arr.push(year);
    }
    if ( year) {
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
          addBarData(yearChart, dataset);
        }
      });
    } else {
      return false;
    }
  });

  // Charts compare between the year
  $('.year_2').click(function() {
    var year_1 = $('.year_1').val();
    var year_2 = $('.year_2').val();
    if (year_1 && year_2) {
      $.ajax({
        url: '/manager/charts/compare_between_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year_1: year_1,
          year_2: year_2
        },
        success: function(data) {
          $('#pieChart').remove();
          $('.pieChart').append('<canvas id="pieChart"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#pieChart');
          var color = []
          keys.forEach(function(){
            color.push(getRandomColor());
          });
          monthChart = responsePieChart(keys, values, 'Total Revenue The Year',ctx, color);
        }
      });
    } else {
      return false;
    }
  });

  $('.year_1').click(function() {
    var year_1 = $(this).val()
    if (year_1) {
      $.ajax({
        url: '/manager/charts/select_to_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year_1: year_1
        },
        success: function(data) {
          $('.year_2').empty();
          for(var i in data) {
            var option = '<option value=' + data[i] + '>' + data[i] + '</option>';
            $('.year_2').append(option);
          }
        }
      });
    } else {
      return false;
    }
  });

  // Top book has biggest revenue
  $('.sell1').click(function() {
    var year = $(this).val()
    if (year) {
      $.ajax({
        url: '/manager/chart_books/book_has_biggest_revenue',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year
        },
        success: function(data) {
          $('#month').empty();
          for(var i in data.month) {
            var option = '<option value=' + data.month[i] + '>' + data.month[i] + '</option>';
            $('#month').append(option);
          }
          $('#book_has_big_revenue').remove();
          $('.book_has_big_revenue').append('<canvas id="book_has_big_revenue"></canvas>');
          var keys = Object.keys(data.top);
          var values = Object.values(data.top);
          var ctx = $('#book_has_big_revenue');
          var color = getRandomColor();
          responseBarChart('bar', keys, values, year, 'Books Has Biggest Revenue '+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
        }
      });
    } else {
      return false;
    }
  });

  // Top book has biggest revenue by month
  $('#month').click(function() {
    var year = $('.sell1').val();
    var month = $(this).val();
    if (year && month) {
      $.ajax({
        url: '/manager/chart_books/book_has_biggest_revenue_in_month',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year,
          month: month
        },
        success: function(data) {
          $('#book_has_big_revenue_in_month').remove();
          $('.book_has_big_revenue_in_month').append('<canvas id="book_has_big_revenue_in_month"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#book_has_big_revenue_in_month');
          var color = getRandomColor();
          responseBarChart('bar', keys, values, year, 'Books Has Biggest Revenue '+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
        }
      });
    } else {
      return false;
    }
  });

  // Chart best selling book in month of year
  $(document).on('click', '#best_sell_book_in_year', function(evt) {
    var activePoint = bookChartInYear.getElementAtEvent(evt)[0];
    var year = activePoint['_model'].datasetLabel;
    var book = activePoint['_model'].label;
    if (year && book) {
      $.ajax({
        url: '/manager/chart_books/best_selling_books_in_month',
        type: 'GET',
        dataType: 'JSON',
        data: {
          book: book,
          year: year
        },
        success: function(data) {
          $('#best_sell_book_in_month').remove();
          $('.best_sell_book_in_month').append('<canvas id="best_sell_book_in_month"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#best_sell_book_in_month');
          var color = getRandomColor();
          responseBarChart('bar', keys, values, book, 'Quantity sold per month', ctx, color, color, color, 'Month', 'Quantity Books' );
        }
      });
    } else {
      return false;
    }
  });

  // Chart best selling books in year
  $('.select_year').click(function() {
    var year = $(this).val();
    if (year) {
      $.ajax({
        url: '/manager/chart_books/best_selling_books',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year: year
        },
        success: function(data) {
          $('#best_sell_book_in_year').remove();
          $('.best_sell_book_in_year').append('<canvas id="best_sell_book_in_year"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#best_sell_book_in_year');
          var color = getRandomColor();
          bookChartInYear = responseBarChart('horizontalBar', keys, values, year, 'Best Selling Books '+year , ctx, color, color, color, 'Quantity Books', 'Books' );
        }
      });
    } else {
      return false;
    }
  });

  // auto load ajax after load page, displayed order by the year
  function refreshPage() {
    var year = (new Date).getFullYear().toString();
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
        yearChart = responseBarChart('bar', keys, values, year, 'Revenue In ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Month', 'Currency($)');
      }
    });

    $.ajax({
      url: '/manager/chart_books/best_selling_books',
      type: 'GET',
      dataType: 'JSON',
      data: {
        year: year
      },
      success: function(data) {
        $('#best_sell_book_in_year').remove();
        $('.best_sell_book_in_year').append('<canvas class="best_sell_book_in_year" id="best_sell_book_in_year"></canvas>');
        var keys = Object.keys(data);
        var values = Object.values(data);
        var ctx = $('#best_sell_book_in_year');
        bookChartInYear = responseBarChart('horizontalBar', keys, values, year, 'Best Selling Books ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Number Books', 'Books');
      }
    });

    $.ajax({
      url: '/manager/chart_books/book_has_biggest_revenue',
      type: 'GET',
      dataType: 'JSON',
      data: {
        year: year
      },
      success: function(data) {
        $('#book_has_big_revenue').remove();
        $('.book_has_big_revenue').append('<canvas id="book_has_big_revenue"></canvas>');
        var keys = Object.keys(data.top);
        var values = Object.values(data.top);
        var ctx = $('#book_has_big_revenue');
        var color = getRandomColor();
        responseBarChart('bar', keys, values, year, 'Books Has Biggest Revenue '+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
      }
    });

    var year_1 = $('.year_1').val();
    var year_2 = (new Date).getFullYear() - 4;
    if (year_1 && year_2) {
      $.ajax({
        url: '/manager/charts/compare_between_year',
        type: 'GET',
        dataType: 'JSON',
        data: {
          year_1: year_1,
          year_2: year_2
        },
        success: function(data) {
          $('#pieChart').remove();
          $('.pieChart').append('<canvas id="pieChart"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#pieChart');
          var color = []
          keys.forEach(function(){
            color.push(getRandomColor());
          });
          monthChart = responsePieChart(keys, values, 'Total Revenue The Year',ctx, color);
        }
      });
    } else {
      return false;
    };

    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
    var date = new Date();
    var month = monthNames[date.getMonth()];
    if (month) {
      $.ajax({
        url: '/manager/charts/revenue_in_month',
        type: 'GET',
        dataType: 'JSON',
        data: {
          month: month,
          year: year
        },
        success: function(data) {
          $('#myChartByMonth').remove();
          $('.to_month_order').append('<canvas id="myChartByMonth"></canvas>');
          var keys = Object.keys(data);
          var values = Object.values(data);
          var ctx = $('#myChartByMonth');
          monthChart = responseBarChart('horizontalBar', keys, values, month, 'Revenue In ' + month + ' ' + year, ctx, getRandomColor(), '#008080', '#3e95cd', 'Currency($)', 'Day' );
        }
      });
    } else {
      return false;
    }
  }

  // function to callback Charts
  function responseBarChart(type='', keys, values, label='', title='', ctx, backgroundColor='', fontColor='', borderColor='', xLabel, yLabel) {
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
          text: title,
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
        to: 1
      }
    });
    return chartByYear;
  };

  function responsePieChart(key, value, title='', ctx, bgcolor) {
    var chart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: key,
        datasets: [
          {
            label: key,
            backgroundColor: bgcolor,
            data: value,
            borderColor: bgcolor,
            fill: false
          }
        ]
      },
      options: {
        title: {
          display: true,
          text: title,
          fontSize: 15
        },
        legend: {
          display: true,
          labels: {
            fontColor: "#000"
          }
        }
      }
    });
    return chart;
  };

  function addBarData(chart, dataset) {
    chart.data.datasets.push(dataset);
    chart.options.title.text += " and " + dataset.label;
    chart.update();
  };

  function addPieChartData(chart, dataset) {
    chart.data.labels.push(dataset.label);
    chart.data.datasets[0].data.push(dataset.data);
    chart.data.datasets[0].backgroundColor.push(dataset.color);
    chart.data.datasets[0].borderColor.push(dataset.color);
    chart.update();
  };


  function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  };

});

