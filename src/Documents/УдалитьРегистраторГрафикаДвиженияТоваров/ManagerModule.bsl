#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.УдалитьРегистраторГрафикаДвиженияТоваров.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.14.17";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a8ef19d3-efbe-43d8-ba55-c3dc6cebd7ea");
	Обработчик.Многопоточный = Ложь;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.УдалитьРегистраторГрафикаДвиженияТоваров.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Некритичный;
	Обработчик.Комментарий = НСтр("ru = 'Удаление записей по документам ""(не используется) Регистратор договора с поставщиком (соглашения с поставщиком)""
		|в регистре ""Данные обработанные в центральном узле РИБ""';
		|en = 'Delete records by the ""(not used) Contract with vendor (terms of purchase) recorder"" documents
		|in the ""Data processed in the master node of the distributed infobase"" register'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ.ПолноеИмя());

	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеОбработанныеВЦентральномУзлеРИБ.Данные КАК Данные
		|ИЗ
		|	РегистрСведений.ДанныеОбработанныеВЦентральномУзлеРИБ КАК ДанныеОбработанныеВЦентральномУзлеРИБ
		|ГДЕ
		|	ДанныеОбработанныеВЦентральномУзлеРИБ.Данные ССЫЛКА Документ.УдалитьРегистраторГрафикаДвиженияТоваров
		|";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = Метаданные.РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ.ПолноеИмя();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			
			// Блокировка регистра распределения запасов.
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеОбработанныеВЦентральномУзлеРИБ");
			ЭлементБлокировки.УстановитьЗначение("Данные", Выборка.Данные);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ДанныеОбработанныеВЦентральномУзлеРИБ.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Данные.Установить(Выборка.Данные, Истина);
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() > 0 Тогда
				НаборЗаписей.Очистить();
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, Истина);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбработкаЗавершена = Ложь;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Неопределено);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
