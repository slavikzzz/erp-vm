
#Область ПрограммныйИнтерфейс

// Получение элемента справочника СтавкиНДС по перечислению СтавкиНДС
//
// Параметры:
//	ПеречислениеСтавкаНДС - ПеречислениеСсылка.СтавкиНДС - Значение ставки НДС.
//	ТипНалогообложенияНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Налогообложение НДС, в рамках которого нужно найти ставку. 
//	                                                       Если Неопределено, то ставка получается по налогообложению ПродажаОблагаетсяНДС.
//	РасчетнаяСтавка       - Булево - значение реквизита РасчетнаяСтавка. Если Неопределено, ставка получается без учета данного реквизита.
// Возвращаемое значение:
//	СправочникСсылка.СтавкиНДС - Соответствующая перечислению ставка НДС.
//
Функция СтавкаНДСПоЗначениюПеречисления(ПеречислениеСтавкаНДС, ТипНалогообложенияНДС = Неопределено, РасчетнаяСтавка = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтавкиНДС.Ссылка КАК СтавкаНДС
		|ИЗ
		|	Справочник.СтавкиНДС.ТипыНалогообложенияНДС КАК СтавкиНДС
		|ГДЕ
		|	СтавкиНДС.Ссылка.ПеречислениеСтавкаНДС = &ПеречислениеСтавкаНДС
		|	И СтавкиНДС.ТипНалогообложенияНДС = &ТипНалогообложенияНДС
		|	И (СтавкиНДС.Ссылка.РасчетнаяСтавка = &РасчетнаяСтавка ИЛИ &РасчетнаяСтавкаНеУказана)
		|	И (СтавкиНДС.Ссылка.Страна = &Страна
		|			ИЛИ &ПеречислениеСтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтавкиНДС.Ссылка КАК СтавкаНДС
		|ИЗ
		|	Справочник.СтавкиНДС КАК СтавкиНДС
		|ГДЕ
		|	СтавкиНДС.ПеречислениеСтавкаНДС = &ПеречислениеСтавкаНДС
		|	И &НалогообложениеНеУказано
		|	И (СтавкиНДС.РасчетнаяСтавка = &РасчетнаяСтавка ИЛИ &РасчетнаяСтавкаНеУказана)
		|	И (СтавкиНДС.Страна = &Страна
		|			ИЛИ &ПеречислениеСтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС))";
	
	Запрос.УстановитьПараметр("ПеречислениеСтавкаНДС", ПеречислениеСтавкаНДС);
	Если ТипНалогообложенияНДС = Неопределено Тогда
		Запрос.УстановитьПараметр("ТипНалогообложенияНДС", Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
		Запрос.УстановитьПараметр("НалогообложениеНеУказано", Истина);
	Иначе
		Запрос.УстановитьПараметр("ТипНалогообложенияНДС", ТипНалогообложенияНДС);
		Запрос.УстановитьПараметр("НалогообложениеНеУказано", Ложь);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Страна", Справочники.СтраныМира.Россия);
	Запрос.УстановитьПараметр("РасчетнаяСтавка", РасчетнаяСтавка);
	Запрос.УстановитьПараметр("РасчетнаяСтавкаНеУказана", ?(РасчетнаяСтавка = Неопределено, Истина, Ложь));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.СтавкаНДС
	КонецЕсли;
	
	Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СчетФактураПолученныйПоОснованию(ПараметрыРегистрации) Экспорт
	
	Результат = Неопределено;
	Если ПараметрыРегистрации.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		СчетаФактуры = Документы.СчетФактураПолученныйНалоговыйАгент.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	Иначе
		СчетаФактуры = Документы.СчетФактураПолученный.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	КонецЕсли;
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИнойДокументПодтвержденияНДСПоОснованию(ПараметрыРегистрации) Экспорт
	
	Результат = Неопределено;
	СчетаФактуры = Документы.ИнойДокументПодтвержденияНДС.СчетаФактурыПоОснованию(ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, Неопределено, Ложь);
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаявлениеОВвозеТоваровПоОснованию(ДокументОснование, Организация) Экспорт
	
	Результат = Неопределено;
	ЗаявленияОВвозеТоваров = Документы.ЗаявлениеОВвозеТоваров.ЗаявленияОВвозеТоваровПоОснованию(ДокументОснование, Организация, Ложь);
	Если ЗаявленияОВвозеТоваров.Количество() > 0 Тогда
		Результат = ЗаявленияОВвозеТоваров[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СчетФактураВыданныйПоОснованию(ДокументОснование, Организация) Экспорт
	
	Результат = Неопределено;
	ПараметрыОтбора = Новый Структура("Организация", Организация);
	ПараметрыОтбора.Вставить("Перевыставленный", Ложь);
	СчетаФактуры = Документы.СчетФактураВыданный.СчетаФактурыПоОснованию(ДокументОснование, ПараметрыОтбора, Неопределено, Ложь);
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция СчетФактураКомиссионеруПоОснованию(ДокументОснование, Организация, НоваяКомиссия) Экспорт
	
	Результат = Неопределено;
	Если НоваяКомиссия Тогда
		СчетаФактуры = Документы.СчетФактураВыданный.СчетаФактурыПоОснованию(ДокументОснование,,, Истина);
	Иначе
		СчетаФактуры = Документы.СчетФактураКомиссионеру.СчетаФактурыПоОснованию(ДокументОснование, Организация);
	КонецЕсли;
	Если СчетаФактуры.Количество() > 0 Тогда
		Результат = СчетаФактуры[0].Ссылка;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция СтруктураРеквизитовДляОбработки(ДокументСсылка) Экспорт 
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
	
		СтруктураРеквизитов = Документы.СчетФактураВыданный.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
	
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		
		СтруктураРеквизитов = Документы.СчетФактураПолученный.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
		
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		
		СтруктураРеквизитов = Документы.СчетФактураПолученныйНалоговыйАгент.ПараметрыЗаполненияПоСчетуФактуре(ДокументСсылка);
		
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

Функция СчетаФактурыПоТоварамВПути(Параметры) Экспорт
	
	Возврат Документы.СчетФактураПолученныйНалоговыйАгент.СчетаФактурыПоТоварамВПути(Параметры).ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Перезаполняет таблицу документов-оснований в счете-фактуре, перепроводит документ в закрытом периоде с 
// выборочной регистрацией по регл учету.
// 
// Параметры:
// 	СчетФактура - ДокументСсылка.СчетФактураПолученныйНалоговыйАгент -ранее зарегистрированный счет-фактура по товарам в пути 
// 	ДокументПриобретения - Массив,ДокументСсылка.ПриобретениеТоваровУслуг - документ отражения перехода права собственности
//
Процедура ОтразитьПолучениеТовараСОбратнымОбложениемНДС(СчетФактура, ДокументПриобретения) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОснований.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.СчетФактураПолученныйНалоговыйАгент.ДокументыОснования КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.Ссылка <> &Ссылка
	|	И ТаблицаОснований.ДокументОснование В(&СписокОснований)
	|	И ТаблицаОснований.Ссылка.Проведен
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СчетФактура);
	Запрос.УстановитьПараметр("СписокОснований", ДокументПриобретения);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Выборка = Результат.Выбрать();
	Отказ = Ложь;
	Пока Выборка.Следующий() Цикл
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для документа %1 уже введен счет-фактура';
				|en = 'Tax invoice is already posted for document %1'"),
			Выборка.ДокументОснование);
		ОбщегоНазначения.СообщитьПользователю(Текст, Выборка.ДокументОснование,,,Отказ);
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураПолученныйНалоговыйАгент");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СчетФактура);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.НДСПредъявленный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииПрочихРасходов.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииНДСКРаспределению.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//++ НЕ УТ
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Хозрасчетный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//-- НЕ УТ
		
		Блокировка.Заблокировать();
		
		ОбъектСФ = СчетФактура.ПолучитьОбъект();
		ОбъектСФ.ДокументыОснования.Очистить();
		Если ТипЗнч(ДокументПриобретения) = Тип("Массив") Тогда
			Для Каждого ДокументОснование Из ДокументПриобретения Цикл
				СтрокаОснований = ОбъектСФ.ДокументыОснования.Добавить();
				СтрокаОснований.ДокументОснование = ДокументОснование;
			КонецЦикла;
		Иначе
			ОбъектСФ.ДокументыОснования.Добавить().ДокументОснование = ДокументПриобретения;
		КонецЕсли;
		ОбъектСФ.ЗаполнитьПараметрыСчетаФактурыПоОснованию();
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДокументов_Отключить", Истина);
		ОбъектСФ.Записать();
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
		
		Движения = Новый Структура;
		
		НДСПредъявленный = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		НДСПредъявленный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("НДСПредъявленный", НДСПредъявленный);
		
		ПартииПрочихРасходов = РегистрыНакопления.ПартииПрочихРасходов.СоздатьНаборЗаписей();
		ПартииПрочихРасходов.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииПрочихРасходов", ПартииПрочихРасходов);
		
		ПартииНДСКРаспределению = РегистрыНакопления.ПартииНДСКРаспределению.СоздатьНаборЗаписей();
		ПартииНДСКРаспределению.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииНДСКРаспределению", ПартииНДСКРаспределению);
		
		//++ НЕ УТ
		ОтражениеДокументовВРеглУчете = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
		ОтражениеДокументовВРеглУчете.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ОтражениеДокументовВРеглУчете", ОтражениеДокументовВРеглУчете);
		
		Хозрасчетный = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		Хозрасчетный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("Хозрасчетный", Хозрасчетный);
		//-- НЕ УТ
		
		Регистры = Новый Структура;
		Регистры.Вставить("НДСПредъявленный");
		Регистры.Вставить("ПартииПрочихРасходов");
		Регистры.Вставить("ПартииНДСКРаспределению");
		//++ НЕ УТ
		Регистры.Вставить("ОтражениеДокументовВРеглУчете");
		//-- НЕ УТ
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(СчетФактура, Регистры);
		
		УчетНДСУП.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		ДоходыИРасходыСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		
		//++ НЕ УТ
		ТаблицаВыборочнойРегистрации = РеглУчетПроведениеСервер.ТаблицаВыборочнойРегистрацииКОтражению();
		РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
			ТаблицаВыборочнойРегистрации,
			ОбъектСФ.Организация,
			ОбъектСФ.ДатаПереходаПраваСобственности);
		Если ЗначениеЗаполнено(ТаблицаВыборочнойРегистрации) Тогда
			ТаблицыДляДвижений.Вставить("ТаблицаВыборочнойРегистрацииКОтражению", ТаблицаВыборочнойРегистрации);
		КонецЕсли;
		
		РеглУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТ
		
		//++ НЕ УТКА
		МеждународныйУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТКА
		
		Документ = ПроведениеДокументов.ЭмуляцияДокумента(СчетФактура, ОбъектСФ.Дата);
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Для Каждого Движение Из Движения Цикл
			ПроведениеДокументов.УстановитьДопСвойстваРегистра(Движение.Значение, Документ, МенеджерВТ);
			Движение.Значение.Записать();
		КонецЦикла;
		ПроведениеДокументов.СформироватьЗаданияНаОтложенныеДвижения(Документ, МенеджерВТ);
		
		//++ НЕ УТКА
		Документ = Новый Структура("Ссылка, Движения, Дата", СчетФактура, Движения, ОбъектСФ.Дата);
		МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(Документ, Новый Структура, Движения, Ложь);
		//-- НЕ УТКА
			
		РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОбновитьСостояние(
			СчетФактура,
			ОбъектСФ.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось выполнить отражение в учете документа ""%1"" по причине: %2';
					|en = 'Cannot record ""%1"" document in accounting. Reason: %2'"),
				СчетФактура,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
	КонецПопытки
	
КонецПроцедуры

// Очищает документы-основания в счете-фактуре полученном (налоговый агент), перепроводит документ в закрытом периоде с 
// выборочной регистрацией по регл учету.
// 
// Параметры:
// 	СчетФактура - ДокументСсылка.СчетФактураПолученныйНалоговыйАгент -ранее зарегистрированный счет-фактура по товарам в пути. 
//
Процедура ОчиститьДокументПриобретенияВСчетеФактуреПолученномНалоговогоАгента(СчетФактура) Экспорт
	
	РеквизитыСчетФактура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетФактура, "Корректировочный, Исправление");
	Если РеквизитыСчетФактура.Корректировочный Или РеквизитыСчетФактура.Исправление Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураПолученныйНалоговыйАгент");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СчетФактура);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.НДСПредъявленный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииПрочихРасходов.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПартииНДСКРаспределению.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//++ НЕ УТ
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОтражениеДокументовВРеглУчете.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		ЭлементБлокировки = Блокировка.Добавить("РегистрБухгалтерии.Хозрасчетный.НаборЗаписей");
		ЭлементБлокировки.УстановитьЗначение("Регистратор", СчетФактура);
		//-- НЕ УТ
		
		Блокировка.Заблокировать();
		
		ОбъектСФ = СчетФактура.ПолучитьОбъект();
		ДокументыОснования = ОбъектСФ.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
		ДатаПереходаПраваСобственности = ОбъектСФ.ДатаПереходаПраваСобственности;
		Для Каждого СтрокаОснований Из ОбъектСФ.ДокументыОснования Цикл
			СтрокаОснований.ДокументОснование = Неопределено;
		КонецЦикла;
		ОбъектСФ.ДатаПереходаПраваСобственности = Дата(1,1,1);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
		ОбъектСФ.ДополнительныеСвойства.Вставить("ПроверкаДокументов_Отключить", Истина);
		ОбъектСФ.Записать();
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
		
		Движения = Новый Структура;
		
		НДСПредъявленный = РегистрыНакопления.НДСПредъявленный.СоздатьНаборЗаписей();
		НДСПредъявленный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("НДСПредъявленный", НДСПредъявленный);
		
		ПартииПрочихРасходов = РегистрыНакопления.ПартииПрочихРасходов.СоздатьНаборЗаписей();
		ПартииПрочихРасходов.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииПрочихРасходов", ПартииПрочихРасходов);
		
		ПартииНДСКРаспределению = РегистрыНакопления.ПартииНДСКРаспределению.СоздатьНаборЗаписей();
		ПартииНДСКРаспределению.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ПартииНДСКРаспределению", ПартииНДСКРаспределению);
		
		//++ НЕ УТ
		ОтражениеДокументовВРеглУчете = РегистрыСведений.ОтражениеДокументовВРеглУчете.СоздатьНаборЗаписей();
		ОтражениеДокументовВРеглУчете.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("ОтражениеДокументовВРеглУчете", ОтражениеДокументовВРеглУчете);
		
		Хозрасчетный = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
		Хозрасчетный.Отбор.Регистратор.Установить(СчетФактура);
		Движения.Вставить("Хозрасчетный", Хозрасчетный);
		//-- НЕ УТ
		
		Регистры = Новый Структура;
		Регистры.Вставить("НДСПредъявленный");
		Регистры.Вставить("ПартииПрочихРасходов");
		Регистры.Вставить("ПартииНДСКРаспределению");
		//++ НЕ УТ
		Регистры.Вставить("ОтражениеДокументовВРеглУчете");
		//-- НЕ УТ
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(СчетФактура, Регистры);
		
		УчетНДСУП.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		ДоходыИРасходыСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		
		//++ НЕ УТ
		ТаблицаВыборочнойРегистрации = РеглУчетПроведениеСервер.ТаблицаВыборочнойРегистрацииКОтражению();
		РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
			ТаблицаВыборочнойРегистрации,
			ОбъектСФ.Организация,
			ОбъектСФ.ДатаПереходаПраваСобственности);
		Если ЗначениеЗаполнено(ТаблицаВыборочнойРегистрации) Тогда
			ТаблицыДляДвижений.Вставить("ТаблицаВыборочнойРегистрацииКОтражению", ТаблицаВыборочнойРегистрации);
		КонецЕсли;
		
		РеглУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТ
		
		//++ НЕ УТКА
		МеждународныйУчетПроведениеСервер.ОтразитьДвижения(ТаблицыДляДвижений, Движения, Ложь);
		//-- НЕ УТКА
		
		Документ = ПроведениеДокументов.ЭмуляцияДокумента(СчетФактура, ОбъектСФ.Дата);
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
		Для Каждого Движение Из Движения Цикл
			ПроведениеДокументов.УстановитьДопСвойстваРегистра(Движение.Значение, Документ, МенеджерВТ);
			Движение.Значение.Записать();
		КонецЦикла;
		ПроведениеДокументов.СформироватьЗаданияНаОтложенныеДвижения(Документ, МенеджерВТ);
		
		//++ НЕ УТКА
		Документ = Новый Структура("Ссылка, Движения, Дата", СчетФактура, Движения, ОбъектСФ.Дата);
		МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(Документ, Новый Структура, Движения, Ложь);
		//-- НЕ УТКА
			
		РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОбновитьСостояние(
			СчетФактура,
			ДокументыОснования);
	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось выполнить отражение в учете документа ""%1"" по причине: %2';
					|en = 'Cannot record ""%1"" document in accounting. Reason: %2'"),
				СчетФактура,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстСообщения;
	КонецПопытки
	
КонецПроцедуры

// Определяет перечень документов счетов-фактур выданных, на основании которых требуется выставить ИСФ/ИКСФ.
// 
// Параметры:
//  ДанныеЗаполнения - Структура - данные заполнения счета-фактуры:
//    * ДокументОснование - ДокументСсылка - Ссылка на документ продажи.
//    * Организация - СправочникСсылка.Организации - Организация, в которой отражается продажа или возврат товаров.
//    * Контрагент - СправочникСсылка.Контрагенты - Контрагент.
//    * Исправление - Булево - Признак того, что документ отражает исправление ошибок в реализации.
//    * Корректировочный - Булево - Признак того, что документ отражает корректировку реализации по согласованию сторон.
//    * РеализацияЧерезКомиссионера - Булево - Признак того, что отражается операция по комиссии версии 2.5.
//
// Возвращаемое значение:
// 	Неопределено, Массив из ДокументСсылка.СчетФактураВыданный - массив счетов-фактур оснований
//
Функция ЗаполнитьСчетаФактурыОснования(ДанныеЗаполнения) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ВалютаСчетаФактуры = ?(ДанныеЗаполнения.Свойство("Валюта"),
		ДанныеЗаполнения.Валюта, ?(ДанныеЗаполнения.Свойство("Организация"), ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация), Справочники.Валюты.ПустаяСсылка()));
	ЭтоПеревыставление = ?(ДанныеЗаполнения.Свойство("Перевыставленный"), ДанныеЗаполнения.Перевыставленный, Ложь);
	ЭтоКорректировочный = ?(ДанныеЗаполнения.Свойство("Корректировочный"), ДанныеЗаполнения.Корректировочный, Ложь);
	ЭтоРеализацияЧерезКомиссионера = ?(ДанныеЗаполнения.Свойство("РеализацияЧерезКомиссионера") И ДанныеЗаполнения.РеализацияЧерезКомиссионера <> Неопределено, ДанныеЗаполнения.РеализацияЧерезКомиссионера, Ложь);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЭтоКорректировочный", ЭтоКорректировочный);
	ДополнительныеПараметры.Вставить("ВалютаСчетаФактуры", ВалютаСчетаФактуры);
	ДополнительныеПараметры.Вставить("ЭтоПеревыставление", ЭтоПеревыставление);
	ДополнительныеПараметры.Вставить("РеализацияЧерезКомиссионера", ЭтоРеализацияЧерезКомиссионера);
	
	ТаблицаТорговыхДокументов = Новый ТаблицаЗначений;
	ТаблицаТорговыхДокументов.Колонки.Добавить("ДокументОснование", Метаданные.Документы.СчетФактураВыданный.ТабличныеЧасти.ДокументыОснования.Реквизиты.ДокументОснование.Тип);
	
	Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("Массив") Тогда
		
		МассивОснований = ДанныеЗаполнения.ДокументОснование;
		Для Каждого ОснованиеЗаполнения Из МассивОснований Цикл
			СтрокаОснования = ТаблицаТорговыхДокументов.Добавить();
			СтрокаОснования.ДокументОснование = ОснованиеЗаполнения;
		КонецЦикла;
		
	Иначе
		СтрокаОснования = ТаблицаТорговыхДокументов.Добавить();
		СтрокаОснования.ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	КонецЕсли;
	
	ТаблицаТорговыхДокументов.Свернуть("ДокументОснование");
	Если ТаблицаТорговыхДокументов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДополнительныеПараметры.Вставить("ДокументОснование", ТаблицаТорговыхДокументов[0].ДокументОснование);

	Документы.СчетФактураВыданный.ПоместитьТаблицуТоваровТорговыхДокументов(ТаблицаТорговыхДокументов.ВыгрузитьКолонку("ДокументОснование"),
		МенеджерВременныхТаблиц, "вт_ТаблицаТоваровДокументовОснований", ДополнительныеПараметры);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТорговыхДокументов", ТаблицаТорговыхДокументов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТорговыхДокументов.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ вт_ТорговыеДокументыОснования
	|ИЗ
	|	&ТаблицаТорговыхДокументов КАК ТаблицаТорговыхДокументов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	вт_ТаблицаТоваров.ИсходныйСчетФактура КАК ИсходныйСчетФактура,
	|	вт_ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	вт_ТаблицаТоваров.Характеристика КАК Характеристика,
	|	вт_ТаблицаТоваров.Серия КАК Серия,
	|	вт_ТаблицаТоваров.НоменклатураНабора КАК НоменклатураНабора,
	|	вт_ТаблицаТоваров.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	вт_ТаблицаТоваров.Содержание КАК Содержание,
	|	вт_ТаблицаТоваров.ТипЗапасов КАК ТипЗапасов,
	|	вт_ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|	вт_ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	вт_ТаблицаТоваров.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	вт_ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	МАКСИМУМ(СчетФактураВыданныйТовары.Ссылка.Дата) КАК ПредыдущийСчетФактураДата
	|ПОМЕСТИТЬ вт_КрайниеПериоды
	|ИЗ
	|	вт_ТаблицаТоваровДокументовОснований КАК вт_ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.Товары КАК СчетФактураВыданныйТовары
	|		ПО вт_ТаблицаТоваров.ИсходныйСчетФактура = СчетФактураВыданныйТовары.ИсходныйСчетФактура
	|			И вт_ТаблицаТоваров.Номенклатура = СчетФактураВыданныйТовары.Номенклатура
	|			И вт_ТаблицаТоваров.Характеристика = СчетФактураВыданныйТовары.Характеристика
	|			И вт_ТаблицаТоваров.Серия = СчетФактураВыданныйТовары.Серия
	|			И вт_ТаблицаТоваров.НоменклатураНабора = СчетФактураВыданныйТовары.НоменклатураНабора
	|			И вт_ТаблицаТоваров.ХарактеристикаНабора = СчетФактураВыданныйТовары.ХарактеристикаНабора
	|			И вт_ТаблицаТоваров.Содержание = СчетФактураВыданныйТовары.Содержание
	|			И вт_ТаблицаТоваров.ТипЗапасов = СчетФактураВыданныйТовары.ТипЗапасов
	|			И вт_ТаблицаТоваров.КодТНВЭД = СчетФактураВыданныйТовары.КодТНВЭД
	|			И вт_ТаблицаТоваров.НомерГТД = СчетФактураВыданныйТовары.НомерГТД
	|			И вт_ТаблицаТоваров.ЕдиницаИзмерения = СчетФактураВыданныйТовары.ЕдиницаИзмерения
	|			И вт_ТаблицаТоваров.СтавкаНДС = СчетФактураВыданныйТовары.СтавкаНДС
	|			И (СчетФактураВыданныйТовары.Ссылка.Проведен)
	|ГДЕ
	|	СчетФактураВыданныйТовары.Ссылка.МоментВремени < &МоментВремени
	|	И СчетФактураВыданныйТовары.Ссылка <> &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_ТаблицаТоваров.ИсходныйСчетФактура,
	|	вт_ТаблицаТоваров.Номенклатура,
	|	вт_ТаблицаТоваров.Характеристика,
	|	вт_ТаблицаТоваров.Серия,
	|	вт_ТаблицаТоваров.НоменклатураНабора,
	|	вт_ТаблицаТоваров.ХарактеристикаНабора,
	|	вт_ТаблицаТоваров.Содержание,
	|	вт_ТаблицаТоваров.ТипЗапасов,
	|	вт_ТаблицаТоваров.КодТНВЭД,
	|	вт_ТаблицаТоваров.НомерГТД,
	|	вт_ТаблицаТоваров.ЕдиницаИзмерения,
	|	вт_ТаблицаТоваров.СтавкаНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	вт_КрайниеПериоды.ИсходныйСчетФактура КАК ИсходныйСчетФактура,
	|	вт_КрайниеПериоды.Номенклатура КАК Номенклатура,
	|	вт_КрайниеПериоды.Характеристика КАК Характеристика,
	|	вт_КрайниеПериоды.Серия КАК Серия,
	|	вт_КрайниеПериоды.НоменклатураНабора КАК НоменклатураНабора,
	|	вт_КрайниеПериоды.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	вт_КрайниеПериоды.Содержание КАК Содержание,
	|	вт_КрайниеПериоды.ТипЗапасов КАК ТипЗапасов,
	|	вт_КрайниеПериоды.КодТНВЭД КАК КодТНВЭД,
	|	вт_КрайниеПериоды.НомерГТД КАК НомерГТД,
	|	вт_КрайниеПериоды.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	вт_КрайниеПериоды.СтавкаНДС КАК СтавкаНДС,
	|	МАКСИМУМ(СчетФактураВыданныйТовары.Ссылка) КАК ПредыдущийСчетФактура
	|ПОМЕСТИТЬ вт_КрайниеСчетаФактуры
	|ИЗ
	|	вт_КрайниеПериоды КАК вт_КрайниеПериоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.Товары КАК СчетФактураВыданныйТовары
	|		ПО вт_КрайниеПериоды.ИсходныйСчетФактура = СчетФактураВыданныйТовары.ИсходныйСчетФактура
	|			И вт_КрайниеПериоды.Номенклатура = СчетФактураВыданныйТовары.Номенклатура
	|			И вт_КрайниеПериоды.Характеристика = СчетФактураВыданныйТовары.Характеристика
	|			И вт_КрайниеПериоды.Серия = СчетФактураВыданныйТовары.Серия
	|			И вт_КрайниеПериоды.НоменклатураНабора = СчетФактураВыданныйТовары.НоменклатураНабора
	|			И вт_КрайниеПериоды.ХарактеристикаНабора = СчетФактураВыданныйТовары.ХарактеристикаНабора
	|			И вт_КрайниеПериоды.Содержание = СчетФактураВыданныйТовары.Содержание
	|			И вт_КрайниеПериоды.ТипЗапасов = СчетФактураВыданныйТовары.ТипЗапасов
	|			И вт_КрайниеПериоды.КодТНВЭД = СчетФактураВыданныйТовары.КодТНВЭД
	|			И вт_КрайниеПериоды.НомерГТД = СчетФактураВыданныйТовары.НомерГТД
	|			И вт_КрайниеПериоды.ЕдиницаИзмерения = СчетФактураВыданныйТовары.ЕдиницаИзмерения
	|			И вт_КрайниеПериоды.СтавкаНДС = СчетФактураВыданныйТовары.СтавкаНДС
	|			И вт_КрайниеПериоды.ПредыдущийСчетФактураДата = СчетФактураВыданныйТовары.Ссылка.Дата
	|			И (СчетФактураВыданныйТовары.Ссылка.Проведен)
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_КрайниеПериоды.ИсходныйСчетФактура,
	|	вт_КрайниеПериоды.Номенклатура,
	|	вт_КрайниеПериоды.Характеристика,
	|	вт_КрайниеПериоды.Серия,
	|	вт_КрайниеПериоды.НоменклатураНабора,
	|	вт_КрайниеПериоды.ХарактеристикаНабора,
	|	вт_КрайниеПериоды.Содержание,
	|	вт_КрайниеПериоды.ТипЗапасов,
	|	вт_КрайниеПериоды.КодТНВЭД,
	|	вт_КрайниеПериоды.НомерГТД,
	|	вт_КрайниеПериоды.ЕдиницаИзмерения,
	|	вт_КрайниеПериоды.СтавкаНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	вт_ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	вт_ТаблицаТоваров.ИсходныйСчетФактура КАК ИсходныйСчетФактура,
	|	ЕСТЬNULL(вт_КрайниеСчетаФактуры.ПредыдущийСчетФактура, вт_ТаблицаТоваров.ИсходныйСчетФактура) КАК ПредыдущийСчетФактура,
	|	ЕСТЬNULL(вт_КрайниеСчетаФактуры.ПредыдущийСчетФактура.Корректировочный, ЛОЖЬ) КАК Корректировочный,
	|	ЕСТЬNULL(вт_КрайниеСчетаФактуры.ПредыдущийСчетФактура.Исправление, ЛОЖЬ) КАК Исправление,
	|	вт_ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	вт_ТаблицаТоваров.Характеристика КАК Характеристика,
	|	вт_ТаблицаТоваров.Серия КАК Серия,
	|	вт_ТаблицаТоваров.НоменклатураНабора КАК НоменклатураНабора,
	|	вт_ТаблицаТоваров.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	вт_ТаблицаТоваров.Содержание КАК Содержание,
	|	вт_ТаблицаТоваров.ТипЗапасов КАК ТипЗапасов,
	|	вт_ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|	вт_ТаблицаТоваров.НомерГТД КАК НомерГТД,
	|	вт_ТаблицаТоваров.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	вт_ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ вт_ТаблицаТоваровПредварительная
	|ИЗ
	|	вт_ТаблицаТоваровДокументовОснований КАК вт_ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ вт_КрайниеСчетаФактуры КАК вт_КрайниеСчетаФактуры
	|		ПО вт_ТаблицаТоваров.ИсходныйСчетФактура = вт_КрайниеСчетаФактуры.ИсходныйСчетФактура
	|			И вт_ТаблицаТоваров.Номенклатура = вт_КрайниеСчетаФактуры.Номенклатура
	|			И вт_ТаблицаТоваров.Характеристика = вт_КрайниеСчетаФактуры.Характеристика
	|			И вт_ТаблицаТоваров.Серия = вт_КрайниеСчетаФактуры.Серия
	|			И вт_ТаблицаТоваров.НоменклатураНабора = вт_КрайниеСчетаФактуры.НоменклатураНабора
	|			И вт_ТаблицаТоваров.ХарактеристикаНабора = вт_КрайниеСчетаФактуры.ХарактеристикаНабора
	|			И вт_ТаблицаТоваров.Содержание = вт_КрайниеСчетаФактуры.Содержание
	|			И вт_ТаблицаТоваров.ТипЗапасов = вт_КрайниеСчетаФактуры.ТипЗапасов
	|			И вт_ТаблицаТоваров.КодТНВЭД = вт_КрайниеСчетаФактуры.КодТНВЭД
	|			И вт_ТаблицаТоваров.НомерГТД = вт_КрайниеСчетаФактуры.НомерГТД
	|			И вт_ТаблицаТоваров.ЕдиницаИзмерения = вт_КрайниеСчетаФактуры.ЕдиницаИзмерения
	|			И вт_ТаблицаТоваров.СтавкаНДС = вт_КрайниеСчетаФактуры.СтавкаНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура.Исправление
	|			ТОГДА вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура.СчетФактураОснование
	|		ИНАЧЕ вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура
	|	КОНЕЦ КАК СчетФактура,
	|	ВЫБОР
	|		КОГДА вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура.Исправление
	|			ТОГДА вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура.СчетФактураОснование.Корректировочный
	|		ИНАЧЕ вт_ТаблицаТоваровПредварительная.ПредыдущийСчетФактура.Корректировочный
	|	КОНЕЦ КАК Корректировочный
	|ПОМЕСТИТЬ вт_ТаблицаСчетовФактурПредварительная
	|ИЗ
	|	вт_ТаблицаТоваровПредварительная КАК вт_ТаблицаТоваровПредварительная
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСчетовФактур.СчетФактура КАК СчетФактура,
	|	ТаблицаСчетовФактур.Корректировочный КАК Корректировочный,
	|	МАКСИМУМ(ЕСТЬNULL(СчетФактураВыданныйИсправление.Ссылка, ЗНАЧЕНИЕ(Документ.СчетФактураВыданный.ПустаяСсылка))) КАК СчетФактураИсправление
	|ИЗ
	|	вт_ТаблицаСчетовФактурПредварительная КАК ТаблицаСчетовФактур
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетФактураВыданныйИсправление
	|		ПО ТаблицаСчетовФактур.СчетФактура = СчетФактураВыданныйИсправление.СчетФактураОснование
	|			И СчетФактураВыданныйИсправление.СозданНаОсновании = &СозданНаОсновании
	|			И СчетФактураВыданныйИсправление.Исправление
	|			И НЕ СчетФактураВыданныйИсправление.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСчетовФактур.СчетФактура,
	|	ТаблицаСчетовФактур.Корректировочный
	|";
	
	Запрос.УстановитьПараметр("МоментВремени", Новый МоментВремени(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Ссылка", Документы.СчетФактураВыданный.ПустаяСсылка());
	Запрос.УстановитьПараметр("СозданНаОсновании", ДополнительныеПараметры.ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаСчетаФактурыОснования = РезультатЗапроса.Выгрузить();
	
	Если ТаблицаСчетаФактурыОснования.Количество() > 1 Тогда 
		СоответствиеСчетовФактур = Новый Соответствие;
		Для Каждого СтрокаСФ Из ТаблицаСчетаФактурыОснования Цикл 
			СоответствиеСчетовФактур.Вставить(СтрокаСФ.СчетФактура, СтрокаСФ.СчетФактураИсправление);
		КонецЦикла;
		Возврат СоответствиеСчетовФактур;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру параметров регистрации счетов-фактур на основании документов корректировки реализации.
// Параметры:
//  ДокументСсылка - ДокументСсылка.КорректировкаРеализации
//
// Возвращаемое значение:
// См. УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурВыданных
//
Функция ПараметрыРегистрацииСчетовФактурВыданных(ДокументСсылка) Экспорт 
	
	ПараметрыРегистрации = Новый Структура;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		
		ПараметрыРегистрации = Документы.КорректировкаРеализации.ПараметрыРегистрацииСчетовФактурВыданных(ДокументСсылка);
		
	КонецЕсли;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти
