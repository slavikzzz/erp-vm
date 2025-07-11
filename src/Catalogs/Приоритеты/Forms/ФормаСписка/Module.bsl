#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключениеПриСоздании = Истина;
	
	//++ НЕ УТКА
	
	ВызватьИсключениеПриСоздании = ВызватьИсключениеПриСоздании
								   И Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	
	//-- НЕ УТКА
	
	//++ НЕ УТ
	
	ВызватьИсключениеПриСоздании = ВызватьИсключениеПриСоздании
								   И Не ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	//-- НЕ УТ
	
	Если ВызватьИсключениеПриСоздании Тогда
		ТекстСообщения = НСтр("ru = 'Непосредственное открытие формы списка справочника ""Приоритеты"" не предусмотрено.';
								|en = 'Cannot directly open the ""Priorities"" catalog list form.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДоступноИзменение = ПравоДоступа("Изменение", Метаданные.Справочники.Приоритеты);
	
	Элементы.ГруппаИзменениеПорядка.Доступность = ДоступноИзменение;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
