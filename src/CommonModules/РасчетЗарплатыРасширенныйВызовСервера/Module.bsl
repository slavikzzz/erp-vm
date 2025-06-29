
#Область СлужебныеПроцедурыИФункции

// Обработчик события ОбработкаПолученияДанныхВыбора модуля менеджера ПВР Начисления.
//
Процедура НачисленияОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапросаУсловий = "";

	// Исключение пособий по уходу за ребенком.
	Если Параметры.Свойство("ИсключатьПособияПоУходуЗаРебенком") Тогда
		
		ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + "
			|	И ") + "(Не ПланВидовРасчетаНачисления.КатегорияНачисленияИлиНеоплаченногоВремени В (&ПособияПоУходуЗаРебенком))";
			
		ИсключенныеВиды = Новый Массив;
		ИсключенныеВиды.Добавить(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет"));
		ИсключенныеВиды.Добавить(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет"));			
		
		Запрос.УстановитьПараметр("ПособияПоУходуЗаРебенком", ИсключенныеВиды);
		
	КонецЕсли;
	
	// Условия подбора по строке и коду.
	Если Параметры.Свойство("СтрокаПоиска") И Не ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
		
		УсловияПодбора = "";
		МетаданныеОбъекта = Метаданные.ПланыВидовРасчета.Начисления;
		
		Для каждого Поле Из МетаданныеОбъекта.ВводПоСтроке Цикл
			УсловияПодбора = УсловияПодбора + ?(ПустаяСтрока(УсловияПодбора), "", Символы.ПС + "ИЛИ ") + "(ПланВидовРасчетаНачисления." + Поле.Имя + " ПОДОБНО &СтрокаПоиска)";
		КонецЦикла;
		
		Если Не ПустаяСтрока(УсловияПодбора) Тогда
			ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + "
				|	И ") + "(" + УсловияПодбора + ")";
		КонецЕсли; 
			
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		
	КонецЕсли; 
	
	// Добавление отборов, переданных в параметре.
	Если Параметры.Отбор.Количество() > 0 И Не Параметры.Отбор.Свойство("КатегорияНачисленияИлиНеоплаченногоВремени") Тогда
				
		Для каждого ЭлементОтбора Из Параметры.Отбор Цикл
						
			Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда				
				УсловиеСПравымЗначением = " В (&Отбор" + ЭлементОтбора.Ключ + ")";				
			Иначе				
				УсловиеСПравымЗначением = " = (&Отбор" + ЭлементОтбора.Ключ + ")";				
			КонецЕсли; 
			
			ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + Символы.ПС + " И ")
				+ "ПланВидовРасчетаНачисления." + ЭлементОтбора.Ключ + УсловиеСПравымЗначением;
				
			Запрос.УстановитьПараметр("Отбор" + ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
		|	ПланВидовРасчетаНачисления.Ссылка КАК Ссылка,
		|	ПланВидовРасчетаНачисления.ПометкаУдаления,
		|	"""" КАК Предупреждение,
		|	ПланВидовРасчетаНачисления.Наименование,
		|	ПланВидовРасчетаНачисления.Код,
		|	ЛОЖЬ КАК ЯвляетсяДенежнымСодержанием
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК ПланВидовРасчетаНачисления";
		
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		НовыйТекстЗапроса = Модуль.УточнитьТекстЗапросаСпискаНачислений(ТекстЗапроса, ТекстЗапросаУсловий);
		Если Не ПустаяСтрока(НовыйТекстЗапроса) Тогда
			ТекстЗапроса = НовыйТекстЗапроса;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ОграничиватьВыборОсновныхВидовРасчетаОплатыПоСреднему") Тогда
		
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			ИсключаемыеКатегории = Новый Массив;
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИсключаемыеКатегории, ПланыВидовРасчета.Начисления.КатегорииНачисленийОплатыДолейРКиСН());
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИсключаемыеКатегории, ПланыВидовРасчета.Начисления.КатегорииОплатыБольничного());
			
			ТекстЗапросаСоединений = "
			|	ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК ПВРНачисления
			|	ПО (ПланВидовРасчетаНачисления.Ссылка = ПВРНачисления.ОсновнойВидРасчета
		 	|	И ПВРНачисления.КатегорияНачисленияИлиНеоплаченногоВремени = &КатегорияНачисленияИлиНеоплаченногоВремени)";
			ТекстЗапроса = ТекстЗапроса + ТекстЗапросаСоединений;
			ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + Символы.ПС + " И ") + "
			|	ПВРНачисления.Ссылка ЕСТЬ NULL И ПланВидовРасчетаНачисления.КатегорияНачисленияИлиНеоплаченногоВремени НЕ В(&ИсключаемыеКатегории)
			|	ИЛИ ПланВидовРасчетаНачисления.Ссылка = &ТекущийОсновнойВидРасчета";
			Запрос.УстановитьПараметр("КатегорияНачисленияИлиНеоплаченногоВремени", Параметры.Отбор.КатегорияНачисленияИлиНеоплаченногоВремени);
			Запрос.УстановитьПараметр("ИсключаемыеКатегории", ИсключаемыеКатегории);
			Запрос.УстановитьПараметр("ТекущийОсновнойВидРасчета", Параметры.Отбор.ТекущийОсновнойВидРасчета);
		КонецЕсли;
		
	КонецЕсли;

	Если Не ПустаяСтрока(ТекстЗапросаУсловий) Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	" + ТекстЗапросаУсловий;
	КонецЕсли; 
		
	ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	ПланВидовРасчетаНачисления.Наименование";
		
	Запрос.Текст = ТекстЗапроса;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ШаблонПредставления = "%1";
		Если ЗначениеЗаполнено(Выборка.Код) Тогда
			ШаблонПредставления = "%1 (%2)";
		КонецЕсли;
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Выборка.Наименование, СокрЛП(Выборка.Код));
		ДанныеВыбора.Добавить(Выборка.Ссылка, Представление);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Функция СведенияОНастройкахЗарплатаКадрыРасширенная(Организация) Экспорт
	
	Возврат РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СведенияОНастройкахОрганизации(
		Организация, "ВыплачиватьЗарплатуВПоследнийДеньМесяца, ДатаВыплатыЗарплатыНеПозжеЧем, ДатаВыплатыАвансаНеПозжеЧем");
	
КонецФункции

Процедура СохранитьНастройкуРежимаОтображенияПодробно(ОбъектСсылка, ВидимостьПолейПодробно, ОписаниеТаблицы) Экспорт

	Если ТипЗнч(ОбъектСсылка) = Тип("Строка") Тогда
		КлючОбъекта = ОбъектСсылка;
	Иначе
		КлючОбъекта = ОбъектСсылка.Метаданные().Имя;
	КонецЕсли;
	КлючНастроек = ОписаниеТаблицы.ИмяТаблицы + "Подробно";
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		ВидимостьПолейПодробно);

КонецПроцедуры

// Обработчик события ОбработкаПолученияДанныхВыбора перечисления КатегорииНачисленийИНеоплаченногоВремени.
//
Процедура КатегорииНачисленийИНеоплаченногоВремениОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка,
	|	ТаблицаКатегорий.Синоним
	|ПОМЕСТИТЬ ВТТаблицаКатегорий
	|ИЗ
	|	&ТаблицаКатегорий КАК ТаблицаКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка
	|ИЗ
	|	ВТТаблицаКатегорий КАК ТаблицаКатегорий
	|ГДЕ
	|	ТаблицаКатегорий.Ссылка В(&ДействующиеКатегории)
	|	И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу категорий.
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииНачисленийИНеоплаченногоВремени"));
	ТаблицаКатегорий.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Ссылка = Перечисления.КатегорииНачисленийИНеоплаченногоВремени[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаКатегорий", ТаблицаКатегорий);
	Запрос.УстановитьПараметр("ДействующиеКатегории", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДействующиеКатегории());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработчик события ОбработкаПолученияДанныхВыбора перечисления КатегорииУдержаний.
//
Процедура КатегорииУдержанийОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка,
	|	ТаблицаКатегорий.Синоним
	|ПОМЕСТИТЬ ВТТаблицаКатегорий
	|ИЗ
	|	&ТаблицаКатегорий КАК ТаблицаКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка
	|ИЗ
	|	ВТТаблицаКатегорий КАК ТаблицаКатегорий
	|ГДЕ
	|	ТаблицаКатегорий.Ссылка В(&ДействующиеКатегории)
	|	И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу категорий.
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииУдержаний"));
	ТаблицаКатегорий.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.КатегорииУдержаний.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Ссылка = Перечисления.КатегорииУдержаний[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаКатегорий", ТаблицаКатегорий);
	Запрос.УстановитьПараметр("ДействующиеКатегории", Перечисления.КатегорииУдержаний.ДействующиеКатегории());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ДанныеДляРасчетаЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт 
	
	Если Данные.Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Данные.Ссылка, "ВидДокумента");
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2 от %3';
			|en = '%1 %2 dated %3'"), 
			ВидДокумента, 
			Данные.Номер, 
			Формат(Данные.Дата, "ДЛФ=Д"));
		
	СтандартнаяОбработка = Ложь;
		
КонецПроцедуры

Процедура НачислениеЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт 
	
	Если Данные.РежимДоначисления Тогда
		
		СтандартнаяОбработка = Ложь;
		Представление = Документы.НачислениеЗарплаты.ПредставлениеТипаДоначислениеПерерасчет() + " " + Данные.Номер + " " +НСтр("ru = 'от';
																																|en = 'dated'") + " "  + Формат(Данные.Дата, "ДЛФ=D");;
		
	Иначе 
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда 
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		    ВидОперации = Модуль.ВидОперацииДокумента(Данные.Ссылка);
			Если ЗначениеЗаполнено(ВидОперации) Тогда
				СтандартнаяОбработка = Ложь;
				Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 %2 от %3';
						|en = '%1 %2 dated %3'"), Строка(ВидОперации), Данные.Номер, Формат(Данные.Дата, "ДЛФ=Д"));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Функция КонтролируемыеПовторяемыеНачисления()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка КАК Начисление
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ПериодичностьНачисления <> ЗНАЧЕНИЕ(Перечисление.ПериодичностьНачисления.ПустаяСсылка)";
		
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Начисление");

КонецФункции	

Функция ПроверяемыеНаУникальностьВПериодахНачисления(РегистрируемыеНачисления)
	
	ПроверяемыеНачисления = Новый ТаблицаЗначений;
	ПроверяемыеНачисления.Колонки.Добавить("Сотрудник",                         Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ПроверяемыеНачисления.Колонки.Добавить("Начисление",                        Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
	ПроверяемыеНачисления.Колонки.Добавить("ПроверяемыйПериодНачало",           Новый ОписаниеТипов("Дата"));
	ПроверяемыеНачисления.Колонки.Добавить("ПроверяемыйПериодОкончание",        Новый ОписаниеТипов("Дата"));
	ПроверяемыеНачисления.Колонки.Добавить("КоличествоНеСторнированныхЗаписей", Новый ОписаниеТипов("Число"));	
	// Вспомогательное поле, необходимо для того что бы "отбросить" сторнированные в этом же наборе начисления.
	
	КонтролируемыеПовторяемыеНачисления = КонтролируемыеПовторяемыеНачисления();
	Если КонтролируемыеПовторяемыеНачисления.Количество() = 0 Тогда
		Возврат ПроверяемыеНачисления;	
	КонецЕсли;
	
	Для Каждого СтрокаРегистрируемыхНачислений Из РегистрируемыеНачисления Цикл
		
		Если КонтролируемыеПовторяемыеНачисления.Найти(СтрокаРегистрируемыхНачислений.Начисление) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
			
		СтрокаПроверяемыхНачислений = ПроверяемыеНачисления.Добавить();
		СтрокаПроверяемыхНачислений.Сотрудник = СтрокаРегистрируемыхНачислений.Сотрудник;
		СтрокаПроверяемыхНачислений.Начисление = СтрокаРегистрируемыхНачислений.Начисление;
		СтрокаПроверяемыхНачислений.КоличествоНеСторнированныхЗаписей = ?(СтрокаРегистрируемыхНачислений.Сторно, -1, 1);
		
		ПериодКонтроляУникальности = СтрокаРегистрируемыхНачислений.Начисление.ПериодичностьНачисления;
		Если ПериодКонтроляУникальности = Перечисления.ПериодичностьНачисления.РазВГод Тогда
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодНачало = НачалоГода(СтрокаРегистрируемыхНачислений.ПериодДействия);
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодОкончание = КонецГода(СтрокаРегистрируемыхНачислений.ПериодДействия);
		ИначеЕсли ПериодКонтроляУникальности = Перечисления.ПериодичностьНачисления.РазВКвартал Тогда
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодНачало = НачалоКвартала(СтрокаРегистрируемыхНачислений.ПериодДействия);
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодОкончание = КонецКвартала(СтрокаРегистрируемыхНачислений.ПериодДействия);
		ИначеЕсли ПериодКонтроляУникальности = Перечисления.ПериодичностьНачисления.РазВМесяц Тогда
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодНачало = НачалоМесяца(СтрокаРегистрируемыхНачислений.ПериодДействия);
			СтрокаПроверяемыхНачислений.ПроверяемыйПериодОкончание = КонецМесяца(СтрокаРегистрируемыхНачислений.ПериодДействия);
		КонецЕсли;	
		
	КонецЦикла;	
	
	// Удалим записи которые были отсторнированы в этом же наборе
	ПроверяемыеНачисления.Свернуть("Сотрудник, Начисление, ПроверяемыйПериодНачало, ПроверяемыйПериодОкончание", "КоличествоНеСторнированныхЗаписей");
	
	ИндексПоследнейЗаписи = ПроверяемыеНачисления.Количество() - 1;
	Для Сч = 0 По ИндексПоследнейЗаписи Цикл
		ИндексТекущейЗаписи = ИндексПоследнейЗаписи - Сч;
		Если ПроверяемыеНачисления[ИндексТекущейЗаписи].КоличествоНеСторнированныхЗаписей <= 0 Тогда
			ПроверяемыеНачисления.Удалить(ИндексТекущейЗаписи);
		КонецЕсли;
	КонецЦикла;	
	
	Возврат ПроверяемыеНачисления;
КонецФункции	

// Проверяет повторение начислений в контролируемом периоде
//
// Параметры:
//		РегистрируемыеНачисления - таблица проверяемых начислений (см ПроверяемыеНаУникальностьВПериодахНачисления()).
//		Регистратор - ссылка на документ.
//
Функция ПроверитьПовторениеКонтролируемыхНачисленийТаблицы(РегистрируемыеНачисления, Регистратор) 
	
	ДанныеСотрудников = Новый Соответствие;

	Если РегистрируемыеНачисления.Количество() = 0 Тогда
		Возврат ДанныеСотрудников;
	КонецЕсли;
	
	ПроверяемыеНачисления = ПроверяемыеНаУникальностьВПериодахНачисления(РегистрируемыеНачисления);
	Если ПроверяемыеНачисления.Количество() = 0 Тогда
		Возврат ДанныеСотрудников;
	КонецЕсли; 
	
	СведенияОбИсправлении = ИсправлениеДокументовЗарплатаКадры.СведенияОбИсправленииДокумента(Регистратор);
	
	ИсключаемыеРегистраторы = Новый Массив;
	ИсключаемыеРегистраторы.Добавить(Регистратор);
	ИсключаемыеРегистраторы.Добавить(СведенияОбИсправлении.ИсправленныйДокумент);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПроверяемыеНачисления", ПроверяемыеНачисления);
	Запрос.УстановитьПараметр("ИсключаемыеРегистраторы", ИсключаемыеРегистраторы);	

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроверяемыеНачисления.Сотрудник КАК Сотрудник,
	|	ПроверяемыеНачисления.Начисление КАК Начисление,
	|	ПроверяемыеНачисления.ПроверяемыйПериодНачало КАК ПроверяемыйПериодНачало,
	|	ПроверяемыеНачисления.ПроверяемыйПериодОкончание КАК ПроверяемыйПериодОкончание
	|ПОМЕСТИТЬ ВТПроверяемыеНачисления
	|ИЗ
	|	&ПроверяемыеНачисления КАК ПроверяемыеНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПроверяемыеНачисления.Сотрудник КАК Сотрудник,
	|	ПроверяемыеНачисления.Начисление КАК Начисление,
	|	ПроверяемыеНачисления.ПроверяемыйПериодНачало КАК ПроверяемыйПериодНачало,
	|	ПроверяемыеНачисления.ПроверяемыйПериодОкончание КАК ПроверяемыйПериодОкончание,
	|	МАКСИМУМ(Начисления.Регистратор) КАК Регистратор
	|ИЗ
	|	ВТПроверяемыеНачисления КАК ПроверяемыеНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.Начисления КАК Начисления
	|		ПО ПроверяемыеНачисления.Сотрудник = Начисления.Сотрудник
	|			И (Начисления.ВидРасчета = ПроверяемыеНачисления.Начисление)
	|			И (Начисления.ПериодДействия МЕЖДУ ПроверяемыеНачисления.ПроверяемыйПериодНачало И ПроверяемыеНачисления.ПроверяемыйПериодОкончание)
	|			И (НЕ Начисления.Регистратор В (&ИсключаемыеРегистраторы))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПроверяемыеНачисления.Сотрудник,
	|	ПроверяемыеНачисления.Начисление,
	|	ПроверяемыеНачисления.ПроверяемыйПериодНачало,
	|	ПроверяемыеНачисления.ПроверяемыйПериодОкончание
	|
	|ИМЕЮЩИЕ
	// учтем только те записи, которые не были сторнированы
	|	СУММА(ВЫБОР
	|			КОГДА Начисления.Сторно
	|				ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ) > 0
	|	
	|";
		
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоДовольствия");
		Модуль.ДополнитьТекстЗапросаПовторенияКонтролируемыхНачислений(Запрос);
	КонецЕсли;	
	
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() > 0 Тогда 
				
		Пока Выборка.Следующий() Цикл 
			
			СведенияОбИсправлении = ИсправлениеДокументовЗарплатаКадры.СведенияОбИсправленииДокумента(Выборка.Регистратор);
			Если СведенияОбИсправлении.Исправлен Или СведенияОбИсправлении.Сторнирован Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСотрудника = ДанныеСотрудников[Выборка.Сотрудник];
			Если ДанныеСотрудника = Неопределено Тогда
				ДанныеСотрудника = Новый Структура("Начисление, Регистратор");
				ДанныеСотрудников.Вставить(Выборка.Сотрудник, ДанныеСотрудника);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(ДанныеСотрудника, Выборка);
			
		КонецЦикла;
		
	КонецЕсли;		
	
	Возврат ДанныеСотрудников;
		
КонецФункции
Функция ТаблицаПовторенийКонтролируемыхНачислений(Данные, ОписаниеТаблицыНачислений) Экспорт
		
	ДанныеНачислений = РасчетЗарплатыРасширенный.ПустаяТаблицаНачисления();
	
	Для Каждого СтрокаТаблицы Из Данные.Начисления Цикл
		
		НоваяСтрока = ДанныеНачислений.Добавить();
		НоваяСтрока.Сотрудник 		= ?(ОписаниеТаблицыНачислений.СодержитПолеСотрудник, СтрокаТаблицы[ОписаниеТаблицыНачислений.ИмяРеквизитаСотрудник], Данные[ОписаниеТаблицыНачислений.ИмяРеквизитаСотрудник]);
		НоваяСтрока.Начисление 		= ?(ОписаниеТаблицыНачислений.СодержитПолеВидРасчета, СтрокаТаблицы[ОписаниеТаблицыНачислений.ИмяРеквизитаВидРасчета], Данные[ОписаниеТаблицыНачислений.ИмяРеквизитаВидРасчета] );
		НоваяСтрока.ПериодДействия 	= СтрокаТаблицы.ПериодДействия;
		
	КонецЦикла;	
		
	КонтролируемыеНачисления = ПроверитьПовторениеКонтролируемыхНачисленийТаблицы(ДанныеНачислений,Данные.Ссылка);
	
	Возврат КонтролируемыеНачисления;
	
КонецФункции

#КонецОбласти
