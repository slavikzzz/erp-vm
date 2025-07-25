#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборНоменклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	
	Если НЕ ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Номенклатура"" не заполнено.';
								|en = '""Items"" are not filled in.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	УстановитьОбязательныеНастройки();
	
	СхемаКомпоновкиДанных.НаборыДанных.ОстаткиСерии.Запрос = ТекстЗапросаОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки()
	
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипПолучателяПодразделение", НСтр("ru = 'Подразделение';
																											|en = 'Business unit'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипПолучателяПокупатель", НСтр("ru = 'Покупатель';
																										|en = 'Customer'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипПолучателяСклад", НСтр("ru = 'Склад';
																									|en = 'Warehouse'"));
	
КонецПроцедуры

Функция ТекстЗапросаОтчета()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	ВидыНоменклатурыПолитикиУчетаСерий.Склад КАК Склад
	|ПОМЕСТИТЬ НоменклатураПоКоторойНеВедутсяОстатки
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ВидыНоменклатурыПолитикиУчетаСерий
	|		ПО ВидыНоменклатурыПолитикиУчетаСерий.Ссылка = Номенклатура.ВидНоменклатуры
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|	И ВидыНоменклатурыПолитикиУчетаСерий.ПолитикаУчетаСерий.ТипПолитики В (ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий),
	|																			ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.АвторасчетПоFEFOОстатковСерий))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыНаСкладах.Регистратор		КАК Регистратор,
	|	ТоварыНаСкладах.ПериодСекунда	КАК ПериодСекунда,
	|	ТоварыНаСкладах.ПериодДень		КАК ПериодДень,
	|	ТоварыНаСкладах.ПериодНеделя	КАК ПериодНеделя,
	|	ТоварыНаСкладах.ПериодДекада	КАК ПериодДекада,
	|	ТоварыНаСкладах.ПериодМесяц		КАК ПериодМесяц,
	|	ТоварыНаСкладах.ПериодКвартал	КАК ПериодКвартал,
	|	ТоварыНаСкладах.ПериодПолугодие	КАК ПериодПолугодие,
	|	ТоварыНаСкладах.ПериодГод		КАК ПериодГод,
	|	ТоварыНаСкладах.Номенклатура	КАК Номенклатура,
	|	ТоварыНаСкладах.Характеристика	КАК Характеристика,
	|	ТоварыНаСкладах.Серия			КАК Серия,
	|	ТоварыНаСкладах.Склад			КАК Получатель,
	|	ТоварыНаСкладах.Помещение		КАК Помещение,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииНачальныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииНачальныйОстаток / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ							КАК ОстатокНачальный,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииПриход / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ							КАК Приход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииРасход / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ							КАК Расход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииКонечныйОстаток / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ							КАК Остаток,
	|	&ТипПолучателяСклад				КАК ТипПолучателя,
	|	ИСТИНА							КАК ОстаткиДоступны
	|
	|{ВЫБРАТЬ
	|	Регистратор.*,
	|	ПериодСекунда,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Номенклатура.*,
	|	Характеристика.*,
	|	Серия.*,
	|	Получатель.*,
	|	Помещение.*,
	|	ОстатокНачальный,
	|	Приход,
	|	Расход,
	|	Остаток,
	|	ТипПолучателя,
	|	ОстаткиДоступны
	|	}
	|
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(
	|			,
	|			,
	|			Авто,
	|			,
	|			Номенклатура = &Номенклатура
	|			И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И (Характеристика = &Характеристика
	|				ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|			И (Серия = &Серия
	|				ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Серия = НЕОПРЕДЕЛЕНО)
	|	) КАК ТоварыНаСкладах
	|
	|{ГДЕ
	|	ТоварыНаСкладах.Регистратор.*		КАК Регистратор,
	|	ТоварыНаСкладах.ПериодСекунда		КАК ПериодСекунда,
	|	ТоварыНаСкладах.ПериодДень			КАК ПериодДень,
	|	ТоварыНаСкладах.ПериодНеделя		КАК ПериодНеделя,
	|	ТоварыНаСкладах.ПериодДекада		КАК ПериодДекада,
	|	ТоварыНаСкладах.ПериодМесяц			КАК ПериодМесяц,
	|	ТоварыНаСкладах.ПериодКвартал		КАК ПериодКвартал,
	|	ТоварыНаСкладах.ПериодПолугодие		КАК ПериодПолугодие,
	|	ТоварыНаСкладах.ПериодГод			КАК ПериодГод,
	|	ТоварыНаСкладах.Номенклатура.*		КАК Номенклатура,
	|	ТоварыНаСкладах.Характеристика.*	КАК Характеристика,
	|	ТоварыНаСкладах.Серия.*				КАК Серия,
	|	ТоварыНаСкладах.Склад.*				КАК Получатель,
	|	ТоварыНаСкладах.Помещение.*			КАК Помещение,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииНачальныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииНачальныйОстаток / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)								КАК ОстатокНачальный,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииПриход / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)								КАК Приход,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииРасход / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)								КАК Расход,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ТоварыНаСкладах.ВНаличииКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ТоварыНаСкладах.ВНаличииКонечныйОстаток / ТоварыНаСкладах.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)								КАК Остаток,
	|	(&ТипПолучателяСклад)				КАК ТипПолучателя,
	|	(ИСТИНА)							КАК ОстаткиДоступны
	|}
	|
	//++ НЕ УТ
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МатериалыВПроизводстве.Регистратор		КАК Регистратор,
	|	МатериалыВПроизводстве.ПериодСекунда	КАК ПериодСекунда,
	|	МатериалыВПроизводстве.ПериодДень		КАК ПериодДень,
	|	МатериалыВПроизводстве.ПериодНеделя		КАК ПериодНеделя,
	|	МатериалыВПроизводстве.ПериодДекада		КАК ПериодДекада,
	|	МатериалыВПроизводстве.ПериодМесяц		КАК ПериодМесяц,
	|	МатериалыВПроизводстве.ПериодКвартал	КАК ПериодКвартал,
	|	МатериалыВПроизводстве.ПериодПолугодие	КАК ПериодПолугодие,
	|	МатериалыВПроизводстве.ПериодГод		КАК ПериодГод,
	|	МатериалыВПроизводстве.Номенклатура		КАК Номенклатура,
	|	МатериалыВПроизводстве.Характеристика	КАК Характеристика,
	|	МатериалыВПроизводстве.Серия			КАК Серия,
	|	МатериалыВПроизводстве.Подразделение	КАК Получатель,
	|	ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка) КАК Помещение,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоНачальныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоНачальныйОстаток / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ									КАК ОстатокНачальный,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоПриход / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ									КАК Приход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоРасход / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ									КАК Расход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоКонечныйОстаток / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ									КАК Остаток,
	|	&ТипПолучателяПодразделение				КАК ТипПолучателя,
	|	ИСТИНА									КАК ОстаткиДоступны
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.ОстаткиИОбороты(
	|			,
	|			,
	|			Авто,
	|			,
	|			Номенклатура = &Номенклатура
	|			И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И (Характеристика = &Характеристика
	|				ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|			И (Серия = &Серия
	|				ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Серия = НЕОПРЕДЕЛЕНО)) КАК МатериалыВПроизводстве
	|
	|{ГДЕ
	|	МатериалыВПроизводстве.Регистратор.*	КАК Регистратор,
	|	МатериалыВПроизводстве.ПериодСекунда	КАК ПериодСекунда,
	|	МатериалыВПроизводстве.ПериодДень		КАК ПериодДень,
	|	МатериалыВПроизводстве.ПериодНеделя		КАК ПериодНеделя,
	|	МатериалыВПроизводстве.ПериодДекада		КАК ПериодДекада,
	|	МатериалыВПроизводстве.ПериодМесяц		КАК ПериодМесяц,
	|	МатериалыВПроизводстве.ПериодКвартал	КАК ПериодКвартал,
	|	МатериалыВПроизводстве.ПериодПолугодие	КАК ПериодПолугодие,
	|	МатериалыВПроизводстве.ПериодГод		КАК ПериодГод,
	|	МатериалыВПроизводстве.Номенклатура.*	КАК Номенклатура,
	|	МатериалыВПроизводстве.Характеристика.*	КАК Характеристика,
	|	МатериалыВПроизводстве.Серия.*			КАК Серия,
	|	МатериалыВПроизводстве.Подразделение.*	КАК Получатель,
	|	(ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)).* КАК Помещение,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоНачальныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоНачальныйОстаток / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)									КАК ОстатокНачальный,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоПриход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоПриход / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)									КАК Приход,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоРасход
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоРасход / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)									КАК Расход,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА МатериалыВПроизводстве.КоличествоКонечныйОстаток
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА МатериалыВПроизводстве.КоличествоКонечныйОстаток / МатериалыВПроизводстве.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)									КАК Остаток,
	|	(&ТипПолучателяПодразделение)			КАК ТипПолучателя,
	|	(ИСТИНА)								КАК ОстаткиДоступны
	|}
	//-- НЕ УТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвиженияСерийТоваров.Регистратор			КАК Регистратор,
	|	ДвиженияСерийТоваров.ПериодСекунда			КАК ПериодСекунда,
	|	ДвиженияСерийТоваров.ПериодДень				КАК ПериодДень,
	|	ДвиженияСерийТоваров.ПериодНеделя			КАК ПериодНеделя,
	|	ДвиженияСерийТоваров.ПериодДекада			КАК ПериодДекада,
	|	ДвиженияСерийТоваров.ПериодМесяц			КАК ПериодМесяц,
	|	ДвиженияСерийТоваров.ПериодКвартал			КАК ПериодКвартал,
	|	ДвиженияСерийТоваров.ПериодПолугодие		КАК ПериодПолугодие,
	|	ДвиженияСерийТоваров.ПериодГод				КАК ПериодГод,
	|	ДвиженияСерийТоваров.Номенклатура			КАК Номенклатура,
	|	ДвиженияСерийТоваров.Характеристика			КАК Характеристика,
	|	ДвиженияСерийТоваров.Серия					КАК Серия,
	|	ДвиженияСерийТоваров.Получатель				КАК Получатель,
	|	ДвиженияСерийТоваров.ПомещениеПолучателя	КАК Помещение,
	|	0											КАК ОстатокНачальный,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваров.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваров.КоличествоОборот / ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ										КАК Приход,
	|	0											КАК Расход,
	|	0											КАК Остаток,
	|	ВЫБОР
	|		КОГДА ДвиженияСерийТоваров.Получатель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваров.Получатель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ										КАК ТипПолучателя,
	|	ЛОЖЬ										КАК ОстаткиДоступны
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			Авто,
	|			ЭтоСкладскоеДвижение
	|			И Номенклатура = &Номенклатура
	|			И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И (Характеристика = &Характеристика
	|				ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|			И (Серия = &Серия
	|				ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Серия = НЕОПРЕДЕЛЕНО)
	|			И ((Номенклатура, Получатель) В
	|					(ВЫБРАТЬ
	|						НоменклатураПоКоторойНеВедутсяОстатки.Ссылка,
	|						НоменклатураПоКоторойНеВедутсяОстатки.Склад
	|					ИЗ
	|						НоменклатураПоКоторойНеВедутсяОстатки)
	|				ИЛИ Получатель ССЫЛКА Справочник.Партнеры
	|					И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКлиенту),
	|											ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаВРозницу)))
	|	) КАК ДвиженияСерийТоваров
	|
	|{ГДЕ
	|	ДвиженияСерийТоваров.Регистратор.*			КАК Регистратор,
	|	ДвиженияСерийТоваров.ПериодСекунда			КАК ПериодСекунда,
	|	ДвиженияСерийТоваров.ПериодДень				КАК ПериодДень,
	|	ДвиженияСерийТоваров.ПериодНеделя			КАК ПериодНеделя,
	|	ДвиженияСерийТоваров.ПериодДекада			КАК ПериодДекада,
	|	ДвиженияСерийТоваров.ПериодМесяц			КАК ПериодМесяц,
	|	ДвиженияСерийТоваров.ПериодКвартал			КАК ПериодКвартал,
	|	ДвиженияСерийТоваров.ПериодПолугодие		КАК ПериодПолугодие,
	|	ДвиженияСерийТоваров.ПериодГод				КАК ПериодГод,
	|	ДвиженияСерийТоваров.Номенклатура.*			КАК Номенклатура,
	|	ДвиженияСерийТоваров.Характеристика.*		КАК Характеристика,
	|	ДвиженияСерийТоваров.Серия.*				КАК Серия,
	|	ДвиженияСерийТоваров.Получатель.*			КАК Получатель,
	|	ДвиженияСерийТоваров.ПомещениеПолучателя.*	КАК Помещение,
	|	(0)											КАК ОстатокНачальный,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваров.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваров.КоличествоОборот / ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)										КАК Приход,
	|	(0)											КАК Расход,
	|	(0)											КАК Остаток,
	|	(ВЫБОР
	|		КОГДА ДвиженияСерийТоваров.Получатель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваров.Получатель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ)										КАК ТипПолучателя,
	|	(ЛОЖЬ)										КАК ОстаткиДоступны
	|}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвиженияСерийТоваров.Регистратор			КАК Регистратор,
	|	ДвиженияСерийТоваров.ПериодСекунда			КАК ПериодСекунда,
	|	ДвиженияСерийТоваров.ПериодДень				КАК ПериодДень,
	|	ДвиженияСерийТоваров.ПериодНеделя			КАК ПериодНеделя,
	|	ДвиженияСерийТоваров.ПериодДекада			КАК ПериодДекада,
	|	ДвиженияСерийТоваров.ПериодМесяц			КАК ПериодМесяц,
	|	ДвиженияСерийТоваров.ПериодКвартал			КАК ПериодКвартал,
	|	ДвиженияСерийТоваров.ПериодПолугодие		КАК ПериодПолугодие,
	|	ДвиженияСерийТоваров.ПериодГод				КАК ПериодГод,
	|	ДвиженияСерийТоваров.Номенклатура			КАК Номенклатура,
	|	ДвиженияСерийТоваров.Характеристика			КАК Характеристика,
	|	ДвиженияСерийТоваров.Серия					КАК Серия,
	|	ДвиженияСерийТоваров.Отправитель			КАК Отправитель,
	|	ДвиженияСерийТоваров.ПомещениеОтправителя	КАК Помещение,
	|	0											КАК ОстатокНачальный,
	|	0											КАК Приход,
	|	ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваров.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваров.КоличествоОборот / ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ										КАК Расход,
	|	0											КАК Остаток,
	|	ВЫБОР
	|		КОГДА ДвиженияСерийТоваров.Отправитель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваров.Отправитель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ										КАК ТипПолучателя,
	|	ЛОЖЬ										КАК ОстаткиДоступны
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			Авто,
	|			ЭтоСкладскоеДвижение
	|			И Номенклатура = &Номенклатура
	|			И Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			И (Характеристика = &Характеристика
	|				ИЛИ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Характеристика = НЕОПРЕДЕЛЕНО)
	|			И (Серия = &Серия
	|				ИЛИ &Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ИЛИ &Серия = НЕОПРЕДЕЛЕНО)
	|			И ((Номенклатура, Отправитель) В
	|				(ВЫБРАТЬ
	|					НоменклатураПоКоторойНеВедутсяОстатки.Ссылка,
	|					НоменклатураПоКоторойНеВедутсяОстатки.Склад
	|				ИЗ
	|					НоменклатураПоКоторойНеВедутсяОстатки)
	|				ИЛИ Отправитель ССЫЛКА Справочник.Партнеры
	|					И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента)))
	|	) КАК ДвиженияСерийТоваров
	|
	|{ГДЕ
	|	ДвиженияСерийТоваров.Регистратор.*			КАК Регистратор,
	|	ДвиженияСерийТоваров.ПериодСекунда			КАК ПериодСекунда,
	|	ДвиженияСерийТоваров.ПериодДень				КАК ПериодДень,
	|	ДвиженияСерийТоваров.ПериодНеделя			КАК ПериодНеделя,
	|	ДвиженияСерийТоваров.ПериодДекада			КАК ПериодДекада,
	|	ДвиженияСерийТоваров.ПериодМесяц			КАК ПериодМесяц,
	|	ДвиженияСерийТоваров.ПериодКвартал			КАК ПериодКвартал,
	|	ДвиженияСерийТоваров.ПериодПолугодие		КАК ПериодПолугодие,
	|	ДвиженияСерийТоваров.ПериодГод				КАК ПериодГод,
	|	ДвиженияСерийТоваров.Номенклатура.*			КАК Номенклатура,
	|	ДвиженияСерийТоваров.Характеристика.*		КАК Характеристика,
	|	ДвиженияСерийТоваров.Серия.*				КАК Серия,
	|	ДвиженияСерийТоваров.Отправитель.*			КАК Отправитель,
	|	ДвиженияСерийТоваров.ПомещениеОтправителя.*	КАК Помещение,
	|	(0)											КАК ОстатокНачальный,
	|	(0)											КАК Приход,
	|	(ВЫБОР
	|		КОГДА &ЕдиницыКоличества = 0
	|			ТОГДА ДвиженияСерийТоваров.КоличествоОборот
	|		КОГДА &ЕдиницыКоличества = 1
	|			ТОГДА ВЫБОР
	|					КОГДА ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов <> 0
	|						ТОГДА ДвиженияСерийТоваров.КоличествоОборот / ДвиженияСерийТоваров.Номенклатура.КоэффициентЕдиницыДляОтчетов
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|	КОНЕЦ)										КАК Расход,
	|	(0)											КАК Остаток,
	|	(ВЫБОР
	|		КОГДА ДвиженияСерийТоваров.Отправитель ССЫЛКА Справочник.СтруктураПредприятия
	|			ТОГДА &ТипПолучателяПодразделение
	|		КОГДА ДвиженияСерийТоваров.Отправитель ССЫЛКА Справочник.Партнеры
	|			ТОГДА &ТипПолучателяПокупатель
	|		ИНАЧЕ &ТипПолучателяСклад
	|	КОНЕЦ)										КАК ТипПолучателя,
	|	(ЛОЖЬ)										КАК ОстаткиДоступны
	|}";

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
