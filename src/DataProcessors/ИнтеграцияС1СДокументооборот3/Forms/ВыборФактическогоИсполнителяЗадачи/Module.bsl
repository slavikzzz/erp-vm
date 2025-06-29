#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	ДанныеXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СтрокаВОбъектXDTO(
		Прокси,
		Параметры.ТребуемоеИнтерактивноеДействие.Контекст);
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ДанныеXDTO, "addressees") Тогда
		Для Каждого СтрокаXDTO Из ДанныеXDTO.addressees Цикл
			Строка = АдресатыЗадачи.Добавить();
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(СтрокаXDTO, "addressee") Тогда
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
					Строка,
					СтрокаXDTO.addressee,
					"Адресат");
			КонецЕсли;
			Строка.ЭтоЗамещающий = СтрокаXDTO.isDeputy;
		КонецЦикла;
	КонецЕсли;
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ДанныеXDTO, "actualPerformers") Тогда
		Для Каждого СтрокаXDTO Из ДанныеXDTO.actualPerformers Цикл
			Строка = ФактическиеИсполнители.Добавить();
			Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(СтрокаXDTO, "actualPerformer") Тогда
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
					Строка,
					СтрокаXDTO.actualPerformer,
					"Сотрудник");
			КонецЕсли;
			Строка.Исполнитель = СтрокаXDTO.performerPresentation;
		КонецЦикла;
	КонецЕсли;
	
	ЕстьАдресаты = АдресатыЗадачи.Количество() > 1;
	ЕстьФактИсполнители = ФактическиеИсполнители.Количество() > 1;
	Элементы.ГруппаАдресаты.Видимость = ЕстьАдресаты;
	Элементы.ГруппаФактическийИсполнитель.Видимость = ЕстьФактИсполнители;
	
	Если ЕстьАдресаты И ЕстьФактИсполнители Тогда
		Заголовок = НСтр("ru = 'Выбор фактического исполнителя и сотрудника, за которого выполняется задача';
						|en = 'Select an actual assignee and an employee whose task is to be performed'");
		УстановитьКлючНазначенияФормы("ПланФакт");
	ИначеЕсли ЕстьАдресаты Тогда
		Заголовок = НСтр("ru = 'Выбор сотрудника, за которого выполняется задача';
						|en = 'Select an employee whose task is to be performed'");
		УстановитьКлючНазначенияФормы("План");
		Элементы.ПояснениеАдресаты.Заголовок = НСтр("ru = 'Укажите сотрудника:';
													|en = 'Select an employee:'");
	Иначе
		Заголовок = НСтр("ru = 'Выбор фактического исполнителя задачи';
						|en = 'Select an actual task assignee'");
		УстановитьКлючНазначенияФормы("Факт");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресатыЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийИсполнительВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("Адресат", Неопределено);
	СтруктураВозврата.Вставить("ЭтоЗамещающий", Ложь);
	СтруктураВозврата.Вставить("Сотрудник", Неопределено);
	
	Если ЕстьАдресаты Тогда
		ТекущиеАдресаты = Элементы.АдресатыЗадачи.ТекущиеДанные;
		Если ТекущиеАдресаты = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СтруктураВозврата.Вставить("Адресат", ДанныеСсылочногоОбъектаДО(ТекущиеАдресаты, "Адресат"));
		СтруктураВозврата.Вставить("ЭтоЗамещающий", ТекущиеАдресаты.ЭтоЗамещающий);
		
	ИначеЕсли АдресатыЗадачи.Количество() > 0 И ЗначениеЗаполнено(АдресатыЗадачи[0].АдресатID) Тогда
		СтруктураВозврата.Вставить("Адресат", ДанныеСсылочногоОбъектаДО(АдресатыЗадачи[0], "Адресат"));
		СтруктураВозврата.Вставить("ЭтоЗамещающий", АдресатыЗадачи[0].ЭтоЗамещающий);
		
	КонецЕсли;
	
	Если ЕстьФактИсполнители Тогда
		ТекущийИсполнитель = Элементы.ФактическийИсполнитель.ТекущиеДанные;
		Если ТекущийИсполнитель = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийИсполнитель.СотрудникID) Тогда
			СтруктураВозврата.Вставить("Сотрудник", ДанныеСсылочногоОбъектаДО(ТекущийИсполнитель, "Сотрудник"));
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ФактическиеИсполнители[0].СотрудникID) Тогда
		СтруктураВозврата.Вставить("Сотрудник", ДанныеСсылочногоОбъектаДО(ФактическиеИсполнители[0], "Сотрудник"));
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураВозврата.Сотрудник) Тогда
		СтруктураВозврата.Вставить("Сотрудник", СтруктураВозврата.Адресат);
	КонецЕсли;
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ДанныеСсылочногоОбъектаДО(Строка, ИмяРеквизита)
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		Строка[ИмяРеквизита + "ID"],
		Строка[ИмяРеквизита + "Тип"],
		Строка[ИмяРеквизита]);
	
КонецФункции

&НаСервере
Процедура УстановитьКлючНазначенияФормы(Ключ)
	
	КлючНазначенияИспользования = Ключ;
	КлючСохраненияПоложенияОкна = Ключ;
	
КонецПроцедуры

#КонецОбласти