#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		
		ЗаполнитьНаОснованииПартнера(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СоглашенияСКлиентами")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СоглашенияСПоставщиками") Тогда
		
		ЗаполнитьНаОснованииСоглашения(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ОрганизацияОтбора") Тогда
			ДанныеЗаполнения.Вставить("Организация", ДанныеЗаполнения.ОрганизацияОтбора);
		КонецЕсли;
		ЗаполнитьПоОтбору(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьСправочник(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Дата начала действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru = 'Дата начала действия договора должна быть не меньше даты договора';
								|en = 'Contract effective date cannot be less than the contract date'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru = 'Дата окончания действия договора должна быть не меньше даты договора';
								|en = 'Contract expiration date cannot be less than the contract date'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru = 'Дата окончания действия договора должна быть не меньше даты начала действия';
								|en = 'Contract expiration date cannot be less than contract effective date'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	
	Если НЕ ЗначениеЗаполнено(Партнер) Тогда
		
		ТекстОшибки = НСтр("ru = 'Поле ""%1"" не заполнено';
							|en = 'Field %1 is required'");
		ЗаголовокПартнер = ПартнерыИКонтрагенты.ЗаголовокРеквизитаПартнерВЗависимостиОтХозяйственнойОперации(ХозяйственнаяОперация);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЗаголовокПартнер);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект, 
			"Партнер",
			,
			Отказ);
			
	Иначе

		ОперацииЗакупки						  = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
		ОперацииИмпорта						  = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);
		ОперацииВСтранахЕАЭС 				  = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС);
		ОперацииПроизводстваУПереработчика2_5 = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика2_5);
		
		ФлагиПартнера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Партнер, "Клиент, Поставщик");
		
		Если ФлагиПартнера.Клиент <> Истина И ФлагиПартнера.Поставщик <> Истина Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для выбранного партнера должен быть установлен признак ""Клиент/Поставщик""';
					|en = 'The selected partner must have the Customer/Vendor checkbox selected'"),
				ЭтотОбъект, 
				"Партнер",
				,
				Отказ);
			
		ИначеЕсли ФлагиПартнера.Клиент <> Истина 
					И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
					
						//++ НЕ УТКА
						//++ Устарело_Переработка24
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья
						//-- Устарело_Переработка24
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья2_5
						//-- НЕ УТКА
						
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоставкаПодПринципала
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для выбранного партнера должен быть установлен признак ""Клиент""';
					|en = 'The selected partner must have the Customer checkbox selected'"),
				ЭтотОбъект, 
				"Партнер",
				,
				Отказ);
			
		ИначеЕсли ФлагиПартнера.Поставщик <> Истина
					И (ОперацииЗакупки.Найти(ХозяйственнаяОперация) <> Неопределено
						Или ОперацииИмпорта.Найти(ХозяйственнаяОперация) <> Неопределено
						Или ОперацииВСтранахЕАЭС.Найти(ХозяйственнаяОперация) <> Неопределено
						
						//++ НЕ УТ
						//++ Устарело_Переработка24
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика
						//-- Устарело_Переработка24
						Или ОперацииПроизводстваУПереработчика2_5.Найти(ХозяйственнаяОперация) <> Неопределено
						//-- НЕ УТ

						//++ НЕ УТКА
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья2_5
						//-- НЕ УТКА
						
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
						Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для выбранного партнера должен быть установлен признак ""Поставщик""';
					|en = 'The selected partner must have the Vendor checkbox selected'"),
				ЭтотОбъект, 
				"Партнер",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не УчетАгентскогоНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидАгентскогоДоговора");
	КонецЕсли;
	
	Если Не ТипДоговора = Перечисления.ТипыДоговоров.РеализацияЧерезКомиссионера Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КомиссионерПартнер");
		МассивНепроверяемыхРеквизитов.Добавить("КомиссионерКонтрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорСКомиссионером");
	КонецЕсли;
	
	ИспользоватьОформлениеЗакупок = (ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
		Или ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
		Или ТипДоговора = Перечисления.ТипыДоговоров.Импорт);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой")
		Или СпособДоставки = Перечисления.СпособыДоставки.ОпределяетсяВРаспоряжении
		Или Не ИспользоватьОформлениеЗакупок Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособДоставки");
		МассивНепроверяемыхРеквизитов.Добавить("ПеревозчикПартнер");
		МассивНепроверяемыхРеквизитов.Добавить("АдресДоставкиПеревозчика");
	КонецЕсли;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	Если НалогообложениеНДСОпределяетсяВДокументе 
		Или ТипДоговора = Перечисления.ТипыДоговоров.Импорт
		//++ Устарело_Переработка24
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
		//-- Устарело_Переработка24
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5 
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	Если ЗакупкаПодДеятельностьОпределяетсяВДокументе
		Или (ТипДоговора <> Перечисления.ТипыДоговоров.СПоставщиком
			//++ Устарело_Переработка24
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПереработчиком
			//-- Устарело_Переработка24
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПереработчиком2_5
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПоклажедателем) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗакупкаПодДеятельность");
	КонецЕсли;
	
	Если ТипДоговора <> Перечисления.ТипыДоговоров.СПоклажедателем Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокОформленияСписанияНедостачТоваровПринятыхНаХранение");
		//++ НЕ УТ
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокОформленияСписанияВПроизводствоТоваровПринятыхНаХранение");
		//-- НЕ УТ
	КонецЕсли;
	
	//++ НЕ УТКА
	Если ТипДоговора <> Перечисления.ТипыДоговоров.СДавальцем
		И ТипДоговора <> Перечисления.ТипыДоговоров.СДавальцем2_5 Тогда
	//-- НЕ УТКА
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	//++ НЕ УТКА
	КонецЕсли;
	//-- НЕ УТКА
	
	Если ТипДоговора <> Перечисления.ТипыДоговоров.Субаренда Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорАренды");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	ДоговорыКонтрагентовЛокализация.ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, ЭтотОбъект);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		И ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку Тогда
		РеквизитыНаправленияДеятельности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НаправлениеДеятельности, "УчетДоходов, УчетЗатрат");
		Если Не РеквизитыНаправленияДеятельности.УчетДоходов
			ИЛИ Не РеквизитыНаправленияДеятельности.УчетЗатрат Тогда
			ТекстОшибки = НСтр("ru = 'Для поставки под принципала направление деятельности должно учитывать и доходы и затраты.';
								|en = 'For procurement outsourcing, the line of business must take into account both income and costs.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "НаправлениеДеятельности", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(НаименованиеДляПечати) Тогда
		НаименованиеДляПечати = СокрЛП(Наименование);
	КонецЕсли;
	
	ХозяйственнаяОперация = Справочники.ДоговорыКонтрагентов.ХозяйственнаяОперация(ТипДоговора, ВариантОформленияЗакупок);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован);
	Если ЗначениеЗаполнено(ДопустимаяСуммаЗадолженности) И НЕ ОграничиватьСуммуЗадолженности Тогда
		ДопустимаяСуммаЗадолженности = 0;
	КонецЕсли;
	
	Если НЕ ЦентрализованныйДоговор Тогда
		Филиалы.Очистить();
	КонецЕсли;
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ);
	
	Если Не ЗаданГрафикИсполнения И ЗначениеЗаполнено(ГрафикИсполненияДоговора) Тогда
		Попытка
			ЗаблокироватьДанныеДляРедактирования(ГрафикИсполненияДоговора);
			ГрафикИсполненияДоговора.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
			ГрафикИсполненияДоговора = Неопределено;
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				Ссылка,,,
				Отказ);
		КонецПопытки;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());
	
	// Отработка смены пометки удаления
	Если Не ЭтоНовый()
		И ПометкаУдаления <> ДополнительныеСвойства.ПометкаУдаленияДоЗаписи Тогда
		Документы.ГрафикИсполненияДоговора.УстановитьПометкуУдаления(Ссылка, ПометкаУдаления);
		//++ НЕ УТКА

		//++ Устарело_Переработка24
		УстановитьПометкуУдаленияДавальческихНазначений();
		//-- Устарело_Переработка24

		//-- НЕ УТКА
	КонецЕсли;
	
	ТребуетсяЗаполнениеШаблонаНазначения = Ложь;
	ШаблонНазначения = Справочники.ДоговорыКонтрагентов.ШаблонНазначения(ЭтотОбъект);

	Если ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку
		И Константы.ВариантОбособленияТоваровВПродажах.Получить() = Перечисления.ВариантыОбособленияТоваровВПродажах.Договор Тогда
	
		ТребуетсяЗаполнениеШаблонаНазначения = Истина;
	//++ НЕ УТ
	ИначеЕсли ТипДоговора  = Перечисления.ТипыДоговоров.СПереработчиком2_5
		ИЛИ ТипДоговора  = Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС
		//++ НЕ УТКА
		ИЛИ ТипДоговора  = Перечисления.ТипыДоговоров.СДавальцем2_5
		//++ Устарело_Переработка24
		ИЛИ ТипДоговора  = Перечисления.ТипыДоговоров.СДавальцем
		//-- Устарело_Переработка24

		//-- НЕ УТКА

		//++ Устарело_Переработка24
		ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
		//-- Устарело_Переработка24
		ИЛИ Ложь Тогда
	
		ТребуетсяЗаполнениеШаблонаНазначения = Истина;
	//-- НЕ УТ
	КонецЕсли;
	
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения, ЭтотОбъект,
		"НаправлениеДеятельности,Партнер,ТипДоговора", Отказ, Истина, НЕ ТребуетсяЗаполнениеШаблонаНазначения);
	
	Если ТипДоговора = Перечисления.ТипыДоговоров.Импорт
		//++ Устарело_Переработка24
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
		//-- Устарело_Переработка24
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС
		Или ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
		Или ТипДоговора = Перечисления.ТипыДоговоров.РеализацияЧерезКомиссионера
		Или (ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
		И ДоговорССамозанятым) Тогда
		
		НалогообложениеНДСПоУмолчанию = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
		
		Если Перечисления.ТипыДоговоров.ЭтоДоговорПродажи(ТипДоговора) Тогда
			ПараметрыЗаполнения = Справочники.ДоговорыКонтрагентов.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
			УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДСПоУмолчанию, ПараметрыЗаполнения, Неопределено);
		ИначеЕсли Перечисления.ТипыДоговоров.ЭтоДоговорЗакупки(ТипДоговора) Тогда
			ПараметрыЗаполнения = Справочники.ДоговорыКонтрагентов.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
			УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДСПоУмолчанию, ПараметрыЗаполнения, Неопределено);
		КонецЕсли;
		
		УчетНДСУП.ЗаполнитьСтавкуНДСДляПлатежей(СтавкаНДС, НалогообложениеНДСПоУмолчанию, Организация, ДатаОкончанияДействия);
		
	КонецЕсли;
	
	ДоговорыКонтрагентовЛокализация.ПередЗаписью(Отказ, ЭтотОбъект);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован               = Ложь;
	ДатаНачалаДействия       = '00010101';
	ДатаОкончанияДействия    = '00010101';
	ГрафикИсполненияДоговора = Неопределено;
	Назначение               = Неопределено;
	ДоговорыКонтрагентовЛокализация.ПриКопировании(ОбъектКопирования, ЭтотОбъект);
	ПереоцениватьТоварыУслугиКОтчетуКомитенту = 
		ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом
		ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку;
	
	ИнициализироватьСправочник(, Ложь);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.ДоговорыКонтрагентов.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиСправочника(Назначение, ШаблонНазначения, ЭтотОбъект, НалогообложениеНДС);

	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	ЭлектронноеАктированиеЕИСУТ.ПриЗаписиДоговора(ГосударственныйКонтракт, ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС

	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);	
	
	ДоговорИспользуетсяПриПриемке = Справочники.ДоговорыКонтрагентов.ДоговорИспользуетсяПриПриемке(ВариантПриемкиТоваров);
	Если ДоговорИспользуетсяПриПриемке Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДокументРегистратор.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.УдалитьРегистраторГрафикаДвиженияТоваров КАК ДокументРегистратор
			|ГДЕ
			|	ДокументРегистратор.Распоряжение = &Ссылка
			|		И ДокументРегистратор.ПометкаУдаления <> &ПометкаУдаления";
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Попытка
				БлокировкаДанных = Новый БлокировкаДанных();
				ЭлементБлокировки = БлокировкаДанных.Добавить("Документ.УдалитьРегистраторГрафикаДвиженияТоваров");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
				БлокировкаДанных.Заблокировать();
				ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ДокОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
			Исключение
				ПараметрыЖурнала = Новый Структура("ГруппаСобытий, Метаданные, Данные");
				ПараметрыЖурнала.ГруппаСобытий = НСтр("ru = 'Запись договора с поставщиком';
														|en = 'Vendor contract record'");
				ПараметрыЖурнала.Метаданные    = Ссылка.Метаданные();
				ПараметрыЖурнала.Данные        = Ссылка;
				ОбщегоНазначенияУТ.ЗаписатьВЖурналСообщитьПользователю(
					ПараметрыЖурнала,
					УровеньЖурналаРегистрации.Ошибка,
					СтрШаблон(НСтр("ru = 'Не удалось синхронизировать пометку удаления %1, со служебным документом %2';
									|en = 'Cannot synchronize the %1 deletion mark with the %2 internal document'"), Ссылка, Выборка.Ссылка),
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	УдалитьСлужебныеРегистраторы(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииПартнера(Знач Партнер, ДанныеЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("Партнер", Партнер);
	ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер));
	ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(Партнер));
	ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперацияПоПартнеру(Партнер));
	ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСоглашения(Знач Соглашение, ДанныеЗаполнения)

	ПолноеИмяСправочника = Соглашение.Метаданные().ПолноеИмя();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&ТекущаяДата КАК Дата,
	|	ДанныеСоглашения.Партнер			   КАК Партнер,
	|	ДанныеСоглашения.Контрагент			   КАК Контрагент,
	|	ДанныеСоглашения.Организация		   КАК Организация,
	|	ДанныеСоглашения.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеСоглашения.Валюта				   КАК ВалютаВзаиморасчетов,
	|	ДанныеСоглашения.ОплатаВВалюте		   КАК ОплатаВВалюте,
	|	&ТекстКонтактноеЛицо,
	|
	|	ВЫБОР КОГДА ДанныеСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
	|	 ИЛИ ДанныеСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует) ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК ЕстьОшибкиСтатус,
	|
	|	НЕ ДанныеСоглашения.ИспользуютсяДоговорыКонтрагентов КАК ЕстьОшибкиИспользованиеДоговоров,
	|	ДанныеСоглашения.НаправлениеДеятельности КАК НаправлениеДеятельности
	|
	|ИЗ
	|	&ПолноеИмяСправочника  КАК ДанныеСоглашения
	|ГДЕ
	|	ДанныеСоглашения.Ссылка = &Ссылка
	|");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяСправочника", ПолноеИмяСправочника);
	
	Если ПолноеИмяСправочника = "Справочник.СоглашенияСКлиентами" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстКонтактноеЛицо,", "ДанныеСоглашения.КонтактноеЛицо        КАК КонтактноеЛицо,");
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстКонтактноеЛицо,", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеЗаполнения = Новый Структура;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		ПроверитьВозможностьВводаНаОснованииСоглашения(Выборка.ЕстьОшибкиИспользованиеДоговоров, Выборка.ЕстьОшибкиСтатус);
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Партнер) 
			И Не ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			ДанныеЗаполнения.Контрагент = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер);
			
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(Выборка.ХозяйственнаяОперация));
		
		ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения);
		ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("ПартнерПоУмолчанию") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ДанныеЗаполнения.ПартнерПоУмолчанию);
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
		
	ИначеЕсли ДанныеЗаполнения.Свойство("Контрагент") Тогда
		ДанныеЗаполнения.Вставить("Партнер", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Контрагент, "Партнер"));
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		Если НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
			ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
		Если НЕ (ДанныеЗаполнения.Свойство("КонтактноеЛицо") И ЗначениеЗаполнено(ДанныеЗаполнения.КонтактноеЛицо)) Тогда
			ДанныеЗаполнения.Вставить("КонтактноеЛицо", ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения);
	ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперацияПоУмолчанию") Тогда
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ДанныеЗаполнения.ХозяйственнаяОперацияПоУмолчанию);
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") И ЗначениеЗаполнено(ДанныеЗаполнения.Партнер)
		И НЕ ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
		ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперацияПоПартнеру(ДанныеЗаполнения.Партнер));
		ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
	ИначеЕсли ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") И ЗначениеЗаполнено(ДанныеЗаполнения.ХозяйственнаяОперация) Тогда
		Если ТипЗнч(ДанныеЗаполнения.ХозяйственнаяОперация) = Тип("Массив")
			И ДанныеЗаполнения.ХозяйственнаяОперация.Количество() = 1 Тогда
			ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация[0]));
		Иначе
			ДанныеЗаполнения.Вставить("ТипДоговора", Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация));
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") И Не ДанныеЗаполнения.Свойство("ОплатаВВалюте") Тогда
		ДанныеЗаполнения.Вставить("ОплатаВВалюте",
			ВзаиморасчетыСервер.ПолучитьОплатуВВалютеПоУмолчанию());
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВозможностьВводаНаОснованииСоглашения(ЕстьОшибкиИспользованиеДоговоров, ЕстьОшибкиСтатус)
	
	Если ЕстьОшибкиИспользованиеДоговоров Тогда
		
		ТекстОшибки = НСтр("ru = 'По соглашению не требуется указание договоров. Ввод на основании запрещен.';
							|en = 'Contract specification is not required under the agreement. Generation from reference documents is prohibited.'");
	
		ВызватьИсключение ТекстОшибки;
		
	ИначеЕсли ЕстьОшибкиСтатус Тогда
		
		ТекстОшибки = НСтр("ru = 'Ввод на основании недействующего соглашения запрещен.';
							|en = 'You cannot generate a document from an invalid agreement.'");
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчет") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчет)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Организация") И ЗначениеЗаполнено(ДанныеЗаполнения.Организация)) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец В (&Организация)
	|	И ((БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Организация", ДанныеЗаполнения.Организация);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчет", Выборка.БанковскийСчет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетКонтрагентаПоУмолчанию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчетКонтрагента") И ЗначениеЗаполнено(ДанныеЗаполнения.БанковскийСчетКонтрагента)
	 ИЛИ НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаКонтрагентов.Ссылка КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|ГДЕ
	|	БанковскиеСчетаКонтрагентов.Владелец = &Контрагент
	|	И ((БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаКонтрагентов.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И НЕ БанковскиеСчетаКонтрагентов.ПометкаУдаления
	|	И НЕ БанковскиеСчетаКонтрагентов.Закрыт
	|");
	
	Запрос.УстановитьПараметр("Контрагент", ДанныеЗаполнения.Контрагент);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Если ДанныеЗаполнения.Свойство("Организация") И ЗначениеЗаполнено(ДанныеЗаполнения.Организация) Тогда
		Запрос.УстановитьПараметр("ВалютаРегл", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация));
	Иначе
		Запрос.УстановитьПараметр("ВалютаРегл", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("БанковскийСчетКонтрагента", Выборка.БанковскийСчетКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет реквизиты справочника значениями "по умолчанию".
//
Процедура ИнициализироватьСправочник(ДанныеЗаполнения = Неопределено, ЗаполнятьВсеРеквизиты = Истина) Экспорт
	
	Менеджер = Пользователи.ТекущийПользователь();
	Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует;
	
	Если ЗаполнятьВсеРеквизиты Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("ВалютаВзаиморасчетов") Тогда
			Если Не ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
				ВалютаВзаиморасчетов = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ОплатаВВалюте") Тогда
			ОплатаВВалюте = ВзаиморасчетыСервер.ПолучитьОплатуВВалютеПоУмолчанию();
		КонецЕсли;
		
		ТипДоговора = Справочники.ДоговорыКонтрагентов.ТипДоговора(ХозяйственнаяОперация);
		Если НЕ ЗначениеЗаполнено(ТипДоговора) И ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
			И ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ТипДоговора = Справочники.ДоговорыКонтрагентов.ТипДоговора(ДанныеЗаполнения.ХозяйственнаяОперация);
		КонецЕсли; 
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация = Организация;
		СтруктураПараметров.БанковскийСчет = БанковскийСчет;
		ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
		Если Перечисления.ТипыДоговоров.ЭтоДоговорПродажи(ТипДоговора) Тогда
			
			ПараметрыЗаполнения = Справочники.ДоговорыКонтрагентов.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
			УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
		
		ИначеЕсли  Перечисления.ТипыДоговоров.ЭтоДоговорЗакупки(ТипДоговора) Тогда
			
			ПараметрыЗаполнения = Справочники.ДоговорыКонтрагентов.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
			УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
			
			ПараметрыЗаполнения = Справочники.ДоговорыКонтрагентов.ПараметрыЗаполненияВидаДеятельностиНДС(ЭтотОбъект);
			УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ЗакупкаПодДеятельность, ПараметрыЗаполнения);
			
		КонецЕсли;
		
		ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, "ПорядокРасчетов");
		
	КонецЕсли;
	
	Если (ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем
			Или ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку)
		И Не ЗначениеЗаполнено(ПорядокОформленияСписанияНедостачТоваровПринятыхНаХранение) Тогда
		ПорядокОформленияСписанияНедостачТоваровПринятыхНаХранение =
			Перечисления.ПорядокОформленияСписанияТоваровПринятыхНаХранение.ОформлятьВыкуп;
	КонецЕсли;
	
	Если (ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом
			Или ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку) Тогда
		ПереоцениватьТоварыУслугиКОтчетуКомитенту = Истина;
	КонецЕсли;
	
	//++ НЕ УТ
	Если ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем
		И Не ЗначениеЗаполнено(ПорядокОформленияСписанияВПроизводствоТоваровПринятыхНаХранение) Тогда
		ПорядокОформленияСписанияВПроизводствоТоваровПринятыхНаХранение =
			Перечисления.ПорядокОформленияСписанияТоваровПринятыхНаХранение.ОформлятьВыкуп;
	КонецЕсли;
	//-- НЕ УТ
	
	//++ НЕ УТКА
	Если ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем2_5 Тогда
		
		Если Не ЗначениеЗаполнено(ПорядокОформленияСписанияНедостачТоваровПринятыхНаХранение) Тогда
			ПорядокОформленияСписанияНедостачТоваровПринятыхНаХранение =
				Перечисления.ПорядокОформленияСписанияТоваровПринятыхНаХранение.ОформлятьСписание;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПорядокОформленияСписанияВПроизводствоТоваровПринятыхНаХранение) Тогда
			ПорядокОформленияСписанияВПроизводствоТоваровПринятыхНаХранение =
				Перечисления.ПорядокОформленияСписанияТоваровПринятыхНаХранение.ОформлятьВыкуп;
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура УдалитьСлужебныеРегистраторы(Отказ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Регистраторы.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.УдалитьРегистраторГрафикаДвиженияТоваров КАК Регистраторы
		|ГДЕ
		|	Регистраторы.Распоряжение = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокОбъект.Удалить();
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Регистраторы.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РегистраторЗапасыИПотребности КАК Регистраторы
		|ГДЕ
		|	Регистраторы.Распоряжение = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокОбъект.Удалить();
	КонецЦикла;
	
КонецПроцедуры

Функция ХозяйственнаяОперацияПоПартнеру(Партнер)
	
	ДанныеПартнера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Партнер, "Клиент, Поставщик");
	
	Если ДанныеПартнера.Клиент И НЕ ДанныеПартнера.Поставщик Тогда
		Возврат Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	ИначеЕсли ДанныеПартнера.Поставщик И НЕ ДанныеПартнера.Клиент Тогда
		Возврат Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Иначе
		Возврат Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

//++ НЕ УТКА

//++ Устарело_Переработка24

Процедура УстановитьПометкуУдаленияДавальческихНазначений()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Договор", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Назначения.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Назначения КАК Назначения
	|ГДЕ
	|	Назначения.Договор = &Договор
	|	И Назначения.ТипНазначения = ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеМатериалы22)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры
//-- Устарело_Переработка24

//-- НЕ УТКА

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.ВидыЗапасов", "ПометкаУдаления");
	Результат.Вставить("Справочник.КлючиАналитикиУчетаПоПартнерам", "ПометкаУдаления");
	Результат.Вставить("Справочник.КлючиАналитикиУчетаНоменклатуры", "Партнер,Контрагент,Организация,ПометкаУдаления");
	Результат.Вставить("Документ.РегистраторЗапасыИПотребности", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
