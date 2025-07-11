#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура ЗаполнитьГоловнуюОрганизацию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Регистратор КАК Регистратор,
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Организация КАК Организация,
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	РегистрНакопления.РасчетыПоНалогамНаЕдиномНалоговомСчете КАК РасчетыПоНалогамНаЕдиномНалоговомСчете
	|ГДЕ
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Регистратор,
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Организация,
	|	РасчетыПоНалогамНаЕдиномНалоговомСчете.Организация.ГоловнаяОрганизация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		НаборЗаписейРегистра = РегистрыНакопления.РасчетыПоНалогамНаЕдиномНалоговомСчете.СоздатьНаборЗаписей();
		ОтборПоРегистратору = НаборЗаписейРегистра.Отбор.Регистратор;
		ОтборПоРегистратору.Установить(Выборка.Регистратор);
		НаборЗаписейРегистра.Прочитать();
		ТаблицаЗаписей = НаборЗаписейРегистра.Выгрузить();
		ТаблицаЗаписей.ЗаполнитьЗначения(Выборка.ГоловнаяОрганизация, "ГоловнаяОрганизация");
		НаборЗаписейРегистра.Загрузить(ТаблицаЗаписей);
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейРегистра);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru = 'Не выполнено обновление записей регистра накопления ""Расчеты по налогам на едином налоговом счете""
			|%1';
			|en = 'The ""AR/AP accounting for taxes on the unified tax account"" accumulation register records were not updated
			|%1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыНакопления.РасчетыПоНалогамНаЕдиномНалоговомСчете,,
				ТекстСообщения);
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли