#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ИнициализироватьДокумент();
	
	Если Сводно Тогда
		НачисленнаяЗарплатаИВзносыПоФизлицам.Очистить();
	КонецЕсли;
	
	СтрокаТЧ = "НачисленныйНДФЛ,УдержаннаяЗарплата,НачисленныеПроцентыПоЗаймам,НачисленнаяЗарплатаИВзносы,НачисленнаяЗарплатаИВзносыПоФизлицам";
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, СтрокаТЧ);	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОтражениеЗарплатыВФинансовомУчете") Тогда
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтражениеЗарплатыВФинансовомУчете.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если ЭтоНовый() Тогда
		СсылкаНаОбъект = ПолучитьСсылкуНового();
		Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			СсылкаНаОбъект = Документы.ОтражениеЗарплатыВФинансовомУчете.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНаОбъект);
		КонецЕсли;
	Иначе
		СсылкаНаОбъект = Ссылка;
	КонецЕсли;
	
	ПараметрыУчетнойПолитики = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("УчетнаяПолитикаБухУчета",
		Организация,
		КонецМесяца(ПериодРегистрации));
	
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПроводкиПоРаботникам = ПараметрыУчетнойПолитики.ПроводкиПоРаботникам И ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") И Не Сводно;
	КонецЕсли;
	
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Тогда
			Строка.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЗаймыВыданные;
			Строка.АналитикаАктивовПассивов = Неопределено;
		КонецЕсли;
		
		Если Строка.ЯвляетсяОснованиемОформленияКассовогоЧека Тогда
			Строка.ИдентификаторФискальнойЗаписи =
				Документы.ОтражениеЗарплатыВФинансовомУчете.ИдентификаторФискальнойЗаписи(СсылкаНаОбъект, Строка);
		Иначе
			Строка.ИдентификаторФискальнойЗаписи = "";
		КонецЕсли;
		
	КонецЦикла;
	
	ТипыНалогов = ТипыНалоговПоВидамОперацийНДФЛ();
	Для Каждого Строка Из НачисленныйНДФЛ Цикл
		Строка.ТипНалога = ТипыНалогов.Получить(Строка.ВидОперации);
	КонецЦикла;
	
	СтрокаТЧ = "НачисленныйНДФЛ,УдержаннаяЗарплата,НачисленныеПроцентыПоЗаймам,НачисленнаяЗарплатаИВзносы,НачисленнаяЗарплатаИВзносыПоФизлицам";
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, СтрокаТЧ);	
	
	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.ОтражениеЗарплатыВФинансовомУчете.ПараметрыНастройкиСчетовУчета());
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтражениеЗарплатыВФинансовомУчете.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("ПериодРегистрации");
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поле ""Месяц"" не заполнено';
				|en = 'Month is not populated'"), , "ПериодРегистрацииСтрокой", , Отказ);
		
	КонецЕсли;
	
	Если НачисленнаяЗарплатаИВзносы.Количество() = 0 И НачисленныйНДФЛ.Количество() = 0
		И УдержаннаяЗарплата.Количество() = 0 И НачисленныеПроцентыПоЗаймам.Количество() = 0
		И ВыплатаЗаСчетРезервов.Количество() = 0 Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Списки документа не содержат ни одной строки';
				|en = 'Document lists do not contain any line'"), ЭтотОбъект, , , Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленнаяЗарплатаИВзносы.СпособОтраженияЗарплатыВБухучете");
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносы Цикл
		
		Если Строка.Сумма = 0 И Строка.ВзносыВсего = 0 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена сумма начисления и взносов в строке %1 списка ""Начисления и взносы""';
						|en = 'Amount of accrual and contributions is not populated in line %1 of the ""Accruals and contributions"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "Сумма"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.СпособОтраженияЗарплатыВБухучете) И НЕ (Строка.РезервБУ И Строка.РезервНУ)
			И Документы.ОтражениеЗарплатыВФинансовомУчете.ТребуетсяСпособОтражения(Строка.ВидОперации) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Способ отражения"" в строке %1 списка ""Начисления и взносы""';
						|en = 'The ""Record method"" column is not populated in line %1 of the ""Accruals and contributions"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "СпособОтраженияЗарплатыВБухучете"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ПодразделениеПредприятия");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		
		СтруктураОтбора = Новый Структура("ВидОперации", Перечисления.ВидыОперацийПоЗарплате.НДФЛДоходыКонтрагентов);
		НайденныеСтроки = НачисленныйНДФЛ.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(Строка.ПодразделениеПредприятия) Тогда
				Продолжить;
			КонецЕсли;
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Подразделение"" в строке %1 списка ""НДФЛ""';
						|en = 'The ""Business unit"" column is not populated in line %1 of the ""PIT"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленныйНДФЛ", Строка.НомерСтроки, "ПодразделениеПредприятия"),
				,
				Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПроверитьНаличиеБазыРаспределения(Отказ);
	
	Если Сводно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ФизическоеЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.ФизическоеЛицо");
	КонецЕсли;
	
	ИспользоватьПрочиеАктивыПассивы = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов");
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		
		Если Сводно И Не ЗначениеЗаполнено(Строка.ФизическоеЛицо)
			И Документы.ОтражениеЗарплатыВФинансовомУчете.ТребуетсяФизическоеЛицоПриСводномОтражении(
				Строка.СпособРасчетов, Строка.ВидОперации, Строка.ЯвляетсяОснованиемОформленияКассовогоЧека) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Сотрудник"" в строке %1 списка ""Удержания""';
						|en = 'The ""Employee"" column is not populated in line %1 of the ""Deductions"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "ФизическоеЛицо"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок
			И Не ЗначениеЗаполнено(Строка.СтатьяДоходов) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Статья доходов"" в строке %1 списка ""Удержания""';
						|en = 'The ""Income item"" column is not populated in line %1 of the ""Deductions"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяДоходов"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок Тогда
			Продолжить;
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Строка.СтатьяАктивовПассивов) И ИспользоватьПрочиеАктивыПассивы Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Статья пассивов"" в строке %1 списка ""Удержания""';
						|en = 'The ""Liability item"" column is not populated in line %1 of the ""Deductions"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяАктивовПассивов"),
				,
				Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяАктивовПассивов");
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяДоходов");
	
	МассивНепроверяемыхРеквизитов.Добавить("ВыплатаЗаСчетРезервов.Резерв");
	
	ЕжегодныеОтпускаОценочныеОбязательстваИРезервы = Перечисления.ВидыОперацийПоЗарплате.ЕжегодныеОтпускаОценочныеОбязательстваИРезервы();
	Для Каждого Строка Из ВыплатаЗаСчетРезервов Цикл
		
		Если ЕжегодныеОтпускаОценочныеОбязательстваИРезервы.Найти(Строка.ВидОперации) <> Неопределено Тогда
			// Архивные данные не проверяем.
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.Резерв) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнена колонка ""Резерв"" в строке %1 списка "" Выплата за счет резерва""';
						|en = 'The ""Payroll fund"" column is not filled in line %1of the ""Payment from payroll fund"" list'"),
					Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВыплатаЗаСчетРезервов", Строка.НомерСтроки, "Резерв"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ОтражениеЗарплатыВФинансовомУчете.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипыНалоговПоВидамОперацийНДФЛ()
	
	ТипыНалогов = Перечисления.ТипыНалогов;
	ВидыОпераций = Перечисления.ВидыОперацийПоЗарплате;
	
	Соответствие = Новый Соответствие;
	Для Каждого ВидОперации Из ВидыОпераций.НДФЛ(Новый Структура) Цикл
		Соответствие.Вставить(ВидОперации, ТипыНалогов.НДФЛ);
	КонецЦикла;
	
	ДатаНачалаДействия176ФЗ = НалоговыйУчет.ДатаНачалаДействия176ФЗ();
	Если Дата < ДатаНачалаДействия176ФЗ И ПериодРегистрации < ДатаНачалаДействия176ФЗ Тогда
		Соответствие.Вставить(ВидыОпераций.НДФЛ,                                     ТипыНалогов.НДФЛ);
		Соответствие.Вставить(ВидыОпераций.НДФЛСПревышения,                          ТипыНалогов.НДФЛСПревышения);
		Соответствие.Вставить(ВидыОпераций.НФДЛДивидендыСотрудникам,                 ТипыНалогов.НДФЛДивидендыСотрудникам);
		Соответствие.Вставить(ВидыОпераций.НДФЛДоходыКонтрагентов,                   ТипыНалогов.НДФЛДоходыКонтрагентов);
		Соответствие.Вставить(ВидыОпераций.НФДЛДивиденды,                            ТипыНалогов.НДФЛДивиденды);
		Соответствие.Вставить(ВидыОпераций.НДФЛПрочиеРасчетыСПерсоналом,             ТипыНалогов.НДФЛПрочиеРасчетыСПерсоналом);
		Соответствие.Вставить(ВидыОпераций.НДФЛРасчетыСБывшимиСотрудниками,          ТипыНалогов.НДФЛДоходыКонтрагентов);
		Соответствие.Вставить(ВидыОпераций.НДФЛДоначисленныйПоРезультатамПроверки,   ТипыНалогов.НДФЛДоначисленныйПоРезультатамПроверки);
		Соответствие.Вставить(ВидыОпераций.НДФЛПередачаЗадолженностиВНалоговыйОрган, ТипыНалогов.НДФЛПередачаЗадолженностиВНалоговыйОрган);
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(Соответствие);
	
КонецФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПроверитьНаличиеБазыРаспределения(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленнаяЗарплата.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	НачисленнаяЗарплата.ВидОперации КАК ВидОперации,
	|	НачисленнаяЗарплата.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	НачисленнаяЗарплата.НомерСтроки КАК НомерСтроки,
	|	НачисленнаяЗарплата.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	&НачисленнаяЗарплата КАК НачисленнаяЗарплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленнаяЗарплата.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	НачисленнаяЗарплата.ВидОперации КАК ВидОперации,
	|	НачисленнаяЗарплата.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	НачисленнаяЗарплата.НомерСтроки КАК НомерСтроки,
	|	НачисленнаяЗарплата.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД
	|ПОМЕСТИТЬ ВТДанныеДокументаСводно
	|ИЗ
	|	&НачисленнаяЗарплатаСводно КАК НачисленнаяЗарплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДД.Подразделение КАК Подразделение,
	|	СУММА(ДД.НормативнаяСтоимость) КАК НормативнаяСтоимость,
	|	СУММА(ВЫБОР
	|		КОГДА ВидыРабот.КратностьТрудоемкости > 0
	|			ТОГДА ВЫРАЗИТЬ(ДД.Количество * ВидыРабот.Трудоемкость / ВидыРабот.КратностьТрудоемкости КАК ЧИСЛО(15,3))
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК Длительность,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТБазаРаспределения
	|ИЗ
	|	РегистрНакопления.ТрудозатратыНезавершенногоПроизводства КАК ДД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыРаботСотрудников КАК ВидыРабот
	|			ПО ДД.ВидРабот = ВидыРабот.Ссылка
	|ГДЕ
	|	ДД.Подразделение В
	|			(ВЫБРАТЬ
	|				Т.ПодразделениеПредприятия
	|			ИЗ
	|				ВТДанныеДокумента КАК Т)
	|	И ДД.Организация = &Организация
	|	И ДД.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ВТДанныеДокументаСводно.НомерСтроки, ВТДанныеДокумента.НомерСтроки) КАК НомерСтроки,
	|	ВТДанныеДокумента.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	ВТДанныеДокумента.ВидОперации КАК ВидОперации,
	|	ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ВТДанныеДокумента.ФизическоеЛицо.Наименование КАК ПредставлениеФизЛица,
	|	ВТДанныеДокумента.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|	ВЫБОР
	|		КОГДА ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ДлительностьВыполненияРабот)
	|			И ЕСТЬNULL(ВТБазаРаспределения.НормативнаяСтоимость,0) > 0
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ТипСообщения
	|ИЗ
	|	ВТДанныеДокумента КАК ВТДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБазаРаспределения КАК ВТБазаРаспределения
	|		ПО ВТДанныеДокумента.ПодразделениеПредприятия = ВТБазаРаспределения.Подразделение
	|			И ВТДанныеДокумента.ФизическоеЛицо = ВТБазаРаспределения.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеДокументаСводно КАК ВТДанныеДокументаСводно
	|		ПО ВТДанныеДокумента.ПодразделениеПредприятия = ВТДанныеДокументаСводно.ПодразделениеПредприятия
	|			И ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете = ВТДанныеДокументаСводно.СпособОтраженияЗарплатыВБухучете
	|			И ВТДанныеДокумента.ВидОперации = ВТДанныеДокументаСводно.ВидОперации
	|			И ВТДанныеДокумента.ОблагаетсяЕНВД = ВТДанныеДокументаСводно.ОблагаетсяЕНВД
	|ГДЕ
	|	ВТДанныеДокумента.ПодразделениеПредприятия <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	И ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.ОплатаСдельныхРабот
	|	И (ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда)
	|			И ЕСТЬNULL(ВТБазаРаспределения.НормативнаяСтоимость,0) = 0
	|		ИЛИ
	|		ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ДлительностьВыполненияРабот)
	|			И ЕСТЬNULL(ВТБазаРаспределения.Длительность,0) = 0
	|	)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЕСТЬNULL(ВТДанныеДокументаСводно.НомерСтроки, ВТДанныеДокумента.НомерСтроки),
	|	ВТДанныеДокумента.ПодразделениеПредприятия,
	|	ВТДанныеДокумента.ВидОперации,
	|	ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете,
	|	ВТДанныеДокумента.ОблагаетсяЕНВД
	|	
	|";
	
	Если Сводно Тогда
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносы.Выгрузить(, "ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо", "ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизическоеЛицо");
		Запрос.УстановитьПараметр("НачисленнаяЗарплатаСводно", НачисленнаяЗарплатаИВзносы.ВыгрузитьКолонки("ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		
	Иначе
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносыПоФизлицам.Выгрузить(, "ПодразделениеПредприятия, ФизическоеЛицо, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		Запрос.УстановитьПараметр("НачисленнаяЗарплатаСводно", НачисленнаяЗарплатаИВзносы.Выгрузить(, "ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода",       НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ОкончаниеПериода",    КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("Сводно",              Сводно);
	Запрос.УстановитьПараметр("Ссылка",              Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	СтруктураСтроки = Новый Структура("ПодразделениеПредприятия, ВидОперации, СпособОтраженияЗарплатыВБухучете, ОблагаетсяЕНВД, НомерСтроки, ТипСообщения");
	
	ТекстыСводно = Новый Массив;
	ТекстыСводно.Добавить(НСтр("ru = 'В подразделении %1 не регистрировалась выработка сотрудников (строка %2 списка ""Начисленная зарплата и взносы"")';
								|en = 'In business unit %1, employee output was not registered (line %2 of the ""Accrued salary and contributions"" list)'"));
	ТекстыСводно.Добавить(НСтр("ru = 'Не задана трудоемкость выполннных работ в подразделении %1 (строка %2 списка ""Начисленная зарплата и взносы"")';
								|en = 'Labor intensity is not specified in the %1 business unit (line %2 of the Accrued salary and contributions list)'"));
	
	ТекстыДетально = Новый Массив;
	ТекстыДетально.Добавить(НСтр("ru = 'Выработка сотрудника (-ов) %1 в подразделении ""%2"" не регистрировалась (строка %3 списка ""Начисленная зарплата и взносы"")';
								|en = 'Output of employee(s) %1 in the ""%2"" business unit has not been registered (line %3 of the ""Accrued salary and contributions"" list)  '"));
	ТекстыДетально.Добавить(НСтр("ru = 'Не задана трудоемкость работ сотрудника (-ов) %1 в подразделении ""%2"" (строка %3 списка ""Начисленная зарплата и взносы"")';
								|en = 'Labor intensity is not specified for employee(s) %1 in the %2 business unit (line %3 of the Accrued salary and contributions list)'"));
	
	ТекстСотрудники = "";
	НомерСтрокиСводнойТаблицы = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Если Сводно Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыСводно[Выборка.ТипСообщения], Выборка.ПодразделениеПредприятия, Выборка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Выборка.НомерСтроки, "ПодразделениеПредприятия"),
				,
				Отказ);
			
		Иначе
			
			Если СтруктураСтроки.ПодразделениеПредприятия <> Выборка.ПодразделениеПредприятия
				Или СтруктураСтроки.ВидОперации <> Выборка.ВидОперации
				Или СтруктураСтроки.СпособОтраженияЗарплатыВБухучете <> Выборка.СпособОтраженияЗарплатыВБухучете
				Или СтруктураСтроки.ОблагаетсяЕНВД <> Выборка.ОблагаетсяЕНВД Тогда
				
				Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыДетально[СтруктураСтроки.ТипСообщения], ТекстСотрудники, СтруктураСтроки.ПодразделениеПредприятия, СтруктураСтроки.НомерСтроки),
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", СтруктураСтроки.НомерСтроки, "ПодразделениеПредприятия"),
						,
						Отказ);
					
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(СтруктураСтроки, Выборка);
				ТекстСотрудники = "";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
				ТекстСотрудники = ТекстСотрудники + ", " + Выборка.ПредставлениеФизЛица;
			Иначе
				ТекстСотрудники = Выборка.ПредставлениеФизЛица;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыДетально[СтруктураСтроки.ТипСообщения], ТекстСотрудники, СтруктураСтроки.ПодразделениеПредприятия, СтруктураСтроки.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", СтруктураСтроки.НомерСтроки, "ПодразделениеПредприятия"),
			,
		Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
