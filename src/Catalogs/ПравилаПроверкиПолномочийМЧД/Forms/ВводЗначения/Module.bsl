#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	
	Если ТипЗнч(НачальноеЗначение) = Тип("Число") Тогда
		
		НепроверяемыеРеквизиты.Добавить("НачальноеЗначение");
		НепроверяемыеРеквизиты.Добавить("КонечноеЗначение");
		
		Если КонечноеЗначение > 0 И КонечноеЗначение < НачальноеЗначение Тогда
			
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Верхняя граница диапазона не может быть меньше нижней';
									|en = 'The upper bound of the range cannot be less than the lower one'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "КонечноеЗначение");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НепроверяемыеРеквизиты.Количество() > 0 Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальноеЗначение = 0;
	КонечноеЗначение = 0;
	
	ТекстЗаголовка = НСтр("ru = 'Выберите вариант';
							|en = 'Select option'");
	Параметры.Свойство("Заголовок", ТекстЗаголовка);
	Параметры.Свойство("НачальноеЗначение", НачальноеЗначение);
	Параметры.Свойство("КонечноеЗначение", КонечноеЗначение);
	
	Если ТипЗнч(НачальноеЗначение) = Тип("Булево") Тогда
		
		Элементы.ГруппаЧисло.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Выбор варианта';
						|en = 'Select option'");
		Элементы.РеквизитБулево.Заголовок = ТекстЗаголовка;
		РеквизитБулево = 2;
		
		Если НачальноеЗначение <> КонечноеЗначение Тогда
			РеквизитБулево = 2;
		Иначе
			РеквизитБулево = ?(НачальноеЗначение, 1, 0);
		КонецЕсли;
		
	Иначе // ввод числа
		
		Элементы.ГруппаБулево.Видимость = Ложь;
		
		Если ЗначениеЗаполнено(ТекстЗаголовка) Тогда
			Заголовок = ТекстЗаголовка + ":";
		Иначе
			Заголовок = НСтр("ru = 'Ввод суммы:';
							|en = 'Enter an amount:'");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(НачальноеЗначение) = Тип("Булево") Тогда
		
		Если ЗначениеБулево = Да() Тогда
			
			НачальноеЗначение = Истина;
			КонечноеЗначение = Истина;
			
		ИначеЕсли ЗначениеБулево = Нет() Тогда
			
			НачальноеЗначение = Ложь;
			КонечноеЗначение = Ложь;
			
		Иначе
			
			НачальноеЗначение = Истина;
			КонечноеЗначение = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура("НачальноеЗначение, КонечноеЗначение", НачальноеЗначение, КонечноеЗначение);
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Закрыть(Результат)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция Да()
	Возврат НСтр("ru = 'Да';
				|en = 'Yes'");
КонецФункции

&НаСервере
Функция Нет()
	Возврат НСтр("ru = 'Нет';
				|en = 'No'");
КонецФункции

#КонецОбласти
