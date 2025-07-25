
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", ПодключаемоеОборудование);
	
	Заголовок = НСтр("ru = 'Оборудование:';
					|en = 'Peripherals:'") + Символы.НПП  + Строка(ПодключаемоеОборудование);
	
	времКаталогОбмена = Неопределено;
	времИмяФайлаВыгрузки = Неопределено;
	времИмяФайлаЗагрузки = Неопределено;
	
	
	Параметры.ПараметрыОборудования.Свойство("КаталогОбмена", времКаталогОбмена);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаВыгрузки", времИмяФайлаВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаЗагрузки", времИмяФайлаЗагрузки);
	
	КаталогОбмена = 	?(времКаталогОбмена = Неопределено, "", времКаталогОбмена);
	ИмяФайлаВыгрузки = 	?(времИмяФайлаВыгрузки = Неопределено, "ExportData", времИмяФайлаВыгрузки);
	ИмяФайлаЗагрузки = 	?(времИмяФайлаЗагрузки = Неопределено, "ImportData", времИмяФайлаЗагрузки);
	
	ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриОткрытии(ЭтотОбъект, ПодключаемоеОборудование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КаталогОбменаНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыборФайла(Оповещение, КаталогОбмена, "ВыборКаталога");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("ВидТранспортаОфлайнОбмена", ВидОбмена);
	
	НовыеЗначениеПараметров.Вставить("КаталогОбмена", 		КаталогОбмена);
	НовыеЗначениеПараметров.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
	НовыеЗначениеПараметров.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", ПодключаемоеОборудование);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(
		ЭтотОбъект,
		ПодключаемоеОборудование,
		НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	ВходныеПараметры  = Неопределено;
	
	времПараметрыУстройства = Новый Структура;
	времПараметрыУстройства.Вставить("ВидОбмена", ВидОбмена);
	времПараметрыУстройства.Вставить("ИдентификаторУстройства", ПодключаемоеОборудование);
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		времПараметрыУстройства.Вставить("КаталогОбмена", 		КаталогОбмена);
		времПараметрыУстройства.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
		времПараметрыУстройства.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Команда", "ТестУстройства");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыполнениеКомандыОфлайнОборудования(ОписаниеОповещения,
		ПодключаемоеОборудование,
		ВходныеПараметры,
		времПараметрыУстройства,
		Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КаталогОбменаНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		КаталогОбмена = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов)
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
	
		ПорядковыйНомер = МассивРеквизитов.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			МассивРеквизитов.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатКоманды, ВыходныеПараметры) Экспорт
	
	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		И ВыходныеПараметры.Количество() >= 2,
		НСтр("ru = 'Дополнительное описание:';
			|en = 'Additional description:'") + " " + ВыходныеПараметры[1],
		"");
	
	Если РезультатКоманды.Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%';
								|en = 'Test completed successfully.%ПереводСтроки%%ДополнительноеОписание%'");
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ПереводСтроки%",
			?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ДополнительноеОписание%",
			?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%';
								|en = 'Test failed.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ПереводСтроки%",
			?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ДополнительноеОписание%",
			?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти