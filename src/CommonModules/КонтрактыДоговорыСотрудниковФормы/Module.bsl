////////////////////////////////////////////////////////////////////////////////
// Учет контрактов, договоров сотрудников.
// Серверные процедуры и функции форм документов.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ОписаниеФормыРедактирующейДанныеКонтрактаДоговора() Экспорт
	
	ОписаниеФормы = Новый Структура; 
	ОписаниеФормы.Вставить("ИмяЭлементаСтраницаОплатаТруда", 		"ОплатаТрудаСтраница");
	ОписаниеФормы.Вставить("ИмяЭлементаСрочныйДоговор", 			"СрочныйДоговор");
	ОписаниеФормы.Вставить("ИмяЭлементаСезонныйДоговор", 			"СезонныйДоговор");
	ОписаниеФормы.Вставить("ИмяЭлементаДатаЗавершенияДоговора", 	"ДатаЗавершенияТрудовогоДоговора");
	ОписаниеФормы.Вставить("ИмяЭлементаСрокЗаключенияДоговора", 	"СрокЗаключенияДоговора");
	ОписаниеФормы.Вставить("ИмяЭлементаОснованиеСрочногоДоговора", 	"ОснованиеСрочногоДоговора");
	ОписаниеФормы.Вставить("ИмяЭлементаДоговорКонтракт", 			"ДоговорКонтракт");
	ОписаниеФормы.Вставить("ИмяЭлементаПредставитель", 				"ПредставительНанимателя");
	ОписаниеФормы.Вставить("ИмяЭлементаДолжностьПредставителя", 	"ДолжностьПредставителяНанимателя");
	ОписаниеФормы.Вставить("ИмяЭлементаИзменитьСведенияОДоговоре", 	"ИзменитьСведенияОДоговореКонтракте");
	ОписаниеФормы.Вставить("ИмяЭлементаВидЗанятости", 				"ВидЗанятости");
	ОписаниеФормы.Вставить("ИмяЭлементаГруппаКлассныйЧин", 			"ГруппаКлассныйЧин");
	ОписаниеФормы.Вставить("ИмяЭлементаСпособПоступленияНаСлужбу", 	"СпособПоступленияНаСлужбу");
	ОписаниеФормы.Вставить("ИмяЭлементаПоступлениеНаСлужбуВпервые", "ПоступлениеНаСлужбуВпервые");
	ОписаниеФормы.Вставить("ИмяЭлементаВидАктаГосоргана", 			"ВидАктаГосоргана");
	ОписаниеФормы.Вставить("ИмяЭлементаФормыСменаВидаДоговора", 	"СменаВидаДоговора");
	ОписаниеФормы.Вставить("ОснованиеСрочногоДоговора", 			"Объект.ОснованиеСрочногоДоговора");
	ОписаниеФормы.Вставить("ОснованиеСрочногоДоговораПредыдущее", 	Неопределено);

	Возврат ОписаниеФормы;
	
КонецФункции

Процедура НастроитьФормуПоВидуДоговора(Форма, ОписаниеФормы, ВидДоговора, УстановитьТипыЗначений = Истина) Экспорт
	
	УстановитьЗаголовкиЭлементовФормы(Форма, ОписаниеФормы, ВидДоговора);
	
	УстановитьВидимостьЭлементовФормы(Форма, ОписаниеФормы, ВидДоговора);
	
	Если УстановитьТипыЗначений Тогда
		УстановитьТипыЗначенийДанныхДоговора(Форма, ОписаниеФормы, ВидДоговора);
	КонецЕсли; 
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.НастроитьФормуДокументаПоВидуДоговора(Форма, ОписаниеФормы, ВидДоговора);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗаголовокПоляСменаВидаДоговора(Форма, ОписаниеФормы, ТекущийВидДоговора) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьЗаголовокПоляСменаВидаДоговора(Форма, ОписаниеФормы, ТекущийВидДоговора);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораВидаДоговора(СписокВыбора, ГруппаДоговоров = "Все") Экспорт
	
	СписокВыбора.Очистить();
	
	Отбор = Новый Структура("ГруппаДоговоров", ГруппаДоговоров);
	
	ДоступныеЗначения = Перечисления.ВидыДоговоровССотрудниками.ПолучитьДанныеВыбора(Новый Структура("Отбор,СтрокаПоиска", Отбор, Неопределено));
	
	Для каждого ЭлементСписка Из ДоступныеЗначения Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьДоступностьПолейСрочногоТрудовогоДоговора(Форма, ОписаниеФормы, ДоступностьИзменения, СрочныйДоговор) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаДатаЗавершенияДоговора"], 	"Доступность", ДоступностьИзменения И СрочныйДоговор);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаОснованиеСрочногоДоговора"], "Доступность", ДоступностьИзменения И СрочныйДоговор);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаСрокЗаключенияДоговора"], 	"Доступность", ДоступностьИзменения И СрочныйДоговор);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаСезонныйДоговор"], 			"Доступность", ДоступностьИзменения И СрочныйДоговор);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовкиЭлементовФормы(Форма, ОписаниеФормы, ВидДоговора)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаСтраницаОплатаТруда"], 		"Заголовок", НСтр("ru = 'Оплата труда';
																																							|en = 'Payroll'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаСрочныйДоговор"], 			"Заголовок", НСтр("ru = 'Срочный трудовой договор до';
																																							|en = 'Fixed-term employment contract until'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаДоговорКонтракт"], 			"Заголовок", НСтр("ru = 'Трудовой договор';
																																							|en = 'Employment contract'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаПредставитель"], 			"Заголовок", НСтр("ru = 'Руководитель';
																																							|en = 'Manager'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаДолжностьПредставителя"], 	"Заголовок", НСтр("ru = 'Должность';
																																							|en = 'Position'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаИзменитьСведенияОДоговоре"], "Заголовок", НСтр("ru = 'Изменить сведения о договоре';
																																							|en = 'Change contract information'"));
КонецПроцедуры

Процедура УстановитьВидимостьЭлементовФормы(Форма, ОписаниеФормы, ВидДоговора)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаВидЗанятости"], "Видимость", Истина);
КонецПроцедуры

Процедура УстановитьТипыЗначенийДанныхДоговора(Форма, ОписаниеФормы, ВидДоговора)
	
	УстановитьТипОснованияСрочногоДоговора(Форма, ОписаниеФормы, ВидДоговора);

КонецПроцедуры

Процедура УстановитьТипОснованияСрочногоДоговора(Форма, ОписаниеФормы, ВидДоговора)
	
	ОграничениеТипа = ОграничениеТипаОснованияСрочногоТрудовогоДоговора(ВидДоговора);
	
	УстановитьОграничениеТипаЭлементаОснованиеСрочногоДоговора(Форма, ОписаниеФормы, ОграничениеТипа);
	
	ПривестиЗначениеОснованияСрочногоДоговора(Форма, ОписаниеФормы, ОграничениеТипа);

КонецПроцедуры
	
Процедура УстановитьОграничениеТипаЭлементаОснованиеСрочногоДоговора(Форма, ОписаниеФормы, ОграничениеТипа);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, ОписаниеФормы["ИмяЭлементаОснованиеСрочногоДоговора"], "ОграничениеТипа", ОграничениеТипа);
	
КонецПроцедуры

Процедура ПривестиЗначениеОснованияСрочногоДоговора(Форма, ОписаниеФормы, ОграничениеТипа)
	
	ПустоеЗначение = ОграничениеТипа.ПривестиЗначение();
	
	ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеФормы["ОснованиеСрочногоДоговора"]);
	
	Если ТипЗнч(ЗначениеРеквизита) <> ТипЗнч(ПустоеЗначение) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ОписаниеФормы["ОснованиеСрочногоДоговора"], ПустоеЗначение);
		
		Если ОписаниеФормы["ОснованиеСрочногоДоговораПредыдущее"] <> Неопределено Тогда
			
			ПредыдущееЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеФормы["ОснованиеСрочногоДоговораПредыдущее"]);
			
			Если ТипЗнч(ПредыдущееЗначениеРеквизита) = ТипЗнч(ПустоеЗначение) Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ОписаниеФормы["ОснованиеСрочногоДоговора"], ПредыдущееЗначениеРеквизита); 
			КонецЕсли;	
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ОписаниеФормы["ОснованиеСрочногоДоговораПредыдущее"], ЗначениеРеквизита); 
			
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры

Функция ОграничениеТипаОснованияСрочногоТрудовогоДоговора(ВидДоговора)
	
	ТипОснования = Тип("СправочникСсылка.ОснованияЗаключенияСрочныхТрудовыхДоговоров");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		ТипОснования = Модуль.ТипОснованияСрочногоТрудовогоДоговора(ВидДоговора);
	КонецЕсли;
	
	ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипОснования)); 
	
	Возврат ОграничениеТипа;	
	
КонецФункции

#КонецОбласти 



