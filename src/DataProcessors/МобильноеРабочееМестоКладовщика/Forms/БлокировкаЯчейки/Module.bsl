	
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ячейка = Параметры.Ячейка;
	Если Параметры.Свойство("ТипБлокировки") Тогда
		ТипБлокировки = Параметры.ТипБлокировки;
	КонецЕсли;
	ЗаполнитьКарточку();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заблокировать(Команда)
	
	Заблокирована = ЗаблокироватьЯчейкуСервер();
	Если Заблокирована Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Разблокировать(Команда)
	
	Разблокирована = РазблокироватьЯчейкуСервер();
	Если Разблокирована Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьКарточку()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ВЫБОР
	|		КОГДА БлокировкиСкладскихЯчеек.Регистратор ССЫЛКА Документ.УстановкаБлокировокЯчеек
	|			ТОГДА ВЫРАЗИТЬ(БлокировкиСкладскихЯчеек.Регистратор КАК Документ.УстановкаБлокировокЯчеек).Комментарий
	|		КОГДА БлокировкиСкладскихЯчеек.Регистратор ССЫЛКА Документ.ПересчетТоваров
	|			ТОГДА ВЫРАЗИТЬ(БлокировкиСкладскихЯчеек.Регистратор КАК Документ.ПересчетТоваров).Комментарий
	|	КОНЕЦ, """") КАК Комментарий,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки КАК ТипБлокировки,
	|	БлокировкиСкладскихЯчеек.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.БлокировкиСкладскихЯчеек КАК БлокировкиСкладскихЯчеек
	|ГДЕ
	|	БлокировкиСкладскихЯчеек.Активность
	|	И БлокировкиСкладскихЯчеек.Ячейка = &Ячейка
	|	И &ТипБлокировки";
	
	Если ЗначениеЗаполнено(ТипБлокировки) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ТипБлокировки", "И БлокировкиСкладскихЯчеек.ТипБлокировки = &ТипБлокировки");
		Запрос.УстановитьПараметр("ТипБлокировки", ТипБлокировки);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ТипБлокировки", "");
	КонецЕсли;

	Запрос.УстановитьПараметр("Ячейка", Ячейка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Элементы.Заблокировать.Видимость = Истина;
		Элементы.Разблокировать.Видимость = Ложь;
		
		ТипБлокировки = Перечисления.ТипыБлокировокСкладскихЯчеек.Полная;
		
	Иначе
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Ссылка        = ВыборкаДетальныеЗаписи.Регистратор;
			Комментарий   = ВыборкаДетальныеЗаписи.Комментарий;
			ТипБлокировки = ВыборкаДетальныеЗаписи.ТипБлокировки;
		КонецЦикла;
		
		Элементы.Заблокировать.Видимость = Ложь;
		Элементы.Разблокировать.Видимость = Истина;
		Элементы.ТипБлокировки.Доступность = Ложь;
		Элементы.Комментарий.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры 

Функция РазблокироватьЯчейкуСервер()
	
	Если ТипЗнч(Ссылка) <> Тип("ДокументСсылка.УстановкаБлокировокЯчеек") Тогда
		ТекстОшибки = НСтр("ru = 'Невозможно разблокировать ячейку';
							|en = 'Cannot unblock the storage bin'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат Ложь;
	КонецЕсли;
	
	ДокументБлокировка = Ссылка.ПолучитьОбъект();
	ДокументБлокировка.Ответственный = Пользователи.ТекущийПользователь();
	Для Каждого Строка Из ДокументБлокировка.СкладскиеЯчейки Цикл
		
		Если Строка.Ячейка = Ячейка Тогда
			Строка.Отменено = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		ДокументБлокировка.Записать(РежимЗаписиДокумента.Проведение);
		Возврат Истина;
	Исключение
		ТекстОшибки = НСтр("ru = 'Невозможно разблокировать ячейку';
							|en = 'Cannot unblock the storage bin'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Функция ЗаблокироватьЯчейкуСервер()
	
	СтруктураРеквизитовЯчейки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ячейка, "Владелец, Помещение");
	
	ДокументБлокировка = Документы.УстановкаБлокировокЯчеек.СоздатьДокумент();
	ДокументБлокировка.Дата = ТекущаяДатаСеанса();
	ДокументБлокировка.Склад = СтруктураРеквизитовЯчейки.Владелец;
	ДокументБлокировка.Комментарий = Комментарий;
	ДокументБлокировка.Помещение = СтруктураРеквизитовЯчейки.Помещение;
	ДокументБлокировка.Ответственный = Пользователи.ТекущийПользователь();
	
	НовСтр = ДокументБлокировка.СкладскиеЯчейки.Добавить();
	НовСтр.Ячейка = Ячейка;
	НовСтр.ТипБлокировки = ТипБлокировки;
	
	Попытка
		ДокументБлокировка.Записать(РежимЗаписиДокумента.Проведение);
		Возврат Истина;
	Исключение
		ТекстОшибки = НСтр("ru = 'Невозможно заблокировть ячейку';
							|en = 'Cannot block the storage bin'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

#КонецОбласти