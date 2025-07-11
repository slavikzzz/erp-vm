#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОтбораПоОрганизации(Настройки);
КонецПроцедуры

#КонецОбласти

Функция СведенияОНастройкахОрганизации(Организация, Сведения) Экспорт
	
	Если ТипЗнч(Сведения) = Тип("Строка") Тогда
		СтруктураСведений = Новый Структура(Сведения);
		
	ИначеЕсли ТипЗнч(Сведения) = Тип("Структура")
	      ИЛИ ТипЗнч(Сведения) = Тип("ФиксированнаяСтруктура") Тогда
		
		СтруктураСведений = Сведения;
		
	ИначеЕсли ТипЗнч(Сведения) = Тип("Массив")
	      ИЛИ ТипЗнч(Сведения) = Тип("ФиксированныйМассив") Тогда
		
		СтруктураСведений = Новый Структура;
		Для каждого Сведение Из Сведения Цикл
			СтруктураСведений.Вставить(Сведение);
		КонецЦикла;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверный тип второго параметра Сведения: %1';
				|en = 'Incorrect type of the second parameter Information: %1'"),
			Строка(ТипЗнч(Сведения)));
	КонецЕсли;
	
	ТекстПолей = "";
	Для Каждого КлючИЗначение Из СтруктураСведений Цикл
		Если КлючИЗначение.Ключ = "ДатаВыплатыМежрасчетаНеПозжеЧем" Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяПоля   = ?(ЗначениеЗаполнено(КлючИЗначение.Значение),
		              СокрЛП(КлючИЗначение.Значение),
		              СокрЛП(КлючИЗначение.Ключ));
		
		Псевдоним = СокрЛП(КлючИЗначение.Ключ);
		
		ТекстПолей  = ТекстПолей + ?(ПустаяСтрока(ТекстПолей), "", ",") + "
		|	" + ИмяПоля + " КАК " + Псевдоним;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|" + ТекстПолей + "
	|ИЗ
	|	РегистрСведений.НастройкиЗарплатаКадрыРасширенная КАК ПсевдонимЗаданнойТаблицы
	|ГДЕ
	|	ПсевдонимЗаданнойТаблицы.Организация = &Организация
	|";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Результат = Новый Структура;
	Для Каждого КлючИЗначение Из СтруктураСведений Цикл
		Результат.Вставить(КлючИЗначение.Ключ);
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
	Если СтруктураСведений.Свойство("ВыплачиватьЗарплатуВПоследнийДеньМесяца") Тогда
		Если Не ЗначениеЗаполнено(Результат.ВыплачиватьЗарплатуВПоследнийДеньМесяца) Тогда
			Результат.ВыплачиватьЗарплатуВПоследнийДеньМесяца = Ложь;
		КонецЕсли;
	КонецЕсли;
	Если СтруктураСведений.Свойство("ДатаВыплатыЗарплатыНеПозжеЧем") Тогда
		Если Не ЗначениеЗаполнено(Результат.ДатаВыплатыЗарплатыНеПозжеЧем) Тогда
			Результат.ДатаВыплатыЗарплатыНеПозжеЧем = 5;
		КонецЕсли;
	КонецЕсли;
	Если СтруктураСведений.Свойство("ДатаВыплатыАвансаНеПозжеЧем") Тогда
		Если Не ЗначениеЗаполнено(Результат.ДатаВыплатыАвансаНеПозжеЧем) Тогда
			Результат.ДатаВыплатыАвансаНеПозжеЧем = 20;
		КонецЕсли;
	КонецЕсли;
	Если СтруктураСведений.Свойство("ДатаВыплатыМежрасчетаНеПозжеЧем") Тогда
		Результат.ДатаВыплатыМежрасчетаНеПозжеЧем = День(КонецДня(ТекущаяДатаСеанса()) + 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли