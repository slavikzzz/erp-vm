#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("НастройкаФормированияПроводок") Тогда
		ПланСчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.НастройкаФормированияПроводок, "Владелец");
		ДанныеЗаполнения.Вставить("ПланСчетов", ПланСчетов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("СчетУчетаДт");
	НепроверяемыеРеквизиты.Добавить("СчетУчетаКт");
	
	СтруктураЗаписи = Новый Структура;
	Для каждого Измерение Из Метаданные().Измерения Цикл
		СтруктураЗаписи.Вставить(Измерение.Имя);
	КонецЦикла;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
		КлючЗаписи = РегистрыСведений.НастройкиОтраженияКорреспонденцийВМеждународномУчете.СоздатьКлючЗаписи(СтруктураЗаписи);
		
		НастройкиПроводок = Справочники.НастройкиФормированияПроводокМеждународногоУчета.НастройкиФормированияПроводок(Запись.НастройкаФормированияПроводок);
		ОписаниеОбъектовУчета = Перечисления.ОбъектыФинансовогоУчета.ОписаниеОбъектовФинансовогоУчета(НастройкиПроводок);
		
		ОписаниеОбъектаУчетаДт = ОписаниеОбъектовУчета.Найти(Запись.ОбъектУчетаДт, "ОбъектУчета");
		ОписаниеОбъектаУчетаКт = ОписаниеОбъектовУчета.Найти(Запись.ОбъектУчетаКт, "ОбъектУчета");
		
		Если ОписаниеОбъектаУчетаДт = Неопределено Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Объект учета ""%1"" не используется с выбранными планом счетов и настройкой проводок';
										|en = 'The ""%1"" accounting object is not used with the selected chart of accounts and entry setting'"), Запись.ОбъектУчетаДт);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ОбъектУчетаДт", , Отказ);
		ИначеЕсли ОписаниеОбъектаУчетаДт.НесобственныеЦенности Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Объект учета ""%1"" не может образовывать корреспонденцию';
										|en = 'The ""%1"" accounting object cannot generate correspondence'"), Запись.ОбъектУчетаДт);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ОбъектУчетаДт", , Отказ);
		КонецЕсли;
		
		Если ОписаниеОбъектаУчетаКт = Неопределено Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Объект учета ""%1"" не используется с выбранными планом счетов и настройкой проводок';
										|en = 'The ""%1"" accounting object is not used with the selected chart of accounts and entry setting'"), Запись.ОбъектУчетаКт);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ОбъектУчетаКт", , Отказ);
		ИначеЕсли ОписаниеОбъектаУчетаКт.НесобственныеЦенности Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Объект учета ""%1"" не может образовывать корреспонденцию';
										|en = 'The ""%1"" accounting object cannot generate correspondence'"), Запись.ОбъектУчетаКт);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ОбъектУчетаКт", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.СчетУчетаДт) Тогда
			Если НЕ Запись.НеОтражаетсяНаСчетах И НЕ Запись.СчетУчетаОпределяетсяНастройкойОбъектаДт Тогда
				ТекстОшибки = НСтр("ru = 'Не заполнено поле ""Счет Дт""';
									|en = '""Dr account"" is required'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.СчетУчетаДт", , Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.СчетУчетаКт) Тогда
			Если НЕ Запись.НеОтражаетсяНаСчетах И НЕ Запись.СчетУчетаОпределяетсяНастройкойОбъектаКт Тогда
				ТекстОшибки = НСтр("ru = 'Не заполнено поле ""Счет Кт""';
									|en = '""Cr account"" is required'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.СчетУчетаКт", , Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если Запись.СчетУчетаОпределяетсяНастройкойОбъектаДт И Запись.СчетУчетаОпределяетсяНастройкойОбъектаКт Тогда
			ТекстОшибки = НСтр("ru = 'В настройке отражения корреспонденции необходимо переопределить хотя бы один счет учета, по дебету или по кредиту';
								|en = 'Override at least one ledger account by debit or credit in correspondence recording settings'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, , , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 1 И Отбор.ПорядокПрименения.Использование Тогда
		
		УстановитьБлокировкуЗаписейПоКорреспонденции();
		
		// Добавление одной настройки с указанным порядком. 
		// Возможно, требуется изменение порядка применения в других настройках по корреспонденции
		СтруктураЗаписи = Новый Структура;
		Для каждого Измерение Из Метаданные().Измерения Цикл
			СтруктураЗаписи.Вставить(Измерение.Имя, Отбор[Измерение.Имя].Значение);
		КонецЦикла;
		КлючЗаписи = РегистрыСведений.НастройкиОтраженияКорреспонденцийВМеждународномУчете.СоздатьКлючЗаписи(СтруктураЗаписи);
		
		НаборЗаписей = РегистрыСведений.НастройкиОтраженияКорреспонденцийВМеждународномУчете.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПланСчетов.Установить(Отбор.ПланСчетов.Значение);
		НаборЗаписей.Отбор.НастройкаФормированияПроводок.Установить(Отбор.НастройкаФормированияПроводок.Значение);
		НаборЗаписей.Отбор.ОбъектУчетаДт.Установить(Отбор.ОбъектУчетаДт.Значение);
		НаборЗаписей.Отбор.ОбъектУчетаКт.Установить(Отбор.ОбъектУчетаКт.Значение);
		НаборЗаписей.Отбор.ДолгосрочныйДт.Установить(Отбор.ДолгосрочныйДт.Значение);
		НаборЗаписей.Отбор.ДолгосрочныйКт.Установить(Отбор.ДолгосрочныйКт.Значение);
		
		НаборЗаписей.Прочитать();
		
		МинимальныйПорядокПримения = 1;
		МаксимальныйПорядокПрименения = НаборЗаписей.Количество() + 1;
		
		Если Отбор.ПорядокПрименения.Значение < МинимальныйПорядокПримения Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Порядок применения не может быть меньше %1';
										|en = 'The application order cannot be less than %1'"), МинимальныйПорядокПримения);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ПорядокПрименения", , Отказ);
		КонецЕсли;
		
		Если Отбор.ПорядокПрименения.Значение > МаксимальныйПорядокПрименения Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Порядок применения не может быть больше %1';
										|en = 'The application order cannot be greater than %1'"), МаксимальныйПорядокПрименения);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ПорядокПрименения", , Отказ);
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПорядокПрименения = Отбор.ПорядокПрименения.Значение;
		
		Для каждого Запись Из НаборЗаписей Цикл
			
			Если Запись.ПорядокПрименения = ПорядокПрименения Тогда
				Запись.ПорядокПрименения = Запись.ПорядокПрименения + 1;
			КонецЕсли;
			
			ПорядокПрименения = Запись.ПорядокПрименения;
			
		КонецЦикла;
		
		Если НаборЗаписей.Модифицированность() Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		
		УстановитьБлокировкуЗаписейПоКорреспонденции();
		
		// Удаление настройки. Необходимо обновить порядки применения других настроек.
		НаборЗаписей = РегистрыСведений.НастройкиОтраженияКорреспонденцийВМеждународномУчете.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПланСчетов.Установить(Отбор.ПланСчетов.Значение);
		НаборЗаписей.Отбор.НастройкаФормированияПроводок.Установить(Отбор.НастройкаФормированияПроводок.Значение);
		НаборЗаписей.Отбор.ОбъектУчетаДт.Установить(Отбор.ОбъектУчетаДт.Значение);
		НаборЗаписей.Отбор.ОбъектУчетаКт.Установить(Отбор.ОбъектУчетаКт.Значение);
		НаборЗаписей.Отбор.ДолгосрочныйДт.Установить(Отбор.ДолгосрочныйДт.Значение);
		НаборЗаписей.Отбор.ДолгосрочныйКт.Установить(Отбор.ДолгосрочныйКт.Значение);
		
		НаборЗаписей.Прочитать();
		
		ПорядокПрименения = 1;
		Для каждого Запись Из НаборЗаписей Цикл
			Запись.ПорядокПрименения = ПорядокПрименения;
			ПорядокПрименения = ПорядокПрименения + 1;
		КонецЦикла;
		
		Если НаборЗаписей.Модифицированность() Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьБлокировкуЗаписейПоКорреспонденции()

	БлокировкаДанных = Новый БлокировкаДанных();
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.НастройкиОтраженияКорреспонденцийВМеждународномУчете");
	ЭлементБлокировкиДанных.УстановитьЗначение("ПланСчетов", Отбор.ПланСчетов.Значение);
	ЭлементБлокировкиДанных.УстановитьЗначение("НастройкаФормированияПроводок", Отбор.НастройкаФормированияПроводок.Значение);
	ЭлементБлокировкиДанных.УстановитьЗначение("ОбъектУчетаДт", Отбор.ОбъектУчетаДт.Значение);
	ЭлементБлокировкиДанных.УстановитьЗначение("ОбъектУчетаКт", Отбор.ОбъектУчетаКт.Значение);
	ЭлементБлокировкиДанных.УстановитьЗначение("ДолгосрочныйДт", Отбор.ДолгосрочныйДт.Значение);
	ЭлементБлокировкиДанных.УстановитьЗначение("ДолгосрочныйКт", Отбор.ДолгосрочныйКт.Значение);
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	БлокировкаДанных.Заблокировать();

КонецПроцедуры


#КонецОбласти

#КонецЕсли
