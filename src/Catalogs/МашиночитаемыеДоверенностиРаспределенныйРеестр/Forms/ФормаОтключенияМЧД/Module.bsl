
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваДоверенности  = Параметры.СвойстваДоверенности;
	ЭтоОтключениеИзПанели = Параметры.ЭтоОтключениеИзПанели;
	
	МассивКодовНалоговыхОрганов = ДокументооборотСКОВызовСервера.КодыНалоговыхОргановМЧДФНС(
		СвойстваДоверенности.СсылкаМЧДФНС);
	КоличествоНалоговыхОрганов = МассивКодовНалоговыхОрганов.Количество();
	ФИОПредставителя = ДокументооборотСКОВызовСервера.ФИОМЧДФНС(СвойстваДоверенности.СсылкаМЧДФНС,
		Перечисления.СубъектыДоверенностиНалогоплательщика.ПредставительФЛ, СвойстваДоверенности);
	Если СвойстваДоверенности.КоличествоПредставителей > 1 Тогда
		ФИОПредставителя = ФИОПредставителя + " " + СтрШаблон(
			НСтр("ru = 'и еще %1';
				|en = 'и еще %1'"),
			Формат(СвойстваДоверенности.КоличествоПредставителей - 1, "ЧДЦ=; ЧН=; ЧГ="));
	КонецЕсли;
	
	Если КоличествоНалоговыхОрганов >= 10 Тогда
		КоличествоНалоговыхОргановТекстом = ОбщегоНазначенияЭДКОКлиентСервер.ПростоеСклонение(
			КоличествоНалоговыхОрганов,
			НСтр("ru = '%1 инспекция';
				|en = '%1 инспекция'"),
			НСтр("ru = '%1 инспекции';
				|en = '%1 инспекции'"),
			НСтр("ru = '%1 инспекций';
				|en = '%1 инспекций'"));
		КоличествоНалоговыхОргановТекстом = СтрШаблон(
			КоличествоНалоговыхОргановТекстом,
			Формат(КоличествоНалоговыхОрганов, "ЧДЦ=; ЧН="));
	КонецЕсли;
	
	Если СвойстваДоверенности.СтатусДоверенности =
		Перечисления.СтатусыМашиночитаемойДоверенностиКО.ИстекСрокДействия Тогда
		
		Элементы.ДекорацияСтатусДоверенности.Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Истек срок действия';
				|en = 'Истек срок действия'") + " " + НСтр("ru = 'машиночитаемой';
															|en = 'машиночитаемой'") + " ",
			Новый ФорматированнаяСтрока(НСтр("ru = 'доверенности';
											|en = 'доверенности'"),,,, "доверенность"),
			".");
	КонецЕсли;
	
	МаксимальноеКоличествоСимволовЗначения = 35;
	Элементы.ЗначенияРеквизитовДоверенности.Заголовок =
		?(СтрДлина(СвойстваДоверенности.НаименованиеОрганизации) > МаксимальноеКоличествоСимволовЗначения,
			Лев(СвойстваДоверенности.НаименованиеОрганизации, МаксимальноеКоличествоСимволовЗначения - 3) + "...",
			СвойстваДоверенности.НаименованиеОрганизации) + "
		|" + НСтр("ru = 'с';
					|en = 'с'") + " "
			+ Формат(СвойстваДоверенности.ДатаВыдачи, "ДФ='дд.ММ.гггг'")
			+ ?(ЗначениеЗаполнено(СвойстваДоверенности.ДатаОкончания),
				" " + НСтр("ru = 'по';
							|en = 'по'") + " " + Формат(СвойстваДоверенности.ДатаОкончания, "ДФ='дд.ММ.гггг'"), "")
			+ ?(НЕ ЗначениеЗаполнено(СвойстваДоверенности.ДатаОкончания)
				И ЗначениеЗаполнено(СвойстваДоверенности.СрокДействия), " " + СвойстваДоверенности.СрокДействия, "") + "
		|" + ?(СтрДлина(ФИОПредставителя) > МаксимальноеКоличествоСимволовЗначения,
			Лев(ФИОПредставителя, МаксимальноеКоличествоСимволовЗначения - 3) + "...", ФИОПредставителя) + "
		|" + ?(КоличествоНалоговыхОрганов = 0, НСтр("ru = 'Все';
													|en = 'Все'"),
			?(ЗначениеЗаполнено(КоличествоНалоговыхОргановТекстом), КоличествоНалоговыхОргановТекстом,
			СтрСоединить(МассивКодовНалоговыхОрганов, ", ")));
	
	Элементы.РегистрацииВНалоговомОрганеКПП.Видимость = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(
		СвойстваДоверенности.ОрганизацияСсылка);
	Элементы.РегистрацииВНалоговомОрганеНаименованиеОрганизации.Видимость =
		СвойстваДоверенности.Организации.Количество() > 1;
	ОбновитьРегистрацииВНалоговомОргане(СвойстваДоверенности.РегистрацииВНалоговомОргане);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСтатусДоверенностиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "доверенность" Тогда
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(, СвойстваДоверенности.СсылкаМЧДФНС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацииВНалоговомОрганеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацииВНалоговомОрганеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбраннаяСтрока = Неопределено ИЛИ ВыбраннаяСтрока < 0
		ИЛИ ВыбраннаяСтрока >= РегистрацииВНалоговомОргане.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", РегистрацииВНалоговомОргане[ВыбраннаяСтрока].РегистрацияСсылка);
	ОткрытьФорму(
		"Справочник.РегистрацииВНалоговомОргане.ФормаОбъекта",
		ПараметрыФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого Стр Из РегистрацииВНалоговомОргане Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого Стр Из РегистрацииВНалоговомОргане Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ОтключениеВыполнено = ЭтоОтключениеИзПанели И (Элементы.ФормаДа.Видимость И НЕ Элементы.ФормаНет.Видимость);
	
	Если НЕ ОтключениеВыполнено Тогда
		ОтключитьМЧДФНС();
		Оповестить("ОтключениеМЧДФНС",, СвойстваДоверенности.СсылкаМЧДФНС);
	КонецЕсли;
	
	Если ЭтоОтключениеИзПанели И НЕ ОтключениеВыполнено Тогда
		Элементы.ГруппаКнопкиТаблицы.Видимость 					= Ложь;
		Элементы.РегистрацииВНалоговомОрганеПометка.Видимость 	= Ложь;
		Элементы.ФормаДа.Заголовок 								= НСтр("ru = 'Закрыть';
																			|en = 'Закрыть'");
		Элементы.ФормаНет.Видимость 							= Ложь;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Готово!';
														|en = 'Готово!'"));
	Иначе
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменения(Команда)
	
	НоваяИгнорируемаяНедействительнаяМЧДФНС = СвойстваДоверенности.СсылкаМЧДФНС;
	ДокументооборотСКОВызовСервера.НедействительныеМЧДФНС(НоваяИгнорируемаяНедействительнаяМЧДФНС);
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	КоличествоПомеченных = 0;
	Для каждого Стр Из Форма.РегистрацииВНалоговомОргане Цикл
		Если Стр.Пометка Тогда
			КоличествоПомеченных = КоличествоПомеченных + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоПомеченныхТекстом = ОбщегоНазначенияЭДКОКлиентСервер.ПростоеСклонение(
		КоличествоПомеченных,
		НСтр("ru = 'Выбрана %1';
			|en = 'Выбрана %1'"),
		НСтр("ru = 'Выбрано %1';
			|en = 'Выбрано %1'"),
		НСтр("ru = 'Выбрано %1';
			|en = 'Выбрано %1'"));
	
	КоличествоВсего = Форма.РегистрацииВНалоговомОргане.Количество();
	КоличествоВсегоТекстом = ОбщегоНазначенияЭДКОКлиентСервер.ПростоеСклонение(
		КоличествоВсего,
		НСтр("ru = '%2 инспекции';
			|en = '%2 инспекции'"),
		НСтр("ru = '%2 инспекций';
			|en = '%2 инспекций'"),
		НСтр("ru = '%2 инспекций';
			|en = '%2 инспекций'"));
	
	Форма.Элементы.ИтогПоТаблице.Заголовок = СтрШаблон(
		КоличествоПомеченныхТекстом + " " + НСтр("ru = 'из';
												|en = 'из'") + " "  + КоличествоВсегоТекстом,
		КоличествоПомеченных,
		КоличествоВсего);
	Форма.Элементы.ФормаДа.Доступность = КоличествоПомеченных <> 0;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРегистрацииВНалоговомОргане(МассивРегистрацийВНалоговомОргане)
	
	Для каждого СвойстваРегистрации Из МассивРегистрацийВНалоговомОргане Цикл
		
		ПараметрыОтбора = Новый Структура("РегистрацияСсылка", СвойстваРегистрации.РегистрацияСсылка);
		МассивРегистраций = РегистрацииВНалоговомОргане.НайтиСтроки(ПараметрыОтбора);
		РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Добавить();
		РегистрацияВНалоговомОргане.Пометка = Истина;
		РегистрацияВНалоговомОргане.КодНалоговогоОргана 	= СвойстваРегистрации.КодРегистрации;
		РегистрацияВНалоговомОргане.КПП 					= СвойстваРегистрации.КППРегистрации;
		
		ЗаполнитьЗначенияСвойств(
			РегистрацияВНалоговомОргане, 
			СвойстваРегистрации);
			
	КонецЦикла;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьМЧДФНС()
	
	Для каждого СвойстваРегистрации Из РегистрацииВНалоговомОргане Цикл
		Если СвойстваРегистрации.Пометка Тогда
			Если СвойстваРегистрации.РегистрацияСсылка.Подписанты.Количество() > 0 Тогда
				ОбъектРегистрации = СвойстваРегистрации.РегистрацияСсылка.ПолучитьОбъект();
				ОбъектРегистрации.Прочитать();
				
				Отбор = Новый Структура();
				Отбор.Вставить("Доверенность", СвойстваРегистрации.ДоверенностьРегистрации);
				
				НайденныеСтроки = ОбъектРегистрации.Подписанты.НайтиСтроки(Отбор);
				Для каждого Строка Из НайденныеСтроки Цикл
					ОбъектРегистрации.Подписанты.Удалить(Строка);
				КонецЦикла; 
				
				ОбъектРегистрации.Записать();
				
			Иначе
				ОбъектРегистрации = СвойстваРегистрации.РегистрацияСсылка.ПолучитьОбъект();
				ОбъектРегистрации.Прочитать();
				ОбъектРегистрации.ДокументПредставителя = "";
				ОбъектРегистрации.Представитель = Неопределено;
				ОбъектРегистрации.УполномоченноеЛицоПредставителя = "";
				ОбъектРегистрации.Доверенность = Неопределено;
				ОбъектРегистрации.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
