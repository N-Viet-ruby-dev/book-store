$(document).ready(function() {
  var yearChart;
  var monthChart;
  var totalChart;
  var bookChartInYear;

  if ($('#chart_revenue').length > 0 || $('#chart_books').length > 0 ) {
    refreshPage();
  };

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
            monthChart = responseBarChart('horizontalBar', keys, values, month, true, 'Revenue In ' + month + ' ' + year, ctx, getRandomColor(), '#008080', '#3e95cd', 'Currency($)', 'Day' );
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
          if ($('#myChart').length > 0 ) {
            addBarData(yearChart, dataset);
          } else {
            $('.to_day_order').append('<canvas class="chart_by_year" id="myChart"></canvas>');
            var values = Object.values(data);
            var keys = Object.keys(data);
            var ctx = $('#myChart');
            yearChart = responseBarChart('bar', keys, values, year, true, 'Revenue In ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Month', 'Currency($)')
          }
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
          monthChart = responseBarChart('bar', keys, values, '', false, 'Total Revenue The Year', ctx, color, color, color, 'Years', 'Currency($)');
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
          responseBarChart('bar', keys, values, year, true, 'Books Has Biggest Revenue '+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
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
          responseBarChart('bar', keys, values, year, true, 'Books Has Biggest Revenue '+month+'/'+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
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
          responseBarChart('bar', keys, values, book, true, 'Book quantity sold per month', ctx, color, color, color, 'Month', 'Books Quantity' );
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
          bookChartInYear = responseBarChart('horizontalBar', keys, values, year, true, 'Best Selling Books '+year , ctx, color, color, color, 'Quantity Books', 'Books' );
        }
      });
    } else {
      return false;
    }
  });

  $('#close_book_revenue_year').click(function() {
    $('#book_has_big_revenue').remove();
  });

  $('#close_best_sell_book_in_year').click(function() {
    $('#best_sell_book_in_year').remove();
  });

  $('#close_book_sold_per_month').click(function() {
    $('#best_sell_book_in_month').remove();
  });

  $('#close_book_revenue_in_month').click(function() {
    $('#book_has_big_revenue_in_month').remove();
  });

  $('#close_revenue_the_year').click(function() {
    $('#pieChart').remove();
  });

  $('#close_revenue_the_month_of_year').click(function() {
    $('#myChart').remove();
    arr = [];
  });

  $('#close_revenue_in_month').click(function() {
    $('#myChartByMonth').remove();
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
        yearChart = responseBarChart('bar', keys, values, year, true, 'Revenue In ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Month', 'Currency($)');
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
        bookChartInYear = responseBarChart('horizontalBar', keys, values, year, true, 'Best Selling Books ' + year, ctx, '#A52A2A', '#A52A2A', '', 'Books Quantity', 'Books');
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
        responseBarChart('bar', keys, values, year, true, 'Books Has Biggest Revenue '+year , ctx, color, color, color, 'Books Name', 'Currency($)' );
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
          responseBarChart('bar', keys, values, '', false, 'Total Revenue The Year', ctx, color, color, color, 'Years', 'Currency($)');
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
          monthChart = responseBarChart('horizontalBar', keys, values, month, true, 'Revenue In ' + month + ' ' + year, ctx, getRandomColor(), '#008080', '#3e95cd', 'Currency($)', 'Day' );
        }
      });
    } else {
      return false;
    }

  }

  // function to callback Charts
  function responseBarChart(type='', keys, values, label='', displays, title='', ctx, backgroundColor='', fontColor='', borderColor='', xLabel, yLabel) {
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
          display: displays
        },
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            },
            scaleLabel: {
              display: true,
              labelString: yLabel,
              fontSize: 17
            }
          }],
          xAxes: [{
            ticks: {
              beginAtZero: true
            },
            scaleLabel: {
              display: true,
              labelString: xLabel,
              fontSize: 17
            }
          }]
        },
        plugins: {
          datalabels: {
            color: 'white',
            textAlign: 'center',
            font: {
              weight: 'bold',
              size: 10
            }
          }
        }
      }
    });
    return chartByYear;
  };

  function addBarData(chart, dataset) {
    chart.data.datasets.push(dataset);
    chart.options.title.text += " and " + dataset.label;
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

  // export file pdf
  $('#downloadPdf').click(function(event) {
    var pdf = new jsPDF('l');
    $("canvas").each(function(index) {
      var imgData = $(this)[0].toDataURL('image/png');
      pdf.addImage(imgData, 'PNG', 20, 20, 250, 180);
      if ( index < $("canvas").length - 1 ) {
        pdf.addPage();
      }
    });
    pdf.save('charts.pdf');
  });

});
