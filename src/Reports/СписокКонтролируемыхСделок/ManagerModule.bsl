#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Формирует параметры исполнения отчета.
//
// Возвращаемое значение:
//  Структура - параметры структуры:
//  * ИспользоватьПередКомпоновкойМакета - Булево - Истана, если использовать обработку перед компоновкой макета.
//  * ИспользоватьПослеВыводаРезультата - Булево - Истина, если использовать обработку после вывода результата.
//  * ИспользоватьДанныеРасшифровки - Булево - Истана, если использовать данные расшифровки.
//  * ИспользоватьПривилегированныйРежим - Булево - Истина, если выполнять в привилегированном режиме.
//  * ИспользоватьВременныеТаблицыЗапроса - Булево - Истина, использовать временные таблицы запроса.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата", Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки", Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Ложь);
	Результат.Вставить("ИспользоватьВременныеТаблицыЗапроса", Истина);
	
	Возврат Результат;

КонецФункции

// Возвращает наименование заголовка отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - параметры структуры:
//  * КлючВариантаОтчета - Строка - наименование ключа варианта отчета.
//
// Возвращаемое значение:
//  Строка - наименование заголовка отчета.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Если ПараметрыОтчета.КлючВариантаОтчета = КлючВариантаОтчетаКонтролируемыеСделкиЦепочки() Тогда
		Возврат НСтр("ru = 'Контролируемые сделки пп. 7. п. 3 ст. 105.16 НК';
					|en = 'Контролируемые сделки пп. 7. п. 3 ст. 105.16 НК'");
	Иначе
		Возврат НСтр("ru = 'Сведения о контролируемых сделках';
					|en = 'Information about controlled transactions'");
	КонецЕсли;
	
КонецФункции

// Обработчик события подсистемы БухгалтерскиеОтчеты.
// Вызов определяется параметром ИспользоватьПередКомпоновкойМакета.
// В процедуре можно доработать компоновщик перед выводом в отчет.
// Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета      - Структура - параметры структуры:
//  * Уведомление       - ДокументСсылка.УведомлениеОКонтролируемыхСделках - ссылка на документ уведомления,
//                        по которому формируется макет отчета.
//  * ОтчетныйГод       - Число - числовое значение года отчетного периода.
//  Схема               - СхемаКомпоновкиДанных - схема отчета.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - описание связи настроек и схемы отчета.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.ОтчетныйГод) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода",
			НачалоГода(Дата(ПараметрыОтчета.ОтчетныйГод, 1, 1)));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОкончаниеПериода",
			КонецГода(Дата(ПараметрыОтчета.ОтчетныйГод, 1, 1)));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Уведомление",
			ПараметрыОтчета.Уведомление);
	КонецЕсли;
	
	ЗаполнитьСтруктуруОтчета(ПараметрыОтчета, КомпоновщикНастроек);
	
	Если ПараметрыОтчета.КлючВариантаОтчета = КлючВариантаОтчетаКонтролируемыеСделкиЦепочки() Тогда
		// Для ключа варианта цепочек нужно установить отбор по сделкам с иностранными зависимыми контрагентами,
		// которые торгуют товарами мировой биржевой торговли.
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек,"ТребуютсяЦепочкиСозданияСтоимости", Истина);
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

// На основании служебных данных по контролируемым сделкам, определяет какие сделки относятся в разряд контролируемых и
// какие нет, возвращает эти данные в виде временных таблиц.
//	Параметры:
//	ПараметрыОтчета     - Структура - параметры структуры:
//  * Уведомление       - ДокументСсылка.УведомлениеОКонтролируемыхСделках - ссылка на документ уведомления,
// 						  для которого подготавливаются врменные таблицы.
// 	КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - параметр в самой функции не используется добавлен для совместимости вызова в функции
// 						  БухгалтерскиеОтчетыВызовСервера.ПодготовитьОтчет.
//	Возвращаемое значение:
//		МенеджерВременныхТаблиц - содержит в себе следующие таблицы:
//			УчастникиКонтролируемыхСделок - организации или контрагенты, сделки с которыми подлежат контролю;
//			КонтролируемыеСделки - данные из регистра накопления "КонтролируемыеСделкиОрганизаций", со сведениями о признаках по которым каждая конкретная сделка контролиурется;
//			КонтрагентыПоМинимальнойСумме - Сделки с контрагентами, которые контролируются так как сумма оборотов по ним превышает мимнимально контролируемую;
//			КонтрагентыКонтролируемыеПоОбщейСумме - Сделки с невзаимозависимыми контрагентами, которые контролируются так как сумма оборотов по ним превышает общую сумму;
//			КонтрагентыКонтролируемыеПоНДПИ - Сделки с контрагентами, контролируемые по НДПИ;
//			КонтрагентыКонтролируемыеПоСпецРежиму - Сделки с контрагентами, контролируемые по спецрежиму (сделка облагается ЕНВД или сделка с плательщиком ЕСХН);
//			КонтрагентыКонтролируемыеПоПрибыли - Сделки с контрагентами, контролируемые по налогу на прибыль;
//			КонтрагентыКонтролируемыеПоОЭЗ - Сделки с контрагентами, контролируемые в виду того, что контрагент зарегистрирован в особой экономической зоне;
//			КонтрагентыКонтролируемыеПоРегистрацииНеВРФ - Сделки с контрагентами, контролируемые в виду того, что контрагент зарегистрирован в стране с льготным налогообложением
//				или сделка совершается по товарам мировой биржевой торговли.
//
Функция МенеджерВременныхТаблицОтчета(ПараметрыОтчета, КомпоновщикНастроек) Экспорт
	
	Возврат Документы.УведомлениеОКонтролируемыхСделках.ПолучитьВременныеТаблицыДляЗаполненияУведомления(
		ПараметрыОтчета.Уведомление);
	
КонецФункции

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Возвращает массив показателей.
//
// Возвращаемое значение:
//  Массив из Строка - массив показателей.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Возвращает значение ключа варианта отчета для цепочек контролируемых сделок.
//
// Возвращаемое значение:
//  Строка - значение ключа варианта отчета для цепочек контролируемых сделок.
//
Функция КлючВариантаОтчетаКонтролируемыеСделкиЦепочки() Экспорт
	
	Возврат "КонтролируемыеСделкиЦепочки";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтруктуруОтчета(ПараметрыОтчета, КомпоновщикНастроек)
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	// Структуру упаковываем в структуру чтобы не анализировать, это первая строка группировки или нет.
	// Для первой нужно делать Структура.Добавить(), а для второй и следующих Структура.Структура.Добавить();
	Структура = Новый Структура("Структура", КомпоновщикНастроек.Настройки.Структура);
	
	Если ПараметрыОтчета.Группировка.Количество() > 0 Тогда
		
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
				
				ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Использование  = Истина;
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
				
				Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
				ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
				Иначе
					ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				КонецЕсли;
				
				Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
				
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ПредметСделки");
		
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	КонецЕсли;
	
	Если ПараметрыОтчета.КлючВариантаОтчета = КлючВариантаОтчетаКонтролируемыеСделкиЦепочки() Тогда
		
		// Добавим в последнюю группировку поля Валюта и Единица измерения.
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ЕдиницаИзмерения"); 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли