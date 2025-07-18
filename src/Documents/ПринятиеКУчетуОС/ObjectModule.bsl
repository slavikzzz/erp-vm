#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения.ДокументОснование);
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		ЗаполнитьНаОснованииИнвентаризацииОС(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаключениеДоговораАренды") Тогда
		ЗаполнитьНаОснованииПоступленияПредметовЛизинга(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиУчетаНалогаНаПрибыль",
		Организация,
		Дата);
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	Если ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.Распределение
		Или Не ЗначениеЗаполнено(ВариантРаздельногоУчетаНДС) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	Если ПорядокУчетаБУ <> Перечисления.ПорядокПогашенияСтоимостиОС.АмортизацияНачислена Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьПР");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьВР");
	КонецЕсли;
	
	Если ПорядокУчетаБУ <> Перечисления.ПорядокПогашенияСтоимостиОС.АмортизацияНачислена 
		И НЕ (СпособПоступления = Перечисления.СпособыПоступленияАктивов.ПоДоговоруЛизинга
				И ПараметрыУчетнойПолитики <> Неопределено 
				И ПараметрыУчетнойПолитики.ВключатьВСоставНалоговыхРасходовАрендныеПлатежи) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьНУ");
	КонецЕсли;
	
	Если ПорядокУчетаБУ = Перечисления.ПорядокПогашенияСтоимостиОС.НачислениеАмортизации
		Или ПорядокУчетаБУ = Перечисления.ПорядокПогашенияСтоимостиОС.АмортизацияНачислена Тогда
		
		Если МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка Тогда
			МассивНепроверяемыхРеквизитов.Добавить("КоэффициентУскоренияБУ");
		КонецЕсли;
		Если МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.Линейный
			И МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПоСуммеЧиселЛетИспользования
			И МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияБУ");
		КонецЕсли;
		Если МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФ
			И МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФНа1000кмПробега Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ГодоваяНормаАмортизацииБУ");
		КонецЕсли;
		Если МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФНа1000кмПробега
			И МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("ОС.ОбъемНаработки");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.ПоказательНаработки");
			
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииБУ");
		
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентУскоренияБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ГодоваяНормаАмортизацииБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.ОбъемНаработки");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.ПоказательНаработки");
		
	КонецЕсли;
	
	Если НЕ УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокВключенияСтоимостиВСоставРасходовНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияНУ");
		
	КонецЕсли;
	
	Если ПорядокУчетаНУ <> Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации
		И ПорядокУчетаНУ <> Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.АмортизацияНачислена Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
		
	КонецЕсли;
	
	Если ПорядокУчетаБУ = Перечисления.ПорядокПогашенияСтоимостиОС.СтоимостьНеПогашается Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
	КонецЕсли;
	
	Если ПорядокУчетаНУ <> Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации
		Или Не ВключитьАмортизационнуюПремиюВСоставРасходов Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПроцентКапитальныхВложенийВключаемыхВРасходыНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовАмортизационнойПремии");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовАмортизационнойПремии");
		
	КонецЕсли;
	
	ТребуетсяНастройкаОтраженияРасходовПоНалогам = ВнеоборотныеАктивыЛокализация.ТребуетсяНастройкаОтраженияРасходовПоНалогам(
													Организация, 
													Дата, 
													ОС.ВыгрузитьКолонку("ОсновноеСредство"),
													ГруппаОС, 
													АмортизационнаяГруппа);
	
	Если Не ТребуетсяНастройкаОтраженияРасходовПоНалогам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовНалог");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовНалог");
	КонецЕсли;
	
	Если Не ПередаватьРасходыВДругуюОрганизацию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучательРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетПередачиРасходов");
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ПроверитьГрафикАмортизации(Отказ);
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Счет");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	КонецЕсли;
	
	Если НЕ (ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное
				ИЛИ ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.Полное
				ИЛИ ДокументНаОснованииИнвентаризации) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаДоходов");
	КонецЕсли; 
	
	Если ВариантПримененияЦелевогоФинансирования <> Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	КонецЕсли;
	
	Если ГруппаОС = Перечисления.ГруппыОС.ЗемельныеУчастки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("АмортизационнаяГруппа");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ТаблицаОС = ЭтотОбъект.ОС.Выгрузить();
	
	Если ПорядокУчетаБУ = Перечисления.ПорядокПогашенияСтоимостиОС.СтоимостьНеПогашается Тогда
		
		НачислятьАмортизациюБУ = Ложь;
		
		МетодНачисленияАмортизацииБУ = Неопределено;
		СрокИспользованияБУ = 0;
		КоэффициентУскоренияБУ = 0;
		ГодоваяНормаАмортизацииБУ = 0;
		
		СтатьяРасходов = Неопределено;
		АналитикаРасходов = Неопределено;
		ПередаватьРасходыВДругуюОрганизацию = Ложь;
		ОрганизацияПолучательРасходов = Неопределено;
		СчетПередачиРасходов = Неопределено;
		
	КонецЕсли;
	
	Если ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету
		Или ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.СтоимостьНеВключаетсяВРасходы Тогда
		НачислятьАмортизациюНУ = Ложь;
		
		СтатьяРасходовАмортизационнойПремии = Неопределено;
		АналитикаРасходовАмортизационнойПремии = Неопределено;
		ВключитьАмортизационнуюПремиюВСоставРасходов = Ложь;
		ПроцентКапитальныхВложенийВключаемыхВРасходыНУ = 0;
	КонецЕсли;
	
	Если МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции
		И МетодНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФНа1000кмПробега Тогда
		
		ТаблицаОС.ЗаполнитьЗначения(Неопределено, "ПоказательНаработки, ОбъемНаработки");
		
	КонецЕсли;
	
	Если ПорядокУчетаБУ <> Перечисления.ПорядокПогашенияСтоимостиОС.АмортизацияНачислена
		И Не ДокументНаОснованииИнвентаризации Тогда
		
		ТаблицаОС.ЗаполнитьЗначения(Неопределено, "СтоимостьБУ, СтоимостьБУ, СтоимостьПР, СтоимостьВР");
		
	КонецЕсли;
	
	ЗаполнитьСуммыЦелевыхСредств(ТаблицаОС);
	
	ЭтотОбъект.ОС.Загрузить(ТаблицаОС);
	
	ЦелевоеФинансированиеОчиститьСубконто();
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиУчетаНДС", Организация, Дата);
	РаздельныйУчетВНАПоНалогообложениюНДС = ПараметрыУчетнойПолитики <> Неопределено И ПараметрыУчетнойПолитики.РаздельныйУчетВНАПоНалогообложениюНДС;
	Если НЕ РаздельныйУчетВНАПоНалогообложениюНДС Тогда
		
		ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента;
		НалогообложениеНДС = ВнеоборотныеАктивы.НалогообложениеНДС(Организация, Дата);
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект, "Хозрасчетный, ПервоначальныеСведенияОС");
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетОСВызовСервера.ПроверитьВозможностьИзмененияСостоянияОС(
		ЭтотОбъект.ОС.Выгрузить(),
		ТаблицаРеквизитов,
		Отказ);
		
	ПроверитьСпособПоступленияОС(Отказ);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОбновлениеОбъектовЭксплуатацииПриПроведении(Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	ДокументНаОсновании = ЗначениеЗаполнено(ДокументОснование);
	ДокументНаОснованииИнвентаризации = (ДокументНаОсновании И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ИнвентаризацияОС"));
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	НачислятьАмортизациюБУ = Истина;
	НачислятьАмортизациюНУ = Истина;
	
	Если Не ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОСВызовСервера.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ПринятиеКУчетуСВводомВЭксплуатацию);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		НалогообложениеНДС = ВнеоборотныеАктивы.НалогообложениеНДС(Организация, Дата);
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииИнвентаризацииОС(Знач ДанныеЗаполнения)
	
	ДокументОснование = Неопределено;
	МассивНомеровСтрок = Неопределено;
	СообщатьОбОшибках = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
		МассивНомеровСтрок = ДанныеЗаполнения.МассивНомеровСтрок;
		СообщатьОбОшибках = ДанныеЗаполнения.СообщатьОбОшибках;
	Иначе
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = Документы.ИнвентаризацияОС.ДанныеЗаполненияНаОснованииИнвентаризации22(ДокументОснование, "ПринятиеКУчету", МассивНомеровСтрок);
	Если РезультатЗапроса.ТабличнаяЧасть = Неопределено Или РезультатЗапроса.ТабличнаяЧасть.Пустой() Тогда
		Если СообщатьОбОшибках Тогда
			ТекстОшибки = НСтр("ru = 'В документе %1 отсутствуют строки требующие заполнения перемещения';
								|en = 'No lines which require transfer population in the %1 document'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ДокументОснование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ДокументОснование");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Реквизиты.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	СпособПоступления = Перечисления.СпособыПоступленияАктивов.Иное;
	
	Выборка = РезультатЗапроса.ТабличнаяЧасть.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Подразделение) Тогда
			Подразделение = Выборка.Подразделение;
			Местонахождение = Выборка.Подразделение;
			ГруппаОС = Выборка.ГруппаОС;
		КонецЕсли;
		
		Если Подразделение = Выборка.Подразделение
			И ГруппаОС = Выборка.ГруппаОС Тогда
			
			НоваяСтрока = ОС.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.СтоимостьБУ = Выборка.СтоимостьФактическая;
			НоваяСтрока.СтоимостьНУ = НоваяСтрока.СтоимостьБУ;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПоступленияПредметовЛизинга(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЗаключениеДоговораАренды.Организация,
	|	ЗаключениеДоговораАренды.Подразделение,
	|	ЗаключениеДоговораАренды.Договор.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ЗаключениеДоговораАренды.Ссылка КАК ДокументОснование,
	|	ИСТИНА КАК ДокументНаОсновании
	|ИЗ
	|	Документ.ЗаключениеДоговораАренды КАК ЗаключениеДоговораАренды
	|ГДЕ
	|	ЗаключениеДоговораАренды.Ссылка = &ДанныеЗаполнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаключениеДоговораАрендыОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЗаключениеДоговораАрендыОС.ОсновноеСредство.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ЗаключениеДоговораАрендыОС.ОсновноеСредство.ГруппаОС КАК ГруппаОС
	|ИЗ
	|	Документ.ЗаключениеДоговораАренды.ОС КАК ЗаключениеДоговораАрендыОС
	|ГДЕ
	|	ЗаключениеДоговораАрендыОС.Ссылка = &ДанныеЗаполнения";
	
	Пакет = Запрос.ВыполнитьПакет();
	
	Выборка = Пакет[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	СписокОС = Новый Массив;
	Выборка = Пакет[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ГруппаОС) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ОС.Добавить(), Выборка);
		СписокОС.Добавить(Выборка.ОсновноеСредство);
	КонецЦикла;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиУчетаНалогаНаПрибыль",
		Организация,
		ДатаДокумента);
		
	Если ПараметрыУчетнойПолитики <> Неопределено
		И ПараметрыУчетнойПолитики.ВключатьВСоставНалоговыхРасходовАрендныеПлатежи Тогда
		СтоимостьОС = Документы.ЗаключениеДоговораАренды.СтоимостьПредметовАренды(СписокОС, Организация, ДатаДокумента);
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.СтоимостьНУ = СтоимостьОС.Получить(ДанныеСтроки.ОсновноеСредство);
		КонецЦикла;
	КонецЕсли; 
	
	СпособПоступления = Перечисления.СпособыПоступленияАктивов.ПоДоговоруЛизинга;
	СчетУчета = ПланыСчетов.Хозрасчетный.АрендованноеИмущество;
	СчетАмортизации = ПланыСчетов.Хозрасчетный.АмортизацияАрендованногоИмущества;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Принятие к учету ОС на основании группы ОС невозможен!
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз';
			|en = 'Unable to recognize FA based on FA group.
			|Select FA. To open a group, press Ctrl and the down arrow'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ОрганизацияОС = УчетОСВызовСервера.ОрганизацияВКоторойОСПринятоКУчету(Основание);
	
	Если ЗначениеЗаполнено(ОрганизацияОС) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" уже принято к учету.';
										|en = 'The ""%1"" fixed asset is already recognized.'"), Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", Основание);
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ОбъектыЭксплуатации.ИнвентарныйНомер <> """"
	|			ТОГДА ОбъектыЭксплуатации.ИнвентарныйНомер
	|		ИНАЧЕ ОбъектыЭксплуатации.Код
	|	КОНЕЦ КАК ИнвентарныйНомер,
	|	ОбъектыЭксплуатации.ГруппаОС КАК ГруппаОС
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка = &ОсновноеСредство";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Реквизиты.Ссылка КАК Регистратор,
		|	Реквизиты.Дата КАК Период,
		|	Реквизиты.Номер,
		|	Реквизиты.Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка
		|ИЗ
		|	Документ.ПринятиеКУчетуОС КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ПроверитьГрафикАмортизации(Отказ)
	
	Если МетодНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции
		Или МетодНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФНа1000кмПробега
		Или Не ЗначениеЗаполнено(ГрафикАмортизации) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент1,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент2,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент3,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент4,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент5,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент6,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент7,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент8,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент9,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент10,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент11,
		|	ГодовыеГрафикиАмортизацииОС.Коэффициент12
		|ИЗ
		|	Справочник.ГодовыеГрафикиАмортизацииОС КАК ГодовыеГрафикиАмортизацииОС
		|ГДЕ
		|	ГодовыеГрафикиАмортизацииОС.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ГрафикАмортизации);
	Результат = Запрос.Выполнить();
	ВыборкаГрафика = Результат.Выбрать();
	ВыборкаГрафика.Следующий();
	
	СуммаКоэффициентов1 = 0;
	СуммаКоэффициентов2 = 0;
	СуммаКоэффициентов3 = 0;
	
	МесяцНачала = Месяц(Дата);
	МесяцНачала = ?(МесяцНачала=12, 1, МесяцНачала+1);
	МесяцЗавершения = Месяц(ДобавитьМесяц(Дата, СрокИспользованияБУ));
	
	Для МесяцНачисления = 1 По 12 Цикл
		Коэффициент = ВыборкаГрафика["Коэффициент" + МесяцНачисления];
		
		Если МесяцНачисления <= МесяцЗавершения Тогда
			СуммаКоэффициентов3 = СуммаКоэффициентов3 + Коэффициент;
		КонецЕсли;
		
		Если МесяцНачисления >= МесяцНачала Тогда
			СуммаКоэффициентов1 = СуммаКоэффициентов1 + Коэффициент;
		КонецЕсли;
		
		Если МесяцНачисления >= МесяцНачала И МесяцНачисления <= МесяцЗавершения Тогда
			СуммаКоэффициентов2 = СуммаКоэффициентов2 + Коэффициент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СрокИспользованияБУ<12 Или (Месяц(Дата)+СрокИспользованияБУ)<12 Тогда
		Если СуммаКоэффициентов2=0 Тогда
			
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'График амортизации не содержит коэффицентов распределения, соответствующих заданному периоду эксплуатации ОС.
				|Выберите другой график амортизации или срок полезного использования';
				|en = 'The depreciation schedule does not contain allocation coefficients which correspond to the selected FA operation period.
				|Choose another depreciation schedule or useful life. '"),
				ЭтотОбъект,
				"ГрафикАмортизации");
			
		КонецЕсли;
	Иначе
		Если СуммаКоэффициентов1=0 Тогда
			
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'График амортизации не содержит коэффицентов распределения для первого года периода эксплуатации ОС.
				|Выберите другой график амортизации или срок полезного использования';
				|en = 'The depreciation schedule does not contain allocation coefficients for the first year of FA use period.
				|Choose another depreciation schedule or useful life. '"),
				ЭтотОбъект,
				"ГрафикАмортизации");
			
		ИначеЕсли СуммаКоэффициентов3=0 Тогда
			
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'График амортизации не содержит коэффицентов распределения для последнего года периода эксплуатации ОС.
				|Выберите другой график амортизации или срок полезного использования';
				|en = 'The depreciation schedule does not contain allocation coefficients for the last year of FA operation period.
				|Choose another depreciation schedule or useful life. '"),
				ЭтотОбъект,
				"ГрафикАмортизации");
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

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

Процедура ОбновлениеОбъектовЭксплуатацииПриПроведении(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектыЭксплуатации", ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.УстановитьПараметр("КодПоОКОФ", КодПоОКОФ);
	Запрос.УстановитьПараметр("ШифрПоЕНАОФ", ШифрПоЕНАОФ);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбъектыЭксплуатации.Ссылка
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка В(&ОбъектыЭксплуатации)
	|	И (ОбъектыЭксплуатации.ГруппаОС = ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ПустаяСсылка)
	|			ИЛИ ОбъектыЭксплуатации.ИнвентарныйНомер = """"
	|			ИЛИ ОбъектыЭксплуатации.КодПоОКОФ = ЗНАЧЕНИЕ(Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка)
	|				И &КодПоОКОФ <> ЗНАЧЕНИЕ(Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка)
	|			ИЛИ ОбъектыЭксплуатации.ШифрПоЕНАОФ = ЗНАЧЕНИЕ(Справочник.ЕдиныеНормыАмортизационныхОтчисленийОсновныхФондов.ПустаяСсылка)
	|				И &ШифрПоЕНАОФ <> ЗНАЧЕНИЕ(Справочник.ЕдиныеНормыАмортизационныхОтчисленийОсновныхФондов.ПустаяСсылка))";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ОбъектыЭксплуатации");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		ЭлементБлокировки.ИсточникДанных = Результат;
		Блокировка.Заблокировать();
		
	Исключение
		Отказ = Истина;
		
		ТекстСообщения = НСтр(
		"ru = 'Ошибка при попытке обновления группы ОС и амортизационной группы для принимаемых к учету объектов основных средств
		|%1';
		|en = 'An error occurred when trying to update the FA group and the depreciation group for the fixed assets to be recognized
		|%1'");
		
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Ссылка.Метаданные(),
			Ссылка,
			ТекстСообщения);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОС",, Отказ);
		
	КонецПопытки;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОбъектСправочника = Выборка.Ссылка.ПолучитьОбъект();
		Если Не ЗначениеЗаполнено(ОбъектСправочника.ИнвентарныйНомер) Тогда
			СтрокаТаблицы = ОС.Найти(Выборка.Ссылка, "ОсновноеСредство");
			ОбъектСправочника.ИнвентарныйНомер = СтрокаТаблицы.ИнвентарныйНомер;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ОбъектСправочника.ГруппаОС) Тогда
			ОбъектСправочника.ГруппаОС = ЭтотОбъект.ГруппаОС;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ОбъектСправочника.КодПоОКОФ)
			И ЗначениеЗаполнено(ЭтотОбъект.КодПоОКОФ) Тогда
			ОбъектСправочника.КодПоОКОФ = ЭтотОбъект.КодПоОКОФ;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ОбъектСправочника.ШифрПоЕНАОФ)
			И ЗначениеЗаполнено(ЭтотОбъект.ШифрПоЕНАОФ) Тогда
			ОбъектСправочника.ШифрПоЕНАОФ = ЭтотОбъект.ШифрПоЕНАОФ;
		КонецЕсли;
		Попытка
			ОбъектСправочника.Записать();
		Исключение
			ТекстСообщения = НСтр(
			"ru = 'Ошибка при попытке обновления реквизитов принимаемых к учету объектов основных средств
			|%1';
			|en = 'An error occurred when trying to update the attributes of the fixed assets to be recognized
			|%1'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Ссылка.Метаданные(),
				Ссылка,
				ТекстСообщения);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОС",, Отказ);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСпособПоступленияОС(Отказ)

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОбъектыЭксплуатации.Ссылка КАК ОсновноеСредство,
	|	ОбъектыЭксплуатации.Наименование КАК ОсновноеСредствоПредставление
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АрендованныеОС.СрезПоследних(
	|				&Период,
	|				Регистратор <> &Ссылка
	|					И ОсновноеСредство В (&СписокОС)) КАК АрендованныеОС
	|		ПО (АрендованныеОС.ОсновноеСредство = ОбъектыЭксплуатации.Ссылка)
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка В (&СписокОС)
	|	И (&СпособПоступления = ЗНАЧЕНИЕ(Перечисление.СпособыПоступленияАктивов.ПоДоговоруЛизинга)
	|			И (АрендованныеОС.Договор ЕСТЬ NULL
	|					ИЛИ АрендованныеОС.Договор = НЕОПРЕДЕЛЕНО
	|					ИЛИ ТИПЗНАЧЕНИЯ(ЕСТЬNULL(АрендованныеОС.Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка))) <> ТИП(Справочник.ДоговорыАренды)
	|					ИЛИ ЕСТЬNULL(АрендованныеОС.Договор, ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка)
	|				)
	|
	|		ИЛИ &СпособПоступления <> ЗНАЧЕНИЕ(Перечисление.СпособыПоступленияАктивов.ПоДоговоруЛизинга)
	|			И АрендованныеОС.Договор ССЫЛКА Справочник.ДоговорыАренды
	|			И АрендованныеОС.Договор <> ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка)
	|		)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", КонецДня(Дата));
	Запрос.УстановитьПараметр("СписокОС", ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.УстановитьПараметр("СпособПоступления", СпособПоступления);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособПоступления = Перечисления.СпособыПоступленияАктивов.ПоДоговоруЛизинга Тогда
		ШаблонСообщения = НСтр("ru = 'По основному средству ""%1"" не оформлено поступление предмета лизинга (строка %2 списка ""Основные средства"").';
								|en = 'Receipt of leasing item is not registered for the ""%1"" fixed asset (line %2 of the ""Fixed assets"" list).'");
	Иначе
		ШаблонСообщения = НСтр("ru = 'Основное средство ""%1"" поступило по договору лизинга (строка %2 списка ""Основные средства""). Необходимо выбрать способ поступления ""По договору лизинга"".';
								|en = 'The ""%1"" fixed asset has been received under the lease agreement (%2 line of the ""Fixed assets"" list). It is required to select the ""Under lease agreement"" receipt method.'");
	КонецЕсли;
	
	СписокОС = Результат.Выгрузить();
	Для каждого ДанныеСтроки Из ОС Цикл
		ПроблемноеОС = СписокОС.Найти(ДанныеСтроки.ОсновноеСредство, "ОсновноеСредство");
		Если ПроблемноеОС = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемноеОС.ОсновноеСредствоПредставление, Формат(ДанныеСтроки.НомерСтроки, "ЧГ="));
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
