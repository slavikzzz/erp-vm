#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаявлениеОПереводеНаДистанционнуюРаботу") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_ЗаявлениеОПереводеНаДистанционнуюРаботу", НСтр("ru = 'Заявление о переводе на дистанционную работу';
																	|en = 'Application for transfer to remote work'"),
			ТабличныйДокументЗаявлениеОПереводеНаДистанционнуюРаботу(УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьДокументовДляПереводаНаДистанционнуюРаботу.ПФ_MXL_ЗаявлениеОПереводеНаДистанционнуюРаботу"), МассивОбъектов, ОбъектыПечати, ПараметрыПечати), ,
			"Обработка.ПечатьДокументовДляПереводаНаДистанционнуюРаботу.ПФ_MXL_ЗаявлениеОПереводеНаДистанционнуюРаботу");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ДопСоглашениеКТрудовомуДоговоруПриПереводеНаДистанционнуюРаботу") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_ДопСоглашениеКТрудовомуДоговоруПриПереводеНаДистанционнуюРаботу", НСтр("ru = 'Доп. соглашение к трудовому договору при переводе на дистанционную работу';
																							|en = 'Supplement agreement to the employment contract when transferring to remote work'"),
			ТабличныйДокументДопСоглашениеКТрудовомуДоговоруПриПереводеДистанционнуюРаботу(УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьДокументовДляПереводаНаДистанционнуюРаботу.ПФ_MXL_ДопСоглашениеКТрудовомуДоговоруПриПереводеНаДистанционнуюРаботу"), МассивОбъектов, ОбъектыПечати, ПараметрыПечати), ,
			"Обработка.ПечатьДокументовДляПереводаНаДистанционнуюРаботу.ПФ_MXL_ДопСоглашениеКТрудовомуДоговоруПриПереводеНаДистанционнуюРаботу", ПараметрыПечати);
	КонецЕсли;
	
КонецПроцедуры

#Область ПереводНаДистанционнуюРаботу

Функция ТабличныйДокументЗаявлениеОПереводеНаДистанционнуюРаботу(Макет, МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявлениеОПереводеНаДистанционнуюРаботу";
	ДокументРезультат.ОриентацияСтраницы= ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ТаблицаДанныхПечатиОбъектов = РассылкаДокументов.ДанныеПечати(ПараметрыПечати);
	Если ТаблицаДанныхПечатиОбъектов = Неопределено Тогда
		ТаблицаДанныхПечатиОбъектов = ТаблицаДанныхПечатиЗаявленияОПереводеНаДистанционнуюРаботу(МассивОбъектов);
	КонецЕсли;
	
	ПервыйДокумент = Истина;
	
	ОбластьЗаявления = Макет.ПолучитьОбласть("Заявление");

	ФИОРуководителейВДательномПадеже = Новый Соответствие;
	ДолжностиРуководителейВДательномПадеже = Новый Соответствие;
	
	Для Каждого ДанныеПечатиОбъекта Из ТаблицаДанныхПечатиОбъектов Цикл
	
		НачалоОбласти = ДокументРезультат.ВысотаТаблицы + 1;
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ОбластьЗаявления.Параметры.Заполнить(ДанныеПечатиОбъекта);
		ОбластьЗаявления.Параметры.ДатаНачала = Формат(ДанныеПечатиОбъекта.ДатаНачала, "ДЛФ=D");
		ОбластьЗаявления.Параметры.ДатаДок = Формат(ДанныеПечатиОбъекта.ДатаДок, "ДЛФ=D");
		ФИОСотрудникаРодительный = "";
		ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечатиОбъекта.ФИОПолные), 2, ФИОСотрудникаРодительный, ДанныеПечатиОбъекта.Пол);
		ОбластьЗаявления.Параметры.ФИОПолноеВРодительномПадеже = ФИОСотрудникаРодительный;
		ФИОРуководителяВДательномПадеже = ФИОРуководителейВДательномПадеже[ДанныеПечатиОбъекта.Организация];
		Если ФИОРуководителяВДательномПадеже = Неопределено Тогда
			
			СтруктураФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
			СтруктураФИО.Фамилия = ДанныеПечатиОбъекта.РуководительФамилия;
			СтруктураФИО.Имя = ДанныеПечатиОбъекта.РуководительИмя;
			СтруктураФИО.Отчество = ДанныеПечатиОбъекта.РуководительОтчество;
			СтруктураФИО.Инициалы = ДанныеПечатиОбъекта.РуководительИнициалы;
			
			ФизическиеЛицаЗарплатаКадры.Просклонять(СтруктураФИО.Фамилия, 3, СтруктураФИО.Фамилия, ДанныеПечатиОбъекта.ПолРуководителя);
			ФИОРуководителяВДательномПадеже = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(СтруктураФИО);
			ФИОРуководителейВДательномПадеже.Вставить(ДанныеПечатиОбъекта.Организация,ФИОРуководителяВДательномПадеже);
			
		КонецЕсли;
		ОбластьЗаявления.Параметры.ФИОРуководителяВДательномПадеже = ФИОРуководителяВДательномПадеже;
		
		ДолжностьРуководителяВДательномПадеже = ДолжностиРуководителейВДательномПадеже[ДанныеПечатиОбъекта.Организация];
		Если ДолжностьРуководителяВДательномПадеже = Неопределено Тогда
			ДолжностьРуководителяВДательномПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
				ДанныеПечатиОбъекта.ДолжностьРуководителя, 3);
		КонецЕсли;
		ОбластьЗаявления.Параметры.ДолжностьРуководителяВДательномПадеже = ДолжностьРуководителяВДательномПадеже;
		
		ДокументРезультат.Вывести(ОбластьЗаявления);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НачалоОбласти, ОбъектыПечати, ДанныеПечатиОбъекта.Ссылка);
	
	КонецЦикла;
		
	Возврат ДокументРезультат;
	
КонецФункции

Функция ТаблицаДанныхПечатиЗаявленияОПереводеНаДистанционнуюРаботу(МассивОбъектов) Экспорт
	
	МенеджерВременныхТаблицЗапроса = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблицЗапроса;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадровыйПеревод.Ссылка КАК Ссылка,
		|	КадровыйПеревод.Номер КАК НомерДок,
		|	КадровыйПеревод.Дата КАК ДатаДок,
		|	КадровыйПеревод.Сотрудник КАК Сотрудник,
		|	КадровыйПеревод.ФизическоеЛицо КАК ФизическоеЛицо,
		|	КадровыйПеревод.ДатаНачала КАК ДатаНачала,
		|	КадровыйПеревод.Дата КАК Период,
		|	КадровыйПеревод.Организация КАК Организация,
		|	КадровыйПеревод.Руководитель КАК Руководитель,
		|	КадровыйПеревод.ДолжностьРуководителя КАК ДолжностьРуководителя
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	Документ.КадровыйПеревод КАК КадровыйПеревод
		|ГДЕ
		|	КадровыйПеревод.Ссылка В (&МассивОбъектов)
		|	И КадровыйПеревод.ИзменитьДистанционнуюРаботу
		|	И КадровыйПеревод.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриемНаРаботу.Ссылка,
		|	ПриемНаРаботу.Номер,
		|	ПриемНаРаботу.Дата,
		|	ПриемНаРаботу.Сотрудник,
		|	ПриемНаРаботу.ФизическоеЛицо,
		|	ПриемНаРаботу.ДатаПриема,
		|	ПриемНаРаботу.Дата,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.Руководитель,
		|	ПриемНаРаботу.ДолжностьРуководителя
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Ссылка В (&МассивОбъектов)
		|	И ПриемНаРаботу.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КадровыйПереводСпискомСотрудники.Ссылка,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Номер,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Дата,
		|	КадровыйПереводСпискомСотрудники.Сотрудник,
		|	КадровыйПереводСпискомСотрудники.ФизическоеЛицо,
		|	КадровыйПереводСпискомСотрудники.ДатаНачала,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Дата,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Организация,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Руководитель,
		|	КадровыйПереводСпискомСотрудники.Ссылка.ДолжностьРуководителя
		|ИЗ
		|	Документ.КадровыйПереводСписком.Сотрудники КАК КадровыйПереводСпискомСотрудники
		|ГДЕ
		|	КадровыйПереводСпискомСотрудники.Ссылка В (&МассивОбъектов)
		|	И КадровыйПереводСпискомСотрудники.ИзменитьДистанционнуюРаботу
		|	И КадровыйПереводСпискомСотрудники.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Номер,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
		|	ПриемНаРаботуСпискомСотрудники.Сотрудник,
		|	ПриемНаРаботуСпискомСотрудники.ФизическоеЛицо,
		|	ПриемНаРаботуСпискомСотрудники.ДатаПриема,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Руководитель,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.ДолжностьРуководителя
		|ИЗ
		|	Документ.ПриемНаРаботуСписком.Сотрудники КАК ПриемНаРаботуСпискомСотрудники
		|ГДЕ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка В (&МассивОбъектов)
		|	И ПриемНаРаботуСпискомСотрудники.РаботаетДистанционно
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Ссылка,
		|	Сотрудники.НомерДок,
		|	Сотрудники.ДатаДок,
		|	Сотрудники.Сотрудник,
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.ДатаНачала,
		|	Сотрудники.Период,
		|	Сотрудники.Руководитель,
		|	Сотрудники.ДолжностьРуководителя,
		|	Сотрудники.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеПолное
		|	КОНЕЦ КАК НаименованиеОрганизацииПолное,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеСокращенное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеСокращенное
		|	КОНЕЦ КАК НаименованиеОрганизацииСокращенное
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО Сотрудники.Организация = Организации.Ссылка";
		
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина,
		"ФИОПолные,Фамилия,Имя,Отчество,Инициалы,Пол,ИОФамилия,Должность");
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента",
		"Руководитель,Период");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина,
		"ФИОПолные,ИОФамилия,Фамилия,Имя,Отчество,Инициалы,Пол");
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Ссылка КАК РассылаемыйДокумент,
		|	ДанныеДокумента.НомерДок КАК НомерДок,
		|	ДанныеДокумента.ДатаДок КАК ДатаДок,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
		|	ДанныеДокумента.Период КАК Период,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.НаименованиеОрганизацииПолное КАК НаименованиеОрганизацииПолное,
		|	ДанныеДокумента.НаименованиеОрганизацииСокращенное КАК НаименованиеОрганизацииСокращенное,
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
		|		И ДанныеДокумента.Период = КадровыеДанныеФизическихЛиц.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеДокумента.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|		И ДанныеДокумента.Период = КадровыеДанныеСотрудников.Период
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	Сотрудник,
		|	ДатаНачала";
		
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ТабличныйДокументДопСоглашениеКТрудовомуДоговоруПриПереводеДистанционнуюРаботу(Макет, МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявлениеОПереводеНаДистанционнуюРаботу";
	ДокументРезультат.ОриентацияСтраницы= ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ТаблицаДанныхПечатиОбъектов = РассылкаДокументов.ДанныеПечати(ПараметрыПечати);
	Если ТаблицаДанныхПечатиОбъектов = Неопределено Тогда
		ТаблицаДанныхПечатиОбъектов = ТаблицаДанныхПечатиДопСоглашенияПриПереводеДистанционнуюРаботу(МассивОбъектов);
	КонецЕсли;
	
	ОбластьДопСоглашения = Макет.ПолучитьОбласть("ДопСоглашение");

	ФИОРуководителейВРодительномПадеже = Новый Соответствие;
	ДолжностиРуководителейВРодительномПадеже = Новый Соответствие;
	
	ПечатаемыеСсылки = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаДанныхПечатиОбъектов,"Ссылка", Истина);
	Для Каждого ПечатаемаяСсылка Из ПечатаемыеСсылки Цикл
		
		НачалоОбласти = ДокументРезультат.ВысотаТаблицы + 1;
		
		Для Каждого ДанныеПечатиОбъекта Из ТаблицаДанныхПечатиОбъектов Цикл
			
			Если ДанныеПечатиОбъекта.Ссылка <> ПечатаемаяСсылка Тогда
				Продолжить;
			КонецЕсли;
			
			НачалоОбластиСотрудника = ДокументРезультат.ВысотаТаблицы + 1;
			// Документы нужно выводить на разных страницах.
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ОбластьДопСоглашения.Параметры.Заполнить(ДанныеПечатиОбъекта);
			ОбластьДопСоглашения.Параметры.ТрудовойДоговорДата = Формат(ДанныеПечатиОбъекта.ТрудовойДоговорДата, "ДЛФ=D");
			ОбластьДопСоглашения.Параметры.ДатаДополнительногоСоглашения = Формат(ДанныеПечатиОбъекта.ДатаНачала, "ДЛФ=D");
			ФИОРуководителяВРодительномПадеже = ФИОРуководителейВРодительномПадеже[ДанныеПечатиОбъекта.Организация];
			Если ФИОРуководителяВРодительномПадеже = Неопределено Тогда
				
				СтруктураФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
				СтруктураФИО.Фамилия = ДанныеПечатиОбъекта.РуководительФамилия;
				СтруктураФИО.Имя = ДанныеПечатиОбъекта.РуководительИмя;
				СтруктураФИО.Отчество = ДанныеПечатиОбъекта.РуководительОтчество;
				СтруктураФИО.Инициалы = ДанныеПечатиОбъекта.РуководительИнициалы;
				
				ФИОРуководителяВРодительномПадеже = "";
				Если Не ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечатиОбъекта.РуководительФИОПолные), 2,
					ФИОРуководителяВРодительномПадеже, ДанныеПечатиОбъекта.РуководительПол) Тогда
					
					СтруктураФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
					СтруктураФИО.Фамилия = ДанныеПечатиОбъекта.РуководительФамилия;
					СтруктураФИО.Имя = ДанныеПечатиОбъекта.РуководительИмя;
					СтруктураФИО.Отчество = ДанныеПечатиОбъекта.РуководительОтчество;
					СтруктураФИО.Инициалы = ДанныеПечатиОбъекта.РуководительИнициалы;
					ФизическиеЛицаЗарплатаКадры.Просклонять(СтруктураФИО.Фамилия, 2, СтруктураФИО.Фамилия, ДанныеПечатиОбъекта.РуководительПол);
					ФИОРуководителяВРодительномПадеже = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(СтруктураФИО);
				КонецЕсли;
				
				ФИОРуководителейВРодительномПадеже.Вставить(ДанныеПечатиОбъекта.Организация,ФИОРуководителяВРодительномПадеже);
				
			КонецЕсли;
			ОбластьДопСоглашения.Параметры.ФИОРуководителяВРодительномПадеже = ФИОРуководителяВРодительномПадеже;
			
			ДолжностьРуководителяВРодительномПадеже = ДолжностиРуководителейВРодительномПадеже[ДанныеПечатиОбъекта.Организация];
			Если ДолжностьРуководителяВРодительномПадеже = Неопределено Тогда
				ДолжностьРуководителяВРодительномПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
					ДанныеПечатиОбъекта.ДолжностьРуководителя, 2);
			КонецЕсли;
			ОбластьДопСоглашения.Параметры.ДолжностьРуководителяВРодительномПадеже = ДолжностьРуководителяВРодительномПадеже;
			
			Если ЗначениеЗаполнено(ДанныеПечатиОбъекта.Организация) Тогда
				
				ИННКПП = НСтр("ru = 'ИНН';
								|en = 'TIN'") + ":  "
					+ ?(ЗначениеЗаполнено(ДанныеПечатиОбъекта.ИНН), ДанныеПечатиОбъекта.ИНН, "_____________");
					
				Если ЗарплатаКадры.ЭтоЮридическоеЛицо(ДанныеПечатиОбъекта.Организация) Тогда
					
					ИННКПП = ИННКПП + " " + НСтр("ru = 'КПП';
												|en = 'CRTR'") + ": "
						+ ?(ЗначениеЗаполнено(ДанныеПечатиОбъекта.КПП), ДанныеПечатиОбъекта.КПП, "_____________");
					
				КонецЕсли;
				ОбластьДопСоглашения.Параметры.ИННКПП = ИННКПП;
			КонецЕсли;
			
			ДокументРезультат.Вывести(ОбластьДопСоглашения);
			
			КадровыйЭДО.ЗадатьДетальнуюОбластьПечати(ПараметрыПечати, ДокументРезультат,
				"ПФ_MXL_ДопСоглашениеКТрудовомуДоговоруПриПереводеНаДистанционнуюРаботу", НачалоОбластиСотрудника, ДанныеПечатиОбъекта, ПечатаемаяСсылка);
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НачалоОбласти, ОбъектыПечати, ПечатаемаяСсылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ТаблицаДанныхПечатиДопСоглашенияПриПереводеДистанционнуюРаботу(МассивОбъектов) Экспорт
	
	МенеджерВременныхТаблицЗапроса = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблицЗапроса;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадровыйПеревод.Ссылка КАК Ссылка,
		|	КадровыйПеревод.Номер КАК НомерДок,
		|	КадровыйПеревод.Дата КАК ДатаДок,
		|	КадровыйПеревод.Сотрудник КАК Сотрудник,
		|	КадровыйПеревод.ФизическоеЛицо КАК ФизическоеЛицо,
		|	КадровыйПеревод.ДатаНачала КАК ДатаНачала,
		|	КадровыйПеревод.Дата КАК Период,
		|	КадровыйПеревод.Организация КАК Организация,
		|	КадровыйПеревод.ТрудовойДоговорНомер КАК ТрудовойДоговорНомер,
		|	КадровыйПеревод.ТрудовойДоговорДата КАК ТрудовойДоговорДата,
		|	КадровыйПеревод.Руководитель КАК Руководитель,
		|	КадровыйПеревод.ДолжностьРуководителя КАК ДолжностьРуководителя
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	Документ.КадровыйПеревод КАК КадровыйПеревод
		|ГДЕ
		|	КадровыйПеревод.Ссылка В (&МассивОбъектов)
		|	И КадровыйПеревод.ИзменитьДистанционнуюРаботу
		|	И КадровыйПеревод.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриемНаРаботу.Ссылка,
		|	ПриемНаРаботу.Номер,
		|	ПриемНаРаботу.Дата,
		|	ПриемНаРаботу.Сотрудник,
		|	ПриемНаРаботу.ФизическоеЛицо,
		|	ПриемНаРаботу.ДатаПриема,
		|	ПриемНаРаботу.Дата,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.ТрудовойДоговорНомер,
		|	ПриемНаРаботу.ТрудовойДоговорДата,
		|	ПриемНаРаботу.Руководитель,
		|	ПриемНаРаботу.ДолжностьРуководителя
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Ссылка В (&МассивОбъектов)
		|	И ПриемНаРаботу.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КадровыйПереводСпискомСотрудники.Ссылка,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Номер,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Дата,
		|	КадровыйПереводСпискомСотрудники.Сотрудник,
		|	КадровыйПереводСпискомСотрудники.ФизическоеЛицо,
		|	КадровыйПереводСпискомСотрудники.ДатаНачала,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Дата,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Организация,
		|	КадровыйПереводСпискомСотрудники.ТрудовойДоговорНомер,
		|	КадровыйПереводСпискомСотрудники.ТрудовойДоговорДата,
		|	КадровыйПереводСпискомСотрудники.Ссылка.Руководитель,
		|	КадровыйПереводСпискомСотрудники.Ссылка.ДолжностьРуководителя
		|ИЗ
		|	Документ.КадровыйПереводСписком.Сотрудники КАК КадровыйПереводСпискомСотрудники
		|ГДЕ
		|	КадровыйПереводСпискомСотрудники.Ссылка В (&МассивОбъектов)
		|	И КадровыйПереводСпискомСотрудники.ИзменитьДистанционнуюРаботу
		|	И КадровыйПереводСпискомСотрудники.РаботаетДистанционно
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Номер,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
		|	ПриемНаРаботуСпискомСотрудники.Сотрудник,
		|	ПриемНаРаботуСпискомСотрудники.ФизическоеЛицо,
		|	ПриемНаРаботуСпискомСотрудники.ДатаПриема,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация,
		|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорНомер,
		|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорДата,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Руководитель,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.ДолжностьРуководителя
		|ИЗ
		|	Документ.ПриемНаРаботуСписком.Сотрудники КАК ПриемНаРаботуСпискомСотрудники
		|ГДЕ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка В (&МассивОбъектов)
		|	И ПриемНаРаботуСпискомСотрудники.РаботаетДистанционно
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Ссылка,
		|	Сотрудники.НомерДок,
		|	Сотрудники.ДатаДок,
		|	Сотрудники.Сотрудник,
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.ДатаНачала,
		|	Сотрудники.Период,
		|	Сотрудники.Руководитель,
		|	Сотрудники.ДолжностьРуководителя,
		|	Сотрудники.ТрудовойДоговорНомер,
		|	Сотрудники.ТрудовойДоговорДата,
		|	Сотрудники.Организация,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеПолное
		|	КОНЕЦ КАК НаименованиеОрганизацииПолное,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеСокращенное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеСокращенное
		|	КОНЕЦ КАК НаименованиеОрганизацииСокращенное
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО Сотрудники.Организация = Организации.Ссылка";
		
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина,
		"ФИОПолные,ФамилияИО,АдресПоПропискеПредставление,ДокументПредставление,ДатаДоговораКонтракта,НомерДоговораКонтракта,Пол,ТелефонДомашнийПредставление,EMailПредставление");
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента",
		"Руководитель,Период");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина,
		"ФИОПолные,ИОФамилия,ФамилияИО,Фамилия,Имя,Отчество,Инициалы,Пол");
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.ДатаДок КАК Период
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента";
	
	СведенияОбОрганизациях = Новый ТаблицаЗначений;
	СведенияОбОрганизациях.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СведенияОбОрганизациях.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СведенияОбОрганизациях.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("КПП", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ТелефонОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресЭлектроннойПочтыОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресЮридический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресФактический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ОрганизацияГородФактическогоАдреса", Новый ОписаниеТипов("Строка"));
	
	РезультатЗапросаПоШапке = Запрос.Выполнить();
	
	Если Не РезультатЗапросаПоШапке.Пустой() Тогда
		Выборка = РезультатЗапросаПоШапке.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрокаСведенияОбОрганизациях = СведенияОбОрганизациях.Добавить();
			
			Сведения = Новый СписокЗначений;
			Сведения.Добавить("", "НаимЮЛПол");
			Сведения.Добавить("", "ИННЮЛ");
			Сведения.Добавить("", "КППЮЛ");
			Сведения.Добавить("", "ТелОрганизации");
			Сведения.Добавить("", "АдресЭлектроннойПочтыОрганизации");
			Сведения.Добавить("", "ОргСубъект");
			Сведения.Добавить("", "ОргНПункт");
			Сведения.Добавить("", "ОргГород");
			
			УстановитьПривилегированныйРежим(Истина);
			ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, Выборка.Период, Сведения);
			УстановитьПривилегированныйРежим(Ложь);
			
			НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
			НоваяСтрокаСведенияОбОрганизациях.Период = Выборка.Период;
			НоваяСтрокаСведенияОбОрганизациях.НаименованиеПолное = ОргСведения.НаимЮЛПол;
			НоваяСтрокаСведенияОбОрганизациях.ИНН = ОргСведения.ИННЮЛ;
			НоваяСтрокаСведенияОбОрганизациях.КПП = ОргСведения.КППЮЛ;
			НоваяСтрокаСведенияОбОрганизациях.ТелефонОрганизации = ОргСведения.ТелОрганизации;
			НоваяСтрокаСведенияОбОрганизациях.АдресЭлектроннойПочтыОрганизации = ОргСведения.АдресЭлектроннойПочтыОрганизации;
			
			НоваяСтрокаСведенияОбОрганизациях.АдресФактический = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				Выборка.Организация, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации, , Выборка.Период);
			НоваяСтрокаСведенияОбОрганизациях.АдресЮридический = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				Выборка.Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, , Выборка.Период);
			
			Если Не ПустаяСтрока(ОргСведения.ОргГород) Тогда
				НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОргСведения.ОргГород;
			ИначеЕсли Не ПустаяСтрока(ОргСведения.ОргНПункт) Тогда
				НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОргСведения.ОргНПункт;
			ИначеЕсли Не ПустаяСтрока(ОргСведения.ОргСубъект) Тогда
				НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОргСведения.ОргСубъект;
			КонецЕсли;
						
		КонецЦикла;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СведенияОбОрганизациях", СведенияОбОрганизациях);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОбОрганизациях.Период КАК Период,
		|	СведенияОбОрганизациях.Организация КАК Организация,
		|	СведенияОбОрганизациях.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	СведенияОбОрганизациях.ИНН КАК ИНН,
		|	СведенияОбОрганизациях.КПП КАК КПП,
		|	СведенияОбОрганизациях.ТелефонОрганизации КАК ТелефонОрганизации,
		|	СведенияОбОрганизациях.АдресЭлектроннойПочтыОрганизации КАК АдресЭлектроннойПочтыОрганизации,
		|	СведенияОбОрганизациях.АдресЮридический КАК ОрганизацияАдресЮридический,
		|	СведенияОбОрганизациях.АдресФактический КАК ОрганизацияАдресФактический,
		|	СведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса КАК ОрганизацияГородФактическогоАдреса
		|ПОМЕСТИТЬ ВТДанныеОрганизаций
		|ИЗ
		|	&СведенияОбОрганизациях КАК СведенияОбОрганизациях
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Ссылка КАК РассылаемыйДокумент,
		|	ДанныеДокумента.НомерДок КАК НомерДок,
		|	ДанныеДокумента.ДатаДок КАК ДатаДок,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
		|	ДанныеДокумента.Период КАК Период,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.НаименованиеОрганизацииПолное КАК НаименованиеОрганизацииПолное,
		|	ДанныеДокумента.НаименованиеОрганизацииСокращенное КАК НаименованиеОрганизацииСокращенное,
		|	ЕСТЬNULL(ДанныеОрганизаций.ИНН, """") КАК ИНН,
		|	ЕСТЬNULL(ДанныеОрганизаций.КПП, """") КАК КПП,
		|	ЕСТЬNULL(ДанныеОрганизаций.ТелефонОрганизации, """") КАК ОрганизацияТелефон,
		|	ЕСТЬNULL(ДанныеОрганизаций.ОрганизацияАдресЮридический, """") КАК ОрганизацияАдресЮридический,
		|	ЕСТЬNULL(ДанныеОрганизаций.ОрганизацияАдресФактический, """") КАК ОрганизацияАдресФактический,
		|	ЕСТЬNULL(ДанныеОрганизаций.ОрганизацияГородФактическогоАдреса, """") КАК ОрганизацияГородФактическогоАдреса,
		|	ЕСТЬNULL(ДанныеОрганизаций.АдресЭлектроннойПочтыОрганизации, """") КАК ОрганизацияEMail,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ДатаДоговораКонтракта, """") КАК ТрудовойДоговорДата,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.НомерДоговораКонтракта, """") КАК ТрудовойДоговорНомер,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ФИОПолные, """") КАК ФИОПолные,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ФамилияИО, """") КАК ФамилияИО,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)) КАК Пол,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.АдресПоПропискеПредставление, """") КАК АдресПоПропискеПредставление,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ДокументПредставление, """") КАК ДокументПредставление,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ТелефонДомашнийПредставление, """") КАК ТелефонДомашнийПредставление,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.EMailПредставление, """") КАК EMailПредставление,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ФамилияИО, """") КАК РуководительФамилияИО,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ФИОПолные, """") КАК РуководительФИОПолные,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ИОФамилия, """") КАК РуководительРасшифровкаПодписи,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Фамилия, """") КАК РуководительФамилия,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Имя, """") КАК РуководительИмя,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Отчество, """") КАК РуководительОтчество,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Инициалы, """") КАК РуководительИнициалы,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)) КАК
		|		РуководительПол,
		|	ДанныеДокумента.Руководитель КАК Руководитель,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДанныеДокумента.ДолжностьРуководителя) КАК ДолжностьРуководителя
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОрганизаций КАК ДанныеОрганизаций
		|		ПО ДанныеДокумента.Организация = ДанныеОрганизаций.Организация
		|		И ДанныеДокумента.ДатаДок = ДанныеОрганизаций.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ДанныеДокумента.Руководитель = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
		|		И ДанныеДокумента.Период = КадровыеДанныеФизическихЛиц.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеДокумента.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|		И ДанныеДокумента.Период = КадровыеДанныеСотрудников.Период
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	Сотрудник,
		|	ДатаНачала";
		
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли