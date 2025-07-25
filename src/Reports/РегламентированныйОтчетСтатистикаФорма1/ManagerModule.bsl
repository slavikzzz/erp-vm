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
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 20.01.2017 № 29 (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 20.01.2017 № 29.";
	НоваяФорма.ДатаНачалоДействия = '20150501';
	НоваяФорма.ДатаКонецДействия  = '20170331';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 20.01.2017 № 29.";
	НоваяФорма.РедакцияФормы	  = "от 20.01.2017 № 29.";
	НоваяФорма.ДатаНачалоДействия = '20170401';
	НоваяФорма.ДатаКонецДействия  = '20170430';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 20.01.2017 № 29 (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 20.01.2017 № 29.";
	НоваяФорма.ДатаНачалоДействия = '20170501';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 17.01.2019 № 7 (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 17.01.2019 № 7.";
	НоваяФорма.ДатаНачалоДействия = '20190101';
	НоваяФорма.ДатаКонецДействия  = '20190331';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 17.01.2019 № 7.";
	НоваяФорма.РедакцияФормы	  = "от 17.01.2019 № 7.";
	НоваяФорма.ДатаНачалоДействия = '20190401';
	НоваяФорма.ДатаКонецДействия  = '20190430';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 17.01.2019 № 7 (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 17.01.2019 № 7.";
	НоваяФорма.ДатаНачалоДействия = '20190501';
	НоваяФорма.ДатаКонецДействия  = '20201231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 27.01.2021 № 37 (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 27.01.2021 № 37.";
	НоваяФорма.ДатаНачалоДействия = '20210101';
	НоваяФорма.ДатаКонецДействия  = '20210331';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.01.2021 № 37.";
	НоваяФорма.РедакцияФормы	  = "от 27.01.2021 № 37.";
	НоваяФорма.ДатаНачалоДействия = '20210401';
	НоваяФорма.ДатаКонецДействия  = '20210430';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма, аналогичная утвержденой приказом Росстата от 27.01.2021 № 37 (в редакции приказа Росстата от 17.12.2021 № 925) (другой период).";
	НоваяФорма.РедакцияФормы	  = "от 27.01.2021 № 37.";
	НоваяФорма.ДатаНачалоДействия = '20210501';
	НоваяФорма.ДатаКонецДействия  = '20230331';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2022Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 26.12.2022 № 978.";
	НоваяФорма.РедакцияФормы	  = "от 26.12.2022 № 978.";
	НоваяФорма.ДатаНачалоДействия = '20230401';
	НоваяФорма.ДатаКонецДействия  = '20231231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2025Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.12.2024 № 696 (в редакции приказа Росстата от 30.01.2025 № 34).";
	НоваяФорма.РедакцияФормы	  = "от 27.12.2024 № 696.";
	НоваяФорма.ДатаНачалоДействия = '20250401';
	НоваяФорма.ДатаКонецДействия  = '20251231';
	
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
	
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "606038", '20170120', "29",	"ФормаОтчета2016Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "606038", '20190117', "7",	"ФормаОтчета2019Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "606038", '20210127', "37",	"ФормаОтчета2021Кв1");
	Форма20220101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "606038", '20221226', "978",	"ФормаОтчета2022Кв1");
	Форма20250101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "606038", '20241227', "696",	"ФормаОтчета2025Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма1", "ФормаОтчета2025Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20250101, ВерсияВыгрузки);
	
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