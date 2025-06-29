#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет таможенную декларацию на экспорт данными из документа-основания
//
Процедура ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию() Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ЗаполнитьПоДокументамОснованиям(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("Организация") И ДанныеЗаполнения.Организация <> Организация Тогда
		Организация = ДанныеЗаполнения.Организация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = Метаданные.Документы.ТаможеннаяДекларацияЭкспорт.Реквизиты.ДокументОснование.Тип;
	Если ДанныеЗаполнения <> Неопределено И ТипОснования.СодержитТип(ТипЗнч(ДанныеЗаполнения)) Тогда

		НоваяСтрока = ДокументыОснования.Добавить();
		НоваяСтрока.ДокументОснование = ДанныеЗаполнения;
		ДанныеЗаполнения = Новый Структура("ДокументОснование", НоваяСтрока.ДокументОснование);
		ЗаполнитьПоДокументамОснованиям(ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДокументОснование")
		И ЗначениеЗаполнено(ДанныеЗаполнения.ДокументОснование) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("Массив") Тогда
			МассивОснований = ДанныеЗаполнения.ДокументОснование;
		Иначе
			МассивОснований = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаполнения.ДокументОснование);
		КонецЕсли;
		
		Для Каждого Основание Из МассивОснований Цикл
			Если ТипОснования.СодержитТип(ТипЗнч(Основание)) Тогда
				НоваяСтрока = ДокументыОснования.Добавить();
				НоваяСтрока.ДокументОснование = Основание;
			КонецЕсли;
		КонецЦикла;
		
		ЗаполнитьПоДокументамОснованиям(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьТаблицуОснований(Отказ);
	ПровестиФЛКНомераДекларации(Отказ);
	ПроверитьСопроводительныеДокументы(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДокументыОснования(Отказ);
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	РеализацииЭкспорт = ЭтотОбъект.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
	РегистрыСведений.ТаможенныеДекларацииЭкспортКРегистрации.ОбновитьСостояние(РеализацииЭкспорт);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументыОснования.Очистить();
	ДокументОснование = Неопределено;
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументамОснованиям(ДанныеЗаполнения)
	
	Если ДокументыОснования.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДекларации = ПолучитьПараметрыТаможеннойДекларацииПоОснованиям();
	
	Если Не ПараметрыДекларации.Организация = Неопределено Тогда
		ДанныеЗаполнения.Вставить("Организация", ПараметрыДекларации.Организация);
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Ввод таможенной декларации на экспорт на основании %1 не требуется.';
				|en = 'Entering export customs declaration based on %1 is not required.'"),
			ДокументыОснования[0].ДокументОснование);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДекларации,, "Организация");
	
КонецПроцедуры

Функция ПолучитьПараметрыТаможеннойДекларацииПоОснованиям()
	
	Результат = Новый Структура("Организация, Контрагент, Партнер, Договор,
		|НаправлениеДеятельности, Подразделение, Склад, ДокументОснование");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеОснований.Ссылка                  КАК ДокументОснование,
	|	ДанныеОснований.Проведен                КАК Проведен,
	|	ДанныеОснований.Организация             КАК Организация,
	|	ДанныеОснований.Подразделение           КАК Подразделение,
	|	ДанныеОснований.Контрагент.Ключ         КАК Контрагент,
	|	ДанныеОснований.Партнер                 КАК Партнер,
	|	ДанныеОснований.Договор                 КАК Договор,
	|	ДанныеОснований.МестоХранения.Ключ      КАК Склад,
	|	ДанныеОснований.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК ДанныеОснований
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОснованийСФ
	|		ПО ДанныеОснований.Ссылка = ДанныеОснованийСФ.Регистратор
	|			И ДанныеОснованийСФ.НалогообложениеНДС В (
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНаЭкспорт),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг))
	|ГДЕ
	|	ДанныеОснований.Ссылка В(&ДокументыОснования)
	|";
	
	Запрос.Текст = ТекстЗапроса;
	
	ПерваяСтрока      = Истина;
	РазныеОрганизации = Ложь;
	РазныеКонтрагенты = Ложь;
	РазныеПартнеры    = Ложь;
	РазныеДоговоры    = Ложь;
	РазныеСклады      = Ложь;
	РазныеПодразделения = Ложь;
	РазныеНаправленияДеятельности = Ложь;
	
	ВыборкаОснований = Запрос.Выполнить().Выбрать();
	Пока ВыборкаОснований.Следующий() Цикл
		
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
			ВыборкаОснований.ДокументОснование, , НЕ ВыборкаОснований.Проведен);
		
		Если ПерваяСтрока Тогда
			ЗаполнитьЗначенияСвойств(Результат, ВыборкаОснований);
			Продолжить;
		КонецЕсли;
		
		РазныеОрганизации   = РазныеОрганизации Или Результат.Организация <> ВыборкаОснований.Организация;
		РазныеКонтрагенты   = РазныеКонтрагенты Или Результат.Контрагент <> ВыборкаОснований.Контрагент;
		РазныеПартнеры      = РазныеПартнеры Или Результат.Партнер <> ВыборкаОснований.Партнер;
		РазныеДоговоры      = РазныеДоговоры Или Результат.Договор <> ВыборкаОснований.Договор;
		РазныеСклады        = РазныеСклады Или Результат.Склад <> ВыборкаОснований.Склад;
		РазныеПодразделения = РазныеПодразделения Или Результат.Подразделение <> ВыборкаОснований.Подразделение;
		РазныеНаправленияДеятельности = РазныеНаправленияДеятельности
			Или Результат.НаправлениеДеятельности <> ВыборкаОснований.НаправлениеДеятельности;
		
	КонецЦикла;
	
	Если РазныеОрганизации Тогда
		Результат.Организация = Неопределено;
	КонецЕсли;
	Если РазныеКонтрагенты Тогда
		Результат.Контрагент = Неопределено;
	КонецЕсли;
	Если РазныеПартнеры Тогда
		Результат.Партнер = Неопределено;
	КонецЕсли;
	Если РазныеДоговоры Тогда
		Результат.Договор = Неопределено;
	КонецЕсли;
	Если РазныеСклады Тогда
		Результат.Склад = Неопределено;
	КонецЕсли;
	Если РазныеПодразделения Тогда
		Результат.Подразделение = Неопределено;
	КонецЕсли;
	Если РазныеНаправленияДеятельности Тогда
		Результат.НаправлениеДеятельности = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиПроверкиЗаполнения

Процедура ПровестиФЛКНомераДекларации(Отказ)
	
	ДлинаНомера = СтрДлина(СокрЛП(Номер));
	Если ДлинаНомера = 23 ИЛИ (ДлинаНомера >= 25 И ДлинаНомера <= 29) Тогда
		Возврат;
		
	Иначе
		ТекстСообщения =
			НСтр("ru = 'Регистрационный номер таможенной декларации должен состоять либо из 23 символов, либо количество символов должно быть от 25 до 29.';
				|en = 'Customs declaration registration number should contain either 23 characters or 25 - 29 characters.'");
			
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле",
			"Корректность",
			"Номер", , ,
			ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Номер", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьТаблицуОснований(Отказ)
	
	КоличествоОснований = ДокументыОснования.Количество();
	
	Если КоличествоОснований = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки в список ""Основания""';
								|en = 'No line is entered in the ""Bases"" list'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДокументыОснованияПредставление", , Отказ);
	КонецЕсли;
	
	ДокументыНеПроведены = Ложь;
	
	Если ДокументыОснования.Количество() > 0 Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеестрДокументов.Проведен КАК Проведен
		|ИЗ
		|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|ГДЕ
		|	РеестрДокументов.Ссылка В(&ДокументыОснования)");
		Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл
			Если Не Выборка.Проведен Тогда
				ДокументыНеПроведены = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДокументыНеПроведены Тогда
		Если КоличествоОснований > 1 Тогда
			ТекстСообщения = НСтр("ru = 'Таможенную декларацию можно провести, если проведены все документы списка ""Документы-основания"".';
									|en = 'Customs declaration can be posted if all documents on the ""Base documents"" list are posted.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Таможенную декларацию можно провести только на основании проведенного документа.';
									|en = 'Customs declaration can be posted only based on the posted document.'");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДокументыОснованияПредставление", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСопроводительныеДокументы(Отказ)
	
	Для Каждого СопроводительныйДокумент Из СопроводительныеДокументы Цикл
		
		Префикс = "Объект.СопроводительныеДокументы[%1].";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(СопроводительныйДокумент.НомерСтроки - 1, "ЧН=0; ЧГ="));
			
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.КодТС) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru = 'Код ТС';
					|en = 'Vehicle code'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru = 'Сопроводительные документы';
					|en = 'Supporting documents'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "КодТС", , Отказ);
		КонецЕсли;
		
		Если СопроводительныйДокумент.КодТС = "71" ИЛИ СопроводительныйДокумент.КодТС = "72" Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.ВидДокумента) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru = 'Вид документа';
					|en = 'Document kind'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru = 'Сопроводительные документы';
					|en = 'Supporting documents'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "ВидДокумента", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.НомерТСД) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru = 'Номер';
					|en = 'Number'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru = 'Сопроводительные документы';
					|en = 'Supporting documents'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "НомерТСД", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.ДатаТСД) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru = 'Дата';
					|en = 'Date'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru = 'Сопроводительные документы';
					|en = 'Supporting documents'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "ДатаТСД", , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьДокументыОснования(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ2.Ссылка
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК Документ1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК Документ2
	|		ПО Документ1.ДокументОснование = Документ2.ДокументОснование
	|ГДЕ
	|	Документ2.Ссылка.Проведен
	|	И Документ1.Ссылка = &Ссылка
	|	И Документ2.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СообщениеПользователю = Новый СообщениеПользователю;
			ТекстСообщения = НСтр("ru = 'На основании документа ""%ДокументОснование%"" уже введена ""%ТаможеннаяДекларация%"". Документ не записан.';
									|en = '%ТаможеннаяДекларация% is already entered on the basis of the %ДокументОснование% document. The document is not saved.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТаможеннаяДекларация%", Ссылка);
			СообщениеПользователю.Текст = ТекстСообщения;
			СообщениеПользователю.Сообщить();
		КонецЦикла; 
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли