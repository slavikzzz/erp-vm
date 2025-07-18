#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает информацию о количестве документов по учету НДС к обработке по организации за период.
//
// Параметры:
//	ПараметрыЗапроса - Структура вида "МассивОрганизаций, НачалоПериода, КонецПериода"
//	СтруктураВидимостиЭлементов - Структура, определяет - формировать ли запрос по документу. 
// 									См. ПолучитьСтруктуруВидимостиЭлементов
//	ТолькоОбязательныеОперации - Булево, Отбирать для анализа только обязательыне операции (требуется для 
//									индикации состояния в помощнике закрытия месяца)
// Возвращаемое значение:
//	ТаблицаЗначений - Таблица документов в обработке и уже сформированных (Документ, КоличествоКОформлению, КоличествоОформленных).
//
Функция СформироватьЗапросПоДокументамКОформлению(ПараметрыЗапроса, СтруктураВидимостиЭлементов = Неопределено, ТолькоОбязательныеОперации = Ложь) Экспорт
	
	Если СтруктураВидимостиЭлементов = Неопределено Тогда
		СтруктураВидимостиЭлементов = ВидимостьЭлементов(ПараметрыЗапроса.МассивОрганизаций, ПараметрыЗапроса.НачалоПериода);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапроса.КонецПериода) Тогда
		ПараметрыЗапроса.КонецПериода = Дата('209901010000');
	КонецЕсли;
	
	МассивОрганизаций = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ПараметрыЗапроса.МассивОрганизаций);
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(
		МассивОрганизаций,
		Справочники.Организации.УправленческаяОрганизация);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОрганизаций",	МассивОрганизаций);
	Запрос.УстановитьПараметр("НачалоПериода",		ПараметрыЗапроса.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",		ПараметрыЗапроса.КонецПериода);
	
	ТекстыЗапросов = Новый Массив;
	
	ПараметрыЗапроса.Вставить("ТолькоПеревыставление", Истина);
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, 
		"СчетФактураВыданный", "ПеревыставлениеКомитенту", "И СчетФактура.Перевыставленный"));
	ПараметрыЗапроса.Вставить("ТолькоОформление", Истина);
	
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураВыданный"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураВыданныйАванс"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураПолученныйАванс"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураКомиссионеру"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "ЗаявлениеОВвозеТоваров"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураНалоговыйАгент"));
	ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураПолученныйНалоговыйАгент"));
	
	Если ТолькоОбязательныеОперации = Ложь Тогда
		
		ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураПолученный"));
		ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураКомитента"));
		ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "ТаможеннаяДекларацияИмпорт"));
		//++ НЕ УТ
		ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "ТаможеннаяДекларацияЭкспорт"));
		//-- НЕ УТ
		ТекстыЗапросов.Добавить(ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, ПараметрыЗапроса, "СчетФактураНаНеподтвержденнуюРеализацию0"));
		
	КонецЕсли;
	
	Запрос.Текст = СтрСоединить(ТекстыЗапросов, РазделительЗапросов());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция СформироватьЗапросПоПрочимОперациям(ПараметрыЗапроса) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапроса.КонецПериода) Тогда
		ПараметрыЗапроса.КонецПериода = Дата('209901010000');
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(1) КАК Количество
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж КАК ЗаписьКнигиПродаж
	|ГДЕ
	|	ЗаписьКнигиПродаж.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ЗаписьКнигиПродаж.Организация В (&МассивОрганизаций)
	|	И ЗаписьКнигиПродаж.Проведен
	|;
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(1) КАК Количество
	|ИЗ
	|	Документ.ЗаписьКнигиПокупок КАК ЗаписьКнигиПокупок
	|ГДЕ
	|	ЗаписьКнигиПокупок.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ЗаписьКнигиПокупок.Организация В (&МассивОрганизаций)
	|	И ЗаписьКнигиПокупок.Проведен
	|;
	|
	|ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата) КАК ДатаПоследнегоДокумента
	|ПОМЕСТИТЬ ДатыПоследнихОперацийПоБлокировке
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата <= &КонецПериода
	|	И БлокировкаВычетаНДССчетаФактуры.Ссылка.Организация В (&МассивОрганизаций)
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	ДатаПоследнегоДокумента
	|;
	|
	|ВЫБРАТЬ
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(БлокировкаВычетаНДССчетаФактуры.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ВТ_СрезПоследнихДокументовБлокировки
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК БлокировкаВычетаНДССчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыПоследнихОперацийПоБлокировке
	|		ПО ДатыПоследнихОперацийПоБлокировке.СчетФактура = БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|			И ДатыПоследнихОперацийПоБлокировке.ДатаПоследнегоДокумента = БлокировкаВычетаНДССчетаФактуры.Ссылка.Дата
	|ГДЕ
	|	НЕ БлокировкаВычетаНДССчетаФактуры.Ссылка.ПометкаУдаления
	|СГРУППИРОВАТЬ ПО
	|	БлокировкаВычетаНДССчетаФактуры.СчетФактура
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(1) КАК Количество
	|ИЗ
	|	Документ.БлокировкаВычетаНДС.СчетаФактуры КАК ЗаблокированныеСФ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СрезПоследнихДокументовБлокировки КАК ВТ_СрезПоследнихДокументовБлокировки
	|		ПО ЗаблокированныеСФ.СчетФактура = ВТ_СрезПоследнихДокументовБлокировки.СчетФактура
	|			И ЗаблокированныеСФ.Ссылка = ВТ_СрезПоследнихДокументовБлокировки.Ссылка
	|ГДЕ
	|	(ЗаблокированныеСФ.СрокБлокировки = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ИЛИ ЗаблокированныеСФ.СрокБлокировки > &КонецПериода)
	|	И ЗаблокированныеСФ.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБлокировкиВычетаНДС.Установлена)
	|;
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(1) КАК Количество
	|ИЗ
	|	Документ.СписаниеНДСнаРасходы КАК СписаниеНДСнаРасходы
	|ГДЕ
	|	СписаниеНДСнаРасходы.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СписаниеНДСнаРасходы.Организация В (&МассивОрганизаций)
	|	И СписаниеНДСнаРасходы.Проведен
	|";
	
	Запрос.УстановитьПараметр("НачалоПериода",		ПараметрыЗапроса.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",		ПараметрыЗапроса.КонецПериода);
	Запрос.УстановитьПараметр("МассивОрганизаций",  ПараметрыЗапроса.МассивОрганизаций);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура;
	Результат.Вставить("ЗаписиКнигиПродаж",   0);
	Результат.Вставить("ЗаписиКнигиПокупок",  0);
	Результат.Вставить("БлокировкиВычетаНДС", 0);
	Результат.Вставить("СписанияНДСнаРасходы", 0);
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Вставить("ЗаписиКнигиПродаж", Выборка.Количество);
	КонецЕсли;
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Вставить("ЗаписиКнигиПокупок", Выборка.Количество);
	КонецЕсли;
	
	Выборка = РезультатЗапроса[4].Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Вставить("БлокировкиВычетаНДС", Выборка.Количество);
	КонецЕсли;

	Выборка = РезультатЗапроса[5].Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Вставить("СписанияНДСнаРасходы", Выборка.Количество);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает информацию о количестве документов по учету НДС к обработке по организации за период.
//
// Параметры:
//	ПараметрыЗапроса - Структура вида "МассивОрганизаций, НачалоПериода, КонецПериода".
//
// Возвращаемое значение:
//	Структура - (ЕстьНевыполненныеОперации, ЕстьОбязательныеНевыполненныеОперации), тип элементов структуры - булево.
//
Функция ОперацииПоНДСКВыполнению(ПараметрыЗапроса) Экспорт
	
	НевыполненныеОперации = 0;
	ОбязательныеНевыполненныеОперации = 0;
	СчетФактураПолученныйАвансОшибкиСумм = 0;
	СчетФактураВыданныйАвансОшибкиСумм = 0;
	
	ТолькоОбязательныеОперации = Истина;
	СтруктураВидимостиЭлементов = Неопределено;
	ТаблицаНевыполненныхОпераций = СформироватьЗапросПоДокументамКОформлению(ПараметрыЗапроса, СтруктураВидимостиЭлементов, ТолькоОбязательныеОперации);
	Для Каждого Строка Из ТаблицаНевыполненныхОпераций Цикл
		
		Если Строка.Документ = "СчетФактураВыданный" 
			Или Строка.Документ = "СчетФактураВыданныйАванс" 
			Или Строка.Документ = "СчетФактураПолученныйНалоговыйАгент"
			Или Строка.Документ = "СчетФактураКомиссионеру"
			Или Строка.Документ = "ЗаявлениеОВвозеТоваров"
			Или Строка.Документ = "СчетФактураНалоговыйАгент" Тогда
			
			ОбязательныеНевыполненныеОперации = ОбязательныеНевыполненныеОперации + Строка.КоличествоКОформлению;
		ИначеЕсли Строка.Документ = "СчетФактураВыданныйАвансОшибкиСумм" Тогда
			СчетФактураВыданныйАвансОшибкиСумм = Строка.КоличествоКОформлению;
		ИначеЕсли Строка.Документ = "СчетФактураПолученныйАвансОшибкиСумм" Тогда
			СчетФактураПолученныйАвансОшибкиСумм = Строка.КоличествоКОформлению;
		КонецЕсли;
		
		НевыполненныеОперации = НевыполненныеОперации + Строка.КоличествоКОформлению;
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("НевыполненныеОперации", НевыполненныеОперации);
	Результат.Вставить("ОбязательныеНевыполненныеОперации", ОбязательныеНевыполненныеОперации);
	Результат.Вставить("ЕстьОперацииКВыполнению", (НевыполненныеОперации > 0));
	Результат.Вставить("ЕстьОбязательныеОперацииКВыполнению", (ОбязательныеНевыполненныеОперации > 0));
	Результат.Вставить("ЕстьСчетФактураПолученныйАвансОшибкиСумм", СчетФактураПолученныйАвансОшибкиСумм > 0);
	Результат.Вставить("ЕстьСчетФактураВыданныйАвансОшибкиСумм", СчетФактураВыданныйАвансОшибкиСумм > 0);
	
	Возврат Результат;
	
КонецФункции

Процедура ОпределитьСтатусРегламентныхЗаданийФоновоеЗадание(Параметры, АдресХранилища) Экспорт
	
	СостояниеЭтапов = ЗакрытиеМесяцаСервер.ОпределитьСостояниеЭтаповРасчета(
			Параметры.ЭтапыЗакрытияМесяца,
			Параметры.Период,
			Параметры.Организация);
	
	ПоместитьВоВременноеХранилище(СостояниеЭтапов, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область ТекстыЗапросов

Функция ТекстЗапросаСчетФактура(СтруктураВидимостиЭлементов, Параметры, ИмяИсточника, ВидИсточника = "", ОтборВидаИсточника = "")
	
	Если ВидИсточника = "" Тогда
		ВидИсточника = ИмяИсточника;
	КонецЕсли;
	
	Если ИмяИсточника = "СчетФактураВыданныйАванс" ИЛИ ИмяИсточника = "СчетФактураПолученныйАванс" Тогда
		Параметры.Вставить("ВернутьПолнуюТаблицу");
		Параметры.Вставить("ИсключитьИУДА");
	КонецЕсли;
	
	Текст = "";

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&ВидИсточника КАК Документ,
	|	&КоличествоКОформлению КАК КоличествоКОформлению,
	|	КОЛИЧЕСТВО(СчетФактура.Ссылка) КАК КоличествоОформленных
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактура
	|ГДЕ
	|	СчетФактура.Проведен
	|	И СчетФактура.Организация В (&МассивОрганизаций)
	|	И СчетФактура.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И &ОтборВидаИсточника
	|
	|";
	
	Если СтруктураВидимостиЭлементов[ИмяИсточника] Тогда
		
		Результат = Документы[ИмяИсточника].ЕстьСчетаФактурыКОформлению(Параметры);
		
		Если (ИмяИсточника = "СчетФактураВыданныйАванс" ИЛИ ИмяИсточника = "СчетФактураПолученныйАванс") 
				И ТипЗнч(Результат) = Тип("ТаблицаЗначений")Тогда 

			КоличествоДокументов = Результат.НайтиСтроки(Новый Структура("СФСформирован", Ложь)).Количество();
			
			ПоляГруппировки = "ДокументОснование, СФСформирован, СуммаСчетаФактуры";
			Если ИмяИсточника = "СчетФактураВыданныйАванс" Тогда
				ПолеСуммирования = "Сумма";
			Иначе
				ПолеСуммирования = "СуммаАвансаРегл";
			КонецЕсли;
			
			КоличествоДокументовСОшибкойСумм = 0;
			Результат.Свернуть(ПоляГруппировки, ПолеСуммирования);
			Результат.Колонки.Добавить("ОшибкаСумм");
			Для Каждого Строка Из Результат Цикл
				Если Строка.СФСформирован = Истина И Строка[ПолеСуммирования] <> Строка.СуммаСчетаФактуры Тогда
					СтрокиОшибкиСуммы = Результат.НайтиСтроки(Новый Структура("ДокументОснование", Строка.ДокументОснование));
					Для Каждого СтрокаОшибки Из СтрокиОшибкиСуммы Цикл
						СтрокаОшибки.ОшибкаСумм = Истина;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
			
			КоличествоДокументовСОшибкойСумм = Результат.НайтиСтроки(Новый Структура("ОшибкаСумм", Истина)).Количество();

			Текст =
			"
			|ВЫБРАТЬ
			|	&ВидИсточника КАК Документ,
			|	&КоличествоКОформлению КАК КоличествоКОформлению,
			|	КОЛИЧЕСТВО(СчетФактура.Ссылка) КАК КоличествоОформленных
			|ИЗ
			|	Документ.СчетФактураВыданный КАК СчетФактура
			|ГДЕ
			|	СчетФактура.Проведен
			|	И СчетФактура.Организация В (&МассивОрганизаций)
			|	И СчетФактура.Дата МЕЖДУ &НачалоПериода И &КонецПериода
			|	И &ОтборВидаИсточника
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";
			
			Если ИмяИсточника = "СчетФактураВыданныйАванс" Тогда
				ВидИсточникаОшибокСумм = "СчетФактураВыданныйАвансОшибкиСумм";
			Иначе 
				ВидИсточникаОшибокСумм = "СчетФактураПолученныйАвансОшибкиСумм";
			КонецЕсли; 
			
			Текст = СтрЗаменить(Текст, "СчетФактураВыданный", ИмяИсточника);
			Текст = СтрЗаменить(Текст, "&КоличествоКОформлению", Формат(КоличествоДокументовСОшибкойСумм, "ЧН=; ЧГ=0"));
			Текст = СтрЗаменить(Текст, "&ВидИсточника", """" + ВидИсточникаОшибокСумм + """");
			Текст = СтрЗаменить(Текст, "И &ОтборВидаИсточника", ОтборВидаИсточника); 
			
		Иначе
			КоличествоДокументов = Результат;
		КонецЕсли;
	Иначе
		КоличествоДокументов = 0;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СчетФактураВыданный", ИмяИсточника);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&КоличествоКОформлению", Формат(КоличествоДокументов, "ЧН=; ЧГ=0"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВидИсточника", """" + ВидИсточника + """");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборВидаИсточника", ОтборВидаИсточника);
	
	ТекстЗапроса = Текст + ТекстЗапроса;
	
	Возврат ТекстЗапроса;

КонецФункции

Функция РазделительЗапросов()
	Возврат 
		"
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|";
КонецФункции

#КонецОбласти
	
#Область Прочее

Функция ВидимостьЭлементов(Знач Организация, Период) Экспорт
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Организация, Период); 
	
	Если ТипЗнч(Организация) = Тип("СписокЗначений") Тогда
		Организация = Организация.ВыгрузитьЗначения();
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("Массив") И Организация.Количество() = 1 Тогда
		 Организация = Организация.Получить(0);
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда 
		ПараметрыУчетаОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Период);
		ПрименяетсяЛьготноеНалогообложениеНДС = ПараметрыУчетаОрганизации.ОсновноеНалогообложениеНДСПродажи = Перечисления.ТипыНалогообложенияНДС.ЛьготноеНалогообложениеНДСНаУСН;
	Иначе
		ПрименяетсяЛьготноеНалогообложениеНДС =  Ложь;
	КонецЕсли;
	
	СтруктураВидимостиЭлементов = Новый Структура;
	СтруктураВидимостиЭлементов.Вставить("СчетФактураВыданный",			Истина);
	СтруктураВидимостиЭлементов.Вставить("СчетФактураПолученный",		Истина);
	СтруктураВидимостиЭлементов.Вставить("СчетФактураВыданныйАванс",	ПлательщикНДС);
	СтруктураВидимостиЭлементов.Вставить("СчетФактураПолученныйАванс",	ПлательщикНДС И НЕ ПрименяетсяЛьготноеНалогообложениеНДС
																			Или ПолучитьФункциональнуюОпцию("ПокупкаТоваровОблагаемыхНДСУПокупателя"));
	СтруктураВидимостиЭлементов.Вставить("СчетФактураНалоговыйАгент",	Истина);
	СтруктураВидимостиЭлементов.Вставить("СчетФактураКомитента",		ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках"));
	СтруктураВидимостиЭлементов.Вставить("СчетФактураКомиссионеру",		ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах"));
	СтруктураВидимостиЭлементов.Вставить("ЗаявлениеОВвозеТоваров",		ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки"));
	СтруктураВидимостиЭлементов.Вставить("ПодтвержденияОплатыВБюджет",	ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки"));
	СтруктураВидимостиЭлементов.Вставить("ТаможеннаяДекларацияИмпорт",	ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки"));
	
	СтруктураВидимостиЭлементов.Вставить("СчетФактураПолученныйНалоговыйАгент", ПолучитьФункциональнуюОпцию("ПокупкаТоваровОблагаемыхНДСУПокупателя"));
	
	СтруктураВидимостиЭлементов.Вставить("ФормированиеЗаписейРаздела7",			ПолучитьФункциональнуюОпцию("ИспользоватьЗаполнениеРаздела7ДекларацииПоНДС"));
	СтруктураВидимостиЭлементов.Вставить("РеестрДокументовПодтверждающихЛьготу",ПолучитьФункциональнуюОпцию("ИспользоватьЗаполнениеРаздела7ДекларацииПоНДС"));
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		СтруктураВидимостиЭлементов.Вставить("ТаможеннаяДекларацияЭкспорт", Ложь);
	//++ НЕ УТ
	Иначе
		СтруктураВидимостиЭлементов.Вставить("ТаможеннаяДекларацияЭкспорт", ПолучитьФункциональнуюОпцию("ВестиУчетТаможенныхДекларацийНаЭкспорт"));
	//-- НЕ УТ
	КонецЕсли;
	
	ИспользоватьПродажиНаЭкспорт = ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортНесырьевыхТоваров")
						ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПродажиНаЭкспортСырьевыхТоваровУслуг"); 
	СтруктураВидимостиЭлементов.Вставить("СчетФактураНаНеподтвержденнуюРеализацию0", ИспользоватьПродажиНаЭкспорт);
	
	Возврат СтруктураВидимостиЭлементов;
	
КонецФункции

#КонецОбласти

#Область ФормированиеГиперссылкиВЖурналеДокументыПродажи

Функция СформироватьГиперссылкуСмТакжеВРаботе(Параметры) Экспорт
	
	Если НЕ ПравоДоступа("Просмотр", Метаданные.Обработки.ПомощникПоУчетуНДС)
		ИЛИ ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстГиперссылки = НСтр("ru = 'Помощник по учету НДС';
							|en = 'VAT accounting wizard'");
	
	Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,,, ИмяФормыРабочееМесто());
	
КонецФункции

Функция ИмяФормыРабочееМесто() Экспорт
	
	Возврат "Обработка.ПомощникПоУчетуНДС.Форма.Форма";
	
КонецФункции

#КонецОбласти

#КонецЕсли