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

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(НачисленияУдержанияВзносы.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
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
	
	МетаданныеДокумента = Метаданные.Документы.РегистрацияПрочихДоходов;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

Функция СпособВыплатыПрочихДоходов() Экспорт
	Возврат Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов;
КонецФункции

Процедура ПровестиПоУчетам(Объект, Отказ) Экспорт
	УчетПрочихДоходов.ПровестиПоУчетам(Объект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//	КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Справка о списании депонированной зарплаты.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.РегистрацияПрочихДоходов";
	КомандаПечати.Идентификатор = "ПФ_MXL_СправкаОРегистрацииПрочихДоходов";
	КомандаПечати.Представление = НСтр("ru = 'Справка о регистрации прочих доходов';
										|en = 'Certificate of other income registration'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//	МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//	ПараметрыПечати - Структура - дополнительные настройки печати;
//	КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//	ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//	ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьСправку = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОРегистрацииПрочихДоходов");
	
	Если НужноПечататьСправку Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОРегистрацииПрочихДоходов",
			НСтр("ru = 'Справка о выплате бывшим сотрудникам';
				|en = 'Certificate of payment to former employees'"), ПечатьСправки(МассивОбъектов, ОбъектыПечати), ,
			"Документ.РегистрацияПрочихДоходов.ПФ_MXL_СправкаОРегистрацииПрочихДоходов");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьСправки(МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РегистрацияПрочихДоходов_СправкаОРегистрацииПрочихДоходов";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РегистрацияПрочихДоходов.ПФ_MXL_СправкаОРегистрацииПрочихДоходов");
		
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаШапкаПовторятьПриПечати = Макет.ПолучитьОбласть("ШапкаПовторятьПриПечати");
	ОбластьМакетаСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьМакетаИтоги = Макет.ПолучитьОбласть("Итоги");
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		ДанныеДокумента = ДанныеПечати.Значение;
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
		
		ОбластьМакетаШапка.Параметры.Заполнить(ДанныеДокумента);
		ДокументРезультат.Вывести(ОбластьМакетаШапка);
		
		Для каждого ДанныеСотрудника Из ДанныеДокумента.ТабличнаяЧастьДокумента Цикл
			
			МассивВыводимыхОбластей = Новый Массив;
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаСтрока);
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаПодвал);
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, МассивВыводимыхОбластей) Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьМакетаШапкаПовторятьПриПечати);
			КонецЕсли;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеСотрудника);
			
			ДокументРезультат.Вывести(ОбластьМакетаСтрока);
			
		КонецЦикла;
		
		ОбластьМакетаИтоги.Параметры.Заполнить(ДанныеДокумента);
		ДокументРезультат.Вывести(ОбластьМакетаИтоги);

		ПодписиДокументовКлиентСервер.ДополнитьТекстОснованиемПодписи(
			ДанныеДокумента.ИсполнительРасшифровкаПодписи, ДанныеДокумента.ОснованиеПодписиИсполнителя);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ДанныеДокумента);
		ДокументРезультат.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.Ссылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияПрочихДоходов.Ссылка.Организация.НаименованиеПолное КАК Организация,
	|	РегистрацияПрочихДоходов.Ссылка.Подразделение.Наименование КАК Подразделение,
	|	РегистрацияПрочихДоходов.Ссылка КАК Ссылка,
	|	РегистрацияПрочихДоходов.Ссылка.Номер КАК Номер,
	|	НАЧАЛОПЕРИОДА(РегистрацияПрочихДоходов.Ссылка.Дата, ДЕНЬ) КАК Дата,
	|	РегистрацияПрочихДоходов.Ссылка.ВидПрочегоДохода КАК ВидПрочегоДохода,
	|	РегистрацияПрочихДоходов.ФизическоеЛицо КАК ФизическоеЛицо,
	|	РегистрацияПрочихДоходов.НДФЛ КАК НДФЛ,
	|	РегистрацияПрочихДоходов.Начислено КАК СуммаДохода,
	|	РегистрацияПрочихДоходов.СуммаВычета КАК СуммаВычета,
	|	РегистрацияПрочихДоходов.Удержано КАК Удержано,
	|	РегистрацияПрочихДоходов.КВыплате КАК СуммаКВыплате,
	|	РегистрацияПрочихДоходов.Ссылка.Исполнитель.ФИО КАК Исполнитель,
	|	РегистрацияПрочихДоходов.Ссылка.ДолжностьИсполнителя КАК ДолжностьИсполнителя,
	|	РегистрацияПрочихДоходов.Ссылка.ОснованиеПодписиИсполнителя КАК ОснованиеПодписиИсполнителя
	|ИЗ
	|	Документ.РегистрацияПрочихДоходов.НачисленияУдержанияВзносы КАК РегистрацияПрочихДоходов
	|ГДЕ
	|	РегистрацияПрочихДоходов.Ссылка В(&МассивОбъектов)
	|ИТОГИ
	|	СУММА(СуммаДохода),
	|	СУММА(СуммаВычета),
	|	СУММА(НДФЛ),
	|	СУММА(Удержано),
	|	СУММА(СуммаКВыплате)
	|ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	ГруппировкаПоДокументу = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ГруппировкаПоДокументу.Следующий() Цикл
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("Ссылка", ГруппировкаПоДокументу.Ссылка);
		ДанныеПечати.Вставить("НазваниеОрганизации", ГруппировкаПоДокументу.Организация);
		ДанныеПечати.Вставить("НазваниеПодразделения", ГруппировкаПоДокументу.Подразделение);
		ДанныеПечати.Вставить("ЕдиницаИзмерения", ВалютаУчета.НаименованиеПолное);
		ДанныеПечати.Вставить("ВидПрочегоДохода", ГруппировкаПоДокументу.ВидПрочегоДохода);
		ДанныеПечати.Вставить("ДатаДокумента", Формат(ГруппировкаПоДокументу.Дата, "ДЛФ=D"));
		ДанныеПечати.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ГруппировкаПоДокументу.Номер, Истина, Истина));
		ДанныеПечати.Вставить("ДолжностьИсполнителя", ГруппировкаПоДокументу.ДолжностьИсполнителя);
		ДанныеПечати.Вставить("ОснованиеПодписиИсполнителя", ГруппировкаПоДокументу.ОснованиеПодписиИсполнителя);
		ДанныеПечати.Вставить("ИсполнительРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(Строка(ГруппировкаПоДокументу.Исполнитель)));
		ДанныеПечати.Вставить("ТабличнаяЧастьДокумента", Новый Массив);
		
		ДанныеПечати.Вставить("СуммаДохода",	ГруппировкаПоДокументу.СуммаДохода);
		ДанныеПечати.Вставить("СуммаВычета",	ГруппировкаПоДокументу.СуммаВычета);
		ДанныеПечати.Вставить("НДФЛ", 			ГруппировкаПоДокументу.НДФЛ);
		ДанныеПечати.Вставить("Удержано", 		ГруппировкаПоДокументу.Удержано);
		ДанныеПечати.Вставить("СуммаКВыплате", 	ГруппировкаПоДокументу.СуммаКВыплате);
		
		ГруппировкаПоСотрудникам = ГруппировкаПоДокументу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ГруппировкаПоСотрудникам.Следующий() Цикл
			
			СтрокаДанныхПечати = Новый Структура;
			СтрокаДанныхПечати.Вставить("Получатель", "");
			СтрокаДанныхПечати.Вставить("СуммаДохода", ГруппировкаПоСотрудникам.СуммаДохода);
			СтрокаДанныхПечати.Вставить("СуммаВычета", ГруппировкаПоСотрудникам.СуммаВычета);
			СтрокаДанныхПечати.Вставить("СуммаКВыплате", ГруппировкаПоСотрудникам.СуммаКВыплате);
			СтрокаДанныхПечати.Вставить("НДФЛ", ГруппировкаПоСотрудникам.НДФЛ);
			СтрокаДанныхПечати.Вставить("Удержано", ГруппировкаПоСотрудникам.Удержано);
			
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ГруппировкаПоСотрудникам.ФизическоеЛицо), 
				"ФИОПолные,Пол", ГруппировкаПоДокументу.Дата);
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				СтрокаДанныхПечати.Получатель = ДанныеФизическогоЛица[0].ФИОПолные;
			КонецЕсли;
			
			ДанныеПечати.ТабличнаяЧастьДокумента.Добавить(СтрокаДанныхПечати);
			
		КонецЦикла;
		
		ДанныеПечатиОбъектов.Вставить(ГруппировкаПоДокументу.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

#КонецОбласти

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт
	
	Возврат УчетПрочихДоходов.ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект);
	
КонецФункции

#КонецОбласти

#КонецЕсли