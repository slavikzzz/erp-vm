#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Проверяет есть ли для качественного товара соответствие с некачественным товаром.
//
// Параметры:
//   Номенклатура - СправочникСсылка.Номенклатура - качественная номенклатура;
//   НекачественныйТовар - СправочникСсылка.Номенклатура - некачественная номенклатура.
//
// Возвращаемое значение:
//   Булево - возвращает истину если соответстиве найдено.
//
Функция ПроверитьНаличиеГрадации(Номенклатура, НекачественныйТовар) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыДругогоКачества.НоменклатураБрак КАК НекачественныйТовар
	|ИЗ
	|	РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
	|ГДЕ
	|	ТоварыДругогоКачества.Номенклатура = &Номенклатура
	|			И ТоварыДругогоКачества.НоменклатураБрак = &НоменклатураБрак
	|			И ТоварыДругогоКачества.ГрадацияКачества = &ГрадацияКачества";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("НоменклатураБрак", НекачественныйТовар);
	Запрос.УстановитьПараметр("ГрадацияКачества", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "Качество"));
	Результат = Запрос.Выполнить();
	ЕстьСоответствие = Не Результат.Пустой();
	Возврат ЕстьСоответствие;
КонецФункции

// Записывает в регистр сведений ТоварыДругогоКачества связь между качественной и некачественной номенклатурой.
//
// Параметры:
//   КачественныйТовар - СправочникСсылка.Номенклатура - качественная номенклатура;
//   НекачественныйТовар - СправочникСсылка.Номенклатура - некачественная номенклатура.
//
Процедура ЗаписатьСвязьСТоваромДругогоКачества(КачественныйТовар, НекачественныйТовар) Экспорт
	
	ТекстСообщения = "";
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "Качество") = Перечисления.ГрадацииКачества.Новый Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно установить соответствие. Некачественный товар не может иметь качество ""Новый""';
								|en = 'Cannot set correspondence. Low-quality goods cannot have the ""New"" quality'");
	ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "ТипНоменклатуры") = Перечисления.ТипыНоменклатуры.Услуга Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно установить соответствие. Некачественный товар не может иметь тип номенклатуры ""Услуга""';
								|en = 'Cannot set correspondence. Low-quality goods cannot have item type ""Service""'");
	ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "ТипНоменклатуры") = Перечисления.ТипыНоменклатуры.Работа Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно установить соответствие. Некачественный товар не может иметь тип номенклатуры ""Работа""';
								|en = 'Cannot set correspondence. Low-quality goods cannot have item type ""Work""'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат
	КонецЕсли;
		
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КачественныйТовар, "Качество") <> Перечисления.ГрадацииКачества.Новый Тогда
		ЗапросПоСоответствиюНоменклатуры = Новый Запрос;
		ЗапросПоСоответствиюНоменклатуры.УстановитьПараметр("НоменклатураБрак", КачественныйТовар);
		ЗапросПоСоответствиюНоменклатуры.Текст = 
		"ВЫБРАТЬ
		|	ТоварыДругогоКачества.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
		|ГДЕ
		|	ТоварыДругогоКачества.НоменклатураБрак = &НоменклатураБрак";
		Результат = ЗапросПоСоответствиюНоменклатуры.Выполнить();
		Если Результат.Пустой() Тогда
			ШаблонТекстаСообщенияОбОшибке = НСтр("ru = 'Невозможно найти качественный товар соответствующий товару %НекачественныйТовар%';
												|en = 'Cannot find high-quality goods which correspond to goods %НекачественныйТовар%'");
			ТекстСообщения = СтрЗаменить(ШаблонТекстаСообщенияОбОшибке, "%НекачественныйТовар%", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "Наименование"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			КачественныйТовар = Выборка.Номенклатура;
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьРегистраСведений = РегистрыСведений.ТоварыДругогоКачества.СоздатьМенеджерЗаписи();
	ЗаписьРегистраСведений.Номенклатура 	= КачественныйТовар;
	ЗаписьРегистраСведений.НоменклатураБрак = НекачественныйТовар;
	ЗаписьРегистраСведений.ГрадацияКачества = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "Качество");
	ЗаписьРегистраСведений.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СпрНоменклатура.ЕстьТоварыДругогоКачества КАК ЕстьТоварыДругогоКачестваВБазе,
	|	ВЫБОР
	|		КОГДА ТоварыДругогоКачества.НоменклатураБрак ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьТоварыДругогоКачестваПоФакту
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
	|		ПО СпрНоменклатура.Ссылка = ТоварыДругогоКачества.Номенклатура
	|ГДЕ
	|	СпрНоменклатура.Ссылка = &Номенклатура
	|	И СпрНоменклатура.ЕстьТоварыДругогоКачества <> ВЫБОР
	|			КОГДА ТоварыДругогоКачества.НоменклатураБрак ЕСТЬ NULL 
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	Запрос.УстановитьПараметр("Номенклатура",КачественныйТовар);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Объект = КачественныйТовар.ПолучитьОбъект();
		Объект.ЕстьТоварыДругогоКачества = Выборка.ЕстьТоварыДругогоКачестваПоФакту;		
		Объект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает новую номенклатуру для некачественной.
//
// Параметры:
//   Товар - СправочникСсылка.Номенклатура - некачественная номенклатура.
//
// Возвращаемое значение:
//   СправочникСсылка.Номенклатура - номенклатура нового качества.
//
Функция ПолучитьТоварИсходногоКачества(Товар) Экспорт
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Товар, "Качество") <> Перечисления.ГрадацииКачества.Новый Тогда
		КачественныйТовар = Неопределено;
		ЗапросПоКачественномуТовару = Новый Запрос;
		ЗапросПоКачественномуТовару.УстановитьПараметр("Номенклатура", Товар);
		ЗапросПоКачественномуТовару.Текст =
		"ВЫБРАТЬ
		|	ТоварыДругогоКачества.Номенклатура КАК КачественныйТовар
		|ИЗ
		|	РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
		|ГДЕ
		|	ТоварыДругогоКачества.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
		|	И ТоварыДругогоКачества.НоменклатураБрак = &Номенклатура";
		Выборка = ЗапросПоКачественномуТовару.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			КачественныйТовар = Выборка.КачественныйТовар;
		КонецЦикла;
		Возврат КачественныйТовар;
	Иначе 
		Возврат Товар;
	КонецЕсли;
КонецФункции

#КонецОбласти
	
#КонецЕсли