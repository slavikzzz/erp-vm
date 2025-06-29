#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	Если ВключитьАмортизационнуюПремиюВСоставРасходов
		ИЛИ ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
			И ВариантПримененияЦелевогоФинансирования <> Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		ПараметрыВыбораСтатейИАналитик = Документы.МодернизацияОС.ПараметрыВыбораСтатейИАналитик();
		ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	КонецЕсли;
	
	Если НЕ ВключитьАмортизационнуюПремиюВСоставРасходов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаДоходов");
		
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Счет");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	КонецЕсли;
	
	Если ВариантПримененияЦелевогоФинансирования <> Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	КонецЕсли;
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	ПроверитьЗаполнениеСчетовЦелевогоФинансирования(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РассчитатьАмортизацию(Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		ЦелевоеФинансирование.Очистить();
	КонецЕсли;
	ТаблицаОС = ЭтотОбъект.ОС.Выгрузить();
	ЗаполнитьСуммыЦелевыхСредств(ТаблицаОС);
	ЭтотОбъект.ОС.Загрузить(ТаблицаОС);
	ЦелевоеФинансированиеОчиститьСубконто();
	
	ПараметрыВыбораСтатейИАналитик = Документы.МодернизацияОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект,
		"Хозрасчетный, ПараметрыАмортизацииОСБУ");
	
	Документы.МодернизацияОС.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Модернизация ОС';
																					|en = 'Fixed assets — Cost additions'"));
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьЗаполнениеСчетаУчетаОС(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ДополнительныеСвойства = ДополнительныеСвойства;
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ, ДопПараметры);
	
	Если Не Отказ Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		
		СобытиеОС = УчетОСВызовСервера.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.Модернизация);
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.МодернизацияОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура РассчитатьАмортизацию(Отказ)
	
	НачисленнаяАмортизация.Очистить();
	
	ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.НачисленнаяАмортизация(
		ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"), ТаблицаРеквизитовДокумента(),, Отказ);
	
	ДополнительныеСвойства.Вставить("НачисленнаяАмортизация", ТаблицаНачисленнаяАмортизация);
	НачисленнаяАмортизация.Загрузить(ТаблицаНачисленнаяАмортизация);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер КАК Номер,
		|	&Организация КАК Организация,
		|	"""" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ЗаполнитьСуммыЦелевыхСредств(ТаблицаОС)
	
	ТаблицаОС.ЗаполнитьЗначения(Неопределено, "СуммаЦелевыхСредств");
	
	Если ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.Полное Тогда
		
		ТаблицаЦФ = ЦелевоеФинансирование.Выгрузить();
		ТаблицаЦФ.ЗаполнитьЗначения(Неопределено, "Сумма");
		ЦелевоеФинансирование.Загрузить(ТаблицаЦФ);
		
	ИначеЕсли ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное Тогда
		Если ТаблицаОС.Количество() > 0 Тогда
			СуммаКРаспределению = ЦелевоеФинансирование.Итог("Сумма");
			СуммаСтроки = Окр(СуммаКРаспределению / ТаблицаОС.Количество(), 2);
			ТаблицаОС.ЗаполнитьЗначения(СуммаСтроки, "СуммаЦелевыхСредств");
			ТаблицаОС[0].СуммаЦелевыхСредств = ТаблицаОС[0].СуммаЦелевыхСредств - (СуммаКРаспределению - СуммаСтроки*ТаблицаОС.Количество());
		КонецЕсли;
	Иначе
		ЦелевоеФинансирование.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЦелевоеФинансированиеОчиститьСубконто()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", ЦелевоеФинансирование.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	(ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
	|	ВЫРАЗИТЬ(Таблица.Счет КАК ПланСчетов.Хозрасчетный) КАК Счет,
	|	Таблица.Субконто1 КАК Субконто1,
	|	Таблица.Субконто2 КАК Субконто2,
	|	Таблица.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ втДанныеЗаполнения
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеЗаполнения.ИндексСтроки,
	|	
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто1.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто1
	|	КОНЕЦ КАК Субконто1,
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто2.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто2
	|	КОНЕЦ КАК Субконто2,
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто3.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто3
	|	КОНЕЦ КАК Субконто3
	|ИЗ
	|	втДанныеЗаполнения КАК втДанныеЗаполнения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто1
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто1.Ссылка И (ХозрасчетныйВидыСубконто1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто2
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто2.Ссылка И (ХозрасчетныйВидыСубконто2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто3
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто3.Ссылка И (ХозрасчетныйВидыСубконто3.НомерСтроки = 3)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаЦФ = ЦелевоеФинансирование[Выборка.ИндексСтроки];
		ЗаполнитьЗначенияСвойств(СтрокаЦФ, Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеСчетовЦелевогоФинансирования(Отказ)
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Организация", ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("СчетУчета", ЭтотОбъект.СчетУчетаЦФ);
	Запрос.УстановитьПараметр("СчетАмортизации", ЭтотОбъект.СчетАмортизацииЦФ);
	Запрос.УстановитьПараметр("ОсновныеСредства", ЭтотОбъект.ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПорядокУчетаОС.ОсновноеСредство,
	|	ПорядокУчетаОС.СчетУчета,
	|	ПорядокУчетаОС.СчетНачисленияАмортизации
	|ПОМЕСТИТЬ втСчета
	|ИЗ
	|	РегистрСведений.ПорядокУчетаОС.СрезПоследних(
	|			&Дата,
	|			Регистратор <> &Ссылка
	|				И ОсновноеСредство В (&ОсновныеСредства)) КАК ПорядокУчетаОС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	втСчета.СчетУчета
	|ИЗ
	|	втСчета КАК втСчета
	|ГДЕ
	|	втСчета.СчетУчета = &СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	втСчета.СчетНачисленияАмортизации
	|ИЗ
	|	втСчета КАК втСчета
	|ГДЕ
	|	втСчета.СчетНачисленияАмортизации = &СчетАмортизации";
	
	Пакет = Запрос.ВыполнитьПакет();
	
	Если Не Пакет[1].Пустой() Тогда
		
		ШаблонОшибки = НСтр("ru = 'Счет ""%1"" уже используется в качестве счета учета стоимости для одного или нескольких основных средств.
			|Требуется выбрать другой счет учета целевых средств в восстановительной стоимости ОС.';
			|en = 'Account ""%1"" is already used as a GL account of cost for one or several fixed assets.
			|Choose another GL account of special-purpose funds in FA replacement cost.'");
		ШаблонОшибки = СтрШаблон(ШаблонОшибки, ЭтотОбъект.СчетУчетаЦФ);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ШаблонОшибки, ЭтотОбъект, "СчетУчетаЦФ",, Отказ);
		
	КонецЕсли;
	
	Если Не Пакет[2].Пустой() Тогда
		
		ШаблонОшибки = НСтр("ru = 'Счет ""%1"" уже используется в качестве счета накопленной амортизации для одного или нескольких основных средств.
			|Требуется выбрать другой счет учета целевых средств в накопленной амортизации ОС.';
			|en = 'Account ""%1"" is already used as an accumulated depreciation account for one or several fixed assets.
			|Choose another GL account of special-purpose funds in FA accumulated depreciation.'");
		ШаблонОшибки = СтрШаблон(ШаблонОшибки, ЭтотОбъект.СчетАмортизацииЦФ);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ШаблонОшибки, ЭтотОбъект, "СчетАмортизацииЦФ",, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли