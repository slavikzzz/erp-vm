#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийТоварыКОформлениюОтчетовКомитенту"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	&ИмяРегистра КАК ИмяРегистра,
	|	&Раздел КАК РазделДатыЗапрета
	|ИЗ
	|	&ИмяТаблицыИзменений КАК Таблица
	|";
	
	ИмяПараметраИмяРегистра = "ИмяРегистра" + ИмяРегистра;
	ИмяПараметраРаздел = "Раздел" + ИмяРегистра;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяРегистра", "&" + ИмяПараметраИмяРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Раздел", "&" + ИмяПараметраРаздел);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяТаблицыИзменений", ИмяТаблицыИзменений);
	
	Запрос.УстановитьПараметр(ИмяПараметраИмяРегистра, ИмяРегистра);
	Запрос.УстановитьПараметр(ИмяПараметраРаздел, "ФинансовыйКонтур");
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВидЗапасов.Организация)
	|	И ЗначениеРазрешено(ВидЗапасов.ВладелецТовара)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

//++ НЕ УТ

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрНакопления - Метаданные регистра накопления
//  РегистрацияКОтражению - Булево - Признак получения параметров для регистрации к отражению в учете
//
// Возвращаемое значение:
// 	см. ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеРегистра = Неопределено, РегистрацияКОтражению = Ложь) Экспорт
	
	ПараметрыОтражения = ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете(РегистрацияКОтражению);
	
	Если РегистрацияКОтражению Тогда
		Возврат ПараметрыОтражения;
	КонецЕсли;
	
	ПараметрыОтражения.ИнверсияДвижений = Истина;
	ПараметрыОтражения.ПутьКДаннымПодразделение = "АналитикаУчетаНоменклатуры.Подразделение";
	ПараметрыОтражения.ПутьКДаннымВалюта = "Валюта";
	ПараметрыОтражения.РесурсыУпр.Добавить("0");
	ПараметрыОтражения.РесурсыУпр.Добавить("СуммаВыручкиУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("0");
	ПараметрыОтражения.РесурсыРегл.Добавить("СуммаВыручкиРегл");
	ПараметрыОтражения.РесурсыВал.Добавить("СуммаВыручки");
	ПараметрыОтражения.РесурсыКоличество.Добавить("Количество");
	ПараметрыОтражения.ТипДанныхУчета = Перечисления.ТипыДанныхУчета.Номенклатура;
	ПараметрыОтражения.ПутьКДаннымДопНастройкаХозОперации = СтрЗаменить(
		"ВЫБОР
		|		КОГДА ПсевдонимИсточникаДанных.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту)
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.РеализацияКомиссионногоТовара)
		|		КОГДА ПсевдонимИсточникаДанных.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиента)
		|			ТОГДА ВЫБОР
		|				КОГДА ПсевдонимИсточникаДанных.ДокументРеализации ССЫЛКА Документ.РеализацияТоваровУслуг
		|					ТОГДА ВЫБОР
		|						КОГДА НАЧАЛОПЕРИОДА(ВЫРАЗИТЬ(ПсевдонимИсточникаДанных.ДокументРеализации КАК Документ.РеализацияТоваровУслуг).Дата, МЕСЯЦ) < НАЧАЛОПЕРИОДА(ПсевдонимИсточникаДанных.Период, МЕСЯЦ)
		|							ТОГДА ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровОтКлиентаПрошлыхПериодов)
		|						ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноРеализации)
		|					КОНЕЦ
		|				КОГДА ПсевдонимИсточникаДанных.ДокументРеализации ССЫЛКА Документ.ОтчетОРозничныхПродажах
		|					ТОГДА ВЫБОР
		|						КОГДА НАЧАЛОПЕРИОДА(ВЫРАЗИТЬ(ПсевдонимИсточникаДанных.ДокументРеализации КАК Документ.ОтчетОРозничныхПродажах).Дата, МЕСЯЦ) < НАЧАЛОПЕРИОДА(ПсевдонимИсточникаДанных.Период, МЕСЯЦ)
		|							ТОГДА ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровОтКлиентаПрошлыхПериодов)
		|						ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноРеализации)
		|					КОНЕЦ
		|				ИНАЧЕ ПсевдонимИсточникаДанных.НастройкаХозяйственнойОперации
		|			КОНЕЦ
		|		ИНАЧЕ ПсевдонимИсточникаДанных.НастройкаХозяйственнойОперации
		|	КОНЕЦ",
		"ПсевдонимИсточникаДанных",
		ПараметрыОтражения.ПсевдонимИсточникаДанных);
	
	Если МетаданныеРегистра = Неопределено Тогда
		МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	КонецЕсли;
	
	ФинансовыйУчетПоДаннымБалансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	//++ НЕ УТКА
	МеждународныйУчетПоДаннымФинансовыхРегистров.ИспользоватьНомерСтрокиКакИдентификаторСтроки(ПараметрыОтражения);
	//-- НЕ УТКА
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.15.11";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1d99b925-d170-44ae-1050-190d1f787828");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет новое измерение ""Организация"" регистра ""Товары к оформлению отчетов комитенту"".';
									|en = 'Fills the new ""Company"" dimension of the ""Goods to be registered in reports to consignor"" register.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыКОформлениюОтчетовКомитенту.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту КАК ТоварыКОформлениюОтчетовКомитенту
	|ГДЕ
	|	ТоварыКОформлениюОтчетовКомитенту.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|";
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущиеДанные Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ТекущиеДанные.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущиеДанные.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для каждого Запись Из НаборЗаписей Цикл
				Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
					ОрганизацияВидаЗапасов = Неопределено;
					Если ЗначениеЗаполнено(Запись.ВидЗапасов) Тогда
						ОрганизацияВидаЗапасов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ВидЗапасов, "Организация");
					КонецЕсли;
					Если ЗначениеЗаполнено(ОрганизацияВидаЗапасов) Тогда
						Запись.Организация = ОрганизацияВидаЗапасов;
					Иначе
						ОрганизацияДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Регистратор, "Организация");
						Запись.Организация = ОрганизацияДокумента;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ТекущиеДанные.Регистратор);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли