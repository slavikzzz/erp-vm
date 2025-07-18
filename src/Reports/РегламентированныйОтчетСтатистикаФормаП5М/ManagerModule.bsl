#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("СхемаВыгрузкиXML",   ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 26.06.2013 № 232.";
	НоваяФорма.РедакцияФормы	  = "от 26.06.2013 № 232.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2014Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 11.11.2014 № 648.";
	НоваяФорма.РедакцияФормы	  = "от 11.11.2014 № 648.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2015Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 26.08.2015 № 390.";
	НоваяФорма.РедакцияФормы	  = "от 26.08.2015 № 390.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2016Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 11.08.2016 № 414.";
	НоваяФорма.РедакцияФормы	  = "от 11.08.2016 № 414.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2017Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 21.08.2017 № 541.";
	НоваяФорма.РедакцияФормы	  = "от 21.08.2017 № 541.";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2018Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 31.07.2018 № 472.";
	НоваяФорма.РедакцияФормы	  = "от 31.07.2018 № 472.";
	НоваяФорма.ДатаНачалоДействия = '20190101';
	НоваяФорма.ДатаКонецДействия  = '20191231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2019Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 22.07.2019 № 419.";
	НоваяФорма.РедакцияФормы	  = "от 22.07.2019 № 419.";
	НоваяФорма.ДатаНачалоДействия = '20200101';
	НоваяФорма.ДатаКонецДействия  = '20201231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2020Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 24.07.2020 № 411.";
	НоваяФорма.РедакцияФормы	  = "от 24.07.2020 № 411.";
	НоваяФорма.ДатаНачалоДействия = '20210101';
	НоваяФорма.ДатаКонецДействия  = '20211231';
	НоваяФорма.СхемаВыгрузкиXML   = "СхемаВыгрузкиXML2021Кв1";
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 13.10.2021 № 704 (в редакции приказа Росстата от 17.12.2021 № 925).";
	НоваяФорма.РедакцияФормы	  = "от 13.10.2021 № 704.";
	НоваяФорма.ДатаНачалоДействия = '20220101';
	НоваяФорма.ДатаКонецДействия  = '20231231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2024Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 31.07.2023 № 365 (в редакции приказа Росстата от 11.01.2024 № 3, 30.01.2025 № 34).";
	НоваяФорма.РедакцияФормы	  = "от 31.07.2023 № 365.";
	НоваяФорма.ДатаНачалоДействия = '20240101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20090728', "153",	"ФормаОтчета2010Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20120829', "470",	"ФормаОтчета2013Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20120829', "470",	"ФормаОтчета2013Кв4");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20130626', "232",	"ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20141111', "648",	"ФормаОтчета2015Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20150826', "390",	"ФормаОтчета2016Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20160811', "414",	"ФормаОтчета2017Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20170821', "541",	"ФормаОтчета2018Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20180731', "472",	"ФормаОтчета2019Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20190722', "419",	"ФормаОтчета2020Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20200724', "411",	"ФормаОтчета2021Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФормаП5М", "ФормаОтчета2021Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, ВерсияВыгрузки);
	Форма20220101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20211013', "704",	"ФормаОтчета2022Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФормаП5М", "ФормаОтчета2022Кв1");
	Форма20240101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "610016", '20230731', "365", "ФормаОтчета2024Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФормаП5М", "ФормаОтчета2024Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20240101, ВерсияВыгрузки);
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли