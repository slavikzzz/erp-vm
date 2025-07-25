#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(Знач ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Основание") Тогда
		ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения.Основание);
		
		Если ДанныеЗаполнения.Свойство("СуммаНедопоставки") Тогда
			Сумма = ДанныеЗаполнения.СуммаНедопоставки;
			ВестиРасчетыПоПретензии = Истина;
		КонецЕсли;
		
		ДанныеЗаполнения = ДанныеЗаполнения.Основание;
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			
			Партнер = ДанныеЗаполнения.Партнер;
			ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
			
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Ответственный") Тогда
			
			Ответственный = ДанныеЗаполнения.Ответственный;
			
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.АктВыполненныхРабот")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказКлиента")
		//++ НЕ УТ

		//++ Устарело_Переработка24
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику")
		//-- Устарело_Переработка24
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику2_5")
		//-- НЕ УТ

		//++ НЕ УТКА
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказДавальца2_5")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетДавальцу2_5")
		//-- НЕ УТКА
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионера")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПередачаТоваровХранителю")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Партнер, КонтактноеЛицо, Организация, Контрагент, Договор");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
		ЗаполнитьРеквизитыПоДоговору();
		Если ЗначениеЗаполнено(РеквизитыОснования.КонтактноеЛицо) И ПартнерыИКонтактныеЛица.Количество() = 0 Тогда
			НоваяСтрока = ПартнерыИКонтактныеЛица.Добавить();
			НоваяСтрока.Партнер = Партнер;
			НоваяСтрока.КонтактноеЛицо = РеквизитыОснования.КонтактноеЛицо;
		КонецЕсли;
		Основание = ДанныеЗаполнения;
		Если НЕ ЗначениеЗаполнено(Валюта) Тогда
			Если ТипДанныхЗаполнения = Тип("ДокументСсылка.АктВыполненныхРабот")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ВалютаВзаиморасчетов");
				
			ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказКлиента")
				//++ НЕ УТ

				//++ Устарело_Переработка24
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику")
				//-- Устарело_Переработка24
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику2_5")
				//-- НЕ УТ
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионера")
				ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПередачаТоваровХранителю") Тогда
				Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Валюта");
			КонецЕслИ;
		КонецЕсли;
		
	ИначеЕсли  ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионераОСписании")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаРеализации")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаПриобретения")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов") Тогда
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Партнер, Организация, Контрагент, Договор");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
		ЗаполнитьРеквизитыПоДоговору();
		Основание = ДанныеЗаполнения;
		Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
			ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов") Тогда
			Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ВалютаВзаиморасчетов");
			
		ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионераОСписании")
			ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаРеализации")
			ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаПриобретения") Тогда
			Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Валюта");
		КонецЕслИ;
		
	ИначеЕсли  ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Перевозчик, Контрагент");
		Партнер = РеквизитыОснования.Перевозчик;
		Основание = ДанныеЗаполнения;
		
	ИначеЕсли  ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		
		Партнер = ДанныеЗаполнения;
		ПродажиСервер.ПроверитьВозможностьВводаНаОснованииПартнераКлиента(Партнер);
		
	ИначеЕсли ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ДанныеЗаполнения) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
			
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Текст, Тема");
			ОписаниеПретензии  = РеквизитыОснования.Текст;
			Наименование       = РеквизитыОснования.Тема;
		Иначе
			ОписаниеПретензии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Описание");
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СделкиСКлиентами") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СделкиСКлиентами.Партнер КАК Партнер
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &Сделка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.Партнер,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.РольПартнера,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.КонтактноеЛицо,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.РольКонтактногоЛица
		|ИЗ
		|	Справочник.СделкиСКлиентами.ПартнерыИКонтактныеЛица КАК СделкиСКлиентамиПартнерыИКонтактныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО СделкиСКлиентамиПартнерыИКонтактныеЛица.Ссылка = СделкиСКлиентами.Ссылка
		|			И СделкиСКлиентамиПартнерыИКонтактныеЛица.Партнер = СделкиСКлиентами.Партнер
		|	И  СделкиСКлиентами.Ссылка = &Сделка
		|";
		
		Запрос.УстановитьПараметр("Сделка", ДанныеЗаполнения);
		
		Результат = Запрос.ВыполнитьПакет();
		ВыборкаПартнер = Результат[0].Выбрать();
		
		Если ВыборкаПартнер.Следующий() Тогда
			
			Партнер = ВыборкаПартнер.Партнер;
			
		КонецЕсли;
		
		ПартнерыИКонтактныеЛица.Загрузить(Результат[1].Выгрузить());
		
	КонецЕсли;
	
	ЭтоПретензияПоставщику = ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаданиеНаПеревозку")
		//++ НЕ УТ

		//++ Устарело_Переработка24
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику")
		//-- Устарело_Переработка24
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПереработчику2_5")
		//-- НЕ УТ
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаПриобретения")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов");
	
		
	Если НЕ ЗначениеЗаполнено(ДатаРегистрации) Тогда
		ДатаРегистрации = ТекущаяДатаСеанса();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаВозникновения");
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована ИЛИ Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончания");
		МассивНепроверяемыхРеквизитов.Добавить("РезультатыОтработки");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПартнерыИКонтактныеЛица.Партнер");
		Для ТекИндекс = 0 По ПартнерыИКонтактныеЛица.Количество() - 1 Цикл
			Если Не ЗначениеЗаполнено(ПартнерыИКонтактныеЛица[ТекИндекс].Партнер) Тогда
				
				АдресОшибки = " " + НСтр("ru = 'в строке %НомерСтроки% списка ""Участники""';
										|en = 'in line %НомерСтроки% of the ""Participants"" list'");
				АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", ПартнерыИКонтактныеЛица[ТекИндекс]["НомерСтроки"]);
				
				ТекстОшибки = НСтр("ru = 'Не заполнена колонка ""Контрагент""';
									|en = 'Column ""Counterparty"" is not filled in'");
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки + АдресОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПартнерыИКонтактныеЛица", ПартнерыИКонтактныеЛица[ТекИндекс].НомерСтроки, "Партнер"),
					,
					Отказ);
					
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Партнер) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		ТекстОшибки = НСтр("ru = 'Поле ""Клиент"" не заполнено';
							|en = '""Customer"" is required'");
		Если ЭтоПретензияПоставщику Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Поставщик"" не заполнено';
								|en = '""Vendor"" is required'");
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Партнер",
			,
			Отказ);
	КонецЕсли;
	
	Если НЕ ВестиРасчетыПоПретензии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПустаяСтрока(Код) Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = Справочники.Претензии.АвтоНаименование(ЭтотОбъект);
	КонецЕсли;
	
	Если (Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована)
	     Или (Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается) Тогда
		ДатаОкончания = Дата(1, 1, 1);
	КонецЕсли;
	
	Если ВестиРасчетыПоПретензии Тогда
		ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ);
	ИначеЕсли ЗначениеЗаполнено(ОбъектРасчетов) Тогда
		ОбъектыРасчетовСервер.ПроверитьУдалитьОбъектРасчетов(ОбъектРасчетов, Отказ, Истина);
		ГруппаФинансовогоУчета = Неопределено;
		ОбъектРасчетов = Неопределено;
		Организация = Неопределено;
		Контрагент = Неопределено;
		Договор = Неопределено;
		Валюта = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПретензияАктивна = (Не ПометкаУдаления) И ((Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована)
	                   Или (Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается));
	
	Взаимодействия.УстановитьПризнакАктивен(Ссылка, ПретензияАктивна);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоДоговору()
		
	Если НЕ Договор.Пустая() Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "ВалютаВзаиморасчетов,НаправлениеДеятельности,ГруппаФинансовогоУчета");
		Валюта = РеквизитыДоговора.ВалютаВзаиморасчетов;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДоговора);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
