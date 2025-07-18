
#Область СлужебныйПрограммныйИнтерфейс

// Для переданного описания ячейки рег.отчета выбирает подходящий отчет-расшифровку,
// настраивает соотв. вариант и получает подготовленную к показу форму отчета.
//
// Параметры:
//	ИДОтчета - Строка - идентификатор отчета (совпадает с именем объекта метаданных).
// 	ИДРедакцииОтчета - Строка - идентификатор редакции формы отчета (совпадает с именем формы объекта метаданных).
//  ИДИменПоказателей - Массив - массив идентификаторов имен показателей, по которым формируется расшифровка.
//  ПараметрыОтчета - Структура - структура параметров отчета, необходимых для формирования расшифровки.
//
Функция ФормаРасшифровкиРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета) Экспорт
	
	Если Не ЗначениеЗаполнено(ИДИменПоказателей) Тогда
		Возврат Неопределено
	КонецЕсли;
	
	ИмяПоказателя = ИДИменПоказателей[0];
	ИмяНабораДанных = "";
	ИмяОтчетаРасшифровки = "";
	ИмяРасчета = "";
	
	Если ИДОтчета = "РегламентированныйОтчет4ФСС" Тогда
		Год = Число(Лев(СтрЗаменить(ИДРедакцииОтчета, "ФормаОтчета", ""), 4));
		Если Год = 2013 Или Год = 2014 Тогда
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ИмяРасчета = "РасчетПоказателей_4ФСС_2012Кв1";
			ДополнитьПараметрыОтчета4ФССЗа2013Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		ИначеЕсли Год = 2015 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2015Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
			Если СтрНайти(ИмяНабораДанных, "2013") > 0 Тогда
				ИмяРасчета = "РасчетПоказателей_4ФСС_2012Кв1";
			ИначеЕсли СтрНайти(ИмяНабораДанных, "2015") > 0 Тогда
				ИмяРасчета = "РасчетПоказателей_4ФСС_2015Кв1";
			КонецЕсли;
		ИначеЕсли Год = 2016 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2016Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
			Если СтрНайти(ИмяНабораДанных, "2013") > 0 Тогда
				ИмяРасчета = "РасчетПоказателей_4ФСС_2012Кв1";
			ИначеЕсли СтрНайти(ИмяНабораДанных, "2015") > 0 Тогда
				ИмяРасчета = "РасчетПоказателей_4ФСС_2015Кв1";
			ИначеЕсли СтрНайти(ИмяНабораДанных, "2016") > 0 Тогда
				ИмяРасчета = "РасчетПоказателей_4ФСС_2016Кв1";
			КонецЕсли;
		ИначеЕсли Год = 2017 Тогда	
			ИмяОтчетаРасшифровки = "Расшифровка4ФСС";
			ПараметрыОтчета.Вставить("ИмяСКД");
			ДополнитьПараметрыОтчета4ФССЗа2017Год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
			ИмяРасчета = "РасчетПоказателей_4ФСС_2017Кв1";
		КонецЕсли;
	ИначеЕсли ИДОтчета = "РегламентированныйОтчетРасчетПоСтраховымВзносам" Тогда
		Если Число(Лев(СтрЗаменить(ИДРедакцииОтчета, "ФормаОтчета", ""), 4)) < 2022 Тогда
			ИмяОтчетаРасшифровки = "РасшифровкаРСВ";
			ИмяРасчета = "РасчетПоказателей_РСВ_2017Кв1";
			ДополнитьПараметрыОтчетаРСВза2017год(ПараметрыОтчета, ИмяПоказателя);
			ИмяНабораДанных = ПараметрыОтчета.ИмяСКД;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка отчета-расшифровки к показу.
	Если ЗначениеЗаполнено(ИмяОтчетаРасшифровки) И ЗначениеЗаполнено(ИмяНабораДанных) И ЗначениеЗаполнено(ИмяРасчета) Тогда
		
		ПараметрыОтчета.Вставить("ИсточникРасшифровки","УчетПособийСоциальногоСтрахования");
		ПараметрыОтчета.Вставить("ИмяОтчетаРасшифровки",ИмяОтчетаРасшифровки);
		ПараметрыОтчета.Вставить("ИмяРасчета",ИмяРасчета);
		ПараметрыОтчета.Вставить("ИДИменПоказателей",ИДИменПоказателей);
		
		ПараметрыФормы = ЗарплатаКадрыКлиент.ЗаполнитьПараметрыФормыРасшифровкиОтчетности(ПараметрыОтчета);
		ФормаРасшифровки = ПолучитьФорму("ОбщаяФорма.РасшифровкаРегламентированногоОтчетаЗарплата", ПараметрыФормы);
		Возврат ФормаРасшифровки
		
	КонецЕсли;
	
	Возврат Неопределено
	
КонецФункции

Процедура ДополнитьПараметрыОтчета4ФССЗа2013Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "02" Тогда
		Если НомерКолонки = "01" Тогда
		ИначеЕсли ИмяПоказателя = "П000020010005" Тогда
		ИначеЕсли НомерСтроки = "080" Или НомерСтроки = "090" Тогда
			ИмяНабораДанных = "ПособияПоУходу2013"
		ИначеЕсли НомерСтроки <> "070" И НомерСтроки <> "120" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2013"
		КонецЕсли;
	ИначеЕсли Раздел = "05" Тогда	
		Если НомерСтроки = "030" Тогда
		ИначеЕсли НомерКолонки = "03" Или НомерКолонки = "04" Или НомерКолонки = "05" Или НомерКолонки = "06" 
			Или НомерКолонки = "09" Или НомерКолонки = "12" Или НомерКолонки = "15" Или НомерКолонки = "18" Тогда
		ИначеЕсли НомерСтроки = "040" Или НомерСтроки = "050" Тогда
			ИмяНабораДанных = "ПособияПоУходуСверхНорм2013"
		ИначеЕсли НомерСтроки <> "070" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2013"
		КонецЕсли;
	ИначеЕсли Раздел = "08" Тогда	
		Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2013"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Число(Раздел), "ЧГ="),
			Формат(Число(НомерСтроки) / 10, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "Расходы по страхованию";
		Если Раздел = "02" Тогда
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "030" Или НомерСтроки = "040" Или НомерСтроки = "100" Тогда
					ЗаголовокПоля = "Количество дней"
				ИначеЕсли НомерСтроки = "080" Или НомерСтроки = "090" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки <> "120" Тогда
					ЗаголовокПоля = "Количество пособий"
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Раздел = "05" Тогда	
			Если НомерКолонки = "07" Или НомерКолонки = "10" Или НомерКолонки = "13" Или НомерКолонки = "16" Или НомерКолонки = "19" Тогда
				Если НомерСтроки = "040" Или НомерСтроки = "050" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки = "060" Тогда
					ЗаголовокПоля = "Количество пособий"
				ИначеЕсли НомерСтроки <> "070" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Раздел = "08" Тогда	
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля",ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2015Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "02" Тогда
		Если НомерКолонки = "01" Тогда
		ИначеЕсли НомерСтроки = "100" Или НомерСтроки = "110" Тогда
			ИмяНабораДанных = "ПособияПоУходу2015"
		ИначеЕсли НомерСтроки <> "090" И НомерСтроки <> "150" И НомерСтроки <> "160" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2015"
		КонецЕсли;
	ИначеЕсли Раздел = "05" Тогда	
		Если НомерСтроки = "030" Тогда
		ИначеЕсли НомерКолонки = "03" Или НомерКолонки = "06" Или НомерКолонки = "09" Или НомерКолонки = "12" Или НомерКолонки = "15" Или НомерКолонки = "18" Тогда
		ИначеЕсли НомерКолонки = "04" Тогда
			Если НомерСтроки = "070" Тогда
				ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2015"
			КонецЕсли;
		ИначеЕсли НомерКолонки = "05" Тогда
			Если НомерСтроки = "070" Или НомерСтроки = "080" Тогда
				ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2015"
			КонецЕсли;
		ИначеЕсли НомерСтроки = "040" Или НомерСтроки = "050" Тогда
			ИмяНабораДанных = "ПособияПоУходуСверхНорм2013"
		ИначеЕсли НомерСтроки <> "090" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2015"
		КонецЕсли;
	ИначеЕсли Раздел = "08" Тогда	
		Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2015"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Число(Раздел), "ЧГ="),
			Формат(Число(НомерСтроки) / 10, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "Расходы по страхованию";
		Если Раздел = "02" Тогда
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "030" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "060" Или НомерСтроки = "120" Тогда
					ЗаголовокПоля = "Количество дней"
				ИначеЕсли НомерСтроки = "100" Или НомерСтроки = "110" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки = "070" Или НомерСтроки = "080" Или НомерСтроки = "140" Тогда
					ЗаголовокПоля = "Количество пособий"
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Раздел = "05" Тогда	
			Если НомерКолонки = "07" Или НомерКолонки = "10" Или НомерКолонки = "13" Или НомерКолонки = "16" Или НомерКолонки = "19" Тогда
				Если НомерСтроки = "040" Или НомерСтроки = "050" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки = "060" Тогда
					ЗаголовокПоля = "Количество пособий"
				ИначеЕсли НомерСтроки <> "090" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			ИначеЕсли НомерКолонки = "04" И  НомерСтроки = "070" Тогда
				ЗаголовокПоля = "Количество дней"
			КонецЕсли;
		ИначеЕсли Раздел = "08" Тогда	
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля",ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2016Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "02" Тогда
		Если НомерКолонки = "01" Тогда
		ИначеЕсли НомерСтроки = "140" И НомерКолонки <> "05" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2015"
		ИначеЕсли НомерСтроки = "100" Или НомерСтроки = "110" Тогда
			ИмяНабораДанных = "ПособияПоУходу2015"
		ИначеЕсли НомерСтроки <> "090" И НомерСтроки <> "140" И НомерСтроки <> "150" И НомерСтроки <> "160" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2015"
		КонецЕсли;
	ИначеЕсли Раздел = "05" Тогда	
		Если НомерСтроки = "030" Тогда
		ИначеЕсли НомерКолонки = "03" Или НомерКолонки = "06" Или НомерКолонки = "09" Или НомерКолонки = "12" Или НомерКолонки = "15" Или НомерКолонки = "18" Тогда
		ИначеЕсли НомерКолонки = "04" Тогда
			Если НомерСтроки = "060" Тогда
				ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2016"
			КонецЕсли;
		ИначеЕсли НомерКолонки = "05" Тогда
			Если НомерСтроки = "060" Или НомерСтроки = "070" Тогда
				ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2016"
			КонецЕсли;
		ИначеЕсли НомерСтроки = "040" Или НомерСтроки = "050" Тогда
			ИмяНабораДанных = "ПособияПоУходуСверхНорм2013"
		ИначеЕсли НомерСтроки <> "080" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2016"
		КонецЕсли;
	ИначеЕсли Раздел = "08" Тогда	
		Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2015"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Число(Раздел), "ЧГ="),
			Формат(Число(НомерСтроки) / 10, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "Расходы по страхованию";
		Если Раздел = "02" Тогда
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "030" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "060" Или НомерСтроки = "120" Тогда
					ЗаголовокПоля = "Количество дней"
				ИначеЕсли НомерСтроки = "100" Или НомерСтроки = "110" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки = "070" Или НомерСтроки = "080" Или НомерСтроки = "140" Тогда
					ЗаголовокПоля = "Количество пособий"
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Раздел = "05" Тогда	
			Если НомерКолонки = "07" Или НомерКолонки = "10" Или НомерКолонки = "13" Или НомерКолонки = "16" Или НомерКолонки = "19" Тогда
				Если НомерСтроки = "040" Или НомерСтроки = "050" Тогда
					ЗаголовокПоля = "Количество выплат"
				ИначеЕсли НомерСтроки <> "080" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			ИначеЕсли НомерКолонки = "04" И  НомерСтроки = "060" Тогда
				ЗаголовокПоля = "Количество дней"
			КонецЕсли;
		ИначеЕсли Раздел = "08" Тогда	
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля",ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчета4ФССЗа2017Год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ИмяНабораДанных = "";
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	Если Раздел = "03" Тогда	
		Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
			ИмяНабораДанных = "ПособияПоНетрудоспособности2017"
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		
		ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);

		ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Табл. %1, строка %2, графа %3';
				|en = 'Tabl. %1, row %2, column %3'"),
			Формат(Число(Раздел), "ЧГ="),
			Формат(Число(НомерСтроки) / 10, "ЧГ="),
			Формат(Число(НомерКолонки), "ЧГ="));
			
		ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
			
		ЗаголовокПоля = "Расходы по страхованию";
		Если Раздел = "03" Тогда	
			Если НомерКолонки = "03" Тогда
				Если НомерСтроки = "010" Или НомерСтроки = "020" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "070" Тогда
					ЗаголовокПоля = "Количество дней"
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыОтчета.Вставить("ЗаголовокПоля",ЗаголовокПоля);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПараметрыОтчетаРСВза2017год(ПараметрыОтчета, ИмяПоказателя)

	Раздел = ЗарплатаКадрыКлиентСервер.РазделРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерСтроки = ЗарплатаКадрыКлиентСервер.СтрокаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	НомерКолонки = ЗарплатаКадрыКлиентСервер.КолонкаРегламентированногоОтчетаПоИмениПоказателя(ИмяПоказателя);
	
	ПараметрыОтчета.Вставить("ИмяСКД", "");
	
	ИмяНабораДанных = "";
	Если Раздел = "13" Тогда
		Если НомерСтроки = "060" Или НомерСтроки = "100" Или НомерСтроки = "110" Тогда
		ИначеЕсли НомерКолонки = "01" И НомерСтроки >= "040" Тогда
		ИначеЕсли (НомерСтроки = "020" Или НомерСтроки = "021" Или НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "090") И НомерКолонки = "05" Или НомерСтроки = "080" И НомерКолонки = "02" Тогда
		ИначеЕсли НомерСтроки = "061" Или НомерСтроки = "062" Тогда
			ИмяНабораДанных = "ПособияПоУходу2017"
		Иначе
			ИмяНабораДанных = "ПособияПоНетрудоспособности2017"
		КонецЕсли;
	ИначеЕсли Раздел = "14" Тогда	
		Если НомерСтроки = "001" Или НомерСтроки = "010" Или НомерСтроки = "040" Или НомерСтроки = "070" Или НомерСтроки = "100" Или НомерСтроки = "130" Или НомерСтроки = "150" Или НомерСтроки = "180" Или НомерСтроки = "210" Или НомерСтроки = "240" Или НомерСтроки = "250" Или НомерСтроки = "260" Или НомерСтроки = "270" Или НомерСтроки = "280" Или НомерСтроки = "290" Тогда
		ИначеЕсли НомерКолонки = "02" Тогда
		ИначеЕсли НомерКолонки = "03" И НомерСтроки = "310" Тогда
		ИначеЕсли НомерСтроки = "050" Или НомерСтроки = "060" Или НомерСтроки = "110" Или НомерСтроки = "120" Или НомерСтроки = "190" Или НомерСтроки = "200" Тогда
			ИмяНабораДанных = "ПособияПоУходуСверхНорм2017"
		Иначе
			ИмяНабораДанных = "ПособияПоНетрудоспособностиСверхНорм2017"
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяНабораДанных) Тогда
		Возврат
	КонецЕсли;
		
	ПараметрыОтчета.Вставить("ИмяСКД",ИмяНабораДанных);
	
	ЗаголовокРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Приложение %1, строка %2, графа %3';
								|en = 'Annex %1, line %2, column %3 '"),
							Прав(Раздел, 1),
							НомерСтроки,
							Формат(Число(НомерКолонки), "ЧГ="));
	
	ПараметрыОтчета.Вставить("ЗаголовокРасшифровки",ЗаголовокРасшифровки);
	
	ЗаголовокПоля = "Расходы по страхованию";
	Если Раздел = "13" Тогда
		Если НомерКолонки = "01" Тогда
			ЗаголовокПоля = "Число случаев"
		ИначеЕсли НомерКолонки = "02" Тогда
			Если НомерСтроки = "061" Или НомерСтроки = "062" Тогда
				ЗаголовокПоля = "Количество выплат"
			ИначеЕсли НомерСтроки = "040" Или НомерСтроки = "050" Или НомерСтроки = "090" Тогда
				ЗаголовокПоля = "Количество пособий"
			Иначе
				ЗаголовокПоля = "Количество дней"
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Раздел = "14" Тогда	
		Если НомерКолонки = "03" Тогда
			Если НомерСтроки = "050" Или НомерСтроки = "060" Или НомерСтроки = "110" Или НомерСтроки = "120" Или НомерСтроки = "190" Или НомерСтроки = "200" Тогда
				ЗаголовокПоля = "Количество выплат"
			Иначе
				ЗаголовокПоля = "Количество дней"
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ЗаголовокПоля",ЗаголовокПоля);
	
КонецПроцедуры

// См. ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентПереопределяемый.ПоказатьСостояниеОтправкиОтчета.
Процедура ПоказатьСостояниеОтправкиОтчета(Ссылка, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеестрДанныхЭЛНЗаполняемыхРаботодателем") Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// См. ЗарплатаКадрыКлиент.НастройкиТипа.
Процедура ПриОпределенииНастроекТипа(Тип, НастройкиТипа) Экспорт
	
	Если Тип = Тип("ДокументСсылка.РеестрДанныхЭЛНЗаполняемыхРаботодателем")
		Или Тип = Тип("ДокументСсылка.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий") Тогда
		
		НастройкиТипа.ПоказыватьКомандыРаботыСФайлами = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// См. РегламентированнаяОтчетностьКлиентПереопределяемый.Выгрузить.
Процедура ВыгрузитьДокументОтчетности(Ссылка, УникальныйИдентификаторФормы) Экспорт
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий") Тогда
		Реестры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
		ПрямыеВыплатыПособийСоциальногоСтрахованияКлиент.СохранитьВФайл(Реестры, , УникальныйИдентификаторФормы);
	КонецЕсли;
КонецПроцедуры

Процедура ОткрытьНастройкиПрямыхВыплатОрганизации(Организация, ФормаВладелец) Экспорт
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	ИмяФормы = "РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций.Форма.ФормаЗаписи";
	Параметры = Новый Структура("Организация", Организация);
	КлючУникальности = Строка(Организация.УникальныйИдентификатор());
	ОткрытьФорму(ИмяФормы, Параметры, ФормаВладелец, КлючУникальности);
КонецПроцедуры

Процедура ПоказатьСпособыПрямыхВыплатФизическихЛиц(Организация, ФормаВладелец) Экспорт
	Параметры = Новый Структура("Организация", Организация);
	ОткрытьФорму("РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Форма.ФормаСписка", Параметры, ФормаВладелец);
КонецПроцедуры

Процедура НастроитьСпособПрямыхВыплатФизическогоЛица(Организация, ФизическоеЛицо, ФормаВладелец, ЭтоГоловнаяОрганизация = Истина) Экспорт
	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура("ФизическоеЛицо", ФизическоеЛицо);
	Если ЭтоГоловнаяОрганизация Тогда
		Параметры.Вставить("ГоловнаяОрганизация", Организация);
	Иначе
		Параметры.Вставить("Организация", Организация);
	КонецЕсли;
	
	КлючУникальности = Строка(Число(ЭтоГоловнаяОрганизация))
		+ Строка(Организация.УникальныйИдентификатор())
		+ Строка(ФизическоеЛицо.УникальныйИдентификатор());
	
	ОткрытьФорму("РегистрСведений.НастройкиПрямыхВыплатФСССотрудников.Форма.ФормаЗаписи",
		Параметры,
		ФормаВладелец,
		КлючУникальности);
КонецПроцедуры

Процедура ОткрытьРеестрЭЛН(РеестрЭЛН, НомерЛН) Экспорт
	Если ТипЗнч(РеестрЭЛН) <> Тип("ДокументСсылка.РеестрДанныхЭЛНЗаполняемыхРаботодателем")
		Или Не ЗначениеЗаполнено(РеестрЭЛН) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",    РеестрЭЛН);
	ПараметрыФормы.Вставить("НомерЛН", НомерЛН);
	
	ОткрытьФорму("Документ.РеестрДанныхЭЛНЗаполняемыхРаботодателем.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьФайлXML(ОписаниеФайла) Экспорт
	Если ОписаниеФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок      = НСтр("ru = 'Укажите файл';
								|en = 'Select file'");
	Диалог.Фильтр         = НСтр("ru = 'Файлы XML (*.xml)|*.xml';
								|en = 'Files XML (*.xml)|*.xml'");
	Диалог.ПолноеИмяФайла = ОписаниеФайла.ИмяБезРасширения;
	Диалог.МножественныйВыбор = Ложь;
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог = Диалог;
	
	ФайловаяСистемаКлиент.СохранитьФайл(
		Неопределено, ОписаниеФайла.Адрес, ОписаниеФайла.ИмяБезРасширения, ПараметрыСохранения);
КонецПроцедуры

#КонецОбласти
