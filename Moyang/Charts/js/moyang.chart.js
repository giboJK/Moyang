var chartObjects = [];

const CHART_COLOR = {
    LMT: {
        background: 'rgba(242, 241, 243, 1)',
        line: 'rgba(85, 61, 172, 1)',
        dot: 'rgba(85, 61, 172, 1)',
        vertical: 'rgba(178, 176, 182, 1)',
        tickX: 'rgba(96, 95, 99, 1)',
    },
    MG: {
        background: 'rgba(96, 95, 99, 1)',
        line: 'rgba(89, 171, 249, 1)',
        dot: 'rgba(89, 171, 249, 1)',
        vertical: 'rgba(178, 176, 182, 1)',
        tickX: 'rgba(96, 95, 99, 1)',
    },
    DEFAULT_BACK: 'rgba(242, 241, 243, 1)',

    BLACK: 'rgba(40, 26, 16, 1)',
    RED: 'rgba(176, 58, 52, 1)',
    DIVE: 'rgba(89, 171, 249, 1)',
    SKI: 'rgba(255, 255, 255, 1)',
    VOLLEYBALL: 'rgba(85, 61, 172, 1)',
    CYCLE02: 'rgba(178, 176, 182, 0.5)',
    HOCKEY: 'rgba(36, 39, 42, 1)',
    GREEN: 'rgba(0, 173, 111, 1)',
    WHITE_GREEN: 'rgba(27, 224, 153, 1)',
    GRAY: 'rgba(223, 220, 216, 1)',
    DOUGHNUT_VALUE: 'rgba(211, 104, 85, 1)',
    DOUGHNUT_OTHER: 'rgba(210, 206, 200, 1)',
};
const CHART_FONT = "SF Pro Text"; // roboto??
const CHART_FONT_SIZE = {
    TICKS: 14,
    VALUES: 16,
    DOUGHNUT_CENTER: 24,
};

var language;
if (window.navigator.languages) {
    language = window.navigator.languages[0];
} else {
    language = window.navigator.userLanguage || window.navigator.language;
}

/**
 * chart plugin
 * 차트의 백그라운드 영역 색 변경
**/
const chartPluginCanvasBackgroundColor = {
    id: 'chartPluginCanvasBackgroundColor',
    afterDraw: (thisChart) => {
        const buttomMargin = 2;
        const ctx = thisChart.canvas.getContext('2d');
        //console.log(thisChart);
        ctx.save();
        ctx.globalCompositeOperation = 'destination-over';
        //var chartHeight = thisChart.chartArea.bottom + thisChart.chartArea.top + buttomMargin;
        var chartHeight = thisChart.offsetHeight;//.bottom + thisChart.chartArea.top + buttomMargin;
        var canvasWidth = thisChart.ctx.offsetWidth;
        var canvasHeight = thisChart.ctx.offsetHeight;
        ctx.fillStyle = CHART_COLOR.DEFAULT_BACK;
        ctx.fillRect(0, 0, canvasWidth, canvasHeight);
        ctx.restore();
    }
};



/**
 * chart plugin
 * 라인차트에서 X축에 있는 Tick에 해당하는 값이 null인 경우 점선으로 연결
**/
const chartPluginDrawUnLinkedLines = {
    id: 'chartPluginDrawUnLinkedLines',
    afterDatasetsDraw: (thisChart) => {
        const thisData = thisChart.data.datasets[0].data;
        const thisLabels = thisChart.data.labels;
        const thisContext = thisChart.canvas.getContext('2d');

        let xAxis = thisChart.scales['x'];
        let yAxis = thisChart.scales['y'];
        let prevValue = null;
        let prevLabel = null;

        thisContext.save();
        thisContext.setLineDash([6, 6]);
        thisContext.lineWidth = 2;

        for (var i = 0; i < thisData.length; i++) {
            if (thisData[i] != null) {
                if (prevValue != null) {
                    // draw dash line
                    let startX = xAxis.getPixelForValue(prevLabel);
                    let startY = yAxis.getPixelForValue(prevValue);
                    let endX = xAxis.getPixelForValue(thisLabels[i]);
                    let endY = yAxis.getPixelForValue(thisData[i]);
                    thisContext.beginPath();
                    thisContext.moveTo(startX, startY);
                    thisContext.lineTo(endX, endY);
                    thisContext.closePath();
                    thisContext.stroke();
                }
                prevValue = thisData[i];
                prevLabel = thisLabels[i];
            }
        }

        thisContext.restore();
    }
};


/**
 * radar chart draw circle
**/
const chartPluginRadarFillCircle = {
    id: 'chartPluginRadarFillCircle',
    beforeDraw: (thisChart) => {
        const thisData = thisChart.data;
        const thisContext = thisChart.canvas.getContext('2d');

        let axisR = thisChart.scales['r'];
        let x = axisR.xCenter;
        let y = axisR.yCenter;
        let r = axisR.drawingArea;
        let e = 2*Math.PI;
        let color = ['rgba(89, 171, 249, 1)', 'rgba(158, 214, 255, 1)', 'rgba(222, 241, 248, 1)'];
        let rDesc = r / color.length;
        
        thisContext.save();

        for (var i = 0; i < 3; i++) {
            let drawR = r - (i * rDesc);
            thisContext.beginPath();
            thisContext.fillStyle = color[i];
            thisContext.arc(x, y, drawR, 0, e);
            thisContext.fill();
            thisContext.closePath();
        }

        thisContext.restore();
    }
};

function createChartLineMG(chartId, chartType, today) {
    const canvas = document.getElementById(chartId);
    var colors = CHART_COLOR[chartType];
    var pointColor = colors.line;

    const myChart = new Chart(canvas, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: chartId,
                data: [],
                borderColor: pointColor,
                pointBackgroundColor: pointColor,
                pointBorderColor: pointColor,
                pointBorderWidth: 0,
                borderWidth: 2,
                pointRadius: 3.4
            }],
            chartType: chartType,
        },
        options: {
            spanGaps: true,
            animation: false,
            plugins: {
                legend: false,
                tooltip: {
                     enabled: false,
                },
            },
            layout: {
                padding: {
                    //right: 20,
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    display: true,
                    grid: {
                        display: true,
                        drawBorder: false,
                        borderDash: [3, 3],
                        lineWidth: 1,
                        color: colors.vertical,
                        borderWidth: 0,
                    },
                    ticks: {
                        autoSkip: false,
                        maxRotation: 0,
                        minRotation: 0,
                        color: CHART_COLOR.SKI,
                        padding: 8,
                        font: {
                            weight: "500",
                            size: 13,
                        },
                        callback: function(val, index) {
                            if (index % 7 != 0) {
                                return null
                            }

                            let todayDate = new Date(today);
                            let date = new Date(this.getLabelForValue(val));

                            if (date.getDate() - 7 <= 0) {
                                if (todayDate.getMonth() === date.getMonth()) {

                                let dateString = date.toLocaleString(language, {
                                    month: 'short',
                                    day: '2-digit'
                                });
                                    return dateString
                                }
                            }
                            let day = date.toLocaleString(language, {
                                day: '2-digit'
                            });

                            return day
                          },
                    }
                },
                y: {
                    display: true,
                    grid: {
                        display: false,
                        drawBorder: false,
                        lineWidth: 0,
                    },
                    reverse: true,
                    ticks: {
                        display: true,
                        color: CHART_COLOR.DIVE,
                        stepSize: 1,
                        font: {
                            weight: "500",
                            size: 13,
                        },
                        callback: function(value, index, values) {
                            if (value == this.min) {
                                if (value > 0 ) {
                                    return ordinal_suffix_of(value)
                                }
                            } else if (value == this.max) {
                                if (value <= 100) {
                                    return ordinal_suffix_of(value)
                                }
                            } else if (value == 100) {
                                return ordinal_suffix_of(value)
                            } else if (value == 1) {
                                return ordinal_suffix_of(value)
                            }
                        }
                    },
                }
            }
        },
        plugins: [
            chartPluginCanvasBackgroundColor,
        ],
    });

    chartObjects[chartId] = myChart;
}


function createChartLine1(chartId, chartType) {
    const canvas = document.getElementById(chartId);
    var colors = CHART_COLOR[chartType];
    var pointColor = colors.line;

    const myChart = new Chart(canvas, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: chartId,
                data: [],
                borderColor: pointColor,
                pointBackgroundColor: pointColor,
                pointBorderColor: pointColor,
                pointBorderWidth: 0,
                borderWidth: 2,
                pointRadius: 3.4
            }],
            chartType: chartType,
        },
        options: {
            spanGaps: true,
            animation: false,
            plugins: {
                legend: false,
                tooltip: {
                     enabled: false,
                },
            },
            layout: {
                padding: {
                    //right: 20,
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    display: true,
                    grid: {
                        display: true,
                        drawBorder: false,
                        borderDash: [6, 6],
                        lineWidth: 1,
                        borderWidth: 0,
                    },
                    ticks: {
                        autoSkip: false,
                        maxRotation: 0,
                        minRotation: 0,
                        color: CHART_COLOR.BLACK,
                        font: {
                            weight: "500",
                            size: CHART_FONT_SIZE.TICKS,
                        },
                        callback: function(value, index, ticks) {
                            if (ticks.length == 7) {
                                return localMessage("weekDaysShort")[index];
                            } else if (ticks.length > 7) {
                                if (((index+1)%7) == 0) {
                                    return (index+1)+"";
                                }
                                if (index == 0) {
                                    return "";
                                }
                            }
                            return null;
                        }
                    }
                },
                y: {
                    display: false,
                    grid: {
                        display: false,
                        drawBorder: false,
                        lineWidth: 0,
                    },
                    ticks: {
                        display: false,
                    },
                }
            }
        },
        plugins: [
            chartPluginCanvasBackgroundColor,
        ],
    });

    chartObjects[chartId] = myChart;
}


function setDataChartLine1(chartId, values, dates) {
    var weekName = [];
    for (var i = 0; i < dates.length; i++) {
        weekName[i] = i;
    }

    var chart = chartObjects[chartId];

    chart.data.labels = weekName;
    chart.data.datasets[0].data = values;
    var nullIgnoreValues = values.filter(function(val) {
        return val !== null
    });
    var minValue = Math.min(...nullIgnoreValues);
    var maxValue = Math.max(...nullIgnoreValues);
    chart.options.scales.y.min = Math.max(minValue * 0.95, 0);
    chart.options.scales.y.max = Math.min(maxValue * 1.05, 200);
    chart.update();
}

function setDataChartLineMG(chartId, values, dates) {
    var chart = chartObjects[chartId];

    chart.data.labels = dates;
    chart.data.datasets[0].data = values;
    var nullIgnoreValues = values.filter(function(val) {
        return val !== null
    });
    
    var minValue = Math.min(...nullIgnoreValues);
    var maxValue = Math.max(...nullIgnoreValues);
    var min = minValue - 5;
    var max = maxValue + 5;
    var margin = parseInt((max - min) / 10)

    chart.options.scales.y.min = Math.max(minValue - 5, 1 - margin);
    chart.options.scales.y.max = Math.min(maxValue + 5, 100 + margin);
    chart.update();
}

function createChartRadar(chartId, chartType) {
    const canvas = document.getElementById(chartId);
    var colors = CHART_COLOR[chartType];
    var pointColor = CHART_COLOR.HOCKEY;
    const myChart = new Chart(canvas, {
        type: 'radar',
        data: {
            labels: [],
            datasets: [{
                label: chartId,
                data: [],
                borderColor: pointColor,
                pointBackgroundColor: pointColor,
                pointBorderColor: pointColor,
                pointBorderWidth: 0,
                borderWidth: 2,
                pointRadius: 3.4
            }],
            chartType: chartType,
        },
        options: {
            animation: false,
            plugins: {
                legend: false,
                tooltip: {
                     enabled: false,
                },
                datalabels: {
                    formatter: function(value, context) {
                        console.log({labels: context.chart.data.labels, context: context});
                        return context.chart.data.labels[context.dataIndex];
                    }
                },
            },
            layout: {
                padding: {
                    //right: 20,
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                r: {
                    angleLines: {
                        display: true,
                        borderDash: [6, 6],
                        color: CHART_COLOR.HOCKEY
                    },
                    pointLabels: {
                        font: {
                            size: CHART_FONT_SIZE.TICKS,
                            weight: "bold",
                        },
                        color: CHART_COLOR.SKI,
                        centerPointLabels: false,
                        callback: function(values, index, other) {
                            return values;
                        }
                    },
                    grid: {
                        circular: true,
                        display: false,
                    },
                    beginAtZero: true,
                    ticks: {
                        autoSkip: false,
                        maxRotation: 0,
                        minRotation: 0,
                        display: false,
                        font: {
                            weight: "500",
                            size: CHART_FONT_SIZE.TICKS,
                        },
                    }
                }
            }
        },
        plugins: [
            chartPluginCanvasBackgroundColor,
            chartPluginRadarFillCircle,
        ],
    });

    chartObjects[chartId] = myChart;
}


function setDataChartRadar(chartId, values, labels, unit) {
    var chart = chartObjects[chartId];
    
    for (var i = 0; i < labels.length; i++) {
        chart.data.labels[i] = [labels[i], values[i].toFixed(2) + " " + unit];
    }
    chart.data.datasets[0].data = values;
    chart.update();
}


function createChartLineMQ(chartId, chartType, isLeft, isRight) {
    const canvas = document.getElementById(chartId);
    var leftColor = CHART_COLOR.DIVE;
    var rightColor = CHART_COLOR.VOLLEYBALL;
    if (!isLeft) {
        leftColor = CHART_COLOR.CYCLE02;
    }
    if (!isRight) {
        rightColor = CHART_COLOR.CYCLE02;
    }

    const myChart = new Chart(canvas, {
        type: 'line',
        data: {
            labels: [],
            datasets: [
                {
                    label: chartId,
                    data: [],
                    order: 1,
                    borderColor: leftColor,
                    pointBackgroundColor: leftColor,
                    pointBorderColor: leftColor,
                    pointBorderWidth: 0,
                    borderWidth: 2,
                    pointRadius: 3.4
                },
                {
                    label: chartId,
                    data: [],
                    order: 0,
                    borderColor: rightColor,
                    pointBackgroundColor: rightColor,
                    pointBorderColor: rightColor,
                    pointBorderWidth: 0,
                    borderWidth: 2,
                    pointRadius: 3.4
                }
            ],
            chartType: chartType,
        },
        options: {
            spanGaps: true,
            animation: false,
            plugins: {
                legend: false,
                tooltip: {
                     enabled: false,
                },
            },
            layout: {
                padding: {
                    //right: 20,
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    display: true,
                    grid: {
                        display: true,
                        drawBorder: false,
                        borderDash: [3, 3],
                        lineWidth: 1,
                        borderWidth: 0,
                    },
                    ticks: {
                        autoSkip: false,
                        maxRotation: 0,
                        minRotation: 0,
                        color: CHART_COLOR.BLACK,
                        font: {
                            family: CHART_FONT,
                            weight: "500",
                            size: CHART_FONT_SIZE.TICKS,
                        },
                        callback: function(value, index, ticks) {
                            if (ticks.length == 7) {
                                return localMessage("weekDaysShort")[index];
                            } else if (ticks.length > 7) {
                                if (((index+1)%7) == 0) {
                                    return (index+1)+"";
                                }
                                if (index == 0) {
                                    return "";
                                }
                            }
                            return null;
                        }
                    }
                },
                y: {
                    display: false,
                    grid: {
                        display: false,
                        drawBorder: false,
                        lineWidth: 0,
                    },
                    ticks: {
                        display: false,
                        stepSize: 1,
                    },
                }
            }
        },
        plugins: [
            chartPluginCanvasBackgroundColor,
        ],
    });

    chartObjects[chartId] = myChart;
}


function setDataChartLineMQ(chartId, values, values2, dates, leftOn, rightOn) {

    var weekName = [];
    for (var i = 0; i < dates.length; i++) {
        weekName[i] = i;
    }

    var leftColor = CHART_COLOR.DIVE;
    var rightColor = CHART_COLOR.VOLLEYBALL;
    if (leftOn) {
        leftColor = CHART_COLOR.DIVE;
    } else {
        leftColor = CHART_COLOR.CYCLE02;
    }
    if(rightOn){
        rightColor = CHART_COLOR.VOLLEYBALL;
    }else{
        rightColor = CHART_COLOR.CYCLE02;
    }

    var chart = chartObjects[chartId];

    chart.data.labels = weekName;
    chart.data.datasets[0].data = values;
    chart.data.datasets[1].data = values2;

    chart.data.datasets[0].borderColor = leftColor;
    chart.data.datasets[0].pointBackgroundColor = leftColor;
    chart.data.datasets[0].pointBorderColor = leftColor;
    chart.data.datasets[1].borderColor = rightColor;
    chart.data.datasets[1].pointBackgroundColor = rightColor;
    chart.data.datasets[1].pointBorderColor = rightColor;

    
    var nullIgnoreValues = values.filter(function(val) {
        return val !== null
    });
    
    var nullIgnoreValues2 = values2.filter(function(val) {
        return val !== null
    });
    
    var minValue = Math.min(Math.min(...nullIgnoreValues), Math.min(...nullIgnoreValues2));
    var maxValue = Math.max(Math.max(...nullIgnoreValues), Math.max(...nullIgnoreValues2));
    chart.options.scales.y.min = minValue * 0.9 - 2;
    chart.options.scales.y.max = maxValue * 1.1;
    chart.update();
}

function ordinal_suffix_of(i) {
    var j = i % 10,
        k = i % 100;
    if (j == 1 && k != 11) {
        return i + "st";
    }
    if (j == 2 && k != 12) {
        return i + "nd";
    }
    if (j == 3 && k != 13) {
        return i + "rd";
    }
    return i + "th";
}
