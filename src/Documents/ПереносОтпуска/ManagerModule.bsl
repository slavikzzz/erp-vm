#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОтбораПоОрганизации(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОбъектаСПрисоединеннымиФайлами(Настройки);
КонецПроцедуры

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ПереносОтпуска);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ЗаявлениеНаПереносОтпуска";
	КомандаПечати.Представление = НСтр("ru = 'Заявление/Уведомление о переносе отпуска';
										|en = 'Leave transfer application/notification'");

КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаявлениеНаПереносОтпуска") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаявлениеНаПереносОтпуска", НСтр("ru = 'Основание переноса';
																															|en = 'Transfer basis'"), ПечатьОснования(МассивОбъектов, ОбъектыПечати));	
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОснования(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадры.НастройкиПечатныхФорм();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОснованиеПереносаОтпуска";
	
	МакетЗаявления = УправлениеПечатью.МакетПечатнойФормы("Документ.ПереносОтпуска.ПФ_MXL_ЗаявлениеНаПереносОтпуска");
	ОбластьЗаявления = МакетЗаявления.ПолучитьОбласть("Заявление");
	МакетПредложения = УправлениеПечатью.МакетПечатнойФормы("Документ.ПереносОтпуска.ПФ_MXL_ПредложениеОПереносеОтпуска");
	ОбластьПредложения = МакетПредложения.ПолучитьОбласть("Предложение");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПереносОтпускаПереносы.Ссылка КАК Ссылка,
	|	КОЛИЧЕСТВО(ПереносОтпускаПереносы.ДатаНачала) КАК КоличествоОтпусков
	|ПОМЕСТИТЬ ВТПеренесенныеОтпуска
	|ИЗ
	|	Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	|ГДЕ
	|	ПереносОтпускаПереносы.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПереносОтпускаПереносы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПереносОтпуска.Ссылка КАК Ссылка,
	|	ПереносОтпуска.Номер КАК НомерДок,
	|	ПереносОтпуска.Дата КАК ДатаДок,
	|	ПереносОтпуска.Сотрудник КАК Сотрудник,
	|	ПереносОтпуска.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПереносОтпуска.ИсходнаяДатаНачала КАК ИсходнаяДатаНачала,
	|	ПереносОтпускаПереносы.ДатаНачала КАК ДатаНачала,
	|	ПереносОтпускаПереносы.ДатаОкончания КАК ДатаОкончания,
	|	ПереносОтпуска.ВидОтпуска КАК ВидОтпуска,
	|	ЕСТЬNULL(ПереносОтпуска.ВидОтпуска.Наименование, """") КАК НаименованиеОтпуска,
	|	ПереносОтпуска.ПереносПоИнициативеСотрудника КАК ПереносПоИнициативеСотрудника,
	|	ПереносОтпуска.ПричинаПереноса КАК ПричинаПереноса,
	|	ПереносОтпуска.Организация КАК Организация,
	|	ПереносОтпуска.Дата КАК Период,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеПолное
	|	КОНЕЦ КАК НаименованиеОрганизацииПолное,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеСокращенное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеСокращенное
	|	КОНЕЦ КАК НаименованиеОрганизацииСокращенное,
	|	ВЫБОР
	|		КОГДА ПереносОтпуска.ВидОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.Основной)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоОсновнойОтпуск,
	|	ПереносОтпуска.Руководитель КАК Руководитель,
	|	ПереносОтпуска.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ПеренесенныеОтпуска.КоличествоОтпусков КАК КоличествоОтпусков
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	Документ.ПереносОтпуска КАК ПереносОтпуска
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	|		ПО ПереносОтпуска.Ссылка = ПереносОтпускаПереносы.Ссылка
	|			И (ПереносОтпуска.Ссылка В (&МассивОбъектов))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ПереносОтпуска.Организация = Организации.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПеренесенныеОтпуска КАК ПеренесенныеОтпуска
	|		ПО ПереносОтпуска.Ссылка = ПеренесенныеОтпуска.Ссылка";
				   
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФИОПолные,Фамилия,Имя,Отчество,Инициалы,Пол,ИОФамилия,Должность");
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента",
		"Руководитель,Период");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "ФИОПолные,ИОФамилия,Фамилия,Имя,Отчество,Инициалы,Пол");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.НомерДок КАК НомерДок,
	|	ДанныеДокумента.ДатаДок КАК ДатаДок,
	|	ДанныеДокумента.Сотрудник КАК Сотрудник,
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.ИсходнаяДатаНачала КАК ИсходнаяДатаНачала,
	|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
	|	ДанныеДокумента.ДатаОкончания КАК ДатаОкончания,
	|	ДанныеДокумента.ВидОтпуска КАК ВидОтпуска,
	|	ДанныеДокумента.НаименованиеОтпуска КАК НаименованиеОтпуска,
	|	ДанныеДокумента.ПереносПоИнициативеСотрудника КАК ПереносПоИнициативеСотрудника,
	|	ДанныеДокумента.ПричинаПереноса КАК ПричинаПереноса,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Период КАК Период,
	|	ДанныеДокумента.НаименованиеОрганизацииПолное КАК НаименованиеОрганизацииПолное,
	|	ДанныеДокумента.НаименованиеОрганизацииСокращенное КАК НаименованиеОрганизацииСокращенное,
	|	ДанныеДокумента.ЭтоОсновнойОтпуск КАК ЭтоОсновнойОтпуск,
	|	ДанныеДокумента.КоличествоОтпусков КАК КоличествоОтпусков,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Фамилия, """") КАК Фамилия,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Имя, """") КАК Имя,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Отчество, """") КАК Отчество,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Инициалы, """") КАК Инициалы,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.ФИОПолные, """") КАК ФИОПолные,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК Должность,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)) КАК Пол,
	|	ЕСТЬNULL(КадровыеДанныеСотрудников.ИОФамилия, """") КАК СотрудникРасшифровкаПодписи,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ФИОПолные, """") КАК ФИОРуководителя,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ИОФамилия, """") КАК РуководительРасшифровкаПодписи,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Фамилия, """") КАК РуководительФамилия,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Имя, """") КАК РуководительИмя,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Отчество, """") КАК РуководительОтчество,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Инициалы, """") КАК РуководительИнициалы,
	|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)) КАК ПолРуководителя,
	|	ДанныеДокумента.Руководитель КАК Руководитель,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДанныеДокумента.ДолжностьРуководителя) КАК ДолжностьРуководителя
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО ДанныеДокумента.Руководитель = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И ДанныеДокумента.Период = КадровыеДанныеФизическихЛиц.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокумента.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ДанныеДокумента.Период = КадровыеДанныеСотрудников.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ДатаНачала";
	
	Выборка = Запрос.Выполнить().Выбрать();			   
	ФИОРуководителейВДательномПадеже = Новый Соответствие;
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл 
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда 
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если Выборка.ПереносПоИнициативеСотрудника Тогда
			
			ОбластьЗаявления.Параметры.Заполнить(Выборка);
			ФИОСотрудникаРодительный = "";
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(Выборка.ФИОПолные), 2, ФИОСотрудникаРодительный, Выборка.Пол, Выборка.ФизическоеЛицо);
			ОбластьЗаявления.Параметры.ФИОПолноеВРодительномПадеже = ФИОСотрудникаРодительный;
			ФИОРуководителяВДательномПадеже = ФИОРуководителейВДательномПадеже[Выборка.Организация];
			Если ФИОРуководителяВДательномПадеже = Неопределено Тогда
				
				СтруктураФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
				СтруктураФИО.Фамилия = Выборка.РуководительФамилия;
				СтруктураФИО.Имя = Выборка.РуководительИмя;
				СтруктураФИО.Отчество = Выборка.РуководительОтчество;
				СтруктураФИО.Инициалы = Выборка.РуководительИнициалы;
				
				ФизическиеЛицаЗарплатаКадры.Просклонять(СтруктураФИО.Фамилия, 3, СтруктураФИО.Фамилия, Выборка.ПолРуководителя);
				ФИОРуководителяВДательномПадеже = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(СтруктураФИО);
				ФИОРуководителейВДательномПадеже.Вставить(Выборка.Организация,ФИОРуководителяВДательномПадеже);
				
			КонецЕсли;
			ОбластьЗаявления.Параметры.ФИОРуководителяВДательномПадеже = ФИОРуководителяВДательномПадеже;
			ОписаниеОтпуска = ?(Выборка.ЭтоОсновнойОтпуск, "основной", "дополнительный" + ?(ЗначениеЗаполнено(Выборка.НаименованиеОтпуска),""," (" + НРег(Выборка.НаименованиеОтпуска) + ")"));
			ОбластьЗаявления.Параметры.ОписаниеОтпуска = ОписаниеОтпуска;
			
			Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
				ОбластьЗаявления.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ОбластьЗаявления.Параметры.НомерДок, Истина, Истина);
			КонецЕсли; 
			
			ПериодОтпуска = "";
			Пока Выборка.Следующий() Цикл 
				ПериодОтпуска = ПериодОтпуска + ?(ПериодОтпуска = "", "", ", ") 
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1 по %2';
																					|en = 'from %1 to %2'"), Формат(Выборка.ДатаНачала,"ДЛФ=DD"), Формат(Выборка.ДатаОкончания,"ДЛФ=DD"));
			КонецЦикла;
			
			ОбластьЗаявления.Параметры.ПериодОтпуска = ПериодОтпуска;
			
			ТабличныйДокумент.Вывести(ОбластьЗаявления);
			
		Иначе
			
			ОбластьПредложения.Параметры.Заполнить(Выборка);
			
			СтруктураФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
			ЗаполнитьЗначенияСвойств(СтруктураФИО, Выборка);
			
			ФизическиеЛицаЗарплатаКадры.Просклонять(СтруктураФИО.Фамилия, 3, СтруктураФИО.Фамилия, Выборка.Пол);
			ОбластьПредложения.Параметры.ФИОПолноеВДательномПадеже = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(СтруктураФИО);
			Если Выборка.Пол = Перечисления.ПолФизическогоЛица.Женский Тогда
				ОбластьПредложения.Параметры.ОкончаниеКраткогоПрилагательного = "а";
				ОбластьПредложения.Параметры.ОкончаниеПолногоПрилагательного = "ая";
				ОбластьПредложения.Параметры.СклонениеСогласенСогласна = НСтр("ru = 'согласна';
																				|en = 'agree'");
			Иначе	
				ОбластьПредложения.Параметры.ОкончаниеПолногоПрилагательного = "ый";
				ОбластьПредложения.Параметры.СклонениеСогласенСогласна = НСтр("ru = 'согласен';
																				|en = 'agree'");
			КонецЕсли;
			
			Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
				ОбластьПредложения.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ОбластьПредложения.Параметры.НомерДок, Истина, Истина);
			КонецЕсли;
			
			Если Выборка.КоличествоОтпусков = 1 Тогда 
				ОписаниеПереноса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'перенести начало Вашего отпуска с %1 на %2';
						|en = 'transfer your leave start from %1 to %2'"),
					Формат(Выборка.ИсходнаяДатаНачала,"ДЛФ=DD"), Формат(Выборка.ДатаНачала,"ДЛФ=DD"));
			Иначе 
				ПериодОтпуска = "";
				Пока Выборка.Следующий() Цикл 
					ПериодОтпуска = ПериодОтпуска + ?(ПериодОтпуска = "", "", ", ") 
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1 по %2';
																						|en = 'from %1 to %2'"), Формат(Выборка.ДатаНачала,"ДЛФ=DD"), Формат(Выборка.ДатаОкончания,"ДЛФ=DD"));
				КонецЦикла;
				ОписаниеПереноса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'перенести Ваш отпуск от %1 на период %2';
						|en = 'transfer your leave from %1 to %2'"),
					Формат(Выборка.ИсходнаяДатаНачала,"ДЛФ=DD"), ПериодОтпуска);
			КонецЕсли;
			
			ОбластьПредложения.Параметры.ОписаниеПереноса = ОписаниеПереноса;
			
			ТабличныйДокумент.Вывести(ОбластьПредложения);
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

// Проверяет, что сотрудник, указанный в документе работает в период отсутствия.
//
// Параметры:
//		ДокументОбъект	- ДокументОбъект.ПереносОтпуска
//		Отказ			- Булево
//
Процедура ПроверитьРаботающих(ДокументОбъект, Отказ) Экспорт
	
	ДатаНачала = Неопределено;
	ДатаОкончания = Неопределено;
	Для Каждого СтрокаПереноса Из ДокументОбъект.Переносы Цикл 
		ДатаНачала = ?(ДатаНачала = Неопределено, СтрокаПереноса.ДатаНачала, Мин(ДатаНачала, СтрокаПереноса.ДатаНачала));
		ДатаОкончания = ?(ДатаОкончания = Неопределено, СтрокаПереноса.ДатаОкончания, Макс(ДатаОкончания, СтрокаПереноса.ДатаОкончания));
	КонецЦикла;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= ДокументОбъект.Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаОкончания;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументОбъект.Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
