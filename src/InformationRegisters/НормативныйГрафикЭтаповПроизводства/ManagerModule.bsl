
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Рассчитывает нормативный график по заданному заказу на производство.
//
// Параметры:
//  Распоряжение - ДокументСсылка.ЗаказНаПроизводство2_2 - распоряжение, очередь этапов которого необходимо рассчитать
//
Процедура Рассчитать(Распоряжение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Документы.ЭтапПроизводства2_2.СоздатьВТСвязиЭтаповПоРаспоряжению(
		МенеджерВременныхТаблиц, Распоряжение, Истина);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = ТекстЗапросаРасчетаНормативногоГрафикаПроизводства();
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	График = МассивРезультатов[0].Выгрузить();
	
	РассчитатьГрафик(График, МассивРезультатов[1].Выгрузить());
	
	Набор = РегистрыСведений.НормативныйГрафикЭтаповПроизводства.СоздатьНаборЗаписей();
	Набор.Отбор.Распоряжение.Установить(Распоряжение);
	Набор.Загрузить(График);
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьГрафик(Этапы, Зависимости) Экспорт
	
	Этапы.Индексы.Добавить("ЭтапПроизводства");
	Зависимости.Индексы.Добавить("Этап");
	Зависимости.Индексы.Добавить("СледующийЭтап");
	
	Этапы.Колонки.Добавить("Путь", Новый ОписаниеТипов("Соответствие"));
	
	// Расчет до запуска
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ПервыйЭтап", Истина);
	
	Для каждого Строка Из Этапы.НайтиСтроки(СтруктураПоиска) Цикл
		РассчитатьДлительность(Этапы, Зависимости, Строка, "ДлительностьДоЗапуска", Истина);
	КонецЦикла;
	
	// Расчет до выпуска
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ПоследнийЭтап", Истина);
	
	Для каждого Строка Из Этапы.НайтиСтроки(СтруктураПоиска) Цикл
		РассчитатьДлительность(Этапы, Зависимости, Строка, "ДлительностьДоВыпуска", Ложь);
	КонецЦикла;
	
	Этапы.Колонки.Удалить("Путь");
	
КонецПроцедуры

Процедура РассчитатьДлительность(Этапы, Зависимости, СтрокаЭтапы, ИмяКолонки, ОбходКОкончанию)
	
	Путь = Новый Соответствие;
	Путь.Вставить(СтрокаЭтапы.ЭтапПроизводства, 0);
	СтрокаЭтапы.Путь = Путь;
	
	Очередь = Новый Массив;
	Очередь.Добавить(СтрокаЭтапы);
	
	Пока Очередь.ВГраница() <> -1 Цикл
		
		ТекущийИндекс = Очередь.ВГраница();
		ТекущаяСтрока = Очередь[ТекущийИндекс];
		
		Если ТекущаяСтрока.Ресурсоемкость = 0 Тогда
			Длительность = ТекущаяСтрока[ИмяКолонки] + 0.0001;
		Иначе
			Длительность = Цел(ТекущаяСтрока[ИмяКолонки]) + ТекущаяСтрока.Ресурсоемкость;
		КонецЕсли;
		
		// Поиск последователей и добавление их в очередь
		Если ОбходКОкончанию Тогда
			
			СтруктураПоиска = Новый Структура("Этап", ТекущаяСтрока.ЭтапПроизводства);
			НайденныеСтроки = Зависимости.НайтиСтроки(СтруктураПоиска);
			
			Для каждого Строка Из НайденныеСтроки Цикл
				
				ПоследующийЭтап = Этапы.Найти(Строка.СледующийЭтап, "ЭтапПроизводства");
				Если ПоследующийЭтап <> Неопределено
					И Длительность > ПоследующийЭтап[ИмяКолонки] Тогда
						
					ПоследующийЭтап[ИмяКолонки] = Длительность;
					Очередь.Добавить(ПоследующийЭтап);
					
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			СтруктураПоиска = Новый Структура("СледующийЭтап", ТекущаяСтрока.ЭтапПроизводства);
			НайденныеСтроки = Зависимости.НайтиСтроки(СтруктураПоиска);
			
			Для каждого Строка Из НайденныеСтроки Цикл
				
				ПоследующийЭтап = Этапы.Найти(Строка.Этап, "ЭтапПроизводства");
				Если ПоследующийЭтап <> Неопределено
					И Длительность > ПоследующийЭтап[ИмяКолонки] Тогда
						
					ПоследующийЭтап[ИмяКолонки] = Длительность;
					Очередь.Добавить(ПоследующийЭтап);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		// Контроль зацикливания
		Если Очередь.ВГраница() <> ТекущийИндекс Тогда
			Для Индекс = ТекущийИндекс+1 По Очередь.ВГраница() Цикл
				
				Строка = Очередь[Индекс];
				Если Индекс = Очередь.ВГраница() Тогда
					Строка.Путь = ТекущаяСтрока.Путь;
				Иначе
					Путь = Новый Соответствие;
					Для каждого КлючИЗначение Из ТекущаяСтрока.Путь Цикл
						Путь.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
					КонецЦикла;
					Строка.Путь = Путь;
				КонецЕсли;
				
				Если Строка.Путь.Получить(Строка.ЭтапПроизводства) = Неопределено Тогда
					Строка.Путь.Вставить(Строка.ЭтапПроизводства, 0);
				Иначе
					ВызватьИсключение СтрШаблон(
						НСтр("ru = 'В процессе расчета очереди обнаружено зацикливание на этапе ""%1"".';
							|en = 'Loop detected during queue calculation at stage ""%1"".'"),
						Строка.ЭтапПроизводства);
				КонецЕсли;
				
			КонецЦикла;
		Иначе
			ТекущаяСтрока.Путь = Неопределено;
		КонецЕсли;
		
		Очередь.Удалить(ТекущийИндекс);
		
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает нормативный график этапов производства.
//
// Параметры:
//  Задания - ТаблицаЗначений - колонки соответствуют измерениям, ресурсам и реквизитам регистра сведений
//                              "ЗаданияКРасчетуНормативногоГрафикаПроизводства", есть и служебные колонки:
//             * ОбъектРасчета          - ДокументСсылка.ЗаказНаПроизводство2_2 -
//             * ИдентификаторЗаписи    - УникальныйИдентификатор -
//             * УдалитьДеньРегистрации - Число  -
//             * ДатаЗаписи             - Дата   -
//             * ИдентификаторЗадания   - УникальныйИдентификатор - служебная
//             * ДатаЗадания            - Дата                    - служебная
//  ИдентификаторыНеОбработанныхЗаписей - Соответствие из УникальныйИдентификатор - ключ, это идентификатор 
//                                                                                   не выполненных (выдающих ошибку при
//                                                                                   выполнении) записей регистра
//                                                                                   сведений очереди заданий
//                                                                                   (измерение ИдентификаторЗаписи
//                                                                                   регистра сведений очереди заданий),
//                                                                                  значение, это представление ошибки.
//  ДополнительныеСвойства - Неопределено, Структура - дополнительные свойства выполнения заданий.
//
Процедура ОбработатьЗаданияКРасчетуНормативногоГрафикаПроизводства(
			Задания,
			ИдентификаторыНеОбработанныхЗаписей,
			ДополнительныеСвойства = Неопределено) Экспорт
	
	Распоряжения = ОбщегоНазначения.ВыгрузитьКолонку(Задания, "ОбъектРасчета", Истина);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Документы.ЭтапПроизводства2_2.СоздатьВТСвязиЭтаповПоРаспоряжению(МенеджерВременныхТаблиц, Распоряжения, Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Распоряжение", Распоряжения);
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = ТекстЗапросаРасчетаНормативногоГрафикаПроизводства(Истина);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Этапы = Результаты[0].Выгрузить();
	Этапы.Индексы.Добавить("Распоряжение");
	
	Зависимости = Результаты[1].Выгрузить();
	Зависимости.Индексы.Добавить("Распоряжение");
	
	ОтборРаспоряжение = Новый Структура("Распоряжение");
	
	МетаРегистра = Неопределено;
	
	Для каждого Распоряжение Из Распоряжения Цикл
		
		Попытка
			
			ОтборРаспоряжение.Распоряжение = Распоряжение;
			
			График = Этапы.Скопировать(ОтборРаспоряжение);
			
			РассчитатьГрафик(График, Зависимости.Скопировать(ОтборРаспоряжение, "Этап, СледующийЭтап"));
			
			Набор = РегистрыСведений.НормативныйГрафикЭтаповПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Распоряжение.Установить(Распоряжение);
			Набор.Загрузить(График);
			Набор.Записать();
			
		Исключение
			
			Если МетаРегистра = Неопределено Тогда
				
				МетаРегистра = Метаданные.РегистрыСведений.ЗаданияКРасчетуНормативногоГрафикаПроизводства;
				ИмяСобытия   = ОтложенныеЗадания.ИмяСобытия();
				ПоляОшибки   = Новый Структура("ОбъектРасчета");
				ДанныеОшибки = Новый Структура("ОбъектРасчета");
				
				Задания.Индексы.Добавить("ОбъектРасчета");
				
			КонецЕсли;
			
			ТекстИсключения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, МетаРегистра,, ТекстИсключения);
			
			ДанныеОшибки.ОбъектРасчета = Распоряжение;
			
			ТекстОшибки = ОтложенныеЗадания.ТекстОшибкиВыполнения(ПоляОшибки, ДанныеОшибки, ТекстИсключения);
			
			НайденныеСтроки = Задания.НайтиСтроки(ДанныеОшибки);
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				ИдентификаторыНеОбработанныхЗаписей.Вставить(НайденнаяСтрока.ИдентификаторЗаписи, ТекстОшибки);
			КонецЦикла;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаРасчетаНормативногоГрафикаПроизводства(РаспоряжениеВТаблицеЗависимости = Ложь)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЭтапПроизводства2_2.Ссылка                                        КАК ЭтапПроизводства,
	|	ЭтапПроизводства2_2.Распоряжение                                  КАК Распоряжение,
	|	0                                                                 КАК ДлительностьДоЗапуска,
	|	0                                                                 КАК ДлительностьДоВыпуска,
	|	ВЫБОР
	|		КОГДА ЭтапПроизводства2_2.ЕдиницаИзмеренияДлительностиЭтапа = ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.Минута)
	|			ТОГДА 60
	|		КОГДА ЭтапПроизводства2_2.ЕдиницаИзмеренияДлительностиЭтапа = ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.Час)
	|			ТОГДА 3600
	|		КОГДА ЭтапПроизводства2_2.ЕдиницаИзмеренияДлительностиЭтапа = ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.День)
	|			ТОГДА 86400
	|		КОГДА ЭтапПроизводства2_2.ЕдиницаИзмеренияДлительностиЭтапа = ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.Сутки)
	|			ТОГДА 86400
	|		ИНАЧЕ 1
	|	КОНЕЦ * ЭтапПроизводства2_2.ДлительностьЭтапа                     КАК Ресурсоемкость,
	|
	|	НЕ ИСТИНА В
	|				(ВЫБРАТЬ 
	|					ИСТИНА
	|				ИЗ
	|					ВТСвязиЭтапов КАК Связи
	|				ГДЕ                       
	|					Связи.СледующийЭтап = ЭтапПроизводства2_2.Ссылка) КАК ПервыйЭтап,
	|	НЕ ИСТИНА В
	|				(ВЫБРАТЬ 
	|					ИСТИНА
	|				ИЗ
	|					ВТСвязиЭтапов КАК Связи
	|				ГДЕ                       
	|					Связи.Этап = ЭтапПроизводства2_2.Ссылка)          КАК ПоследнийЭтап
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|ГДЕ
	|	ЭтапПроизводства2_2.Распоряжение В (&Распоряжение)
	|	И ЭтапПроизводства2_2.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСвязиЭтапов.Этап.Распоряжение КАК Распоряжение,
	|	ВТСвязиЭтапов.Этап              КАК Этап,
	|	ВТСвязиЭтапов.СледующийЭтап     КАК СледующийЭтап
	|ИЗ
	|	ВТСвязиЭтапов КАК ВТСвязиЭтапов";
	
	Если Не РаспоряжениеВТаблицеЗависимости Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТСвязиЭтапов.Этап.Распоряжение КАК Распоряжение,", "");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
	
#КонецЕсли
