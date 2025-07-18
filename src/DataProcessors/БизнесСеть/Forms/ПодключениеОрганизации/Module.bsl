
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ВызватьИсключение НСтр("ru = 'Не передана организация';
								|en = 'Company is not passed'");
	КонецЕсли;
				
	НастроитьФормуПриСоздании();
	
	ВыполнитьПроверкуФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.КартинкаДлительнаяОперация.Видимость Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, ДанныеСервиса);
	
	ОписаниеОповещенияОЗакрытии = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперссылкаНаСайтБизнесСетиНажатие(Элемент)
	
	ЕстьОшибки = Ложь;
	
	ПроверитьВывестиОшибки(ЕстьОшибки);
	
	Если Не ЕстьОшибки Тогда	
		ОткрытьСайтБизнесСети();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("РежимПриглашения",     "Общий");
	ПараметрыОткрытия.Вставить("Организация",          Организация);
	ПараметрыОткрытия.Вставить("ЗаполнятьПриОткрытии", Истина);
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашенийКонтрагентам", ПараметрыОткрытия);

	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)

	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПриДлительнойОперации(Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьОрганизациюКСервисуЗавершение", ЭтотОбъект);
	
	БизнесСетьСлужебныйКлиент.ПодключитьОрганизациюКСервису(Организация, КодАктивации, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменаПодключения(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьПроверку(Команда)
	ВыполнитьПроверкуФормыНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключениеОрганизацииКСервису

&НаКлиенте
Процедура ПодключитьОрганизациюКСервисуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НастроитьФормуПриДлительнойОперации(Ложь);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БизнесСетьСлужебныйКлиент.ВывестиСообщенияФоновогоЗадания(Результат);
	
	ДанныеСервиса = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если Не ЗначениеЗаполнено(ДанныеСервиса) Тогда
		БизнесСетьСлужебныйКлиент.ПоказатьОповещениеБизнесСети(НСтр("ru = 'Не удалось подключить организацию';
																	|en = 'Cannot attach the company'"));
		Возврат;
	КонецЕсли;
	
	Если ДанныеСервиса.СтатусПодключения = "Подключена" Тогда
		Оповестить("Запись_НаборКонстант",, "ИспользоватьОбменБизнесСеть");
		Оповестить("БизнесСеть_РегистрацияОрганизаций",, ВладелецФормы);
		НастроитьФормуПослеПодключенияОрганизации();
	Иначе
		БизнесСетьСлужебныйКлиент.ПоказатьОповещениеБизнесСети(НСтр("ru = 'Не удалось подключить организацию';
																	|en = 'Cannot attach the company'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьФормуПриСоздании()
	
	Если БизнесСеть.ТребуетсяПовторноеПодключениеОрганизации(Организация) Тогда
		ШаблонСтроки = 
			НСтр("ru = 'Для организации <a href=""%1"">%2</a> доступ к сервису 1С:Бизнес-сеть был приостановлен. Необходимо повторное подключение организации.';
				|en = 'Access of the company <a href=""%1"">%2</a> to the 1C:Business network service was suspended. Please, reconnect the company.'");
	Иначе
		ШаблонСтроки = НСтр("ru = 'Для подключения информационной базы к организации 
			|<a href=""%1"">%2</a> в сервисе 1С:Бизнес-сеть, введите одноразовый пароль.';
			|en = 'Enter a one-time password to connect an infobase to a company
			|<a href=""%1"">%2</a> in the 1C:Business Network service.'");
	КонецЕсли;	

	Элементы.ПодсказкаФормы.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		ШаблонСтроки,
		ПолучитьНавигационнуюСсылку(Организация), 
		Организация);
	
	Элементы.КартинкаДлительнаяОперация.Видимость = Ложь;
			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСайтБизнесСети()
	
	ДанныеОрганизации = ПолучитьИзВременногоХранилища(ДанныеОрганизацииВBase64);
	
	БизнесСетьСлужебныйКлиент.ОткрытьСтраницуРегистрацииОрганизации(ДанныеОрганизации);

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПриДлительнойОперации(ЭтоНачалоДлительнойОперации)
	
	Элементы.КартинкаДлительнаяОперация.Видимость = ЭтоНачалоДлительнойОперации;
	Элементы.Продолжить.Доступность               = Не ЭтоНачалоДлительнойОперации;
	Элементы.Отмена.Доступность                   = Не ЭтоНачалоДлительнойОперации;
	Элементы.КодАктивации.Доступность             = Не ЭтоНачалоДлительнойОперации;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПослеПодключенияОрганизации()
		
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОрганизацияПодключена;
	
	Элементы.Продолжить.Доступность = Ложь;
	
	Элементы.ПодсказкаФормы.Заголовок = 
		СтроковыеФункции.ФорматированнаяСтрока(
			СтрШаблон(
				"Подключение информационной базы к организации 
				|<a href=""%1"">%2</a> в сервисе 1С:Бизнес-сеть завершено.",
					ПолучитьНавигационнуюСсылку(Организация), Организация));
					
	Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть';
									|en = 'Close'");

КонецПроцедуры

&НаСервере
Процедура ПроверитьВывестиОшибки(ЕстьОшибки = Ложь)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницы", "ТекущаяСтраница", 
		Элементы.СтраницаКодАктивации);
	
	МассивОшибок = Новый Массив;
	
	ПроверкаКорректностиИННКПП(МассивОшибок);
		
	ЕстьОшибки = МассивОшибок.Количество() > 0;
	
	Если ЕстьОшибки Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницы", "ТекущаяСтраница", 
			Элементы.СтраницаОшибки);
		
		Разделитель = СтрШаблон("%1---%2", Символы.ПС, Символы.ПС);
		
		ОбщийТекстОшибок = СтрСоединить(МассивОшибок, Разделитель);
		
		ФорматированныйТекстОшибок = СтроковыеФункции.ФорматированнаяСтрока(ОбщийТекстОшибок);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НадписьОписаниеОшибкиРасширенное", 
			"Заголовок", ФорматированныйТекстОшибок);
			
	КонецЕсли;
	
	УправлениеКомандамиФормы(ЕстьОшибки);
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаКорректностиИННКПП(МассивОшибок)
	
	ИмяРеквизитаИННОрганизации = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации");
	
	ИмяРеквизитаКППОрганизации = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППОрганизации");
	
	ШаблонИменИННКПП = "%1, %2";
	
	ИменаРеквизитовИННКППОрганизации = 
		СтрШаблон(ШаблонИменИННКПП, ИмяРеквизитаИННОрганизации, ИмяРеквизитаКППОрганизации);
		
	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаРеквизитовИННКППОрганизации);
	
	ТекстИменИННКПП = "";
			
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДанныеОрганизации[ИмяРеквизитаИННОрганизации]) Тогда
		
		ТекстИменИННКПП = СтрШаблон(ШаблонИменИННКПП, ТекстИменИННКПП, ИмяРеквизитаИННОрганизации);
								
	КонецЕсли;
		
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДанныеОрганизации[ИмяРеквизитаКППОрганизации]) Тогда
		
		ТекстИменИННКПП = СтрШаблон(ШаблонИменИННКПП, ТекстИменИННКПП, ИмяРеквизитаКППОрганизации);
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстИменИННКПП) Тогда
		
		МассивИменИННКПП = СтрРазделить(ТекстИменИННКПП, ", ", Ложь);
		
		ТексИменИННКПП = СтрСоединить(МассивИменИННКПП, ", ");
		
		ШаблонОшибки = НСтр("ru = 'У %1 организации должны присутствовать только числовые символы. 
			|%2<a href=""%3"">Исправьте</a> данные в карточке организации и повторите попытку.';
			|en = 'The %1 company must have only numeric characters. 
			|%2<a href=""%3"">Correct</a> the data in the company card and try again.'");
		
		ТекстОшибокИННКПП = СтрШаблон(ШаблонОшибки, ТексИменИННКПП, Символы.ПС, ПолучитьНавигационнуюСсылку(Организация));
		
		МассивОшибок.Добавить(ТекстОшибокИННКПП);
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УправлениеКомандамиФормы(ЕстьОшибки)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Продолжить", "Видимость", Не ЕстьОшибки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПовторитьПопытку", "Видимость", ЕстьОшибки);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуФормыНаСервере()

	ЕстьОшибки = Ложь;
	
	ПроверитьВывестиОшибки(ЕстьОшибки);	
	
	Если Не ЕстьОшибки Тогда
		
		ПоместитьДанныеОрганизацииВХранилище();
				
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПоместитьДанныеОрганизацииВХранилище()
	
	ДанныеОрганизацииВBase64 = 
		ПоместитьВоВременноеХранилище(
			БизнесСеть.ДанныеОрганизацииВBase64(Организация), УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти