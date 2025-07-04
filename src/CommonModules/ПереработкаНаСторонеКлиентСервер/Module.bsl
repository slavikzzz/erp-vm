////////////////////////////////////////////////////////////////////////////////
// Подсистема "Переработка на стороне".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает хозяйственную операцию по имени документа
//
// Параметры:
//  ИмяДокумента - Строка -
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ХозяйственныеОперации - 
//
Функция ХозяйственнаяОперацияПоИмениДокумента(ИмяДокумента) Экспорт

	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
	
	Если ВРег(ИмяДокумента) = ВРег("ПередачаТоваровХранителю") Тогда
		ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаПереработчику2_5");
	КонецЕсли;

	Возврат ХозяйственнаяОперация;

КонецФункции

#Область ГруппировкаЗатрат2_5

// Возвращает перечень полей, идентифицирующих группу затрат.
//	Параметры:
//		ГруппировкаЗатрат - ПеречислениеСсылка.ГруппировкиЗатратВЗаказеПереработчику - тип группировки затрат.
//	Возвращаемое значение:
//		СписокЗначений - перечень полей, идентифицирующих группу затрат.
//
Функция ПереченьПолейГруппыЗатратЗаказаПереработчику(ГруппировкаЗатрат) Экспорт
	
	СписокПолей = Новый СписокЗначений;
	
	Если ГруппировкаЗатрат = 
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям") Тогда
		СписокПолей.Добавить("Спецификация",	НСтр("ru = 'Спецификация';
													|en = 'Bill of materials'"));
	ИначеЕсли ГруппировкаЗатрат = 
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациямИНазначениям") Тогда
		СписокПолей.Добавить("Спецификация",	НСтр("ru = 'Спецификация';
													|en = 'Bill of materials'"));
		СписокПолей.Добавить("Назначение",		НСтр("ru = 'Назначение';
														|en = 'Assignment'"));
	ИначеЕсли ГруппировкаЗатрат =
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции") Тогда
		СписокПолей.Добавить("Номенклатура",	НСтр("ru = 'Номенклатура';
													|en = 'Items'"));
		СписокПолей.Добавить("Характеристика",	НСтр("ru = 'Характеристика';
														|en = 'Variant'"));
	ИначеЕсли ГруппировкаЗатрат =
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукцииИНазначениям") Тогда
		СписокПолей.Добавить("Номенклатура",	НСтр("ru = 'Номенклатура';
													|en = 'Items'"));
		СписокПолей.Добавить("Характеристика",	НСтр("ru = 'Характеристика';
														|en = 'Variant'"));
		СписокПолей.Добавить("Назначение",		НСтр("ru = 'Назначение';
														|en = 'Assignment'"));
	//++ НЕ УТКА
	ИначеЕсли ГруппировкаЗатрат =
		ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		СписокПолей.Добавить("Распоряжение",	НСтр("ru = 'Распоряжение';
													|en = 'Reference'"));
	//-- НЕ УТКА
	КонецЕсли;
	
	Возврат СписокПолей;
	
КонецФункции

// Возвращает перечень полей, идентифицирующих группу затрат.
//	Параметры:
//		ГруппировкаЗатрат - ПеречислениеСсылка.ГруппировкиЗатратВЗаказеПереработчику - тип группировки затрат.
//	Возвращаемое значение:
//		СписокЗначений - перечень полей, идентифицирующих группу затрат.
//
Функция ПереченьПолейГруппыЗатратОтчетаПереработчика(ГруппировкаЗатрат) Экспорт
	
	СписокПолей = Новый СписокЗначений;
	
	Если ГруппировкаЗатрат = 
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям") Тогда
		СписокПолей.Добавить("Спецификация",	НСтр("ru = 'Спецификация';
													|en = 'Bill of materials'"));
	ИначеЕсли ГруппировкаЗатрат = 
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациямИНазначениям") Тогда
		СписокПолей.Добавить("Спецификация",	НСтр("ru = 'Спецификация';
													|en = 'Bill of materials'"));
		СписокПолей.Добавить("Назначение",		НСтр("ru = 'Назначение';
														|en = 'Assignment'"));
	ИначеЕсли ГруппировкаЗатрат =
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции") Тогда
		СписокПолей.Добавить("Номенклатура",	НСтр("ru = 'Номенклатура';
													|en = 'Items'"));
		СписокПолей.Добавить("Характеристика",	НСтр("ru = 'Характеристика';
														|en = 'Variant'"));
		СписокПолей.Добавить("Серия",			НСтр("ru = 'Серия';
														|en = 'Batch'"));
	ИначеЕсли ГруппировкаЗатрат =
			ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукцииИНазначениям") Тогда
		СписокПолей.Добавить("Номенклатура",	НСтр("ru = 'Номенклатура';
													|en = 'Items'"));
		СписокПолей.Добавить("Характеристика",	НСтр("ru = 'Характеристика';
														|en = 'Variant'"));
		СписокПолей.Добавить("Серия",			НСтр("ru = 'Серия';
														|en = 'Batch'"));
		СписокПолей.Добавить("Назначение",		НСтр("ru = 'Назначение';
														|en = 'Assignment'"));
	//++ НЕ УТКА
	ИначеЕсли ГруппировкаЗатрат =
		ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		СписокПолей.Добавить("Распоряжение",	НСтр("ru = 'Распоряжение';
													|en = 'Reference'"));
	//-- НЕ УТКА
	КонецЕсли;
	
	Возврат СписокПолей;
	
КонецФункции

// Представление группы затрат
// 
// Параметры:
// 	Группа - Структура - описание группы затрат
// 	ПоляГруппыЗатрат - СписокЗначений - список полей группы затрат
// Возвращаемое значение:
// 	Строка
Функция ПредставлениеГруппыЗатрат(Группа, ПоляГруппыЗатрат) Экспорт
	
	ПредставлениеГруппы = "";
	Для Каждого ТекПоле Из ПоляГруппыЗатрат Цикл
		
		ТекПредставление = Строка(Группа[ТекПоле.Значение]);
		
		Если ЗначениеЗаполнено(ТекПредставление) Тогда
			ПредставлениеГруппы = ПредставлениеГруппы + ТекПредставление + " / ";
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ПредставлениеГруппы) Тогда
		ПредставлениеГруппы = Лев(ПредставлениеГруппы, СтрДлина(ПредставлениеГруппы) - 3);
	Иначе
		ПредставлениеГруппы = НСтр("ru = '<группа с пустыми значениями>';
									|en = '<group with empty values>'");
	КонецЕсли;
	
	Возврат ПредставлениеГруппы;

КонецФункции 

// Возвращает строку, содержащую перечень путей получения идентифицирующих группу затрат полей.
//	Параметры:
//		ИмяТаблицы - Строка - имя источника получения идентифицирующих группу затрат полей.
//		СписокПолей - СписокЗначений - перечень полей, идентифицирующих группу затрат.
//	Возвращаемое значение:
//		Строка - строка, содержащая перечень путей получения идентифицирующих группу затрат полей.
//
Функция ТекстЗапросаПоПолямГруппыЗатрат(ИмяТаблицы, СписокПолей) Экспорт
	
	ТекстЗапросаПоПолям = "";
	
	Для Каждого ТекПоле Из СписокПолей Цикл
		ТекстЗапросаПоПолям = ТекстЗапросаПоПолям + ", " + ИмяТаблицы + "." + ТекПоле.Значение;
	КонецЦикла;
	
	Возврат ТекстЗапросаПоПолям;
	
КонецФункции

// Возвращает структуру, содержащую перечень идентифицирующих группу затрат полей.
//	Параметры:
//		СписокПолей - СписокЗначений - перечень полей, идентифицирующих группу затрат.
//	Возвращаемое значение:
//		Структура - структура, содержащая перечень идентифицирующих группу затрат полей.
//
Функция СтруктураОтбораГруппыЗатрат(СписокПолей) Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	Для Каждого ТекПоле Из СписокПолей Цикл
		СтруктураОтбора.Вставить(ТекПоле.Значение);
	КонецЦикла;
	
	Возврат СтруктураОтбора;
	
КонецФункции


// Получает заголовок поля группы затрат
// 
// Параметры:
// 	ПоляГруппыЗатрат - СписокЗначений
// Возвращаемое значение:
// 	Строка
Функция ЗаголовокПоляГруппыЗатрат2_5(ПоляГруппыЗатрат) Экспорт
	
	ЗаголовокГруппыЗатрат = "";
	Для Каждого ТекПоле Из ПоляГруппыЗатрат Цикл
		ЗаголовокГруппыЗатрат = ЗаголовокГруппыЗатрат + ТекПоле.Представление + " / ";
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ЗаголовокГруппыЗатрат) Тогда
		ЗаголовокГруппыЗатрат = Лев(ЗаголовокГруппыЗатрат, СтрДлина(ЗаголовокГруппыЗатрат) - 3);
		ЗаголовокГруппыЗатрат = НСтр("ru = 'Группа затрат';
									|en = 'Cost group'") + " (" + ЗаголовокГруппыЗатрат + ")";
	Иначе
		ЗаголовокГруппыЗатрат = НСтр("ru = 'Группа затрат';
									|en = 'Cost group'");
	КонецЕсли;
	
	Возврат ЗаголовокГруппыЗатрат;
	
КонецФункции

// Описание
// 
// Параметры:
// 	ГруппировкаЗатрат - ПеречислениеСсылка.ГруппировкиЗатратВЗаказеПереработчику
// Возвращаемое значение:
// 	Строка
Функция ШаблонПодсказкиПоляГруппыЗатрат2_5(ГруппировкаЗатрат) Экспорт
	
	ПодсказкаГруппыЗатрат = "";
	
	Если ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции") Тогда
		ПодсказкаГруппыЗатрат = НСтр("ru = 'Продукция к которой относится %1';
									|en = 'Products that include %1'");
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукцииИНазначениям") Тогда
		ПодсказкаГруппыЗатрат = НСтр("ru = 'Продукция и назначение к которым относится %1';
									|en = 'Manufactured products and assignment to which %1 belongs'");
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям") Тогда
		ПодсказкаГруппыЗатрат = НСтр("ru = 'Спецификация к которой относится %1';
									|en = 'Bill of materials to which %1 belongs'");
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациямИНазначениям") Тогда
		ПодсказкаГруппыЗатрат = НСтр("ru = 'Спецификация и назначение к которым относится %1';
									|en = 'Bill of materials and assignment to which %1 belongs'");
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		ПодсказкаГруппыЗатрат = НСтр("ru = 'Этап к которому относится %1';
									|en = 'Stage to which %1 is related'");
	КонецЕсли;
	
	Возврат ПодсказкаГруппыЗатрат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НомерГруппыЗатратВОтчетеПереработчика(Объект, СтрокаПродукция) Экспорт
	
	НомерГруппыЗатрат = 0;
	
	Если Объект.ПоЗаказам Тогда
		
		ИмяПоляГруппаЗатрат = ИмяПоляГруппаЗатратВОтчетеПереработчика(Объект);
	
		// Если отчет по заказу то группы затрат могут быть только из заказа
		// Если группа только одна то сразу подставим ее в текущую строку продукции.
		Если Объект.Услуги.Количество() = 1 Тогда
			НомерГруппыЗатрат = Объект.Услуги[0][ИмяПоляГруппаЗатрат];
		КонецЕсли; 
		
	Иначе
		
		// Если отчет не по заказу то заполнение группы аналогично заполнению в заказе переработчику.
		Если Объект.ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции") Тогда
			
			СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Назначение,ДокументПоступления");
			СтруктураПоиска.Номенклатура        = СтрокаПродукция.Номенклатура;
			СтруктураПоиска.Характеристика      = СтрокаПродукция.Характеристика;
			СтруктураПоиска.Назначение          = СтрокаПродукция.Назначение;
			СтруктураПоиска.ДокументПоступления = СтрокаПродукция.ДокументПоступления;
			
			СписокСтрок = Объект.Продукция.НайтиСтроки(СтруктураПоиска);
			
			Для каждого ДанныеСтроки Из СписокСтрок Цикл
				Если ДанныеСтроки.НомерГруппыЗатрат <> 0 Тогда
					НомерГруппыЗатрат = ДанныеСтроки.НомерГруппыЗатрат;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НомерГруппыЗатрат = 0 Тогда
				Объект.МаксимальныйНомерГруппыЗатрат = Объект.МаксимальныйНомерГруппыЗатрат + 1;
				НомерГруппыЗатрат = Объект.МаксимальныйНомерГруппыЗатрат;
			КонецЕсли;
			
		ИначеЕсли Объект.ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям") Тогда
			
			СтруктураПоиска = Новый Структура("Спецификация", СтрокаПродукция.Спецификация);
			СписокСтрок = Объект.Продукция.НайтиСтроки(СтруктураПоиска);
			Для каждого ДанныеСтроки Из СписокСтрок Цикл
				Если ДанныеСтроки.НомерГруппыЗатрат <> 0 Тогда
					НомерГруппыЗатрат = ДанныеСтроки.НомерГруппыЗатрат;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НомерГруппыЗатрат = 0 Тогда
				Объект.МаксимальныйНомерГруппыЗатрат = Объект.МаксимальныйНомерГруппыЗатрат + 1;
				НомерГруппыЗатрат = Объект.МаксимальныйНомерГруппыЗатрат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 

	Возврат НомерГруппыЗатрат;
	
КонецФункции

Функция ЗаголовокПоляГруппыЗатрат(ГруппировкаЗатрат, ОбосабливатьПоНазначениюПродукции) Экспорт
	
	Если ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции") Тогда
		
		Если ОбосабливатьПоНазначениюПродукции Тогда
			ЗаголовокГруппы = НСтр("ru = 'Продукция и назначение';
									|en = 'Products and purpose'");
		Иначе
			ЗаголовокГруппы = НСтр("ru = 'Продукция';
									|en = 'Manufactured products'");
		КонецЕсли;
		
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям") Тогда
		
		ЗаголовокГруппы = НСтр("ru = 'Спецификация продукции';
								|en = 'Product BOM'");
	
	//++ Устарело_Производство21	
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЗаказамНаПроизводство") Тогда
		
		ЗаголовокГруппы = НСтр("ru = 'Заказ (этап, спецификация)';
								|en = 'Order (step, BOM)'");
	//-- Устарело_Производство21	
	ИначеЕсли ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		
		ЗаголовокГруппы = НСтр("ru = 'Этап производства';
								|en = 'Production stage'");
		
	КонецЕсли;
	
	Возврат ЗаголовокГруппы;
	
КонецФункции

Функция ИмяПоляГруппаЗатратВОтчетеПереработчика(Объект) Экспорт
	
	Если Объект.ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		Возврат "ЭтапПроизводства";
	Иначе
		Возврат "НомерГруппыЗатрат";
	КонецЕсли;
	
КонецФункции

Функция ИмяПоляГруппаЗатратВЗаказеПереработчику(Объект) Экспорт
	
	Если Объект.ГруппировкаЗатрат = ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства") Тогда
		Возврат "Распоряжение";
	Иначе
		Возврат "НомерГруппыЗатрат";
	КонецЕсли;
	
КонецФункции

#КонецОбласти
