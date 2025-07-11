#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак использования плана обмена для организации обмена в модели сервиса.
//  Если признак установлен, то в сервисе можно включить обмен данными
//  с использованием этого плана обмена.
//  Если признак не установлен, то план обмена будет использоваться только 
//  для обмена в локальном режиме работы конфигурации.
//
// Возвращаемое значение:
//  Булево - признак использования плана обмена для организации обмена в модели сервиса.
//
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
КонецФункции

// Возвращает признак использования Push-уведомлений.
//
// Возвращаемое значение:
//  Булево - Истина, когда используется отправка Push-уведомлений.
//
Функция ПланОбменаИспользуетОтправкуPushУведомлений() Экспорт
	
	ЭтотУзел = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.ЭтотУзел();
	Возврат НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзел, "ВариантОтправкиPushУведомлений") = Перечисления.ВариантыОтправкиPushУведомлений.НеОтправлять;
КонецФункции

// Возвращает массив элементов отбора, которые будут использоваться в шапке формы.
//
// Возвращаемое значение:
//  Массив - массив реквизитов шапки формы.
//
Функция РеквизитыШапкиФормы() Экспорт
	
	РеквизитыШапкиФормы = Новый Массив;
	РеквизитыШапкиФормы.Добавить("ЭквайринговыйТерминал");
	РеквизитыШапкиФормы.Добавить("СтатьяДДСЭквайринг");
	
	РеквизитыШапкиФормы.Добавить("Куратор");
	
	РеквизитыШапкиФормы.Добавить("ИспользоватьДоверенностиДляРегистрацииОплаты");
	РеквизитыШапкиФормы.Добавить("ИспользоватьПКОДляРегистрацииОплаты");
	РеквизитыШапкиФормы.Добавить("Касса");
	РеквизитыШапкиФормы.Добавить("СтатьяДДСНаличные");
	
	РеквизитыШапкиФормы.Добавить("ИспользоватьВесовыеХарактеристики");
	РеквизитыШапкиФормы.Добавить("ПередаватьИзображенияТоваров");
	
	РеквизитыШапкиФормы.Добавить("НеОтображатьОстатокПриПодборе");
	
	Возврат РеквизитыШапкиФормы;
КонецФункции

// Возвращает соответствия элементов отбора и используемых функциональных опций.
//
// Возвращаемое значение:
//  Массив - массив соответствий элементов отбора функциональным опциям.
//
Функция СоответствияЭлементовОтбораФункциональнымОпциям() Экспорт
	
	Соответствия = Новый Массив;
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьСегментыНоменклатуры", "СегментНоменклатуры");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьСегментыПартнеров", "СегментПартнеров");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьНесколькоОрганизаций", "Организация");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьНесколькоВидовЦен", "ВидЦены");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьНесколькоСкладов", "Склад");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьСоглашенияСКлиентами", "Соглашение");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьОплатуПлатежнымиКартами", "ЭквайринговыйТерминал");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьОплатуПлатежнымиКартами", "СтатьяДДСЭквайринг");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьДоверенностиНаПолучениеТМЦ", "ИспользоватьДоверенностиДляРегистрацииОплаты");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьНесколькоКасс", "Касса");
	Соответствия.Добавить(Зависимость);
	
	Зависимость = Новый Соответствие;
	Зависимость.Вставить("ИспользоватьЗаданияДляУправленияТорговымиПредставителями", "Куратор");
	Соответствия.Добавить(Зависимость);
	
	Возврат Соответствия;
КонецФункции

// Возвращает предопределенный узел плана обмена "Мобильное приложение "1С:Заказы".
//
// Возвращаемое значение:
//  ПланОбменаСсылка - предопределенный узел.
//
Функция ГлавныйУзелОбмена() Экспорт
	
	ГлавныйУзелОбмена = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.ЭтотУзел();
	
	Если Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГлавныйУзелОбмена, "Код")) Тогда
		ГлавныйУзелОбъект = ГлавныйУзелОбмена.ПолучитьОбъект();
		ГлавныйУзелОбъект.Код = "001";
		ГлавныйУзелОбъект.Наименование = НСтр("ru = 'Центральный';
												|en = 'Central'");
		ГлавныйУзелОбъект.Записать();
	КонецЕсли;
	Возврат ГлавныйУзелОбмена;
КонецФункции

#КонецОбласти

#КонецЕсли
