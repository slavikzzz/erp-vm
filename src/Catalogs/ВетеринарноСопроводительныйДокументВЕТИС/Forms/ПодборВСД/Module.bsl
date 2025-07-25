#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	
	Для каждого ЭлементОбязательногоОтбора Из Параметры.Отбор Цикл
		ОбязательныйОтбор.Добавить(ЭлементОбязательногоОтбора.Значение, ЭлементОбязательногоОтбора.Ключ, Истина);
		Отбор.Вставить(ЭлементОбязательногоОтбора.Ключ, ЭлементОбязательногоОтбора.Значение);
	КонецЦикла;
	Если Параметры.Свойство("ОформлениеБумажногоВСД") Тогда
		Отбор.Вставить("ОформлениеБумажногоВСД", Параметры.ОформлениеБумажногоВСД);
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступныВсеВСД") Тогда
		ЭтотОбъект.Заголовок = НСтр("ru = 'Подбор ВСД';
									|en = 'Подбор ВСД'");
	Иначе
		Отбор.Вставить("Статус", Перечисления.СтатусыВетеринарныхДокументовВЕТИС.Оформлен);
	КонецЕсли;
	
	ПредставлениеОтбораПоСтроке();
	
	ИсключенияВСД.ЗагрузитьЗначения(Параметры.ПодобранныеВДокументСтроки);
	
	Элементы.ДоступныеВСДПометка.Видимость = Параметры.МножественныйВыбор;
	Элементы.ДоступныеВСД.МножественныйВыбор = Параметры.МножественныйВыбор;
	Элементы.ДоступныеВСД.РежимВыделения = ?(Параметры.МножественныйВыбор, РежимВыделенияТаблицы.Множественный, РежимВыделенияТаблицы.Одиночный);
	Элементы.ДоступныеВСДКоличествоВЕТИС.ТолькоПросмотр = Истина;
	
	ЗаполнитьТаблицуДоступныеВСД();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДоступныеВСДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Не Элементы.ДоступныеВСДПометка.Видимость Тогда
		Закрыть(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДоступныеВСД.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныеВСД = Новый Массив;
	Если Элементы.ДоступныеВСДПометка.Видимость Тогда
		ВыбранныеВСД = ПроверитьВозможностьВыбораИВернутьВыбранные();
	ИначеЕсли Элементы.ДоступныеВСД.ТекущиеДанные = Неопределено Тогда
	Иначе
		ВыбранныеВСД.Добавить(Элементы.ДоступныеВСД.ТекущиеДанные.Ссылка);
	КонецЕсли;
	Если ВыбранныеВСД.Количество() Тогда
		Закрыть(ВыбранныеВСД);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПредставлениеОтбораПоСтроке()
	
	СтруктураОтбора = Отбор;
	МассивСтрокОтбора = Новый Массив;
	
	Если СтруктураОтбора.Свойство("ГрузоотправительХозяйствующийСубъект") И СтруктураОтбора.Свойство("ГрузоотправительПредприятие") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузоотправитель:';
										|en = 'Грузоотправитель:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузоотправительХозяйствующийСубъект));
		МассивСтрокОтбора.Добавить(" / ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузоотправительПредприятие));
	ИначеЕсли СтруктураОтбора.Свойство("ГрузоотправительХозяйствующийСубъект") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузоотправитель (хозяйствующий субъект):';
										|en = 'Грузоотправитель (хозяйствующий субъект):'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузоотправительХозяйствующийСубъект));
	ИначеЕсли СтруктураОтбора.Свойство("ГрузоотправительПредприятие") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузоотправитель (предприятие):';
										|en = 'Грузоотправитель (предприятие):'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузоотправительПредприятие));
	КонецЕсли;
	Если МассивСтрокОтбора.Количество() Тогда
		ПредставлениеОтбораПоГрузоотправителю = Новый ФорматированнаяСтрока(МассивСтрокОтбора);
	Иначе
		Элементы.ПредставлениеОтбораПоГрузоотправителю.Видимость = Ложь;
	КонецЕсли;
	МассивСтрокОтбора.Очистить();
		
	Если СтруктураОтбора.Свойство("ГрузополучательХозяйствующийСубъект") И СтруктураОтбора.Свойство("ГрузополучательПредприятие") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузополучатель:';
										|en = 'Грузополучатель:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузополучательХозяйствующийСубъект));
		МассивСтрокОтбора.Добавить(" / ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузополучательПредприятие));
	ИначеЕсли СтруктураОтбора.Свойство("ГрузополучательХозяйствующийСубъект") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузополучатель (хозяйствующий субъект):';
										|en = 'Грузополучатель (хозяйствующий субъект):'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузополучательХозяйствующийСубъект));
	ИначеЕсли СтруктураОтбора.Свойство("ГрузополучательПредприятие") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Грузополучатель (предприятие):';
										|en = 'Грузополучатель (предприятие):'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ГрузополучательПредприятие));
	КонецЕсли;
	Если МассивСтрокОтбора.Количество() Тогда
		ПредставлениеОтбораПоГрузополучателю = Новый ФорматированнаяСтрока(МассивСтрокОтбора);
	Иначе
		Элементы.ПредставлениеОтбораПоГрузополучателю.Видимость = Ложь;
	КонецЕсли;
	МассивСтрокОтбора.Очистить();
	
	Если СтруктураОтбора.Свойство("ПеревозчикХозяйствующийСубъект") И СтруктураОтбора.Свойство("СпособХранения") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Перевозчик:';
										|en = 'Перевозчик:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ПеревозчикХозяйствующийСубъект));
		МассивСтрокОтбора.Добавить(" / ");
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Способ хранения:';
										|en = 'Способ хранения:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.СпособХранения, Ложь));
	ИначеЕсли СтруктураОтбора.Свойство("ПеревозчикХозяйствующийСубъект") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Перевозчик:';
										|en = 'Перевозчик:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ПеревозчикХозяйствующийСубъект));
	ИначеЕсли СтруктураОтбора.Свойство("СпособХранения") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'Способ хранения:';
										|en = 'Способ хранения:'"));
		МассивСтрокОтбора.Добавить(" ");
		МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.СпособХранения, Ложь));
	КонецЕсли;
	Если МассивСтрокОтбора.Количество() Тогда
		ПредставлениеОтбораПоДругимРеквизитам = Новый ФорматированнаяСтрока(МассивСтрокОтбора);
	Иначе
		Элементы.ПредставлениеОтбораПоДругимРеквизитам.Видимость = Ложь;
	КонецЕсли;
	МассивСтрокОтбора.Очистить();

	МассивСтрокОтбора = Новый Массив;
	ТТННеУказан = Ложь;
	Если СтруктураОтбора.Свойство("ТипТТН") Тогда
		Если ЗначениеЗаполнено(СтруктураОтбора.ТипТТН) Тогда
			МассивСтрокОтбора.Добавить(ПредставлениеЗначения(СтруктураОтбора.ТипТТН, Ложь) + ":");
		Иначе
			ТТННеУказан = Истина;
		КонецЕсли;
	КонецЕсли;
	Если СтруктураОтбора.Свойство("СерияТТН") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'серия';
										|en = 'серия'") + " " + СтруктураОтбора.СерияТТН);
	КонецЕсли;
	Если СтруктураОтбора.Свойство("НомерТТН") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = '№';
										|en = '№'") + СтруктураОтбора.НомерТТН);
	КонецЕсли;
	Если СтруктураОтбора.Свойство("ДатаТТН") Тогда
		МассивСтрокОтбора.Добавить(НСтр("ru = 'от';
										|en = 'от'") + " " + Формат(СтруктураОтбора.ДатаТТН, "ДЛФ=D"));
	КонецЕсли;
	Если МассивСтрокОтбора.Количество() Тогда
		Если ТТННеУказан Тогда
			ПредставлениеОтбораПоТТН = Новый ФорматированнаяСтрока(НСтр("ru = 'ТТН не указан';
																		|en = 'ТТН не указан'"));
		Иначе
			ПредставлениеОтбораПоТТН = Новый ФорматированнаяСтрока(СтрСоединить(МассивСтрокОтбора, " "));
		КонецЕсли;
	Иначе
		Элементы.ПредставлениеОтбораПоТТН.Видимость = Ложь;
	КонецЕсли;
	МассивСтрокОтбора.Очистить();
	
	Если СтруктураОтбора.Свойство("ТипТранспорта") Тогда
		МассивСтрокОтбора = Новый Массив;
		Если СтруктураОтбора.Свойство("НомерТранспортногоСредства") Тогда
			МассивСтрокОтбора.Добавить("№ " + СтруктураОтбора.НомерТранспортногоСредства);
		Иначе
			МассивСтрокОтбора.Добавить(НСтр("ru = '№ <не заполнено>';
											|en = '№ <не заполнено>'"));
		КонецЕсли;
		ЭтоАвтомобиль = СтруктураОтбора.ТипТранспорта = ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.Автомобиль");
		Если ЭтоАвтомобиль И СтруктураОтбора.Свойство("НомерАвтомобильногоПрицепа") Тогда
			МассивСтрокОтбора.Добавить(СтрШаблон(НСтр("ru = 'прицеп №%1';
														|en = 'прицеп №%1'"), СтруктураОтбора.НомерАвтомобильногоПрицепа));
		КонецЕсли;
		Если ЭтоАвтомобиль И СтруктураОтбора.Свойство("НомерАвтомобильногоКонтейнера") Тогда
			МассивСтрокОтбора.Добавить(СтрШаблон(НСтр("ru = 'контейнер №%1';
														|en = 'контейнер №%1'"), СтруктураОтбора.НомерАвтомобильногоКонтейнера));
		КонецЕсли;
	КонецЕсли;
	Если МассивСтрокОтбора.Количество() Тогда
		ПредставлениеОтбораПоТранспортномуСредству = СтрШаблон("%1 (%2)", СтруктураОтбора.ТипТранспорта, СтрСоединить(МассивСтрокОтбора, ", "));
	Иначе
		Элементы.ПредставлениеОтбораПоТранспортномуСредству.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеЗначения(Значение, ПолучатьНавигационнуюСсылку = Истина)
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат НСтр("ru = '< пусто >';
					|en = '< пусто >'");
	ИначеЕсли ПолучатьНавигационнуюСсылку Тогда
		Возврат Новый ФорматированнаяСтрока(Строка(Значение),,,, ПолучитьНавигационнуюСсылку(Значение));
	Иначе
		Возврат Строка(Значение);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуДоступныеВСД()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ИсключенияВСД.ВыгрузитьЗначения());
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВСД.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ДоступныеВСДБезТранспортныхСредств
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВСД
	|ГДЕ
	|	НЕ ВСД.Ссылка В (&Ссылка)";
	ШаблонСтрокиОтбораЗапроса = Символы.ПС + Символы.Таб + "И ВСД.ИмяПоляПереопределяемый = &ИмяПоляПереопределяемый";
	Для каждого ЭлементОбязательногоОтбора Из Отбор Цикл
		Если ЭтоПолеТранспорта(ЭлементОбязательногоОтбора.Ключ) Тогда
			Продолжить;
		ИначеЕсли ЭлементОбязательногоОтбора.Ключ = "ОформлениеБумажногоВСД" Тогда
			СтрокаОтбора = Символы.ПС + Символы.Таб + "И ВСД.Идентификатор %ВидСравнения """"";
			СтрокаОтбора = СтрЗаменить(СтрокаОтбора, "%ВидСравнения", ?(ЭлементОбязательногоОтбора.Значение, "=", "<>"));
			ТекстЗапроса = ТекстЗапроса + СтрокаОтбора;
			Продолжить;
		КонецЕсли;
		СтрокаОтбораЗапроса = СтрЗаменить(ШаблонСтрокиОтбораЗапроса, "ИмяПоляПереопределяемый", ЭлементОбязательногоОтбора.Ключ);
		ТекстЗапроса = ТекстЗапроса + СтрокаОтбораЗапроса;
		Запрос.УстановитьПараметр(ЭлементОбязательногоОтбора.Ключ, ЭлементОбязательногоОтбора.Значение);
		Если ЭлементОбязательногоОтбора.Ключ<>"Статус" Тогда
			Элементы["ДоступныеВСД"+ЭлементОбязательногоОтбора.Ключ].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка КАК Ссылка,
	|	МАКСИМУМ(ВетеринарноСопроводительныйДокументВЕТИСМаршрут.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ МаксимальныеНомераСтрокВСДТранспортныхСредств
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Маршрут КАК ВетеринарноСопроводительныйДокументВЕТИСМаршрут
	|ГДЕ
	|	(ВетеринарноСопроводительныйДокументВЕТИСМаршрут.НомерСтроки = 1
	|			ИЛИ ВетеринарноСопроводительныйДокументВЕТИСМаршрут.СПерегрузкой
	|				И ВетеринарноСопроводительныйДокументВЕТИСМаршрут.НомерТранспортногоСредства <> """""""")
	|	И ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка В
	|			(ВЫБРАТЬ
	|				ДоступныеВСДБезТранспортныхСредств.Ссылка
	|			ИЗ
	|				ДоступныеВСДБезТранспортныхСредств КАК ДоступныеВСДБезТранспортныхСредств)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка,
	|	0
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Маршрут КАК ВетеринарноСопроводительныйДокументВЕТИСМаршрут
	|		ПО ВетеринарноСопроводительныйДокументВЕТИС.Ссылка = ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка
	|ГДЕ
	|	ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка В
	|			(ВЫБРАТЬ
	|				ДоступныеВСДБезТранспортныхСредств.Ссылка
	|			ИЗ
	|				ДоступныеВСДБезТранспортныхСредств КАК ДоступныеВСДБезТранспортныхСредств)
	|	И ВетеринарноСопроводительныйДокументВЕТИСМаршрут.Ссылка ЕСТЬ NULL";
	
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВетеринарноСопроводительныйДокументВЕТИС.Ссылка КАК Ссылка,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Продукция КАК Продукция,
	|	ВетеринарноСопроводительныйДокументВЕТИС.КоличествоВЕТИС КАК КоличествоВЕТИС,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ЕдиницаИзмеренияВЕТИС КАК ЕдиницаИзмеренияВЕТИС,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиСтрока КАК СрокГодностиСтрока,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиТочностьЗаполнения КАК СрокГодностиТочностьЗаполнения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиНачалоПериода КАК СрокГодностиНачалоПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СрокГодностиКонецПериода КАК СрокГодностиКонецПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваСтрока КАК ДатаПроизводстваСтрока,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваТочностьЗаполнения КАК ДатаПроизводстваТочностьЗаполнения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваНачалоПериода КАК ДатаПроизводстваНачалоПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаПроизводстваКонецПериода КАК ДатаПроизводстваКонецПериода,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительХозяйствующийСубъект КАК ГрузоотправительХозяйствующийСубъект,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузоотправительПредприятие КАК ГрузоотправительПредприятие,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательХозяйствующийСубъект КАК ГрузополучательХозяйствующийСубъект,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ГрузополучательПредприятие КАК ГрузополучательПредприятие,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ПеревозчикХозяйствующийСубъект КАК ПеревозчикХозяйствующийСубъект,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СпособХранения КАК СпособХранения,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ТипТТН КАК ТипТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.СерияТТН КАК СерияТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.НомерТТН КАК НомерТТН,
	|	ВетеринарноСопроводительныйДокументВЕТИС.ДатаТТН КАК ДатаТТН,
	|	ЕСТЬNULL(ДанныеТранспорта.ТипТранспорта, ЗНАЧЕНИЕ(Перечисление.ТипыТранспортаВЕТИС.ПустаяСсылка)) КАК ТипТранспорта,
	|	ЕСТЬNULL(ДанныеТранспорта.НомерТранспортногоСредства, """") КАК НомерТранспортногоСредства,
	|	ЕСТЬNULL(ДанныеТранспорта.НомерАвтомобильногоПрицепа, """") КАК НомерАвтомобильногоПрицепа,
	|	ЕСТЬNULL(ДанныеТранспорта.НомерАвтомобильногоКонтейнера, """") КАК НомерАвтомобильногоКонтейнера,
	|	ВетеринарноСопроводительныйДокументВЕТИС.Маршрут.(
	|		Предприятие КАК Предприятие,
	|		Адрес КАК Адрес,
	|		ТипТранспорта КАК ТипТранспорта
	|	) КАК Маршрут
	|ИЗ
	|	МаксимальныеНомераСтрокВСДТранспортныхСредств КАК МаксимальныеНомераСтрокВСДТранспортныхСредств
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВетеринарноСопроводительныйДокументВЕТИС
	|		ПО МаксимальныеНомераСтрокВСДТранспортныхСредств.Ссылка = ВетеринарноСопроводительныйДокументВЕТИС.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Маршрут КАК ДанныеТранспорта
	|		ПО МаксимальныеНомераСтрокВСДТранспортныхСредств.Ссылка = ДанныеТранспорта.Ссылка
	|			И МаксимальныеНомераСтрокВСДТранспортныхСредств.НомерСтроки = ДанныеТранспорта.НомерСтроки
	|ГДЕ
	|	ИСТИНА";
	ШаблонСтрокиОтбораЗапроса = Символы.ПС + Символы.Таб + "И ДанныеТранспорта.ИмяПоляПереопределяемый = &ИмяПоляПереопределяемый";
	Для каждого ЭлементОбязательногоОтбора Из Отбор Цикл
		Если ЭтоПолеТранспорта(ЭлементОбязательногоОтбора.Ключ) Тогда
			СтрокаОтбораЗапроса = СтрЗаменить(ШаблонСтрокиОтбораЗапроса, "ИмяПоляПереопределяемый", ЭлементОбязательногоОтбора.Ключ);
			ТекстЗапроса = ТекстЗапроса + СтрокаОтбораЗапроса;
			Запрос.УстановитьПараметр(ЭлементОбязательногоОтбора.Ключ, ЭлементОбязательногоОтбора.Значение);
			Элементы["ДоступныеВСД"+ЭлементОбязательногоОтбора.Ключ].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ ДоступныеВСДБезТранспортныхСредств");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ МаксимальныеНомераСтрокВСДТранспортныхСредств");
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Выборка = Запрос.Выполнить().Выбрать();
	ДоступныеВСД.Очистить();
	Пока Выборка.Следующий() Цикл 
		НоваяСтрокаВСД = ДоступныеВСД.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаВСД,Выборка);
		НоваяСтрокаВСД.СрокГодностиПредставление = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(Выборка.СрокГодностиТочностьЗаполнения,Выборка.СрокГодностиНачалоПериода,Выборка.СрокГодностиКонецПериода,Выборка.СрокГодностиСтрока);
		НоваяСтрокаВСД.ДатаПроизводстваПредставление = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(Выборка.ДатаПроизводстваТочностьЗаполнения,Выборка.ДатаПроизводстваНачалоПериода,Выборка.ДатаПроизводстваКонецПериода,Выборка.ДатаПроизводстваСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВозможностьВыбораИВернутьВыбранные()
	
	ВыбранныеВСД = Новый Массив;
	РеквизитыОтбора = ИнтеграцияВЕТИСКлиентСервер.РеквизитыПодбораВСДВоВходящуюТранспортнуюОперацию();
	ВыбранныеСтроки = ДоступныеВСД.НайтиСтроки(Новый Структура("Пометка",Истина));
	Если ВыбранныеСтроки.Количество() Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыОтбора, ВыбранныеСтроки.Получить(0));
		Для Каждого СтрокаВСД Из ВыбранныеСтроки Цикл
			КоллекцииИдентичны = Истина;
			Для каждого РеквизитОтбора Из РеквизитыОтбора Цикл
				Если РеквизитОтбора.Значение <> СтрокаВСД[РеквизитОтбора.Ключ] Тогда
					КоллекцииИдентичны = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если КоллекцииИдентичны Тогда
				ВыбранныеВСД.Добавить(СтрокаВСД.Ссылка);
			Иначе
				ТекстСообщения = НСтр("ru = 'Различаются ключевые реквизиты ВСД. Выделенные строки должны быть включены в различные входящие транспортные операции.';
										|en = 'Различаются ключевые реквизиты ВСД. Выделенные строки должны быть включены в различные входящие транспортные операции.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				Возврат Новый Массив;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ВыбранныеВСД;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПолеТранспорта(ИмяПоля)
	Возврат СтрНайти("ТипТранспорта,НомерТранспортногоСредства,НомерАвтомобильногоПрицепа,НомерАвтомобильногоКонтейнера", ИмяПоля) <> 0;
КонецФункции

#КонецОбласти