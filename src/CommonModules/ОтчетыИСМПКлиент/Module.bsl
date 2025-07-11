
#Область ПрограммныйИнтерфейс

// Обработчик расшифровки табличного документа формы отчета.
// См. "Расширение поля формы для поля табличного документа.ОбработкаРасшифровки" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения - Форма отчета.
//   Элемент     - ПолеФормы        - Табличный документ.
//   Расшифровка - Произвольный     - Значение расшифровки точки, серии или значения диаграммы.
//   СтандартнаяОбработка - Булево  - Признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаРасшифровкиОтчета(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	ПолноеИмяОтчета = ФормаОтчета.НастройкиОтчета.ПолноеИмя;
	
	Если ПолноеИмяОтчета = "Отчет.СписокКИНаБалансеИСМП" Тогда
		
		КлючТекущегоВарианта = ФормаОтчета.КлючТекущегоВарианта;
		Если КлючТекущегоВарианта = "РасшифровкаПоКодамМаркировки" Тогда
			Возврат;
		КонецЕсли;
		
		ПоляРасшифровки = Новый Массив;
		ПоляРасшифровки.Добавить("Количество");
		ПоляРасшифровки.Добавить("GTIN");
		ПоляРасшифровки.Добавить("Ссылка");
		ПоляРасшифровки.Добавить("ВидУпаковки");
		ПоляРасшифровки.Добавить("СпособВводаВОборот");
		ПоляРасшифровки.Добавить("СтатусКодаМаркировки");
		ПоляРасшифровки.Добавить("УпаковкаВерхнегоУровня");
		
		СписокПараметров = Новый Массив;
		СписокПараметров.Добавить("ДокументИСМП");
		
		СтруктураРасшифровки = ОтчетыИСМПВызовСервера.ПараметрыФормыРасшифровки(
			Расшифровка, ФормаОтчета.ОтчетДанныеРасшифровки, СписокПараметров, ПоляРасшифровки, "Количество");
		
		Если СтруктураРасшифровки.Свойство("Расшифровать") И Не СтруктураРасшифровки.Расшифровать Тогда
			Возврат;
		КонецЕсли;
		
		ДокументРасшифровки = ДокументПоДаннымРасшифровки(СтруктураРасшифровки);
		
		Если ДокументРасшифровки = Неопределено Тогда
			// Для расшифровки по кодам требуется файл-выгрузки из присоединенных файлов.
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не удалось определить документ в структуре отчета для расшифровки по кодам маркировки.';
					|en = 'Не удалось определить документ в структуре отчета для расшифровки по кодам маркировки.'"));
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство("GTIN") И ЗначениеЗаполнено(СтруктураРасшифровки.GTIN)
			Или СтруктураРасшифровки.Свойство("ВидУпаковки") И ЗначениеЗаполнено(СтруктураРасшифровки.ВидУпаковки) Тогда
			СтандартнаяОбработка = Ложь;
			
			ПараметрыФормы = ПараметрыФормыОтчета();
			ПараметрыФормы.КлючВарианта    = "РасшифровкаПоКодамМаркировки";
			ПараметрыФормы.ПараметрКоманды = ДокументРасшифровки;
			ПараметрыФормы.Отбор           = ОтборПоДаннымРасшифровки(СтруктураРасшифровки, ПоляРасшифровки);
			
			ОткрытьФорму("Отчет.СписокКИНаБалансеИСМП.Форма", ПараметрыФормы);
			
		КонецЕсли;
		
	ИначеЕсли ПолноеИмяОтчета = "Отчет.СведенияОбОтклоненияхИСМП" Тогда
		
		КлючТекущегоВарианта = ФормаОтчета.КлючТекущегоВарианта;
		Если КлючТекущегоВарианта = "РасшифровкаПоКодамМаркировки" Тогда
			Возврат;
		КонецЕсли;
		
		ПоляРасшифровки = Новый Массив;
		ПоляРасшифровки.Добавить("Количество");
		ПоляРасшифровки.Добавить("Ссылка");
		ПоляРасшифровки.Добавить("ВидОтклонения");
		ПоляРасшифровки.Добавить("РезультатПроверки");
		ПоляРасшифровки.Добавить("АдресОбъекта");
		ПоляРасшифровки.Добавить("Субъект");
		ПоляРасшифровки.Добавить("Нивелировано");
		ПоляРасшифровки.Добавить("НомерККТ");
		ПоляРасшифровки.Добавить("ВидПродукции");
		
		СписокПараметров = Новый Массив;
		СписокПараметров.Добавить("ДокументИСМП");
		
		СтруктураРасшифровки = ОтчетыИСМПВызовСервера.ПараметрыФормыРасшифровки(
			Расшифровка, ФормаОтчета.ОтчетДанныеРасшифровки, СписокПараметров, ПоляРасшифровки, "Количество");
		
		Если СтруктураРасшифровки.Свойство("Расшифровать") И Не СтруктураРасшифровки.Расшифровать Тогда
			Возврат;
		КонецЕсли;
		
		ДокументРасшифровки = ДокументПоДаннымРасшифровки(СтруктураРасшифровки);
		
		Если ДокументРасшифровки = Неопределено Тогда
			// Для расшифровки по кодам требуется файл-выгрузки из присоединенных файлов.
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не удалось определить документ в структуре отчета для расшифровки по кодам маркировки.';
					|en = 'Не удалось определить документ в структуре отчета для расшифровки по кодам маркировки.'"));
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство("АдресОбъекта") И ЗначениеЗаполнено(СтруктураРасшифровки.АдресОбъекта)
			Или СтруктураРасшифровки.Свойство("ВидОтклонения") И ЗначениеЗаполнено(СтруктураРасшифровки.ВидОтклонения)
			Или СтруктураРасшифровки.Свойство("РезультатПроверки") И ЗначениеЗаполнено(СтруктураРасшифровки.РезультатПроверки) Тогда
				
			СтандартнаяОбработка = Ложь;
			
			ПараметрыФормы = ПараметрыФормыОтчета();
			ПараметрыФормы.КлючВарианта    = "РасшифровкаПоКодамМаркировки";
			ПараметрыФормы.ПараметрКоманды = ДокументРасшифровки;
			ПараметрыФормы.Отбор           = ОтборПоДаннымРасшифровки(СтруктураРасшифровки, ПоляРасшифровки);
			
			ОткрытьФорму("Отчет.СведенияОбОтклоненияхИСМП.Форма", ПараметрыФормы);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДокументПоДаннымРасшифровки(СтруктураРасшифровки)
	
	ДокументРасшифровки = Неопределено;
	
	Если СтруктураРасшифровки.Свойство("Ссылка") И ЗначениеЗаполнено(СтруктураРасшифровки.Ссылка) Тогда
		ДокументРасшифровки = Новый СписокЗначений;
		ДокументРасшифровки.Добавить(СтруктураРасшифровки.Ссылка);
	ИначеЕсли СтруктураРасшифровки.Свойство("ДокументИСМП") И ЗначениеЗаполнено(СтруктураРасшифровки.ДокументИСМП) Тогда
		Если ТипЗнч(СтруктураРасшифровки.ДокументИСМП) = Тип("СписокЗначений") Тогда
			Если СтруктураРасшифровки.ДокументИСМП.Количество() = 1 Тогда
				ДокументРасшифровки = Новый СписокЗначений;
				ДокументРасшифровки.Добавить(СтруктураРасшифровки.ДокументИСМП[0].Значение);
			КонецЕсли;
		Иначе
			ДокументРасшифровки = Новый СписокЗначений;
			ДокументРасшифровки.Добавить(СтруктураРасшифровки.ДокументИСМП);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДокументРасшифровки;
	
КонецФункции

Функция ОтборПоДаннымРасшифровки(СтруктураРасшифровки, ПоляРасшифровки)
	
	Отбор = Новый Структура();
	Для Каждого ИмяПоля Из ПоляРасшифровки Цикл
		
		Если ИмяПоля = "Ссылка" Или ИмяПоля = "Количество" Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтруктураРасшифровки.Свойство(ИмяПоля) И ЗначениеЗаполнено(СтруктураРасшифровки[ИмяПоля]) Тогда
			Отбор.Вставить(ИмяПоля, СтруктураРасшифровки[ИмяПоля]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Отбор;
	
КонецФункции

Функция ПараметрыФормыОтчета()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("КлючВарианта");
	ПараметрыФормы.Вставить("КлючНазначенияИспользования");
	ПараметрыФормы.Вставить("Отбор");
	ПараметрыФормы.Вставить("ПараметрКоманды");
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти
