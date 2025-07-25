#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбменСБанкамиКлиентСервер.ЗаполненыРеквизитыНастройкиОбмена(ЭтотОбъект) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не НастройкаОбменаУникальна() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ПрограммаБанка = Перечисления.ПрограммыБанка.АсинхронныйОбмен
		И НЕ ЗначениеЗаполнено(ВерсияФормата) Тогда
		ВерсияФормата = ОбменСБанкамиКлиентСервер.АктуальнаяВерсияФорматаАсинхронногоОбмена();
	КонецЕсли;
	
	Если ЭтоНовый() И ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн Тогда
		// По умолчанию сразу устанавливаем признак.
		ОтправлятьДокументыБезПодписиSMS = Истина;
	КонецЕсли;
	
	// Маршрут подписания электронного документа формируется в момент его формирования.
	// Если электронный документ был создан с настройкой без подписи, а потом настройка изменена на использование подписи,
	// то необходимо в существующих неотправленных электронных документах заполнить маршрут подписания.
	// Это имеет смысл делать только для документов за последние 10 дней.
	Если УстановленПризнакПодписиПлатежногоДокумента() Тогда
		ДополнительныеСвойства.Вставить("ЗаполнитьМаршрутПодписанияПоследнихПлатежныхДокументов");
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьПоддержкаПисем = ОбменСБанкамиСлужебный.ЕстьПоддержкаПисем();
	Если Не ЕстьПоддержкаПисем Тогда 
		УстановитьПривилегированныйРежим(Истина); 		
		ЕстьИсторияПисем = ОбменСБанкамиСлужебный.ЕстьИсторияПисем();
		ДоступностьПисем = ЕстьПоддержкаПисем Или ЕстьИсторияПисем;
		Константы.ПисьмаОбменСБанками.Установить(ДоступностьПисем);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЗаполнитьМаршрутПодписанияПоследнихПлатежныхДокументов") Тогда
		НаименованиеЗадания = НСтр("ru = '1С:ДиректБанк: Заполнение маршрутов подписи.';
									|en = '1C:DirectBank: Filling in the signature routes.'");
		Параметры = Новый Массив;
		Параметры.Добавить(Ссылка);
		ФоновыеЗадания.Выполнить("ОбменСБанкамиСлужебный.УстановитьМаршрутПодписанияПоследнихПлатежныхДокументов",
			Параметры, , НаименованиеЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет что настройка уникальна.
//
// Возвращаемое значение:
//  Булево - если настройка уникальна, то истина.
//
Функция НастройкаОбменаУникальна()
	
	Если ПометкаУдаления ИЛИ Недействительна Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) ИЛИ НЕ ЗначениеЗаполнено(Банк) Тогда
		Возврат Истина
	КонецЕсли;
	
	ТекущаяНастройкаУникальна = Истина;
	
	// Проверка на уникальное использование настройки по реквизитам: Организация, Банк
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяНастройка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Банк", Банк);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НастройкиОбмена.Банк,
	|	НастройкиОбмена.Организация
	|ИЗ
	|	Справочник.НастройкиОбменСБанками КАК НастройкиОбмена
	|ГДЕ
	|	НЕ НастройкиОбмена.ПометкаУдаления
	|	И НастройкиОбмена.Организация = &Организация
	|	И НастройкиОбмена.Банк = &Банк
	|	И НастройкиОбмена.Ссылка <> &ТекущаяНастройка
	|	И НЕ НастройкиОбмена.Недействительна";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТекущаяНастройкаУникальна = Ложь;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ШаблонСообщения = НСтр("ru = 'В информационной базе уже существует действующая настройка обмена
									|между банком %1 и организацией %2';
									|en = 'The valid setting of exchange
									|between the %1 bank and the %2 company already exists in the infobase'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.Банк, Выборка.Организация);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекущаяНастройкаУникальна;
	
КонецФункции

Функция УстановленПризнакПодписиПлатежногоДокумента()
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИскомаяСтрока = ИсходящиеДокументы.Найти(Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение, "ИсходящийДокумент");
	
	Если ИскомаяСтрока = Неопределено ИЛИ НЕ ИскомаяСтрока.ИспользоватьЭП Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА НастройкиОбменСБанкамиИсходящиеДокументы.СпособПодтвержденияДокумента <> ЗНАЧЕНИЕ(Перечисление.СпособыПодтвержденияДокументовОбменСБанками.ПустаяСсылка)
	|			ТОГДА НастройкиОбменСБанкамиИсходящиеДокументы.СпособПодтвержденияДокумента = ЗНАЧЕНИЕ(Перечисление.СпособыПодтвержденияДокументовОбменСБанками.ЭлектроннаяПодпись)
	|		ИНАЧЕ НастройкиОбменСБанкамиИсходящиеДокументы.ИспользоватьЭП
	|	КОНЕЦ КАК ИспользоватьЭП
	|ИЗ
	|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
	|ГДЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка = &Ссылка
	|	И НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭДОбменСБанками.ПлатежноеПоручение)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат НЕ Выборка.ИспользоватьЭП;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Иначе
	
#Область Инициализация
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
							|en = 'Invalid object call on the client.'");
	
#КонецОбласти
	
#КонецЕсли

