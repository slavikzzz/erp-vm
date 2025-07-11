#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ВыводДанных

Процедура ВывестиДанныеВТаблицу(Результат, СтруктураФормированияОтчета, ТаблицаОтчета)
	
	ТаблицаОтчета.Очистить();
	Макет = ПолучитьМакет("ВыводДанных");
	
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока|РеквизитПартнера");
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьОтбор     = Макет.ПолучитьОбласть("Отбор");
	ОбластьОтбор.Параметры.ТекстОтборПоПартнерам = СтруктураФормированияОтчета.ПредставлениеОтбора;
	
	Если СтруктураФормированияОтчета.ГруппироватьПоПартнеру Тогда
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = НСтр("ru = 'Контактная информация контактных лиц';
														|en = 'Contact details of contact persons'");
		ТаблицаОтчета.Вывести(ОбластьЗаголовок);
		ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
		ТаблицаОтчета.НачатьГруппуСтрок("Отбор");
		ТаблицаОтчета.Вывести(ОбластьОтбор,2);
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
		ВывестиШапкуОтчетаСГруппировкой(СтруктураФормированияОтчета, ТаблицаОтчета, Макет);
		ВывестиДанныеВОтчетСГруппировкой(Результат, СтруктураФормированияОтчета, ТаблицаОтчета, Макет);
		
		ТаблицаОтчета.ФиксацияСверху = 5;
		
	Иначе
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = НСтр("ru = 'Контактная информация по партнерам';
														|en = 'Contact details by partners'");
		ТаблицаОтчета.Вывести(ОбластьЗаголовок);
		ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
		ТаблицаОтчета.НачатьГруппуСтрок("Отбор");
		ТаблицаОтчета.Вывести(ОбластьОтбор,2);
		ТаблицаОтчета.ЗакончитьГруппуСтрок();
		ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
		ВывестиШапкуОтчета(СтруктураФормированияОтчета, ТаблицаОтчета, Макет);
		ВывестиДанныеВОтчет(Результат, СтруктураФормированияОтчета, ТаблицаОтчета, Макет);
		ТаблицаОтчета.ФиксацияСлева  = 1;
		ТаблицаОтчета.ФиксацияСверху = 5;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиШапкуОтчета(СтруктураФормированияОтчета, ТаблицаОтчета, Макет)
	
	ОбластьШапкаРеквизитПартнера              = Макет.ПолучитьОбласть("Шапка|РеквизитПартнера");
	ОбластьГруппировкаШапкаРеквизитПартнера   = Макет.ПолучитьОбласть("ГруппировкаШапка|РеквизитПартнера");
	
	ГраницаНетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии);
	ГраницаСплошнаяЛиния    = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);

	КоличествоДанныхПоПартнеру = СтруктураФормированияОтчета.ВыбранныеПоляПартнера.НайтиСтроки(Новый Структура("Пометка",Истина)).Количество() + 1;
	
	ОбластьГруппировкаШапкаРеквизитПартнера.Параметры.ЗаголовокДанныеПартнера =НСтр("ru = 'Данные партнера';
																					|en = 'Partner data'");
	Если КоличествоДанныхПоПартнеру > 1 Тогда
		ОбластьГруппировкаШапкаРеквизитПартнера.Области.ЗаголовокДанныеПартнера.ГраницаСправа = ГраницаНетЛинии;
	КонецЕсли;
	ТаблицаОтчета.Вывести(ОбластьГруппировкаШапкаРеквизитПартнера);
	
	Инд = 2;
	Для каждого Строка Из СтруктураФормированияОтчета.ВыбранныеПоляПартнера Цикл
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьГруппировкаШапкаРеквизитПартнера.Области.ЗаголовокДанныеПартнера.ГраницаСлева = ГраницаНетЛинии;
		
		Если Инд <> КоличествоДанныхПоПартнеру Тогда
			ОбластьГруппировкаШапкаРеквизитПартнера.Области.ЗаголовокДанныеПартнера.ГраницаСправа = ГраницаНетЛинии;
		Иначе
			ОбластьГруппировкаШапкаРеквизитПартнера.Области.ЗаголовокДанныеПартнера.ГраницаСправа = ГраницаСплошнаяЛиния;
		КонецЕсли;
		
		ОбластьГруппировкаШапкаРеквизитПартнера.Параметры.ЗаголовокДанныеПартнера = "";
		ТаблицаОтчета.Присоединить(ОбластьГруппировкаШапкаРеквизитПартнера);
		
		Инд = Инд + 1;
		
	КонецЦикла;
	
	ОбластьРольШапка = Макет.ПолучитьОбласть("ШапкаРольКЛ");
	ОбластьРольШапка.Области.ШапкаРольКЛ.ГраницаСнизу = ГраницаНетЛинии;
	Для каждого Строка Из СтруктураФормированияОтчета.РолиКЛ Цикл
		
		 Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьРольШапка.Параметры.Значение = Строка.Представление;
		ТаблицаОтчета.Присоединить(ОбластьРольШапка);
		
	КонецЦикла;
	
	ОбластьГруппировкаШапкаРеквизитПартнера.Области.ЗаголовокДанныеПартнера.ГраницаСправа = ГраницаСплошнаяЛиния;
	ОбластьГруппировкаШапкаРеквизитПартнера.Параметры.ЗаголовокДанныеПартнера =НСтр("ru = 'Рабочее наименование';
																					|en = 'Working title'");
	ТаблицаОтчета.Вывести(ОбластьГруппировкаШапкаРеквизитПартнера);
	
	Для каждого Строка Из СтруктураФормированияОтчета.ВыбранныеПоляПартнера Цикл
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьГруппировкаШапкаРеквизитПартнера.Параметры.ЗаголовокДанныеПартнера = Строка.Представление;
		ТаблицаОтчета.Присоединить(ОбластьГруппировкаШапкаРеквизитПартнера);
		
	КонецЦикла;
	
	ОбластьРольШапка.Области.ШапкаРольКЛ.ГраницаСнизу  = ГраницаСплошнаяЛиния;
	ОбластьРольШапка.Области.ШапкаРольКЛ.ГраницаСверху = ГраницаНетЛинии;
	Для каждого Строка Из СтруктураФормированияОтчета.РолиКЛ Цикл
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьРольШапка.Параметры.Значение = "";
		ТаблицаОтчета.Присоединить(ОбластьРольШапка);
		
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиДанныеВОтчет(Результат, СтруктураФормированияОтчета, ТаблицаОтчета, Макет)
	
	МассивВыбранныхПолейПартнера  = Новый Массив;
	МассивКИПартнера              = Новый Массив;
	МассивРолей                   = Новый Массив;
	КоличествоВыбранныхКИКЛ       = СтруктураФормированияОтчета.ВыбраннаяКИКЛ.НайтиСтроки(Новый Структура("Пометка", Истина)).Количество();
	ОбластьСтрокаРеквизитПартнера = Макет.ПолучитьОбласть("РеквизитПартнераСтрока|РеквизитПартнера");
	ОбластьСтрокаРольКЛ           = Макет.ПолучитьОбласть("СтрокаРольКЛ");
	
	Для каждого Строка Из СтруктураФормированияОтчета.ВыбранныеПоляПартнера Цикл
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Строка.Значение) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			МассивКИПартнера.Добавить(Строка.Значение);
		Иначе
			МассивВыбранныхПолейПартнера.Добавить(Строка.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	ЕстьКИПартнера = (МассивКИПартнера.Количество() > 0);
	ЕстьКлассификация = (МассивВыбранныхПолейПартнера.Найти("Классификация") <> Неопределено);
	
	Для каждого Строка Из СтруктураФормированияОтчета.РолиКЛ Цикл
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРолей.Добавить(Строка.Значение);
		
	КонецЦикла;
	
	ЕстьДанныеПоРолям = МассивРолей.Количество() > 0;
	
	ВыборкаПартнеры = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПартнеры.Следующий() Цикл
		
		ОбластьСтрокаРеквизитПартнера.Параметры.Значение = ВыборкаПартнеры.НаименованиеПартнера;
		ОбластьСтрокаРеквизитПартнера.Параметры.ЗначениеРасшифровки = ВыборкаПартнеры.ПартнерСсылка;
		ТаблицаОтчета.Вывести(ОбластьСтрокаРеквизитПартнера);
		
		Для каждого Элемент Из МассивВыбранныхПолейПартнера Цикл
			
			Если Элемент <> "Классификация" Тогда
				Если Элемент = "ДатаРегистрации" Тогда
					ОбластьСтрокаРеквизитПартнера.Параметры.Значение = Формат(ВыборкаПартнеры[Элемент],"ДЛФ=D");
				Иначе
					ОбластьСтрокаРеквизитПартнера.Параметры.Значение = ВыборкаПартнеры[Элемент];
				КонецЕсли;
				ОбластьСтрокаРеквизитПартнера.Параметры.ЗначениеРасшифровки = ВыборкаПартнеры.ПартнерСсылка;
				ТаблицаОтчета.Присоединить(ОбластьСтрокаРеквизитПартнера);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьКлассификация Тогда
			
			ВыборкаКлассификация = ВыборкаПартнеры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКлассификация.Следующий() Цикл
			
				ОбластьСтрокаРеквизитПартнера.Параметры.Значение = ВыборкаКлассификация.Классификация;
				ОбластьСтрокаРеквизитПартнера.Параметры.ЗначениеРасшифровки = ВыборкаПартнеры.ПартнерСсылка;
				ТаблицаОтчета.Присоединить(ОбластьСтрокаРеквизитПартнера);
			
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЕстьКИПартнера Тогда
			
			Если ЕстьКлассификация Тогда
				ВыборкаКлассификация.Сбросить();
				ВыборкаКлассификация.Следующий();
				ВыборкаКИПартнера = ВыборкаКлассификация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Иначе
				ВыборкаКИПартнера = ВыборкаПартнеры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			КонецЕсли;
			
			ТекущаяКолонкаКИПартнера = 0;
			
			Пока ВыборкаКИПартнера.Следующий() Цикл
				
				ПоместитьВКолонку = МассивКИПартнера.Найти(ВыборкаКИПартнера.ВидКИПартнера);
				Если ПоместитьВКолонку = Неопределено Тогда
					ВыборкаПредставлениеКИ = Неопределено;
					Продолжить;
				КонецЕсли;
				
				Пока ТекущаяКолонкаКИПартнера < ПоместитьВКолонку Цикл
					ОбластьСтрокаРеквизитПартнера.Параметры.Значение = "";
					ТаблицаОтчета.Присоединить(ОбластьСтрокаРеквизитПартнера);
					ТекущаяКолонкаКИПартнера = ТекущаяКолонкаКИПартнера + 1;
				КонецЦикла;
				
				ВыборкаПредставлениеКИ = ВыборкаКИПартнера.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ПредставлениеКИПартнера = "";
				Пока ВыборкаПредставлениеКИ.Следующий() Цикл
					ПредставлениеКИПартнера = ПредставлениеКИПартнера
					                          + ?(ПустаяСтрока(ПредставлениеКИПартнера),"", Символы.ПС)
					                          + ВыборкаПредставлениеКИ.ПредставлениеКИПартнера;
				КонецЦикла;
				
				ОбластьСтрокаРеквизитПартнера.Параметры.Значение = ПредставлениеКИПартнера;
				ТаблицаОтчета.Присоединить(ОбластьСтрокаРеквизитПартнера);
				ТекущаяКолонкаКИПартнера = ТекущаяКолонкаКИПартнера + 1;
				
			КонецЦикла;
			
			Пока ТекущаяКолонкаКИПартнера < МассивКИПартнера.Количество() Цикл
				ОбластьСтрокаРеквизитПартнера.Параметры.Значение = "";
				ТаблицаОтчета.Присоединить(ОбластьСтрокаРеквизитПартнера);
				ТекущаяКолонкаКИПартнера = ТекущаяКолонкаКИПартнера + 1;
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЕстьДанныеПоРолям Тогда
			
			Если ЕстьКИПартнера Тогда
				Если ВыборкаПредставлениеКИ = Неопределено Тогда
					ВыборкаКИПартнера.Сбросить();
					ВыборкаКИПартнера.Следующий();
					ВыборкаПредставлениеКИ = ВыборкаКИПартнера.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					ВыборкаПредставлениеКИ.Следующий();
					ВыборкаРоли = ВыборкаПредставлениеКИ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Иначе
					ВыборкаПредставлениеКИ.Сбросить();
					ВыборкаПредставлениеКИ.Следующий();
					ВыборкаРоли = ВыборкаПредставлениеКИ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				КонецЕсли;
			Иначе
				Если ЕстьКлассификация Тогда
					ВыборкаКлассификация.Сбросить();
					ВыборкаКлассификация.Следующий();
					ВыборкаРоли = ВыборкаКлассификация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Иначе
					ВыборкаРоли = ВыборкаПартнеры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				КонецЕсли;
			КонецЕсли;
			
			НомерТекущейКолонкиРоли = 1;
			
			Пока ВыборкаРоли.Следующий() Цикл
				
					НомерРолиВМассиве = МассивРолей.Найти(?(ВыборкаРоли.РольКонтактногоЛица = NULL, Справочники.РолиКонтактныхЛицПартнеров.ПустаяСсылка(), ВыборкаРоли.РольКонтактногоЛица));
					Если НомерРолиВМассиве = Неопределено Тогда
						Продолжить;
					Иначе
						НомерКолонкиКЗаполнению = НомерРолиВМассиве + 1;
					КонецЕсли;
					
					ТекстРоль = "";
					
					ВыборкаКЛ = ВыборкаРоли.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаКЛ.Следующий() Цикл
						
						ТекстКЛ = "";
						НаименованиеКЛ = "";
						
						Если ВыборкаКЛ.КЛСсылка = NULL Тогда
							Продолжить;
						КонецЕсли;
						
						ВыборкаВидыКИКЛ = ВыборкаКЛ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаВидыКИКЛ.Следующий() Цикл
							
							ВыборкаДетали = ВыборкаВидыКИКЛ.Выбрать();
							Пока ВыборкаДетали.Следующий() Цикл
								НаименованиеКЛ = ВыборкаДетали.КЛНаименование + ":";
								Если НЕ ПустаяСтрока(ВыборкаДетали.ПредставлениеКИКЛ) Тогда
									ТекстКЛ = ТекстКЛ + Символы.ПС + Символы.Таб +  ВыборкаДетали.ВидКИКЛ + ": " + ВыборкаДетали.ПредставлениеКИКЛ;
								КонецЕсли;
							КонецЦикла;
							
						КонецЦикла;
						
						ТекстРоль = ТекстРоль +?(ПустаяСтрока(ТекстРоль),"", Символы.ПС)+ НаименованиеКЛ + ТекстКЛ;
						
					КонецЦикла;
					
					Пока НомерТекущейКолонкиРоли < НомерКолонкиКЗаполнению Цикл
						ОбластьСтрокаРольКЛ.Параметры.Значение = "";
						ТаблицаОтчета.Присоединить(ОбластьСтрокаРольКЛ);
						НомерТекущейКолонкиРоли = НомерТекущейКолонкиРоли + 1;
					КонецЦикла;
					
					ОбластьСтрокаРольКЛ.Параметры.Значение = ТекстРоль;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаРольКЛ);
					НомерТекущейКолонкиРоли = НомерТекущейКолонкиРоли + 1;
					
			КонецЦикла;
			
			Пока НомерТекущейКолонкиРоли < МассивРолей.Количество() + 1 Цикл
				ОбластьСтрокаРольКЛ.Параметры.Значение = "";
				ТаблицаОтчета.Присоединить(ОбластьСтрокаРольКЛ);
				НомерТекущейКолонкиРоли = НомерТекущейКолонкиРоли + 1;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеВОтчетСГруппировкой(Результат, СтруктураФормированияОтчета, ТаблицаОтчета, Макет)
	
	ОбластьПартнерГруппировкаСтрока   = Макет.ПолучитьОбласть("ПартнерГруппировкаСтрока");
	ОбластьПартнерГруппировкаСтрокаКИ = Макет.ПолучитьОбласть("ПартнерГруппировкаСтрокаКИ");
	ОбластьСтрокаРеквизитКЛ           = Макет.ПолучитьОбласть("РеквизитКЛСтрока");
	ОбластьСтрокаКИПКЛ                = Макет.ПолучитьОбласть("КИКЛСтрока");
	
	ГраницаНетЛинии      = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии);
	ГраницаСплошнаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
	
	МассивКИКЛ          = Новый Массив;
	Для каждого СтрокаТаблицы Из СтруктураФормированияОтчета.ВыбраннаяКИКЛ Цикл
	
		Если НЕ СтрокаТаблицы.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		МассивКИКЛ.Добавить(СтрокаТаблицы.Значение);
	
	КонецЦикла;
	КоличествоКолонокКИ = МассивКИКЛ.Количество();
	
	ВыборкаПартнеры = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПартнеры.Следующий() Цикл
		
		ОбластьПартнерГруппировкаСтрока.Параметры.Значение = ВыборкаПартнеры.НаименованиеПартнера;
		ОбластьПартнерГруппировкаСтрока.Параметры.ЗначениеРасшифровки = ВыборкаПартнеры.ПартнерСсылка;
		Если КоличествоКолонокКИ > 0 Тогда
			ОбластьПартнерГруппировкаСтрока.Области.ПартнерГруппировкаСтрока.ГраницаСправа = ГраницаНетЛинии;
		КонецЕсли;
		ТаблицаОтчета.Вывести(ОбластьПартнерГруппировкаСтрока);
		
		НомерВыводимойКолонки = 1;
		Если КоличествоКолонокКИ > 0 Тогда
			
			Пока НомерВыводимойКолонки < КоличествоКолонокКИ + 1 Цикл
				
				Если НомерВыводимойКолонки < КоличествоКолонокКИ Тогда
					ОбластьПартнерГруппировкаСтрокаКИ.Области.ПартнерГруппировкаСтрокаКИ.ГраницаСправа  = ГраницаНетЛинии;
				Иначе
					ОбластьПартнерГруппировкаСтрокаКИ.Области.ПартнерГруппировкаСтрокаКИ.ГраницаСправа  = ГраницаСплошнаяЛиния;
				КонецЕсли;
				
				ОбластьПартнерГруппировкаСтрокаКИ.Параметры.ЗначениеРасшифровки = ВыборкаПартнеры.ПартнерСсылка;
				ТаблицаОтчета.Присоединить(ОбластьПартнерГруппировкаСтрокаКИ);
				НомерВыводимойКолонки = НомерВыводимойКолонки + 1;
			КонецЦикла;
			
		КонецЕсли;
		
		Если КоличествоКолонокКИ > 0 Тогда
			
			ТаблицаОтчета.НачатьГруппуСтрок("КЛПартнера");
			
			ВыборкаКЛ = ВыборкаПартнеры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаКЛ.Следующий() Цикл 
				
				Если ВыборкаКЛ.КЛСсылка = NULL Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаКЛ           = ВыборкаКЛ.КЛСсылка;
				СтрокаРоли         = "";
				ДолжностьПоВизитке = "";
				
				ВыборкаРоли = ВыборкаКЛ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаРоли.Следующий() Цикл
					
					Если ВыборкаРоли.РольКонтактногоЛица <> NULL Тогда
						СтрокаРоли = СтрокаРоли + ?(ПустаяСтрока(СтрокаРоли),"",Символы.ПС) + ВыборкаРоли.РольКонтактногоЛица;
					КонецЕсли;
					ВыборкаВидыКИКЛ = ВыборкаРоли.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаВидыКИКЛ.Следующий() Цикл
						
						Если ВыборкаВидыКИКЛ.ВидКИКЛ = NULL Тогда
							Прервать;
						КонецЕсли;
						
						ТекстКИКЛ = "";
						ВыборкаДетали = ВыборкаВидыКИКЛ.Выбрать();
						Пока ВыборкаДетали.Следующий() Цикл
							ТекстКИКЛ = ТекстКИКЛ + ?(ПустаяСтрока(ТекстКИКЛ),"",Символы.ПС)+ ВыборкаДетали.ВидКИКЛ + ": " + ВыборкаДетали.ПредставлениеКИКЛ;
							ДолжностьПоВизитке = ВыборкаДетали.ДолжностьПоВизитке;
						КонецЦикла;
						
					КонецЦикла;
					
				КонецЦикла;
				
				ОбластьСтрокаРеквизитКЛ.Параметры.КонтактноеЛицо      = СтрокаКЛ;
				ОбластьСтрокаРеквизитКЛ.Параметры.Роли                = СтрокаРоли;
				ОбластьСтрокаРеквизитКЛ.Параметры.ДолжностьПоВизитке  = ДолжностьПоВизитке;
				ОбластьСтрокаРеквизитКЛ.Параметры.ЗначениеРасшифровки = ВыборкаКЛ.КЛСсылка;
				ТаблицаОтчета.Вывести(ОбластьСтрокаРеквизитКЛ,2);
				
				НомерТекущейКолонки = 1;
				ВыборкаВидыКИКЛ.Сбросить();
				Пока ВыборкаВидыКИКЛ.Следующий() Цикл
					
					ПредставлениеКИ = "";
					Если ВыборкаВидыКИКЛ.ВидКИКЛ = NULL Тогда
						Прервать;
					КонецЕсли;
					
					ВыборкаДетали = ВыборкаВидыКИКЛ.Выбрать();
					ПредставлениеКИ = "";
					Пока ВыборкаДетали.Следующий() Цикл
						ПредставлениеКИ = ПредставлениеКИ + ?(ПустаяСтрока(ПредставлениеКИ), "", Символы.ПС) + ВыборкаДетали.ПредставлениеКИКЛ;
					КонецЦикла;
					
					НомерКолонкиКЗаполнению = МассивКИКЛ.Найти(ВыборкаВидыКИКЛ.ВидКИКЛ) + 1;
					
					Пока НомерТекущейКолонки < НомерКолонкиКЗаполнению Цикл
						ОбластьСтрокаКИПКЛ.Параметры.Значение = "";
						ТаблицаОтчета.Присоединить(ОбластьСтрокаКИПКЛ);
						НомерТекущейКолонки = НомерТекущейКолонки + 1;
					КонецЦикла;
					
					ОбластьСтрокаКИПКЛ.Параметры.Значение = ПредставлениеКИ;
					ТаблицаОтчета.Присоединить(ОбластьСтрокаКИПКЛ);
					НомерТекущейКолонки = НомерТекущейКолонки + 1;
					
				КонецЦикла;
				
				Пока НомерТекущейКолонки < КоличествоКолонокКИ + 1 Цикл
					ОбластьСтрокаКИПКЛ.Параметры.Значение = "";
					ТаблицаОтчета.Присоединить(ОбластьСтрокаКИПКЛ);
					НомерТекущейКолонки = НомерТекущейКолонки + 1;
				КонецЦикла;
				
			КонецЦикла;
			
			ТаблицаОтчета.ЗакончитьГруппуСтрок();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиШапкуОтчетаСГруппировкой(СтруктураФормированияОтчета, ТаблицаОтчета, Макет)
	
	ОбластьШапкаПартнер     = Макет.ПолучитьОбласть("ШапкаПартнер");
	ОбластьШапкаКЛ          = Макет.ПолучитьОбласть("КИКЛШапка");
	ОбластьШапкаРеквизитыКЛ = Макет.ПолучитьОбласть("ШапкаРеквизитыКЛ");
	
	ГраницаНетЛинии      = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии);
	ГраницаСплошнаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
	
	МассивКИКЛ          = Новый Массив;
	Для каждого СтрокаТаблицы Из СтруктураФормированияОтчета.ВыбраннаяКИКЛ Цикл
	
		Если НЕ СтрокаТаблицы.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		МассивКИКЛ.Добавить(СтрокаТаблицы.Значение);
	
	КонецЦикла;
	КоличествоКолонок = МассивКИКЛ.Количество();
	
	ТаблицаОтчета.Вывести(ОбластьШапкаПартнер);
	
	НомерВыводимойКолонки = 1;
	Если КоличествоКолонок > 0 Тогда
		Пока НомерВыводимойКолонки < КоличествоКолонок + 1 Цикл
			
			Если НомерВыводимойКолонки = 1 Тогда 
				ОбластьШапкаКЛ.Параметры.Значение = НСтр("ru = 'Контактная информация';
														|en = 'Contact details'");
			Иначе
				ОбластьШапкаКЛ.Параметры.Значение = "";
			КонецЕсли;
			
			Если НомерВыводимойКолонки < КоличествоКолонок Тогда
				ОбластьШапкаКЛ.Области.КИКЛШапка.ГраницаСправа  = ГраницаНетЛинии;
			Иначе
				ОбластьШапкаКЛ.Области.КИКЛШапка.ГраницаСправа  = ГраницаСплошнаяЛиния;
			КонецЕсли;
			
			Если НомерВыводимойКолонки > 1 Тогда
				ОбластьШапкаКЛ.Области.КИКЛШапка.ГраницаСлева  = ГраницаНетЛинии;
			Иначе
				ОбластьШапкаКЛ.Области.КИКЛШапка.ГраницаСлева  = ГраницаСплошнаяЛиния;
			КонецЕсли;
			
			ТаблицаОтчета.Присоединить(ОбластьШапкаКЛ);
			НомерВыводимойКолонки = НомерВыводимойКолонки + 1;
		КонецЦикла;
		
		ОбластьШапкаКЛ.Области.КИКЛШапка.ГраницаСлева  = ГраницаСплошнаяЛиния;
		
	КонецЕсли;
	
	ТаблицаОтчета.Вывести(ОбластьШапкаРеквизитыКЛ);
	
	НомерВыводимойКолонки = 1;
	Если КоличествоКолонок > 0 Тогда
		Для Каждого Элемент Из МассивКИКЛ Цикл
			ОбластьШапкаКЛ.Параметры.Значение = Элемент;
			ТаблицаОтчета.Присоединить(ОбластьШапкаКЛ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеИВыполнениеЗапроса

Функция РезультатЗапросаПоДаннымОтчета(СтруктураФормированияОтчета)
	
	СоответствиеПараметровЗапросаВидовКИ = Новый Соответствие;
	
	Если НЕ СтруктураФормированияОтчета.ГруппироватьПоПартнеру Тогда
		ТекстЗапросаВыбранныеПоляПартнера = ТекстЗапросаВыбранныеПоляПартнера(СтруктураФормированияОтчета.ВыбранныеПоляПартнера);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Партнеры.Ссылка КАК ПартнерСсылка,
	|	Партнеры.Наименование КАК НаименованиеПартнера" + ТекстЗапросаВыбранныеПоляПартнера + "%ПоляКИПартнера%" +"%ПолеКлассификация%" +"%ПоляКЛ%
	|ИЗ
	|	Справочник.Партнеры КАК Партнеры" +"%СоединениеКИПартнера%"+ "%СоединениеРолиКЛ%" + "%СоединениеКлассификация%
	|ГДЕ
	|Партнеры.Ссылка В
	|		(ВЫБРАТЬ
	|			ОтборПоПартнерам.Партнер
	|		ИЗ
	|			ОтборПоПартнерам КАК ОтборПоПартнерам)
	|
	|УПОРЯДОЧИТЬ ПО
	|  НаименованиеПартнера"  + "%УпорядочитьКИПартнера%" + "%СтрокаУпорядочивания%
	|ИТОГИ ПО
	|	ПартнерСсылка" + "%ИтогиКлассификация%" + "%ИтогиКИПартнера%";
	
	ДобавитьВЗапросДанныеКлассификации(Запрос,СтруктураФормированияОтчета);
	ДобавитьВЗапросДанныеКИПартнера(Запрос.Текст,СтруктураФормированияОтчета, СоответствиеПараметровЗапросаВидовКИ);
	ДобавитьВЗапросВыводПолейКИПартнера(Запрос.Текст,СтруктураФормированияОтчета, СоответствиеПараметровЗапросаВидовКИ.Количество() > 0);
	
	ДобавитьВЗапросДанныеКонтактныхЛиц(Запрос.Текст,СтруктураФормированияОтчета,СоответствиеПараметровЗапросаВидовКИ);
	ДобавитьВЗапросОтбор(Запрос);
	
	Для Каждого Параметр Из СоответствиеПараметровЗапросаВидовКИ Цикл
		
		Запрос.УстановитьПараметр(Параметр.Ключ,Параметр.Значение);
		
	КонецЦикла;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ДобавитьВЗапросДанныеКлассификации(Запрос,СтруктураФормированияОтчета)

	ТекстСоединенияКлассификации = "";
	ТекстПолеКлассификация       = "";
	ТекстИтогиКлассификация      = "";
	
	Если СтруктураФормированияОтчета.ГруппироватьПоПартнеру 
		Или НЕ (ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ABCXYZКлассификацияКлиентов)) Тогда 
		ЕстьВыводКлассификации = ЛОЖЬ;
	Иначе
		ЕстьВыводКлассификации = СтруктураФормированияОтчета.ВыбранныеПоляПартнера.НайтиСтроки(Новый Структура("Значение,Пометка","Классификация",Истина)).Количество() > 0;
	КонецЕсли;
	
	Если ЕстьВыводКлассификации Тогда
		
		ТекстИтогиКлассификация = ",
		|Классификация";
		
		ТекстСоединенияКлассификации = "
		|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(
		|		,
		|		ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Выручка)
		|			И ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC)) КАК ABCСрезПоследних
		|ПО ABCСрезПоследних.Партнер = Партнеры.Ссылка
		|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов.СрезПоследних(
		|		,
		|		ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Выручка)
		|			И ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ)) КАК XYZСрезПоследних
		|ПО XYZСрезПоследних.Партнер = Партнеры.Ссылка";
		
		ТекстПолеКлассификация       = ",
		|ВЫБОР
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.AКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.XКласс)
		|	ТОГДА &AX
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.AКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.YКласс)
		|	ТОГДА &AY
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.AКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|	ТОГДА &AZ
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.BКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.XКласс)
		|	ТОГДА &BX
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.BКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.YКласс)
		|	ТОГДА &BY
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.BКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|	ТОГДА &BZ
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.CКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.XКласс)
		|	ТОГДА &CX
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.CКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.YКласс)
		|	ТОГДА &CY
		|КОГДА ABCСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.CКласс)
		|		И XYZСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|	ТОГДА &CZ
		|ИНАЧЕ &НеКлассифицирован
		|КОНЕЦ КАК Классификация";
		
		Запрос.УстановитьПараметр("AX","AX");
		Запрос.УстановитьПараметр("AY","AY");
		Запрос.УстановитьПараметр("AZ","AZ");
		Запрос.УстановитьПараметр("BX","BX");
		Запрос.УстановитьПараметр("BY","BY");
		Запрос.УстановитьПараметр("BZ","BZ");
		Запрос.УстановитьПараметр("CX","CX");
		Запрос.УстановитьПараметр("CY","CY");
		Запрос.УстановитьПараметр("CZ","CZ");
		Запрос.УстановитьПараметр("НеКлассифицирован",НСтр("ru = 'Не классифицирован';
															|en = 'Not classified'"));
	
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"%СоединениеКлассификация%",ТекстСоединенияКлассификации);
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ПолеКлассификация%",ТекстПолеКлассификация);
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ИтогиКлассификация%",ТекстИтогиКлассификация);

КонецПроцедуры

Процедура ДобавитьВЗапросОтбор(Запрос)

	СхемаДляОтбораПартнеров = ПолучитьМакет("ОтборПоПартнерам");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаДляОтбораПартнеров, КомпоновщикНастроек.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

	ТекстЗапросаОтбор = МакетКомпоновкиДанных.НаборыДанных.Основной.Запрос;
	
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Если Параметр.Имя = "СтрокаAX" Тогда
			Запрос.Параметры.Вставить("СтрокаAX", НСтр("ru = 'AX';
														|en = 'AX'"));
		ИначеЕсли Параметр.Имя = "СтрокаAY" Тогда
			Запрос.Параметры.Вставить("СтрокаAY", НСтр("ru = 'AY';
														|en = 'AY'"));
		ИначеЕсли Параметр.Имя = "СтрокаAZ" Тогда
			Запрос.Параметры.Вставить("СтрокаAZ", НСтр("ru = 'AZ';
														|en = 'AZ'"));
		ИначеЕсли Параметр.Имя = "СтрокаBX" Тогда
			Запрос.Параметры.Вставить("СтрокаBX", НСтр("ru = 'BX';
														|en = 'BX'"));
		ИначеЕсли Параметр.Имя = "СтрокаBY" Тогда
			Запрос.Параметры.Вставить("СтрокаBY", НСтр("ru = 'BY';
														|en = 'BY'"));
		ИначеЕсли Параметр.Имя = "СтрокаBZ" Тогда
			Запрос.Параметры.Вставить("СтрокаBZ", НСтр("ru = 'BZ';
														|en = 'BZ'"));
		ИначеЕсли Параметр.Имя = "СтрокаCX" Тогда
			Запрос.Параметры.Вставить("СтрокаCX", НСтр("ru = 'CX';
														|en = 'CX'"));
		ИначеЕсли Параметр.Имя = "СтрокаCY" Тогда
			Запрос.Параметры.Вставить("СтрокаCY", НСтр("ru = 'CY';
														|en = 'CY'"));
		ИначеЕсли Параметр.Имя = "СтрокаCZ" Тогда
			Запрос.Параметры.Вставить("СтрокаCZ", НСтр("ru = 'CZ';
														|en = 'CZ'"));
		ИначеЕсли Параметр.Имя = "СтрокаНеКлассифицирован" Тогда
			Запрос.Параметры.Вставить("СтрокаНеКлассифицирован", НСтр("ru = 'Не классифицирован';
																		|en = 'Not classified'"));
		Иначе
			Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапросаОтбор = ТекстЗапросаОтбор +"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	НайденнаяПозицияИЗ = СтрНайти(ТекстЗапросаОтбор,"ИЗ");
	Если НайденнаяПозицияИЗ <> 0 Тогда
		ТекстЗапросаОтбор = Лев(ТекстЗапросаОтбор,НайденнаяПозицияИЗ - 1) + "  ПОМЕСТИТЬ ОтборПоПартнерам
		|  " + Прав(ТекстЗапросаОтбор,СтрДлина(ТекстЗапросаОтбор) - НайденнаяПозицияИЗ + 1);
		
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапросаОтбор + Запрос.Текст;

КонецПроцедуры

Процедура ДобавитьВЗапросДанныеКонтактныхЛиц(ТекстЗапроса, СтруктураФормированияОтчета,СоответствиеПараметровЗапросаВидовКИ)
	
	ТекстУсловияПоРолям   = "(";
	ТекстУсловияПоВидамКИ = "(";
	СтрокаИли             = " ИЛИ ";
	ДлинаСтрокиИли        = СтрДлина(СтрокаИли);
	
	Для каждого СтрокаРоли Из СтруктураФормированияОтчета.РолиКЛ Цикл
		
		Если (НЕ СтрокаРоли.Пометка ) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если СтрокаРоли.Значение = Справочники.РолиКонтактныхЛицПартнеров.ПустаяСсылка() Тогда
			СтрокаПараметрЗапросаРоль = "ЕСТЬ NULL";
		Иначе
			СтрокаПараметрЗапросаРоль = " = &РольКЛ" + Строка(СоответствиеПараметровЗапросаВидовКИ.Количество() + 1);
			СоответствиеПараметровЗапросаВидовКИ.Вставить("РольКЛ" + Строка(СоответствиеПараметровЗапросаВидовКИ.Количество() + 1),СтрокаРоли.Значение);
		КонецЕсли;
		
		ТекстУсловияПоРолям = ТекстУсловияПоРолям + "
				|		КонтактныеЛицаПартнеровРолиКонтактногоЛица.РольКонтактногоЛица " + СтрокаПараметрЗапросаРоль + СтрокаИли;
				
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстУсловияПоРолям, ДлинаСтрокиИли);
	ТекстУсловияПоРолям = ТекстУсловияПоРолям + ")";
		
	Для каждого СтрокаКИ Из СтруктураФормированияОтчета.ВыбраннаяКИКЛ Цикл
		
		Если СтрокаКИ.Пометка Тогда
			
			СтрокаПараметрЗапроса = "ВидКИ" + Строка(СоответствиеПараметровЗапросаВидовКИ.Количество() + 1);
			СоответствиеПараметровЗапросаВидовКИ.Вставить(СтрокаПараметрЗапроса, СтрокаКИ.Значение);
			
			ТекстУсловияПоВидамКИ = ТекстУсловияПоВидамКИ + "
			|	 КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид = &" + СтрокаПараметрЗапроса + СтрокаИли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстУсловияПоВидамКИ, ДлинаСтрокиИли);
	ТекстУсловияПоВидамКИ = ТекстУсловияПоВидамКИ + ")";
		
	Если СтрДлина(ТекстУсловияПоРолям) = 1 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ПоляКЛ%","");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%СтрокаУпорядочивания%","");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%СоединениеРолиКЛ%","");
		Возврат;
	КонецЕсли;
	
	ТекстУсловияПоРолям = ТекстУсловияПоРолям + "	И КонтактныеЛицаПартнеров.Владелец В
		|	(ВЫБРАТЬ
		|		ОтборПоПартнерам.Партнер
		|	ИЗ
		|		ОтборПоПартнерам КАК ОтборПоПартнерам)";
		
	ТекстЗапросаДопУпорядочивание = ",
	|РольКонтактногоЛица,
	|ВидКИКЛ
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%СтрокаУпорядочивания%",ТекстЗапросаДопУпорядочивание);
	
	ТекстЗапросаВыбранныеПоляКонтактныхЛиц = ",
	|КонтактныеЛицаРолиКИ.РольКонтактногоЛица КАК РольКонтактногоЛица,
	|КонтактныеЛицаРолиКИ.Вид КАК ВидКИКЛ,
	|КонтактныеЛицаРолиКИ.Представление КАК ПредставлениеКИКЛ,
	|КонтактныеЛицаРолиКИ.ДолжностьПоВизитке КАК ДолжностьПоВизитке,
	|КонтактныеЛицаРолиКИ.Наименование КАК КЛНаименование,
	|КонтактныеЛицаРолиКИ.Ссылка КАК КЛСсылка";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ПоляКЛ%", ТекстЗапросаВыбранныеПоляКонтактныхЛиц);
	
	ТекстЗапросаПоКЛ = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛицаПартнеров.Ссылка,
	|	КонтактныеЛицаПартнеров.Наименование,
	|	КонтактныеЛицаПартнеров.ДолжностьПоВизитке,
	|	КонтактныеЛицаПартнеровРолиКонтактногоЛица.РольКонтактногоЛица,
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид,
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление,
	|	КонтактныеЛицаПартнеров.Владелец
	|ПОМЕСТИТЬ КонтактныеЛицаРолиКИ
	|ИЗ
	|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.РолиКонтактногоЛица КАК КонтактныеЛицаПартнеровРолиКонтактногоЛица
	|		ПО (КонтактныеЛицаПартнеровРолиКонтактногоЛица.Ссылка = КонтактныеЛицаПартнеров.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
	|		ПО (КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка = КонтактныеЛицаПартнеров.Ссылка) И &УсловиеПоВидамКИ 
	|ГДЕ &УсловиеПоРолям
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапросаПоКЛ = СтрЗаменить(ТекстЗапросаПоКЛ, "&УсловиеПоВидамКИ", ТекстУсловияПоВидамКИ);
	ТекстЗапросаПоКЛ = СтрЗаменить(ТекстЗапросаПоКЛ, "&УсловиеПоРолям", ТекстУсловияПоРолям);
	
	ТекстЗапроса = ТекстЗапросаПоКЛ + ТекстЗапроса; 
	
	ТекстЗапросаСоединениеКонтактныеЛицаРолиКИ = " 
	|ЛЕВОЕ СОЕДИНЕНИЕ КонтактныеЛицаРолиКИ КАК КонтактныеЛицаРолиКИ
	|	ПО Партнеры.Ссылка = КонтактныеЛицаРолиКИ.Владелец";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%СоединениеРолиКЛ%",ТекстЗапросаСоединениеКонтактныеЛицаРолиКИ);
	
	ТекстЗапросаИтогиПоРоли = ",
	|РольКонтактногоЛица,
	|КЛСсылка,
	|ВидКИКЛ";
	
	Если СтруктураФормированияОтчета.ГруппироватьПоПартнеру Тогда
		ТекстЗапросаИтогиПоРоли = ",
		|КЛСсылка,
		|РольКонтактногоЛица,
		|ВидКИКЛ";
	Иначе
		ТекстЗапросаИтогиПоРоли = ",
		|РольКонтактногоЛица,
		|КЛСсылка,
		|ВидКИКЛ";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + ТекстЗапросаИтогиПоРоли;
	
КонецПроцедуры

Процедура ДобавитьВЗапросВыводПолейКИПартнера(ТекстЗапроса, СтруктураФормированияОтчета, ЕстьКИПартнера)
	
	Если ЕстьКИПартнера И НЕ СтруктураФормированияОтчета.ГруппироватьПоПартнеру Тогда
		
		ТекстЗамены = ",
		|	ПартнерыКонтактнаяИнформация.Вид КАК ВидКИПартнера,
		|	ПартнерыКонтактнаяИнформация.Представление КАК ПредставлениеКИПартнера";
		
	Иначе
		
		ТекстЗамены = ""
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ПоляКИПартнера%", ТекстЗамены);
	
КонецПроцедуры

Функция ТекстЗапросаВыбранныеПоляПартнера(ВыбранныеПоляПартнера)
	
	ТекстЗапросаВыбранныеПоляПартнера = "";
	
	Для каждого Строка Из ВыбранныеПоляПартнера Цикл
		
		Если ТипЗнч(Строка.Значение) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Или Строка.Значение = "Классификация" Тогда
			Прервать;
		КонецЕсли;
		
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаВыбранныеПоляПартнера = ТекстЗапросаВыбранныеПоляПартнера + ", " + Символы.ПС + "	Партнеры." + Строка.Значение + " КАК " + Строка.Значение;
		
	КонецЦикла;
	
	Возврат ТекстЗапросаВыбранныеПоляПартнера;
	
КонецФункции

Процедура ДобавитьВЗапросДанныеКИПартнера(ТекстЗапроса, СтруктураФормированияОтчета, СоответствиеПараметровЗапросаВидовКИ)
	
	ТекстСоединенияКИПартнера    = "";
	ТекстЗапросаИтогиКИПартнера  = "";
	ТекстУпорядочитьПоКИПартнера = "";
	СтрокаИли                    = " ИЛИ ";
	
	Если НЕ СтруктураФормированияОтчета.ГруппироватьПоПартнеру Тогда
		
		Для каждого Строка Из СтруктураФормированияОтчета.ВыбранныеПоляПартнера Цикл
			
			Если ТипЗнч(Строка.Значение) = Тип("Строка") ИЛИ НЕ Строка.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаПараметрЗапроса = "ВидКИ" + Строка(СоответствиеПараметровЗапросаВидовКИ.Количество() + 1);
			СоответствиеПараметровЗапросаВидовКИ.Вставить(СтрокаПараметрЗапроса,Строка.Значение); 
			ТекстСоединенияКИПартнера = ТекстСоединенияКИПартнера + "ПартнерыКонтактнаяИнформация.Вид = &" + СтрокаПараметрЗапроса + СтрокаИли;
			
		КонецЦикла;
		
		Если НЕ ПустаяСтрока(ТекстСоединенияКИПартнера) Тогда
			
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстСоединенияКИПартнера, СтрДлина(СтрокаИли));
			ТекстСоединенияКИПартнера = "
			|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
			|		ПО (ПартнерыКонтактнаяИнформация.Ссылка = Партнеры.Ссылка) И (" + ТекстСоединенияКИПартнера + ")";
			
			ТекстЗапросаИтогиКИПартнера = ",
			|	ВидКИПартнера,
			|	ПредставлениеКИПартнера";
			
			ТекстУпорядочитьПоКИПартнера =",
			|	ВидКИПартнера";
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%СоединениеКИПартнера%",ТекстСоединенияКИПартнера);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ИтогиКИПартнера%",ТекстЗапросаИтогиКИПартнера);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УпорядочитьКИПартнера%",ТекстУпорядочитьПоКИПартнера);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьОтчет(ТаблицаОтчета, СтруктураФормированияОтчета)  Экспорт
	
	Результат = РезультатЗапросаПоДаннымОтчета(СтруктураФормированияОтчета);
	ВывестиДанныеВТаблицу(Результат, СтруктураФормированияОтчета, ТаблицаОтчета);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли