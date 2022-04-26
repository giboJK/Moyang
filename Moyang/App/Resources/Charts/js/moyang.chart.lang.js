var CLIENT_LANG = "en";

const LOCALIZATION = {
	en: {
        YMD_UNIT: ["Year", "Month", "Day"],
        months: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        monthsFull: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        weekDays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        weekDaysShort: ["S", "M", "T", "W", "T", "F", "S"],
		legends: ["Low", "Avg.", "High"],
		intakeNutrition: ["Carbs", "Protein", "Fat"],
		chartTitle1: ["VIS-FL", "SQ-FL", "Weight", "Waist Size"],
		chartTitle2: ["VIS-FL", "Body Fat %", "Weight", "Waist Size"],
		chartTitleSub1: ["Visceral Fat Level", "Subcutaneous Fat Level", "", ""],
		chartTitleSub2: ["Visceral Fat Level", "", "", ""],
        chartTitleUnit1: ["points", "points", "", ""],
        chartTitleUnit2: ["points", "%", "", ""],
		chartUnitName: "Unit",
        unitNames: {kg: "kg", lb: "pounds", cm: "cm", in: "inches", ft: "fits"},
        userSex: {M: "Male", F: "Female"},
        healthGrade: {A: "Optimal", B: "Good", C: "Moderate", D: "Unhealthy", F: "High Risk"},
        bello_pr_sec1_option2_01: "which you measured <span class=\"weight-700\">more frequently</span> compared to the past 6 months. <span class=\"weight-700\">Good job!</span>",
        bello_pr_sec1_option2_02: "which you measured with a similar frequency compared to the past 6 months. Why don’t you use Bello more often?",
        bello_pr_sec1_option2_03: "which you measured more less frequently compared to the past 6 months. Please try to measure it more often.",
        bello_pr_sec3_9bt_01_com: "Skiny Fat",
        bello_pr_sec3_9bt_02_com: "Over VIS Fat",
        bello_pr_sec3_9bt_03_com: "Obese",
        bello_pr_sec3_9bt_04_com: "Average",
        bello_pr_sec3_9bt_05_com: "Overweight",
        bello_pr_sec3_9bt_06_com: "Fit",
        bello_pr_sec3_9bt_07_com: "Slim",
        bello_pr_sec3_9bt_08_com: "Over Body Fat%",
        bello_pr_sec3_9bt_desc: [
            "Above-Average VIS-FL / Below-Average Body Fat %",
            "Above-Average VIS-FL / Average Body Fat %",
            "Above-Average VIS-FL / Above-Average Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Average VIS-FL / Body Fat %",
            "Average VIS-FL /  Above-Average Body Fat %",
            "Below-Average VIS-FL / Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Below-Average VIS-FL / Above-Average Body Fat %",
        ],
	},
	ja: {
        YMD_UNIT: ["年", "月", "日"],
        months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
        monthsFull: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
		weekDays: ["日", "月", "火", "水", "木", "金", "土"],
        weekDaysShort: ["日", "月", "火", "水", "木", "金", "土"],
		legends: ["最小", "平均", "最大"],
		intakeNutrition: ["炭水化物", "タンパク質", "脂肪"],
		chartTitle1: ["VIS-FL", "SQ-FL", "Weight", "Waist Size"],
		chartTitle2: ["VIS-FL", "Body Fat %", "Weight", "Waist Size"],
		chartTitleSub1: ["Visceral Fat Level", "Subcutaneous Fat Level", "", ""],
		chartTitleSub2: ["Visceral Fat Level", "", "", ""],
        chartTitleUnit1: ["ポイント", "ポイント", "", ""],
		chartTitleUnit2: ["ポイント", "%", "", ""],
		chartUnitName: "単位",
        unitNames: {kg: "kg", lb: "pounds", cm: "cm", in: "inches", ft: "fits"},
        userSex: {M: "男性", F: "女性"},
        healthGrade: {A: "Optimal", B: "Good", C: "Moderate", D: "Unhealthy", F: "High Risk"},
        bello_pr_sec1_option2_01: "which you measured more frequently compared to the past 6 months. Good job!",
        bello_pr_sec1_option2_02: "which you measured with a similar frequency compared to the past 6 months. Why don’t you use Bello more often?",
        bello_pr_sec1_option2_03: "which you measured more less frequently compared to the past 6 months. Please try to measure it more often.",
        bello_pr_sec3_9bt_01_com: "Skiny Fat",
        bello_pr_sec3_9bt_02_com: "Over VIS Fat",
        bello_pr_sec3_9bt_03_com: "Obese",
        bello_pr_sec3_9bt_04_com: "Average",
        bello_pr_sec3_9bt_05_com: "Overweight",
        bello_pr_sec3_9bt_06_com: "Fit",
        bello_pr_sec3_9bt_07_com: "Slim",
        bello_pr_sec3_9bt_08_com: "Over Body Fat%",
        bello_pr_sec3_9bt_desc: [
            "Above-Average VIS-FL / Below-Average Body Fat %",
            "Above-Average VIS-FL / Average Body Fat %",
            "Above-Average VIS-FL / Above-Average Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Average VIS-FL / Body Fat %",
            "Average VIS-FL /  Above-Average Body Fat %",
            "Below-Average VIS-FL / Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Below-Average VIS-FL / Above-Average Body Fat %",
        ],
	},
    ko: {
        YMD_UNIT: ["년", "월", "일"],
        months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthsFull: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        weekDays: ["일", "월", "화", "수", "목", "금", "토"],
        weekDaysShort: ["일", "월", "화", "수", "목", "금", "토"],
        legends: ["과소", "평균", "과대"],
        intakeNutrition: ["炭水化物", "タンパク質", "脂肪"],
        chartTitle1: ["VIS-FL", "SQ-FL", "Weight", "Waist Size"],
        chartTitle2: ["VIS-FL", "Body Fat %", "Weight", "Waist Size"],
        chartTitleSub1: ["Visceral Fat Level", "Subcutaneous Fat Level", "", ""],
        chartTitleSub2: ["Visceral Fat Level", "", "", ""],
        chartTitleUnit1: ["ポイント", "ポイント", "", ""],
        chartTitleUnit2: ["ポイント", "%", "", ""],
        chartUnitName: "무게",
        unitNames: {kg: "kg", lb: "pounds", cm: "cm", in: "inches", ft: "fits"},
        userSex: {M: "남성", F: "여성"},
        healthGrade: {A: "Optimal", B: "Good", C: "Moderate", D: "Unhealthy", F: "High Risk"},
        bello_pr_sec1_option2_01: "which you measured more frequently compared to the past 6 months. Good job!",
        bello_pr_sec1_option2_02: "which you measured with a similar frequency compared to the past 6 months. Why don’t you use Bello more often?",
        bello_pr_sec1_option2_03: "which you measured more less frequently compared to the past 6 months. Please try to measure it more often.",
        bello_pr_sec3_9bt_01_com: "Skiny Fat",
        bello_pr_sec3_9bt_02_com: "Over VIS Fat",
        bello_pr_sec3_9bt_03_com: "Obese",
        bello_pr_sec3_9bt_04_com: "Average",
        bello_pr_sec3_9bt_05_com: "Overweight",
        bello_pr_sec3_9bt_06_com: "Fit",
        bello_pr_sec3_9bt_07_com: "Slim",
        bello_pr_sec3_9bt_08_com: "Over Body Fat%",
        bello_pr_sec3_9bt_desc: [
            "Above-Average VIS-FL / Below-Average Body Fat %",
            "Above-Average VIS-FL / Average Body Fat %",
            "Above-Average VIS-FL / Above-Average Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Average VIS-FL / Body Fat %",
            "Average VIS-FL /  Above-Average Body Fat %",
            "Below-Average VIS-FL / Body Fat %",
            "Average VIS-FL / Below-Average Body Fat %",
            "Below-Average VIS-FL / Above-Average Body Fat %",
        ],
    },
};

function localMessage(prop, defaultValue) {
    var localMessage = null;
    try {
        localMessage = LOCALIZATION[CLIENT_LANG][prop];
    } catch (e) {
    }
    if (localMessage == null) {
        localMessage = defaultValue;
    }
    return localMessage;
}

function localDateFormat(date, monthType, useNth) {
    var ymd = parseIsoYmd(date);
    var month = localMessage(monthType)[ymd.month-1];

    if (CLIENT_LANG == "en") {
        var day = ymd.day + (useNth ? nth(ymd.day) : "");
        return month + " " + day + ", " + ymd.year;
    } else if (CLIENT_LANG == "ja") {
        var ymdUnit = localMessage("YMD_UNIT")
        return ymd.year + ymdUnit[0] + " " + month + " " + ymd.day + ymdUnit[2];
    } else {
        console.log("CLIENT_LANG: " + CLIENT_LANG);
    }
}

function localDateFormatLong(date) {
    return localDateFormat(date, "monthsFull", true);
}

function localDateFormatMid(date) {
    return localDateFormat(date, "months", false);
}

function parseIsoYmd(date) {
    var ymd = date.split("-");
    var j = {year: parseInt(ymd[0]), month: parseInt(ymd[1]), day: parseInt(ymd[2])};
    return j;
}

const nth = function(d) {
  if (d > 3 && d < 21) return 'th';
  switch (d % 10) {
    case 1:  return "st";
    case 2:  return "nd";
    case 3:  return "rd";
    default: return "th";
  }
}

function dateToWeekDayShort(date) {
    var dt = new Date(date+"T00:00:00.000Z");
    var wd = dt.getDay();
    var weekDaysShort = localMessage("weekDaysShort");
    return weekDaysShort[wd];
}
