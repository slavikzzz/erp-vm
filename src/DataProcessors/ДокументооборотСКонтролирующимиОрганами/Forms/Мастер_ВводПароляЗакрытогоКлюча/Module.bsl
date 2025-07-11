
&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Расписка") Тогда
		ПоказыватьРасписку = Истина;
		Расписка = Параметры.Расписка;
	КонецЕсли;
	
	СертификатДляПодписания = Параметры.СертификатДляПодписания;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатДляПодписанияНажатие(Элемент)
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПодписания, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Пароль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСертификата(Сертификат)
	
	Если Сертификат = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	СертификатДействителенС = Формат(Сертификат.ДействителенС, "ДЛФ=D");
	СертификатДействителенПо = Формат(Сертификат.ДействителенПо, "ДЛФ=D");
	
	Если Сертификат.ПоставщикСтруктура.Свойство("O") Тогда
		Издатель = Сертификат.ПоставщикСтруктура["O"];
	Иначе
		Издатель = "";
	КонецЕсли;
	
	Представление = НСтр("ru = '%1 (%2-%3), %4';
						|en = '%1 (%2-%3), %4'");
	Представление = СтрШаблон(
		Представление,
		Сертификат.Наименование,
		СертификатДействителенС,
		СертификатДействителенПо,
		Издатель);
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Процедура ПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Расписка" Тогда
		КонтекстЭДОКлиент.НапечататьДокумент(Расписка, НСтр("ru = 'Расписка';
															|en = 'Расписка'"));
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СертификатПодписания" Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПодписания, ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеФормы()
	
	ПредставлениеСертификата = ПредставлениеСертификата(СертификатДляПодписания);
	
	Если ПоказыватьРасписку Тогда
		
		СсылкаНаРасписку   = Новый ФорматированнаяСтрока(НСтр("ru = 'сертификата';
																|en = 'сертификата'"),,,,"Расписка");
		СсылкаНаСертификат = Новый ФорматированнаяСтрока(ПредставлениеСертификата,,,,"СертификатПодписания");
		
		Пояснение = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Подпишите расписку в получении изданного ';
				|en = 'Подпишите расписку в получении изданного '"),
			СсылкаНаРасписку,
			НСтр("ru = '. Для этого введите пароль закрытого ключа сертификата ';
				|en = '. Для этого введите пароль закрытого ключа сертификата '"),
			СсылкаНаСертификат);
			
		Элементы.Пояснение.Заголовок = Пояснение;
		Элементы.СертификатДляПодписания.Видимость = Ложь;
		
	Иначе
		
		Элементы.СертификатДляПодписания.Заголовок = ПредставлениеСертификата;
		Элементы.СертификатДляПодписания.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(РезультатПолученияКонтекста, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = РезультатПолученияКонтекста.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти