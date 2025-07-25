#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отчеты.НастройкиПрограммыЗарплатаКадры.СформироватьОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//   Подробнее - см. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора().
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
	Если СвойстваНастройки.ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Организации") Тогда 
		
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
		СвойстваНастройки.ЗначенияДляВыбора.Очистить();
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	Организации.Ссылка
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |ГДЕ
		               |	НЕ Организации.Предопределенный";
													   
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = ТекстЗапроса;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли