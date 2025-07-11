#Область СлужебныйПрограммныйИнтерфейс

// Перечисление параметров настроек контроля кодов маркировки.
// 
// Возвращаемое значение:
//  Структура - Параметры контроля:
//    * ПараметрыКонтроляСтатусов - Произвольный - параметры контроля статусов,
//    * ПараметрыКонтроляВладельцев - Произвольный - параметры контроля владельцев,
//    * ПараметрыИгнорированияПроверкиККТ -Произвольный - параметры контроля ККТ.
Функция ПараметрыКонтроля() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	
	ВозвращаемоеЗначение.Вставить("ПараметрыКонтроляСтатусов");
	ВозвращаемоеЗначение.Вставить("ПараметрыКонтроляВладельцев");
	ВозвращаемоеЗначение.Вставить("ПараметрыИгнорированияПроверкиККТ");
	
	ЗаполнитьЗначенияКлючами(ВозвращаемоеЗначение);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция РежимыКонтроляСредствамиККТ() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	
	ВозвращаемоеЗначение.Вставить("ПриСканировании");
	ВозвращаемоеЗначение.Вставить("ПередПробитиемЧека");
	
	ЗаполнитьЗначенияКлючами(ВозвращаемоеЗначение);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Представления настроек параметров сканирования для отображения пользователю.
// 
// Возвращаемое значение:
// 	Соответствие - Представление параметров сканирования.
Функция ПредставленияПараметровСканирования() Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие();
	ПараметрыКонтроля    = ПараметрыКонтроля();
	
	ВозвращаемоеЗначение.Вставить(
		"ЗапрашиватьДанныеСервисаИСМП",
		НСтр("ru = 'Запрашивать данные сервиса ГИС МТ';
			|en = 'Запрашивать данные сервиса ГИС МТ'"));
	
	ВозвращаемоеЗначение.Вставить(
		ПараметрыКонтроля.ПараметрыКонтроляСтатусов,
		НСтр("ru = 'Контролировать статусы кодов маркировки';
			|en = 'Контролировать статусы кодов маркировки'"));
	ВозвращаемоеЗначение.Вставить(
		ПараметрыКонтроля.ПараметрыКонтроляВладельцев,
		НСтр("ru = 'Контролировать владельцев кодов маркировки';
			|en = 'Контролировать владельцев кодов маркировки'"));
	
	РежимыКонтроля = РежимыКонтроляСредствамиККТ();
	
	ВозвращаемоеЗначение.Вставить(
		РежимыКонтроля.ПриСканировании,
		НСтр("ru = 'При сканировании';
			|en = 'При сканировании'"));
	ВозвращаемоеЗначение.Вставить(
		РежимыКонтроля.ПередПробитиемЧека,
		НСтр("ru = 'Перед пробитием чека';
			|en = 'Перед пробитием чека'"));
	ВозвращаемоеЗначение.Вставить(
		"ПропускатьПроверкуСредствамиККТ",
		НСтр("ru = 'Игнорировать результаты проверки, если выполнен контроль статусов';
			|en = 'Игнорировать результаты проверки, если выполнен контроль статусов'"));
	ВозвращаемоеЗначение.Вставить(
		"ПараметрыИгнорированияПроверкиККТ",
		НСтр("ru = 'Игнорировать результаты проверки средствами ККТ';
			|en = 'Игнорировать результаты проверки средствами ККТ'"));
	ВозвращаемоеЗначение.Вставить(
		"ПропускатьСтрокиСОшибкамиПриЗагрузкеИзТСД",
		НСтр("ru = 'Пропускать строки с ошибками при загрузке из ТСД';
			|en = 'Пропускать строки с ошибками при загрузке из ТСД'"));
	ВозвращаемоеЗначение.Вставить(
		"ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП",
		НСтр("ru = 'Проверять потребительские упаковки на вхождение в серую зону';
			|en = 'Проверять потребительские упаковки на вхождение в серую зону'"));
	ВозвращаемоеЗначение.Вставить(
		"ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП",
		НСтр("ru = 'Проверять логистические и групповые упаковки на содержание серых кодов';
			|en = 'Проверять логистические и групповые упаковки на содержание серых кодов'"));
	ВозвращаемоеЗначение.Вставить(
		"УчитыватьМРЦ",
		НСтр("ru = 'Проверять потребительские упаковки на вхождение в серую зону';
			|en = 'Проверять потребительские упаковки на вхождение в серую зону'"));
	ВозвращаемоеЗначение.Вставить(
		"ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП",
		НСтр("ru = 'Контролировать статусы с даты производства';
			|en = 'Контролировать статусы с даты производства'"));
	ВозвращаемоеЗначение.Вставить(
		"ПроверятьСтруктуруКодовМаркировки",
		НСтр("ru = 'Восстанавливать структуру кода маркировки';
			|en = 'Восстанавливать структуру кода маркировки'"));
	ВозвращаемоеЗначение.Вставить(
		"КоличествоКодовВПакетеДляЗапросаСтатусов",
		НСтр("ru = 'Количество кодов в пакете для запроса статусов';
			|en = 'Количество кодов в пакете для запроса статусов'"));
	ВозвращаемоеЗначение.Вставить(
		"ЧастотаОбновленияCDNПлощадок",
		НСтр("ru = 'Частота обновления CDN-площадок';
			|en = 'Частота обновления CDN-площадок'"));
	ВозвращаемоеЗначение.Вставить(
		"ВремяБлокировкиCDNПлощадок",
		НСтр("ru = 'Время блокировки CDN-площадок';
			|en = 'Время блокировки CDN-площадок'"));
	ВозвращаемоеЗначение.Вставить(
		"ВремяОтветаCDNПлощадокПриПробитииЧека",
		НСтр("ru = 'Время ожидания ответа CDN-площадок при пробитии чека';
			|en = 'Время ожидания ответа CDN-площадок при пробитии чека'"));
	ВозвращаемоеЗначение.Вставить(
		"АварийноеОтключенияРазрешительногоРежимаДоУниверсальнаяДата",
		НСтр("ru = 'Аварийный режим включен до';
			|en = 'Аварийный режим включен до'"));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Допустимые виды операций для настройки исключений.
//
// Параметры:
//  ПараметрКонтроля - Строка,Неопределено - см. ПараметрыКонтроля.
// Возвращаемое значение:
// 	СписокЗначений Из  ПеречислениеСсылка.ВидыОперацийИСМП - Значение и представление допустимых видов операций.
Функция ДопустимыеВидыОпераций(ПараметрКонтроля = Неопределено) Экспорт

	ПараметрыКонтроля = ПараметрыКонтроля();
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	
	//
	ВозвращаемоеЗначение.Добавить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
		НСтр("ru = 'Розничные продажи';
			|en = 'Розничные продажи'"));
	
	ВозвращаемоеЗначение.Добавить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации"),
		НСтр("ru = 'Розничные возвраты';
			|en = 'Розничные возвраты'"));
	
		//
	ВозвращаемоеЗначение.Добавить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"),
		НСтр("ru = 'Оптовые продажи';
			|en = 'Оптовые продажи'"));
	ВозвращаемоеЗначение.Добавить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаПродажа"),
		НСтр("ru = 'Оптовые возвраты';
			|en = 'Оптовые возвраты'"));
	
	Если ПараметрКонтроля <> ПараметрыКонтроля.ПараметрыИгнорированияПроверкиККТ Тогда

		//
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"),
			НСтр("ru = 'Приобретение товаров';
				|en = 'Приобретение товаров'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Перемаркировка"),
			НСтр("ru = 'Перемаркировка';
				|en = 'Перемаркировка'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировки"),
			НСтр("ru = 'Списание кодов маркировки';
				|en = 'Списание кодов маркировки'"));

		//
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"),
			НСтр("ru = 'Агрегация';
				|en = 'Агрегация'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОВерификацииНанесенныхКМ"),
			НСтр("ru = 'Нанесение';
				|en = 'Нанесение'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"),
			НСтр("ru = 'Ввод в оборот';
				|en = 'Ввод в оборот'"));

		//
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"),
			НСтр("ru = 'Вывод из оборота';
				|en = 'Вывод из оборота'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"),
			НСтр("ru = 'Возврат в оборот';
				|en = 'Возврат в оборот'"));
			
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"),
			НСтр("ru = 'Уточнение сведений о кодах маркировки';
				|en = 'Уточнение сведений о кодах маркировки'"));
		
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВскрытиеПотребительскойУпаковки"),
			НСтр("ru = 'Подключение кега к оборудованию розлива';
				|en = 'Подключение кега к оборудованию розлива'"));
			
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОД"),
			НСтр("ru = 'Перемещение между МОД';
				|en = 'Перемещение между МОД'"));
		
	КонецЕсли;

	Для Каждого Элемент Из ВозвращаемоеЗначение Цикл
		Если Не ЗначениеЗаполнено(Элемент.Представление) Тогда
			Элемент.Представление = СокрЛП(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ВозвращаемоеЗначение.СортироватьПоПредставлению();
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Определение зависимостей видов операций от допустимых для настройки исключений видов операций.
// 
// Возвращаемое значение:
// 	Соответствие Из ПеречислениеСсылка.ВидыОперацийИСМП - соответствие виду операции, который не указан в допустимых видах операции.
Функция ПодчиненныеВидыОпераций() Экспорт
	
	СоответствиеЗначений = Новый Соответствие();
	
	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаПродажа"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.АгрегацияИзменение"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.АгрегацияСоздание"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.АгрегацияУдаление"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.АгрегацияПроверкаСтатусаОбработкиДокумента"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация"));
	
	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеПроверкаСтатусаОбработкиДокумента"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировки"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировкиПриПоступлении"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировки"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеКодовВыбывшихДоОбязательностиМаркировки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировки"));
	
	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОбИспользованииКодовМаркировки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОВерификацииНанесенныхКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОбИспользованииРасчетСтатуса"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОВерификацииНанесенныхКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОбИспользованииКодовМаркировки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОВерификацииНанесенныхКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПолучениеПродукцииОтФизическихЛиц"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотКонтрактноеПроизводствоЕАЭС"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговору"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговоруНаСторонеЗаказчика"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТС"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТСМех"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборот"));

	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВозвратФизическомуЛицу"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВПроцессеРеализацииПоДоговоруРассрочки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКредитныйДоговор"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияКонфискованныхТоваров"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияПоДоговоруРассрочки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцам"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДистанционнаяПродажа"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаЧерезВендинговыйАппарат"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБрак"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛабораторныеОбразцы"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаОтзывСРынка"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРекламации"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругиеПричины"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаТестированиеПродукта"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СписаниеВведенныхВОборотКодовМаркировки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляПроизводственныхЦелей"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияНезарегистрированномуУчастнику"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаФасовка"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтилизацияТовара"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПриОСУАннулирование"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляМедицинскогоПрименения"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКорректировкаОстатковОСУ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляВетеринарногоПрименения"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПересортицаПоКодам"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборота"));
	
	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаТрансграничнаяТорговля"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаБезвозмезднаяПередача"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПриобретениеГосПредприятием"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаКомиссия"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаДляСобственныхНуждПокупателя"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаАгент"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаАннулировать"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаАннулирование"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаТрансграничнаяТорговляАннулирование"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаЕАЭССПризнаниемКИ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаПродажа"));

	//
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаПродажа"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаБезвозмезднаяПередача"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаКомиссия"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаАгент"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаПриобретениеГосПредприятием"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаДляСобственныхНуждПокупателя"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаОтклонить"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаОтклонен"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаТрансграничнаяТорговля"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаИзЕАЭССПризнаниемКМ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриДистанционномСпособеПродажи"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриПродажеЧерезВендинговыйАппарат"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараВыведенногоИзОборотаВЦеляхНеСвязанныхСРеализацией"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараПриобретавшегосяНеДляПродажи"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараВыведенногоДляПроизводственныхЦелей"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратТовараВОборотПоСделкеСГосТайной"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборот"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаИзЕАЭСПриОСУ"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Приемка"));
	
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СведенияОРазрешительнойДокументацииДляВводаВОборот"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтчетОПеревзвешивании"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.СведенияОКодахИдентификацииДляВводаВОборот"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМСрокГодности"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМСрокГодностиВСД"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМФактическийВес"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.КорректировкаСведенийКМ"));
	
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОДИсправление"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОД"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОДОтменаПредварительнойОтгрузки"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОД"));
	СоответствиеЗначений.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОДПредварительнаяОтгрузка"),
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПеремещениеМеждуМОД"));
	
	Возврат СоответствиеЗначений;
	
КонецФункции

// Предопределенное значение отображения по товарным группам.
// 
// Возвращаемое значение:
// 	Строка - Идентификатор значения.
Функция ВариантОтображенияПоВидамПродукции() Экспорт
	Возврат "ПоТоварнымГруппам";
КонецФункции

// Предопределенное значение отображения по видам операции.
// 
// Возвращаемое значение:
// 	Строка - Идентификатор значения
Функция ВариантОтображенияПоОперациям() Экспорт
	Возврат "ПоОперациям";
КонецФункции

// Описание
// 
// Параметры:
// 	НастройкаЗначение - ПеречислениеСсылка.ВидыПродукцииИС, ПеречислениеСсылка.ВидыОперацийИСМП - Настройка.
// Возвращаемое значение:
// 	Строка - Представление
Функция ПредставлениеНастройки(НастройкаЗначение) Экспорт
	
	ДопустимыеВидыОпераций = ДопустимыеВидыОпераций();
	
	ПоискЗначения = ДопустимыеВидыОпераций.НайтиПоЗначению(НастройкаЗначение);
	Если ПоискЗначения <> Неопределено Тогда
		Если ЗначениеЗаполнено(ПоискЗначения.Представление) Тогда
			Возврат ПоискЗначения.Представление;
		Иначе
			Возврат СокрЛП(ПоискЗначения.Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СокрЛП(НастройкаЗначение);
	
КонецФункции

// Описание
// 
// Параметры:
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// 	ВидОперации - ПеречислениеСсылка.ВидыОперацийИСМП - Вид операции.
// 	ИмяПараметраКонтроля - Строка - Идентификатор параметра контроля.
// Возвращаемое значение:
// 	Булево - Признак исключения операции.
Функция ОперацияУточненаВНастройкахСканирования(ВидПродукции, ВидОперации, ИмяПараметраКонтроля) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидПродукции) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыКонтроля = ПараметрыКонтроля();
	Если ИмяПараметраКонтроля <> ПараметрыКонтроля.ПараметрыИгнорированияПроверкиККТ Тогда
	
		ЗапрашиватьДанныеСервисаИСМП = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ЗапрашиватьДанныеСервиса();
		
		Если Не ЗапрашиватьДанныеСервисаИСМП Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	ГруппаПараметров = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ОбщегоНазначенияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки(),
		ИмяПараметраКонтроля);
	
	ВыбранныеЗначения = ГруппаПараметров.Исключения.Получить(ВидПродукции);
	
	Если ГруппаПараметров.РежимИсключения Тогда
		
		Если ВыбранныеЗначения = Неопределено Тогда
			Возврат Ложь;
		ИначеЕсли ВыбранныеЗначения.Количество() = 0 Тогда
			Возврат Истина;
		ИначеЕсли Не ЗначениеЗаполнено(ВидОперации) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ВыбранныеЗначения.Получить(ВидОперации) <> Неопределено Тогда
			Возврат Истина;
		Иначе
			
			ПодчиненныеВидыОпераций = ПодчиненныеВидыОпераций();
			РодительскаяОперация    = ПодчиненныеВидыОпераций.Получить(ВидОперации);
			
			Если ВыбранныеЗначения.Получить(РодительскаяОперация) = Неопределено Тогда
				Возврат Ложь;
			Иначе 
				Возврат Истина;
			КонецЕсли;
			
		КонецЕсли;
	
	Иначе
		
		Если ГруппаПараметров.Исключения.Количество() = 0 Тогда
			Возврат Истина;
		ИначеЕсли ВыбранныеЗначения = Неопределено Тогда
			Возврат Ложь;
		ИначеЕсли ВыбранныеЗначения.Количество() = 0 Тогда
			Возврат Истина;
		ИначеЕсли Не ЗначениеЗаполнено(ВидОперации) Тогда
			Возврат Истина;
		КонецЕсли;
		
		Если ВыбранныеЗначения.Получить(ВидОперации) = Неопределено Тогда
			ПодчиненныеВидыОпераций = ПодчиненныеВидыОпераций();
			РодительскаяОперация    = ПодчиненныеВидыОпераций.Получить(ВидОперации);
			Если ВыбранныеЗначения.Получить(РодительскаяОперация) = Неопределено Тогда
				Возврат Ложь;
			Иначе
				Возврат Истина;
			КонецЕсли;
		Иначе
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Виды розничных операций.
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ВидыОперацийИСМП - Виды розничных операций.
Функция ОперацииРозничнойТорговли() Экспорт
	
	ОперацииРозничнойТорговли = Новый Массив();
	
	ОперацииРозничнойТорговли.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"));
	ОперацииРозничнойТорговли.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации"));
	
	Возврат ОперацииРозничнойТорговли;
	
КонецФункции

// Определяет необходимость контроля статусов кодов маркировки для вида операции по товарной группе.
// 
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС  - Вид продукции.
//  ВидОперации  - ПеречислениеСсылка.ВидыОперацийИСМП - Вид операции.
//  ТребуетсяПроверкаСредствамиККТ - Булево  - в зависимости от флага проверяется контроль статусов с учетом или
//   без учета разрешительного режима. Если Ложь, то проверяются исключения, если Истина - контроль всегда.
// 
// Возвращаемое значение:
//  Булево - Контролировать статусы кодов маркировки.
Функция КонтролироватьСтатусыКодовМаркировки(ВидПродукции, ВидОперации, ТребуетсяПроверкаСредствамиККТ = Истина) Экспорт
	
	Если ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ПродукцияПодлежитОбязательнойОнлайнПроверкеПередРозничнойПродажей(
		ВидПродукции, ВидОперации, ТребуетсяПроверкаСредствамиККТ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыКонтроля = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПараметрыКонтроля();
	ГруппаПараметров  = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ОбщегоНазначенияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки(),
		ПараметрыКонтроля.ПараметрыКонтроляСтатусов);
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ЕстьВИсключениях = ОперацияУточненаВНастройкахСканирования(
			ВидПродукции,
			ВидОперации,
			ПараметрыКонтроля.ПараметрыКонтроляСтатусов);
	Иначе

		ЕстьВИсключениях = Истина;
		ВидыПродукции = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
		Для Каждого ВидПродукцииПроверки Из ВидыПродукции Цикл
			Если Не ОперацияУточненаВНастройкахСканирования(
				ВидПродукцииПроверки,
				ВидОперации,
				ПараметрыКонтроля.ПараметрыКонтроляСтатусов) Тогда

				ЕстьВИсключениях = Ложь;
				Прервать;

			КонецЕсли;
		КонецЦикла
		
	КонецЕсли;

	Возврат (ГруппаПараметров.Включено
			И Не ЕстьВИсключениях);

КонецФункции

// Определяет необходимость контроля владельцев кодов маркировки для вида опреации по товарной группе.
// 
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС  - Вид продукции.
//  ВидОперации  - ПеречислениеСсылка.ВидыОперацийИСМП - Вид операции.
// 
// Возвращаемое значение:
//  Булево - Контролировать владельцев кодов маркировки.
Функция КонтролироватьВладельцевКодовМаркировки(ВидПродукции, ВидОперации) Экспорт
	
	ПараметрыКонтроля = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПараметрыКонтроля();
	ГруппаПараметров  = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ОбщегоНазначенияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки(),
		ПараметрыКонтроля.ПараметрыКонтроляВладельцев);
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ЕстьВИсключениях = ОперацияУточненаВНастройкахСканирования(
			ВидПродукции,
			ВидОперации,
			ПараметрыКонтроля.ПараметрыКонтроляВладельцев);
	Иначе

		ЕстьВИсключениях = Истина;
		ВидыПродукции = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
		Для Каждого ВидПродукцииПроверки Из ВидыПродукции Цикл
			Если Не ОперацияУточненаВНастройкахСканирования(
				ВидПродукцииПроверки,
				ВидОперации,
				ПараметрыКонтроля.ПараметрыКонтроляВладельцев) Тогда

				ЕстьВИсключениях = Ложь;
				Прервать;

			КонецЕсли;
		КонецЦикла
		
	КонецЕсли;
	
	Возврат (ГруппаПараметров.Включено
			И Не ЕстьВИсключениях);

КонецФункции

// Определяет необходимость контроля кодов маркировки средствами ККТ для вида опреации по товарной группе.
// 
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС  - Вид продукции.
//  ВидОперации  - ПеречислениеСсылка.ВидыОперацийИСМП - Вид операции.
// 
// Возвращаемое значение:
//  Булево - Контролировать коды маркировки средствами ККТ.
Функция КонтролироватьКодыМаркировкиСредствамиККТ(ВидПродукции, ВидОперации) Экспорт
	
	ПараметрыКонтроля = ПараметрыКонтроля();
	ГруппаПараметров  = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ОбщегоНазначенияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки(),
		ПараметрыКонтроля.ПараметрыИгнорированияПроверкиККТ);
	
	ОперацияУточнена = ОперацияУточненаВНастройкахСканирования(
		ВидПродукции,
		ВидОперации,
		ПараметрыКонтроля.ПараметрыИгнорированияПроверкиККТ);
	
	Возврат (Не ГруппаПараметров.Включено
			Или ГруппаПараметров.Включено
				И Не ОперацияУточнена);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЗначенияКлючами(Данные)

	Для Каждого КлючИЗначение Из Данные Цикл
		Данные[КлючИЗначение.Ключ] = КлючИЗначение.Ключ;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти