#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем МассивПисем, ИндексОтправляемогоПисьма;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущееПисьмо = Параметры.ТекущееПисьмо;
	ОбновитьСостояние();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТаблицаПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьВсе(Команда)
	
	ОтправитьПисьма();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОтправитьПисьмаСписок()

	МассивПисем = Новый Массив;
	
	КопияТаблицы = ТаблицаПисем.Выгрузить();
	КопияТаблицы.Сортировать("Тема");
	
	Для Счетчик = 1 По КопияТаблицы.Количество() Цикл
		ТекущаяСтрока = КопияТаблицы[Счетчик - 1];
		Если ТекущаяСтрока.Статус <> 1 Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Новый Структура("Тип, Ссылка, Организация");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		МассивПисем.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат МассивПисем;
	
КонецФункции

&НаКлиенте
Процедура ОтправитьПисьма()
	
	ОбновитьСостояние();
	
	Если КоличествоНеОтправленных > 0 Тогда
		ТекстВопроса = "Все неотправленные письма из списка будут отправлены в контролирующий орган. Продолжить?";
	Иначе
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьПисьмаЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмаЗавершение(ОтветПользователя, ДополнительныеПараметры) Экспорт
	
	Если ОтветПользователя <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МассивПисем = ОтправитьПисьмаСписок();
	
	ИндексОтправляемогоПисьма = 0;
	ПодключитьОбработчикОжидания("Подключаемый_ОтправитьПисьмо", 0.2, Истина);
	
КонецПроцедуры
	
&НаКлиенте
Процедура Подключаемый_ОтправитьПисьмо()
	
	ВсегоПисем = МассивПисем.Количество();
	
	Если ИндексОтправляемогоПисьма >= ВсегоПисем Тогда
		ОбновитьСостояние();
		Если КоличествоНеОтправленных = 0 Тогда
			Закрыть(Истина);
		КонецЕсли;
	Иначе	
		ОтправляемоеПисьмо = МассивПисем[ИндексОтправляемогоПисьма];
		ИндексОтправляемогоПисьма = ИндексОтправляемогоПисьма + 1;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ОтправитьПисьмоЗавершение", ЭтотОбъект, ОтправляемоеПисьмо);
		
		Если ОтправляемоеПисьмо.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
			КонтекстЭДОКлиент.ОтправкаНеформализованногоДокументаВФНС(ОтправляемоеПисьмо.Ссылка, ОтправляемоеПисьмо.Организация, ОписаниеОповещения, ВсегоПисем = ИндексОтправляемогоПисьма);
		ИначеЕсли ОтправляемоеПисьмо.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР") Тогда
			КонтекстЭДОКлиент.ОтправкаНеформализованногоДокументаВПФР(ОтправляемоеПисьмо.Ссылка, ОтправляемоеПисьмо.Организация, ОписаниеОповещения, ВсегоПисем = ИндексОтправляемогоПисьма);
		ИначеЕсли ОтправляемоеПисьмо.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС") Тогда
			КонтекстЭДОКлиент.ОтправкаНеформализованногоДокументаВФСГС(ОтправляемоеПисьмо.Ссылка, ОтправляемоеПисьмо.Организация, ОписаниеОповещения, ВсегоПисем = ИндексОтправляемогоПисьма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьПисьмоЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПисьмоОтправлено = Ложь;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Ссылка) Тогда
		СтатусОтправки = КонтекстЭДОКлиент.ПолучитьСтатусОтправкиОбъекта(ДополнительныеПараметры.Ссылка);	
		ПисьмоОтправлено = ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> ПредопределенноеЗначение("Перечисление.СтатусыОтправки.ВКонверте");
	КонецЕсли;
	
	Если НЕ ПисьмоОтправлено Тогда
		ИндексОтправляемогоПисьма = МассивПисем.Количество();
		Активизировать();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Возникла ошибка при отправке писем.';
														|en = 'Возникла ошибка при отправке писем.'"));
	Иначе
		ПараметрыОповещения = Новый Структура(); 
		ПараметрыОповещения.Вставить("Ссылка", ДополнительныеПараметры.Ссылка);
		ПараметрыОповещения.Вставить("Организация", ДополнительныеПараметры.Организация);
		Оповестить("Завершение отправки в контролирующий орган", ПараметрыОповещения, ДополнительныеПараметры.Ссылка);
	КонецЕсли;

	ПодключитьОбработчикОжидания("Подключаемый_ОтправитьПисьмо", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояние()
	
	ТаблицаПисем.Загрузить(Справочники.ПерепискаСКонтролирующимиОрганами.СостояниеГрупповойОтправки(ТекущееПисьмо));
	ТаблицаПисем.Сортировать("Тема");
	
	НашлиСтроки = ТаблицаПисем.НайтиСтроки(Новый Структура("Статус", 1));
	КоличествоНеОтправленных = НашлиСтроки.Количество();
	
	НашлиСтроки = ТаблицаПисем.НайтиСтроки(Новый Структура("Ссылка", ТекущееПисьмо));
	Если НашлиСтроки.Количество() > 0 Тогда
		Элементы.ТаблицаПисем.ТекущаяСтрока = НашлиСтроки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Элементы.ФормаОтравитьВсе.Видимость = КоличествоНеОтправленных > 0;
	
КонецПроцедуры

#КонецОбласти
