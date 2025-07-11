#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Возвращает коллекцию вариантов настроек
//
// Возвращаемое значение:
//  Массив -  коллекция объектов со свойствами Имя и Представление (см. ВариантНастроекКомпоновкиДанных).
//
Функция ВариантыНастроек() Экспорт
	
	ВариантыНастроек = Новый Массив;
	
	ПоляНастройки = "Имя, Представление";
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "КонтактнаяИнформацияСотрудников", НСтр("ru = 'Контактная информация сотрудников';
																									|en = 'Employee contact information'")));
	
	Возврат ВариантыНастроек;
	
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	ВариантыОтчета = ВариантыНастроек();
	Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
		
		НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ВариантОтчета.Имя);
		НастройкиВарианта.Описание = 
		НСтр("ru = 'Контактная информация сотрудников: адрес проживания, телефоны, email.';
			|en = 'Employee contact information: residence address, phones, email.'");
		
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли