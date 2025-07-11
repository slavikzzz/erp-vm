///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Ссылка  - СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы,
//            СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы - ссылка на файл, который необходимо
//                                                                            открыть.
//
Процедура ОткрытьВложение(Ссылка, Форма, ДляРедактирования = Ложь) Экспорт

	ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(Ссылка, Форма.УникальныйИдентификатор);
	
	Если Форма.ЗапрещенныеРасширения.НайтиПоЗначению(ДанныеФайла.Расширение) <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура("ДанныеФайла", ДанныеФайла);
		ДополнительныеПараметры.Вставить("ДляРедактирования", ДляРедактирования);
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьФайлПослеПодтверждения", ЭтотОбъект, ДополнительныеПараметры);
		ПользователиСлужебныйКлиент.ПоказатьПредупреждениеБезопасности(Оповещение,
			ПользователиСлужебныйКлиентСервер.ВидыПредупрежденийБезопасности().ПередОткрытиемФайла,
			ДанныеФайла.ИмяФайла);
		Возврат;
		
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, ДляРедактирования);
	
КонецПроцедуры

Процедура ОткрытьФайлПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат = "Продолжить" Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДополнительныеПараметры.ДанныеФайла, ДополнительныеПараметры.ДляРедактирования);
	КонецЕсли;

КонецПроцедуры

// Параметры:
//  ТаблицаКонтактов - ДанныеФормыКоллекция - содержащая описания и ссылки на контакты взаимодействия
//                                            или участников предмета взаимодействия.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Адрес - Строка
//    * Представление - Строка
//    * Контакт - Произвольный 
//
Функция ТаблицуКонтактовВМассив(ТаблицаКонтактов) Экспорт
	
	Результат = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаКонтактов Цикл
		Контакт = ?(ТипЗнч(СтрокаТаблицы.Контакт) = Тип("Строка"), Неопределено, СтрокаТаблицы.Контакт);
		Запись = Новый Структура(
		"Адрес, Представление, Контакт", СтрокаТаблицы.Адрес, СтрокаТаблицы.Представление, Контакт);
		Результат.Добавить(Запись);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполнить получение почты по всем доступным учетным записям.
// 
// Параметры:
//  ЭлементСписок - ПолеФормы - элемент формы, который необходимо обновить, после получения писем.
//
Процедура ОтправитьЗагрузитьПочтуПользователя(УникальныйИдентификатор, Форма, ЭлементСписок = Неопределено, ВыводитьПрогресс = Истина) Экспорт

	ДлительнаяОперация =  ВзаимодействияВызовСервера.ОтправитьПолучитьПочтуПользователяВФоне(УникальныйИдентификатор);
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ОтправкаПолучениеПисемВыполняется = Истина;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЭлементСписок",       ЭлементСписок);
	ДополнительныеПараметры.Вставить("НавигационнаяСсылка", Неопределено);
	ДополнительныеПараметры.Вставить("Форма",               Форма);
	ДополнительныеПараметры.Вставить("ВыводитьПрогресс",    ВыводитьПрогресс);
	Если Форма.Окно <> Неопределено Тогда
		ДополнительныеПараметры.НавигационнаяСсылка = Форма.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;	
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	Если ВыводитьПрогресс Тогда
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	Иначе
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	КонецЕсли;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОтправитьЗагрузитьПочтуПользователяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

// Обработка завершения загрузки почты пользователя
// 
// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Структура:
//   * ЭлементСписок - ТаблицаФормы - элемент, содержащий динамический список.
//
Процедура ОтправитьЗагрузитьПочтуПользователяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Форма.ОтправкаПолучениеПисемВыполняется = Ложь;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Если ДополнительныеПараметры.ЭлементСписок <> Неопределено 
		     И ДополнительныеПараметры.ЭлементСписок.Видимость
		     И ДополнительныеПараметры.ЭлементСписок.ТекущиеДанные <> Неопределено Тогда
			ДополнительныеПараметры.ЭлементСписок.Обновить();
		КонецЕсли;
		
		ДополнительныеПараметры.Форма.ДатаПредыдущегоПолученияОтправкиПочты = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		Если ДополнительныеПараметры.ВыводитьПрогресс Тогда
		
			Заголовок = НСтр("ru = 'Отправка и получение почты';
							|en = 'Mail Sync'");
			РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			Если РезультатВыполнения.ЕстьОшибки Тогда
				ПоказатьОповещениеПользователя(Заголовок, "e1cib/app/Обработка.ЖурналРегистрации", 
					НСтр("ru = 'Не удалось выполнить все действия. Технические подробности для администратора в журнале регистрации.';
						|en = 'Not all the mail has been synced. See the Event Log for details.'"), 
					БиблиотекаКартинок.Предупреждение, СтатусОповещенияПользователя.Важное);
			Иначе	
				ПоказатьОповещениеПользователя(Заголовок, ДополнительныеПараметры.НавигационнаяСсылка,
					РезультатОтправкиПолученияПисем(РезультатВыполнения));
			КонецЕсли;
			
		КонецЕсли;
		
		Оповестить("ВыполненаОтправкаПолучениеПисем");
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатОтправкиПолученияПисем(РезультатВыполнения)
	
	Если РезультатВыполнения.ПолученоПисем > 0 И РезультатВыполнения.ОтправленоПисем > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Получено: %1, отправлено: %2';
																						|en = 'Received: %1; Sent: %2'"), 
			РезультатВыполнения.ПолученоПисем, РезультатВыполнения.ОтправленоПисем);
	ИначеЕсли РезультатВыполнения.ПолученоПисем > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Получено: %1';
																						|en = 'Received: %1'"), 
			РезультатВыполнения.ПолученоПисем);
	ИначеЕсли РезультатВыполнения.ОтправленоПисем > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отправлено: %1';
																						|en = 'Sent: %1'"), 
			РезультатВыполнения.ОтправленоПисем);
	Иначе
		ТекстСообщения = НСтр("ru = 'Нет новых писем';
								|en = 'No new messages.'");
	КонецЕсли;	
	Если РезультатВыполнения.ДоступноУчетныхЗаписей > 1 Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС  
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '(учетных записей: %1)';
																			|en = 'Accounts synced: %1'"),
				РезультатВыполнения.ДоступноУчетныхЗаписей);
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
