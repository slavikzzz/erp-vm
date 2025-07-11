#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ТипНалогообложенияНДС") Тогда 
		НоваяСтрока = ТипыНалогообложенияНДС.Добавить();
		НоваяСтрока.ТипНалогообложенияНДС = ДанныеЗаполнения.ТипНалогообложенияНДС;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМногострановойУчет") Тогда
		Страна = ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	БлокировкаДанных = Новый БлокировкаДанных();
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ОсновныеСтавкиНДС"); //ЭлементБлокировкиДанных
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	БлокировкаДанных.Заблокировать();
	
	БлокировкаДанных = Новый БлокировкаДанных();
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.СтавкиНДС"); //ЭлементБлокировкиДанных
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
	БлокировкаДанных.Заблокировать();
	
	// Очистим записи по данной ставке
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновныеСтавкиНДС.Страна КАК Страна
	|ПОМЕСТИТЬ Страны
	|ИЗ
	|	РегистрСведений.ОсновныеСтавкиНДС КАК ОсновныеСтавкиНДС
	|ГДЕ
	|	ОсновныеСтавкиНДС.СтавкаНДС = &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	&Страна
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкиНДС.НачалоПериода КАК Период,
	|	СтавкиНДС.Страна КАК Страна,
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.Страна В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Т.Страна
	|			ИЗ
	|				Страны КАК Т)
	|	И СтавкиНДС.Основная
	|ИТОГИ ПО
	|	Страна";
	
	Запрос.УстановитьПараметр("Страна", Страна);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаСтрана = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаСтрана.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ОсновныеСтавкиНДС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Страна.Установить(ВыборкаСтрана.Страна);
		
		ВыборкаДетальныеЗаписи = ВыборкаСтрана.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ВыборкаДетальныеЗаписи);
			Если Не ЗначениеЗаполнено(НоваяЗапись.Период) Тогда
				НоваяЗапись.Период = Дата("19800101");
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		Если НачалоПериода >= КонецПериода Тогда
			ТекстОшибки = НСтр("ru = 'Дата окончания периода действия ставки НДС должна быть больше даты начала.';
								|en = 'The validity period end date of the VAT rate must be greater than the start date.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "КонецПериода",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Ссылка = Справочники.СтавкиНДС.БезНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить(Метаданные().Реквизиты.Страна.Имя);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#КонецЕсли
