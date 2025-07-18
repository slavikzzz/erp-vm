#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ПрочиеРасходыНезавершенногоПроизводства.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийПрочиеРасходыНезавершенногоПроизводства"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрНакопления - Метаданные регистра накопления
//  РегистрацияКОтражению - Булево - Признак получения параметров для регистрации к отражению в учете
//
// Возвращаемое значение:
// 	см. ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеРегистра = Неопределено, РегистрацияКОтражению = Ложь) Экспорт
	
	ПараметрыОтражения = ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете(РегистрацияКОтражению);
	
	Если РегистрацияКОтражению Тогда
		Возврат ПараметрыОтражения;
	КонецЕсли;
	
	ПараметрыОтражения.ПутьКДаннымНаправлениеДеятельности = "НаправлениеДеятельности";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Подразделение";
	//++ НЕ УТКА
	ПараметрыОтражения.ПутьКДаннымОбъектНастройки = "ГруппаПродукции";
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Подразделение";
	//-- НЕ УТКА
	ПараметрыОтражения.РесурсыУпр.Добавить("СтоимостьУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("СтоимостьРегл");
	ПараметрыОтражения.ТипДанныхУчета = Перечисления.ТипыДанныхУчета.ДоходыРасходы;
	ПараметрыОтражения.СтруктураАналитики = ОбщегоНазначения.СкопироватьРекурсивно(ИсточникиДанныхПовтИсп.СтруктураАналитикиПоТипуДанныхУчета(ПараметрыОтражения.ТипДанныхУчета));
	ПараметрыОтражения.СтруктураАналитики.СтатьяДоходовРасходов.ПутьКДанным = "СтатьяРасходов";
	ПараметрыОтражения.СтруктураАналитики.АналитикаДоходов.Вставить("Значение", Неопределено);
	
	Если МетаданныеРегистра = Неопределено Тогда
		МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	КонецЕсли;
	
	ФинансовыйУчетПоДаннымБалансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	//++ НЕ УТКА
	МеждународныйУчетПоДаннымФинансовыхРегистров.ИспользоватьНомерСтрокиКакИдентификаторСтроки(ПараметрыОтражения);
	//-- НЕ УТКА
	
	Возврат ПараметрыОтражения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
