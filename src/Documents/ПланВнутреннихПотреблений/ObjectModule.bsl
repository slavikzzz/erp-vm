#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по правилу заполнения из различных источников.
//
Процедура ЗаполнитьПоПравилуЗаполнения() Экспорт
	
	Параметры = Новый Структура("Ссылка, Сценарий, КроссТаблица, ИзменитьРезультатНа, 
		|ЗаполненоАвтоматически, ТочностьОкругления, Подразделение, Склад, Статус, 
		|Периодичность, НачалоПериода, ОкончаниеПериода, РаспределитьПоРабочимДням");
	
	ЗаполнитьЗначенияСвойств(Параметры, ЭтотОбъект);
	
	Параметры.Вставить("ЗаполнятьПоПравилу", Истина);
	Параметры.Вставить("ПравилоЗаполнения", ПравилоЗаполнения.Выгрузить());
	Параметры.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки.Получить());
	
	ЗаполняемаяТЧ = Товары.Выгрузить();
	Если ОбновитьДополнить = 0 Тогда
		ЗаполняемаяТЧ.Очистить();
	КонецЕсли;
	
	Параметры.Вставить("ЗаполняемаяТЧ", ЗаполняемаяТЧ);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ПланВнутреннихПотреблений.ЗаполнитьПоПравилуЗаполнения(Параметры, АдресХранилища);
	
	ЗаполняемаяТЧ = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Товары.Загрузить(ЗаполняемаяТЧ);
	
	ЗаполненоАвтоматически = Истина;
	
КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Пропускаем обработку, чтобы гарантировать получение формы объекта при передаче параметра "АвтоТест".
	Если ДанныеЗаполнения = "АвтоТест" Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	Иначе
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
		ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
		НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	КонецЕсли;

	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ",                    "Товары");
	ПараметрыПроверки.Вставить("ПредставлениеТЧ",          НСтр("ru = 'Товары';
																|en = 'Goods'"));
	ПараметрыПроверки.Вставить("Периодичность",            Периодичность);
	ПараметрыПроверки.Вставить("ДатаНачала",               НачалоПериода);
	ПараметрыПроверки.Вставить("ДатаОкончания",            ОкончаниеПериода);
	ПараметрыПроверки.Вставить("ИмяПоляДатыПериода",       "ДатаОтгрузки");
	ПараметрыПроверки.Вставить("ПредставлениеДатыПериода", НСтр("ru = 'Дата отгрузки';
																|en = 'Shipment date'"));
	
	Если Не КроссТаблица Тогда
		ПланированиеКлиентСервер.ПроверитьДатуПериодаТЧ(ЭтотОбъект, Отказ, ПараметрыПроверки);
	КонецЕсли;
	
	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли;

	Планирование.ОбработкаПроверкиЗаполненияПоСценариюВидуПлана(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	Если Не ОтражаетсяВБюджетировании Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетов");
		МассивНепроверяемыхРеквизитов.Добавить("СценарийБюджетирования");
	КонецЕсли;
	
	Если Не КроссТаблица
		И ЗначениеЗаполнено(ВидПлана) Тогда
		
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСклад");
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Склад,
		|	ТаблицаТовары.Назначение,
		|	ТаблицаТовары.ДатаОтгрузки,
		|	ТаблицаТовары.Количество
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	СУММА(Товары.Количество) КАК Количество
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И (Не &ЗаполнятьСклад ИЛИ Товары.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	Товары.ДатаОтгрузки,
		|	Товары.Характеристика
		|
		|ИМЕЮЩИЕ
		|	СУММА(Товары.Количество) = 0";
		Запрос.УстановитьПараметр("ТаблицаТовары", Товары.Выгрузить());
		Запрос.УстановитьПараметр("ЗаполнятьСклад", РеквизитыВидПлана.ЗаполнятьСклад);
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСклад, ЗаполнятьСкладВТЧ");
		
		ТаблицаОшибок = Запрос.Выполнить().Выгрузить();
		
		КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Назначение,Склад");
		
		Для Каждого СтрокаОшибки Из ТаблицаОшибок Цикл
			
			ТекстСообщения = НСтр("ru = 'Для строк плана с номенклатурой %Номенклатура%%Характеристика%
				|%Назначение%%Склад% не запланировано количество ни в одном периоде планирования.';
				|en = 'Quantity is not planned in any planning period for lines of plan with the %Номенклатура%%Характеристика%
				|%Назначение%%Склад% items.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", СтрокаОшибки.Номенклатура);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Характеристика%",
				?(ЗначениеЗаполнено(СтрокаОшибки.Характеристика),
				НСтр("ru = ', характеристикой';
					|en = ', variants'") + " "
				+ СтрокаОшибки.Характеристика, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Назначение%", ?(ЗначениеЗаполнено(СтрокаОшибки.Назначение)
				И РеквизитыВидПлана.ЗаполнятьНазначениеВТЧ,
				НСтр("ru = ', назначением';
					|en = ', assignment'") + " " + СтрокаОшибки.Назначение, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", ?(ЗначениеЗаполнено(СтрокаОшибки.Склад)
				И РеквизитыВидПлана.ЗаполнятьСкладВТЧ , НСтр("ru = ', складом';
															|en = ', warehouse'") + " " + СтрокаОшибки.Склад, ""));
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОшибки);
			СтрокаПоиска = Товары.НайтиСтроки(СтруктураПоиска)[0];
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары",СтрокаПоиска.НомерСтроки,
																	"КоличествоУпаковок");
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,КлючДанных, Поле,"Объект",Отказ);
			
		КонецЦикла;
		
		ПоляГруппировки = "Номенклатура, Характеристика, Назначение, Упаковка, Склад, ДатаОтгрузки";
		Планирование.ОбработкаПроверкиДублированияСтрок(Товары, "Товары", ПоляГруппировки, Отказ);
		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Запись 
		И Не ДополнительныеСвойства.Свойство("ПропуститьПроверкуЗапретаИзменения") Тогда
		
		ДанныеДляПроверки = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
		НоваяСтрока = ДанныеДляПроверки.Добавить();
		НоваяСтрока.Дата   = НачалоПериода;
		НоваяСтрока.Раздел = "Планирование";
		НоваяСтрока.Объект = Сценарий;
		
		Если ЗначениеЗаполнено(СценарийБюджетирования) Тогда
			НоваяСтрока = ДанныеДляПроверки.Добавить();
			НоваяСтрока.Дата   = НачалоПериода;
			НоваяСтрока.Раздел = "Бюджетирование";
			НоваяСтрока.Объект = СценарийБюджетирования;
		КонецЕсли;
		
		ОписаниеДанных = Новый Структура;
		ОписаниеДанных.Вставить("НоваяВерсия", Истина);
		ОписаниеДанных.Вставить("Данные",      Ссылка);
		
		ОписаниеОшибки = "";
		Если ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ДанныеДляПроверки, ОписаниеДанных, ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				ОписаниеОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
			
	КонецЕсли;
	
	//++ НЕ УТКА
	Планирование.ПроверитьНаличиеБюджетнойЗадачи(Отказ, Ссылка, ЭтотОбъект);
	//-- НЕ УТКА
	
	// Заполнить даты отгрузки
	Если Не КроссТаблица Тогда
		Для Каждого Строка Из Товары Цикл
			Если Не ЗначениеЗаполнено(Строка.ДатаОтгрузки) Тогда
				Строка.ДатаОтгрузки = НачалоПериода;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Замещающий Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗамещениеПланов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидПлана", ВидПлана);
		Блокировка.Заблокировать();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Планирование.ПроверитьСтатусУтвержден(ЭтотОбъект, Отказ, РежимЗаписи, 
		Перечисления.ТипыПланов.ПланВнутреннихПотреблений);
	
	Для каждого СтрокаТЧ Из Товары Цикл
		
		Если ЗначениеЗаполнено(Склад) Тогда
			СтрокаТЧ.Склад = Склад;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СтатьяБюджетов = Неопределено;
		СценарийБюджетирования = Неопределено;
	КонецЕсли;
	
	Если Замещающий 
		И Не ЭтоНовый()
		И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещениеПлана(РежимЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если Не Замещающий
		И Не ЭтоНовый()
		И Не Отказ
		И Планирование.ЕстьЗамещениеПлана(Ссылка) Тогда
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещениеПлана(РежимЗаписи, ОбновлениеИБ = Ложь) Экспорт
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или (РежимЗаписи = РежимЗаписиДокумента.Запись И Не Проведен) Тогда
		
		Для Каждого Строка Из Товары Цикл
			Строка.Замещен = Ложь;
			Строка.ЗамещенКЗаказу = Ложь;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
		
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(
			ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланВнутреннихПотребленийЗамещающий.Ссылка,
	|	ПланВнутреннихПотребленийЗамещающий.ВидПлана,
	|	ВЫБОР
	|		КОГДА &НачалоПериода > ПланВнутреннихПотребленийЗамещающий.НачалоПериода
	|			ТОГДА &НачалоПериода
	|		ИНАЧЕ ПланВнутреннихПотребленийЗамещающий.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА &ОкончаниеПериода < ПланВнутреннихПотребленийЗамещающий.ОкончаниеПериода
	|			ТОГДА &ОкончаниеПериода
	|		ИНАЧЕ ПланВнутреннихПотребленийЗамещающий.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода,
	|	ПланВнутреннихПотребленийЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден)
	|		И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден) КАК ЗамещенКЗаказу,
	|	ПланВнутреннихПотребленийЗамещающий.Статус.Порядок >= &СтатусИндекс
	|		ИЛИ ПланВнутреннихПотребленийЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|			И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден) КАК Замещен,
	|	ПланВнутреннихПотребленийЗамещающий.Статус КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещаемыеПланы
	|ИЗ
	|	Документ.ПланВнутреннихПотреблений КАК ПланВнутреннихПотребленийЗамещающий
	|ГДЕ
	|	ПланВнутреннихПотребленийЗамещающий.ОкончаниеПериода >= &НачалоПериода
	|	И ПланВнутреннихПотребленийЗамещающий.НачалоПериода <= &ОкончаниеПериода
	|	И ПланВнутреннихПотребленийЗамещающий.Ссылка <> &Ссылка
	|	И ПланВнутреннихПотребленийЗамещающий.Проведен
	|	И ПланВнутреннихПотребленийЗамещающий.ВидПлана = &ВидПлана
	|	И &Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|	И (ПланВнутреннихПотребленийЗамещающий.Статус.Порядок >= &СтатусИндекс
	|			ИЛИ ПланВнутреннихПотребленийЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|				И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден))
	|	И ПланВнутреннихПотребленийЗамещающий.Дата > &Дата
	|	И ПланВнутреннихПотребленийЗамещающий.Подразделение = &Подразделение
	|	И ПланВнутреннихПотребленийЗамещающий.Склад = &Склад
	|	И ПланВнутреннихПотребленийЗамещающий.Назначение = &Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана КАК ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЛОЖЬ КАК КЗамещению,
	|	ЛОЖЬ КАК КОтменеЗамещения,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещающийПлан,
	|	&Ссылка КАК ЗамещенныйПлан,
	|	ЗамещаемыеПланы.ЗамещенКЗаказу КАК ЗамещенКЗаказу,
	|	ЗамещаемыеПланы.Замещен КАК Замещен,
	|	ЗамещаемыеПланы.СтатусЗамещения КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещаемыеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланВнутреннихПотребленийТовары.ДатаОтгрузки,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланВнутреннихПотребленийТовары.ДатаОтгрузки, ГОД)
	|		ИНАЧЕ ПланВнутреннихПотребленийТовары.ДатаОтгрузки
	|	КОНЕЦ КАК Период
	|ПОМЕСТИТЬ ПланВнутреннихПотребленийТовары
	|ИЗ
	|	&ПланВнутреннихПотребленийТовары КАК ПланВнутреннихПотребленийТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланВнутреннихПотребленийТовары.ДатаОтгрузки,
	|	МАКСИМУМ(ЗамещениеПланов.ЗамещенКЗаказу) КАК ЗамещенКЗаказу,
	|	МАКСИМУМ(ЗамещениеПланов.Замещен) КАК Замещен
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВнутреннихПотребленийТовары КАК ПланВнутреннихПотребленийТовары
	|		ПО ЗамещениеПланов.ЗамещенныйПериод = ПланВнутреннихПотребленийТовары.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланВнутреннихПотребленийТовары.ДатаОтгрузки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения КАК КОтменеЗамещения,
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.СтатусЗамещения КАК СтатусЗамещения
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	Запрос.УстановитьПараметр("СтатусИндекс", Перечисления.СтатусыПланов.Индекс(Статус));
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	Запрос.УстановитьПараметр("ПланВнутреннихПотребленийТовары", Товары.Выгрузить());
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[4].Выбрать();
	ТаблицаЗамещениеПлана = ЗапросПакет[5].Выгрузить();
	
	Для Каждого Строка Из Товары Цикл
		Строка.Замещен = Ложь;
		Строка.ЗамещенКЗаказу = Ложь;
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура("ДатаОтгрузки", Выборка.ДатаОтгрузки);
		ЗамещаемыеСтроки = Товары.НайтиСтроки(Отбор);
		Для Каждого Строка Из ЗамещаемыеСтроки Цикл
			Строка.Замещен = Выборка.Замещен;
			Строка.ЗамещенКЗаказу = Выборка.ЗамещенКЗаказу;
		КонецЦикла;
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
	НаборЗаписей.Загрузить(ТаблицаЗамещениеПлана);
	
	Если ОбновлениеИБ Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ", Неопределено);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И (Замещающий ИЛИ Планирование.ЕстьЗамещениеПлана(Ссылка)) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещенныеПланы();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещенныеПланы()
	
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(
			ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланВнутреннихПотребленийЗамещенный.Ссылка,
	|	ПланВнутреннихПотребленийЗамещенный.ВидПлана,
	|	ВЫБОР
	|		КОГДА ПланВнутреннихПотреблений.НачалоПериода > ПланВнутреннихПотребленийЗамещенный.НачалоПериода
	|			ТОГДА ПланВнутреннихПотреблений.НачалоПериода
	|		ИНАЧЕ ПланВнутреннихПотребленийЗамещенный.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА ПланВнутреннихПотреблений.ОкончаниеПериода < ПланВнутреннихПотребленийЗамещенный.ОкончаниеПериода
	|			ТОГДА ПланВнутреннихПотреблений.ОкончаниеПериода
	|		ИНАЧЕ ПланВнутреннихПотребленийЗамещенный.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода,
	|	ПланВнутреннихПотреблений.Статус КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещенныеПланы
	|ИЗ
	|	Документ.ПланВнутреннихПотреблений КАК ПланВнутреннихПотреблений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПланВнутреннихПотреблений КАК ПланВнутреннихПотребленийЗамещенный
	|		ПО ПланВнутреннихПотреблений.ВидПлана = ПланВнутреннихПотребленийЗамещенный.ВидПлана
	|			И (ПланВнутреннихПотреблений.Статус.Порядок >= ПланВнутреннихПотребленийЗамещенный.Статус.Порядок
	|				ИЛИ ПланВнутреннихПотреблений.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|					И ПланВнутреннихПотребленийЗамещенный.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден))
	|			И ПланВнутреннихПотребленийЗамещенный.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|			И ПланВнутреннихПотреблений.Дата > ПланВнутреннихПотребленийЗамещенный.Дата
	|			И ПланВнутреннихПотреблений.Подразделение = ПланВнутреннихПотребленийЗамещенный.Подразделение
	|			И ПланВнутреннихПотреблений.Склад = ПланВнутреннихПотребленийЗамещенный.Склад
	|			И ПланВнутреннихПотреблений.Назначение = ПланВнутреннихПотребленийЗамещенный.Назначение
	|			И ПланВнутреннихПотребленийЗамещенный.Проведен
	|			И ПланВнутреннихПотребленийЗамещенный.Замещающий
	|ГДЕ
	|	ПланВнутреннихПотребленийЗамещенный.ОкончаниеПериода >= ПланВнутреннихПотреблений.НачалоПериода
	|	И ПланВнутреннихПотребленийЗамещенный.НачалоПериода <= ПланВнутреннихПотреблений.ОкончаниеПериода
	|	И ПланВнутреннихПотреблений.Ссылка = &Ссылка
	|	И ПланВнутреннихПотреблений.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещенныйПлан,
	|	&Ссылка КАК ЗамещающийПлан,
	|	ЗамещаемыеПланы.СтатусЗамещения КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещенныеПланыПоПериодам
	|ИЗ
	|	ЗамещенныеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.СтатусЗамещения ЕСТЬ NULL
	|			ТОГДА ЗамещениеПланов.СтатусЗамещения
	|		ИНАЧЕ ЗамещенныеПланыПоПериодам.СтатусЗамещения
	|	КОНЕЦ КАК СтатусЗамещения,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.ЗамещенныйПериод ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КОтменеЗамещения
	|ПОМЕСТИТЬ ЗамещениеПлановСуммаДвижений
	|ИЗ
	|	РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ПО ЗамещениеПланов.ВидПлана = ЗамещенныеПланыПоПериодам.ВидПлана
	|			И ЗамещениеПланов.ЗамещенныйПериод = ЗамещенныеПланыПоПериодам.ЗамещенныйПериод
	|			И ЗамещениеПланов.ЗамещающийПлан = ЗамещенныеПланыПоПериодам.ЗамещающийПлан
	|			И ЗамещениеПланов.ЗамещенныйПлан = ЗамещенныеПланыПоПериодам.ЗамещенныйПлан
	|			И ЗамещениеПланов.СтатусЗамещения = ЗамещенныеПланыПоПериодам.СтатусЗамещения
	|ГДЕ
	|	&Ссылка = ЗамещениеПланов.ЗамещающийПлан
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗамещенныеПланыПоПериодам.ЗамещающийПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПериод,
	|	ЗамещенныеПланыПоПериодам.ВидПлана,
	|	ЗамещенныеПланыПоПериодам.СтатусЗамещения,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещенныеПланыПоПериодам.ВидПлана = ЗамещениеПланов.ВидПлана
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещенныеПланыПоПериодам.ЗамещающийПлан = ЗамещениеПланов.ЗамещающийПлан
	|			И ЗамещенныеПланыПоПериодам.СтатусЗамещения = ЗамещениеПланов.СтатусЗамещения
	|ГДЕ
	|	ЗамещениеПланов.ЗамещенныйПериод ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов1.КЗамещению, ЗамещениеПлановСуммаДвижений.КЗамещению)) КАК КЗамещению,
	|	МИНИМУМ(ЗамещениеПлановСуммаДвижений.КОтменеЗамещения) КАК КОтменеЗамещения,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов.КОтменеЗамещения, ИСТИНА)) КАК ВыполнитьОтменуЗамещению,
	|	ЗамещениеПлановСуммаДвижений.СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещениеПлановСуммаДвижений КАК ЗамещениеПлановСуммаДвижений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов.КОтменеЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов.ЗамещающийПлан)
	|			И (ЗамещениеПлановСуммаДвижений.СтатусЗамещения = ЗамещениеПланов.СтатусЗамещения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов1
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов1.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов1.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов1.КЗамещению)
	|			И (ЗамещениеПлановСуммаДвижений.СтатусЗамещения = ЗамещениеПланов1.СтатусЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов1.ЗамещающийПлан)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.СтатусЗамещения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана,
	|	ЗамещениеПланов.КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения,
	|	ЗамещениеПланов.ВыполнитьОтменуЗамещению,
	|	ЗамещениеПланов.СтатусЗамещения
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|ИТОГИ ПО
	|	ЗамещенныйПлан";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	ЗапросПакет = Запрос.ВыполнитьПакет(); 
	ВыборкаЗамещенныйПлан = ЗапросПакет[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбновитьЗамещениеПлана = Ложь;
	
	Пока ВыборкаЗамещенныйПлан.Следующий() Цикл
		
		НаборЗаписейОчереди = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписейОчереди.Отбор.ЗамещающийПлан.Установить(Ссылка);
		НаборЗаписейОчереди.Отбор.ЗамещенныйПлан.Установить(ВыборкаЗамещенныйПлан.ЗамещенныйПлан);
		
		Выборка = ВыборкаЗамещенныйПлан.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			Если (Выборка.КЗамещению И Выборка.КОтменеЗамещения)Тогда
				ОбновитьЗамещениеПлана = Истина;
			ИначеЕсли Выборка.КОтменеЗамещения И НЕ Выборка.ВыполнитьОтменуЗамещению Тогда
				Продолжить;
			ИначеЕсли Выборка.КЗамещению Или Выборка.КОтменеЗамещения Тогда
				ОбновитьЗамещениеПлана = Истина;
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			ИначеЕсли Проведен Тогда
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписейОчереди.Записать();
		
	КонецЦикла;
	
	Если ОбновитьЗамещениеПлана Тогда
		Планирование.ЗапускВыполненияФоновогоПроведенияПлана();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	Для каждого СтрокаТовары Из Товары Цикл

		СтрокаТовары.Отменено = Ложь;

	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДанныеЗаполнения.Свойство("Сценарий", Сценарий);
		ДанныеЗаполнения.Свойство("ВидПлана", ВидПлана);
		ДанныеЗаполнения.Свойство("НачалоПериода", НачалоПериода);
		ДанныеЗаполнения.Свойство("ОкончаниеПериода", ОкончаниеПериода);
	Иначе
		ЗаполнитьДанныеПоУмолчанию();
	КонецЕсли;
	
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	
КонецПроцедуры

// Процедура заполняет подразделение, сценарий, вид плана и признак кросс-таблицы в документе, значением по умолчанию.
//
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Подразделение
	|	КОНЕЦ КАК Подразделение,
	|	ВЫБОР
	|		КОГДА СценарииТоварногоПланирования.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СценарииТоварногоПланирования.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Сценарий
	|	КОНЕЦ КАК Сценарий,
	|	ВЫБОР
	|		КОГДА ВидыПланов.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.ВидПлана
	|	КОНЕЦ КАК ВидПлана,
	|	ДанныеДокумента.ЗаполнятьПоФормуле КАК ЗаполнятьПоФормуле,
	|	ДанныеДокумента.КроссТаблица КАК КроссТаблица
	|ИЗ
	|	Документ.ПланВнутреннихПотреблений КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
	|		ПО ДанныеДокумента.ВидПлана = ВидыПланов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СценарииТоварногоПланирования КАК СценарииТоварногоПланирования
	|		ПО ДанныеДокумента.Сценарий = СценарииТоварногоПланирования.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО ДанныеДокумента.Подразделение = СтруктураПредприятия.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Сценарий = ЗначениеНастроекПовтИсп.ПолучитьСценарийПоУмолчанию(
		Перечисления.ТипыПланов.ПланВнутреннихПотреблений, Сценарий);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПланаПоСценариюВидуПлана()
	
	РеквизитыСценария = "Периодичность";
	//++ НЕ УТ
	РеквизитыСценария = РеквизитыСценария + ", СценарийБюджетирования";
	//-- НЕ УТ
	ПараметрыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, РеквизитыСценария);
	Если НЕ ЗначениеЗаполнено(ВидПлана) Тогда
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(Перечисления.ТипыПланов.ПланВнутреннихПотреблений, Сценарий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСценария);
	
	Если ЗначениеЗаполнено(ВидПлана) Тогда
		Реквизиты = "ЗаполнятьПланОплат,ЗаполнятьПоФормуле,Замещающий";
		//++ НЕ УТ
		Реквизиты = Реквизиты + ", ОтражаетсяВБюджетировании, СтатьяБюджетов";
		//-- НЕ УТ
		
		ПараметрыВидаПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, Реквизиты);
		
		СтруктураНастроекВидПлана = Планирование.ПолучитьНастройкиПоУмолчанию(Перечисления.ТипыПланов.ПланВнутреннихПотреблений, ВидПлана);
		Если СтруктураНастроекВидПлана.Свойство("Формула") Тогда
			ПараметрыВидаПлана.Вставить("СтруктураНастроек", СтруктураНастроекВидПлана);
		КонецЕсли;
		Для каждого Элемент Из СтруктураНастроекВидПлана Цикл
			ПараметрыВидаПлана.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыВидаПлана);
		ЭтотОбъект.СтруктураНастроек  = Новый ХранилищеЗначения(СтруктураНастроекВидПлана);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
