&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(Параметры);
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Успешная отправка заявления на переход" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОтправитьЗаявлениеЗавершение", 
			ЭтотОбъект);
			
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ОписаниеОповещения);
		ДополнительныеПараметры.Вставить("РезультатОтправки", 	  Истина);
			
		Оповестить("Длительная отправка. Выполняемое оповещение", ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Шаг1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполняемоеОповещение = Новый ОписаниеОповещения(
		"ПоказатьФормуВыбораТелефонаИПочтыВОблаке_Завершение", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.ПоказатьФормуВыбораТелефонаИПочтыВОблаке(ЭтотОбъект, ВыполняемоеОповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявление(Команда)
	
	Если НЕ ЗначениеЗаполнено(ПроверкаТелефонДляПаролей.ИдентификаторПроверки) Тогда
		Текст = НСтр("ru = 'Укажите и подтвердите номер телефона, на который будут приходить SMS с паролем для отправки отчетности.';
					|en = 'Укажите и подтвердите номер телефона, на который будут приходить SMS с паролем для отправки отчетности.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ДлительнаяОтправкаКлиент.ПараметрыДлительнойОтправкиЗаявления();
	ДополнительныеПараметры.Вставить("Организация", 			Организация);
	ДополнительныеПараметры.Вставить("ЭтоПереходВКоробку", 		Ложь);
	ДополнительныеПараметры.Вставить("ТипКриптопровайдера", 	Неопределено);
	ДополнительныеПараметры.Вставить("ЭлектроннаяПодписьВМоделиСервиса", Истина);
	ДополнительныеПараметры.Вставить("ИдентификаторПроверкиТелефонаДляПаролей", ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	ДополнительныеПараметры.Вставить("ИдентификаторПроверкиЭлектроннойПочтыДляПаролей", ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки);
	ДополнительныеПараметры.Вставить("ТелефонМобильныйДляАвторизации", ТелефонМобильныйДляПаролей);
	ДополнительныеПараметры.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);

	ТелефонМобильныйБезРазделителей = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ТелефонМобильныйБезРазделителей(ТелефонМобильный);
	ДополнительныеПараметры.Вставить("ТелефонМобильный", ТелефонМобильный);
	ДополнительныеПараметры.Вставить("ПолучатьСМСУведомления", ПолучатьСМСУведомления);

	КонтекстЭДОКлиент.СформироватьИОтправитьЗаявлениеНаПереход(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Инициализация(Параметры)
	
	Организация   = Параметры.Организация;
	УчетнаяЗапись = Организация.УчетнаяЗаписьОбмена;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	ДополнительныеРеквизиты = КонтекстЭДОСервер.ДополнительныеРеквизитыУчетнойЗаписи(УчетнаяЗапись);
	
	ТелефонМобильный = ДополнительныеРеквизиты.ТелефонМобильный;
	ТелефонМобильный = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(ТелефонМобильный);
	ТелефонМобильныйИсходный = ТелефонМобильный;
	ЭлектроннаяПочта = ДополнительныеРеквизиты.ЭлектроннаяПочта;
	
	ПолучатьСМСУведомления = ЗначениеЗаполнено(ТелефонМобильный);
	
	ЭтоПереходВОблако = Истина;
	ЭтоУчетнаяЗаписьВМоделиСервиса = КриптографияЭДКОКлиентСервер.ЭтоПодписьСервиса(УчетнаяЗапись);
	
	ОбработкаЗаявленийАбонентаКлиентСервер.СкопироватьНастройкиПаролейВОблакеИзКоробки(ЭтотОбъект);
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьЗаголовок()
	
	ТекстЗаголовка = НСтр("ru = 'Перенос ключа в программу по %1';
							|en = 'Перенос ключа в программу по %1'");
	Заголовок = СтрШаблон(ТекстЗаголовка, Организация);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	УстановитьЗаголовок();
	
	Подстрока1 = НСтр("ru = 'Номер телефона: ';
						|en = 'Номер телефона: '");
	Если НЕ ЗначениеЗаполнено(ПроверкаТелефонДляПаролей.ИдентификаторПроверки) Тогда
		Подстрока2 = Новый ФорматированнаяСтрока(НСтр("ru = 'не указан';
														|en = 'не указан'"),,Новый Цвет(225, 40, 40),,"номер телефона");
	Иначе
		Подстрока2 = Новый ФорматированнаяСтрока(ТелефонМобильный,,,,"номер телефона");
	КонецЕсли;
	
	Элементы.Шаг2.Заголовок = Новый ФорматированнаяСтрока(Подстрока1, Подстрока2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Истина Тогда
		Если Открыта() Тогда
			
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("Организация", 		Организация);
			ДополнительныеПараметры.Вставить("ЗаявлениеОтправлено", Истина);
		
			Закрыть(ДополнительныеПараметры);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуВыбораТелефонаИПочтыВОблаке_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти