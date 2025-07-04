#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("ПервичныйДокумент") И ЗначениеЗаполнено(ДанныеЗаполнения.ПервичныйДокумент) Тогда
			Товары.Загрузить(Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ДанныеТЧТоварыПоОснованию(
			ПервичныйДокумент,
			КодТНВЭД,
			ЕдиницаИзмерения));	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КодТНВЭД) Тогда
			ЕдиницаПрослеживаемости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодТНВЭД, "ЕдиницаИзмерения");
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,
																		Документы.УведомлениеОВвозеПрослеживаемыхТоваров);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												ПараметрыУказанияСерий,
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ПроверитьКорректностьЗаполнениеТабличнойЧасти(Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоРНПТ");
	
	Если Не ЗначениеЗаполнено(РНПТ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтранаПроисхождения");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ
		И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,
																		Документы.УведомлениеОВвозеПрослеживаемыхТоваров);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МенеджерАналитики = РегистрыСведений.АналитикаУчетаНоменклатуры;
		
		МестаУчета = МенеджерАналитики.МестаУчета(Неопределено, Неопределено, Неопределено, Неопределено);
		
		ТекстПоляСклад =
		"ВЫБОР
		|	КОГДА Коллекция.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)
		|		ТОГДА Коллекция.Склад
		|	КОГДА Коллекция.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
		|		ТОГДА Коллекция.Договор
		|	КОГДА Коллекция.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
		|		ТОГДА Коллекция.Подразделение
		|	ИНАЧЕ НЕОПРЕДЕЛЕНО
		|КОНЕЦ";
		
		ИменаПолей = МенеджерАналитики.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.Вставить("Товар",				Новый Структура("ТекстПоля", ТекстПоляСклад));
		ИменаПолей.Вставить("МногооборотнаяТара",	Новый Структура("ТекстПоля", ТекстПоляСклад));
		
		МенеджерАналитики.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РНПТ)
		И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ВыгружаемыкКолонки = "НомерСтроки, Номенклатура, НомерГТД, СтранаПроисхождения";
		
		УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьНомера(ЭтотОбъект, Товары.Выгрузить(, ВыгружаемыкКолонки));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный	= Пользователи.ТекущийПользователь();
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПроверитьКорректностьЗаполнениеТабличнойЧасти(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки		КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура		КАК Номенклатура,
	|	ТаблицаТоваров.КоличествоПоРНПТ	КАК КоличествоПоРНПТ,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|				И ТаблицаТоваров.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|				И ТаблицаТоваров.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ							КАК ПустоеМестоХранения
	|ПОМЕСТИТЬ ТаблицаТоварыДляЗапроса
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыДокумента.НомерСтроки							КАК НомерСтроки,
	|	ТоварыДокумента.Номенклатура						КАК Номенклатура,
	|	МИНИМУМ(ТоварыДокумента.ПрослеживаемыйТовар)		КАК ПрослеживаемыйТовар,
	|	МАКСИМУМ(ТоварыДокумента.ПустоеКоличествоПоРНПТ)	КАК ПустоеКоличествоПоРНПТ,
	|	МАКСИМУМ(ТоварыДокумента.ПустоеМестоХранения)		КАК ПустоеМестоХранения
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.НомерСтроки	КАК НомерСтроки,
	|		ТаблицаТоваров.Номенклатура	КАК Номенклатура,
	|		ЕСТЬNULL(ТаблицаНоменклатуры.ПрослеживаемыйТовар, ЛОЖЬ)
	|			И ЕСТЬNULL(ТаблицаНоменклатуры.ВестиУчетПоГТД, ЛОЖЬ) КАК ПрослеживаемыйТовар,
	|		ЛОЖЬ						КАК ПустоеКоличествоПоРНПТ,
	|		ЛОЖЬ						КАК ПустоеМестоХранения
	|	ИЗ
	|		ТаблицаТоварыДляЗапроса КАК ТаблицаТоваров
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК ТаблицаНоменклатуры
	|			ПО ТаблицаТоваров.Номенклатура = ТаблицаНоменклатуры.Ссылка
	|				И ТаблицаНоменклатуры.ТипНоменклатуры В(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|														ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	
	|	ГДЕ
	|		НЕ (ЕСТЬNULL(ТаблицаНоменклатуры.ПрослеживаемыйТовар, ЛОЖЬ)
	|			И ЕСТЬNULL(ТаблицаНоменклатуры.ВестиУчетПоГТД, ЛОЖЬ))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.НомерСтроки	КАК НомерСтроки,
	|		ТаблицаТоваров.Номенклатура	КАК Номенклатура,
	|		ИСТИНА						КАК ПрослеживаемыйТовар,
	|		&ПроверитьКоличествоПоРНПТ
	|			И ТаблицаТоваров.КоличествоПоРНПТ = 0
	|			И ЕСТЬNULL(ТаблицаНоменклатуры.ВестиУчетПоГТД, ЛОЖЬ)
	|			И ЕСТЬNULL(ТаблицаНоменклатуры.ПрослеживаемыйТовар, ЛОЖЬ) КАК ПустоеКоличествоПоРНПТ,
	|		ЛОЖЬ						КАК ПустоеМестоХранения
	|	ИЗ
	|		ТаблицаТоварыДляЗапроса КАК ТаблицаТоваров
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК ТаблицаНоменклатуры
	|			ПО ТаблицаТоваров.Номенклатура = ТаблицаНоменклатуры.Ссылка
	|				И ТаблицаНоменклатуры.ТипНоменклатуры В(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|														ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	
	|	ГДЕ
	|		&ПроверитьКоличествоПоРНПТ
	|		И ТаблицаТоваров.КоличествоПоРНПТ = 0
	|		И ЕСТЬNULL(ТаблицаНоменклатуры.ВестиУчетПоГТД, ЛОЖЬ)
	|		И ЕСТЬNULL(ТаблицаНоменклатуры.ПрослеживаемыйТовар, ЛОЖЬ)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.НомерСтроки			КАК НомерСтроки,
	|		ТаблицаТоваров.Номенклатура			КАК Номенклатура,
	|		ИСТИНА								КАК ПрослеживаемыйТовар,
	|		ЛОЖЬ								КАК ПустоеКоличествоПоРНПТ,
	|		ТаблицаТоваров.ПустоеМестоХранения	КАК ПустоеМестоХранения
	|	ИЗ
	|		ТаблицаТоварыДляЗапроса КАК ТаблицаТоваров
	|	
	|	ГДЕ
	|		ТаблицаТоваров.ПустоеМестоХранения
	|	
	|	) КАК ТоварыДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыДокумента.НомерСтроки,
	|	ТоварыДокумента.Номенклатура
	|
	|ИМЕЮЩИЕ
	|	НЕ МИНИМУМ(ТоварыДокумента.ПрослеживаемыйТовар)
	|	ИЛИ МАКСИМУМ(ТоварыДокумента.ПустоеКоличествоПоРНПТ)
	|	ИЛИ МАКСИМУМ(ТоварыДокумента.ПустоеМестоХранения)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить());
	Запрос.УстановитьПараметр("ПроверитьКоличествоПоРНПТ",
								ПолучитьФункциональнуюОпцию("ИспользуетсяУчетВЕдиницеИзмеренияТНВЭД"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ОшибкаНаличияНепрослеживаемогоТовара	= НСтр("ru = 'Непрослеживаемый товар ""%Номенклатура%"" в строке %НомерСтроки% списка ""Товары"".';
													|en = 'Untraced goods ""%Номенклатура%"" in line %НомерСтроки% if the Item list.'");
	ОшибкаЗаполненияКоличестваПоРНПТ		= НСтр("ru = 'Не заполнена колонка ""Количество по РНПТ"" в строке %НомерСтроки% списка ""Товары"".';
													|en = 'The ""Quantity by GBRN"" column is not filled in line %НомерСтроки% of the ""Goods"" list.'");
	ОшибкаЗаполненияМестаХранения			= НСтр("ru = 'Не заполнена колонка ""Место хранения"" в строке %НомерСтроки% списка ""Товары"".';
													|en = 'Column ""Storage location"" in line %НомерСтроки% of the ""Goods"" list is not filled in.'");
	КлючДанных								= ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.ПрослеживаемыйТовар Тогда
			ТекстСообщения = СтрЗаменить(ОшибкаНаличияНепрослеживаемогоТовара, "%Номенклатура%", Выборка.Номенклатура);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Выборка.НомерСтроки);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары",
																	Выборка.НомерСтроки,
																	"Номенклатура");
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если Выборка.ПустоеКоличествоПоРНПТ Тогда
			ТекстСообщения = СтрЗаменить(ОшибкаЗаполненияКоличестваПоРНПТ, "%НомерСтроки%", Выборка.НомерСтроки);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "КоличествоПоРНПТ");
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если Выборка.ПустоеМестоХранения Тогда
			ТекстСообщения = СтрЗаменить(ОшибкаЗаполненияМестаХранения, "%НомерСтроки%", Выборка.НомерСтроки);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, "", "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
