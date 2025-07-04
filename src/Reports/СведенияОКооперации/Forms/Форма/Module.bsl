#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Не Параметры.Свойство("ПараметрКоманды") Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Отчет не предназначен для интерактивного открытия.';
								|en = 'The report is not designed for interactive opening.'");
	КонецЕсли;
	
	Если Не (Параметры.ПараметрКоманды.ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
		//++ НЕ УТКА
		Или Параметры.ПараметрКоманды.ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем2_5
		//-- НЕ УТКА
		Или Параметры.ПараметрКоманды.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем) Тогда
		Отказ = Истина;
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Для типа договора ""%1"" отчет не требуется.';
										|en = 'Report is not required for contract type ""%1"".'"), Параметры.ПараметрКоманды.ТипДоговора);
	КонецЕсли;
	
	Отчет.ДоговорСЗаказчиком = Параметры.ПараметрКоманды.Ссылка;
	
	Приложение1 = Параметры.Свойство("Приложение1") И Параметры.Приложение1;
	Приложения2и3 = Параметры.Свойство("Приложения2и3") И Параметры.Приложения2и3;
	
	Заголовок = Заголовок + ?(Приложение1, " (" + НСтр("ru = 'Приложение 1';
														|en = 'Application 1'") + ")", " (" + НСтр("ru = 'Приложения 2 и 3';
																								|en = 'Annexes 2 and 3'") + ")");
	
	ОбновитьНаСервере();
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	Результат.Очистить();
	
	// Добавим фиксированные параметры
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаСведенияОКооперации();

	Запрос.УстановитьПараметр("ДоговорСЗаказчиком", Отчет.ДоговорСЗаказчиком);
	ДанныеОКонтрактах = Запрос.Выполнить().Выгрузить();
	
	// Получение контактной информации
	
	Исполнители = ДанныеОКонтрактах.ВыгрузитьКолонку("Исполнитель");
	ИсполнителиДляКИ = Новый Массив;
	Для Каждого Исполнитель Из Исполнители Цикл 
		Если Не ЗначениеЗаполнено(Исполнитель) Тогда
			Продолжить;
		КонецЕсли;
		
		ИсполнителиДляКИ.Добавить(Исполнитель);
	КонецЦикла;
	
	Если ИсполнителиДляКИ.Количество() > 0 Тогда
		ВидыКИ = Новый Массив;
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
		ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(ИсполнителиДляКИ, , ВидыКИ, ТекущаяДатаСеанса());
	КонецЕсли;
	
	#Область ВыводПриложения1
	
	Если Приложение1 Тогда
		Макет = Отчеты.СведенияОКооперации.ПолучитьМакет("ПФ_Приложение1");
		
		НомерСтроки = 1;
		ШапкаВыведена = Ложь;
		Для Каждого ДанныеКонтракта Из ДанныеОКонтрактах Цикл 
			Если Не ШапкаВыведена Тогда
				ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
				ОбластьШапка.Параметры.Заполнить(ДанныеКонтракта);
				
				ГосударственныйКонтрактДатаЗаключения = ДанныеКонтракта.ГосударственныйКонтракт.ДатаЗаключения;
				ГосударственныйКонтрактНомер = ДанныеКонтракта.ГосударственныйКонтрактИдентификатор;
	
				ОбластьШапка.Параметры["ГосударственныйКонтрактДень"] = День(ГосударственныйКонтрактДатаЗаключения);
				ОбластьШапка.Параметры["ГосударственныйКонтрактМесяцПрописью"] = МесяцПрописью(Месяц(ГосударственныйКонтрактДатаЗаключения));
				ОбластьШапка.Параметры["ГосударственныйКонтрактГод"] = Формат(Год(ГосударственныйКонтрактДатаЗаключения), "ЧГ=0");
				ОбластьШапка.Параметры["ГосударственныйКонтрактНомер"] = ГосударственныйКонтрактНомер;
				
				ОбластьШапка.Параметры["ГосударственныйЗаказчикНаименованиеПолное"] = ПредставлениеГосударственногоЗаказчика(ДанныеКонтракта);
				
				ОбластьШапка.Параметры["ГосударственныйКонтрактСрокИсполнения"] = Строка(Формат(ДанныеКонтракта.ГосударственныйКонтрактСрокиГодЗаключения, "ЧГ=0")) 
					+ " - " + Строка(Формат(ДанныеКонтракта.ГосударственныйКонтрактСрокиГодОкончанияСрокаДействия, "ЧГ=0")) + " " + НСтр("ru = 'гг.';
																																		|en = 'year'") ;
					
				ОбластьШапка.Параметры["ГосударственныйКонтрактСумма"] = ДанныеКонтракта.КонтрактСЗаказчикомСумма;
					
				Результат.Вывести(ОбластьШапка);
			
				ОбластьОтступ = Макет.ПолучитьОбласть("Отступ");
				Результат.Вывести(ОбластьОтступ);
				
				ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы");
				Результат.Вывести(ОбластьШапка);
				
				ШапкаВыведена = Истина;
			КонецЕсли;
			
			Если Не ДанныеКонтракта.ЭтоИностранныйИсполнитель Тогда
				ИсполнительКонтрагент = ТипЗнч(ДанныеКонтракта.Исполнитель) = Тип("СправочникСсылка.Контрагенты");
	
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
				ОбластьСтрокаТаблицы.Параметры["НомерСтроки"] = НомерСтроки;
				
				МассивСтрокНаименования = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительНаименованиеПолное) Тогда
					МассивСтрокНаименования.Добавить(ДанныеКонтракта.ИсполнительНаименованиеПолное);
				КонецЕсли;
				
				ПредставлениеКИ = КонтактнаяИнформацияОбъекта(КонтактнаяИнформация, 
					ДанныеКонтракта.Исполнитель,
					?(ИсполнительКонтрагент, 
						Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
						Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации));
					
				Если ЗначениеЗаполнено(ПредставлениеКИ) Тогда
					МассивСтрокНаименования.Добавить(ПредставлениеКИ);
				КонецЕсли;
				
				СтрокаНаименованиеПолное = СтрСоединить(МассивСтрокНаименования, ", ");
				ОбластьСтрокаТаблицы.Параметры["ИсполнительНаименованиеПолное"] = ?(ЗначениеЗаполнено(СтрокаНаименованиеПолное), СтрокаНаименованиеПолное, НСтр("ru = '<Полное наименование, адрес, телефоны не указаны>';
																																								|en = '<Full name, address, phone are not specified>'"));
				
				МассивСтрокИННКПП = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительИНН) Тогда
					МассивСтрокИННКПП.Добавить(НСтр("ru = 'ИНН:';
													|en = 'TIN:'") + ДанныеКонтракта.ИсполнительИНН);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительКПП) Тогда
					МассивСтрокИННКПП.Добавить(НСтр("ru = 'КПП:';
													|en = 'KPP:'") + ДанныеКонтракта.ИсполнительКПП);
				КонецЕсли;
				СтрокаИНН_КПП = СтрСоединить(МассивСтрокИННКПП, ", ");
				ОбластьСтрокаТаблицы.Параметры["ИНН_КПП"] = ?(ЗначениеЗаполнено(СтрокаИНН_КПП), СтрокаИНН_КПП, НСтр("ru = '<ИНН и КПП не указаны>';
																													|en = '<TIN and KPP are not specified>'"));
				
				МассивСтрокНомерДата = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемНомер) Тогда
					МассивСтрокНомерДата.Добавить(ДанныеКонтракта.КонтрактСИсполнителемНомер);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемДата) Тогда
					МассивСтрокНомерДата.Добавить(НСтр("ru = 'от';
														|en = 'dated'") + " " + Строка(Формат(ДанныеКонтракта.КонтрактСИсполнителемДата, "ДЛФ=D")) + " " + НСтр("ru = 'г.';
																																							|en = 'year'"));
				КонецЕсли;
				СтрокаДатаИНомер = СтрСоединить(МассивСтрокНомерДата, " ");
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемДатаИНомер"] = ?(ЗначениеЗаполнено(СтрокаДатаИНомер), СтрокаДатаИНомер, НСтр("ru = '<Номер и дата не указаны>';
																																					|en = '<Number and date are not specified>'"));
				
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемПредмет"] = ДанныеКонтракта.КонтрактСИсполнителемПредмет;
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемСумма"] = ДанныеКонтракта.КонтрактСИсполнителемСумма;
				ОбластьСтрокаТаблицы.Параметры["СпособОпределенияПоставщика"] = ПредставлениеИдентификатораИнформацииОЗакупке(ДанныеКонтракта);
				
				Результат.Вывести(ОбластьСтрокаТаблицы);
				
				НомерСтроки = НомерСтроки + 1;
			КонецЕсли;
		КонецЦикла;
		
		Результат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	#КонецОбласти 
	
	Если Приложения2и3 Тогда
		
		#Область ВыводПриложения2
		
		Макет = Отчеты.СведенияОКооперации.ПолучитьМакет("ПФ_Приложение2");
		
		НомерСтроки = 1;
		ШапкаВыведена = Ложь;
		Для Каждого ДанныеКонтракта Из ДанныеОКонтрактах Цикл 
			Если Не ШапкаВыведена Тогда
				ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
				ОбластьШапка.Параметры.Заполнить(ДанныеКонтракта);
				ОбластьШапка.Параметры["КонтрактСЗаказчикомСрокИсполнения"] = Строка(Формат(ДанныеКонтракта.КонтрактСЗаказчикомДатаНачала, "ДЛФ=D")) + " " + НСтр("ru = 'г.';
																																									|en = 'year'") 
					+ " - " + Строка(Формат(ДанныеКонтракта.КонтрактСЗаказчикомДатаОкончания, "ДЛФ=D")) + " " + НСтр("ru = 'г.';
																													|en = 'year'") ;
					
				Результат.Вывести(ОбластьШапка);
			
				ОбластьОтступ = Макет.ПолучитьОбласть("Отступ");
				Результат.Вывести(ОбластьОтступ);
				
				ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы");
				Результат.Вывести(ОбластьШапка);
				
				ШапкаВыведена = Истина;
			КонецЕсли;
			
			Если Не ДанныеКонтракта.ЭтоИностранныйИсполнитель Тогда
				ИсполнительКонтрагент = ТипЗнч(ДанныеКонтракта.Исполнитель) = Тип("СправочникСсылка.Контрагенты");
				
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
				ОбластьСтрокаТаблицы.Параметры["НомерСтроки"] = НомерСтроки;
				
				МассивСтрокНаименования = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительНаименованиеПолное) Тогда
					МассивСтрокНаименования.Добавить(ДанныеКонтракта.ИсполнительНаименованиеПолное);
				КонецЕсли;
				
				ПредставлениеКИ = КонтактнаяИнформацияОбъекта(КонтактнаяИнформация, 
					ДанныеКонтракта.Исполнитель,
					?(ИсполнительКонтрагент, 
						Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
						Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации));
					
				Если ЗначениеЗаполнено(ПредставлениеКИ) Тогда
					МассивСтрокНаименования.Добавить(ПредставлениеКИ);
				КонецЕсли;
				
				СтрокаНаименованиеПолное = СтрСоединить(МассивСтрокНаименования, ", ");
				ОбластьСтрокаТаблицы.Параметры["ИсполнительНаименованиеПолное"] = ?(ЗначениеЗаполнено(СтрокаНаименованиеПолное), СтрокаНаименованиеПолное, НСтр("ru = '<Полное наименование, адрес, телефоны не указаны>';
																																								|en = '<Full name, address, phone are not specified>'"));
				
				МассивСтрокИННКПП = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительИНН) Тогда
					МассивСтрокИННКПП.Добавить(НСтр("ru = 'ИНН:';
													|en = 'TIN:'") + ДанныеКонтракта.ИсполнительИНН);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительКПП) Тогда
					МассивСтрокИННКПП.Добавить(НСтр("ru = 'КПП:';
													|en = 'KPP:'") + ДанныеКонтракта.ИсполнительКПП);
				КонецЕсли;
				СтрокаИНН_КПП = СтрСоединить(МассивСтрокИННКПП, ", ");
				ОбластьСтрокаТаблицы.Параметры["ИНН_КПП"] = ?(ЗначениеЗаполнено(СтрокаИНН_КПП), СтрокаИНН_КПП, НСтр("ru = '<ИНН и КПП не указаны>';
																													|en = '<TIN and KPP are not specified>'"));
				
				МассивСтрокНомерДата = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемНомер) Тогда
					МассивСтрокНомерДата.Добавить(ДанныеКонтракта.КонтрактСИсполнителемНомер);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемДата) Тогда
					МассивСтрокНомерДата.Добавить(НСтр("ru = 'от';
														|en = 'dated'") + " " + Строка(Формат(ДанныеКонтракта.КонтрактСИсполнителемДата, "ДЛФ=D")) + " " + НСтр("ru = 'г.';
																																							|en = 'year'"));
				КонецЕсли;
				СтрокаДатаИНомер = СтрСоединить(МассивСтрокНомерДата, " ");
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемДатаИНомер"] = ?(ЗначениеЗаполнено(СтрокаДатаИНомер), СтрокаДатаИНомер, НСтр("ru = '<Номер и дата не указаны>';
																																					|en = '<Number and date are not specified>'"));
				
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемПредмет"] = ДанныеКонтракта.КонтрактСИсполнителемПредмет;
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемСумма"] = ДанныеКонтракта.КонтрактСИсполнителемСумма;
				ОбластьСтрокаТаблицы.Параметры["СпособОпределенияПоставщика"] = ПредставлениеИдентификатораИнформацииОЗакупке(ДанныеКонтракта);
				
				Результат.Вывести(ОбластьСтрокаТаблицы);
				
				НомерСтроки = НомерСтроки + 1;
			КонецЕсли;
		КонецЦикла;
		
		Результат.ВывестиГоризонтальныйРазделительСтраниц();
		
		#КонецОбласти 
		
		#Область ВыводПриложения3
			
		Макет = Отчеты.СведенияОКооперации.ПолучитьМакет("ПФ_Приложение3");
		
		НомерСтроки = 1;
		ШапкаВыведена = Ложь;
		Для Каждого ДанныеКонтракта Из ДанныеОКонтрактах Цикл 
			Если Не ШапкаВыведена Тогда
				ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
				ОбластьШапка.Параметры.Заполнить(ДанныеКонтракта);
				
				ГосударственныйКонтрактДатаЗаключения = ДанныеКонтракта.ГосударственныйКонтракт.ДатаЗаключения;
				ГосударственныйКонтрактНомер = ДанныеКонтракта.ГосударственныйКонтрактИдентификатор;
	
				ОбластьШапка.Параметры["ГосударственныйКонтрактДень"] = День(ГосударственныйКонтрактДатаЗаключения);
				ОбластьШапка.Параметры["ГосударственныйКонтрактМесяцПрописью"] = МесяцПрописью(Месяц(ГосударственныйКонтрактДатаЗаключения));
				ОбластьШапка.Параметры["ГосударственныйКонтрактГод"] = Формат(Год(ГосударственныйКонтрактДатаЗаключения), "ЧГ=0");
				ОбластьШапка.Параметры["ГосударственныйКонтрактНомер"] = ГосударственныйКонтрактНомер;
				
				ОбластьШапка.Параметры["ГосударственныйЗаказчикНаименованиеПолное"] = ПредставлениеГосударственногоЗаказчика(ДанныеКонтракта);
				
				ОбластьШапка.Параметры["ГосударственныйКонтрактСрокИсполнения"] = Строка(Формат(ДанныеКонтракта.ГосударственныйКонтрактСрокиГодЗаключения, "ЧГ=0")) 
					+ " - " + Строка(Формат(ДанныеКонтракта.ГосударственныйКонтрактСрокиГодОкончанияСрокаДействия, "ЧГ=0")) + " " + НСтр("ru = 'гг.';
																																		|en = 'year'") ;
					
				ОбластьШапка.Параметры["ГосударственныйКонтрактСумма"] = ДанныеКонтракта.КонтрактСЗаказчикомСумма;
					
				Результат.Вывести(ОбластьШапка);
				
				ОбластьОтступ = Макет.ПолучитьОбласть("Отступ");
				Результат.Вывести(ОбластьОтступ);
				
				ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы");
				Результат.Вывести(ОбластьШапка);
				
				ШапкаВыведена = Истина;
			КонецЕсли;
			
			Если ДанныеКонтракта.ЭтоИностранныйИсполнитель Тогда
				ИсполнительКонтрагент = ТипЗнч(ДанныеКонтракта.Исполнитель) = Тип("СправочникСсылка.Контрагенты");
				
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
				ОбластьСтрокаТаблицы.Параметры["НомерСтроки"] = НомерСтроки;
				
				МассивСтрокНаименования = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительНаименованиеПолное) Тогда
					МассивСтрокНаименования.Добавить(ДанныеКонтракта.ИсполнительНаименованиеПолное);
				КонецЕсли;
				
				ПредставлениеКИ = КонтактнаяИнформацияОбъекта(КонтактнаяИнформация, 
					ДанныеКонтракта.Исполнитель,
					?(ИсполнительКонтрагент, 
						Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
						Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации));
					
				Если ЗначениеЗаполнено(ПредставлениеКИ) Тогда
					МассивСтрокНаименования.Добавить(ПредставлениеКИ);
				КонецЕсли;
				
				СтрокаНаименованиеПолное = СтрСоединить(МассивСтрокНаименования, ", ");
				ОбластьСтрокаТаблицы.Параметры["ИсполнительНаименованиеПолное"] = ?(ЗначениеЗаполнено(СтрокаНаименованиеПолное), СтрокаНаименованиеПолное, НСтр("ru = '<Полное наименование, адрес, телефоны не указаны>';
																																								|en = '<Full name, address, phone are not specified>'"));
				
				ОбластьСтрокаТаблицы.Параметры["ИсполнительРегистрационныйНомер"] = ?(ЗначениеЗаполнено(ДанныеКонтракта.ИсполнительРегистрационныйНомер), ДанныеКонтракта.ИсполнительРегистрационныйНомер, НСтр("ru = 'Рег. номер не указан';
																																																				|en = 'Reg. number is not specified'"));
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемОснование"] = ПредставлениеИдентификатораИнформацииОЗакупке(ДанныеКонтракта);
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемПредмет"] = ДанныеКонтракта.КонтрактСИсполнителемПредмет;
				
				МассивСтрокНомерДата = Новый Массив;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемНомер) Тогда
					МассивСтрокНомерДата.Добавить(ДанныеКонтракта.КонтрактСИсполнителемНомер);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеКонтракта.КонтрактСИсполнителемДата) Тогда
					МассивСтрокНомерДата.Добавить(НСтр("ru = 'от';
														|en = 'dated'") + " " + Строка(Формат(ДанныеКонтракта.КонтрактСИсполнителемДата, "ДЛФ=D")) + " " + НСтр("ru = 'г.';
																																							|en = 'year'"));
				КонецЕсли;
				СтрокаДатаИНомер = СтрСоединить(МассивСтрокНомерДата, " ");
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемДатаИНомер"] = ?(ЗначениеЗаполнено(СтрокаДатаИНомер), СтрокаДатаИНомер, НСтр("ru = '<Номер и дата не указаны>';
																																					|en = '<Number and date are not specified>'"));
				
				ОбластьСтрокаТаблицы.Параметры["КонтрактСИсполнителемСумма"] = ДанныеКонтракта.КонтрактСИсполнителемСумма;
				
				Результат.Вывести(ОбластьСтрокаТаблицы);
				
				НомерСтроки = НомерСтроки + 1;
			КонецЕсли;
		КонецЦикла;
		
		#КонецОбласти 
	
	КонецЕсли;
	
	// Параметры печати
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Результат.АвтоМасштаб = Истина;
	
	// Поля
	Результат.ПолеСверху = 5;
	Результат.ПолеСнизу = 10;
	Результат.ПолеСлева = 5;
	Результат.ПолеСправа = 5;
	
	Результат.РазмерКолонтитулаСверху = 5;
	Результат.РазмерКолонтитулаСнизу = 5;
	
	// Колонтитулы
	Результат.НижнийКолонтитул.Выводить = Истина;
	Результат.НижнийКолонтитул.ТекстСправа = НСтр("ru = 'Страница [&НомерСтраницы] из [&СтраницВсего]';
													|en = 'Page [&НомерСтраницы] of [&СтраницВсего]'");
	
	// Прочие параметры
	Результат.Защита = Истина;
	Результат.ОтображатьЗаголовки = Ложь;
	Результат.ОтображатьСетку = Ложь;
	Результат.КлючПараметровПечати = "ПечатнаяФормаСведенийОКооперации";
	Результат.ИспользуемоеИмяФайла = НСтр("ru = 'Сведения о кооперации';
											|en = 'Information about cooperation'") + ?(Приложение1, " (" + НСтр("ru = 'Приложение 1';
																										|en = 'Application 1'") + ")", " (" + НСтр("ru = 'Приложения 2 и 3';
																																				|en = 'Annexes 2 and 3'") + ")") + " " + Отчет.ДоговорСЗаказчиком;
КонецПроцедуры

&НаСервере
Функция ПредставлениеИдентификатораИнформацииОЗакупке(Знач ДанныеКонтракта)
	
	Возврат "(" + ДанныеКонтракта.КодСпособаОпределенияПоставщика + ")" + " " 
		+ Справочники.ГосударственныеКонтракты.ПредставлениеИдентификатораИнформацииОЗакупке(ДанныеКонтракта.КодСпособаОпределенияПоставщика);

КонецФункции

&НаСервере
Функция ПредставлениеГосударственногоЗаказчика(Знач ДанныеКонтракта)
	ПредставлениеГосударственногоЗаказчика = "";
	
	ИГК = ДанныеКонтракта.ГосударственныйКонтрактИдентификатор;
	
	КодГосударственногоЗаказчика = Сред(ИГК, 5, 3);
	
	НайденныеАдминистраторыДохода = Справочники.ГосударственныеКонтракты.АдминистраторыДоходовБюджета(КодГосударственногоЗаказчика);
	
	Если НайденныеАдминистраторыДохода.Количество() > 0 Тогда
		ПредставлениеГосудартсвенногоЗаказчика = НайденныеАдминистраторыДохода[0].ПолноеНаименование;
	КонецЕсли;
	
	Возврат ПредставлениеГосудартсвенногоЗаказчика;
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция МесяцПрописью(НомерМесяца)
	МесяцПрописью = "";
	
	Если НомерМесяца = 1 Тогда
		МесяцПрописью = НСтр("ru = 'января';
							|en = 'January'");
	ИначеЕсли НомерМесяца = 2 Тогда
		МесяцПрописью = НСтр("ru = 'февраля';
							|en = 'February'");
	ИначеЕсли НомерМесяца = 3 Тогда
		МесяцПрописью = НСтр("ru = 'марта';
							|en = 'March'");
	ИначеЕсли НомерМесяца = 4 Тогда
		МесяцПрописью = НСтр("ru = 'апреля';
							|en = 'April'");
	ИначеЕсли НомерМесяца = 5 Тогда
		МесяцПрописью = НСтр("ru = 'мая';
							|en = 'May'");
	ИначеЕсли НомерМесяца = 6 Тогда
		МесяцПрописью = НСтр("ru = 'июня';
							|en = 'June'");
	ИначеЕсли НомерМесяца = 7 Тогда
		МесяцПрописью = НСтр("ru = 'июля';
							|en = 'July'");
	ИначеЕсли НомерМесяца = 8 Тогда
		МесяцПрописью = НСтр("ru = 'августа';
							|en = 'August'");
	ИначеЕсли НомерМесяца = 9 Тогда
		МесяцПрописью = НСтр("ru = 'сентября';
							|en = 'September'");
	ИначеЕсли НомерМесяца = 10 Тогда
		МесяцПрописью = НСтр("ru = 'октября';
							|en = 'October'");
	ИначеЕсли НомерМесяца = 11 Тогда
		МесяцПрописью = НСтр("ru = 'ноября';
							|en = 'November'");
	ИначеЕсли НомерМесяца = 12 Тогда
		МесяцПрописью = НСтр("ru = 'декабря';
							|en = 'December'");
	КонецЕсли;
	
	Возврат МесяцПрописью;
КонецФункции

&НаСервереБезКонтекста 
Функция КонтактнаяИнформацияОбъекта(КонтактнаяИнформация, ОбъектКИ, ВидКИ)
	КонтактнаяИнформацияОбъекта = Неопределено;
	
	Если Не КонтактнаяИнформация = Неопределено Тогда 
		ИскомаяКИ = КонтактнаяИнформация.НайтиСтроки(Новый Структура("Объект, Вид", ОбъектКИ, ВидКИ));
		
		Если ИскомаяКИ.Количество() > 0 Тогда
			КонтактнаяИнформацияОбъекта = ИскомаяКИ[0].Представление;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонтактнаяИнформацияОбъекта;
КонецФункции

&НаСервереБезКонтекста 
Функция ТекстЗапросаСведенияОКооперации()
	Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка,
	|	ДоговорыКонтрагентов.ДатаНачалаДействия КАК КонтрактСЗаказчикомДатаНачала,
	|	ДоговорыКонтрагентов.ДатаОкончанияДействия КАК КонтрактСЗаказчикомДатаОкончания,
	|	ДоговорыКонтрагентов.Сумма КАК КонтрактСЗаказчикомСумма,
	|	ДоговорыКонтрагентов.Наименование КАК КонтрактСЗаказчикомПредмет,
	|	ДоговорыКонтрагентов.Контрагент.НаименованиеПолное КАК КонтрактСЗаказчикомЗаказчикНаименованиеПолное,
	|	ДоговорыКонтрагентов.Организация.НаименованиеПолное КАК КонтрактСЗаказчикомИсполнительНаименованиеПолное,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт КАК ГосударственныйКонтракт,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.НомерГОЗ КАК ГосударственныйКонтрактИдентификатор,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.Наименование КАК ГосударственныйКонтрактПредмет,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.ГодЗаключения КАК ГосударственныйКонтрактСрокиГодЗаключения,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.ГодОкончанияСрокаДействия КАК ГосударственныйКонтрактСрокиГодОкончанияСрокаДействия,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.КодСпособаОпределенияПоставщика КАК КодСпособаОпределенияПоставщика,
	|	ДоговорыКонтрагентов.ГосударственныйКонтракт.ГоловнойИсполнитель КАК ГоловнойИсполнитель,
	|	ВЫБОР
	|		КОГДА ДоговорыКонтрагентов.ГосударственныйКонтракт.ГоловнойИсполнитель ССЫЛКА Справочник.Контрагенты
	|			ТОГДА ВЫРАЗИТЬ(ДоговорыКонтрагентов.ГосударственныйКонтракт.ГоловнойИсполнитель КАК Справочник.Контрагенты).НаименованиеПолное
	|		КОГДА ДоговорыКонтрагентов.ГосударственныйКонтракт.ГоловнойИсполнитель ССЫЛКА Справочник.Организации
	|			ТОГДА ВЫРАЗИТЬ(ДоговорыКонтрагентов.ГосударственныйКонтракт.ГоловнойИсполнитель КАК Справочник.Организации).НаименованиеПолное
	|	КОНЕЦ КАК ГоловнойИсполнительНаименованиеПолное,
	|	0 КАК ГосударственныйКонтрактСумма
	|ПОМЕСТИТЬ РеквизитыДоговораСЗаказчиком
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &ДоговорСЗаказчиком
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыМеждуОрганизациями.Ссылка,
	|	ДоговорыМеждуОрганизациями.ДатаНачалаДействия,
	|	ДоговорыМеждуОрганизациями.ДатаОкончанияДействия,
	|	ДоговорыМеждуОрганизациями.Сумма,
	|	ДоговорыМеждуОрганизациями.Наименование,
	|	ДоговорыМеждуОрганизациями.ОрганизацияПолучатель.НаименованиеПолное,
	|	ДоговорыМеждуОрганизациями.Организация.НаименованиеПолное,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.НомерГОЗ,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.Наименование,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГодЗаключения,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГодОкончанияСрокаДействия,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.КодСпособаОпределенияПоставщика,
	|	ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГоловнойИсполнитель,
	|	ВЫБОР
	|		КОГДА ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГоловнойИсполнитель ССЫЛКА Справочник.Контрагенты
	|			ТОГДА ВЫРАЗИТЬ(ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГоловнойИсполнитель КАК Справочник.Контрагенты).НаименованиеПолное
	|		КОГДА ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГоловнойИсполнитель ССЫЛКА Справочник.Организации
	|			ТОГДА ВЫРАЗИТЬ(ДоговорыМеждуОрганизациями.ГосударственныйКонтракт.ГоловнойИсполнитель КАК Справочник.Организации).НаименованиеПолное
	|	КОНЕЦ,
	|	0
	|ИЗ
	|	Справочник.ДоговорыМеждуОрганизациями КАК ДоговорыМеждуОрганизациями
	|ГДЕ
	|	ДоговорыМеждуОрганизациями.Ссылка = &ДоговорСЗаказчиком
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыДоговораСЗаказчиком.Ссылка КАК ДоговорСЗаказчиком,
	|	ДоговорыСЗаказчиками.Ссылка,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент КАК Исполнитель,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент) КАК ЭтоИностранныйИсполнитель,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент.НаименованиеПолное КАК ИсполнительНаименованиеПолное,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент.ИНН КАК ИсполнительИНН,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент.КПП КАК ИсполнительКПП,
	|	ДоговорыСЗаказчиками.Ссылка.Контрагент.РегистрационныйНомер КАК ИсполнительРегистрационныйНомер,
	|	"""" КАК КонтрактСИсполнителемОснование,
	|	ДоговорыСЗаказчиками.Ссылка.Дата КАК КонтрактСИсполнителемДата,
	|	ДоговорыСЗаказчиками.Ссылка.Номер КАК КонтрактСИсполнителемНомер,
	|	ДоговорыСЗаказчиками.Ссылка.Наименование КАК КонтрактСИсполнителемПредмет,
	|	ДоговорыСЗаказчиками.Ссылка.Сумма КАК КонтрактСИсполнителемСумма
	|ПОМЕСТИТЬ РеквизитыДоговоровИсполнителей
	|ИЗ
	|	РеквизитыДоговораСЗаказчиком КАК РеквизитыДоговораСЗаказчиком
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов.ДоговорыСЗаказчиками КАК ДоговорыСЗаказчиками
	|		ПО РеквизитыДоговораСЗаказчиком.Ссылка = ДоговорыСЗаказчиками.ДоговорСЗаказчиком
	|ГДЕ
	|	НЕ ДоговорыСЗаказчиками.Ссылка ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеквизитыДоговораСЗаказчиком.Ссылка,
	|	ДоговорыСЗаказчиками.Ссылка,
	|	ДоговорыСЗаказчиками.Ссылка.Организация,
	|	ДоговорыСЗаказчиками.Ссылка.Организация.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент),
	|	ДоговорыСЗаказчиками.Ссылка.Организация.НаименованиеПолное,
	|	ДоговорыСЗаказчиками.Ссылка.Организация.ИНН,
	|	ДоговорыСЗаказчиками.Ссылка.Организация.КПП,
	|	"""",
	|	"""",
	|	ДоговорыСЗаказчиками.Ссылка.Дата,
	|	ДоговорыСЗаказчиками.Ссылка.Номер,
	|	ДоговорыСЗаказчиками.Ссылка.Наименование,
	|	ДоговорыСЗаказчиками.Ссылка.Сумма
	|ИЗ
	|	РеквизитыДоговораСЗаказчиком КАК РеквизитыДоговораСЗаказчиком
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыМеждуОрганизациями.ДоговорыСЗаказчиками КАК ДоговорыСЗаказчиками
	|		ПО РеквизитыДоговораСЗаказчиком.Ссылка = ДоговорыСЗаказчиками.ДоговорСЗаказчиком
	|ГДЕ
	|	НЕ ДоговорыСЗаказчиками.Ссылка ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыДоговораСЗаказчиком.Ссылка КАК КонтрактСЗаказчиком,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомДатаНачала,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомДатаОкончания,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомСумма,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомПредмет,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомЗаказчикНаименованиеПолное,
	|	РеквизитыДоговораСЗаказчиком.КонтрактСЗаказчикомИсполнительНаименованиеПолное,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтракт,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтрактИдентификатор,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтрактПредмет,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтрактСрокиГодЗаключения,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтрактСрокиГодОкончанияСрокаДействия,
	|	РеквизитыДоговораСЗаказчиком.КодСпособаОпределенияПоставщика,
	|	РеквизитыДоговораСЗаказчиком.ГоловнойИсполнитель,
	|	РеквизитыДоговораСЗаказчиком.ГоловнойИсполнительНаименованиеПолное,
	|	РеквизитыДоговораСЗаказчиком.ГосударственныйКонтрактСумма,
	|	РеквизитыДоговоровИсполнителей.Исполнитель,
	|	ЕСТЬNULL(РеквизитыДоговоровИсполнителей.ЭтоИностранныйИсполнитель, ЛОЖЬ) КАК ЭтоИностранныйИсполнитель,
	|	РеквизитыДоговоровИсполнителей.ИсполнительНаименованиеПолное,
	|	РеквизитыДоговоровИсполнителей.ИсполнительИНН,
	|	РеквизитыДоговоровИсполнителей.ИсполнительКПП,
	|	РеквизитыДоговоровИсполнителей.ИсполнительРегистрационныйНомер,
	|	РеквизитыДоговоровИсполнителей.КонтрактСИсполнителемОснование,
	|	РеквизитыДоговоровИсполнителей.КонтрактСИсполнителемДата,
	|	РеквизитыДоговоровИсполнителей.КонтрактСИсполнителемНомер,
	|	РеквизитыДоговоровИсполнителей.КонтрактСИсполнителемПредмет,
	|	РеквизитыДоговоровИсполнителей.КонтрактСИсполнителемСумма
	|ИЗ
	|	РеквизитыДоговораСЗаказчиком КАК РеквизитыДоговораСЗаказчиком
	|		ЛЕВОЕ СОЕДИНЕНИЕ РеквизитыДоговоровИсполнителей КАК РеквизитыДоговоровИсполнителей
	|		ПО РеквизитыДоговораСЗаказчиком.Ссылка = РеквизитыДоговоровИсполнителей.ДоговорСЗаказчиком";
	
	Возврат Текст;
КонецФункции

#КонецОбласти 
