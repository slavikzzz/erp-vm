#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")  Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПланСчетовМеждународногоУчета) Тогда
		ПланСчетовМеждународногоУчета = Справочники.ПланыСчетовМеждународногоУчета.ПланСчетовПоУмолчанию();
	КонецЕсли;
	//-- НЕ УТКА
	
	Возврат;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ИсточникСуммыОперации");
	МассивНепроверяемыхРеквизитов.Добавить("ТипИтога");
	
	Если НЕ ЗначениеЗаполнено(РазделИсточникаДанных) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИсточникДанных");
	КонецЕсли;
	
	Если РазделИсточникаДанных <> Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПланСчетовМеждународногоУчета");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НеЗаполненИсточникСуммыОперации = 
		РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет И Не ЗначениеЗаполнено(ИсточникСуммыОперации);
		
	НеЗаполненТипИтога = (РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет
						ИЛИ РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет)
						И Не ЗначениеЗаполнено(ТипИтога);
	
	Если НеЗаполненИсточникСуммыОперации Тогда
		ТекстСообщения = НСтр("ru = 'Поле Источник суммы не заполнено';
								|en = '""Amount source"" is required'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,"ИсточникСуммыОперации", "Запись", Отказ);
	КонецЕсли;
	Если НеЗаполненТипИтога Тогда
		ТекстСообщения = НСтр("ru = 'Поле Тип итога не заполнено';
								|en = '""Total type"" is required'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ,"ТипИтога", "Запись", Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Наименование = Строка(РазделИсточникаДанных) + ": " + ИсточникДанных;
	Если ЗначениеЗаполнено(КорСчет) Тогда
		Наименование = Наименование + ", " + КорСчет;
	КонецЕсли;
	Если ЗначениеЗаполнено(ИсточникСуммыОперации) Тогда
		Наименование = Наименование + ", " + ИсточникСуммыОперации;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТипИтога) Тогда
		Наименование = Наименование + ", " + ТипИтога;
	КонецЕсли;
	Если ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
		Наименование = Наименование + ", " + ПредставлениеОтбора;
	КонецЕсли;
	
	МаксимальноеКоличествоАналитик = БюджетированиеКлиентСервер.МаксимальноеКоличествоАналитик();
	Для Сч = 1 По МаксимальноеКоличествоАналитик Цикл
		
		Если ЭтотОбъект["ЗаполнятьУказаннымЗначениемАналитику" + Сч]
		   И ЗначениеЗаполнено(СтатьяБюджетов["ВидАналитики" + Сч]) Тогда
			
			ТипАналитики = СтатьяБюджетов["ВидАналитики" + Сч].ТипЗначения;
			ЭтотОбъект["ЗначениеАналитики" + Сч] = БюджетированиеКлиентСервер.ПриведенноеЗначениеАналитики(
				ЭтотОбъект["ЗначениеАналитики" + Сч],
				ТипАналитики);
				
		Иначе
			
			ЭтотОбъект["ЗначениеАналитики" + Сч] = БюджетированиеКлиентСервер.ПустоеЗначениеАналитики();
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Сделаем слепок настроек и схемы для будущего сравнения их между собой без анализа каждого элемента.
	Если Не ПометкаУдаления Тогда
		БюджетированиеСервер.ЗаполнитьРеквизитыХешейНастроекИСхемы(ЭтотОбъект);
	КонецЕсли;
	
	// Заполним настройки заполнения аналитик
	Если Не РасширенныйРежимНастройкиЗаполненияАналитики И Не ПометкаУдаления Тогда
		БюджетированиеСервер.ЗаполнитьРеквизитыОбъектаНастроекЗаполненияАналитики(ЭтотОбъект);
	КонецЕсли;
	
	УстановкаРеквизитовИсторииПереходаНаНовыеФормулы();
	
	ПроверкаИзмененияКэшированныхДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановкаРеквизитовИсторииПереходаНаНовыеФормулы()
	
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики1ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики1) Тогда
		ВыражениеЗаполненияАналитики1ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики1;
	КонецЕсли;
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики2ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики2) Тогда
		ВыражениеЗаполненияАналитики2ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики2;
	КонецЕсли;
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики3ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики3) Тогда
		ВыражениеЗаполненияАналитики2ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики3;
	КонецЕсли;
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики4ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики4) Тогда
		ВыражениеЗаполненияАналитики4ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики4;
	КонецЕсли;
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики5ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики5) Тогда
		ВыражениеЗаполненияАналитики5ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики5;
	КонецЕсли;
	Если ПустаяСтрока(ВыражениеЗаполненияАналитики6ИсторияПереходаНаНовыеФормулы)
		И НЕ ПустаяСтрока(ВыражениеЗаполненияАналитики6) Тогда
		ВыражениеЗаполненияАналитики6ИсторияПереходаНаНовыеФормулы = ВыражениеЗаполненияАналитики6;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаИзмененияКэшированныхДанных()
	
	ОчищатьКэшИменДокументов = Ложь;
	ОчищатьКэшВидовБюджетов  = Ложь;
	
	Если НЕ ЭтоНовый() Тогда
		
		ПредыдущиеПараметрыОтраженияДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ПромежуточноеКэшированиеРезультатовРаботыПравил, ИсточникДанных, РазделИсточникаДанных, ТипПравила, ХешСхемыКомпоновкиДанных, ПометкаУдаления");
		
		Если ПромежуточноеКэшированиеРезультатовРаботыПравил
			ИЛИ ПредыдущиеПараметрыОтраженияДокументов["ПромежуточноеКэшированиеРезультатовРаботыПравил"] Тогда
			
			Для каждого КлючИЗначение Из ПредыдущиеПараметрыОтраженияДокументов Цикл
				Если ЭтотОбъект[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
					Если КлючИЗначение.Ключ = "ПромежуточноеКэшированиеРезультатовРаботыПравил" Тогда
						ОчищатьКэшИменДокументов = Истина;
						ОчищатьКэшВидовБюджетов  = Истина;
					ИначеЕсли КлючИЗначение.Ключ = "ПометкаУдаления" Тогда
						ОчищатьКэшВидовБюджетов  = Истина;
					Иначе
						ОчищатьКэшИменДокументов = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ЭтоНовый()
		И ПромежуточноеКэшированиеРезультатовРаботыПравил Тогда
		ОчищатьКэшВидовБюджетов = Истина;
	КонецЕсли;
	
	Если ОчищатьКэшИменДокументов Тогда
		ИменаОтражаемыхДокументов = РегистрыСведений.КэшИменДокументовДляОбработкиПоПравилу.СоздатьНаборЗаписей();
		ИменаОтражаемыхДокументов.Отбор.Правило.Установить(Ссылка);
		УстановитьПривилегированныйРежим(Истина);
		ИменаОтражаемыхДокументов.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	Если ОчищатьКэшВидовБюджетов Тогда
		ИспользующиеВидыБюджета = ПолучитьИспользующиеПравилоВидыБюджета();
		Для каждого ВидБюджета Из ИспользующиеВидыБюджета Цикл
			НаборПоВидуБюджета = РегистрыСведений.КэшВспомогательныхДанныхВидаБюджета.СоздатьНаборЗаписей();
			НаборПоВидуБюджета.Отбор.ВидБюджета.Установить(ВидБюджета);
			УстановитьПривилегированныйРежим(Истина);
			НаборПоВидуБюджета.Записать(Истина);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИспользующиеПравилоВидыБюджета()
	
	// Правило получения фактических данных по статье может использоваться в кэше
	// для получения факта по статье или как факт, влияющий на показатель.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтатьяБюджетов", СтатьяБюджетов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СвязиПоказателейБюджетов.СвязанныйПоказательБюджетов КАК СтатьяПоказатель
	|ПОМЕСТИТЬ СтатьиИПоказатели
	|ИЗ
	|	РегистрСведений.СвязиПоказателейБюджетов КАК СвязиПоказателейБюджетов
	|ГДЕ
	|	СвязиПоказателейБюджетов.СтатьяБюджетов = &СтатьяБюджетов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтатьиБюджетов.Ссылка
	|ИЗ
	|	Справочник.СтатьиБюджетов КАК СтатьиБюджетов
	|ГДЕ
	|	СтатьиБюджетов.Ссылка = &СтатьяБюджетов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СтатьяПоказатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыБюджетовКэшСтатейИПоказателей.Ссылка КАК ВидБюджета
	|ИЗ
	|	Справочник.ВидыБюджетов.КэшСтатейИПоказателей КАК ВидыБюджетовКэшСтатейИПоказателей
	|ГДЕ
	|	ВидыБюджетовКэшСтатейИПоказателей.СтатьяПоказатель В
	|			(ВЫБРАТЬ
	|				Т.СтатьяПоказатель
	|			ИЗ
	|				СтатьиИПоказатели КАК Т)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидБюджета");
	
КонецФункции

#КонецОбласти

#КонецЕсли
