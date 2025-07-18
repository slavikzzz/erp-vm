
#Область ПрограммныйИнтерфейс

// Позволяет отметить загруженные в информационную базу письма по заголовкам почтовых сообщений.
// Заголовки писем с установленным свойством ПисьмоЗагружено = Истина не будут получены с почтового сервера.
//
// Параметры:
//  ЗаголовкиПисем - ТаблицаЗначений - состав колонок таблицы значений см. ЗагрузкаПочтовыхСообщений.СоздатьАдаптированноеОписаниеПисьма.
//  ВидОперации    - Строка - Наименование операции. Например: "ЗагрузкаСчетовФактур", "ЗагрузкаСчетовНаОплату".
//  УчетнаяЗапись  - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Используемая учетная запись электронной почты.
//
// Возвращаемое значение:
//  Булево - Истина если в переопределяемой функции были отмечены заголовки.
//
Функция ОтметитьЗаголовкиЗагруженныхПисем(ЗаголовкиПисем, ВидОперации, УчетнаяЗапись) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент") Тогда
		// Взаимодействия не используется, письма считываются только с почтового сервера.
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаИдентификаторов = Новый ТаблицаЗначений;
	ТаблицаИдентификаторов.Колонки.Добавить("ИндексСтроки", 			ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаИдентификаторов.Колонки.Добавить("ИдентификаторНаСервере", 	ОбщегоНазначения.ОписаниеТипаСтрока(100));
	
	Для Каждого СтрокаЗаголовка Из ЗаголовкиПисем Цикл
	
		Если СтрокаЗаголовка.ПисьмоЗагружено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаЗаголовка.Идентификатор.Количество() > 0 Тогда
			НоваяСтрока = ТаблицаИдентификаторов.Добавить();
			НоваяСтрока.ИндексСтроки 			= ЗаголовкиПисем.Индекс(СтрокаЗаголовка);
			НоваяСтрока.ИдентификаторНаСервере 	= СтрокаЗаголовка.Идентификатор[0];
		КонецЕсли;
	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаИдентификаторов", ТаблицаИдентификаторов);
	Запрос.УстановитьПараметр("УчетнаяЗапись", 			УчетнаяЗапись);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИдентификаторов.ИндексСтроки КАК ИндексСтроки,
	|	ТаблицаИдентификаторов.ИдентификаторНаСервере КАК ИдентификаторНаСервере
	|ПОМЕСТИТЬ ВТ_ТаблицаИдентификаторов
	|ИЗ
	|	&ТаблицаИдентификаторов КАК ТаблицаИдентификаторов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИдентификаторНаСервере
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаИдентификаторов.ИндексСтроки
	|ИЗ
	|	ВТ_ТаблицаИдентификаторов КАК ВТ_ТаблицаИдентификаторов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ПО ВТ_ТаблицаИдентификаторов.ИдентификаторНаСервере = ЭлектронноеПисьмоВходящее.ИдентификаторНаСервере
	|			И (ЭлектронноеПисьмоВходящее.УчетнаяЗапись = &УчетнаяЗапись)
	|			И НЕ ЭлектронноеПисьмоВходящее.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		ЗаголовкиПисем[Выборка.ИндексСтроки].ПисьмоЗагружено = Истина;
		
	КонецЦикла;

	Возврат Истина;
	
КонецФункции

// Позволяет дополнить таблицу писем, загруженных с почтового сервера, данными информационной базы.
//
// Параметры:
//  Письма - ТаблицаЗначений - состав колонок таблицы значений см. ЗагрузкаПочтовыхСообщений.СоздатьАдаптированноеОписаниеПисьма.
//  ВидОперации    - Строка - Наименование операции. Например: "ЗагрузкаСчетовФактур", "ЗагрузкаСчетовНаОплату".
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Используемая учетная запись электронной почты.
//  ПараметрыОтбораЗаголовков - Структура - Содержит поля:
//    * ПослеДатыОтправления - ДатаВремя - Дата и время, начиная с которых обрабатывать почтовые сообщения.
//
Процедура ДополнитьТаблицуПочтовыхСообщений(Письма, ВидОперации, УчетнаяЗапись, ПараметрыОтбораЗаголовков) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент") Тогда
		// Взаимодействия не используется, письма считываются только с почтового сервера.
		Возврат;
	КонецЕсли;
	
	ТаблицаИдентификаторов = Новый ТаблицаЗначений;
	ТаблицаИдентификаторов.Колонки.Добавить("ИндексСтроки", 			ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаИдентификаторов.Колонки.Добавить("ИдентификаторНаСервере", 	ОбщегоНазначения.ОписаниеТипаСтрока(100));
	
	// Отбираем идентификаторы писем, которые уже есть в таблице.
	Для Каждого СтрокаПисьма Из Письма Цикл
	
		Если НЕ СтрокаПисьма.ПисьмоЗагружено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаПисьма.Идентификатор.Количество() > 0 Тогда
			НоваяСтрока = ТаблицаИдентификаторов.Добавить();
			НоваяСтрока.ИндексСтроки 			= Письма.Индекс(СтрокаПисьма);
			НоваяСтрока.ИдентификаторНаСервере 	= СтрокаПисьма.Идентификатор[0];
		КонецЕсли;
	
	КонецЦикла;

	// Выбираем загруженные ранее в базу письма по учетной записи.

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаИдентификаторов", ТаблицаИдентификаторов);
	Запрос.УстановитьПараметр("УчетнаяЗапись", 			УчетнаяЗапись);
	Запрос.УстановитьПараметр("ПослеДатыОтправления", 	ПараметрыОтбораЗаголовков.ПослеДатыОтправления);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИдентификаторов.ИндексСтроки КАК ИндексСтроки,
	|	ТаблицаИдентификаторов.ИдентификаторНаСервере КАК ИдентификаторНаСервере
	|ПОМЕСТИТЬ ВТ_ТаблицаИдентификаторов
	|ИЗ
	|	&ТаблицаИдентификаторов КАК ТаблицаИдентификаторов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИдентификаторНаСервере
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоВходящее.Ссылка КАК Ссылка,
	|	ЭлектронноеПисьмоВходящее.Дата КАК ДатаОтправления,
	|	ЭлектронноеПисьмоВходящее.ИдентификаторНаСервере КАК Идентификатор,
	|	ЭлектронноеПисьмоВходящее.ИдентификаторСообщения КАК ИдентификаторСообщения,
	|	ЭлектронноеПисьмоВходящее.Размер КАК Размер,
	|	ЕСТЬNULL(ВТ_ТаблицаИдентификаторов.ИндексСтроки, -1) КАК ИндексСтроки,
	|	ЭлектронноеПисьмоВходящееПрисоединенныеФайлы.Ссылка КАК ПрисоединенныйФайл
	|ИЗ
	|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТаблицаИдентификаторов КАК ВТ_ТаблицаИдентификаторов
	|		ПО ЭлектронноеПисьмоВходящее.ИдентификаторНаСервере = ВТ_ТаблицаИдентификаторов.ИдентификаторНаСервере
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы КАК ЭлектронноеПисьмоВходящееПрисоединенныеФайлы
	|		ПО ЭлектронноеПисьмоВходящее.Ссылка = ЭлектронноеПисьмоВходящееПрисоединенныеФайлы.ВладелецФайла
	|ГДЕ
	|	ЭлектронноеПисьмоВходящее.УчетнаяЗапись = &УчетнаяЗапись
	|	И ЭлектронноеПисьмоВходящее.Дата >= &ПослеДатыОтправления
	|	И НЕ ЭлектронноеПисьмоВходящее.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭлектронноеПисьмоВходящее.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьДанные = Выборка.Следующий();
	
	Пока ЕстьДанные Цикл
	
	    ТекущаяСсылка = Выборка.Ссылка;
	    Если Выборка.ИндексСтроки >= 0 Тогда
	    	СтрокаПисьма = Письма[Выборка.ИндексСтроки];
	    Иначе
	    	// Если такого письма нет в таблице писем, но оно было загружено ранее в базу, 
	    	// то добавляем его.
	    	СтрокаПисьма = Письма.Добавить();
		    СтрокаПисьма.ДатаОтправления = Выборка.ДатаОтправления;
		    СтрокаПисьма.Идентификатор	 = Новый Массив();
		    СтрокаПисьма.Идентификатор.Добавить(Выборка.Идентификатор);
		    СтрокаПисьма.ИдентификаторСообщения = Выборка.ИдентификаторСообщения;
		    СтрокаПисьма.Размер			 = Выборка.Размер;
	    КонецЕсли;
	    СтрокаПисьма.ПисьмоЗагружено = Истина;
	    Если ТипЗнч(СтрокаПисьма.Вложения) <> Тип("Соответствие") Тогда
	    	СтрокаПисьма.Вложения		 = Новый Соответствие;
	    КонецЕсли;
	    
	    Пока ЕстьДанные
	    	И Выборка.Ссылка = ТекущаяСсылка Цикл
	    	
	    	Если ЗначениеЗаполнено(Выборка.ПрисоединенныйФайл) Тогда
	    		Попытка
		    		ДанныеФайла = РаботаСФайлами.ДанныеФайла(Выборка.ПрисоединенныйФайл, Неопределено, Ложь, Ложь);
		    		ДвоичныеДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(Выборка.ПрисоединенныйФайл);
			    	
			    	СтрокаПисьма.Вложения.Вставить(ДанныеФайла.ИмяФайла, ДвоичныеДанныеФайла);
			    Исключение
			    
			    	ИнфоОбОшибке = ИнформацияОбОшибке();
			    	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			    		НСтр("ru = 'Ошибка при загрузке вложения ""%1"" в ""%2"": %3';
							|en = 'An error occurred while importing attachment ""%1"" to ""%2"": %3'", ОбщегоНазначения.КодОсновногоЯзыка()),
			    		Выборка.ПрисоединенныйФайл,
			    		Выборка.Ссылка,
			    		ПодробноеПредставлениеОшибки(ИнфоОбОшибке));
			    	
			    	ЗаписьЖурналаРегистрации(
			    		НСтр("ru = 'СверкаДанныхУчетаНДС.ЗагрузкаИзПочты';
							|en = 'СверкаДанныхУчетаНДС.ЗагрузкаИзПочты'", ОбщегоНазначения.КодОсновногоЯзыка()),
			    		УровеньЖурналаРегистрации.Ошибка,
			    		Метаданные.Справочники.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы,
			    		Выборка.ПрисоединенныйФайл,
			    		ТекстОшибки);

			    КонецПопытки;
	    	КонецЕсли;
	    	
	    	ЕстьДанные = Выборка.Следующий();

	    КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры

// Возвращает учетную запись настроенную на получения почтовых сообщений или пустую ссылку
// если учетной записи настроенной на получение почты нет.
//
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись электронной почты.
//
Функция УчетнаяЗаписьПользователяДляЗагрузкиСообщений() Экспорт
	
	СистемнаяУчетнаяЗапись    = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СистемнаяУчетнаяЗапись, "ИспользоватьДляПолучения") Тогда
		
		УчетнаяЗапись = СистемнаяУчетнаяЗапись;
		
	Иначе
		
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();
		
	КонецЕсли;
	
	Возврат УчетнаяЗапись;
	
КонецФункции

#КонецОбласти
