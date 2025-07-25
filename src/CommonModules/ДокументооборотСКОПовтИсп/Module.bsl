////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры и функции регламентированных отчетов общего назначения 
// с кешируемым результатом на время сеанса.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция PostЗапросОператору(ИмяМетода) Экспорт
	
	Возврат ДокументооборотСКО.PostЗапросОператору(ИмяМетода);

КонецФункции

Функция ДанныеУЦИзВебСервиса(Спецоператор) Экспорт
	
	Спецоператор = Перечисления.СпецоператорыСвязи.КалугаАстрал;
	
	Сервис = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОбменССерверомСоздатьСервис(Спецоператор,,,,Ложь);
	
	Если Сервис = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		XDTOРезультат = Сервис.GetCaInfo1C(РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось получить наименование УЦ:
					|%1';
					|en = 'Не удалось получить наименование УЦ:
					|%1'"), ИнформацияОбОшибке.Описание);
					
		ТекстОшибки = ДокументооборотСКОВызовСервера.ДобавитьТекстОшибкиСертификатаКА(ТекстОшибки);
					
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СообщитьИлиПередатьВМастерОшибку(
			ТекстОшибки, 
			, 
			, 
			Ложь);
			
		ДокументооборотСКО.ОбработатьИсключение(ИнформацияОбОшибке, "Ошибка при выполнении метода GetCaInfo1C");
			
		Возврат Неопределено;
	КонецПопытки;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XDTOРезультат);
	
	ПостроительДОМ 	= Новый ПостроительDOM();
	ДОМ 			= ПостроительДОМ.Прочитать(ЧтениеXML);
	УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("code");
	кодРезультата 	= УзелDOM[0].ТекстовоеСодержимое;
	
	
	Если кодРезультата = "0" Тогда
		
		УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("ca");
		НаименованиеУЦ 	= УзелDOM[0].ТекстовоеСодержимое;
		
		УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("caReglament");
		АдресРегламента = УзелDOM[0].ТекстовоеСодержимое;
		АдресРегламента = РаскодироватьСтроку(АдресРегламента, СпособКодированияСтроки.КодировкаURL);
		
		УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("toWhom");
		Получатель		= УзелDOM[0].ТекстовоеСодержимое;		
		
		УзелDOM 		= ДОМ.ПолучитьЭлементыПоИмени("address");
		АдресУЦ			= УзелDOM[0].ТекстовоеСодержимое;
		
		Результат = Новый Структура();
		Результат.Вставить("НаименованиеУЦ",  НаименованиеУЦ);
		Результат.Вставить("РегламентУЦ", 	АдресРегламента);
		Результат.Вставить("ПолучательЗаявленияВУЦ", Получатель);
		Результат.Вставить("АдресУЦ", АдресУЦ);
		
		Возврат Результат;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть();
	
КонецФункции

Функция ДоверенныеСторонниеУЦ() Экспорт
	
	Ответ = ДокументооборотСКОПовтИсп.PostЗапросОператору("GetSolidCaInfo");
	
	Если Ответ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	ДОМ = ДокументооборотСКО.ДваждыРазобратьОтветНаPostЗапрос(Ответ, "string", "windows-1251");
	СторонниеУЦ = Новый Массив;
	
	УзлыУЦ = ДОМ.ПолучитьЭлементыПоИмени("Ca");
	Для каждого УзелУЦ Из УзлыУЦ Цикл
		
		СтороннийУЦ = Новый Структура;

		ДочерниеУзлы = УзелУЦ.ДочерниеУзлы;
		Для каждого ДочернийУзел Из ДочерниеУзлы Цикл
			Если ДочернийУзел.ИмяУзла = "CaName" Тогда
				
				СтороннийУЦ.Вставить("Представление", ДочернийУзел.ТекстовоеСодержимое);
				
			ИначеЕсли ДочернийУзел.ИмяУзла = "Skids" Тогда
				
				УзлыИдентификаторы = ДочернийУзел.ДочерниеУзлы;
				Skids = Новый Массив;
				Для каждого УзелИдентификаторы Из УзлыИдентификаторы Цикл
					Skids.Добавить(УзелИдентификаторы.ТекстовоеСодержимое);
				КонецЦикла;
				СтороннийУЦ.Вставить("Skids", Skids);
				
			ИначеЕсли ДочернийУзел.ИмяУзла = "CNs" Тогда
				
				Наименования = Новый Массив;
				УзлыНаименования = ДочернийУзел.ДочерниеУзлы;
				Для каждого УзелНаименование Из УзлыНаименования Цикл
					Наименования.Добавить(УзелНаименование.ТекстовоеСодержимое);
				КонецЦикла;
				СтороннийУЦ.Вставить("Наименования", Наименования);
			
			КонецЕсли;
		КонецЦикла;
		
		СторонниеУЦ.Добавить(СтороннийУЦ);
		
	КонецЦикла;

	Возврат СторонниеУЦ;  
	
КонецФункции

Функция ПолучитьПараметрыОператораСвязи(Знач Спецоператор) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Макет = КонтекстЭДОСервер.ПолучитьМакет("ПараметрыСпецоператоровСвязи");
	
	// Инициализируем ключи, чтобы не было падения при попытке получить значение из Неопределено
	Результат = Новый Структура();
	Для НомерСтолбца = 1 По Макет.ШиринаТаблицы Цикл
		Ключ = Макет.Область(0, НомерСтолбца, 0, НомерСтолбца).Имя;
		Результат.Вставить(Ключ, "");
	КонецЦикла;

	Если ЗначениеЗаполнено(Спецоператор) Тогда
		
		Если ТипЗнч(Спецоператор) = Тип("ПеречислениеСсылка.СпецоператорыСвязи") Тогда
			ИмяСпецоператора = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьИмяЗначенияПеречисленияСпецоператорыСвязиПоСинониму(Спецоператор);
		Иначе
			ИмяСпецоператора = Спецоператор.Имя;
		КонецЕсли;
		
		Для НомерСтроки = 2 По Макет.ВысотаТаблицы Цикл
			
			ИмяТекущейСтроки = Макет.Область(НомерСтроки, 1).Текст;
			
			Если НРег(ИмяТекущейСтроки) = НРег(ИмяСпецоператора) Тогда
				
				Для НомерСтолбца = 1 По Макет.ШиринаТаблицы Цикл
					
					Ключ = Макет.Область(0, НомерСтолбца, 0, НомерСтолбца).Имя;
					Значение = Макет.Область(НомерСтроки, НомерСтолбца, НомерСтроки, НомерСтолбца).Текст;
					
					Результат[Ключ] = Значение;
					
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОбменССерверомСоздатьСервисНизкоуровневый(СпецОператорСвязи, ПараметрыРесурса = Неопределено) Экспорт

	Результат = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОбменССерверомСоздатьСервисНизкоуровневый(СпецОператорСвязи, ПараметрыРесурса);
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПараметрСпецоператора(Знач Спецоператор, Параметр) Экспорт
	
	ПараметрыСпецоператора = ДокументооборотСКОПовтИсп.ПолучитьПараметрыОператораСвязи(Спецоператор);
	Возврат ПараметрыСпецоператора[Параметр];
	
КонецФункции

Функция СоздатьКлиентСервисаПоСпецоператоруСвязи(СпецоператорСвязи) Экспорт
	
	Результат = Новый Структура("Выполнено", Истина);
	
	Обмен = ДокументооборотСКОПовтИсп.ОбменССерверомСоздатьСервисНизкоуровневый(СпецОператорСвязи);
	
	Если Обмен.Сервис = Неопределено Тогда
		Результат.Выполнено = Ложь;
 		Результат.Вставить("ОписаниеОшибки", Обмен.КраткаяОшибка);
	Иначе
		Результат.Вставить("КлиентСервиса", Обмен.Сервис);
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

Функция КодРегиона(АдресЮридический) Экспорт
	
	ЭтоАдресПоФИАСу = УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(АдресЮридический);
	
	Если ЭтоАдресПоФИАСу Тогда	
		
		СведенияОбАдресе = ОбработкаЗаявленийАбонента.СведенияОбАдресе(АдресЮридический);
		КодРегиона 		 = СведенияОбАдресе.КодРегиона;
		
	Иначе
		
		КодРегиона = ОбработкаЗаявленийАбонента.РазобратьСтрокуАдреса(АдресЮридический, ",");
		
	КонецЕсли;
	
	Возврат КодРегиона;
	
КонецФункции

Функция УчетнаяЗаписьОблачнойПодписьПоОтпечатку(ОтпечатокСертификата) Экспорт
	
	Результат = Неопределено;
	
	Если КриптографияЭДКО.ИспользованиеОблачнойПодписиВозможно() Тогда
		МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
		НашлиСертификат = МодульСервисКриптографииDSS.НайтиСертификат(Новый Структура("Отпечаток", ОтпечатокСертификата));
		Результат = ?(НЕ НашлиСертификат.Выполнено, Неопределено, НашлиСертификат.УчетнаяЗапись);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаВидовОтправляемыхДокументов() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыОтправляемыхДокументов.Ссылка КАК Ссылка,
		|	ВидыОтправляемыхДокументов.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.ВидыОтправляемыхДокументов КАК ВидыОтправляемыхДокументов");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ОписаниеКлиентскогоПриложенияДляСЭДО() Экспорт

	Описание = "";
	Попытка
		СистемнаяИнформация = Новый СистемнаяИнформация; 
		ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
		
		ВариантРаботы = ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(), "File", "ClientServer");
		РежимРазделения = ?(ОбщегоНазначения.РазделениеВключено(), "; Splitted", "");
		
		ВерсияПодсистемы = "";
		УстановитьПривилегированныйРежим(Истина);
		ВерсииПодсистем = ОбновлениеИнформационнойБазы.ВерсииПодсистем();
		УстановитьПривилегированныйРежим(Ложь);
		СтрокаБРО = ВерсииПодсистем.Найти("РегламентированнаяОтчетность", "ИмяПодсистемы");
		Если СтрокаБРО <> Неопределено Тогда
			ВерсияПодсистемы = СтрокаБРО.Версия;
		Иначе
			ВерсияПодсистемы = "0.0.0.0";
		КонецЕсли;
		
		ИдентификаторКонфигурации = ОбщегоНазначения.ИдентификаторИнтернетПоддержкиКонфигурации();
		
		Описание = СтрШаблон("1C+Enterprise/%1"
				+ " (%2%3)"
				+ " BRO/%4"
				+ " %5/%6",
			ВерсияПлатформы,
			ВариантРаботы,
			РежимРазделения,
			ВерсияПодсистемы,
			ИдентификаторКонфигурации,
			Метаданные.Версия);
	Исключение
	КонецПопытки;
	
	Возврат Описание;

КонецФункции

Функция ШаблоныПисем() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Макет   = Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьМакет("ШаблоныПисем");
	Таблица = КонтекстЭДОСервер.ДанныеМакетаЧерезПостроительЗапроса(Макет);
	
	Возврат Таблица;
	
КонецФункции

Функция ДанныеСправочникаШаблонаПоИмениМакета(ИмяМакета) Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Макет = Справочники.ШаблоныПоясненийДляФНС.ПолучитьМакет(ИмяМакета);
	ТаблицаИзМакета = КонтекстЭДОСервер.ДанныеМакетаЧерезПостроительЗапроса(Макет);
	
	Значения = Новый Массив;
	Для каждого СтрокиИзМакета Из ТаблицаИзМакета Цикл
		Значение = ДокументооборотСКОКлиентСервер.СделатьПервуюБуквуЗаглавной(СокрЛП(СтрокиИзМакета.Значение));
		
		Если ЗначениеЗаполнено(Значение) Тогда 
			
			УдалитьСимволОкончанияСтроки(Значение);
			Значения.Добавить(Значение);
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Значения;
	
КонецФункции

Процедура УдалитьСимволОкончанияСтроки(Текст) Экспорт
	
	ПоследнийСимвол = Прав(Текст, 1);
	Если ПоследнийСимвол = ";" ИЛИ ПоследнийСимвол = "," ИЛИ ПоследнийСимвол = "." ИЛИ ПоследнийСимвол = "." Тогда
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Текст);
	КонецЕсли;
	
КонецПроцедуры

Функция ВидыПредставляемыхДокументов() Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Макет = КонтекстЭДОСервер.ПолучитьМакет("ВидыПредставляемыхДокументов");
	КолонкиБулево = КолонкиДляПреобразованияВБулево();
	
	Виды = КонтекстЭДОСервер.ДанныеМакетаЧерезПостроительЗапроса(
		Макет, 
		КолонкиБулево);
		
	Виды.Колонки.Добавить("Значение");
	
	Для каждого Вид Из Виды Цикл
		Вид.Значение = Перечисления.ВидыПредставляемыхДокументов[Вид.Имя];
	КонецЦикла; 
	
	Возврат Виды;
		
КонецФункции

Функция КолонкиДляПреобразованияВБулево() Экспорт

	КолонкиБулево = Новый Массив;
	КолонкиБулево.Добавить("ЭтоНДС");
	КолонкиБулево.Добавить("ЕстьЭД");
	КолонкиБулево.Добавить("ОбязательноПодтверждение");
	
	Возврат КолонкиБулево;
		
КонецФункции

Функция ЭтоРежимОблачной1СО() Экспорт
	
	Возврат ВРЕГ(Метаданные.Имя) = ВРЕГ("Отчетность");
	
КонецФункции

Функция СписокВыбораРегионов() Экспорт

	СписокРегионов = Новый ТаблицаЗначений;
	СписокРегионов.Колонки.Добавить("Значение");
	СписокРегионов.Колонки.Добавить("Представление");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификатор = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификатор");
		ТаблицаРегионов = МодульАдресныйКлассификатор.СубъектыРФ();
		
		Для каждого СтрокаТаблицы Из ТаблицаРегионов Цикл
			НоваяСтрока = СписокРегионов.Добавить();
			НоваяСтрока.Значение = Формат(СтрокаТаблицы.КодСубъектаРФ, "ЧЦ=2; ЧДЦ=; ЧВН=");
			НоваяСтрока.Представление = СтрокаТаблицы.Наименование + " " + СтрокаТаблицы.Сокращение;
		КонецЦикла;
	КонецЕсли;
	
	СписокРегионов.Сортировать("Представление Возр");
	
	НоваяСтрока = СписокРегионов.Вставить(0);
	НоваяСтрока.Значение = Формат(0, "ЧЦ=2; ЧДЦ=; ЧВН=");
	НоваяСтрока.Представление = НСтр("ru = 'Все регионы';
									|en = 'Все регионы'");
	
	Возврат СписокРегионов;
	
КонецФункции

#КонецОбласти