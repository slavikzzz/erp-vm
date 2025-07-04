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
	
	Возврат НСтр("ru = 'Список цепочек создания стоимости контролируемых сделок';
				|en = 'Список цепочек создания стоимости контролируемых сделок'");
	
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
	
	Организации = Новый Массив;
	
	Если ТипЗнч(ПараметрыОтчета.Организация) = Тип("Массив")
		ИЛИ ТипЗнч(ПараметрыОтчета.Организация) = Тип("СписокЗначений") Тогда
		Организации = ПараметрыОтчета.Организация;
	ИначеЕсли ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		Организации.Добавить(ПараметрыОтчета.Организация);
	Иначе
		Выборка = Справочники.Организации.Выбрать();
		Пока Выборка.Следующий() Цикл
			Организации.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Документы.ЦепочкаСозданияСтоимостиКонтролируемойСделки.ВременныеТаблицыДляЗаполненияЦепочекСозданияСтоимостиКонтролируемыхСделок(
		ПараметрыОтчета.НачалоПериода, Организации);
	
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

#КонецОбласти

#КонецЕсли