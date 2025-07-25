#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Установка параметров настроек штатного расписания
	НастройкиШтатногоРасписания = УправлениеШтатнымРасписанием.НастройкиШтатногоРасписания();
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДнейСохраненияБрони"));
	ЗначениеПараметра.Значение = НастройкиШтатногоРасписания.ДнейСохраненияБрони;
	ЗначениеПараметра.Использование = Истина;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРаботуНаНеполнуюСтавку") Тогда
		
		ФорматКоличестваСтавок = УправлениеШтатнымРасписанием.ФорматКоличестваСтавок();
		Для каждого ЭлементУсловноеОформления Из НастройкиОтчета.УсловноеОформление.Элементы Цикл
			Если ЭлементУсловноеОформления.Представление = НСтр("ru = 'Формат вывода количества ставок';
																|en = 'Output format of rate quantity'") Тогда
				ЭлементУсловноеОформления.Оформление.УстановитьЗначениеПараметра("Формат", ФорматКоличестваСтавок);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаВТабличныйДокумент(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ВывестиВНаборДанныхДополнительныеПоляПредставлений(
		СхемаКомпоновкиДанных.НаборыДанных.Найти("КадроваяИсторияСотрудников"), ДополнительныеПоляПредставлений());
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "СхемаИнициализирована" Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = "СхемаИнициализирована";
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДополнительныеПоляПредставлений() Экспорт
	
	ДополнительныеПоляКадровыхДанныхСотрудников = КадровыйУчет.ПоляПредставленийКадровыхДанныхСотрудников();
	
	ДополнительныеПоля = Новый Структура;
	ДополнительныеПоля.Вставить("Представления_КадровыеДанныеСотрудников", ДополнительныеПоляКадровыхДанныхСотрудников);
	
	Возврат ДополнительныеПоля;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли