#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
	
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ДанныеВыбораБЗК.ЗаполнитьДляКлассификатораСПорядкомПоДопРеквизиту(
		Справочники.СтатусыНалогоплательщиковПоНДФЛ,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ОписанияСтатусов = Новый Массив;
	// Строки не локализуются т.к. являются частью регламентированной формы, применяемой в РФ.
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Резидент";
	Описание.Наименование = НСтр("ru = 'Резидент';
								|en = 'Resident'");
	Описание.КодФНС = "1";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Нерезидент";
	Описание.Наименование = НСтр("ru = 'Нерезидент';
								|en = 'Non-resident'");
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "ВысококвалифицированныйИностранныйСпециалист";
	Описание.Наименование = НСтр("ru = 'Высококвалифицированный иностранный специалист';
								|en = 'Highly-skilled foreign specialist'");
	Описание.КодФНС = "3";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "ЧленЭкипажаСуднаПодФлагомРФ";
	Описание.Наименование = НСтр("ru = 'Член экипажа судна, зарегистрированного в Российском международном реестре судов';
								|en = 'Vessel crew member registered in the Russian International Register of Vessels'");
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "УчастникПрограммыПоПереселениюСоотечественников";
	Описание.Наименование = НСтр("ru = 'Участник программы по переселению соотечественников';
								|en = 'Participant of the program for the resettlement of compatriots'");
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
	
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Беженцы";
	Описание.Наименование = НСтр("ru = 'Беженцы или получившие временное убежище на территории РФ';
								|en = 'Refugees or those who received temporary asylum on the territory of the Russian Federation'");
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
	
	Счетчик = 1;
	Для каждого ОписаниеСтатуса Из ОписанияСтатусов Цикл
		
		СтатусСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатусыНалогоплательщиковПоНДФЛ." + ОписаниеСтатуса.Идентификатор);
		Если ЗначениеЗаполнено(СтатусСсылка) Тогда
			СтатусОбъект = СтатусСсылка.ПолучитьОбъект();
		Иначе
			СтатусОбъект = Справочники.СтатусыНалогоплательщиковПоНДФЛ.СоздатьЭлемент();
			СтатусОбъект.ИмяПредопределенныхДанных = ОписаниеСтатуса.Идентификатор;
		КонецЕсли;
		
		Если СтатусОбъект.РеквизитДопУпорядочивания <> Счетчик Тогда
		
			СтатусОбъект.Наименование = ОписаниеСтатуса.Наименование;
			СтатусОбъект.КодФНС = ОписаниеСтатуса.КодФНС;
			СтатусОбъект.РеквизитДопУпорядочивания = Счетчик;
			СтатусОбъект.ОбменДанными.Загрузка = Истина;
			СтатусОбъект.Записать();
			
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	ОписатьСтатусыНерезидентов2015(Истина);
	ПроставитьКоды_2015(Истина);
	ОписатьСтатусДистанционныйРаботник();
	
КонецПроцедуры

Процедура ОписатьСтатусыНерезидентов2015(Переписывать = Ложь)
	
	Если Переписывать Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС, "КодФНС")) Тогда
		СтатусБеженца = Справочники.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС.ПолучитьОбъект();
		СтатусБеженца.КодФНС = "2";
		СтатусБеженца.РеквизитДопУпорядочивания = 7;
		СтатусБеженца.ОбменДанными.Загрузка = Истина;
		СтатусБеженца.Записать();
	КонецЕсли;
	
	Если Переписывать Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента, "КодФНС")) Тогда
		СтатусБеженца = Справочники.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента.ПолучитьОбъект();
		СтатусБеженца.КодФНС = "2";
		СтатусБеженца.РеквизитДопУпорядочивания = 8;
		СтатусБеженца.ОбменДанными.Загрузка = Истина;
		СтатусБеженца.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОписатьСтатусДистанционныйРаботник() Экспорт
	
	ОписатьСтатусНалогоплательщика("ДистанционныйРаботник",НСтр("ru = 'Дистанционный работник, не являющийся налоговым резидентом РФ';
																|en = 'Remote worker who is not an RF tax resident'"),"2","8",9);
	
КонецПроцедуры

Процедура ОписатьСтатусНалогоплательщика(ИмяПредопределенныхДанных, Наименование, КодФНС, КодФНС_2015, РеквизитДопУпорядочивания)
	
	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатусыНалогоплательщиковПоНДФЛ." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Элемент = Справочники.СтатусыНалогоплательщиковПоНДФЛ.СоздатьЭлемент();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;
	
	Если Элемент.Наименование <> Наименование Тогда
		Элемент.Наименование = Наименование;
	КонецЕсли;
	
	Если Элемент.КодФНС <> КодФНС Тогда
		Элемент.КодФНС = КодФНС;
	КонецЕсли;
	
	Если Элемент.КодФНС_2015 <> КодФНС_2015 Тогда
		Элемент.КодФНС_2015 = КодФНС_2015;
	КонецЕсли;
	
	Если Элемент.РеквизитДопУпорядочивания <> РеквизитДопУпорядочивания Тогда
		Элемент.РеквизитДопУпорядочивания = РеквизитДопУпорядочивания;
	КонецЕсли;
	
	Если Элемент.Модифицированность() Тогда
		Элемент.ОбменДанными.Загрузка = Истина;
		Элемент.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Элемент.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроставитьКоды_2015(Переписывать = Ложь)

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтатусыНалогоплательщиковПоНДФЛ.Ссылка,
	|	ВЫБОР
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Резидент)
	|			ТОГДА ""1""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент)
	|			ТОГДА ""2""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС)
	|			ТОГДА ""2""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ВысококвалифицированныйИностранныйСпециалист)
	|			ТОГДА ""3""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ЧленЭкипажаСуднаПодФлагомРФ)
	|			ТОГДА ""4""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.УчастникПрограммыПоПереселениюСоотечественников)
	|			ТОГДА ""4""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Беженцы)
	|			ТОГДА ""5""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента)
	|			ТОГДА ""6""
	|		ИНАЧЕ ""2""
	|	КОНЕЦ КАК КодФНС_2015
	|ИЗ
	|	Справочник.СтатусыНалогоплательщиковПоНДФЛ КАК СтатусыНалогоплательщиковПоНДФЛ
	|ГДЕ
	|	&Условие";
	Если Переписывать Тогда
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Условие", Истина);
	Иначе
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Условие", "СтатусыНалогоплательщиковПоНДФЛ.КодФНС_2015 = """"");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтатусОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СтатусОбъект.КодФНС_2015 = Выборка.КодФНС_2015;
		СтатусОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СтатусОбъект.ОбменДанными.Загрузка = Истина;
		СтатусОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ОписаниеСтатуса()
	
	Возврат Новый Структура("Идентификатор, Наименование, КодФНС");	
	
КонецФункции	

Функция ЭтоРезидент(СтатусНалогоплательщика) Экспорт
	Если ТипЗнч(СтатусНалогоплательщика) <> Тип("СправочникСсылка.СтатусыНалогоплательщиковПоНДФЛ")
		Или СтатусНалогоплательщика.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	Имя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатусНалогоплательщика, "ИмяПредопределенныхДанных", Ложь);
	Возврат СтрСравнить(Имя, "Резидент") = 0;
КонецФункции

#КонецОбласти

#КонецЕсли
