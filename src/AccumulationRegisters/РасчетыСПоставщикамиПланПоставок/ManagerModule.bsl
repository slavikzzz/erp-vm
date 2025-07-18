
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.14.13";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1d86c915-d170-44ae-9560-190d1f7da828");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документов информационной базы по регистру накопления ""Плановые поставки"".';
									|en = 'Updates register records of infobase documents in the ""Planned deliveries"" accumulation register.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ГрафикИсполненияДоговора.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказПоставщику.ПолноеИмя());
	//++ НЕ УТ
	
	//++ Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ЗаказПереработчику.ПолноеИмя());
	//-- Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ЗаказПереработчику2_5.ПолноеИмя());
	//-- НЕ УТ
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.РасчетыСПоставщикамиПланПоставок";
	
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ПолучитьТекстыЗапроса = Истина;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(ДокументыКОбновлению(), ",");
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыСПоставщиками.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК РасчетыСПоставщикамиПланПоставок
	|			ПО РасчетыСПоставщикамиПланПоставок.Регистратор = РасчетыСПоставщиками.Регистратор
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(РасчетыСПоставщиками.Регистратор) В (&ТипыДокументов)
	|	И РасчетыСПоставщиками.КПоступлению > 0
	|	И РасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И РасчетыСПоставщикамиПланПоставок.Регистратор ЕСТЬ NULL";
	Запрос.УстановитьПараметр("ТипыДокументов", ТипыДокументовКОбновлению());
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыСПоставщикамиПланПоставок";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазыУТ.ДополнительныеПараметрыПерезаписиДвиженийИзОчереди();
	ДополнительныеПараметры.ОбновляемыеДанные = Параметры.ОбновляемыеДанные;
	ДополнительныеПараметры.НужнаДополнительнаяОбработкаЗаписей = Истина;
	
	СписокДокументов = ДокументыКОбновлению();
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(СписокДокументов,
																						ПолноеИмяРегистра,
																						Параметры.Очередь,
																						ДополнительныеПараметры);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДокументыКОбновлению()
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить("Документ.ГрафикИсполненияДоговора");
	СписокДокументов.Добавить("Документ.ЗаказПоставщику");
	//++ НЕ УТ
	
	//++ Устарело_Переработка24
	СписокДокументов.Добавить("Документ.ЗаказПереработчику");
	//-- Устарело_Переработка24
	СписокДокументов.Добавить("Документ.ЗаказПереработчику2_5");
	//-- НЕ УТ
	Возврат СписокДокументов;
КонецФункции

Функция ТипыДокументовКОбновлению()
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить(Тип("ДокументСсылка.ГрафикИсполненияДоговора"));
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	//++ НЕ УТ
	
	//++ Устарело_Переработка24
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказПереработчику"));
	//-- Устарело_Переработка24
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказПереработчику2_5"));
	//-- НЕ УТ
	Возврат СписокДокументов;
КонецФункции

#КонецОбласти
#КонецЕсли