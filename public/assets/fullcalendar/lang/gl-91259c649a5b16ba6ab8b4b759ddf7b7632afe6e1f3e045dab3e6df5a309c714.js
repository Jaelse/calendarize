!function(e){"function"==typeof define&&define.amd?define(["jquery","moment"],e):"object"==typeof exports?module.exports=e(require("jquery"),require("moment")):e(jQuery,moment)}(function(e,o){!function(){"use strict";(o.defineLocale||o.lang).call(o,"gl",{months:"Xaneiro_Febreiro_Marzo_Abril_Maio_Xu\xf1o_Xullo_Agosto_Setembro_Outubro_Novembro_Decembro".split("_"),monthsShort:"Xan._Feb._Mar._Abr._Mai._Xu\xf1._Xul._Ago._Set._Out._Nov._Dec.".split("_"),monthsParseExact:!0,weekdays:"Domingo_Luns_Martes_M\xe9rcores_Xoves_Venres_S\xe1bado".split("_"),weekdaysShort:"Dom._Lun._Mar._M\xe9r._Xov._Ven._S\xe1b.".split("_"),weekdaysMin:"Do_Lu_Ma_M\xe9_Xo_Ve_S\xe1".split("_"),weekdaysParseExact:!0,longDateFormat:{LT:"H:mm",LTS:"H:mm:ss",L:"DD/MM/YYYY",LL:"D MMMM YYYY",LLL:"D MMMM YYYY H:mm",LLLL:"dddd D MMMM YYYY H:mm"},calendar:{sameDay:function(){return"[hoxe "+(1!==this.hours()?"\xe1s":"\xe1")+"] LT"},nextDay:function(){return"[ma\xf1\xe1 "+(1!==this.hours()?"\xe1s":"\xe1")+"] LT"},nextWeek:function(){return"dddd ["+(1!==this.hours()?"\xe1s":"a")+"] LT"},lastDay:function(){return"[onte "+(1!==this.hours()?"\xe1":"a")+"] LT"},lastWeek:function(){return"[o] dddd [pasado "+(1!==this.hours()?"\xe1s":"a")+"] LT"},sameElse:"L"},relativeTime:{future:function(e){return"uns segundos"===e?"nuns segundos":"en "+e},past:"hai %s",s:"uns segundos",m:"un minuto",mm:"%d minutos",h:"unha hora",hh:"%d horas",d:"un d\xeda",dd:"%d d\xedas",M:"un mes",MM:"%d meses",y:"un ano",yy:"%d anos"},ordinalParse:/\d{1,2}\xba/,ordinal:"%d\xba",week:{dow:1,doy:7}})}(),e.fullCalendar.datepickerLang("gl","gl",{closeText:"Pechar",prevText:"&#x3C;Ant",nextText:"Seg&#x3E;",currentText:"Hoxe",monthNames:["Xaneiro","Febreiro","Marzo","Abril","Maio","Xu\xf1o","Xullo","Agosto","Setembro","Outubro","Novembro","Decembro"],monthNamesShort:["Xan","Feb","Mar","Abr","Mai","Xu\xf1","Xul","Ago","Set","Out","Nov","Dec"],dayNames:["Domingo","Luns","Martes","M\xe9rcores","Xoves","Venres","S\xe1bado"],dayNamesShort:["Dom","Lun","Mar","M\xe9r","Xov","Ven","S\xe1b"],dayNamesMin:["Do","Lu","Ma","M\xe9","Xo","Ve","S\xe1"],weekHeader:"Sm",dateFormat:"dd/mm/yy",firstDay:1,isRTL:!1,showMonthAfterYear:!1,yearSuffix:""}),e.fullCalendar.lang("gl",{buttonText:{month:"Mes",week:"Semana",day:"D\xeda",list:"Axenda"},allDayHtml:"Todo<br/>o d\xeda",eventLimitText:"m\xe1is"})});