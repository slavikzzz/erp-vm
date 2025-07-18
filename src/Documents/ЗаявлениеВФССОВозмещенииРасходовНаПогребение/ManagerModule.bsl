#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать заявления о выплате пособия.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ЗаявлениеВФССПогребение";
	КомандаПечати.Представление = НСтр("ru = 'Заявление о возмещении расходов';
										|en = 'Application for expense compensation'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПечати.
Процедура Печать(МассивСсылок, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеВФССПогребение") Тогда
		ТабличныйДокумент = ТабличныйДокументЗаявлениеВФССПогребение(МассивСсылок, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаявлениеВФССПогребение",
			НСтр("ru = 'Заявление о возмещении расходов';
				|en = 'Application for expense compensation'"),
			ТабличныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Оплаты.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеТЧ = Новый Структура("Оплаты", СтрРазделить("ДокументОснование", ",", Ложь));
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты(), ФиксируемыеТЧ);
КонецФункции

#КонецОбласти

// Возвращает дату начала действия печатной формы 2022 г.
Функция ДатаФорм2022() Экспорт
	Возврат '20220913';
КонецФункции

// Возвращает имя макета печатной формы 2022 г.
Функция ИмяФормы2022() Экспорт
	Возврат "ПФ_MXL_ВозмещениеРасходовНаПогребение_2022";
КонецФункции

// Возвращает дату начала действия печатной формы 2023 г.
Функция ДатаФорм2023() Экспорт
	Возврат '20230908';
КонецФункции

// Возвращает имя макета печатной формы 2023 г.
Функция ИмяФормы2023() Экспорт
	Возврат "ПФ_MXL_ВозмещениеРасходовНаПогребение_2023";
КонецФункции

// Возвращает дату начала действия печатной формы 2025 г.
Функция ДатаФорм2025() Экспорт
	Возврат '20250101';
КонецФункции

// Возвращает имя макета печатной формы 2025 г.
Функция ИмяФормы2025() Экспорт
	Возврат "ПФ_MXL_ВозмещениеРасходовНаПогребение_2025";
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	Объект = Метаданные.Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ПолноеИмя();
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = Объект;
	НовыеСведения.ПоляРегистрации = "Оплаты.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Оплаты.РазмерПособия";
	НовыеСведения.ОбластьДанных   = "Доходы";
	
КонецПроцедуры

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Организация";
	Шаблон.ОснованиеЗаполнения = "Организация";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаименованиеТерриториальногоОрганаФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИНН");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КПП");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОКТМО");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресЭлектроннойПочтыОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТелефонСоставителя");
	
	// Роль подписанта Руководитель.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения      = "Организация";
	Шаблон.ИмяГруппы                = "Руководитель";
	Шаблон.ФиксацияГруппы           = Истина;
	Шаблон.ОтображатьПредупреждение = Ложь;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Руководитель");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьРуководителя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиРуководителя");
	
	// Реквизиты документа-основания.
	ОписаниеТипа = Метаданные.ОпределяемыеТипы.ДокументыОснованияЗаявлениеВФССОВозмещенииРасходовНаПогребение.Тип;
	Если Не ОписаниеТипа.СодержитТип(Тип("Строка")) Тогда
		Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
		Шаблон.ИмяГруппы           = "Оплаты";
		Шаблон.ОснованиеЗаполнения = "ДокументОснование";
		Шаблон.РеквизитСтроки      = Истина;
		Шаблон.Путь                = "Оплаты";
		
		ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФизическоеЛицо");
		ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РазмерПособия");
		ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КоличествоСтраниц");
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

Функция ТабличныйДокументЗаявлениеВФССПогребение(МассивСсылок, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ЗаявлениеВФССПогребение";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ПолеСлева   = 0;
	ТабличныйДокумент.ПолеСверху  = 5;
	ТабличныйДокумент.ПолеСправа  = 0;
	ТабличныйДокумент.ПолеСнизу   = 5;
	
	ДатаФорм2017 = ПрямыеВыплатыПособийСоциальногоСтрахования.ДатаВступленияВСилуФорм2017Года();
	ДатаФорм2021 = ПрямыеВыплатыПособийСоциальногоСтрахования.ДатаВступленияВСилуФорм2021Года();
	ИмяФормы2022 = ИмяФормы2022();
	ИмяФормы2023 = ИмяФормы2023();
	ИмяФормы2025 = ИмяФормы2025();
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("ДатаФорм2017", ДатаФорм2017);
	Запрос.УстановитьПараметр("ДатаФорм2021", ДатаФорм2021);
	Запрос.УстановитьПараметр("ДатаФорм2022", ДатаФорм2022());
	Запрос.УстановитьПараметр("ДатаФорм2023", ДатаФорм2023());
	Запрос.УстановитьПараметр("ИмяФормы2022", ИмяФормы2022);
	Запрос.УстановитьПараметр("ИмяФормы2023", ИмяФормы2023);
	Запрос.УстановитьПараметр("ДатаФорм2025", ДатаФорм2025());
	Запрос.УстановитьПараметр("ИмяФормы2025", ИмяФормы2025);
	
	СоздатьВТКадровыхДанных(Запрос);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка КАК Ссылка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Номер КАК Номер,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2017
	|			ТОГДА ""ЗаявлениеВФССПогребение_2012""
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2021
	|			ТОГДА ""ЗаявлениеВФССПогребение_2017""
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2022
	|			ТОГДА ""ЗаявлениеВФССПогребение_2021""
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2023
	|			ТОГДА &ИмяФормы2022
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2025
	|			ТОГДА &ИмяФормы2023
	|		ИНАЧЕ &ИмяФормы2025
	|	КОНЕЦ КАК ИмяМакета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Проведен КАК Проведен,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Организация КАК Организация,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НаименованиеТерриториальногоОрганаФСС КАК НаименованиеТерриториальногоОрганаФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.РегистрационныйНомерФСС КАК РегистрационныйНомерФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ДополнительныйКодФСС КАК ДополнительныйКодФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КодПодчиненностиФСС КАК КодПодчиненностиФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель КАК Руководитель,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.АдресОрганизации КАК АдресОрганизации,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НаименованиеБанка КАК НаименованиеБанка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КБК КАК КБК,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ОКТМО КАК ОКТМО,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НомерСчета КАК НомерСчета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.БИКБанка КАК БИКБанка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.СтатусДокумента КАК СтатусДокумента,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ТелефонСоставителя КАК ТелефонСоставителя,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.АдресЭлектроннойПочтыОрганизации КАК АдресЭлектроннойПочтыОрганизации,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ЗаявлениеСоставил КАК ЗаявлениеСоставил,
	|	ТЧОплаты.НомерСтроки КАК НомерСтроки,
	|	ТЧОплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ТЧОплаты.Статус КАК Статус,
	|	ТЧОплаты.ДокументОснование КАК ДокументОснование,
	|	ТЧОплаты.КоличествоСтраниц КАК КоличествоСтраниц,
	|	ТЧОплаты.РазмерПособия КАК РазмерПособия,
	|	ТЧОплаты.ФамилияУмершего КАК ФамилияУмершего,
	|	ТЧОплаты.ИмяУмершего КАК ИмяУмершего,
	|	ТЧОплаты.ОтчествоУмершего КАК ОтчествоУмершего,
	|	КадровыеДанныеРуководителей.ФИОПолные КАК ФИОРуководителя,
	|	ВТКадровыеДанныеФизическихЛиц.Фамилия КАК Фамилия,
	|	ВТКадровыеДанныеФизическихЛиц.Имя КАК Имя,
	|	ВТКадровыеДанныеФизическихЛиц.Отчество КАК Отчество,
	|	ВТКадровыеДанныеФизическихЛиц.СтраховойНомерПФР КАК ПолучательСНИЛС,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА Организации.НаименованиеСокращенное
	|		ИНАЧЕ ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))
	|	КОНЕЦ КАК ОрганизацияНаименование,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ИНН КАК ИНН,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КПП КАК КПП,
	|	ТЧОплаты.СНИЛСУмершего КАК СНИЛСУмершего,
	|	ТЧОплаты.СтатусУмершего КАК СтатусУмершего
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеРуководителей
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель = КадровыеДанныеРуководителей.ФизическоеЛицо
	|			И ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата = КадровыеДанныеРуководителей.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Оплаты КАК ТЧОплаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛиц
	|			ПО ТЧОплаты.ФизическоеЛицо = ВТКадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|				И ТЧОплаты.Ссылка.Дата = ВТКадровыеДанныеФизическихЛиц.Период
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка = ТЧОплаты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Организация = Организации.Ссылка
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИмяМакета") Цикл
		Если Выборка.ИмяМакета = ИмяФормы2022 Или Выборка.ИмяМакета = ИмяФормы2023 Или Выборка.ИмяМакета = ИмяФормы2025 Тогда
			ВывестиЗаявлениеОВозмещении_2022(Выборка, ТабличныйДокумент, ОбъектыПечати);
			Продолжить;
		КонецЕсли;
		Макет = Неопределено;
		ВыведеноСтрок = 0;
		ИтогоПособия = 0;
		ВсегоСтраниц = 0;
		Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
			КоличествоСтрокВМакете = 5;
		ИначеЕсли Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2017" Тогда
			КоличествоСтрокВМакете = 7;
		Иначе
			КоличествоСтрокВМакете = 3;
		КонецЕсли;
		
		Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
			Пока Выборка.Следующий() Цикл
				ВыведеноСтрок = (ВыведеноСтрок + 1) % КоличествоСтрокВМакете;
				НомерСтроки = ?(ВыведеноСтрок = 0, КоличествоСтрокВМакете, ВыведеноСтрок);
				
				Если ВыведеноСтрок = 1 Тогда
					Если Макет <> Неопределено Тогда
						Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
							ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц);
						Иначе
							ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц);
						КонецЕсли;
						Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
							ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						КонецЕсли;
						ТабличныйДокумент.Вывести(Макет);
					КонецЕсли;
					ИтогоПособия = 0;
					ВсегоСтраниц = 0;
					
					Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение." + Выборка.ИмяМакета);
					Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
						ВывестиШапкуИПодвалЗаявленияОВозмещении_2012(Макет, Выборка);
					Иначе
						ВывестиШапкуИПодвалЗаявленияОВозмещении_2017(Макет, Выборка);
					КонецЕсли;
				КонецЕсли;
				
				Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
					ВывестиСтрокуЗаявленияОВозмещении_2012(Макет, Выборка, НомерСтроки);
				ИначеЕсли Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2017" Тогда
					ВывестиСтрокуЗаявленияОВозмещении_2017(Макет, Выборка, НомерСтроки);
				Иначе
					ВывестиСтрокуЗаявленияОВозмещении_2021(Макет, Выборка, НомерСтроки);
				КонецЕсли;
				
				ИтогоПособия = ИтогоПособия + Выборка.РазмерПособия;
				ВсегоСтраниц = ВсегоСтраниц + Выборка.КоличествоСтраниц;
				
			КонецЦикла;
		КонецЦикла;
		
		Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
			ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц);
		Иначе
			ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц);
		КонецЕсли;
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабличныйДокумент.Вывести(Макет);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Процедура ВывестиШапкуИПодвалЗаявленияОВозмещении_2012(Макет, Выборка) Экспорт
	
	ДлиныСтрок = Новый Массив();
	ДлиныСтрок.Добавить(27);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.НаименованиеТерриториальногоОрганаФСС), ДлиныСтрок), Макет, "Наименование_ФСС_", 135);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.ОрганизацияНаименование), ДлиныСтрок), Макет, "ФИО_Заявителя_", 135);
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.РегистрационныйНомерФСС, Макет, "РегистрационныйНомер_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ДополнительныйКодФСС, Макет, "ДополнительныйКод_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КодПодчиненностиФСС, Макет, "КодПодчиненности_", 5);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ИНН, Макет, "ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КПП, Макет, "КПП_", 9);
	
	Если ЗначениеЗаполнено(Выборка.АдресОрганизации) Тогда
		СтруктураАдреса = ПрямыеВыплатыПособийСоциальногоСтрахования.СтруктураАдресаВМашиночитаемомФормате2012(Выборка.АдресОрганизации);
		Если ЗначениеЗаполнено(СтруктураАдреса.Индекс) Тогда
			Префикс = "АдресРегистрации_";
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Индекс), Макет, Префикс, 6);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Регион), Макет, Префикс, 17, 7);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Район), Макет, Префикс, 17, 24);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.НаселенныйПункт), Макет, Префикс, 34, 41);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Улица), Макет, Префикс, 37, 75);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Дом), Макет, Префикс, 8, 112);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Корпус), Макет, Префикс, 3, 120);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Строение), Макет, Префикс, 3, 123);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Квартира), Макет, Префикс, 6, 126);
		КонецЕсли;
	КонецЕсли;
	
	ДлиныСтрок = Новый Массив();
	ДлиныСтрок.Добавить(39);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.НаименованиеБанка), ДлиныСтрок), Макет, "НаименованиеБанка_", 78);
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.НомерСчета, Макет, "НомерСчета_", 20);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.БИКБанка, Макет, "БИК_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.НомерЛицевогоСчета, Макет, "ЛицСчет_", 12);
	
	Если ЗначениеЗаполнено(Выборка.ТелефонСоставителя) Тогда
		СтруктураТелефона = УправлениеКонтактнойИнформацией.СведенияОТелефоне(Выборка.ТелефонСоставителя);
		Телефон = СтрЗаменить(СтруктураТелефона.КодГорода, "-", "") + СтрЗаменить(СтруктураТелефона.НомерТелефона, "-", "");
		Телефон = СтрЗаменить(Телефон, " ", ""); 
		ЗарплатаКадры.ВывестиДанныеПоБуквенно(Телефон, Макет, "ТелефонСоставителя_", 10);
	КонецЕсли;
	Макет.Параметры.ДолжностьРуководителя = "" + Выборка.ДолжностьРуководителя;
	Макет.Параметры.ФИОРуководителя = "" + Выборка.ФИОРуководителя;
	
КонецПроцедуры

Процедура ВывестиСтрокуЗаявленияОВозмещении_2012(Макет, Выборка, НомерСтроки)
	
	ПрефиксСтроки = "ФИО_" + Формат(НомерСтроки,"ЧЦ=2; ЧВН=") + "_";
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Фамилия),  Макет, ПрефиксСтроки, 24);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Имя),      Макет, ПрефиксСтроки, 24, 25);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Отчество), Макет, ПрефиксСтроки, 24, 49);
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(Выборка.РазмерПособия, Макет, "РазмерПособия" + НомерСтроки + "_", 8);
	Макет.Области["Статус" + НомерСтроки].Текст = Выборка.Статус;
	
КонецПроцедуры

Процедура ВывестиШапкуИПодвалЗаявленияОВозмещении_2017(Макет, Выборка)
	
	ДлиныСтрок = Новый Массив();
	ДлиныСтрок.Добавить(27);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.НаименованиеТерриториальногоОрганаФСС), ДлиныСтрок), Макет, "Наименование_ФСС_", 135);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.ОрганизацияНаименование), ДлиныСтрок), Макет, "ФИО_Заявителя_", 135);
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.РегистрационныйНомерФСС, Макет, "РегистрационныйНомер_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ДополнительныйКодФСС, Макет, "ДополнительныйКод_", 10);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КодПодчиненностиФСС, Макет, "КодПодчиненности_", 5);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.ИНН, Макет, "ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КПП, Макет, "КПП_", 9);
	
	Если ЗначениеЗаполнено(Выборка.АдресОрганизации) Тогда
		СтруктураАдреса = ПрямыеВыплатыПособийСоциальногоСтрахования.СтруктураАдресаВМашиночитаемомФормате2012(Выборка.АдресОрганизации);
		Если ЗначениеЗаполнено(СтруктураАдреса.Индекс) Тогда
			Префикс = "АдресРегистрации_";
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Индекс), Макет, Префикс, 6);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Регион), Макет, Префикс, 37, 7);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Район), Макет, Префикс, 37, 44);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.НаселенныйПункт), Макет, Префикс, 34, 81);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Улица), Макет, Префикс, 37, 115);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Дом), Макет, Префикс, 7, 152);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Корпус), Макет, Префикс, 3, 159);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Строение), Макет, Префикс, 3, 162);
			ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(СтруктураАдреса.Квартира), Макет, Префикс, 5, 165);
		КонецЕсли;
	КонецЕсли;
	
	ДлиныСтрок = Новый Массив();
	ДлиныСтрок.Добавить(39);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ЗарплатаКадры.РазбитьСтрокуНаПодСтроки(ВРег(Выборка.НаименованиеБанка), ДлиныСтрок), Макет, "НаименованиеБанка_", 78);
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.НомерСчета, Макет, "НомерСчета_", 20);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.БИКБанка, Макет, "БИК_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.НомерЛицевогоСчета, Макет, "ЛицСчет_", 12);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Выборка.КБК, Макет, "КБК_", 20);
	
	Если ЗначениеЗаполнено(Выборка.ТелефонСоставителя) Тогда
		СтруктураТелефона = УправлениеКонтактнойИнформацией.СведенияОТелефоне(Выборка.ТелефонСоставителя);
		Телефон = СтрЗаменить(СтруктураТелефона.КодГорода, "-", "") + СтрЗаменить(СтруктураТелефона.НомерТелефона, "-", "");
		Телефон = СтрЗаменить(Телефон, " ", ""); 
		ЗарплатаКадры.ВывестиДанныеПоБуквенно(Телефон, Макет, "ТелефонСоставителя_", 10);
	КонецЕсли;
	Макет.Параметры.ДолжностьРуководителя = "" + Выборка.ДолжностьРуководителя;
	Макет.Параметры.ФИОРуководителя = "" + Выборка.ФИОРуководителя;
	
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(СокрЛП(Выборка.АдресЭлектроннойПочтыОрганизации), Макет, "АдресЭлектроннойПочты_", 28);
КонецПроцедуры

Процедура ВывестиСтрокуЗаявленияОВозмещении_2017(Макет, Выборка, НомерСтроки)
	
	Макет.Параметры["Фамилия"  + НомерСтроки] = Выборка.Фамилия;
	Макет.Параметры["Имя"      + НомерСтроки] = Выборка.Имя;
	Макет.Параметры["Отчество" + НомерСтроки] = Выборка.Отчество;
	Макет.Параметры["ФамилияУмершего"  + НомерСтроки] = Выборка.ФамилияУмершего;
	Макет.Параметры["ИмяУмершего"      + НомерСтроки] = Выборка.ИмяУмершего;
	Макет.Параметры["ОтчествоУмершего" + НомерСтроки] = Выборка.ОтчествоУмершего;
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(Выборка.РазмерПособия, Макет, "РазмерПособия" + НомерСтроки + "_", 8);
	Макет.Области["Статус" + НомерСтроки].Текст = Выборка.Статус;
	
КонецПроцедуры

Процедура ВывестиСтрокуЗаявленияОВозмещении_2021(Макет, Выборка, НомерСтроки)
	
	Макет.Параметры["Фамилия"  + НомерСтроки] = Выборка.Фамилия;
	Макет.Параметры["Имя"      + НомерСтроки] = Выборка.Имя;
	Макет.Параметры["Отчество" + НомерСтроки] = Выборка.Отчество;
	Макет.Параметры["ФамилияУмершего"  + НомерСтроки] = Выборка.ФамилияУмершего;
	Макет.Параметры["ИмяУмершего"      + НомерСтроки] = Выборка.ИмяУмершего;
	Макет.Параметры["ОтчествоУмершего" + НомерСтроки] = Выборка.ОтчествоУмершего;
	Макет.Параметры["СтатусУмершего" + НомерСтроки] = Выборка.СтатусУмершего;
	Макет.Параметры["СНИЛС" + НомерСтроки] = Выборка.СНИЛСУмершего;
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(Выборка.РазмерПособия, Макет, "РазмерПособия" + НомерСтроки + "_", 8);
	Макет.Области["Статус" + НомерСтроки].Текст = Выборка.Статус;
	
КонецПроцедуры

Процедура ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц)
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия_", 9);
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия2_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Строка(ВсегоСтраниц), Макет, "КоличествоСтраниц_", 2);
	
КонецПроцедуры

Процедура ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц)
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия_", 9);
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия2_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Строка(ВсегоСтраниц), Макет, "КоличествоСтраниц_", 2);
	
КонецПроцедуры

Процедура СоздатьВТКадровыхДанных(Запрос)
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Оплаты.ФизическоеЛицо,
	|	Оплаты.Ссылка.Дата КАК Период
	|ПОМЕСТИТЬ ВТФизическиеЛицаОбщийСписок
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Оплаты КАК Оплаты
	|ГДЕ
	|	Оплаты.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ЗаявлениеСоставил,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТФизическиеЛицаОбщийСписок.ФизическоеЛицо,
	|	ВТФизическиеЛицаОбщийСписок.Период
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТФизическиеЛицаОбщийСписок КАК ВТФизическиеЛицаОбщийСписок";
	
	Запрос.Выполнить();
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТФизическиеЛица");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(Описатель, Истина, "ФИОПолные,ФамилияИО,Фамилия,Имя,Отчество,СтраховойНомерПФР");
	
КонецПроцедуры

#Область ПФ_MXL_ВозмещениеРасходовНаПогребение_2022

Процедура ВывестиЗаявлениеОВозмещении_2022(Выборка, ТабличныйДокумент, ОбъектыПечати)
	МетаданныеМакета = Метаданные.Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Макеты[Выборка.ИмяМакета];
	КонтекстПечати = УправлениеПечатьюБЗК.КонтекстПечати(МетаданныеМакета, , ОбъектыПечати, ТабличныйДокумент);
	
	ТаблицаСтрок = Новый ТаблицаЗначений;
	ИменаКолонок = Новый Массив;
	Для Каждого КолонкаРезультатаЗапроса Из Выборка.Владелец().Колонки Цикл
		ТаблицаСтрок.Колонки.Добавить(КолонкаРезультатаЗапроса.Имя, КолонкаРезультатаЗапроса.ТипЗначения);
		ИменаКолонок.Добавить(КолонкаРезультатаЗапроса.Имя);
	КонецЦикла;
	ТаблицаСтрок.Колонки.Добавить("ВместеСоСледующим", Новый ОписаниеТипов("Булево"));
	ИменаКолонок = СтрСоединить(ИменаКолонок, ",");
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		// Получаются данные всех строк документа.
		Документ = Неопределено;
		ТаблицаСтрок.Очистить();
		Пока Выборка.Следующий() Цикл
			Если Документ = Неопределено Тогда
				Документ = Новый Структура(ИменаКолонок);
				ЗаполнитьЗначенияСвойств(Документ, Выборка);
			КонецЕсли;
			СтрокаТаблицы = ТаблицаСтрок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
		КонецЦикла;
		Если Документ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		КоличествоСтрок    = ТаблицаСтрок.Количество();
		ИтогоРазмерПособия = ТаблицаСтрок.Итог("РазмерПособия");
		КоличествоЛистов   = ТаблицаСтрок.Итог("КоличествоСтраниц");
		ТаблицаСтрок.Сортировать("НомерСтроки");
		// Первая и последняя строка выводятся вместе с шапкой и подвалом.
		// Для первой строки это обеспечивается флажком "ВместеСоСледующим" шапки.
		// Для последней строки необходимо включить явно.
		ТаблицаСтрок[КоличествоСтрок-1].ВместеСоСледующим = Истина;
		// Если строк много...
		Если КоличествоСтрок > 3 Тогда
			// На пустой лист помещается целиком 4 строки.
			// На первом листе по умолчанию помещаются 2 строки.
			ЗаВычетомПервойИПоследней = КоличествоСтрок-2;
			Остаток = ЗаВычетомПервойИПоследней % 4;
			Если Остаток = 0 Тогда
				// По умолчанию выведется как 2 4 ... 3 1,
				// а хотелось бы вывести как 1 4 ... 4 1,
				// для чего 2я строка должна "прицепиться" к 3й и "убежать" с 1й страницы.
				ТаблицаСтрок[1].ВместеСоСледующим = Истина;
			ИначеЕсли Остаток = 2 Тогда
				// При автоматической балансировке количество кратное 4 выведется как 2 4 ... 4 1 1.
				// На предпоследней странице в воздухе "повисает" 1 строка, что не очень красиво.
				Если КоличествоСтрок = 4 Тогда
					// 4 строки выводятся по схеме "1 2 1",
					// для чего 2я строка должна "прицепиться" к 3й.
					ТаблицаСтрок[1].ВместеСоСледующим = Истина;
				ИначеЕсли КоличествоСтрок = 8 Тогда
					// 8 строк выводятся по схеме "1 3 3 1",
					// для чего 2я строка должна "прицепиться" к 3й,
					ТаблицаСтрок[1].ВместеСоСледующим = Истина;
					// а две пред-предпоследние строки должны "прицепиться" к предпоследней (-2й).
					ТаблицаСтрок[КоличествоСтрок-4].ВместеСоСледующим = Истина;
					ТаблицаСтрок[КоличествоСтрок-3].ВместеСоСледующим = Истина;
				Иначе
					// 12, 16 и т.д. строк - по схеме: "2 4 ... 4 3 3 3 1".
					ТаблицаСтрок[КоличествоСтрок-7].ВместеСоСледующим = Истина;
					ТаблицаСтрок[КоличествоСтрок-6].ВместеСоСледующим = Истина;
					ТаблицаСтрок[КоличествоСтрок-4].ВместеСоСледующим = Истина;
					ТаблицаСтрок[КоличествоСтрок-3].ВместеСоСледующим = Истина;
				КонецЕсли;
			ИначеЕсли Остаток = 3 И КоличествоСтрок > 8 Тогда
				// Вывод по схеме "2 4 ... 4 3 3 1".
				ТаблицаСтрок[КоличествоСтрок-4].ВместеСоСледующим = Истина;
				ТаблицаСтрок[КоличествоСтрок-3].ВместеСоСледующим = Истина;
			КонецЕсли;
		КонецЕсли;
		// Начало печати.
		УправлениеПечатьюБЗК.ПередПечатьюОчередногоОбъекта(КонтекстПечати);
		// Вывод шапки.
		Шапка = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Шапка");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Шапка, Документ.ОрганизацияНаименование, "СтраховательНаименование");
		КонтекстПечати.ТабличныйДокумент.Вывести(Шапка.ТабличныйДокумент);
		// Вывод строк таблицы.
		Для Каждого СтрокаТаблицы Из ТаблицаСтрок Цикл
			Параметры = Новый Структура(КонтекстПечати.ИменаПараметровОбластей.СтрокаТаблицы);
			Параметры.НомерСтроки = СтрокаТаблицы.НомерСтроки;
			Секция = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "СтрокаТаблицы");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.ФамилияУмершего,  "УмершийФамилия");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.ИмяУмершего,      "УмершийИмя");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.ОтчествоУмершего, "УмершийОтчество");
			УправлениеПечатьюБЗК.ВывестиСНИЛСПоБуквам(Секция, СтрокаТаблицы.СНИЛСУмершего,    "УмершийСНИЛС");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.СтатусУмершего,   "УмершийСтатус");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.Фамилия,          "ПолучательФамилия");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.Имя,              "ПолучательИмя");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.Отчество,         "ПолучательОтчество");
			УправлениеПечатьюБЗК.ВывестиСНИЛСПоБуквам(Секция, СтрокаТаблицы.ПолучательСНИЛС,  "ПолучательСНИЛС");
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция,      СтрокаТаблицы.Статус,           "ПолучательСтатус");
			УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Секция, СтрокаТаблицы.РазмерПособия,    "РазмерПособия");
			Секция.ТабличныйДокумент.Области.КонецСтроки.ВместеСоСледующим = СтрокаТаблицы.ВместеСоСледующим;
			Секция.ТабличныйДокумент.Параметры.Заполнить(Параметры);
			КонтекстПечати.ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
		КонецЦикла;
		
		// Вывод пустых строк.
		Для НомерСтроки = КоличествоСтрок + 1 По 3 Цикл
			Параметры = Новый Структура(КонтекстПечати.ИменаПараметровОбластей.СтрокаТаблицы);
			Параметры.НомерСтроки = НомерСтроки;
			Секция = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "СтрокаТаблицы");
			Секция.ТабличныйДокумент.Параметры.Заполнить(Параметры);
			КонтекстПечати.ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
		КонецЦикла;
		
		// Вывод подвала.
		ПараметрыПодвала = Новый Структура(КонтекстПечати.ИменаПараметровОбластей.Подвал);
		ПараметрыПодвала.УполномоченныйПредставительДолжность = Строка(Документ.ДолжностьРуководителя);
		ПараметрыПодвала.УполномоченныйПредставительФИО       = Строка(Документ.ФИОРуководителя);
		Подвал = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Подвал");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.РегистрационныйНомерФСС,    "РегистрационныйНомер");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.ДополнительныйКодФСС,       "ДополнительныйКод");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.ИНН,                        "ИНН");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.КПП,                        "КПП");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.ОрганизацияНаименование,    "ПолучательНаименование");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.НаименованиеБанка,          "БанкНаименование");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.НомерСчета,                 "НомерСчета");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.БИКБанка,                   "БанкБИК");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.НомерЛицевогоСчета,         "ЛицевойСчет");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.КБК,                        "КБК");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.ОКТМО,                      "ОКТМО");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.АдресЭлектроннойПочтыОрганизации, "СтраховательПочта");
		УправлениеПечатьюБЗК.ВывестиТелефонПоБуквам(Подвал, Документ.ТелефонСоставителя,        "СтраховательТелефон");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.КодПодчиненностиФСС,              "КодТОФ");
		УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Подвал, ИтогоРазмерПособия, "ИтогоРазмерПособия");
		Если Подвал.ГруппыОбластей["КодПодчиненности"] <> Неопределено Тогда
			УправлениеПечатьюБЗК.ВывестиПоБуквам(Подвал, Документ.КодПодчиненностиФСС, "КодПодчиненности");
		КонецЕсли;
		ПараметрыПодвала.КоличествоПособий = КоличествоСтрок;
		ПараметрыПодвала.КоличествоЛистов  = КоличествоЛистов;
		Подвал.ТабличныйДокумент.Параметры.Заполнить(ПараметрыПодвала);
		КонтекстПечати.ТабличныйДокумент.Вывести(Подвал.ТабличныйДокумент);
		
		// Окончание печати.
		УправлениеПечатьюБЗК.ПослеПечатиОчередногоОбъекта(КонтекстПечати, Документ.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
