#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьОтображениеТаблицыМероприятия(УправляемаяФорма, Организация, Мероприятия, ДатаДокумента = Неопределено) Экспорт
	
	Элементы = УправляемаяФорма.Элементы;
	
	ДоступныеПоляМероприятий = ДоступныеПоляПоВидамМероприятий(ДатаДокумента);
	
	// Подготовка коллекции имен полей с управляемым выводом
	ИменаПолейСУправляемымВыводом = Новый Структура;
	Для Каждого ОписаниеДоступныхПолей Из ДоступныеПоляМероприятий Цикл
		
		Для Каждого ИмяПоля Из ОписаниеДоступныхПолей.Значение Цикл
			ИменаПолейСУправляемымВыводом.Вставить(ИмяПоля, Истина);
		КонецЦикла;
		
	КонецЦикла;
	
	// Подготовка коллекции имен полей документа
	ИменаПолейДокумента = Новый Структура("Идентификатор", Истина);
	
	ДанныеМероприятий = ДанныеСтрокМероприятий(Мероприятия);
	Для Каждого ВидМероприятия Из ДанныеМероприятий.ВидыМероприятий Цикл
		
		ДоступныеПоляВида = ДоступныеПоляМероприятий[ВидМероприятия.Ключ];
		Если ДоступныеПоляВида <> Неопределено Тогда
			Для Каждого ИмяПоля Из ДоступныеПоляВида Цикл
				ИменаПолейДокумента.Вставить(ИмяПоля, Истина);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	// Поле редактирования идентификатора мероприятия скрывается, если нет отмененных мероприятий
	Если Не ДанныеМероприятий.ЕстьДатаОтмены
		И ДанныеМероприятий.ВидыМероприятий.Получить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод")) = Неопределено Тогда
		
		ИменаПолейДокумента.Удалить("Идентификатор");
		ВидимостьДатаОтмены = Ложь;
	Иначе
		ВидимостьДатаОтмены = Истина;
	КонецЕсли;
	
	// Скрытие поля ДатаОтмены, если нет отмененных событий
	Если Не ВидимостьДатаОтмены Тогда
		ВидимостьДатаОтмены = ДанныеМероприятий.ЕстьФиксСтрока;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"МероприятияДатаОтмены",
		"Видимость",
		ВидимостьДатаОтмены);
	
	ВидимостьПодразделений = ДанныеМероприятий.ЕстьПодразделения;
	Если Не ВидимостьПодразделений Тогда
		
		Если Не ЭлектронныеТрудовыеКнижкиВызовСервера.НеЗаполнятьПодразделенияВМероприятияхТрудовойДеятельности(Организация) Тогда
			ВидимостьПодразделений = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ВидимостьПодразделений Тогда
		ИменаПолейДокумента.Удалить("Подразделение");
	КонецЕсли;
	
	Если ДатаДокумента <> Неопределено И ДатаДокумента <= ПерсонифицированныйУчетКлиентСервер.ДатаПостановленияЕФС1_2023() Тогда
		ИменаПолейДокумента.Удалить("СрочностьТрудовогоДоговора");
		ИменаПолейДокумента.Удалить("УдаленностьРаботы");
		ИменаПолейДокумента.Удалить("СокращенностьГрафика");
	Иначе
		ИменаПолейДокумента.Удалить("ЯвляетсяСовместителем");
	КонецЕсли;
	
	// Установка видимости элементов полей с управляемым выводом
	КоллекцииЭлементов = Новый Массив;
	КоллекцииЭлементов.Добавить(Элементы.Мероприятия.ПодчиненныеЭлементы);
	
	Для Каждого ЭлементФормы Из Элементы.Мероприятия.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ГруппаФормы") Тогда
			КоллекцииЭлементов.Добавить(ЭлементФормы.ПодчиненныеЭлементы);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КоллекцияЭлементов Из КоллекцииЭлементов Цикл
		
		Для Каждого ЭлементФормы Из КоллекцияЭлементов Цикл
			
			ИмяКолонки = Сред(ЭлементФормы.Имя, СтрДлина("Мероприятия") + 1);
			
			Если Не ИменаПолейСУправляемымВыводом.Свойство(ИмяКолонки) Тогда
				Продолжить;
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				ЭлементФормы.Имя,
				"Видимость",
				ИменаПолейДокумента.Свойство(ИмяКолонки));
			
		КонецЦикла;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"МероприятияКодПоРееструДолжностей",
		"Видимость",
		УправляемаяФорма.КодПоРееструДолжностейВидимость
		И ИменаПолейДокумента.Свойство("Должность"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"МероприятияРазрядКатегория",
		"Видимость",
		УправляемаяФорма.РазрядКатегорияВидимость
		И ИменаПолейДокумента.Свойство("Должность"));
	
КонецПроцедуры

Функция ДоступныеПоляВсехВидовМероприятий() Экспорт
	
	Возврат "ИдМероприятия,ДатаМероприятия,ВидМероприятия,Сведения,НаименованиеДокументаОснования,"
		+ "ДатаДокументаОснования,НомерДокументаОснования,СерияДокументаОснования,ДатаОтмены,СотрудникЗаписи,"
		+ "НаименованиеВторогоДокументаОснования,ДатаВторогоДокументаОснования,СерияВторогоДокументаОснования,НомерВторогоДокументаОснования";
	
КонецФункции

Функция ДоступныеПоляВсехВидовМероприятийДокумента() Экспорт
	
	Возврат СтрЗаменить(ДоступныеПоляВсехВидовМероприятий(), "ИдМероприятия,", "") + ",ФиксСтрока";
	
КонецФункции

Функция ИменаДоступныхПолейВидовМероприятий(ДатаДокумента = Неопределено) Экспорт
	
	ДоступныеПоля = Новый Соответствие;
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.ЗапретЗаниматьДолжность"),
		"ЯвляетсяСовместителем,Должность,КодПоРееструДолжностей,РазрядКатегория,ТрудоваяФункция,ДатаС,ДатаПо,КодПоОКЗ,"
		+ "ПредставлениеДолжности");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Переименование"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Прием"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,"
		+ "Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ОснованиеУвольнения,ОснованиеУвольненияТекстОснования,ОснованиеУвольненияСтатья,ОснованиеУвольненияЧасть,"
		+ "ОснованиеУвольненияПункт,ОснованиеУвольненияПодпункт,ОснованиеУвольненияАбзац,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.УстановлениеВторойПрофессии"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ОписаниеДолжности");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Приостановление"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Возобновление"),
		"ЯвляетсяСовместителем,СрочностьТрудовогоДоговора,УдаленностьРаботы,СокращенностьГрафика,Должность,КодПоРееструДолжностей,РазрядКатегория,Подразделение,ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия,"
		+ "ПредставлениеДолжности,ПредставлениеПодразделения");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.НачалоДоговораГПХ"),
		"ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия");
	
	ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.ОкончаниеДоговораГПХ"),
		"ТрудоваяФункция,КодПоОКЗ,ТерриториальныеУсловия");
	
	Если ЗначениеЗаполнено(ДатаДокумента) Тогда
		
		Если ДатаДокумента >= ЗарплатаКадрыВызовСервера.ДатаВступленияВСилуНА("ДатаНачалаПриемаСведенийОМобилизованных") Тогда
			
			ПоляУвольнений = ДоступныеПоля[ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение")];
			ПоляУвольнений = ПоляУвольнений + ",ТрудоваяФункция,КодПоОКЗ";
			ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение"), ПоляУвольнений);
			
		КонецЕсли;
		
		Если ДатаДокумента >= ЗарплатаКадрыВызовСервера.ДатаВступленияВСилуНА("ДатаНачалаПриемаЕФС1") Тогда
			
			ПоляУвольнений = ДоступныеПоля[ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение")];
			ПоляУвольнений = ПоляУвольнений + ",ПричинаУвольненияПФР";
			ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение"), ПоляУвольнений);
			
		КонецЕсли;
		
		Если ДатаДокумента >= ПерсонифицированныйУчетКлиентСервер.ДатаПостановленияЕФС1_2023() Тогда
			
			ПоляУвольнений = ДоступныеПоля[ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение")];
			ПоляУвольнений = ПоляУвольнений + ",КодПоОКЗ";
			ДоступныеПоля.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение"), ПоляУвольнений);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДоступныеПоля;
	
КонецФункции

Процедура УстановитьОтображениеНомеровДокумента(УправляемаяФорма) Экспорт
	
	ЗарплатаКадрыКлиентСервер.УстановитьОтображениеНомеровДокумента(УправляемаяФорма, "НомерПриказа");
	
КонецПроцедуры

Процедура УстановитьЗаголовокГруппыВторогоДокументаОснования(УправляемаяФорма, РедактированиеСтрокиСписочногоДокумента = Ложь) Экспорт
	
	Объект = УправляемаяФорма.Объект;
	Элементы = УправляемаяФорма.Элементы;
	
	Если ЗначениеЗаполнено(Объект.НаименованиеВторогоДокументаОснования) Тогда
		
		ЗаголовокГруппы = НСтр("ru = 'Второй документ основание';
								|en = 'Second base document'") + ": " + Объект.НаименованиеВторогоДокументаОснования
			+ " " + НСтр("ru = 'от';
						|en = 'dated'") + " " + Формат(Объект.ДатаВторогоДокументаОснования, "ДЛФ=D; ДП=")
			+ " № " + Объект.СерияВторогоДокументаОснования + ?(ЗначениеЗаполнено(Объект.СерияВторогоДокументаОснования), " ", "")
			+ Объект.НомерВторогоДокументаОснования;
		
	Иначе
		ЗаголовокГруппы = НСтр("ru = 'Второй документ основание: не задан';
								|en = 'Second base document: not specified'")
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВторойДокументОснованиеГруппа",
		"ЗаголовокСвернутогоОтображения",
		ЗаголовокГруппы);
	
	ВидимостьГруппы = Не РедактированиеСтрокиСписочногоДокумента
		И (ЗначениеЗаполнено(Объект.НаименованиеВторогоДокументаОснования)
			Или ЗначениеЗаполнено(Объект.ДатаВторогоДокументаОснования)
			Или ЗначениеЗаполнено(Объект.СерияВторогоДокументаОснования)
			Или ЗначениеЗаполнено(Объект.НомерВторогоДокументаОснования)
			Или ЭлектронныеТрудовыеКнижкиВызовСервера.ИспользоватьДляМероприятийПриемПереводУвольнениеДваДокументаОснования());
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВторойДокументОснованиеГруппа",
		"Видимость",
		ВидимостьГруппы);
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

Процедура УстановитьДоступностьКомандыИзмененияДокумента(УправляемаяФорма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"КнопкаИзменитьДокументЭТК",
		"Видимость",
		УправляемаяФорма.ТолькоПросмотр);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоступныеПоляПоВидамМероприятий(ДатаДокумента)
	
	ДоступныеПоля = Новый Соответствие;
	
	ИменаДоступныхПолей = ИменаДоступныхПолейВидовМероприятий(ДатаДокумента);
	Для Каждого ОписаниеИменДоступныхПолей Из ИменаДоступныхПолей Цикл
		
		ИменаПолей = СтрРазделить(ОписаниеИменДоступныхПолей.Значение, ",");
		ИменаПолей.Добавить("Идентификатор");
		
		ДоступныеПоля.Вставить(ОписаниеИменДоступныхПолей.Ключ, ИменаПолей);
		
	КонецЦикла;
	
	Возврат ДоступныеПоля;
	
КонецФункции

Функция ДанныеСтрокМероприятий(КоллекцияСтрок)
	
	ДанныеСтрок = Новый Структура;
	
	ВидыМероприятий = Новый Соответствие;
	ДанныеСтрок.Вставить("ВидыМероприятий", ВидыМероприятий);
	
	ЕстьПодразделения = Ложь;
	ЕстьДатаОтмены    = Ложь;
	ЕстьФиксСтрока    = Ложь;
	
	Для каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		
		Если ЗначениеЗаполнено(СтрокаКоллекции.ВидМероприятия) Тогда
			ВидыМероприятий.Вставить(СтрокаКоллекции.ВидМероприятия, Истина);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаКоллекции.Подразделение) Тогда
			ЕстьПодразделения = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаКоллекции.ДатаОтмены) Тогда
			ЕстьДатаОтмены = Истина;
		КонецЕсли;
		
		Если СтрокаКоллекции.ФиксСтрока Тогда
			ЕстьФиксСтрока = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеСтрок.Вставить("ЕстьПодразделения", ЕстьПодразделения);
	ДанныеСтрок.Вставить("ЕстьДатаОтмены", ЕстьДатаОтмены);
	ДанныеСтрок.Вставить("ЕстьФиксСтрока", ЕстьФиксСтрока);
	
	Возврат ДанныеСтрок;
	
КонецФункции

#КонецОбласти