
#Область ПрограммныйИнтерфейс

// Процедура начинает выполнение команды, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  Команда - Строка
//  ВходныеПараметры - Структура
//  ОбъектДрайвера - Структура
//  Параметры - Структура
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры, ОбъектДрайвера, Параметры) Экспорт
	
	ВыходныеПараметры = Новый Массив();
	
	// Тестирование устройства
	Если Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		НачатьТестУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ВыходныеПараметры);
		
	// Выгрузка данных на ККМ
	ИначеЕсли Команда = "ВыгрузитьДанные" Тогда
		
		НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		
		НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	ИначеЕсли Команда = "УстановитьФлагДанныеЗагружены" Тогда
		
		НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Выгрузка настроек в ККМ Offline
	ИначеЕсли Команда = "ВыгрузитьНастройки" Тогда
		
		НачатьВыгрузкуНастроек(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru = 'Команда ""%Команда%"" не поддерживается данным драйвером.';
										|en = 'The ""%Команда%"" command is not supported by the driver.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КомандыДрайвера

#Область КомандаВыгрузкаДанных

Процедура НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаВыгрузки;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ДополнительныеПараметры.Вставить("Параметры", Параметры);
		ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // 100Х
		
		НачатьВыгрузкуТоваров(
			ОповещениеПриЗавершении,
			Параметры,
			ВыходныеПараметры,
			ВходныеПараметры,
			Истина,
			Параметры.ВерсияФорматаОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПоискФайловВыгрузкиДанных(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Продолжает выгрузку данных
//
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура 
//   * ВыходныеПараметры - Структура
//   * Параметры - Структура
Процедура НачатьВыгрузкуДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Параметры = ДополнительныеПараметры.Параметры;
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	Если Результат.Успешно Тогда
		
		МассивФайлов = Новый Массив;
		Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
			МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
		КонецЦикла;
		
		ПакетыОбработаны = Ложь;
		ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Истина, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
		
		Если НЕ Отказ И НЕ ПакетыОбработаны Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Файл предыдущей выгрузки не обработан (загружен)';
															|en = 'Previous export file not processed (imported)'"));
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если НЕ Результат.СодержаниеФайлов.Количество() = 0 Тогда
			
			ОповещениеУдалениеФайлов = Новый ОписаниеОповещения("ОповещениеУдалениеФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
			
			Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
			
			НачатьУдалениеФайлов(ОповещениеУдалениеФайлов,
				Каталог,
				Параметры.ИмяФайлаВыгрузки + "*.xml");
			
		Иначе
			
			ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
			
		КонецЕсли;
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеУдалениеФайловВыгрузкиДанных(ДополнительныеПараметры) Экспорт
	
	ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
	
КонецПроцедуры

// Завершает выгрузку данных
//
// Параметры:
//  Результат - Булево
//  ДополнительныеПараметры - Структура 
//   * ВходныеПараметры - Структура
//   * Параметры - Структура
Процедура НачатьВыгрузкуДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВходныеПараметры 	= ДополнительныеПараметры.ВходныеПараметры;
	Параметры 			= ДополнительныеПараметры.Параметры;
	Каталог 			= ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	ИмяФайла = Параметры.ИмяФайлаВыгрузки;
	
	Результат = Истина;
	
	МассивИменФайлов = Новый Массив;
	
	ИмяФайла = Каталог + ИмяФайла + ".txml";
	МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайла, ".txml", ""));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайловВыгрузки", ЭтотОбъект, ДополнительныеПараметры);
	ДополнительныеПараметры.Вставить("МассивИменФайлов", МассивИменФайлов);
	ДополнительныеПараметры.Вставить("ТекущийИндексФайла", -1);
	
	ФайлДанныхВыгрузки = ОфлайнОборудование1СККМВызовСервера.ТекстовыйДокументДанныхВыгрузки(ВходныеПараметры.ДанныеДляВыгрузки, ВерсияФорматаОбмена);
	
	ФайлДанныхВыгрузки.НачатьЗапись(ОписаниеОповещения, ИмяФайла);
	
КонецПроцедуры

Процедура ОповещениеПеремещениеФайловВыгрузки(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.МассивИменФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайловВыгрузки", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПеремещениеФайла(ОписаниеОповещения, ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".txml", ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".xml");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандаЗагрузкаДанных

Процедура НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаЗагрузки;
	Иначе // 100Х
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогЗагрузки);
		ИмяФайла = Параметры.ИмяЗагружаемогоФайла;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", 		ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", 				Параметры);
	ДополнительныеПараметры.Вставить("ВходныеПараметры", 		ВходныеПараметры);
	ДополнительныеПараметры.Вставить("ВерсияФорматаОбмена", 	Параметры.ВерсияФорматаОбмена);
	
	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловЗагрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
	
КонецПроцедуры

Процедура ОповещениеПоискФайловЗагрузкиДанных(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если НайденныеФайлы.Количество()= 0 Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Файл загрузки не найден';
														|en = 'Import file not found.'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
	ФайлЗагрузки = НайденныеФайлы[0];
	ПолноеИмяФайла = ФайлЗагрузки.ПолноеИмя;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ПолноеИмяФайла, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Продолжает загрузку данных
//
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура 
//   * ВыходныеПараметры - Структура
//   * Параметры - Структура
Процедура НачатьЗагрузкуДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Параметры = ДополнительныеПараметры.Параметры;
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	Если Результат.Успешно Тогда
		
		МассивФайлов = Новый Массив;
		Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
			МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
		КонецЦикла;
		
		ПакетыОбработаны = Ложь;
		
		ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Ложь, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
		
		Если ПакетыОбработаны Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Файл загрузки был обработан ранее.';
															|en = 'Import file has been processed before.'"));
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		ОповещениеЗавершения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
		
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьЗагрузкуДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	Отказ = Ложь;
	РезультатЗагрузки = Истина;
	ДанныеИзККМ = Неопределено;
	
	Если Результат.Успешно И НЕ Результат.СодержаниеФайлов = Неопределено Тогда
		
		Если Результат.СодержаниеФайлов.Количество() Тогда
			
			XMLТекст = Результат.СодержаниеФайлов[0].ТекстСодержания;
			
			ДанныеИзККМ = ОфлайнОборудование1СККМВызовСервера.ЗагружаемыеДанныеИзККМ(
				Отказ,
				XMLТекст,
				ВыходныеПараметры,
				ВерсияФорматаОбмена);
			
			Если НЕ Отказ Тогда
				ВыходныеПараметры.Добавить(ДанныеИзККМ);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Отказ Тогда
		
		РезультатЗагрузки = Ложь;
		
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", РезультатЗагрузки, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область КомандаВыгрузкаНастроек

Процедура НачатьВыгрузкуНастроек(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаВыгрузки;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ДополнительныеПараметры.Вставить("Параметры", Параметры);
		ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // 100Х
		
		СтруктураНастроек   = ВходныеПараметры.ДанныеДляВыгрузки.НастройкиККМ;
		ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьНастройкиФормат1000Завершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогВыгрузки);
		ИмяФайла = Параметры.ИмяФайлаНастроек;
		
		ИмяФайла = Каталог + ИмяФайла + ".xml";
		
		ТекстовыйДокументНастроек = ОфлайнОборудование1СККМВызовСервера.ТекстовыйДокументНастроек(СтруктураНастроек, ВерсияФорматаОбмена);
		
		ТекстовыйДокументНастроек.НачатьЗапись(ОписаниеОповещения, ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьНастройкиФормат1000Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	Иначе
		СоздатьСообщениеОбОшибке(ДополнительныеПараметры.ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.';
																				|en = 'Cannot save the file.'"));
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандаУстановитьФлагДанныеЗагружены

Процедура НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаЗагрузки;
		
	Иначе // 100Х
		
		Каталог = Параметры.КаталогЗагрузки;
		ИмяФайла = Параметры.ИмяЗагружаемогоФайла;
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + ".*";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла, Ложь);
	
КонецПроцедуры

// Результат поиска файлов
// 
// Параметры:
//  НайденныеФайлы - Массив из Файл
//  ДополнительныеПараметры - Структура
//   * Параметры - Структура
Процедура ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	Параметры = ДополнительныеПараметры.Параметры;
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	МассивИменИФайлов    = Новый Массив;
	СтруктураИменИФайлов = Новый Структура("ИмяФайла, ТекстовыйФайл");
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		
		ТекстовыйДокументДанныеЗагружены   = ОфлайнОборудование1СККМВызовСервера.ТекстовыйДокументДанныеЗагружены(ВерсияФорматаОбмена);
		СтруктураИменИФайлов.ИмяФайла      = ИмяФайла;
		СтруктураИменИФайлов.ТекстовыйФайл = ТекстовыйДокументДанныеЗагружены;
		МассивИменИФайлов.Добавить(СтруктураИменИФайлов);
		
	КонецЦикла;
	
	ДополнительныеПараметры.Вставить("МассивИменИФайлов", МассивИменИФайлов);
	ДополнительныеПараметры.Вставить("ТекущийИндексФайла", -1);
	
	ОповещениеПоискФайловУстановкаФлагаДанныеЗагруженыЗавершение(Ложь, ДополнительныеПараметры);
	
КонецПроцедуры

// Завершение
//
// Параметры:
//  Результат - Булево
//  ДополнительныеПараметры - Структура:
//   * МассивИменИФайлов - Массив из Структура:
//      ** ИмяФайла - Строка
//      ** ТекстовыйФайл - ТекстовыйДокумент
Процедура ОповещениеПоискФайловУстановкаФлагаДанныеЗагруженыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.МассивИменИФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ЗначениеМассиваИменИФайлов = ДополнительныеПараметры.МассивИменИФайлов.Получить(ДополнительныеПараметры.ТекущийИндексФайла);
		ФайлУстановкаФлагаДанныеЗагружены = ЗначениеМассиваИменИФайлов.ТекстовыйФайл; // ТекстовыйДокумент
		ИмяФайлаУстановкаФлагаДанныеЗагружены = ЗначениеМассиваИменИФайлов.ИмяФайла;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискФайловУстановкаФлагаДанныеЗагруженыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ФайлУстановкаФлагаДанныеЗагружены.НачатьЗапись(ОписаниеОповещения, ИмяФайлаУстановкаФлагаДанныеЗагружены);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Асинхронно
Процедура НачатьВыгрузкуТоваров(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры, ВходныеПараметры, ЧастичнаяВыгрузка, ВерсияФорматаОбмена)
	
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогВыгрузки);
	ИмяФайла = Параметры.ИмяФайлаПрайсЛиста;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Каталог", Каталог);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);
	ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
	ДополнительныеПараметры.Вставить("ЧастичнаяВыгрузка", ЧастичнаяВыгрузка);
	ДополнительныеПараметры.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
	
	Если ЧастичнаяВыгрузка Тогда
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // Полная выгрузка, поиск файлов пропускается
		
		РезультатЧтенияФайлов = Новый Структура;
		РезультатЧтенияФайлов.Вставить("СодержаниеФайлов", Новый Массив);
		РезультатЧтенияФайлов.Вставить("Успешно", Истина);
		РезультатЧтенияФайлов.Вставить("ТекстОшибки", "");
		
		ОповещениеПродолжения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеПродолжения, РезультатЧтенияФайлов);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПоискФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Продолжает выгрузку товаров
//
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура 
//   * ВыходныеПараметры - Структура
//   * Параметры - Структура
Процедура НачатьВыгрузкуТоваровПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	
	Если ДополнительныеПараметры.ЧастичнаяВыгрузка Тогда
		
		Если Результат.Успешно Тогда
			
			МассивФайлов = Новый Массив;
			Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
				МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
			КонецЦикла;
			
			ПакетыОбработаны = Ложь;
			ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Истина, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
			
			Если НЕ Отказ И НЕ ПакетыОбработаны Тогда
				СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не все файлы предыдущей выгрузки обработаны';
																|en = 'Not all files of previous export are processed'"));
				Отказ = Истина;
			КонецЕсли;
			
		Иначе
			
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если НЕ ДополнительныеПараметры.ЧастичнаяВыгрузка
			ИЛИ (ДополнительныеПараметры.ЧастичнаяВыгрузка И НЕ Результат.СодержаниеФайлов.Количество() = 0) Тогда
			
			ОповещениеУдалениеФайлов = Новый ОписаниеОповещения("ОповещениеУдалениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
			
			НачатьУдалениеФайлов(ОповещениеУдалениеФайлов,
				ДополнительныеПараметры.Каталог,
				ДополнительныеПараметры.Параметры.ИмяФайлаПрайсЛиста + "*.xml");
			
		Иначе
			
			ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжениеЗаписи", ЭтотОбъект, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
			
		КонецЕсли;
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеУдалениеФайлов(ДополнительныеПараметры) Экспорт
	
	ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжениеЗаписи", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
	
КонецПроцедуры

// Продолжает выгрузку товаров
//
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура 
//   * ВходныеПараметры - Структура
//   * Параметры - Структура
Процедура НачатьВыгрузкуТоваровПродолжениеЗаписи(Результат, ДополнительныеПараметры) Экспорт
	
	Каталог = ДополнительныеПараметры.Каталог;
	Параметры = ДополнительныеПараметры.Параметры;
	ВходныеПараметры = ДополнительныеПараметры.ВходныеПараметры;
	КоличествоЭлементовВПакете = Параметры.КоличествоЭлементовВПакете;
	ИмяФайла = Параметры.ИмяФайлаПрайсЛиста;
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	
	СтруктураПрайсЛиста = ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист;
	Результат = Истина;
	
	МассивИменФайлов = Новый Массив;
	
	Если Параметры.КоличествоЭлементовВПакете = 0 Тогда
		
		ИмяФайла = Каталог + ИмяФайла + ".txml";
		МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайла, ".txml", ""));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстовыйДокументПрайсЛист = ОфлайнОборудование1СККМВызовСервера.ТекстовыйДокументПрайсЛиста(СтруктураПрайсЛиста, ВерсияФорматаОбмена);
		ТекстовыйДокументПрайсЛист.НачатьЗапись(ОписаниеОповещения, ЭтотОбъект);
		
	Иначе
		
		МассивПакетов = ОфлайнОборудование1СККМВызовСервера.ПрайсЛистПоПакетам(СтруктураПрайсЛиста, КоличествоЭлементовВПакете);
		НомерПакета = 1;
		
		МассивИменИФайлов    = Новый Массив;
		СтруктураИменИФайлов = Новый Структура("ИмяФайла, ТекстовыйФайл");
		
		Для Каждого Пакет Из МассивПакетов Цикл
			
			Если НЕ Результат Тогда
				Прервать;
			КонецЕсли;
			
			
			ИмяФайлаНумерованный = Каталог + ИмяФайла + Формат(Пакет.НомерПакета, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0")+".txml";
			МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайлаНумерованный, ".txml", ""));
			ТекстовыйДокументПрайсЛист = ОфлайнОборудование1СККМВызовСервера.ТекстовыйДокументПрайсЛиста(СтруктураПрайсЛиста, ВерсияФорматаОбмена);
			НомерПакета = НомерПакета + 1;
			СтруктураИменИФайлов.ИмяФайла      = ИмяФайла;
			СтруктураИменИФайлов.ТекстовыйФайл = ТекстовыйДокументПрайсЛист;
			МассивИменИФайлов.Добавить(СтруктураИменИФайлов);
			
		КонецЦикла;
		
		ДополнительныеПараметры.Вставить("МассивИменФайлов", МассивИменФайлов);
		ДополнительныеПараметры.Вставить("ТекущийИндексФайла", -1);
		НачатьВыгрузкуТоваровЗавершение(Ложь, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Завершение
//
// Параметры:
//  Результат - Булево
//  ДополнительныеПараметры - Структура:
//   * МассивИменИФайлов - Массив из Структура:
//      ** ИмяФайла - Строка
//      ** ТекстовыйФайл - ТекстовыйДокумент
Процедура НачатьВыгрузкуТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		
		СоздатьСообщениеОбОшибке(ДополнительныеПараметры.ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.';
																				|en = 'Cannot save the file.'"));
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);		
		
	КонецЕсли;
	
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла=ДополнительныеПараметры.МассивИменФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
		
	Иначе
		
		ЗначениеМассиваИменИФайлов = ДополнительныеПараметры.МассивИменФайлов.Получить[ДополнительныеПараметры.ТекущийИндексФайла];
		ФайлУстановкаФлагаДанныеЗагружены = ЗначениеМассиваИменИФайлов.ТекстовыйФайл; // ТекстовыйДокумент
		ИмяФайлаУстановкаФлагаДанныеЗагружены = ЗначениеМассиваИменИФайлов.ИмяФайла;
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ФайлУстановкаФлагаДанныеЗагружены.НачатьЗапись(ОписаниеОповещения, ИмяФайлаУстановкаФлагаДанныеЗагружены);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПеремещениеФайлов(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущийИндексФайла = -1;
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла=ДополнительныеПараметры.МассивИменФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПеремещениеФайла(ОписаниеОповещения, ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".txml", ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".xml");
		
	КонецЕсли;
	
КонецПроцедуры

///////

// Функция проверяет корректность заполнения параметров драйвера.
//	При успешном прохождении проверки вернет "Истина", иначе "Ложь".
//	Параметры:
//		- ОбъектДрайвера.
//		- Параметры.
//		- ВыходныеПараметры.
Функция ТестУстройства(Параметры, ВыходныеПараметры)
	
	Результат = Истина;
	
	ТекстОшибкиОбщий = "";
	ВремПараметр = "";
	ВерсияФорматаОбмена = 0;
	ВидОбмена = Неопределено;
	
	Параметры.Свойство("ВерсияФорматаОбмена", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru = 'Версия формата обмена не указана';
								|en = 'Exchange format version not specified'");
	Иначе
		ВерсияФорматаОбмена = ВремПараметр;
	КонецЕсли;
	
	Параметры.Свойство("ВидТранспортаОфлайнОбмена", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru = 'Вид обмена не указан';
								|en = 'Exchange kind is not specified'");
	Иначе
		ВидОбмена = Параметры.ВидТранспортаОфлайнОбмена;
	КонецЕсли;
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		Если ВерсияФорматаОбмена > 1000 И ВерсияФорматаОбмена < 2000 Тогда
			
			Параметры.Свойство("КаталогВыгрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = НСтр("ru = 'Каталог выгрузки не указан';
										|en = 'Export directory is not specified'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаПрайсЛиста", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имя файла прайс-листа не указано';
															|en = 'Price list file name is not specified'") 
			КонецЕсли;
			
			Параметры.Свойство("КаталогЗагрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Каталог загрузки не указан';
															|en = 'Import directory is not specified'") 
			КонецЕсли;
			
			Параметры.Свойство("ИмяЗагружаемогоФайла", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имя файла отчета не указано';
															|en = 'Report file name is not specified'") 
			КонецЕсли;
			
			Параметры.Свойство("КоличествоЭлементовВПакете", ВремПараметр);
			Если ВремПараметр=Неопределено Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Не указано количество элементов в пакете';
															|en = 'Number of items in the package is not specified'") 
			КонецЕсли;
			
			Если Результат Тогда
				Если Лев(Параметры.ИмяЗагружаемогоФайла, СтрДлина(Параметры.ИмяФайлаПрайсЛиста)) = Параметры.ИмяФайлаПрайсЛиста Тогда
					Результат = Ложь;
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имена выгружаемого и загружаемого файлов не должны пересекаться.';
																|en = 'Imported and exported file names should not be the same.'"); 
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ВерсияФорматаОбмена > 2000 Тогда
			
			Параметры.Свойство("КаталогОбмена", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = НСтр("ru = 'Каталог обмена не указан';
										|en = 'Exchange directory is not specified'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаЗагрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имя файла выгрузки не указано';
															|en = 'Export file name is not specified'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаВыгрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имя файла загрузки не указано';
															|en = 'Import file name is not specified'");
			КонецЕсли;
			
			Если Результат Тогда
				Если НРег(Параметры.ИмяФайлаВыгрузки) = НРег(Параметры.ИмяФайлаЗагрузки) Тогда
					Результат = Ложь;
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Имена файлов загрузки и выгрузки не должны совпадать';
																|en = 'Import and export files cannot have the same names'");
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.WS") Тогда
		
		Параметры.Свойство("ИдентификаторWebСервисОборудования", ВремПараметр);
		Если ПустаяСтрока(ВремПараметр) Тогда
			Результат = Ложь;
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Идентификатор оборудования не указан';
														|en = 'Equipment ID is not specified'");
			
		Иначе
			
			Уникален = ОфлайнОборудование1СККМВызовСервера.УникальностьИдентификатораWebСервисОборудования(Параметры.ИдентификаторУстройства, ВремПараметр);
			
			Если НЕ Уникален Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru = 'Указан неуникальный идентификатор оборудования';
															|en = 'Non-unique equipment ID is specified'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	Если НЕ ПустаяСтрока(ТекстОшибкиОбщий) Тогда
		ВыходныеПараметры.Добавить(ТекстОшибкиОбщий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура осуществляет тестирование устройства.
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ВыходныеПараметры)
	
	Результат = ТестУстройства(Параметры, ВыходныеПараметры);
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

// Дополнить имя каталога слешем.
// 
// Параметры:
//  ИмяКаталога - Строка - Имя каталога
// 
// Возвращаемое значение:
//  Строка.
Функция ДополнитьИмяКаталогаСлешем(Знач ИмяКаталога)
	
	Если Найти(ИмяКаталога, "ftp") > 0 Тогда
		Слеш = "/";
	Иначе
		Слеш = "\";
	КонецЕсли;
	
	Если НЕ Прав(ИмяКаталога,1) = Слеш Тогда
		ИмяКаталога = ИмяКаталога + Слеш;
	КонецЕсли;
	
	Возврат ИмяКаталога;
	
КонецФункции

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке.
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти