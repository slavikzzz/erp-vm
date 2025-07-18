#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду создания параметров поддержания запаса на основании.
//
// Параметры:
//  КомандыСоздатьНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю
Функция ДобавитьКомандуУстановитьПоддержаниеЗапасов(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ТоварныеОграничения)
		И ПравоДоступа("Просмотр", Метаданные.Обработки.НастройкаПоддержанияЗапасов) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.УстановитьПоддержаниеЗапасов";
		КомандаСоздатьНаОсновании.Идентификатор = "УстановитьПоддержаниеЗапасов";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Установить поддержание запасов';
														|en = 'Set inventory level control'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьРасширенноеОбеспечениеПотребностей";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет команду создания параметров поддержания запаса на основании с открытием отдельной формы настройки параметров.
//
// Параметры:
//  КомандыСоздатьНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю
Функция ДобавитьКомандуНастройкаПоддержанияЗапасов(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.НастройкаПоддержанияЗапасов) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.НастройкаПоддержанияЗапасов";
		КомандаСоздатьНаОсновании.Идентификатор = "НастройкаПоддержанияЗапасов";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Настройка поддержания запасов';
														|en = 'Inventory replenishment parameters'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьРасширенноеОбеспечениеПотребностей";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция УстановитьПоддержаниеЗапасовДляДокументаИзмененияАссортимента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеАссортиментаТовары.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(Форматы.Склад, ИзменениеАссортимента.ОбъектПланирования) КАК Склад
		|ПОМЕСТИТЬ ВтТовары
		|ИЗ
		|	Документ.ИзменениеАссортимента КАК ИзменениеАссортимента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеАссортимента.Товары КАК ИзменениеАссортиментаТовары
		|		ПО (ИзменениеАссортиментаТовары.Ссылка = ИзменениеАссортимента.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних КАК Форматы
		|		ПО (Форматы.ФорматМагазина = ИзменениеАссортимента.ОбъектПланирования)
		|ГДЕ
		|	ИзменениеАссортимента.Ссылка = &ДокументИзмененияАссортимента
		|		И ЕСТЬNULL(Форматы.Склад, ИзменениеАссортимента.ОбъектПланирования) ССЫЛКА Справочник.Склады
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВтТовары.Номенклатура КАК Номенклатура,
		|	ВтТовары.Склад КАК Склад
		|ИЗ
		|	ВтТовары КАК ВтТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныеОграничения КАК ТоварныеОграничения
		|		ПО ВтТовары.Номенклатура = ТоварныеОграничения.Номенклатура
		|			И ВтТовары.Склад = ТоварныеОграничения.Склад
		|			И (ТоварныеОграничения.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
		|ГДЕ
		|	ТоварныеОграничения.Склад ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ДокументИзмененияАссортимента", ДокументСсылка);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	Если Выборка.Количество = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючиЗаписей = Новый Массив;
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		КлючЗаписиТовара = РегистрыСведений.ТоварныеОграничения.КлючЗаписиНоменклатуры();
		КлючЗаписиТовара.Номенклатура = Выборка.Номенклатура;
		КлючЗаписиТовара.Склад = Выборка.Склад;
		КлючиЗаписей.Добавить(КлючЗаписиТовара);
	КонецЦикла;
	
	РегистрыСведений.ТоварныеОграничения.ДобавитьПоддержаниеЗапасаМинМакс(КлючиЗаписей);
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли