
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция РешениеПринято(Состояние) Экспорт
	Возврат СостоянияРешениеПринято().Найти(Состояние) <> Неопределено;
КонецФункции

Функция СостоянияРешениеПринято() Экспорт
	
	Состояния = Новый Массив;
	Состояния.Добавить(Согласовано);
	Состояния.Добавить(Отклонено);
	
	Возврат Состояния;
	
КонецФункции

#Область ИнтеграцияС1СДокументооборот

Функция СостояниеСогласованияБЗК(ТипРеквизита, СостояниеДО) Экспорт
	
	Результат = Неопределено;
	
	Если ТипРеквизита = Тип("ПеречислениеСсылка.СостоянияСогласования") Тогда
		
		Если СостояниеДО = "Согласован" Тогда
			Результат = Перечисления.СостоянияСогласования.Согласовано;
			
		ИначеЕсли СостояниеДО = "НеСогласован" Тогда
			Результат = Перечисления.СостоянияСогласования.Отклонено;
			
		ИначеЕсли СостояниеДО = "НаСогласовании" Тогда
			Результат = Перечисления.СостоянияСогласования.Рассматривается;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриЗаполненииСтатусаСогласованияПоЗначению(Значение, Свойства, СтандартнаяОбработка) Экспорт
	
	Если Не ТипЗнч(Значение) = Тип("ПеречислениеСсылка.СостоянияСогласования") Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение = Перечисления.СостоянияСогласования.Согласовано Тогда
		Свойства.СостояниеСогласование = НСтр("ru = 'Согласовано';
												|en = 'Approved'");
		Свойства.СостояниеСогласованиеID = "Согласовано";
		Свойства.СостояниеСогласованиеТип = "DMDocumentStatus";
		СтандартнаяОбработка = Ложь;
	ИначеЕсли Значение = Перечисления.СостоянияСогласования.Отклонено Тогда
		Свойства.СостояниеСогласование = НСтр("ru = 'Не согласовано';
												|en = 'Not approved'");
		Свойства.СостояниеСогласованиеID = "НеСогласовано";
		Свойства.СостояниеСогласованиеТип = "DMDocumentStatus";
		СтандартнаяОбработка = Ложь;
	ИначеЕсли Значение = Перечисления.СостоянияСогласования.Рассматривается Тогда
		Свойства.СостояниеСогласование = НСтр("ru = 'На согласовании';
												|en = 'Pending approval'");
		Свойства.СостояниеСогласованиеID = "НаСогласовании";
		Свойства.СостояниеСогласованиеТип = "DMDocumentStatus";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли