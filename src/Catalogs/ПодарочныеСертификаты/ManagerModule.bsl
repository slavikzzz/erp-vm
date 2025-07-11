#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//  Массив Из Строка - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	Результат.Добавить("Штрихкод");
	Результат.Добавить("МагнитныйКод");
	
	Возврат Результат;

КонецФункции

// Возвращает параметры механизма взаиморасчетов.
//
// Параметры:
// 	ДанныеЗаполнения - ДокументОбъект, СправочникОбъект, Структура, ДанныеФормыСтруктура - Объект или коллекция для
//              расчета параметров взаиморасчетов.
//
// Возвращаемое значение:
// 	Массив из см. ВзаиморасчетыСервер.ПараметрыМеханизма
//
Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения = Неопределено) Экспорт
	
	МассивПараметров = Новый Массив();
	
	#Область ОсновнаяСтруктура
	
	СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
	
	// Определяет какой регистр двигают параметры, какие общие формы, перечисления и справочники использовать.
	СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;

	СтруктураПараметров.ИзменяетПланОплаты = Истина;
	
	СтруктураПараметров.Номер                            = "";
	СтруктураПараметров.Дата                             = "";
	СтруктураПараметров.Организация                      = "Объект.Владелец.Организация";
	
	СтруктураПараметров.ОбъектРасчетов                   = "Объект.ОбъектРасчетов";
	
	// Валюта и сумма операции. Обязательно путь к реквизитам объекта.
	СтруктураПараметров.ВалютаДокумента                  = "Объект.Владелец.Валюта";
	СтруктураПараметров.СуммаДокумента                   = "Объект.Владелец.Номинал";
	
	СтруктураПараметров.Контрагент                       = "Объект.Контрагент";
	СтруктураПараметров.Партнер                          = "Объект.Партнер";
	СтруктураПараметров.Договор                          = "";
	СтруктураПараметров.ПорядокРасчетов                  = Перечисления.ПорядокРасчетов.ПоНакладным;

	// Используется для заполнения значений по умолчанию, заполнения графика плановых оплат и даты платежа.
	СтруктураПараметров.Соглашение                       = "";
	
	// Используются для определения значения ОплатаВВалюте и в форме редактирования правил оплаты.
	СтруктураПараметров.БанковскийСчетОрганизации        = "";
	СтруктураПараметров.Касса                            = "";
	СтруктураПараметров.ФормаОплаты                      = "";
	СтруктураПараметров.ОплатаВВалюте                    = "";
	СтруктураПараметров.БанковскийСчетКонтрагента        = "";
	
	// Используется в форме правил оплаты и для подбора в расшифровку платежа объектов расчетов.
	СтруктураПараметров.ИдентификаторПлатежа             = "Объект.ИдентификаторПлатежа";
	СтруктураПараметров.НалогообложениеНДС               = "Объект.НалогообложениеНДС";
	
	// Используется при отражении расчетов с клиентами в регламентированном и международном учетах.
	СтруктураПараметров.ГруппаФинансовогоУчета           = "Объект.Владелец.ГруппаФинансовогоУчета";
	
	МассивПараметров.Добавить(СтруктураПараметров);
	
	#КонецОбласти
	
	Возврат МассивПараметров;
	
КонецФункции

// Определяет, является ли подарочный сертификат сертификатом вида 2.5
// 
// Параметры:
//  ПодарочныйСертификат - СправочникОбъект.ПодарочныеСертификаты - Подарочный сертификат
// 
// Возвращаемое значение:
//  Булево - Истина, если подарочный сертификат вида 2.5
Функция УчетПодарочныхСертификатов2_5(ПодарочныйСертификат) Экспорт
	
	УчетПодарочныхСертификатов2_5 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодарочныйСертификат.Владелец, "УчетПодарочныхСертификатов2_5");
	
	Возврат УчетПодарочныхСертификатов2_5;
	
КонецФункции

// Возвращает соответствие подарочных сертификатов к переданным объектам расчетов.
// 
// Параметры:
//  ОбъектыРасчетов - Массив Из СправочникСсылка.ОбъектыРасчетов - Массив объектов расчетов.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ - СправочникСсылка.ОбъектыРасчетов -
//   * Значение - СправочникСсылка.ПодарочныеСертификаты -
//
Функция ПодарочныеСертификатыПоОбъектамРасчетов(ОбъектыРасчетов) Экспорт
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка КАК ПодарочныйСертификат,
	|	ОбъектыРасчетов.Ссылка КАК ОбъектРасчетов
	|ИЗ
	|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ПО ПодарочныеСертификаты.Ссылка = ОбъектыРасчетов.Объект
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|		ПО ПодарочныеСертификаты.Владелец = ВидыПодарочныхСертификатов.Ссылка
	|ГДЕ
	|	ВидыПодарочныхСертификатов.УчетПодарочныхСертификатов2_5 = ИСТИНА
	|	И ОбъектыРасчетов.Ссылка В (&МассивОбъектовРасчетов)";
	Запрос.УстановитьПараметр("МассивОбъектовРасчетов", ОбъектыРасчетов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.ОбъектРасчетов, Выборка.ПодарочныйСертификат);
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции

// Получает выборку данных о подарочных сертификатах по документу для дальнейшей обработки
//
// Параметры:
//  ОтборПоПодарочномуСертификату - СправочникСсылка.ПодарочныеСертификаты, Массив Из СправочникСсылка.ПодарочныеСертификаты -
//  Объект - ДокументОбъект -
//
// Возвращаемое значение:
//	ВыборкаИзРезультатаЗапроса -
Функция ВыборкаДанныхПоПодарочнымСертификатамДляОбработки(ОтборПоПодарочномуСертификату, Объект) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка КАК ПодарочныйСертификат,	
	|	ПодарочныеСертификаты.Владелец.Номинал КАК Номинал,
	|	ПодарочныеСертификаты.Владелец.Валюта  КАК ВалютаНоминала,
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.Активность, ЛОЖЬ) КАК СтатусАктивации,
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.Организация, ВЫБОР
	|			КОГДА ПодарочныеСертификаты.Владелец.УчетПодарочныхСертификатов2_5
	|				ТОГДА ПодарочныеСертификаты.Владелец.Организация
	|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|		КОНЕЦ) КАК Организация,
	|	ПодарочныеСертификаты.Владелец КАК ВидПодарочногоСертификата,
	|	ПодарочныеСертификаты.Владелец.УчетПодарочныхСертификатов2_5 КАК УчетПодарочныхСертификатов2_5,
	|	ПодарочныеСертификаты.Владелец.Номинал
	|	* ВЫБОР
	|		КОГДА &Валюта <> ПодарочныеСертификаты.Владелец.Валюта
	|			ТОГДА ВЫБОР
	|					КОГДА ЕСТЬNULL(КурсыВалютыСертификаты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалютыСертификаты.КурсЧислитель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА 
	|						(КурсыВалютыСертификаты.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
	|						/ (КурсыВалюты.КурсЧислитель * КурсыВалютыСертификаты.КурсЗнаменатель)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Сумма,
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.ДатаНачалаДействия, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаНачалаДействия,
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.ДатаОкончанияДействия, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОкончанияДействия,
	|	ЕСТЬNULL(АктивацияПодарочныхСертификатов.Регистратор, НЕОПРЕДЕЛЕНО) ДокументРеализации
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&ГраницаДатаКонецДня, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыСертификаты
	|ПО 
	|	ПодарочныеСертификаты.Владелец.Валюта = КурсыВалютыСертификаты.Валюта
	|	И ПодарочныеСертификаты.Ссылка В (&Ссылка)
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&ГраницаДатаКонецДня, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|	ПО ИСТИНА
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АктивацияПодарочныхСертификатов КАК АктивацияПодарочныхСертификатов
	|	ПО АктивацияПодарочныхСертификатов.ПодарочныйСертификат = ПодарочныеСертификаты.Ссылка	
	|
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка В (&Ссылка)
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ОтборПоПодарочномуСертификату);
	Запрос.УстановитьПараметр("Валюта", Объект.Валюта);
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		ТекущаяДатаСеанса = Объект.Дата;
	КонецЕсли;
	Запрос.УстановитьПараметр("ГраницаДатаКонецДня",   Новый Граница(КонецДня(ТекущаяДатаСеанса),ВидГраницы.Включая));
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Выборка;
	
КонецФункции

// Заполняет реквизиты подарочного сертификата заранее расчитанными данными;
// Предполагается, что проверка необходимости записи этих данных сделана до вызова метода.
// 
// Параметры:
//  ПодарочныйСертификат - СправочникСсылка.ПодарочныеСертификаты - Подарочный сертификат.
//  ДанныеДляЗаполнения - Соответствие из КлючИЗначение:
//   * Ключ - Строка - имя реквизита справочника подарочные сертификаты
//   * Значение - Строка - имя реквизита документа продажи
//
Процедура ЗаполнитьРеквизитыПодарочногоСертификата(ПодарочныйСертификат, ДанныеДляЗаполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(ПодарочныйСертификат) Или ДанныеДляЗаполнения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СправочникОбъект = ПодарочныйСертификат.ПолучитьОбъект();
	Для Каждого КлючЗначение Из ДанныеДляЗаполнения Цикл
		Если Не СправочникОбъект[КлючЗначение.Ключ] = КлючЗначение.Значение Тогда
			СправочникОбъект[КлючЗначение.Ключ] = КлючЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если СправочникОбъект.Модифицированность() Тогда
		УстановитьПривилегированныйРежим(Истина);
		СправочникОбъект.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт

	КомандаБизнесПроцессыЗадание = БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	НоваяАрхитектураВзаиморасчетов = ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов");
	Если НоваяАрхитектураВзаиморасчетов Тогда		
		КомандаБизнесПроцессыЗадание.Порядок = 99;
		
		РазрешенныеСтатусыДляВозврата = Новый Массив;
		РазрешенныеСтатусыДляВозврата.Добавить(Перечисления.СтатусыПодарочныхСертификатов.Активирован);
		
		// Возврат подарочных сертификатов
		НоваяКоманда = Документы.ЗаявкаНаРасходованиеДенежныхСредств.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;
			
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																РазрешенныеСтатусыДляВозврата,
																ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;
		НоваяКоманда = Документы.РасходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.РасходныйКассовыйОрдер.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;
			
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																РазрешенныеСтатусыДляВозврата,
																ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;
		
		НоваяКоманда = Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.СписаниеБезналичныхДенежныхСредств.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;
			
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																РазрешенныеСтатусыДляВозврата,
																ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;
						
		// Продажа подарочных сертификатов
		НоваяКоманда = Документы.ПриходныйКассовыйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;

			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																Перечисления.СтатусыПодарочныхСертификатов.НеАктивирован,
																ВидСравненияКомпоновкиДанных.Равно);
			
		КонецЕсли;
		
		НоваяКоманда = Документы.ПоступлениеБезналичныхДенежныхСредств.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.ПоступлениеБезналичныхДенежныхСредств.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																Перечисления.СтатусыПодарочныхСертификатов.НеАктивирован,
																ВидСравненияКомпоновкиДанных.Равно);
			
		КонецЕсли;
		
		
		// Продажа/Возврат подарочных сертификатов в зависимости от хозяйственной операции.
		НоваяКоманда = Документы.ОперацияПоПлатежнойКарте.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если НоваяКоманда <> Неопределено Тогда
			НоваяКоманда.Обработчик = "ПодарочныеСертификатыКлиент.ВыбратьКонтрагентаДляВводаДокументаОплатыНаОснованииПодарочногоСертификата";
			НоваяКоманда.ИмяФормы = "Документ.ОперацияПоПлатежнойКарте.Форма.ФормаДокумента";
			НоваяКоманда.ВидимостьВФормах =
				"ФормаСписка,ФормаЭлемента";
			НоваяКоманда.МножественныйВыбор = Ложь;
			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"УчетПодарочныхСертификатов2_5",
																Истина,
																ВидСравненияКомпоновкиДанных.Равно);
			РазрешенныеСтатусыПСДляЭквайринга = Новый Массив;
			РазрешенныеСтатусыПСДляЭквайринга.Добавить(Перечисления.СтатусыПодарочныхСертификатов.НеАктивирован);
			РазрешенныеСтатусыПСДляЭквайринга.Добавить(Перечисления.СтатусыПодарочныхСертификатов.Активирован);

			ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НоваяКоманда,
																"Статус",
																РазрешенныеСтатусыПСДляЭквайринга,
																ВидСравненияКомпоновкиДанных.ВСписке);
			
		КонецЕсли;

	КонецЕсли;
		
КонецПроцедуры

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты")
		И (ПравоДоступа("Использование", Метаданные.Обработки.ПечатьПодарочныхСертификатов)
			ИЛИ Пользователи.ЭтоПолноправныйПользователь()) Тогда
		// Подарочный сертификат
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьПодарочныхСертификатов";
		КомандаПечати.Идентификатор = "ПодарочныйСертификат";
		КомандаПечати.Представление = НСтр("ru = 'Подарочный сертификат';
											|en = 'Gift card'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КонецЕсли;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Функция получает данные для формирования печатной формы Подарочный сертификат.
//
// Параметры:
//  ПараметрыПечати - Структура - Параметры печати.
//  МассивОбъектов - Массив - Массив подарочных сертификатов.
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * РезультатЗапроса - РезультатЗапроса - Результат запроса.
//   * ЗаголовокДокумента - Строка - Заголовок документа.
//
Функция ПолучитьДанныеДляПечатнойФормыПодарочныйСертификат(ПараметрыПечати, МассивОбъектов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка        КАК Ссылка,
	|	ПодарочныеСертификаты.Код           КАК СерийныйНомер,
	|	ПодарочныеСертификаты.Штрихкод      КАК Штрихкод,
	|	ПодарочныеСертификаты.МагнитныйКод  КАК МагнитныйКод,
	|	ПодарочныеСертификаты.Владелец.Номинал  КАК Номинал,
	|	ПодарочныеСертификаты.Владелец.Валюта   КАК Валюта
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка В (&МассивДокументов)
	|");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДанныхДляПечати    = Новый Структура("РезультатЗапроса, ЗаголовокДокумента",
	                                               РезультатЗапроса, НСтр("ru = 'Подарочный сертификат';
																			|en = 'Gift card'"));
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = ВзаиморасчетыСервер.КарточкаРасчетовСКлиентом_ДобавитьКомандуОтчетаПоДокументам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "ФормаЭлемента,ФормаСписка";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
