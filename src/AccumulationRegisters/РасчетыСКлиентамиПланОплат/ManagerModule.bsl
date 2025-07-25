
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
	Обработчик.Процедура = "РегистрыНакопления.РасчетыСКлиентамиПланОплат.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.13.13";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1d86b915-d170-44ae-9550-190d1f7da828");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РасчетыСКлиентамиПланОплат.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документов информационной базы по регистру накопления ""Плановые оплаты клиентов"".';
									|en = 'Updates register records of infobase documents in the Scheduled customer payments accumulation register.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ГрафикИсполненияДоговора.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказКлиента.ПолноеИмя());
	//++ НЕ УТКА
	
	//++ Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ЗаказДавальца.ПолноеИмя());
	//-- Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ЗаказДавальца2_5.ПолноеИмя());
	//-- НЕ УТКА
	Читаемые.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РеализацияУслугПрочихАктивов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.РасчетыСКлиентамиПланОплат";
	
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
	|	Документ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентамиПланОплат КАК РасчетыСКлиентамиПланОплат
	|			ПО РасчетыСКлиентамиПланОплат.Регистратор = Документ.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|			ПО РасчетыСКлиентами.Регистратор = Документ.Ссылка
	|				И РасчетыСКлиентами.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|ГДЕ
	|	Документ.Проведен
	|	И Документ.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
	|	И Документ.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|												ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет),
	|												ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|												ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера),
	|												ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
	|	И РасчетыСКлиентамиПланОплат.Регистратор ЕСТЬ NULL
	|	И РасчетыСКлиентами.Регистратор ЕСТЬ НЕ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РеализацияУслугПрочихАктивов КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентамиПланОплат КАК РасчетыСКлиентамиПланОплат
	|			ПО РасчетыСКлиентамиПланОплат.Регистратор = Документ.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|			ПО РасчетыСКлиентами.Регистратор = Документ.Ссылка
	|				И РасчетыСКлиентами.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|ГДЕ
	|	Документ.Проведен
	|	И Документ.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
	|	И Документ.ХозяйственнаяОперация В (
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияОСсОтложеннымПереходомПрав))
	|	И РасчетыСКлиентамиПланОплат.Регистратор ЕСТЬ NULL
	|	И РасчетыСКлиентами.Регистратор ЕСТЬ НЕ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РасчетыСКлиентами.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентамиПланОплат КАК РасчетыСКлиентамиПланОплат
	|			ПО РасчетыСКлиентамиПланОплат.Регистратор = РасчетыСКлиентами.Регистратор
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.Регистратор) В (&ТипыДокументов)
	|	И РасчетыСКлиентами.КОплате > 0
	|	И РасчетыСКлиентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И РасчетыСКлиентами.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|	И РасчетыСКлиентамиПланОплат.Регистратор ЕСТЬ NULL";
	Запрос.УстановитьПараметр("ТипыДокументов", ТипыДокументовКОбновлению());
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыСКлиентамиПланОплат";
	
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
	СписокДокументов.Добавить("Документ.ЗаказКлиента");
	//++ НЕ УТКА
	
	//++ Устарело_Переработка24
	СписокДокументов.Добавить("Документ.ЗаказДавальца");
	//-- Устарело_Переработка24
	СписокДокументов.Добавить("Документ.ЗаказДавальца2_5");
	//-- НЕ УТКА
	СписокДокументов.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	СписокДокументов.Добавить("Документ.РеализацияТоваровУслуг");
	СписокДокументов.Добавить("Документ.РеализацияУслугПрочихАктивов");
	Возврат СписокДокументов;
КонецФункции

Функция ТипыДокументовКОбновлению()
	СписокДокументов = Новый Массив;
	СписокДокументов.Добавить(Тип("ДокументСсылка.ГрафикИсполненияДоговора"));
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	//++ НЕ УТКА
	
	//++ Устарело_Переработка24
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказДавальца"));
	//-- Устарело_Переработка24
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаказДавальца2_5"));
	//-- НЕ УТКА
	СписокДокументов.Добавить(Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента"));
	Возврат СписокДокументов;
КонецФункции

#КонецОбласти

#КонецЕсли